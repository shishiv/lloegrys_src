#!/usr/bin/env python3
"""Process watchdog with analytical crash logging and timestamped output."""

from __future__ import annotations

import argparse
import collections
import logging
import os
import signal
import subprocess
import sys
import threading
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Deque, Iterable, List, Optional


def setup_logging(base_dir: Path) -> tuple[logging.Logger, logging.Logger]:
    """Configure watchdog and child-output loggers."""
    base_dir.mkdir(parents=True, exist_ok=True)
    crash_dir = base_dir / "crashes"
    crash_dir.mkdir(parents=True, exist_ok=True)

    formatter = logging.Formatter(
        "%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    watchdog_logger = logging.getLogger("watchdog")
    watchdog_logger.setLevel(logging.DEBUG)
    watchdog_logger.handlers.clear()

    watchdog_console = logging.StreamHandler(sys.stdout)
    watchdog_console.setLevel(logging.INFO)
    watchdog_console.setFormatter(formatter)

    watchdog_file = logging.FileHandler(base_dir / "watchdog.log", encoding="utf-8")
    watchdog_file.setFormatter(formatter)
    watchdog_logger.addHandler(watchdog_console)
    watchdog_logger.addHandler(watchdog_file)

    output_logger = logging.getLogger("watchdog.child")
    output_logger.propagate = False
    output_logger.setLevel(logging.DEBUG)
    output_logger.handlers.clear()

    output_console = logging.StreamHandler(sys.stdout)
    output_console.setLevel(logging.INFO)
    output_console.setFormatter(logging.Formatter("%(message)s"))

    output_file = logging.FileHandler(base_dir / "server-output.log", encoding="utf-8")
    output_file.setFormatter(formatter)
    output_logger.addHandler(output_console)
    output_logger.addHandler(output_file)

    return watchdog_logger, output_logger


class Watchdog:
    """Encapsulates crash monitoring and restart logic."""

    def __init__(
        self,
        command: List[str],
        working_dir: Optional[Path],
        log_dir: Path,
        restart_delay: float,
        max_restarts: int,
        crash_tail_lines: int,
        restart_on_success: bool,
        label: str,
    ) -> None:
        self.command = command
        self.working_dir = working_dir
        self.restart_delay = restart_delay
        self.max_restarts = max_restarts
        self.crash_tail_lines = crash_tail_lines if crash_tail_lines > 0 else 0
        self.restart_on_success = restart_on_success
        self.label = label
        self.log_dir = log_dir
        self.crash_dir = log_dir / "crashes"
        self.watchdog_logger, self.output_logger = setup_logging(log_dir)
        self._stop_event = threading.Event()
        self._current_process: Optional[subprocess.Popen[str]] = None
        self._lock = threading.Lock()

    def run(self) -> int:
        """Run the watchdog loop until shutdown or restart exhaustion."""
        self._install_signal_handlers()

        restart_attempt = 0
        exit_code = 0

        self.watchdog_logger.info("Starting watchdog for command: %s", " ".join(self.command))
        if self.working_dir:
            self.watchdog_logger.info("Working directory: %s", self.working_dir)
        self.watchdog_logger.info("Logs stored at: %s", self.log_dir)

        while not self._stop_event.is_set():
            start_time = time.time()
            start_iso = datetime.now(timezone.utc).astimezone().isoformat()
            output_buffer: Optional[Deque[str]] = None
            if self.crash_tail_lines:
                output_buffer = collections.deque(maxlen=self.crash_tail_lines)

            try:
                process = subprocess.Popen(
                    self.command,
                    cwd=self.working_dir,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1,
                    encoding="utf-8",
                    errors="replace",
                )
            except FileNotFoundError:
                self.watchdog_logger.error("Command not found: %s", self.command[0])
                return 127
            except Exception as exc:  # pylint: disable=broad-except
                self.watchdog_logger.exception("Failed to launch process: %s", exc)
                return 1

            with self._lock:
                self._current_process = process

            reader = threading.Thread(
                target=self._consume_output,
                args=(process, output_buffer),
                name="watchdog-output",
                daemon=True,
            )
            reader.start()

            self.watchdog_logger.info("Process started (PID %s)", process.pid)

            try:
                exit_code = process.wait()
            except KeyboardInterrupt:
                self.watchdog_logger.info("Interrupt received; stopping watchdog.")
                self.request_stop()
                continue
            finally:
                reader.join(timeout=2)
                with self._lock:
                    self._current_process = None

            runtime = time.time() - start_time
            stop_iso = datetime.now(timezone.utc).astimezone().isoformat()

            if self._stop_event.is_set():
                self.watchdog_logger.info(
                    "Shutdown requested while child (PID %s) exited with %s",
                    process.pid,
                    exit_code,
                )
                break

            if exit_code == 0 and not self.restart_on_success:
                self.watchdog_logger.info(
                    "Process exited cleanly after %.2fs; watchdog will stop.",
                    runtime,
                )
                break

            restart_attempt += 1
            self.watchdog_logger.warning(
                "Process exited with code %s after %.2fs (attempt %s).",
                exit_code,
                runtime,
                restart_attempt,
            )
            self._generate_crash_report(
                restart_attempt,
                exit_code,
                start_iso,
                stop_iso,
                runtime,
                list(output_buffer) if output_buffer is not None else [],
            )

            if self.max_restarts and restart_attempt >= self.max_restarts:
                self.watchdog_logger.error(
                    "Reached maximum restart attempts (%s).",
                    self.max_restarts,
                )
                break

            if self.restart_delay > 0:
                self.watchdog_logger.info(
                    "Waiting %.1fs before restart.",
                    self.restart_delay,
                )
                self._wait_with_cancellation(self.restart_delay)

        return exit_code

    def request_stop(self) -> None:
        """Signal graceful shutdown and terminate the child if needed."""
        self._stop_event.set()
        with self._lock:
            process = self._current_process
        if process and process.poll() is None:
            self.watchdog_logger.info("Terminating child process (PID %s).", process.pid)
            try:
                process.terminate()
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                self.watchdog_logger.warning("Child unresponsive; forcing kill.")
                process.kill()

    def _wait_with_cancellation(self, delay: float) -> None:
        """Sleep with early exit if a stop is requested."""
        deadline = time.time() + delay
        while time.time() < deadline and not self._stop_event.is_set():
            time.sleep(0.2)

    def _consume_output(
        self,
        process: subprocess.Popen[str],
        buffer: Optional[Deque[str]],
    ) -> None:
        """Stream child output into loggers and ring buffer."""
        assert process.stdout is not None
        for raw_line in iter(process.stdout.readline, ""):
            if self._stop_event.is_set() and raw_line == "":
                break
            line = raw_line.rstrip("\r\n")
            if buffer is not None:
                buffer.append(line)
            self.output_logger.info(line)
        process.stdout.close()

    def _generate_crash_report(
        self,
        attempt: int,
        exit_code: int,
        start_time: str,
        stop_time: str,
        runtime: float,
        tail_lines: Iterable[str],
    ) -> None:
        """Persist structured crash information for diagnostics."""
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        file_name = f"{self.label}-crash-{timestamp}-attempt{attempt}.log"
        crash_path = self.crash_dir / file_name

        header = [
            f"Crash Report: {self.label}",
            f"Attempt: {attempt}",
            f"Exit Code: {exit_code}",
            f"Start Time: {start_time}",
            f"Stop Time: {stop_time}",
            f"Runtime (s): {runtime:.2f}",
            f"Command: {' '.join(self.command)}",
            "",
            "Captured Output (most recent first)" if tail_lines else "No output captured.",
            "",
        ]

        try:
            with crash_path.open("w", encoding="utf-8") as crash_file:
                for line in header:
                    crash_file.write(line + os.linesep)
                if tail_lines:
                    for line in tail_lines:
                        crash_file.write(line + os.linesep)
        except OSError as exc:
            self.watchdog_logger.error("Failed to write crash report: %s", exc)
            return

        self.watchdog_logger.info("Crash report saved to %s", crash_path)

    def _install_signal_handlers(self) -> None:
        """Ensure signals trigger graceful shutdown."""
        def _handler(signum: int, _: Optional[object]) -> None:
            self.watchdog_logger.info("Received signal %s; stopping.", signum)
            self.request_stop()

        for sig in (signal.SIGINT, signal.SIGTERM):
            try:
                signal.signal(sig, _handler)
            except ValueError:
                # Signals not supported on this platform (e.g., Windows + SIGTERM in threads)
                pass


def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Watchdog that restarts a process and records analytical crash logs.",
        allow_abbrev=False,
    )
    parser.add_argument(
        "--working-dir",
        type=Path,
        default=None,
        help="Working directory for the supervised process.",
    )
    parser.add_argument(
        "--log-dir",
        type=Path,
        default=Path("logs/watchdog"),
        help="Directory where watchdog logs and crash reports are written.",
    )
    parser.add_argument(
        "--restart-delay",
        type=float,
        default=5.0,
        help="Seconds to wait before restarting after a crash.",
    )
    parser.add_argument(
        "--max-restarts",
        type=int,
        default=0,
        help="Maximum number of restart attempts before giving up (0 = unlimited).",
    )
    parser.add_argument(
        "--crash-tail-lines",
        type=int,
        default=200,
        help="How many recent output lines to include in crash reports (0 = disable).",
    )
    parser.add_argument(
        "--restart-on-success",
        action="store_true",
        help="Restart even when the supervised process exits with code 0.",
    )
    parser.add_argument(
        "--label",
        default="lloegrys",
        help="Short label used in crash report filenames.",
    )
    parser.add_argument(
        "command",
        nargs=argparse.REMAINDER,
        help="Command to supervise (prefix with -- to separate from options).",
    )

    args = parser.parse_args(argv)
    if not args.command:
        parser.error("No command provided. Pass it after --, e.g., watchdog.py -- ./lloegrys")
    if args.command[0] == "--":
        args.command = args.command[1:]
    return args


def main(argv: Optional[List[str]] = None) -> int:
    args = parse_args(argv)
    log_dir = args.log_dir.expanduser()
    working_dir = args.working_dir.expanduser() if args.working_dir else None

    watchdog = Watchdog(
        command=args.command,
        working_dir=working_dir,
        log_dir=log_dir,
        restart_delay=max(0.0, args.restart_delay),
        max_restarts=max(0, args.max_restarts),
        crash_tail_lines=max(0, args.crash_tail_lines),
        restart_on_success=args.restart_on_success,
        label=args.label,
    )

    try:
        return watchdog.run()
    finally:
        watchdog.request_stop()


if __name__ == "__main__":
    sys.exit(main())

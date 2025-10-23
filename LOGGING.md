Lloegrys Server Logging and Crash Diagnostics

Overview

- Adds a lightweight, thread‑safe logger that writes to console and a file.
- Keeps a ring buffer of recent messages; dumps it on crash.
- Installs signal/terminate handlers (Linux) to log stacktraces.

Configuration

- Env `LLOEGRYS_LOG_FILE` (default: `logs/server.log`)
- Env `LLOEGRYS_LOG_LEVEL` one of: `debug`, `info`, `warn`, `error` (default: `info`)

What’s logged

- Startup/shutdown notices still print to console.
- XML parse errors are also written to the log file with `ERROR` level.
- On fatal signals or unhandled exceptions (Linux), a stacktrace is appended to the log and the last ~200 buffered records are dumped.

Notes

- Windows builds don’t include a stacktrace yet; ring buffer dump still occurs.
- Logs directory is created on first run if it does not exist.


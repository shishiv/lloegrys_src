#!/bin/bash
set -euo pipefail

LOG_DIR="${LLOEGRYS_LOG_DIR:-/var/log/lloegrys}"
WORK_DIR="/opt/lloegrys"
BINARY_PATH="${WORK_DIR}/lloegrys"

mkdir -p "${LOG_DIR}" "${WORK_DIR}/logs"

echo "========================================="
echo "Lloegrys Server Startup"
echo "========================================="

echo "Binary: ${BINARY_PATH}"
if [ -x "${BINARY_PATH}" ]; then
    echo "✓ Executable found"
else
    echo "✗ Executable missing or not executable"
fi

echo "Checking config.lua..."
if [ -f "${WORK_DIR}/config.lua" ]; then
    echo "✓ config.lua found"
else
    echo "✗ config.lua not found"
fi

echo "Preparing log directories in ${LOG_DIR}";
if [ -d "${LOG_DIR}/crashes" ]; then
    CRASH_COUNT=$(find "${LOG_DIR}/crashes" -type f -name '*.log' 2>/dev/null | wc -l)
    echo "Existing crash reports: ${CRASH_COUNT}"
else
    mkdir -p "${LOG_DIR}/crashes"
    echo "Created crash report directory"
fi

echo "Starting watchdog..."
exec python3 -u /opt/watchdog.py \
    --working-dir "${WORK_DIR}" \
    --log-dir "${LOG_DIR}" \
    -- "${BINARY_PATH}"

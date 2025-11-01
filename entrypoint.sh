#!/bin/bash
set -e

echo "========================================="
echo "Lloegrys Server Startup Diagnostics"
echo "========================================="
echo ""

echo "1. Binary Check:"
file /opt/lloegrys/lloegrys
echo ""

echo "2. Library Dependencies:"
ldd /opt/lloegrys/lloegrys
echo ""

echo "3. Binary Permissions:"
ls -lah /opt/lloegrys/lloegrys
echo ""

echo "4. Working Directory Contents:"
ls -lah /opt/lloegrys/
echo ""

echo "5. Config File Check:"
if [ -f /opt/lloegrys/config.lua ]; then
    echo "✓ config.lua exists"
    echo ""
    echo "Database Configuration:"
    grep -E "mysql(Host|User|Pass|Database|Port)" /opt/lloegrys/config.lua | sed 's/mysqlPass = .*/mysqlPass = "***HIDDEN***"/'
else
    echo "✗ config.lua NOT FOUND!"
fi
echo ""

echo "6. Environment Variables:"
env | grep -E "(LLOEGRYS|PYTHON|PATH|HOME)" | sort
echo ""

echo "7. Testing binary execution with verbose output (5 seconds):"
echo "Running server to test startup..."
echo "Note: Server will run in watchdog mode below for full operation"
echo ""

# Create log directory to ensure it exists before binary starts
mkdir -p /var/log/lloegrys /opt/lloegrys/logs 2>/dev/null || true

# Run with timeout and capture all output
timeout 5 /opt/lloegrys/lloegrys 2>&1 | tee /tmp/startup_test.log || EXIT_CODE=$?

echo ""
echo "Exit code: ${EXIT_CODE:-0}"
echo ""

if [ -f /tmp/startup_test.log ]; then
    LOG_SIZE=$(wc -l < /tmp/startup_test.log)
    echo "Captured ${LOG_SIZE} lines of stdout/stderr"
    if [ "${LOG_SIZE}" -gt 0 ]; then
        echo "--- Server Startup Output (first 50 lines) ---"
        head -50 /tmp/startup_test.log
        echo "--- End Output ---"
    else
        echo "⚠ No stdout/stderr captured (server logs to files)"
    fi
fi

echo ""
echo "8. Checking for log files created during test:"

# Find ALL log files created in the last minute
echo "All log files created recently:"
find /var/log/lloegrys /opt/lloegrys/logs /opt/lloegrys -type f -name "*.log" -mmin -1 2>/dev/null | while read -r logfile; do
    echo "  Found: $logfile"
    LOG_LINES=$(wc -l < "$logfile" 2>/dev/null || echo "0")
    echo "    Size: $(stat -c%s "$logfile" 2>/dev/null || echo "0") bytes, Lines: ${LOG_LINES}"
    if [ "${LOG_LINES}" -gt 0 ]; then
        echo "    --- Content (first 100 lines) ---"
        head -100 "$logfile"
        echo "    --- End ---"
    fi
done

# Also check for server.log specifically
if [ -f /var/log/lloegrys/server.log ]; then
    echo "✓ Found /var/log/lloegrys/server.log"
else
    echo "✗ No log file at /var/log/lloegrys/server.log"
fi
echo ""

if [ "${EXIT_CODE:-0}" -eq 124 ]; then
    echo "✓ Binary started successfully (timeout as expected)"
elif [ "${EXIT_CODE:-0}" -eq 0 ]; then
    echo "⚠ WARNING: Binary exited cleanly (code 0) - this is unexpected for a server!"
    echo "Possible causes:"
    echo "  - Configuration error (check config.lua)"
    echo "  - Database connection failure"
    echo "  - Port already in use"
    echo "  - Missing data files"
elif [ "${EXIT_CODE:-0}" -eq 139 ]; then
    echo "✗ SEGMENTATION FAULT! Binary crashed with SIGSEGV"
    echo "This indicates a memory access error or missing library"
else
    echo "✗ Binary failed with exit code ${EXIT_CODE}"
fi
echo ""

echo "========================================="
echo "Starting watchdog..."
echo "========================================="
echo ""

# Start server health monitor in background
echo "Starting server health monitor..."
(
    sleep 5
    while true; do
        # Check if server is running
        if pgrep -x lloegrys > /dev/null; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Server process is running (PID: $(pgrep -x lloegrys))"

            # Check if ports are listening
            if command -v ss > /dev/null; then
                PORTS=$(ss -tlnp 2>/dev/null | grep lloegrys || echo "Port info unavailable")
                if [ -n "$PORTS" ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Listening ports: ${PORTS}"
                fi
            fi

            # Check for log files and tail them
            for logfile in /opt/lloegrys/*.log /opt/lloegrys/logs/*.log /var/log/lloegrys/*.log; do
                if [ -f "$logfile" ] && ! pgrep -f "tail -f $logfile" > /dev/null; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Found log file: $logfile"
                    tail -f "$logfile" &
                fi
            done
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✗ Server process NOT running!"
        fi
        sleep 30
    done
) &

exec python3 -u /opt/watchdog.py \
    --working-dir /opt/lloegrys \
    --log-dir /var/log/lloegrys \
    -- /opt/lloegrys/lloegrys

#!/usr/bin/env bash
# Stop the current recording started by rec-start.sh.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f media/raw/.current ] || { echo "no recording running"; exit 1; }
read -r OUT PID START < media/raw/.current
kill -INT "$PID" 2>/dev/null || true
for _ in $(seq 1 20); do kill -0 "$PID" 2>/dev/null || break; sleep 0.5; done
rm -f media/raw/.current
echo "stopped: $OUT ($(( $(date +%s) - START ))s)"

#!/usr/bin/env bash
# Drop a timestamp marker into the current recording's marker file.
# Usage: scripts/mark.sh "Astra routing the LED chain"
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f media/raw/.current ] || { echo "no recording running"; exit 1; }
read -r OUT PID START < media/raw/.current
T=$(( $(date +%s) - START ))
printf '%02d:%02d:%02d\t%s\n' $((T/3600)) $((T%3600/60)) $((T%60)) "${1:-mark}" >> "${OUT%.mov}.markers.tsv"
tail -1 "${OUT%.mov}.markers.tsv"

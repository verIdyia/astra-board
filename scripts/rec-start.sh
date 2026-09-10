#!/usr/bin/env bash
# Start a full-screen recording for this session. Usage: scripts/rec-start.sh <dayNN>
# Writes media/raw/<dayNN>-<timestamp>.mov and media/raw/.current (path + pid).
# Prefers ffmpeg (smaller files); falls back to macOS screencapture.
set -euo pipefail
cd "$(dirname "$0")/.."
DAY="${1:?usage: rec-start.sh dayNN}"
mkdir -p media/raw media/clips
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="media/raw/${DAY}-${STAMP}.mov"
if [ -f media/raw/.current ]; then
  echo "recording already running: $(cat media/raw/.current)"; exit 1
fi
if command -v ffmpeg >/dev/null 2>&1; then
  # device index 1 is usually the main display on macOS; check with: ffmpeg -f avfoundation -list_devices true -i ""
  IDX="${SCREEN_INDEX:-1}"
  nohup ffmpeg -hide_banner -loglevel error -f avfoundation -capture_cursor 1 -framerate 15 -i "${IDX}:none" \
    -vf "scale=1920:-2" -c:v h264_videotoolbox -b:v 4M -pix_fmt yuv420p "$OUT" >media/raw/ffmpeg.log 2>&1 &
  PID=$!
else
  nohup screencapture -v -V 7200 "$OUT" >/dev/null 2>&1 &
  PID=$!
fi
echo "$OUT $PID $(date +%s)" > media/raw/.current
echo "recording -> $OUT (pid $PID)"

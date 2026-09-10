#!/usr/bin/env bash
# Cut a clip for X from a raw recording.
# Usage: scripts/clip.sh media/raw/day03-....mov 00:12:40 15 day03-routing
# -> media/clips/day03-routing.mp4 (H.264, 1920 wide, no audio, ≤ 512 MB fits X)
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="${1:?raw file}"; AT="${2:?start hh:mm:ss}"; LEN="${3:-15}"; NAME="${4:?clip name}"
mkdir -p media/clips
ffmpeg -hide_banner -loglevel error -y -ss "$AT" -t "$LEN" -i "$SRC" \
  -vf "scale=1920:-2,fps=30" -c:v libx264 -crf 20 -pix_fmt yuv420p -an -movflags +faststart \
  "media/clips/${NAME}.mp4"
echo "media/clips/${NAME}.mp4"

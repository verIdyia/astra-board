#!/usr/bin/env bash
# Snapshot the Codex/ChatGPT usage limits (the same numbers /status shows) into log/usage.tsv.
# Usage: scripts/usage.sh "label"    e.g. scripts/usage.sh "start" / "after schematic" / "end"
# Uses the endpoint the Codex CLI itself polls. Unofficial; if it changes, the raw JSON is still saved.
set -euo pipefail
cd "$(dirname "$0")/.."
LABEL="${1:-snapshot}"
AUTH="${CODEX_HOME:-$HOME/.codex}/auth.json"
[ -f "$AUTH" ] || { echo "no auth.json at $AUTH"; exit 1; }
mkdir -p log/usage-raw
STAMP="$(date +%Y%m%d-%H%M%S)"
RAW="log/usage-raw/${STAMP}.json"

python3 - "$AUTH" "$RAW" "$LABEL" "$STAMP" <<'PY'
import json, sys, urllib.request, datetime
auth, raw, label, stamp = sys.argv[1:5]
t = json.load(open(auth))["tokens"]
req = urllib.request.Request(
    "https://chatgpt.com/backend-api/wham/usage",
    headers={"Authorization": f"Bearer {t['access_token']}",
             "ChatGPT-Account-ID": t.get("account_id", ""),
             "User-Agent": "codex-cli"})
try:
    data = json.load(urllib.request.urlopen(req, timeout=20))
except Exception as e:
    print(f"usage fetch failed: {e}"); sys.exit(1)
json.dump(data, open(raw, "w"), indent=1)

# Read only the main account bucket; never mix in other model limits.
windows = {w.get("limit_window_seconds"): w
           for w in (data.get("rate_limit") or {}).values()
           if isinstance(w, dict) and "limit_window_seconds" in w}
def when(v):
    if v is None:
        return "unavailable"
    return datetime.datetime.fromtimestamp(int(v)).strftime("%m-%d %H:%M")
p = windows.get(18000, {})
s = windows.get(604800, {})
p_used = p.get("used_percent", "unavailable"); p_reset = p.get("reset_at")
s_used = s.get("used_percent", "unavailable"); s_reset = s.get("reset_at")
credits = (data.get("rate_limit_reset_credits") or {}).get("available_count", "unavailable")
line = "\t".join(map(str, [stamp, label, p_used, when(p_reset), s_used, when(s_reset), credits]))
import os
hdr = not os.path.exists("log/usage.tsv")
with open("log/usage.tsv", "a") as f:
    if hdr: f.write("time\tlabel\t5h_used%\t5h_resets\tweek_used%\tweek_resets\treset_credits\n")
    f.write(line + "\n")
print(line)
PY

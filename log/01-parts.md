# 01 — Parts preflight — 2026-09-10

## Phase
Parts preparation only. Stopped before selecting or editing design parts.

## What happened
Read the root and project AGENTS.md and BRIEF.md. No existing board or schematic was present. The KiCad MCP responded; its JLCPCB database contains 0 parts. Its UI check matched Node MCP server processes, so it does not establish that a KiCad editor is open.

Required recording was started twice, first in the sandbox and then with approved execution outside it. Both returned a PID but produced no movie. The first PID was confirmed absent. FFmpeg device enumeration showed camera and Desk View camera, but no screen capture device. The script defaults to index 1, which is Desk View on this machine, not a display. Screen Recording permission and subsequent display-device selection need resolution before continuing. No permission-denied text was returned, so the precise cause remains unverified; no workaround was attempted.

Usage tracking was attempted at session start and end. Both failed with DNS resolution errors. Per project instructions, no alternative quota source was used.

## Human interventions
Approved process inspection, recording restart, and capture-device enumeration. Asked to enable/check macOS Screen Recording permission for the application running the shell.

## Verification
- Root-cause follow-up: power logs show the display turned off again at 15:13:46, before the 15:13:53 recording attempt. Keeping user activity and display wake asserted together with `caffeinate -u -d -t 45` restored screen indices 2 and 3. A foreground FFmpeg capture from index 2 exited 0; ffprobe validated `media/raw/recording-diagnostic.mov` as 2.933334 seconds, 1,093,232 bytes. Screen capture permission works in this execution context. The failures involved display sleep and the script's incorrect default index 1, not demonstrated permission denial. The earlier 5-second user-active assertion expired too soon; the later display-only assertion did not keep this setup awake. Long-session recording is still unverified.
- Follow-up correction: the user suggested display sleep. At 15:13:31, `caffeinate -u -t 5` produced a `Display is turned on` power-log event; FFmpeg then enumerated `Capture screen 0` and `Capture screen 1` at indices 2 and 3. Display sleep was confirmed as a factor; the earlier permission diagnosis was premature. A subsequent recording attempt at index 2 still failed with `Invalid device index`, indicating that the transient device list was not stable. Recording remains unverified; no movie was generated.
- ERC errors: not run; no schematic exists.
- DRC errors: not run; no PCB exists.
- Confirmed: project instructions read; MCP responds; parts database empty; no recording movie generated; capture device list lacks a display.
- Commands run: scripts/rec-start.sh run01 (twice), scripts/rec-stop.sh, scripts/usage.sh session-start and session-end, FFmpeg AVFoundation device enumeration.
- Unverified: recording permissions, all parts, all phase gates, hardware operation.

## Scoreboard
DRC N/A / ERC N/A / Astra usage unavailable (DNS failure) / human time not measured.

## Media candidates
No valid recording or markers. Neither attempted recording generated a movie, so there are no clips to recommend.

## Resumed parts phase — 15:18–15:26 KST
Parts gate passed: 19 LCSC entries present in the downloaded catalog and all 19 symbol/footprint pairs exist in KiCad 10.0.6. Evidence: parts/evidence/library-gate.json and jlcpcb-selected.json. 16 SMT BOM lines, 50 placements, seven extended SMT types; reasons and cost estimate in parts/DECISIONS.md. Live checkout stock, datasheet mechanical matching and hardware performance are not established by the existence gate.

MCP downloader timed out at 30 seconds but continued and populated 632,871 records. A CLI fallback failed because system Python lacked pcbnew; no server code was changed. Database success was verified with MCP stats/search. GUI process inspection found no KiCad editor. No design files existed before this phase.

Weekly usage 65% at resumed start and parts gate. Five-hour window absent, confirmed by user. Human input requested: public repo URL for QR; not yet supplied. Recording now grows normally using device 2 with a persistent awake assertion.

Media candidates: media/raw/run01-20260910-151816.mov; 00:01:16 recording and library verification; 00:05:20 parts gate passed. ERC/DRC not run yet.

# astra-board — working rules for the agent

Read `BRIEF.md` first. These rules override general habits.

## What "done" means

- Schematic work is done only when `kicad-cli sch erc --format json` reports **0 errors**. Warnings must be listed with a one-line reason each.
- Layout work is done only when `kicad-cli pcb drc --format json --exit-code-violations` exits with code 0.
- "It looks fine" is not a verification. If you cannot run the check, say the work is unverified.
- Be explicit at the end of every task: what was verified, how, and what remains unverified.

## Tool preference (cheapest first)

1. The `kicad` MCP server tools and `kicad-cli` for anything that touches project files.
2. Python with the KiCad-bundled `pcbnew` only when the MCP server has no tool for it.
3. Computer Use on the KiCad GUI **only** for what cannot be done from files: final visual placement touch-ups the human asks for, and the JLCPCB order flow in the browser. Do not use screenshots to "check" a board; export SVG/STEP with `kicad-cli` instead.

## KiCad file locking

The MCP server edits files directly (SWIG backend, not real-time). **If KiCad has this project open, do not write to its files.** Ask the human to close it first. Opening KiCad while you are mid-edit will corrupt the project.

## Libraries and parts

- Use only symbols/footprints from the KiCad 10 standard libraries or `lib/` in this repo. Never invent a footprint or symbol name; if unsure, search the library first and quote the exact name.
- Every part carries an `LCSC` field with a verified part number, and a `JLC_BASIC` field (`basic` / `extended`).
- Never guess an LCSC number. Verify against the JLCPCB parts DB or jlcpcb.com; otherwise mark `UNVERIFIED`.

## Cost and quota discipline

- Do the smallest step that moves the current phase forward, verify it, then continue. Do not build tooling, wrappers, or abstractions around the flow before the flow works.
- Keep tool outputs small: request specific nets/components rather than dumping whole netlists.
- Do not loop on the same failing fix more than twice. Stop, explain what is failing and what you have tried, and ask.

## Phase discipline

Follow the phases in `BRIEF.md` in order, back to back, without waiting for the human between them. Only two things stop you: the JLCPCB payment page, and a gate that has failed twice. Never submit a payment or place an order yourself.

## Recording (required for every session that touches KiCad, the browser, or hardware)

The screen is recorded so the human can post clips later. This costs no tokens; do it every time.

1. **First thing in the session:** `scripts/rec-start.sh run01` (from the project root). It records the full screen to `media/raw/`. If it says a recording is already running, leave it.
2. **Whenever something clip-worthy is about to happen** (you are about to place parts, route, run the first DRC, upload to JLCPCB, a fix goes wrong): `scripts/mark.sh "short description"`. Markers are cheap; drop many.
3. **Last thing in the session:** `scripts/rec-stop.sh`, then in each phase log list the 2–3 best marker timestamps under "Media candidates".
4. Cut clips only when the human asks: `scripts/clip.sh <raw.mov> <hh:mm:ss> 15 <name>`.

If `rec-start.sh` fails with a permission error, stop and tell the human: the app running this shell needs Screen Recording permission in System Settings → Privacy & Security. Do not try to work around it.

`media/raw/` is not committed to git (large). `media/clips/` is.

## Usage tracking (required)

Run `scripts/usage.sh "<label>"` at session start, after each phase gate passes, and at the end. It appends one line to `log/usage.tsv` (5-hour and weekly used %, reset times) and saves the raw JSON. This is the "what did one shot cost" evidence; do not skip it. If it fails, note the failure in the log and keep going — do not try other ways to read the quota.

## Logging (required at the end of every session)

Write `log/NN-phase.md` per phase using `log/TEMPLATE.md`. Include the ERC/DRC error counts, the usage figures from `log/usage.tsv`, the things that went wrong, and the exact points where the human had to intervene. This log is published; write it plainly.

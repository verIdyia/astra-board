# 02 — Schematic — 2026-09-10 15:26–15:28 KST

## Phase
Schematic completed; moving to layout.

## What happened
Built three hierarchical pages with KiCad MCP batch placement, sourcing properties and global net labels. Native USB maps to GPIO18/19; I2C GPIO4/5; pixels GPIO6; buzzer GPIO7; user buttons GPIO0/1; BOOT GPIO9. GPIO2/8 receive external pull-ups. Expansion carries six remaining GPIOs, 3V3, 5V and two grounds. Last LED output and USB SBU pins are deliberately unconnected.

## Human interventions
No schematic intervention. Repo URL question remains pending for layout QR.

## Verification
- ERC errors: 0; warnings: 0 on the first run.
- DRC: not run yet.
- kicad-cli sch erc --format json generated hw/export/erc-attempt1.json.
- kicad-cli XML netlist export verified 53 physical components: 50 SMT, 3 owner-soldered THT. Every component has LCSC and JLC_BASIC; USB and I2C endpoint checks passed.
- Default KiCad ignored checks are recorded in the JSON; no check was disabled by the agent. In particular footprint-filter checking is a default ignored item, so library existence is checked separately.
- SVG exports of all three pages are in hw/export/schematic/.
- Unverified: rendered-page visual QA, analog stability/thermal behavior, hardware operation. ERC does not prove those.
- MCP created a PCB with 53 footprints and assigned 188 pads; NC/NPTH pads were intentionally unmatched.

## Scoreboard
ERC 0 / DRC not run / weekly usage 65%→66% / 5h absent / human time not measured.

## Media candidates
Raw: media/raw/run01-20260910-151816.mov.
- 00:05:20 — parts gate, before schematic work
- 00:09:22 — first ERC, zero violations

# astra-board — project brief

Read this before doing anything. `AGENTS.md` next to this file has the working rules.

## Why this project exists

The owner is a PCB / embedded firmware engineer (6 years, memory burn-in boards, I2C/SPI device firmware). This month there are many posts claiming GPT-6 Astra can one-shot a PCB. This project tests that claim end to end, honestly, and documents it publicly on X.

The rule of the experiment: **the human does not open the schematic or PCB editor.** The human writes prompts, reviews outputs, approves the JLCPCB payment, and solders the through-hole parts. Everything else is done by Astra through the KiCad MCP server, `kicad-cli`, and (only where unavoidable) Computer Use.

Wins and failures are both published. Do not hide errors, do not paper over an ERC/DRC violation, do not claim something is verified when it is not.

## What we are building

A small dev board that is easy for an AI agent to write firmware for. It will be given away to a few people on X; they should be able to plug it in, point Codex/Claude at this repo, and say "make it do something."

Board concept:

- MCU: ESP32-C3 module (native USB serial/JTAG, WiFi, Arduino / ESP-IDF / MicroPython support, very well represented in training data). If you believe a different part is clearly better for this purpose, say so in `parts/DECISIONS.md` with reasons, but the default is C3.
- Power: USB-C receptacle (16-pin, 5.1 kΩ CC pull-downs), 5 V → 3.3 V LDO rated ≥ 600 mA (WiFi TX peaks), proper decoupling.
- Things that give immediate visible / audible feedback:
  - 8 × addressable RGB LEDs (WS2812B family or compatible), in a row or arc
  - 2 × user tactile buttons, plus BOOT and RESET buttons
  - 1 × passive buzzer with a transistor driver
  - 0.96" I2C OLED (SSD1306, 4-pin module) on a through-hole header — the human solders this
- Expansion: 1 × Qwiic / STEMMA QT connector (JST SH 1.0 mm, 4-pin) on the same I2C bus, and a through-hole header breaking out the remaining GPIOs, 3V3, 5V, GND.
- Silkscreen: board name, pin labels on every header, a QR code pointing at this repo.
- Repo will contain `board.json` (machine-readable pinout) and firmware examples. Example firmware #1: a "quota gauge" that reads a JSON endpoint and shows remaining Astra / Claude usage on the LEDs and OLED.

## Hard constraints

- 2-layer, single-side SMT, JLCPCB Economic PCBA. Board size target ≤ 60 × 40 mm.
- JLCPCB **basic** parts first. Every **extended** part costs a feeder fee; each one must be justified in `parts/DECISIONS.md`. Aim for ≤ 4 extended parts (module, USB-C, Qwiic, LEDs are the likely ones).
- Passives 0603 or larger (hand rework must be possible). No BGA, no QFN with exposed pad unless it is inside the module.
- Through-hole parts (headers, OLED header, buzzer if THT) are **not** assembled by JLCPCB; the human solders them. Keep them few.
- SMT part count ≤ 20 lines in the BOM.
- Design rules: ≥ 0.2 mm trace / 0.2 mm clearance, ≥ 0.2 mm drill, ≥ 0.6 mm via pad (JLCPCB standard capabilities).
- Only use symbols and footprints that actually exist in the KiCad 10 standard libraries or in `lib/` inside this project. Never invent a footprint. If a part needs a footprint that does not exist, say so and stop.
- Every LCSC part number must be verified against the JLCPCB parts database (the MCP server ships `download_jlcpcb.py`) or jlcpcb.com. Never guess an LCSC number. Mark anything you could not verify as UNVERIFIED.

## Phases and gates

Run the phases **back to back in one session** — this is the point of the experiment: can it go start to finish in one day? Each phase has a machine-checkable gate. Pass the gate, write the phase log, move on. Do not wait for the human between phases.

There are exactly **two hard stops** where you wait for the human:

- **Before payment on JLCPCB.** Show the cart total, the assembly preview (part rotations, polarity), and the extended-part count. The human clicks pay. Never submit payment yourself.
- **A gate that fails after two honest attempts.** Stop, write down what is failing and what you tried, and ask. Do not loop.

1. **Parts** → `parts/bom-candidates.csv` (columns: `role, qty, mpn, manufacturer, lcsc, basic_or_extended, unit_price_usd_at_10, stock, kicad_symbol, kicad_footprint, datasheet_url, note`) + `parts/DECISIONS.md` (MCU module choice — compare at least ESP32-C3-MINI-1 vs ESP32-C3-WROOM-02 — LDO, LED package, USB-C receptacle, buzzer + driver, Qwiic connector, button footprint, every extended part and why it earns its feeder fee, estimated PCBA cost for 10 boards). Prefer stock > 1,000. Gate: every LCSC number verified; every symbol/footprint name confirmed to exist.
2. **Schematic** → `hw/astra-board.kicad_sch`. Gate: `kicad-cli sch erc --format json` reports 0 errors; warnings listed with a reason each.
3. **Layout** → `hw/astra-board.kicad_pcb`. Gate: `kicad-cli pcb drc --format json --exit-code-violations` exits 0. Export SVG (both sides) and STEP to `hw/export/` for the human to look at later.
4. **Fab files** → `fab/` (gerbers, drill, POS, BOM/CPL in JLCPCB column format). Gate: files present, BOM lines match the schematic, CPL row count matches SMT part count.
5. **Order** → JLCPCB via browser up to the payment page. **Hard stop.**
6. **Firmware** → `fw/` examples + `board.json` + `fw/AGENTS.md` for the people who receive the board. Gate: the example firmware builds for the chosen module. Hardware test happens when the boards arrive.

Write a log entry per phase (`log/01-parts.md`, `log/02-schematic.md`, … using `log/TEMPLATE.md`). The human will read them afterwards, not during.

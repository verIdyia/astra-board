# Astra Board

ESP32-C3 development board built as a documented AI-assisted PCB experiment.

## Status

Work in progress. KiCad ERC and DRC passed with zero reported violations on 2026-09-10. Fabrication release is pending the repository QR, final manufacturing exports and assembly-preview verification. No hardware has been manufactured or tested.

## Hardware

- 60 × 40 mm, two layers, front-side SMT
- ESP32-C3-WROOM-02, native USB-C, 3.3 V regulator
- Eight addressable RGB LEDs, two user buttons, BOOT and RESET
- Passive buzzer, OLED header, Qwiic connector and GPIO expansion
- 16 SMT BOM lines / 50 assembled components; buzzer and two headers are owner-soldered

Open `hw/astra-board.kicad_pro` with KiCad 10. Local footprint variants are in `lib/Astra.pretty`; the project footprint table resolves them relative to the project.

See `BRIEF.md` for requirements, `parts/DECISIONS.md` for design choices and known limitations, and `log/` for the experiment record. `parts/bom-candidates.csv` records selected parts and sourcing evidence. Firmware and a machine-readable pinout are planned but not yet implemented.

Raw recordings, account responses, intermediate router output and draft manufacturing files are deliberately excluded. This repository is not yet a fabrication release.

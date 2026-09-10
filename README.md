# Astra Board

ESP32-C3 development board built as a documented AI-assisted PCB experiment.

## Status

**Manufacturing paused due to cost (2026-09-10).** The owner reported approximately **US$123 for Standard PCBA** and **US$85 for Economic PCBA** in the 10-board quote discussion, and chose to stop procurement. These are owner-reported figures, not an independently verified complete checkout total; shipping/tax inclusion and complete LED assembly are unconfirmed. No order or payment was submitted.

KiCad ERC and DRC passed with zero reported violations on 2026-09-10. The repository QR is added and independently decoded from the KiCad export. Manufacturing files are in `fab/rev2/`; supplier assembly-preview verification is pending. JLCPCB currently rejects the LED for Economic PCBA; alternative-part eligibility is inconsistent and remains unresolved. The support inquiry is drafted but unsent. Revision 2 includes the electrical-review routing and power-copper repair. USB signal integrity and regulator temperature remain unverified. No hardware has been manufactured or tested.

## Hardware

- 60 × 40 mm, two layers, front-side SMT
- ESP32-C3-WROOM-02, native USB-C, 3.3 V regulator
- Eight addressable RGB LEDs, two user buttons, BOOT and RESET
- Passive buzzer, OLED header, Qwiic connector and GPIO expansion
- 16 SMT BOM lines / 50 assembled components; buzzer and two headers are owner-soldered

Open `hw/astra-board.kicad_pro` with KiCad 10. Local footprint variants are in `lib/Astra.pretty`; the project footprint table resolves them relative to the project.

See `BRIEF.md` for requirements, `parts/DECISIONS.md` for design choices and known limitations, and `log/` for the experiment record. `parts/bom-candidates.csv` records selected parts and sourcing evidence. Firmware and a machine-readable pinout are planned but not yet implemented.

Raw recordings, account responses, intermediate router output and draft manufacturing files are deliberately excluded. This repository is not yet a fabrication release.

# PCB review — 2026-09-10

Scope: read-only review of the current board and selected power/USB connections. No PCB or schematic edits. This is not a full manufacturer footprint audit or hardware qualification.

## Findings

1. **High priority — USB routing needs revision before release.** R14-to-U1 USB_P tracks total 60.91 mm; R15-to-U1 USB_N total 42.04 mm, a difference of 18.87 mm. Each MCU-side net has two vias and uses both copper layers; the connector-side USB_CONN_N has another three vias whereas USB_CONN_P has none. R14/R15 are around x=115 mm while U1 USB pins are x=153.75 mm. These are separate routes, not a consistently parallel differential pair, and the series resistors are far from the MCU. Recommend placing R14/R15 by the MCU and rerouting USB together over continuous ground with controlled differential geometry. Full-speed USB might work, but successful enumeration and compliance cannot be inferred from DRC.

2. **Medium priority — power distribution and local bulk capacitance need improvement.** All explicit +5V tracks are 0.2 mm wide (147.39 mm summed over the entire branched net, NOT one current path). Almost all explicit +3V3 tracks are also 0.2 mm; the regulator has a copper zone but the feed to the module remains narrow. The eight LEDs share 5V with the regulator. C1 is only 100 nF near the module; all three 10 uF output capacitors are near the regulator, with the closest bulk-cap positive pad about 9.36 mm from U1's 3V3 pad. Widen the common supply paths or use suitable pours and add/relocate bulk capacitance at the module supply entry. Exact voltage drop and temperature rise require branch-current and copper-stack assumptions; no failure threshold is claimed from trace width alone.

3. **Medium priority — LDO thermal capacity is not verified.** At the BRIEF's 600 mA load, a 5V-to-3.3V linear regulator dissipates approximately (5-3.3)*0.6 = 1.02 W, excluding quiescent loss. The 1 A nameplate rating does not establish continuous 600 mA operation on this copper area. Verify the selected part's thermal data against the actual copper and ambient conditions, or reduce dissipation. This is a thermal-margin concern, not an observed shutdown.

## Verification

- Standard kicad-cli pcb drc --format json --exit-code-violations: exit 0, zero violations and zero unconnected items, hw/export/drc-review.json. The initial --refill-zones invocation did not produce a report in this environment; therefore no new successful refill is claimed. Current saved board hash exactly matches the already-validated fab/rev1/validation.json board hash.
- kicad-cli sch erc: zero violations, /tmp/astra-review-erc.json.
- Inspected U1, U2, U4, USB-C, USB series resistors and power capacitor pad nets and positions using read-only pcbnew.
- Board and manufacturing revision match. No order was placed. Supplier assembly rotations remain unverified.
- Physical USB performance, RF range, Wi-Fi load transients, thermal performance and assembled QR readability remain unverified.

## Sources

Espressif USB layout guidance calls for parallel equal-length 90 ohm differential routing, few transitions with return vias, continuous reference ground and components near the chip:
https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32c3/pcb-layout-design.html#usb

Power-supply guidance:
https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32c3/schematic-checklist.html

## Session limitations

Recording startup printed success but ffmpeg immediately failed with Invalid device index; no working recording was available. Usage lookup failed because the endpoint hostname could not resolve. No alternative account lookup was attempted. Source files were not changed, and the review was not pushed to GitHub.


## Repair update — 2026-09-10 19:57 KST
The review above describes the old rev1 board. Revised main PCB and fab/rev2 now pass CLI DRC with zero errors, warnings and unconnected items; ERC also has zero violations. USB connector moved to the right edge, module shifted left and series resistors relocated next to MCU pins. MCU-side USB_P/USB_N routing is approximately 2.325/2.408 mm with no vias, versus 60.91/42.04 mm in the reviewed board. Connector-side USB routing was also shortened, but N still has layer transitions whereas P does not. This is a mitigation, not verified matched differential routing or impedance.
Power nets now have explicit 0.6 mm class assignments and wider routing; local neckdowns remain, including two 0.35 mm segments near the USB locating hole. Existing C5 bulk capacitor moved close to the module's supply pin. Front regulator-tab copper was enlarged to approximately 497 mm²; full-load thermal behavior is not established by this area and remains a hardware test requirement. No circuit/BOM additions. Supplier placement and polarity preview still pending.

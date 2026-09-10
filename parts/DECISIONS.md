# Astra board decisions — 2026-09-10

## Constraints and verification
Plan: 60 × 40 mm, two copper layers, front-side SMT only, Economic PCBA. Minimum track/clearance 0.2 mm, drill 0.2 mm (user revision), via diameter 0.6 mm. No invented library items or fine-pitch exposed-pad ICs outside the module. Parts gate evidence is in `evidence/`: 19 verified JLCPCB snapshot entries and existing KiCad 10 library pairs, 16 SMT BOM lines / 50 SMT placements. Live checkout stock and the physical board remain unverified.

## MCU comparison
Choose ESP32-C3-WROOM-02-N4 (C2934560), 4 MB flash, native USB, onboard antenna. The installed standard library contains both its symbol and footprint. JLCPCB snapshot stock 3,702; quantity-10 unit price $2.8942. The catalog erroneously calls the module VFQFN-32-EP; do not use its automatically suggested QFN footprint. The Espressif module datasheet and exact RF_Module footprint determine the package.

ESP32-C3-MINI-1-N4 (C2838502) is smaller (13.2 × 16.6 mm versus WROOM 18 × 20 mm) and snapshot stock is 25,989, but the exact MINI-1 symbol and footprint are absent from installed KiCad 10 standard libraries and this repository. WROOM avoids a custom-library dependency. This keeps the BRIEF's default MCU family. Place the antenna at the board edge and preserve the library antenna keepout on both sides.

Source: https://documentation.espressif.com/esp32-c3-wroom-02_datasheet_en.html

## Power and passives
AMS1117-3.3 C6186 is the available Basic 3.3 V regulator meeting the ≥600 mA rating (1 A nominal). SOT-223 permits a larger thermal copper area than SOT-23 LDOs. At the module's 345 mA TX rating, dissipation is approximately (5−3.3)×0.345 = 0.59 W; rated output current does not establish thermal capability. Provide copper on the output tab and verify temperature on hardware. LED power stays on 5 V.

Use three Basic C7171 10 µF/16 V tantalums in parallel on the output (30 µF nominal, 27 µF at −10%) because AMS1117's compensation calls for tantalum bulk capacitance and the available Basic choice is 10 µF. Avoid assuming arbitrary MLCC-only stability. This trades two placements for avoiding another extended BOM line. Add local 100 nF decoupling. USB input uses 1 µF plus local LED/logic bypassing, rather than a large directly connected VBUS bulk capacitor. RC reset uses 5.1 kΩ and 1 µF.

Consolidate pull-ups and pull-downs to Basic 5.1 kΩ (including independent CC1/CC2 resistors). I2C starts at 100 kHz; receiver hardware will determine allowed bus capacitance. Other resistor values are 1 kΩ for buzzer drive/discharge, 330 Ω LED data, and 22 Ω USB data. All chip R/C parts are 0603 or larger.

## Feedback, connectors and assembly
LEDs: WS2812B-V5/W C2874885, 5050, matching the standard WS2812B pin layout. Eight LEDs in a row; individual bypass capacitors. TI SN74AHCT1G125DBVR C7484 translates 3.3 V data to 5 V with a specified TTL input threshold. Do not rely on a marginal 3.3 V high level into a 5 V pixel. Firmware must start dark and cap brightness; the board does not negotiate USB PD or guarantee full-white LEDs plus WiFi from every host port.

USB-C: HRO TYPE-C-31-M-12 C165948, exact standard footprint, 16 contacts. Its adjacent data-pad clearance is 0.2 mm. Shell anchors are part of the SMT connector's mechanical footprint; confirm their treatment in the PCBA preview. Add ST USBLC6-2SC6 C7519 ESD protection for a board repeatedly plugged into computers.

Qwiic: genuine JST SM04B-SRSS-TB(LF)(SN), C160404, standard horizontal footprint. Pins 1 GND, 2 3V3, 3 SDA, 4 SCL. Buttons: four TS-1088R-02026 C455280 with standard SW_SPST_TS-1088-xR020 footprint; keep one MPN for all four.

Buzzer: passive piezo TDK PS1240P02BT C76871, through-hole; owner solders it. Basic S8050 C2146 low-side driver uses pin 1 base, 2 emitter, 3 collector. A 1 kΩ resistor across the piezo provides discharge during the off half-cycle. This is piezoelectric, not an inductive magnetic buzzer. No active buzzer substitution.

Headers: C124378 1×4 for the off-board SSD1306 OLED, C124372 1×10 expansion, both through-hole and owner-soldered. OLED pin order is GND/3V3/SCL/SDA and must be matched to the supplied module before plugging in. The OLED module itself is a separate owner-supplied assembly, not a JLCPCB placement.

## Every extended SMT line and departure from the target
Seven extended SMT types exceed the BRIEF's **aim** of four, while keeping its hard assembly and 20-line limits:

| Part | Why the feeder fee is justified |
| --- | --- |
| ESP32-C3-WROOM-02-N4 | Required programmable wireless module with native USB |
| HRO USB-C | Required 16-contact USB-C interface |
| JST Qwiic | Required compatible expansion connector |
| WS2812B-V5/W | Required eight addressable RGB pixels |
| TS-1088R switch | Required four tactile buttons with a verified standard footprint; no Basic switch found |
| TI AHCT buffer | Guaranteed LED logic levels across supply and temperature |
| ST USBLC6 | USB ESD protection for the intended giveaway/use case |

THT buzzer and headers are also catalog Extended but incur no PCBA feeder charge because they are excluded from assembly. Every physical schematic part will retain its actual `LCSC` and `JLC_BASIC` field, including THT items.

## Estimate for 10 boards
Using quantity-10 pricing for every selected SMT line gives $5.7528 per board, $57.528 for ten, before attrition (conservative for lines bought in larger quantities). Published Economic setup $8.18, stencil $1.53, extended loading 7×$3.07=$21.49, plus roughly $2–4 placement fees yields approximately $91–93 before bare PCBs, possible anchor/manual processing or module inspection charges, shipping and tax. Budget approximately $110–140 total before shipping/tax and owner-supplied OLEDs; this is an estimate, not a checkout quote. The order page is authoritative.

Pricing source (checked 2026-09-10): https://jlcpcb.com/help/article/pcb-assembly-price

## Process adjustments
User confirmed the 5-hour usage window no longer exists. Keep it unavailable in legacy usage rows and report weekly usage; never substitute the Spark bucket. Screen recording requires an active display (device 2 on this machine), maintained with `caffeinate -u -d`; the original index 1 was a camera. These are workflow corrections, not board-constraint changes.

Public repository URL is pending user input for the required QR code; do not invent or encode a placeholder URL.

## Layout discovery: module thermal drills
The existing KiCad 10 RF_Module:ESP32-C3-WROOM-02 footprint includes twelve 0.2 mm thermal holes, incompatible with the BRIEF's ≥0.3 mm drill rule. Copied that existing footprint into lib/Astra.pretty/ESP32-C3-WROOM-02.kicad_mod and changed only those hole diameters to 0.3 mm; pad sizes (0.6 mm), positions, paste apertures, outline and antenna keepout are preserved. The local library reference is Astra:ESP32-C3-WROOM-02. This is an adaptation of the actual installed footprint, not a guessed land pattern. The MCP pad editor cannot select only the through-hole pads sharing pad number 19 (it would also add a drill to its SMT pad), so KiCad-bundled pcbnew performed this selective modification. The first save helper could not infer the empty library plugin; explicit KiCad S-expression plugin saved it successfully. Confirm drill and annular spacing in DRC; module center-pad wicking/assembly inspection remains part of the JLC preview.

Component references moved from crowded front silkscreen to the fabrication drawing. User-facing labels (headers, buttons, LED indices, board name) will remain on silkscreen. No circuit features were removed.

Local Freerouting 2.4.1 and Temurin JRE 25 were downloaded to /tmp/astra-routing because no working Java runtime/router was installed. KiCad MCP exports/imports DSN/SES; routing runs locally without uploading the design to a third-party routing service.

## Layout gate outcome
Two DRC attempts failed; see log/03-layout.md and hw/export/drc-attempt*.json. The second result has 31 undersized tracks, one thermal-spoke error, two isolated-zone connectivity errors and 14 library-mismatch warnings from relocated silk. Do not fabricate this revision. The new Power class did not propagate into DSN; actual routing remains default-class width, with some unwanted 0.15 mm segments. Further correction requires the user to release the BRIEF's two-failed-gates stop.

## User revision: minimum drill 0.2 mm
The user changed the permitted minimum drill to 0.2 mm after the layout stop. The on-disk BRIEF still read 0.3 mm when reread, so its drill line was synchronized to the user's explicit instruction. Trace width/clearance remain 0.2 mm and via pad diameter remains 0.6 mm. The earlier thermal-hole adaptation was made under the old constraint and is retained above as history; it is no longer necessary to satisfy the revised minimum. No PCB, library geometry or KiCad project setting was changed in this documentation-only update. The existing 0.3 mm holes remain compliant. Latest DRC failures were not drill violations, so this revision alone does not resolve the failed layout gate.

## Resumed layout corrections and current state
User authorized additional work and computer use. The board now references four local standard-library artwork variants (module, USB-C, switches, LEDs) whose silk-to-Fab changes match the placed instances; all 14 mismatch warnings are resolved. Other footprints remain standard. Minimum drill rule is 0.2 mm per revised BRIEF; existing 0.3 mm module holes remain compliant.

KiCad-bundled Python was needed because MCP modify_trace rejected its advertised traceUuid parameter and add_zone was unsupported. Actual saved trace widths now meet 0.2 mm, with one small GND path shift to preserve clearance. The previous 3V3 pour was removed during repair, and its replacement failed to create; current board therefore has seven +3V3 unconnected errors and three dangling-track warnings (drc-attempt4.json). This supersedes the earlier counts. It is NOT ready for fabrication. The two-attempt stop applies again. No DRC errors or warnings were disabled.

## Third authorized repair session
Restored the front 3V3 copper region with solid pad connections and island removal; this reduced seven unconnected reports to two. Added a 0.4 mm back-layer bridge at x=117.5 from y=109.2 to 110.85, with two 0.6 mm vias / 0.3 mm drills, joining the C6 island to the regulator region. Exact track/pad copper-shape checks preceded the edit. KiCad-bundled Python was used for zone configuration, filling and clearance-aware bridge construction, which the available working MCP interfaces do not expose. Keeping the ZONE_FILLER object alive allowed filling and saving without the previous crash.
A second straight back-layer bridge near x=128–129.6 collided with existing copper in both candidate searches and was not saved. Final DRC attempt6 still has one 3V3 island connection error, zero other violations. No checks were relaxed. Next repair should reroute the crossing signal or use a non-straight bridge after user release of the stop.

## Fourth authorized repair session — DRC passed
The user authorized rerouting the remaining island. The front EN trace separated the 3V3 region, while the back BOOT trace blocked a straight 3V3 bridge. Moved the EN segment from x=128.4 to x=129.8, y=107.1584, onto B.Cu using two 0.6 mm vias with 0.3 mm drills; trace width remains 0.2 mm. The initial 1.0 mm via spacing still closed the copper passage; increasing it to 1.4 mm allowed the filled 3V3 region to join. Saved copper was refilled and DRC attempt8 exits 0 with zero violations and zero unconnected items. No rules or severities were relaxed.
The existing Python fallback was used for the precise segment replacement and shape-clearance checks because the working MCP tools do not provide this atomic operation. ERC was rerun and remains zero violations.
Fab files are staged in fab/draft because the repository URL required by the QR requirement has not been supplied. No placeholder QR or invented URL was used. The STEP export exists but the installed library lacks the J1 USB-C 3D model; this limits mechanical visualization, not the footprint or copper checks. Browser access to the JLCPCB quote page succeeds; no design files uploaded and no order placed.

## Public repository and QR
Created the public repository https://github.com/verIdyia/astra-board after user-requested GitHub device authentication. Version control contains selected source files, local libraries, sourcing evidence and curated logs; raw recordings, raw account responses, intermediate router output and draft manufacturing artifacts are excluded.
Added a 37-cell QR including four-cell quiet border at 0.3 mm pitch (11.1 mm square) on back silkscreen. White background spans leave dark soldermask modules; coordinates are mirrored for back-side reading. It points to the real repository, with no URL shortener. Python pcbnew was required because no QR insertion tool is available. The exported KiCad SVG was rasterized and decoded independently with ZXing; exact repository URL matched. DRC with QR: zero violations and unconnected items. Physical printed-code readability awaits hardware.
Generated fab/rev1 with common absolute origin for Gerber, drills and CPL; raw KiCad rotations await supplier preview. Selected default economical green soldermask, white silk, two layers, 1.6 mm FR-4 and tented vias for the quote; no payment authorized to the agent.


## Electrical review repair — 2026-09-10, unverified candidate
User authorized correcting the PCB review and proceeding. Preserve the published board and fab/rev1 while working in ignored hw/rework/: do not replace manufacturing artifacts until the revised layout passes DRC. Existing rev1 passes geometric checks but has the electrical concerns in reviews/2026-09-10-pcb-review.md; it should not be ordered pending this repair.
Moved the USB-C connector to the right edge and the module leftward so the series resistors can sit immediately next to the MCU USB pins. Moved the BOOT switch and nearby passives/header to clear the module antenna and component courtyards. These are placement choices within the BRIEF, not changes to its features, board dimensions, BOM or hard constraints. No new BOM line or feeder fee was added.
Assigned +5V and +3V3 explicitly to a 0.6 mm Power net class; the previous class existed without net assignments. Local 0.45 mm power neckdowns and 0.2 mm signal tracks remain above the minimum. Moved the existing C5 bulk capacitor close to the module supply and enlarged the front 3V3 regulator-tab copper area; the measured candidate filled area is approximately 497 mm². This does not establish regulator thermal qualification: 600 mA at 5 V input dissipates about 1.02 W, and hardware temperature/load testing remains necessary.
MCP exported/imported DSN/SES; local Freerouting generated the changed placement's routes. KiCad-bundled pcbnew then widened undersized segments, configured/fill-saved copper zones and attempted clearance-aware local connections because the relevant advertised MCP modification interfaces are missing or broken. No server code, rule minimum, severity or violation exclusion was changed.
The first complete revised-layout DRC failed (one courtyard overlap, seven dangling-via warnings, three unconnected reports). A later candidate addressed those items but has not passed a complete gate. Two subsequent local USB-ESD routing attempts failed to connect USB_CONN_N after rotating U4; the second removed the two power/ground segments obstructing the rotated signal pads, but the connector route still failed. No complete USB-rotation result was saved. Stop under AGENTS.md's two-failed-fix rule; do not claim matched USB routing or signal-integrity verification. The next approach should reconsider ESD placement and route the USB pair together before surrounding power and signals.


## Resumed USB candidate — two-gate stop
After user authorization, starting routes at exact connector-pad positions resolved the USB search-grid escape failure. Two short 5V neckdowns were reduced to 0.35 mm to maintain the connector NPTH clearance, still above the 0.2 mm hard minimum. J1 ground pads use solid copper connections to avoid a starved thermal and strengthen the shell ground connection. These choices preserve the BRIEF's circuit, BOM, layer count and rule minima.
The resulting candidate has zero DRC errors and zero unconnected items but one hole-to-hole warning: the newly routed ground connection placed a via 0.2 mm from an existing same-net via, overlapping their drills. This was missed because the local search ignored same-net objects. No DRC severity was relaxed. Preserve candidate gate2.kicad_pcb and stop after the two failed gates; fabrication files remain unchanged. Next correction should reuse the existing via, not create an adjacent one.


## Review repair accepted after DRC — 2026-09-10
User authorized the remaining via correction. Removed the duplicate ground via and retained the existing overlapping copper connection; refilled copper passes DRC with zero errors, warnings and unconnected items. Main board/project now contain the repair; silk identifies REV 1.1 and manufacturing package is fab/rev2. Previous fab/rev1 is retained as history and explicitly marked superseded. ERC also remains zero. No hard constraint, BOM line, rule minimum or severity changed.
The larger power copper and shorter USB routes mitigate the review findings, but are not a controlled-impedance or thermal qualification. USB_CONN_N still changes layers while USB_CONN_P remains front-side; do not describe these as a fully matched differential pair. Physical USB and regulator load tests remain necessary. Estimated copper area is not a measured junction-temperature result.


## Supplier LED restriction — 2026-09-10 20:02–20:09 KST
After explicit user approval, accepted the assembly-service terms and uploaded BOM/CPL. All 16 BOM lines matched, but C2874885 LEDs are unchecked and marked Standard Only. Fifteen lines remain selected; do not treat this as a complete 50-part assembly order.
Searched Economic/in-stock alternatives. C55109525 WS2812B-V7 and C52941391 WS2812B-B-V6 both appear under Economic filtering and their JLCPCB part-detail pages say Economic and Standard. Attempting to select either nevertheless produces the Standard PCBA Parts rejection dialog. This inconsistency is unresolved; neither replacement persisted. No sourcing or schematic change was made.
Reviewed the manufacturer WS2812B-B-V6 PDF hosted by LCSC: https://atta.szlcsc.com/upload/public/pdf/source/20251224/2F6ED8FFFF9D3044AED3CCAA3E4BF0D9.pdf . Page 2 preserves 1=VDD,2=DOUT,3=VSS,4=DIN. Its 5050 contact geometry aligns with the existing pad centers; recommended pad height is 1.0 mm versus the existing 0.9 mm. This is preliminary replacement review, not a released footprint change. V7 geometry was not verified. Source pages: https://jlcpcb.com/partdetail/Worldsemi-WS2812B_BV6/C52941391 and https://jlcpcb.com/partdetail/Worldsemi-WS2812BV7/C55109525 .
Preserve Economic as the BRIEF hard constraint; do not silently switch to Standard or omit the LEDs. Two supplier-selection attempts failed, so stop per AGENTS.md and request permission to send the drafted support inquiry in parts/jlcpcb-economic-led-inquiry.md. No inquiry was sent yet. No order or payment occurred.

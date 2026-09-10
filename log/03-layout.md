# 03 — Layout — 2026-09-10 15:28–15:42 KST

## Phase
Layout gate failed twice. Stopped; no fabrication package or order created.

## What happened
Placed 53 footprints on a 60 × 40 mm, two-layer board with SMT on the front. Corrected mechanical placement conflicts with file-based geometry checks. Routed using local Freerouting 2.4.1, then checked the saved result with KiCad CLI. Added rear ground fill and a front 3V3 thermal copper region. Header labels are on the back; buttons, board name and LED indices are on the front. Public-repo QR remains pending the URL.

The standard module footprint had 0.2 mm thermal drills. A documented derivative in lib/Astra.pretty increases the twelve holes to 0.3 mm without changing pad locations/sizes. This fixed the drill constraint; no drill violations remain. No KiCad editor was used.

## Attempts and what failed
1. `kicad-cli pcb drc --format json --exit-code-violations --refill-zones -o hw/export/drc-attempt1.json hw/astra-board.kicad_pcb`: exit 5; 70 errors, 65 warnings, 0 unconnected. Errors: 66 undersized 0.15 mm trace segments, two courtyard overlaps and two copper-edge clearances. Warnings: 30 undersized text, 20 silk overlap, nine silk over copper, six silk-edge clipping.
2. Moved C2/R8/J2 to resolve mechanical/edge issues. Moved problematic body outlines and LED pin-number text to fabrication layer, enlarged actual silk text to 0.8 mm, and repositioned labels. Removed prior routing and rerouted with `--router.automatic_neckdown=false --router.neck_width_um=0`; exported DSN smd_smd clearance also raised from the exporter's 0.05 mm to 0.2 mm. CLI DRC with the same flags, output drc-attempt2.json: exit 5; 32 errors and 14 warnings in violations, plus two unconnected-item errors. Total 34 errors / 14 warnings. Thirty-one trace segments remain 0.15 mm despite the requested router override. One thermal connection at U2 pad 2 has only one required spoke; two disconnected items are islands within the 3V3 zone. All prior placement, edge and silk-size/overlap errors are gone.

The second SES still contained width values 1500 and 2000 in its coordinate scale. Those were printed before import; I should have investigated the remaining 1500 widths instead of assuming the flag had worked. The actual router behavior is not yet explained (fanout or settings precedence are possibilities, not verified causes).

The 14 library-footprint mismatch warnings are D1–D8, SW1–SW4, U1 and J1, whose silk graphics were relocated to F.Fab. They need matching local library variants or another consistent artwork solution. They have not been suppressed.

A requested Power net class was saved in the project, but the MCP warned its in-memory assignment failed; DSN still places all nets in kicad_default. Therefore the intended 0.4 mm power routing was NOT achieved. Do not claim otherwise.

SES import updated disk without refreshing the MCP file-change fingerprint. Subsequent autosaves were refused. Reloaded from disk and reapplied zones/labels; did not force-overwrite the routed file. No server code was modified.

## Human interventions
No layout-editor intervention. Asking for authorization to continue after the two-failure hard stop. Repo URL question remains unanswered.

## Verification
- ERC: final recheck after local footprint reference change, 0 errors / 0 warnings (erc-final.json).
- DRC final: 34 errors including two unconnected-item reports; 14 warnings; exit 5.
- Minimum drill change verified by DRC (no drill violations); minimum trace requirement still fails.
- Front and mirrored back SVGs and STEP successfully exported as review-NOT-FOR-FAB files.
- File-based rendered front silk/mask inspected; no screenshot used as design-rule verification.
- Unverified: QR, impedance/USB pair lengths, thermal/current performance, detailed datasheet mechanical match, successful final DRC, fab consistency, JLC assembly preview, firmware build and hardware.

## Scoreboard
ERC 0 / DRC 34 errors + 14 warnings / weekly usage 66%→68% (resumed session 65%→68%) / 5h absent / human time not measured.

## Media candidates
Raw: media/raw/run01-20260910-151816.mov.
- 00:09:22 — first schematic ERC passed
- 00:17:43 — first routed PCB DRC failed
- 00:21:44 — second DRC and hard stop

## Resumed session — 2026-09-10 15:45–15:54 KST
User authorized continued fixes and computer use. No editor was running. Recording run02 started with a persistent display-awake assertion; weekly usage 68%→70%.

New gate attempt 1 (overall attempt3): 31 track-width errors, two unconnected errors, zero warnings. The earlier claim that MCP widened the tracks was incorrect: the advertised modify_trace parameter traceUuid is rejected by the backend as “Missing trace identifier”; its nested success:false was initially missed. The tool did not change those widths. No server code was changed. The local library mismatches were fixed by generating four artwork variants directly from existing standard library parts, then synchronizing 14 schematic and board references. Two failed SWIG copy attempts were abandoned in favor of loading the known original library footprints. The minimum-hole rule was updated to 0.2 mm; actual existing 0.3 mm drills remain unchanged.

New gate attempt 2 (overall attempt4): seven unconnected errors and three dangling-track warnings, exit 5. Width and clearance errors are now zero; library mismatch warnings are zero. KiCad-bundled Python widened all 31 affected tracks and reread the saved board to verify the minimum width is 0.2 mm. A prospective shape-clearance check found one conflict with a 3V3 via; a 0.035 mm shift of the connected 45-degree/vertical GND segments removed that conflict. No cross-net GND pad/track/via collisions remained in the preflight check, and DRC confirmed no clearance failures.

The remaining seven connectivity errors and three dangling warnings are all on +3V3, around U2 and C4/C5/C6. The earlier large 3V3 pour had two disconnected sections even with solid connections/island removal. It was removed for replacement with a smaller solid thermal region, but the advertised MCP add_zone command returned “Unknown command”. I ran DRC before resolving that command failure, so the replacement zone is absent. The affected traces had previously depended on that pour for connectivity. Next correction must establish explicit 3V3 copper continuity and sufficient LDO thermal copper, verify that it is saved, then run the gate; do not merely suppress these reports.

All four local footprint variants are based on existing standard parts; no pad geometry changed beyond the already documented twelve module drill enlargements. Refreshed BOM footprint references accordingly. Thermal behavior, USB signal integrity, repo QR and manufacturing remain unverified. No fab/order/firmware phase was started.

Human interventions: user permitted this resumed correction round; another two-attempt stop reached. Further fixes await permission. Public repo URL is still missing.

Media candidates: media/raw/run02-20260910-154511.mov.
- 00:03:27 — resumed DRC exposes failed width command
- 00:07:17 — saved widths verified; remaining 3V3 connectivity failure

## Third repair session — 2026-09-10 15:57–16:02 KST
Human intervention: user said “응” to resume the failed layout repair.
Restored the 3V3 zone, directly connected pads, and added one clearance-checked 0.4 mm back-layer bridge with 0.6/0.3 mm vias. Filled copper was saved using a retained pcbnew ZONE_FILLER instance.
Verification: drc-attempt5: 2 unconnected errors, 0 other violations; drc-attempt6: 1 unconnected error, 0 other violations (warnings included). Layout gate still fails; not ready for fabrication. Two straight-bridge candidate searches for the remaining island collided with existing copper. Those failed candidates were not written. Stop retained per AGENTS/BRIEF; remaining connection needs a changed route.
Quota: weekly 70% at start and end; five-hour window unavailable.
Media candidates: run03 00:00:00 repair start; 00:04:12 remaining island and stop. Existing review exports predate this repair and are not fabrication artifacts.

## Fourth repair session — 2026-09-10 16:03 KST
Human intervention: user said “응” to authorize rerouting the last island.
Moved a short EN segment to B.Cu. The initial 1.0 mm via separation left the 3V3 passage closed (attempt7: one unconnected). Increased spacing to 1.4 mm; attempt8 exits 0, zero errors/warnings/unconnected. No rules relaxed. Saved zone fill retained.
ERC rerun: zero violations in erc-final.json. Front/back SVGs and STEP refreshed. Exported SVGs were rendered and inspected for copper continuity, antenna clearance and header label readability. STEP omits J1 because its installed 3D model is absent; mechanical assembly and hardware behavior remain unverified.
The DRC gate passes, but the required repository QR is still pending the actual public URL. Asked user for URL; no placeholder inserted.
Quota at start 70%, DRC pass 71%; five-hour window unavailable.
Media candidates: run04-20260910-160313.mov, 00:00:48 EN crossing change; 00:01:23 DRC passes. Latest exports remain named NOT-FOR-FAB while QR is pending.

## Repository QR completion — 2026-09-10 16:15 KST
Public repository created after user authentication. Added its QR on B.Silkscreen, 11.1 mm square with 0.3 mm cells and quiet border. DRC after the QR: zero violations and zero unconnected. Independent ZXing decode of the actual KiCad SVG raster matched https://github.com/verIdyia/astra-board. Physical scan quality awaits fabricated hardware. Front/back SVG and STEP refreshed; STEP still omits the absent J1 model.
Media: run05 00:01:02 QR insertion; 00:02:10 fabrication validation.


## Electrical review repair — 2026-09-10 19:11–19:30 KST — paused
Human intervention: user authorized fixing the review findings and proceeding directly. No PCB editor was open at the pre-edit check. Work stayed in hw/rework; published PCB and fabrication files were not overwritten.
Moved USB-C, module and USB resistors; shortened the MCU-side P/N traces to approximately 2.325/2.408 mm with no vias. Assigned power nets to the 0.6 mm class, corrected router-generated undersized tracks to at least 0.2 mm, moved the existing module bulk capacitor closer, and increased regulator-tab front copper to approximately 497 mm². This is candidate geometry, not electrical qualification.
First complete gate: kicad-cli pcb drc --format json --exit-code-violations, report hw/rework/drc1.json, failed: one courtyard overlap, seven dangling-via warnings, three unconnected reports. A saved follow-up candidate (rev2-fixed.kicad_pcb) addresses those items; it was not subjected to a second full DRC because USB routing remained unsatisfactory. Native courtyard checks reported zero overlaps for that candidate.
Two local USB-ESD route attempts then failed. First, rotated U4's power/ground connections obstructed signal escape; second, removing the two obstructing segments allowed both ESD pin ties, but the N connection to the connector still could not be routed by the local clearance-aware search. No complete rotated-USB board was saved. Stopped per AGENTS.md: do not loop on the same failing fix more than twice. Proposed next step is a new ESD placement and pair-first routing with surrounding copper rerouted afterwards.
Verification: revised DRC is NOT passed; schematic unchanged and ERC not rerun in this repair (previous published ERC zero). Thermal behavior, USB impedance/length matching, assembled-board operation and JLC placement preview remain unverified. No revised fab exports, uploads, order or payment occurred. Existing fab/rev1 is superseded in intent by the pending electrical repair and should not be ordered.
Quota: weekly 74% to 77%; five-hour window unavailable. Recording stopped normally.
Media candidates: media/raw/run07-20260910-191138.mov.
- 00:08:19 — first complete revised-layout DRC
- 00:18:40 — two local USB route failures and preserved-candidate stop


## Resumed USB repair — 2026-09-10 19:31 KST — two-gate stop
User authorized continuation. Recording run08 started; the PCB editor was not running. Reversed the local search direction to escape from the connector's narrow USB pads at their exact coordinates. This avoided the coarse 0.2 mm search-grid alignment issue and produced a complete saved USB candidate. Routing all narrow-pad connections this way succeeded; previous unsuccessful searches were not evidence that the physical routing was impossible.
First resumed gate, hw/rework/drc-usb1.json: four errors (two NPTH-to-copper clearances, one BUZZ_BASE-to-Q1 clearance, one starved J1 ground thermal), plus one unconnected item; zero warnings. Reduced two short 5V neckdown segments from 0.45 to 0.35 mm to clear the connector locating hole, rerouted the BUZZ_BASE segment, made the connector ground pads solid-connected to the ground pour, and connected the isolated ground region.
Second resumed gate, hw/rework/drc-usb2.json: ZERO errors, ZERO unconnected items, ONE warning, exit 5. Two same-net ground vias at (149.5,109.9375) and (149.5,110.1375) have overlapping 0.3 mm drills. The local search ignored same-net copper obstacles and consequently did not enforce physical drill separation between these vias. No warning was excluded. Stop per BRIEF after two failed gates. Next fix: reuse the existing ground via instead of the new adjacent via, preserving the copper connection, then refill and rerun DRC.
Last candidate: hw/rework/gate2.kicad_pcb. Original PCB and fab/rev1 remain untouched. ERC not rerun because the schematic did not change. USB signal integrity/impedance and thermal operation are unverified; DRC alone cannot verify them. No fabrication update, browser upload, order or payment.
Media candidates: run08-20260910-193144.mov, connector-escape repaired/first DRC and final single-warning stop; exact timestamps are in the adjacent markers TSV. Usage at session start: weekly 77%; five-hour absent. End usage recorded in log/usage.tsv.


## Via repair and layout gate passed — 2026-09-10 19:52–19:54 KST
User authorized continuing. Removed the redundant GND via; its attached copper endpoints are inside the retained 0.6 mm via annulus, so no separate drill is required. Refilling saved copper and running kicad-cli pcb drc --format json --exit-code-violations produced zero violations and zero unconnected items, exit 0. No rule or severity changed.
Promoted the verified candidate to hw/astra-board.kicad_pcb and its power net assignments to the main project; updated silk REV 1.0 to REV 1.1. Reran DRC on the main board with its actual library table: zero violations/unconnected, exit 0. Schematic ERC rerun: zero violations. Reports are in fab/rev2.
Front/back SVGs were exported and inspected. The actual back SVG raster still decodes the exact repository URL with ZXing. STEP exported, but the installed USB-C model remains missing. Electrical/thermal hardware qualification and supplier assembly preview remain unverified. Quota: weekly 77% at start and layout pass, five-hour absent.
Media: run09-20260910-195254.mov, 00:00:22 duplicate-via correction/DRC; later revised Gerber upload.

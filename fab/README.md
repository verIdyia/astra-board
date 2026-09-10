# Fabrication status
Draft only: repository QR URL is pending. Do not manufacture these files.
The board currently passes DRC (hw/export/drc-attempt8.json) and ERC (hw/export/erc-final.json).
draft/ contains Gerbers, separate PTH/NPTH Excellon drills, the drill report, raw KiCad positions, JLCPCB BOM and CPL, and validation.json.
BOM has 16 SMT lines / 50 components; CPL has 50 top-side rows, matched to schematic references. BZ1, J3 and J4 are owner-soldered and excluded.
Gerbers, drills and positions use the same absolute origin; positions use KiCad's Y-up convention. Rotations are raw KiCad angles and must be verified against the JLCPCB assembly preview before release.
Regenerate after adding the QR, rerun DRC, then validate and upload the final package. No draft package has been uploaded.

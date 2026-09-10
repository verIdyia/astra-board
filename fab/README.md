# Fabrication status
`rev1/` is the current package for supplier review. It includes the repository QR, Gerbers, drills, BOM/CPL and machine-check reports. No order has been placed.
DRC and ERC report zero violations. BOM has 16 SMT lines / 50 components, and CPL has 50 top-side rows matching the schematic. BZ1, J3 and J4 are owner-soldered.
All exports use the absolute origin; CPL Y follows KiCad's Y-up convention. Rotations are raw KiCad angles and still require JLCPCB assembly-preview verification. Hardware and thermal performance are unverified.
The STEP preview remains local and omits the absent USB-C 3D model. Draft and intermediate artifacts are excluded from version control.

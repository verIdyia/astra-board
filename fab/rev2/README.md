# Revision 2 manufacturing package — PCB silk REV 1.1

**Procurement paused by the owner due to cost on 2026-09-10.** Preserved for future supplier review; no order/payment submitted. Economic LED eligibility remains unresolved and supplier assembly preview is incomplete. ERC and DRC: zero violations. BOM: 16 lines, 50 SMT components; CPL: 50 front-side placements. Seven extended lines are justified in parts/DECISIONS.md. BZ1/J3/J4 are owner-soldered and excluded.

Gerber ZIP and CPL use the common absolute KiCad coordinate origin; negative CPL Y is intentional. JLCPCB placement rotations/polarity must be reviewed before ordering. STEP visualization in hw/export omits J1 because its installed model is missing.

USB routing was shortened and power routing/thermal copper increased. Controlled differential impedance, USB signal integrity, regulator temperature at load and physical QR scanning remain unverified. See reviews/2026-09-10-pcb-review.md and log/03-layout.md.

# 05 — order access smoke test — 2026-09-10
Opened the actual JLCPCB site and quote page in the Codex in-app browser. Gerber upload control is available. No files uploaded, no cart created, no order placed or payment submitted. Final fabrication files await the repository URL for the mandatory QR. Account login, assembly preview, stock allocation, shipping and payable total remain unverified.

## Supplier quote preparation — 2026-09-10 16:17 KST
Uploaded fab/rev1/astra-board-gerbers.zip. JLCPCB detected 2 layers, 40×60 mm. Set quantity 10, Economic PCBA, top side, 1.6 mm FR-4, green mask, white silk, tented vias and LeadFree HASL. PCBA quantity displays 10. Bare-PCB price displays $5; this is NOT an assembly total or payable cart total.
NEXT is preceded by a prechecked assembly-service Terms and Conditions checkbox. Did not click NEXT. Requested explicit user confirmation of those terms under the computer-use tool's action-time confirmation rule. The site displays Sign In; account authentication may also be needed. BOM/CPL not yet uploaded; no assembly preview, final total, order or payment.

## Google login check — 2026-09-10 16:26 KST
User authorized using Google sign-in if available. Selected JLCPCB Sign In, then Sign in with Google. The current in-app browser has no active Google session: Google displays an empty email/phone login form. Left the login tab visible for the user; no credentials entered. Assembly terms confirmation remains pending. No order/payment submitted. Quote before login displayed $6.20 for bare PCB plus lead-free finish, excluding assembly and shipping.
Recording run06 covers the login navigation only; stopped before user credential entry. Weekly usage 72% at start.


## Chrome revised quote — 2026-09-10 19:57 KST
Chrome quote page shows My Account; login is complete. Previous upload attempt lost its file-chooser event and the automation session reset without uploading. Opened a dedicated Chrome quote tab and used its actual upload control; revised fab/rev2/astra-board-rev2-gerbers.zip uploaded successfully. JLCPCB reports a 2-layer 40x60 mm board. Selected quantity 10, Economic, Top Side, LeadFree HASL; other base options remain standard 1.6 mm FR4, green, white, tented. No BOM/CPL uploaded yet.
The Next button is preceded by an automatically checked agreement to the Terms and Conditions of JLCPCB Assembly Service. Paused before Next under the computer-use tool's action-time agreement confirmation requirement. User's generic continuation messages authorized design repair but did not explicitly accept those terms. Request explicit permission for this agreement, then proceed to BOM/CPL matching and assembly preview. No total assembly price, cart, order or payment is claimed. The live Chrome tab is marked for handoff.
Media: run09, duplicate-via DRC pass and revised Gerber quote. Layout quota 77%; fab gate 78%; five-hour absent.


## Assembly matching — 2026-09-10 20:02–20:09 KST — supplier blocker
User explicitly approved the assembly-service terms. Clicked Next, entered the PCB assembly workflow, uploaded fab/rev2/BOM.csv and CPL.csv, and processed them. The site confirmed 16 matched lines, but automatically excluded the eight C2874885 LEDs per board as Standard Only. All other 15 rows are selected. Did not advance an incomplete assembly.
Two alternatives were investigated and attempted: C55109525 V7 and C52941391 V6. Economic filters and part-detail pages indicate support, but both actual selection attempts show a Standard-only rejection. The quote itself remains Economic, Top Side, qty 10. The V6 PDF pin/land geometry was inspected using the PDF skill with bundled pypdfium2 fallback (Poppler executable absent). A TME PDF fetch was blocked; the exact LCSC-hosted manufacturer PDF succeeded. V7 datasheet was not found and no V7 compatibility claim is made.
No schematic/PCB/BOM substitution was applied. Previous ERC/DRC remain zero; no new circuit checks needed for read-only investigation. BOM/CPL are uploaded, but assembly rotations/polarity, complete supplier allocation and payable total remain unverified. Stop after two failed supplier-selection attempts; draft a support inquiry and request user authorization before sending. Chrome quote tab marked for handoff. No order/payment or outbound support message.
Quota: weekly 78% at session start; end usage in log/usage.tsv. Raw recording run10-20260910-200200.mov. Media: 00:06:51 supplier LED restriction; end marker records stop.

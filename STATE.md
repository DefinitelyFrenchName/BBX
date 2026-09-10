# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-5 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete. This sitting: the re-baseline of bbh to `10a82d2` as a
PROCEDURE (R28 answered and reclassified by the maintainer: R8/R20 applied,
never a queue entry) — measured first by the D20 override, then both fidelity
gates' default, D20, D12's five literals by definition, the dated line in
`docs/rebaselines.md`, the census re-measured (A2 19 → 20), G11 closed as
fixed in bbh. Two findings raised from bbh's own must-fire work: R30 ruled
and built (the gate header is the LEADING COMMENT BLOCK; one reader,
`controls.py`, imported by the readout; `body-is-not-header` control), R29
raised and open (executable controls — the runner drives each declared
control on the gate's real path and requires its own FAIL; recommended for
S6). `bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 19 gates,
56/56 controls. Fidelity F12–F17 diff empty on the plain clone at
`10a82d2`. bbh's tip `447e5d2` (README: the remote renamed BBH-frame-based),
a NOTE. Defaults D1–D32. Gotchas G1–G18.

**In force:** `DECISIONS.md` — R0–R20, R22–R30 and method M1–M4. **Open rulings:** R21 (the platform runs: no Linux or WSL host here). R28 (a re-baseline is a procedure, done), R29 (executable controls: on the page, built in S6) and R30 (the header is the leading comment block, built) answered 2026-09-10.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at
`f675710`; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tree clean |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33` |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1 (`docs/gotchas.md`, G1–G18). The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** slice S3 (the document-set kind, `docs/generality.md`): its plan,
measured, and a STOP for its rulings before any tool; R29 lands in S6 with
the controls registry. The platform run when R21's host exists. bbh's tip
past the baseline follows the R28 procedure when a sitting needs it.

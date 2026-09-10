# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-4 close, 2026-09-10):** slice S2 COMPLETE (its readout in
`docs/readout.md`); slice S1 complete but for the platform run (R21). This
sitting: step 4 on R24 — `lib/py/bbx/provenance.py` (the TOML register,
R11's eight classes, complete both ways, `testimony` and `fixture` named as
not evidence), `gates/provenance.sh`; the readout's suite screen (findings
apart, the register's histogram, the real pairings by file) and the kept
run's untracked count on the tree line (G17's mechanism); D31, D32. bbh
moved to `10a82d2` at the open (G11 fixed in bbh, its four dirty files
committed); both fidelity gates PASS against it by the D20 override; R28
raised to re-baseline. `bin/bbx selftest` GREEN twice at one HEAD (BBX-14
met): 19 gates, 55/55 controls, ~6 min. Fidelity F12 (17), F16 (35), F17
(52) diff empty on the plain clone at `f675710`, beside F13–F15. Defaults
D1–D32. Gotchas G1–G18. In the tree beyond S1: the temporal family, the one
dispatcher, the kinds table, the suite with its kept run, the register tool.
No driver of BBX's own; no fixture subject; no consumer with a register.

**In force:** `DECISIONS.md` — R0–R20, R22–R27 and method M1–M4. **Open rulings:** R21 (the platform runs: no Linux or WSL host here); R28 (re-baseline bbh to `10a82d2`, its tip since bbx-4's open — both fidelity gates PASS against it by the D20 override).
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
| bbh | `f675710` | 190 | fidelity baseline (R8); 4 uncommitted modifications recorded |
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

**Next:** R28 (the re-baseline to `10a82d2`: D12, D20, `docs/rebaselines.md`,
the census row A2, HANDOFF's dirty-files hazard, G11 closed) as bbx-5's first
task if ruled; then slice S3 (the document-set kind, `docs/generality.md`):
its plan, measured, and a STOP for its rulings before any tool. The
platform run when R21's host exists.

# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-11 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 steps 1–5 built** (`docs/plans/S3.md` §8.1–8.5;
R31–R34 answered) — **S3 is laid before the maintainer for the DONE ruling**
(CLAUDE.md §7's six conditions answered one by one in `docs/readout.md`, the
bbx-11 section; the contributor's reading: all six hold for the document-set
kind AS A FIXTURE). Step 5 wrote no tool: the slice readout — comparator
families per kind measured off the kinds tables (document-set 3: exact / set
/ schema; frame-driven 1: temporal), controls declared / fired per gate off
the kept run (the four S3 gates 21 / 21; the plan's design said fourteen),
the fixture register's 16 rows (fixture 15, registry 1), the defaults
D33–D44 by class (principled 6, ruled 2, arbitrary 2, split 2) — and the
first shared-vs-kind-specific FILE CENSUS, `docs/census/bbx_files.md`,
measured at runtime in a shadow tree (37 harness files: 11 executed by both
kinds' gates, 7 + 7 by one kind only, 5 + 3 by one kind and the kernel, 4 by
the kernel only, 0 by no gate; gates K 13 / F 6 / D 4), **measured once, not
gated** — the generator is in the census's §C and the gate is S4's plan to
decide. The plan's §6 screen line corrected in its own commit (X12, BBX-19).
G25: the instrument's first version ended every header (R30) and
`gates/docset_suite.sh` caught it in the shadow (paid 1 shadow gate run).
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 23 gates, 78/78 controls (`build/selftest_20260910T141218Z`, `build/selftest_20260910T142107Z`).
Fidelity F12–F17 diff empty on the plain clone at `10a82d2` (104 pairings;
F13/F14 21). bbh's tip `447e5d2`, a NOTE. Defaults D1–D44. Gotchas G1–G25.
Retractions X1–X12.

**In force:** `DECISIONS.md` — R0–R20, R22–R34 and method M1–M4. **Open
rulings:** R21 (the platform runs: no Linux or WSL host here); R35–R40 (the
S4 plan's, raised bbx-12 while S3's DONE ruling is pending: `docs/plans/S4.md` §10). R31–R34
(the S3 plan's) validated 2026-09-10 — R33 to be reworked only if
experience proves it insufficient, R34 with the TSV caveat and its TOML
revision validated (the frozen rows of the new kinds are TOML-subset
tables, R24's shape).
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `447e5d2`, one past (README), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, 19 ahead at the bbx-8 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16 (`docs/gotchas.md`, G1–G25). The
formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** the maintainer's ruling on S3 DONE (the table in `docs/readout.md`,
bbx-11); then the STOP for S4's plan (R2's third kind, the command-line tool:
the second consumer of `schema` and of the kinds loop; the tolerant-numeric
family; the adapter contract; the file census as a gate — its two "+kernel"
rows, `bin/bbx` executed by one gate and the runners by no document-set gate,
are what S4 must exercise) — written and stopped for rulings before anything
is built (CLAUDE.md §6). The platform run when R21's host exists. bbh's tip
past the baseline follows the R28 procedure when a sitting needs it.

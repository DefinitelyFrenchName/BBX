# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-7 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 step 1 built** (`docs/plans/S3.md` §8.1; R31–R34
answered, R34's TOML revision validated at this open): the `document-set`
kind profile (D33), `[suite].scenario_ext` per kind (D34, R32) read by the
suite loop and the enumeration helper, the fixture generator
`fixture/docset/mkdocset.py` with `--check` and ten named chirality
predicates (D35–D37), the fixture `fixture/docset/` as BBX's second consumer
(the artifact, three documents, three claim sets, nine expectations — every
register row `fixture` — the registry row on the whole-set key), and
`gates/docset_fixture.sh` (3 controls, portable). Built in a shadow tree
first, which caught one defect before the tree saw it. No driver, no
`set`/`schema`/`exact` comparator, no `.truth` kind yet (steps 2–4).
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 20 gates,
59/59 controls. Fidelity F12–F17 diff empty on the plain clone at `10a82d2`
after the loop change (104 pairings). bbh's tip `447e5d2`, a NOTE. Defaults
D1–D37. Gotchas G1–G19.

**In force:** `DECISIONS.md` — R0–R20, R22–R34 and method M1–M4. **Open
rulings:** R21 (the platform runs: no Linux or WSL host here). R31–R34
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
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10
(`docs/gotchas.md`, G1–G19). The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** S3 step 2 (`docs/plans/S3.md` §8.2: `lib/py/bbx/docset.py`, `drivers/docset.sh`,
`gates/docset_driver.sh`; the generator's `--truth`). The platform run when R21's host exists. bbh's
tip past the baseline follows the R28 procedure when a sitting needs it.

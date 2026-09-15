# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-29 close, 2026-09-15):** slices S1 and S2 complete; **S3, S4 and S5 DONE** (S4 and S5 with riders on
BBX-25); **S6 — rot and registers — IN PROGRESS: steps 1 and 2 of six built.** The opening battery at `1cb162e` was
GREEN (PASS 34, controls 179 / 179) and ran while bbh was being committed on the same host (G86). **Step 1**
(`998e0f7`): `docs/defaults.md` corrected and completed under R61 — one table, ids in order, every kind-blind `DEFAULTS`
key named as `[section].key` in its row's default cell, every `${BBX_*:-}` fallback named; D8's claim retracted (X68,
G88); the ten pages HANDOFF reached only through a directory or a brace form routed by path. **R66, raised by step 1 and
ruled the same sitting** (`154b481`): `[project].lib_dir`, read by no line of BBX or of bbh (G87; bbh issue #2), removed
from BBX, and K3 given a third direction, every default's reader. **Step 2** (`f01488e`, `b18678b`): eight pages'
`Shape:` lines reworded first to lead with R62's vocabulary (BBX-19); `bbx defaults --check` (K3, D81) over
`docs/defaults.md`, 82 rows, and `bbx documents --check` (K4, D82) over `docs/documents.toml`, 42 pages in 15 shapes;
`gates/registers.sh`, portable, 28 controls, every finding either check can print planted in a copy; the bbh fidelity
pairs measured identical with the key removed. The gate's controls found three defects before the commit (G89, G90,
G91, the last costing a battery). The census was regenerated (`008db5f`: 51 rows at identity `b9009dc1057c`) and the self
subject refrozen (`858fc45`), and both again after the skills gate fix below (`e9b579f`: 51 rows at identity
`bc53b3b479db`, only the key moved; refreeze `1db186f`). The close's pair is quoted in `docs/readout.md` (CLOSE — bbx-29). **The WSL platform row
stays GREEN at `429d3f8` and attests that commit only; native Linux is a PARTIAL row** at `f6f136d` (the static tier not
run). At the close, G90's list re-anchored BBX-2 and stopped a skills gate control keyed to BBX-2's old status; the control
was re-keyed to a re-anchored rule (`0ee5bfb`, G93). Gotchas G1–G94; retractions X1–X68.

**Open rulings: none.** R0–R66 are answered and recorded in `DECISIONS.md`. The maintainer's words with R49 stand as
a rule of method: discipline is never arbitrated — only the method of applying it, on time or practicality. The
maintainer's caveat on TSV stands the same way (R34, R40, restated at R62): a new register or row file is a TOML-subset
file.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, with BBX ITSELF a
subject and an external test framework a driver — five consumers:
bbh's `example/`, `fixture/docset/`, `fixture/fakecli/`, `fixture/unittest/`,
`fixture/selfgates/` (R14, R15, R37, R38). **BBX's own harness files are
measured by a gate**, not by a document (`docs/census/bbx_files.md`, generated;
R39, D62, D63): regenerated at the bbx-29 close at identity `bc53b3b479db`, 35 gates, 51 rows for
51 harness files, and `bbx file-census --self --check-register` reads no drift. **BBX's own registers are checked every
battery** since bbx-29: `docs/defaults.md` (K3) and `docs/documents.toml` (K4), by `gates/registers.sh`.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `37db3ac`, 15 past with `porcelain=0`, since two commits landed during the bbx-29 opening battery (G86) — a NOTE; its skill carries 87 rules at the baseline and 91 at `e7d6767` (measured bbx-26); every fidelity pair runs on a clone of the baseline, untouched by construction; bbh issue #2 filed at bbx-29 (`[project].lib_dir`, R66) |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills, their lock identical through VampireSaved's own checker and bbh's at bbx-26, and through BBX's since (F18d); 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `59f67c856726` and 87 ahead at the bbx-29 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the first skills lock, `tools/checkskills.py` (168 lines, two renditions per tier, read at bbx-26); the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** 30 rule lines in CLAUDE.md §4. **24 are re-anchored in R53's reading** — the 23 promoted at `24cfb12` and
BBX-2, named by G90 at bbx-29; BBX-2's tag in CLAUDE.md still reads `[inherited VS VSP-19]`, and its promotion is a
CLAUDE.md edit that waits for the maintainer's approval (R16; R55 part (2) gave the form). **6 are still inherited**,
candidates for dropping and never dropped by S5: BBX-3, BBX-4, BBX-11, BBX-13, BBX-17, BBX-27. The relation is derived
every run by `bin/bbx reanchors` (`gates/skills.sh` prints it on the screen) and stated rule by rule in the generated
`docs/rules.md`; it is not copied here, because the hand-kept list this paragraph once carried rotted (X51).

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit); BBX-1's and BBX-20's tags and §3.3's
citation corrected under R55's part (1) (`581eced`); the 23 re-anchored tags promoted under R55's part (2) and R58
(`24cfb12`). Every further edit to `CLAUDE.md` needs maintainer approval
(R16). The counts "304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md (measured 311 / 4,808;
G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down (the bbx-29 opening battery: `coverage: census_recount: rows=300 recountable=244
not_recountable=56`); the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **G91's small fix (R27)**: `gates/registry_complete.sh` refuses a registered gate that is not executable.
(2) **S6 step 3** (`docs/plans/S6.md` §10; R63, R64): K6, references and ids in living pages; K7, the gate index; K8, the
trap lint; F19 as a static fidelity gate. (3) **BBX-2's tag promotion** in CLAUDE.md, for the maintainer's approval.
(4) bbh issue #2, bbh's to answer. **Standing with S4's DONE ruling:** BBX-25's scope and status are gone over again as
F20 lands (S7's row in `docs/slices.md`). **Standing with S5's:** the ledger reader, the skill generator and the
`integers` vocabulary stay BBX's own, never called generic, until a second consumer is in view (`docs/generality.md`);
since bbx-29 the two register checks join them (`gates/registers.sh`, R50). (5) **Named, not queued (bbx-25):** where
the single-kind comparators live (`docs/generality.md`); **G86's candidate:** lineage tips recorded at a run's start and
end. (6) **A full native Linux pair** (with `BBX_BBH_HOME` set) and **a WSL re-run** whenever a platform row should
attest a commit newer than its own (`docs/platforms/README.md`). (7) **G48's sweep, widened by G50, G53, G59, G60, G61,
G67, G71 and G92**: every reader — the contributor's probes included — that may read LESS than is there, asking whether
the shortfall reads as silence. (8) **The candidate ruling G54 names, strengthened by G69 and G74**: BBX's own `docs/`
checked as a document-set subject. For any future harness change, the order that avoids paying twice is in HANDOFF.

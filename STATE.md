# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-30 close, 2026-09-15):** slices S1 and S2 complete; **S3, S4 and S5 DONE** (S4 and S5 with riders on
BBX-25); **S6 — rot and registers — IN PROGRESS: steps 1 to 3 of six built.** The opening battery at `fe37bf0` was
GREEN (PASS 35, controls 207 / 207). **G91's small fix** (`92d7f4f`): `gates/registry_complete.sh` refuses a registered
gate on disk that is not executable. **R67 and R68, raised by step 3's measurement and ruled the same sitting**
(`abe52b2`): K6 reads the pages that state what is true now, counts only rooted tokens as path claims, and moves to step
4 after K5; K7's family file is read by its extension and its two further columns are named by config. The probes behind
them are in `docs/plans/S6_probes/`; G95 records that two counts first read in the working tree carried an ignored file
of this host. **Step 3** (`82fc129`, X71; `9816082`): K8, `bbx demand-after-trap` lifted from bbh with its two deltas and
`gates/trap_lint.sh`; K7, `bbx gate-index` lifted with its three deltas, `gates/families.toml`, `docs/gates.md` generated
and `gates/gate_index.sh`; F19, `gates/fidelity_bbh_s6.sh`, 19 pairs identical; D83–D86; X72, X73. A battery over the
change before its commit read GREEN (PASS 38, controls 218 / 218). The census was regenerated (`d417355`: 53 rows at
identity `016163742714`) and the self subject refrozen (`a2a0208`). The close's pair is quoted in `docs/readout.md`
(CLOSE — bbx-30). bbh was committed twice during the sitting (`833f7a7`, `13ff687`), changing after the baseline the
gate-index preamble default that D85 copies. **The WSL platform row stays GREEN at `429d3f8` and attests that commit
only; native Linux is a PARTIAL row** at `f6f136d` (the static tier not run). Gotchas G1–G97; retractions X1–X73.

**Open rulings: none.** R0–R69 are answered and recorded in `DECISIONS.md`; R69 (K9's containment on a host whose
`mktemp` ignores `TMPDIR`) was raised at bbx-31 by S6 step 4's measurement (G101) and ruled the same sitting. The maintainer's words with R49 stand as
a rule of method: discipline is never arbitrated — only the method of applying it, on time or practicality. The
maintainer's caveat on TSV stands the same way (R34, R40, restated at R62 and applied at R68): a new register or row file
is a TOML-subset file.
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
R39, D62, D63): regenerated at bbx-30 at identity `016163742714`, 38 gates, 53 rows for 53 harness files, and
`bbx file-census --self --check-register` reads no drift. **BBX's own registers are checked every battery** since
bbx-29: `docs/defaults.md` (K3) and `docs/documents.toml` (K4), by `gates/registers.sh`; **its gates are indexed** since
bbx-30: `docs/gates.md`, generated and held current by `gates/gate_index.sh` (K7).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `13ff687`, 17 past with `porcelain=0`: two commits landed during bbx-30 (`833f7a7`, `13ff687`) that change bbh's gate-index preamble default, which a rebaseline past `833f7a7` carries into D85's profile; its skill carries 87 rules at the baseline and 91 at `e7d6767` (measured bbx-26); every fidelity pair runs on a clone of the baseline, untouched by construction; bbh issue #2 filed at bbx-29 (`[project].lib_dir`, R66) |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills, their lock identical through VampireSaved's own checker and bbh's at bbx-26, and through BBX's since (F18d); 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `e4fbb4a1aa42` and 96 ahead at bbx-30's step 3 battery; not re-measured by design) |
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
number to bring down (bbx-30's step 3 battery: `coverage: census_recount: rows=300 recountable=244
not_recountable=56`); the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **G96's small fix (R27)**: `gates/fidelity_bbh_s6.sh` holds D85 — every `[gate_header]` key of bbh's
`DEFAULTS`, on its clone, against what BBX resolves for a config naming no kind. (2) **S6 step 4** (`docs/plans/S6.md`
§10; R64, R65, R67): K5, the rot register, first; K6, references and ids in the pages R67 names, resolved among the
tracked files (G95); K2, the whole-tree control count; K9, a `TMPDIR` per gate. (3) **BBX-2's tag promotion** in
CLAUDE.md, for the maintainer's approval. (4) bbh issue #2, bbh's to answer; and the rebaseline past `833f7a7` whenever
the baseline moves. **Standing with S4's DONE ruling:** BBX-25's scope and status are gone over again as F20 lands (S7's
row in `docs/slices.md`). **Standing with S5's:** the ledger reader, the skill generator and the `integers` vocabulary
stay BBX's own, never called generic, until a second consumer is in view (`docs/generality.md`); the two register checks,
the TOML family register, the two further index columns and the trap lint join them, each declared in its gate (R50).
(5) **Named, not queued (bbx-25):** where the single-kind comparators live (`docs/generality.md`); **G86's candidate:**
lineage tips recorded at a run's start and end. (6) **A full native Linux pair** (with `BBX_BBH_HOME` set) and **a WSL
re-run** whenever a platform row should attest a commit newer than its own (`docs/platforms/README.md`). (7) **G48's
sweep, widened by G50, G53, G59, G60, G61, G67, G71, G92, G95 and G96**: every reader — the contributor's probes
included — that may read LESS or MORE than is there, asking whether the difference reads as silence. (8) **The candidate
ruling G54 names, strengthened by G69 and G74**: BBX's own `docs/` checked as a document-set subject. For any future
harness change, the order that avoids paying twice is in HANDOFF.

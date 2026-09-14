# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-26 close, 2026-09-14):** slices S1 and S2 complete; **S3 DONE**; **S4 DONE** (ruled after the bbx-25
close, with a rider on BBX-25 that F20 meets); **S5 — the skill — IN PROGRESS: planned, ruled, and steps 1 and 2 of
five built.** The plan (`docs/plans/S5.md`, `230ea95`) measured H10 on clones of bbh `10a82d2` and VampireSaved
`0cdd9726`, and BBX's 30 rules against 60 incidents — 23 re-anchored in fact, 7 by none (BBX-2, BBX-3, BBX-4, BBX-11,
BBX-13, BBX-17, BBX-27) — and STOPPED at R51–R57, which the maintainer ruled the same sitting, all as recommended
(R55 on a reworded §3.3 citation: the draft's "from VampireSaved" was found unmeasured before the question was put).
**Step 1** lifted bbh's skills lock and guide generator (`lib/py/bbx/checkskills.py`, `gen_skill_guide.py`, `bin/bbx
check-skills` and `skill-guide`, D64, D65) and made F18 a gate (`gates/fidelity_bbh_s5.sh`: 26 pairs identical over
bbh's skill, bbh's synthetic test consumer, the lock's selftest and VampireSaved's eight skills; red on the pre-lift
code). **Step 2** added R54's two deltas — a definition is ONE line; a per-skill `numbers` vocabulary whose `integers`
are found in the logs as whole tokens, because every two-digit integer occurs as a substring of BBX's own ledgers
(D66) — and `gates/skills.sh` (portable, 16 controls, red on the pre-delta code for exactly its five delta controls);
F18 stayed identical. The battery over each build was GREEN (PASS 33, controls 134 / 134; then PASS 34, controls
150 / 150); the census was regenerated after each (47 rows, no kind lost; identity `1fbb91c0bff1`) and the self
subject refrozen each time. **Corrected on the way, each first and in its own commit:** F18's filed bbh command, which
exits 2 (G62, X49); STATE's gotcha count and its hand-kept re-anchor list, wrong in 6 of 30 entries (X50, X51); three
lineage citations in CLAUDE.md, under R55's approved wording (`581eced`, G65, X52–X54); R43's recorded reason for
declining a config key, an inference that step 1's own F13e run measured false (G68, X55); three current-tense counts
on the platform step-by-step (G69, X56–X58). The opening battery at `f89eec2` was GREEN (PASS 32, controls 133 / 133);
the close's pair is quoted in `docs/readout.md` (CLOSE — bbx-26). **The WSL platform row stays GREEN at `429d3f8` and
attests that commit only; native Linux is a PARTIAL row** at `f6f136d` (the static tier not run). Gotchas G1–G71;
retractions X1–X59. **bbx-27, in progress: S5 step 3 built** — the ledger reader and `gates/skills.sh` §7 (`c17ae40`),
the census regenerated (`b2a7080`), the self subject refrozen (`2446418`); the opening battery at `db5a1ca` was GREEN
(PASS 34, controls 150 / 150) and the battery over the step 3 build GREEN (PASS 34, controls 162 / 162).

**Open rulings: none.** R0–R57 are answered and recorded in `DECISIONS.md`. The maintainer's words with R49 stand as
a rule of method: discipline is never arbitrated — only the method of applying it, on time or practicality.
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
R39, D62, D63): regenerated at bbx-27 after S5 step 3 at identity `da6bb9deb618`, 34 gates, 48 rows for
48 harness files, and `bbx file-census --self --check-register` reads no drift.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `f4094c2`, nine past with `porcelain=0`, at the bbx-26 open (`bbh-drift baseline=10a82d2 tip=f4094c2 ahead=9`) — a NOTE; its skill carries 87 rules at the baseline and 91 at the tip (measured bbx-26); every fidelity pair runs on a clone of the baseline, untouched by construction |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills, their lock identical through VampireSaved's own checker and bbh's at bbx-26, and through BBX's since (F18d); 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `d86e3a46ab5e` and 70 ahead at the bbx-26 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the first skills lock, `tools/checkskills.py` (168 lines, two renditions per tier, read at bbx-26); the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** 29 of the 30 rule lines in CLAUDE.md §4 carry `[inherited …]` and BBX-30 is `[this project]`; none is
promoted yet. **Measured at bbx-26, in R53's reading:** 23 rules are named by at least one gotcha's explicit re-anchor
list and 7 by none (BBX-2, BBX-3, BBX-4, BBX-11, BBX-13, BBX-17, BBX-27). The table, entry by entry, is
`docs/plans/S5.md` §3.2 over G1–G60, re-read over G1–G69 with the same count; it is not copied here, because the
hand-kept list this paragraph used to carry rotted (X51). Since S5 step 3 (bbx-27, `c17ae40`) `bin/bbx reanchors`
derives it every run: `gates/skills.sh` reproduces the plan's table through G60 and prints the whole ledger's reading
on the screen (23 and 7 over G1–G71). Step 4 builds the generated `docs/rules.md`, and R55's part (2) promotes the 23
tags after both.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit); BBX-1's and BBX-20's tags and §3.3's
citation corrected under R55's part (1) (`581eced`). Every further edit to `CLAUDE.md` needs maintainer approval
(R16). The counts "304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md (measured 311 / 4,808;
G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down (the bbx-26 opening battery: `coverage: census_recount: rows=300 recountable=244
not_recountable=56`); the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **S5 step 4** (`docs/plans/S5.md` §5 K2, K3, K6, K7; R51, R52, R56, R57): the skill generator, the
generated `docs/rules.md`, the `[BBH-N]` check in the F18 gate, BBX's skill locked; then step 5 (R55's promotion, the
slice readout). Step 3, the ledger reader, was built at bbx-27 (`c17ae40`). **Standing with S4's DONE ruling:** BBX-25's scope and status are gone over again as F20 lands (S7's
row in `docs/slices.md`). (2) **Named, not queued (bbx-25):** where the single-kind comparators live
(`docs/generality.md`). (3) **A full native Linux pair** (with `BBX_BBH_HOME` set) and **a WSL re-run** whenever a
platform row should attest a commit newer than its own (`docs/platforms/README.md`). (4) **G48's sweep, widened by
G50, G53, G59, G60, G61, G67 and G71**: every reader — the contributor's probes included — that may read LESS than is
there, asking whether the shortfall reads as silence. (5) **The candidate ruling G54 names, strengthened by G69**:
BBX's own `docs/` checked as a document-set subject. For any future harness change, the order that avoids paying
twice is in HANDOFF.

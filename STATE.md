# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-27 close, 2026-09-14):** slices S1 and S2 complete; **S3 DONE**; **S4 DONE** (ruled after the bbx-25
close, with a rider on BBX-25 that F20 meets); **S5 DONE** (built in five steps; ruled after the bbx-27 close on its slice readout in
`docs/readout.md`, with a rider on BBX-25 following S4's precedent); **S6 ruled next**. bbx-26 planned S5 and built steps 1 and 2 (the
lifted lock with F18; R54's two deltas). **Step 3** (`c17ae40`): `bbx reanchors`, R53's reader — every gotcha's explicit
list read, the plan's §3.2 table reproduced through G60 (23 re-anchored, 7 inherited), the whole ledger's reading on
every screen (D67). **Step 4** (`23a10c6`): BBX's skill `skill/bbx/`, generated from CLAUDE.md §4 by `bbx skill-gen` and
locked to the generated `docs/rules.md` — one anchored paragraph per rule, its re-anchoring entries or its tag and "a
candidate for dropping" — its guide current, every `[BBH-N]` resolved against bbh's skill at the baseline (R51, R52,
R56, R57; D68, D69). **Step 5** (`24cfb12`): the 23 re-anchored tags promoted in CLAUDE.md, derived from the reader — 22
as `[re-anchored; inherited …]` under R55's part (2), BBX-30 as `[re-anchored; this project]` under **R58, raised and
ruled this sitting**. **The battery went NOT GREEN once**, on `gates/sweep_runner.sh` §15, a check comparing two clocks
on a 1–2 s margin; feature work halted until it was made a handshake (`b07edbc`, G76). **Corrected first, each in its own
commit:** two stale status lines (`11c6dcd`, G74, X60, X61) and four of this sitting's own lines saying the promotion
awaited an approval R55 had given (`9353ff2`, G77, X62); and one missing BBX-25 declaration, for the `integers` vocabulary, found drafting the slice readout (`c5f1312`, G78). **One cost fell outside the tree:** a load test's cleanup ran
in zsh and left 24 CPU burners up for 1 h 41 min (G75). The census was regenerated and committed three times (48, 49 and 49
rows; identity `5059aa730eb5`), a fourth run superseded before its commit (G78), and the self subject refrozen each time. The close's pair is quoted in `docs/readout.md`
(CLOSE — bbx-27). **The WSL platform row stays GREEN at `429d3f8` and attests that commit only; native Linux is a
PARTIAL row** at `f6f136d` (the static tier not run). Gotchas G1–G81; retractions X1–X63.

**Open rulings: none.** R0–R65 are answered and recorded in `DECISIONS.md`; R59–R65, raised by S6's plan
(`docs/plans/S6.md`, bbx-28), were ruled the same sitting, all as recommended — R62 on its second form, a TOML register,
after the maintainer declined a TSV (R40's caveat, restated). The maintainer's words with R49 stand as
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
R39, D62, D63): regenerated at bbx-27 after the skills gate's anchor fix at identity `5059aa730eb5`, 34 gates, 49 rows for
49 harness files, and `bbx file-census --self --check-register` reads no drift.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `f4094c2`, nine past with `porcelain=0`, at the bbx-26 open (`bbh-drift baseline=10a82d2 tip=f4094c2 ahead=9`) — a NOTE; its skill carries 87 rules at the baseline and 91 at the tip (measured bbx-26); every fidelity pair runs on a clone of the baseline, untouched by construction |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills, their lock identical through VampireSaved's own checker and bbh's at bbx-26, and through BBX's since (F18d); 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `d86e3a46ab5e` and 70 ahead at the bbx-26 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the first skills lock, `tools/checkskills.py` (168 lines, two renditions per tier, read at bbx-26); the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** 30 rule lines in CLAUDE.md §4. **23 are re-anchored in R53's reading and promoted** (`24cfb12`): 22 tags
read `[re-anchored; inherited …]` and BBX-30's `[re-anchored; this project]` (R55 part (2), R58). **7 are still
inherited**, candidates for dropping and never dropped by S5: BBX-2, BBX-3, BBX-4, BBX-11, BBX-13, BBX-17, BBX-27. The
relation is derived every run by `bin/bbx reanchors` (`gates/skills.sh` prints it on the screen) and stated rule by rule
in the generated `docs/rules.md`; it is not copied here, because the hand-kept list this paragraph once carried rotted
(X51).

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit); BBX-1's and BBX-20's tags and §3.3's
citation corrected under R55's part (1) (`581eced`); the 23 re-anchored tags promoted under R55's part (2) and R58
(`24cfb12`). Every further edit to `CLAUDE.md` needs maintainer approval
(R16). The counts "304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md (measured 311 / 4,808;
G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down (the bbx-26 opening battery: `coverage: census_recount: rows=300 recountable=244
not_recountable=56`); the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **S6 step 1** (`docs/plans/S6.md` §10; R59–R65 ruled at bbx-28): the registers' pages first —
`docs/defaults.md` corrected and completed (R61), routing lines for the pages HANDOFF does not name (R62). BBX's skill is installed, a symlink
`~/.claude/skills/bbx` → `skill/bbx` measured after the close (R57). **Standing with S4's DONE ruling:** BBX-25's scope and status are gone over again as F20 lands (S7's
row in `docs/slices.md`). **Standing with S5's:** the ledger reader, the skill generator and the `integers` vocabulary
stay BBX's own, never called generic, until a second consumer is in view (`docs/generality.md`). (2) **Named, not queued (bbx-25):** where the single-kind comparators live
(`docs/generality.md`). (3) **A full native Linux pair** (with `BBX_BBH_HOME` set) and **a WSL re-run** whenever a
platform row should attest a commit newer than its own (`docs/platforms/README.md`). (4) **G48's sweep, widened by
G50, G53, G59, G60, G61, G67 and G71**: every reader — the contributor's probes included — that may read LESS than is
there, asking whether the shortfall reads as silence. (5) **The candidate ruling G54 names, strengthened by G69 and G74**:
BBX's own `docs/` checked as a document-set subject. For any future harness change, the order that avoids paying
twice is in HANDOFF.

# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-28 close, 2026-09-14):** slices S1 and S2 complete; **S3, S4 and S5 DONE** (S4 and S5 with riders on
BBX-25); **S6 — rot and registers — IN PROGRESS: planned and ruled, no step built.** The opening battery at `35faa56`
was GREEN (PASS 34, controls 179 / 179, no `census-drift` NOTE). The plan (`docs/plans/S6.md`, `e95be35`) measured
bbh's five hygiene sub-commands at `10a82d2` and the executable controls at its tip `e7d6767`, VampireSaved's rot classes
and documents register at `0cdd9726`, SMS at `ecc5481`, and BBX's own controls, defaults, documents, prose references and
gate headers at `35faa56`, every count from a probe kept in `docs/plans/S6_probes/`; it STOPPED at R59–R65, which the
maintainer ruled the same sitting (`c106028`), all as recommended — R62 on its second form: a TSV register was declined
in the maintainer's words (R34's and R40's caveat, restated) and `docs/documents.toml` ruled, with R64 put as
`docs/rot.toml`. **Corrected first, in their own commit** (`4376831`): F19's row (X64), `docs/controls.md` on what the
screen says (X65), and the count of VampireSaved's §7 decisions in the census and bins (X66); G37's description of R29 as
built retracted in the register (X67). **G80's temporary directories attributed (G82):** bbh's fake driver never removes
the sandbox it makes when none is named, 594 per battery through three of BBX's static gates; the maintainer deleted the
40,312 attributed directories after a listing proven on a synthetic root, and a listing afterwards read 0. Two probes'
controls could not reach their population and were caught before use (G83, G84); two of the maintainer's standing words
were not applied when the plan and its questions were drafted (G85). No harness file changed this sitting: the census
identity `5059aa730eb5` and the self subject stand. The close's pair is quoted in `docs/readout.md` (CLOSE — bbx-28).
**The WSL platform row stays GREEN at `429d3f8` and attests that commit only; native Linux is a PARTIAL row** at
`f6f136d` (the static tier not run). Gotchas G1–G85; retractions X1–X67.

**Open rulings: none.** R0–R65 are answered and recorded in `DECISIONS.md`. The maintainer's words with R49 stand as
a rule of method: discipline is never arbitrated — only the method of applying it, on time or practicality. The maintainer's caveat on TSV stands the same way (R34, R40, restated at R62): a new
register or row file is a TOML-subset file.
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
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `e7d6767`, 13 past with `porcelain=0`, at the bbx-28 open (`bbh-drift baseline=10a82d2 tip=e7d6767 ahead=13`) — a NOTE; its skill carries 87 rules at the baseline and 91 at the tip (measured bbx-26); every fidelity pair runs on a clone of the baseline, untouched by construction |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills, their lock identical through VampireSaved's own checker and bbh's at bbx-26, and through BBX's since (F18d); 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `cb1ca29d3f8f` and 79 ahead at the bbx-28 open; not re-measured by design) |
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

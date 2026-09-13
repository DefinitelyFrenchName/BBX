# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-22 close, 2026-09-13):** slices S1 and S2 complete; **S3 DONE**;
**S4's BUILD IS COMPLETE — only step 7, the slice readout, remains.** One subject,
in the order the maintainer set: **R48 answered and built — a correct SKIP can now
be green, and `--strict` still refuses every skip, with no exception of any shape**
(the maintainer's addition: an exemption under `--strict` is a ruling, never a
change). A gate the classifier calls SKIP gets `verdict=SKIPPED`; only
declared-and-not-fired is set aside, and the runner and the readout count and name
what was set aside. On the real gate that reddened WSL (`census_recount` alone, its
census pointed at an absent tree) the fix reads GREEN where it read NOT GREEN, and
NOT GREEN again under `--strict`. **Building it found G48:** a controls reader that
CRASHED was read as `red: 0` and GREEN, and the readout of such a run said `each can
fail: 31 of 31`. Fixed in the same block — the verdict rests on the reader's output,
one line per gate that ran, never on its exit. Four new must-fire controls in
`gates/controls.sh`, each measured DEAD on a regression and FIRED on the fix; bbh
fidelity unchanged. **R21 ANSWERED after the close** (maintainer, 2026-09-13):
platform runs are the maintainer's, brought back as a kept pair and committed keyed by
commit; a platform reads green only on such a pair at a commit whose macOS battery is
green; SSH or basic automation is a later decision that depends on how often runs are
needed. **The WSL platform row is GREEN:** the kept pair at `429d3f8` (the
macOS close pair's commit) reads GREEN twice with `census_recount` SKIPPED and BBX-14
met, every other gate verdict and every NOTE value equal to macOS, on Linux x86_64 —
a second OS and a second CPU architecture. Five kept WSL runs are committed
byte-identical under `docs/platforms/wsl/runs/`. Reading them here found G50: the
readout of another host's run counts every gate header it cannot find as a gate
declaring no blind spot (31 where the truth is 0) — the next sitting's first small fix. The opening
battery and the close's pair are quoted in `docs/readout.md` (bbx-22, and CLOSE —
bbx-22). Gotchas G1–G50; retractions X1–X41. G49: a WSL re-run met the pre-fix tree
because the fix was not yet pushed when it was asked for; `429d3f8` was pushed before
the close commit, and the platform procedure now carries a tree check.

**Open rulings, two:** R44's BUILD (the
ruling is answered; the printed-refreeze step is not yet written, and it joins R46's
one-definition work because both touch the single identity key), and R45 (rescoped
to three directions over three registries, with the tier-listing fix measured and
ruled out). Each carries a recommendation and its declined alternatives; none blocks
S4 step 7.
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
R39, D62, D63); the register holds 45 rows for 45 harness files, measured by
`gates/census_register.sh` at bbx-22, and the census itself is stale by design
until the next regeneration (`census-drift register=af2b1f085070 tree=bc18c672fdb9`).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `529f9d2`, EIGHT past at the bbx-22 open (`bbh-drift baseline=10a82d2 tip=529f9d2 ahead=8`), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `373725e0c000` and 63 ahead at the bbx-22 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16. From G38 on, every entry in
`docs/gotchas.md` names the rules it re-anchors in its own text (11 of 11, G38–G48,
counted at bbx-22), and this list is not copied further. The formal promotion is
slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **G50, the first small fix:** the readout names a gate header it
cannot read ("header not found at <path>") instead of counting that gate as declaring
no blind spot. It is a harness change, so fold it into R44's and R46's build if that
comes next: one identity move, one refreeze, one census regeneration, one battery pair. (2) **S4 step 7,
the slice readout** (`docs/plans/S4.md` §8.7), after which S4 goes to the maintainer
for a DONE ruling as S3 did. (3) **R44's printed refreeze and R46's one definition of
the identity key, built as ONE step**, then ONE census regeneration. The order that
avoids paying twice: land every code change FIRST, then `bin/bbx file-census --self
--out build/file_census_<stamp> --shadow-refreeze 'python3
fixture/selfgates/mkselfgates.py' --document docs/census/bbx_files.md --frozen
expected/file_census.toml --freeze`, then commit the document and register
(docs-only, so the key holds), then refreeze the fixture row (fixture-only, so the
key still holds), then the battery twice. Prove any instrument change on a two-gate
`--only` probe before paying twenty minutes. (4) **G48's sweep**: every count a
runner in `bin/` takes over a tool's output, asking whether a missing line reads as
zero — measured before any of them is called a defect. R45 is rescoped and waiting.

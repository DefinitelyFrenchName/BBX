# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-19 close, 2026-09-12):** slices S1 (but for R21's platform run)
and S2 complete; **S3 DONE**; **S4's BUILD IS COMPLETE — steps 1 through 6 are
built, and only step 7, the slice readout, remains.** This sitting built step 6,
THE FILE CENSUS AS A GATE (R39), and the step found **six defects in its own
work, every one by measurement**. What landed: `lib/py/bbx/file_census.py` and
`bbx file-census`; `gates/file_census_tool.sh` (portable, ~13 s, 12 instrument
runs on a synthetic harness tree, 5 controls) which holds the INSTRUMENT every
battery; `gates/file_census.sh` (~20 min, 3 controls) which makes the
MEASUREMENT and is the first row of `gates/sweep.tsv` at the release scope;
BBX's **first `[tier].patterns` entry**, without which a gate registered only in
the sweep registry is an orphan (`tier.py` reads `known = portable | static`);
`expected/file_census.toml`, 44 frozen kind-sets, class `self`, shrink-only; and
`docs/census/bbx_files.md` GENERATED, its §A and §B never hand-edited again.
**Two derivations replaced bbx-11's hand lists:** a kind's SEEDS come from its
own profile (families from `[expectations].kinds`, modules from
`lib/sh/compare.sh`'s dispatch case followed through its functions, plus the
log_summary module, the driver, and every consumer config's driver), and a gate
is frame-driven-by-need when it sits in the static registry and names
`static_needs_env` — the second reproduces bbx-11's list exactly, the first
ADAPTS where a list would have lied. **The measurement:** 30 gates traced in a
shadow, all PASS, universe 44 files, kinds K 14 / F 6 / D 4 / C 6, and **A17 = 0
files reached by NO gate**, printed explicitly. `bin/bbx` went from 1 gate of one
kind to 5 gates of two; `bin/bbx-run-static` gained the command-line kind;
`bin/bbx-run-sweep` stayed where bbx-11 put it, as X33 and X37 said. Eleven
files are reached by gates of all three kinds. **The six defects (G38–G43, and
three plan corrections X36–X38):** the shadow is an instrumented harness, so
R38's identity legitimately moves inside it and the adapters gate failed there
until `--shadow-refreeze` (G38); a command-line gate read as document-set
because two shared comparators IMPORT `docset.py` and the trace records what was
loaded, invisible at bbx-11 because with two kinds the wrong attribution and the
right answer were the same string — the third kind is the detector, BBX-25 turned
on the tool that measures genericity (G39); `git commit` with nothing to commit
exits 1 and under `set -e` killed a gate four controls early (G40); a retraction
pattern spanning two lines could never match, because the sweep reads per line
(G41); keying the generated document by `HEAD` made its own check fail for ever,
fixed with R38's identity (G42); and **the census read 30 of 44 files as reached
by NO gate** because a gate handed a cwd reports its PHYSICAL path, so modules
imported under `/private/var` while the trace recorded `/var` — a plausible
number and pure garbage, and the committed census had been correct only by the
luck of writing under `build/` (G43). Its fix is proven both ways: the portable
gate's synthetic stub now derives PYTHONPATH the way real gates do, and on a copy
with only the realpath comparison reverted the gate FAILs. **Three runs now agree
on every file count, kind and verdict**; the only field that ever moved is the
runtime, which is why the seconds column came out of the checked block (BBX-14:
non-determinism is never absorbed). Defaults D1–D63 (D62 the identity, the
markers and the frozen register; D63 the cadence and why the sweep row needs the
tier pattern). Gotchas G1–G43. Retractions X1–X38. **One shape, now five
instances in two sittings:** a check that cannot reach its own failing state —
the orphan verdict (G34), the clock stub (X32), the watcher loop (G37), the
two-line retraction pattern (G41), and the portable gate's own ground truth,
which lacked the one idiom that triggered G43.

**In force:** `DECISIONS.md` — R0–R20, R22–R42 and method M1–M4. **Open
rulings, six:** R21 (the platform runs: no Linux or WSL host here), R43 (which
bbh commit `gates/suite.sh` clones, and where the one baseline default lives),
R44 (what the self subject's moving identity costs at every close), R45 (how
BBX-9's orphan direction gets a verdict when the runner that reports it is the
lineage's), and two raised this sitting — R46 (where the harness's own identity
key is COMPUTED, now that two writers of it exist in two languages and a gate
only cross-checks them on one tree; the precedent against merging is R41, which
KEPT two writers after measuring they could not disagree, and these two can) and
R47 (what detects a harness file no gate executes BETWEEN releases, now that the
census is release-scoped: the recommendation is a cheap portable row holding the
frozen register complete both ways against the universe, which cannot prove a
file is reached and must say so). Each carries a recommendation and its declined
alternatives; none blocks S4 step 7.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, with BBX ITSELF a
subject and an external test framework a driver — five consumers:
bbh's `example/`, `fixture/docset/`, `fixture/fakecli/`, `fixture/unittest/`,
`fixture/selfgates/` (R14, R15, R37, R38). **BBX's own harness files are now
measured by a gate**, not by a document: 44 files, 30 gates, 0 unreached
(`docs/census/bbx_files.md`, generated; R39, D62, D63).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `1af19c7`, SIX past (it moved during bbx-16 and twice during bbx-17), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `46ccb3b` and 36 ahead at the bbx-17 close; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16 (`docs/gotchas.md`, G1–G37). The
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

**Next:** **S4 step 7, the slice readout** — the last thing S4's plan asks for
(`docs/plans/S4.md` §8.7): the families per kind (the design target B = 4),
controls declared and fired, the provenance classes, the defaults rows, the FILE
CENSUS from the gate with its three-kind rows, and what the green does not assert
(CLAUDE.md §7). The build is done; this is the slice's own readout, after which
S4 can be put to the maintainer for a DONE ruling as S3 was. **Before any of it:**
the battery GREEN at the open, in the background (~11 min; `file_census_tool` is
the 30th gate and adds ~13 s). **The census's own cadence:** `gates/file_census.sh`
is NOT in the battery — it is the first row of `gates/sweep.tsv` at the release
scope, and it takes ~20 min because it runs the whole battery inside a shadow.
Run it with `BBX_BBH_HOME` set when a release or a kernel change wants it, and
read R47 first, which is about the gap that cadence leaves. **The refreeze rule
stands and now has a companion:** a commit touching `bin`, `lib`, `drivers` or
`gates` moves BOTH the self subject's registry row (R38, R44) AND the census's
key (D62), so such a commit leaves `gates/adapters.sh` red until the reviewed
refreeze and leaves `docs/census/bbx_files.md` stale until a release run
regenerates it. A commit touching only `docs/`, `expected/` or `fixture/` moves
neither — which is why this sitting could land the census and then refreeze.
R21's platform run when a host exists. bbh's tip is past the baseline: the R28
procedure when a sitting needs it, and R43 first.

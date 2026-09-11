# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-18 close, 2026-09-12; the sitting ran from 2026-09-11):** slices
S1 (but for R21's platform run) and S2 complete; **S3 DONE**; **S4 steps 1–5
built — the slice's build is complete but for step 6 (the file census as a gate)
and step 7 (the slice readout)**. This sitting built step 5, THE ADAPTERS, and
found two things nobody was looking for. **Step 5:** `drivers/unittest.sh`
drives a Python unittest package and `drivers/gates.sh` drives BBX's OWN static
runner through its OWN dispatcher over a synthetic consumer, both over the same
`lib/py/bbx/cli.py` core, which now has three consumers (BBX-25 with one to
spare). The framework's verdict is an OBSERVATION: a case that fails by design
is `case:FAIL:<sha1>` and PASSes against a truth that expects it. Two new
consumers, `fixture/unittest/` (8 cases in 2 modules, all six verdict words) and
`fixture/selfgates/` (BBX itself as the subject, R38's `command` identity read
through `$BBX_HOME` because a copy under TMPDIR is no git repository), and
`gates/adapters.sh` with 6 controls, 9 firings and 42 ok lines in 97 s. **The
first finding (G32, R43 open):** the R28 re-baseline of 2026-09-10 moved two of
the THREE gates that read `BBX_BBH_BASELINE` — `gates/suite.sh` still clones bbh
at `f675710` while `D20` says `10a82d2`, and its own header says it clones "at
the baseline (D20)". Measured both ways: exit 0 and 77 identical printed lines at
either commit, so it is currency and not correctness (§3.3), and the register
row named one reader of three. **The second (G34, R45 open):** BBX-9 is enforced
in ONE direction. A registered-but-absent gate is a `MISSING` row and reds the
run; a gate on disk in no registry is merely NAMED — `bbx tier --unregistered`
exits 0 in all three states, an orphan planted in BBX's own `gates/` left
`gates/tier.sh` PASSing, and the runner's `rc` never reads the list. It cannot be
fixed in the runner without breaking the fidelity obligation (F13's pairs diff
both runners over a repo that CONTAINS an orphan), so the verdict must live in a
gate of BBX's own. **R44 open** from R38 made concrete: the self subject's
identity moves on every commit touching `bin`, `lib`, `drivers` or `gates` — 22
of BBX's 53 commits, 5 of the last 10 — so this sitting's own step-5 commit moved
it and the close carries the reviewed refreeze as its own commit. Defaults
D1–D61 (D58–D61 added; D43 and D47 amended, dated). Gotchas G1–G36 (G32 the
half-moved default; G33 zsh's `:l` modifier turning `$c:lib` into `headib`, so git
resolved two of three trees and printed a plausible key; G34 the unenforced orphan;
G35 a shared helper that renamed the subject in three messages, one frozen by a
gate and two invisible to every gate; G36 `bbx controls report` reading a MISSING
log as zero firings and printing RED). Retractions X1–X35.
`bin/bbx selftest` GREEN at the open on `8b4426a` (`build/selftest_20260911T201846Z`:
28 gates, 105/105), GREEN with step 5 staged on `1afffc5`
(`build/selftest_20260911T215227Z`: **29 gates**, 111/111) and GREEN twice more at
the close on `4cbacd9` (BBX-14 met); the tally and the controls line are quoted
verbatim in `docs/readout.md`'s bbx-18 CLOSE. **The battery now takes about ten and
a half minutes and no longer fits a ten-minute foreground command: run it in the
background and wait on its tally.**

**In force:** `DECISIONS.md` — R0–R20, R22–R42 and method M1–M4. **Open
rulings, four:** R21 (the platform runs: no Linux or WSL host here), and three
raised this sitting — R43 (which bbh commit `gates/suite.sh` clones, and where the
one baseline default lives), R44 (what the self subject's moving identity costs at
every close, and whether the whole-set key keeps `gates`), R45 (how BBX-9's orphan
direction gets a verdict when the runner that reports it is the lineage's). Each
carries a recommendation and its declined alternatives; none blocks S4 step 6.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, with BBX ITSELF a
subject and an external test framework a driver since bbx-18 — five consumers now:
bbh's `example/`, `fixture/docset/`, `fixture/fakecli/`, `fixture/unittest/`,
`fixture/selfgates/` (R14, R15, R37, R38).

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
G36 → BBX-16/BBX-6/BBX-12 (`docs/gotchas.md`, G1–G36). The
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

**Next:** **S4 step 6** (`docs/plans/S4.md` §8.6, R39 answered): the file census
lifted into `lib/py/bbx/file_census.py`, `bin/bbx file-census [--check]`,
`gates/file_census_tool.sh` (portable, the instrument on a synthetic tree, G25 as a
mode) and `gates/file_census.sh` as the first row of `gates/sweep.tsv` (static,
release cadence), the census document regenerated — step 5 moved the two "+kernel"
rows that census is meant to measure, because `bin/bbx` and `bin/bbx-run-static`
are now executed by a gate of the command-line kind. Then step 7, the slice
readout. **Before any of it:** the battery GREEN at the open, in the background;
and a commit touching `bin`, `lib`, `drivers` or `gates` needs the REVIEWED
refreeze of `fixture/selfgates/expected/registry.tsv` as its own last commit (R38,
R44 — `python3 fixture/selfgates/mkselfgates.py` is both the detector and the
refreeze). R21's platform run when a host exists. bbh's tip is six past the
baseline: the R28 procedure when a sitting needs it, and R43 first, because one of
the three gates that read that default was never moved.

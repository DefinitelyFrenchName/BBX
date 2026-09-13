# WSL — the first platform run of R21 (reported 2026-09-13)

**Status (after the bbx-22 close, 2026-09-13): WSL is GREEN — the kept pair at `429d3f8`
reads GREEN twice, BBX-14 met.** R21 is answered: a platform reads green only on a kept pair at
a commit whose macOS battery is also green, and the macOS close pair is GREEN twice at the same
commit. The first run below, at `ab21e4c`, was NOT GREEN, and the red was a defect in BBX's own
controls contract, not in any gate and not in WSL (G47, fixed by R48 at bbx-22). All five kept
runs are in `runs/`, byte-identical to the maintainer's archive.

| | |
|---|---|
| reported by | the maintainer, from a WSL host |
| BBX commit | `ab21e4c`, read from the kept run's `run.txt` (this page had said `84442f8` or later) |
| verdict | `PASS 30  SKIP 1  FAIL 0  MISSING 0` — then `NOT GREEN` |
| controls | `fired 115 / declared 119; gates with no declaration: 0; red: 1` |
| the one red | `controls=census_recount declared=4 fired=0 dead=4 undeclared=0 verdict=RED` |
| working tree | `ok: no tracked file changed during the run` |
| the run itself | kept: `runs/selftest_linux_20260913T105013Z/`; `run_2026-09-13.txt` is its printed output as first reported |

## What the run found

`gates/census_recount.sh` SKIPPED, exactly as `docs/platforms/README.md` predicted,
because the three lineage census files record absolute paths from the macOS host. A
skipped gate asserts nothing and runs none of its checks — so none of its four
declared must-fire controls could fire. The controls reader then counted a declared
control that did not fire as DEAD, the runner made that RED, and the whole battery
read NOT GREEN (the contract until R48, bbx-22).

**Reproduced on macOS the same day**, so it is a contract defect and not a platform
difference: pointing `BBX_CENSUS_DIR` at a census naming an absent tree gives
`controls=census_recount declared=4 fired=0 dead=4 verdict=RED` here too. The
finding is therefore instrument-grade, not a witness (BBX-28). It is filed as G47
and raised as ruling R48.

Why macOS could never show it: no gate skips here, because the three lineage trees
are present at the paths the censuses record. The SECOND PLATFORM is the detector,
which is BBX-25's argument about consumers applied to hosts.

## What the run also established, and this is the strong part

Everything else is **identical between Darwin arm64 and WSL**. Same 31 registered
gates, same per-gate declared-control counts summing to 119, and every NOTE-class
number the same on both hosts:

```
band              verdict-lines-frozen 22        json_schema   verdict-lines-frozen 30
set_schema        verdict-lines-frozen 38        cli_suite     suite-runs 15
docset_suite      suite-runs 17                  suite         suite-runs 25
file_census_tool  file-census-tool-runs 12       docset_driver coverage 20/23
census_register   files 45  rows 45              fidelity      bbh-drift ahead=8
cli_fixture       records=9 commands=5 options=9 refusals=7 scenarios=9 expectations=12 truth_logs=9 band_fields=1
docset_fixture    records=12 documents=3 claims=20 wrong=1 paraphrase=1 unbindable=2 scenarios=3 expectations=12 truth_logs=3
```

The anti-orphan check, the working-tree check and both fidelity gates behave the
same. Runtimes differ and are not gated: the WSL host is faster on the heavy gates
(`sweep_runner` 58 s against 91 s, `cli_suite` 59 s against 132 s, `adapters` 37 s
against 135 s).

The expected `census-drift` NOTE appeared and was correctly ignored, as the
procedure said it should be.

## The kept runs (the maintainer's archive, received after the bbx-22 close)

`bbx_linux_run.tgz`, sha1 `dabf99b8c3f9b97063d9920e1e739e2435b1e60b`, 182 entries. Every
stamped run directory is committed under `runs/` byte-identical to the archive (`diff -r`, 5 of
5). Each row below is read from that run's own `run.txt` and `controls.txt`:

| run | commit | platform | verdict | tally | controls | tree |
|---|---|---|---|---|---|---|
| `selftest_linux_20260913T105013Z` | `ab21e4c` | Linux x86_64 | NOT GREEN | PASS 30 SKIP 1 FAIL 0 MISSING 0 | fired 115 / declared 119, red 1 | unchanged, porcelain 0 |
| `selftest_linux_20260913T123740Z` | `fd63797` | Linux x86_64 | NOT GREEN | PASS 30 SKIP 1 FAIL 0 MISSING 0 | fired 115 / declared 119, red 1 | unchanged, porcelain 0 |
| `selftest_linux_20260913T124807Z` | `fd63797` | Linux x86_64 | NOT GREEN | PASS 30 SKIP 1 FAIL 0 MISSING 0 | fired 115 / declared 119, red 1 | unchanged, porcelain 0 |
| `selftest_linux_20260913T125915Z` | `429d3f8` | Linux x86_64 | **GREEN** | PASS 30 SKIP 1 FAIL 0 MISSING 0 | fired 119 / declared 119, red 0; `census_recount` SKIPPED (4 set aside) | unchanged, porcelain 0 |
| `selftest_linux_20260913T131738Z` | `429d3f8` | Linux x86_64 | **GREEN** | PASS 30 SKIP 1 FAIL 0 MISSING 0 | fired 119 / declared 119, red 0; `census_recount` SKIPPED (4 set aside) | unchanged, porcelain 0 |

The `fd63797` pair is the re-run that met the pre-fix tree (G49); its two runs agree (BBX-14 met,
0 verdict differences). The archive's sixth directory, `build/selftest_linux_/` with no timestamp,
is NOT committed: it has no `run.txt`, so there is no commit to key it by (BBX-29), and its
`results.tsv` stops at `sweep_runner` with exit 130, the status of an interrupted process.

Reported by the maintainer beside the archive, not re-derivable from it: `git log --oneline -1`
→ `429d3f8` (it agrees with both GREEN runs' `run.txt`), `uname -a` → `Linux <host>
6.18.33.2-microsoft-standard-WSL2 … x86_64 GNU/Linux`, `python3 -V` → `Python 3.14.4` (the macOS
host runs 3.9.6).

## The platform's screen (the `429d3f8` pair)

Generated on the macOS host by `bin/bbx readout <…T131738Z> --against <…T125915Z>` on COPIES of
the two runs whose `root=` line was rewritten to a clone of BBX at `429d3f8` — the same commit,
so the same gate headers (`git diff --quiet 429d3f8 -- gates` in the clone). Without the rewrite
the screen is identical except for its first line and its blind-spot section, which reads `gates
declaring no blind spot: 31`, because the WSL root does not exist on the macOS host (G50). The
committed runs are unmodified and record `root=/home/koneko/bbx/BBX`; the first line below
names the clone instead.

```
== READOUT — self subject at /private/tmp/claude-501/-Users-koneko-Developer-generalized-blackbox-harness-BBX/68f1f01d-7c10-4c82-a556-beae3b0198a2/scratchpad/bbx429 @ 429d3f8 (porcelain 0) — started 2026-09-13T13:17:38Z on Linux x86_64 ==
VERDICT: GREEN   PASS 30  SKIP 1  FAIL 0  TIMEOUT 0  MISSING 0   (gates 31)
tree during the run: unchanged (untracked entries 0 -> 0)   harness: bbx @ 429d3f8
rests on:
  controls: fired 119 / declared 119; dead 0; undeclared firings 0; gates red 0; skipped 1, whose 4 declared control(s) assert nothing: census_recount
  each can fail: 30 of 31 gates proved a control fires on purpose; skipped, proving nothing this run: census_recount
  expectations relied upon: none registered — a static run compares against no frozen expectation; a kept suite run (bbx-run-suite --log) carries its register's histogram (D32)
  coverage: docset_driver: 20/23
  note: docset_fixture: docset-fixture records=12 documents=3 claims=20 wrong=1 paraphrase=1 unbindable=2 scenarios=3 expectations=12 truth_logs=3
  note: docset_driver: paraphrase 1
  note: docset_driver: unbindable 2
  note: docset_driver: stale 0
  note: docset_driver: mismatch 1
  note: set_schema: verdict-lines-frozen 38
  note: docset_suite: suite-runs 17 (each kept under --log)
  note: cli_fixture: fakecli-fixture records=9 commands=5 options=9 refusals=7 scenarios=9 expectations=12 truth_logs=9 band_fields=1
  note: band: verdict-lines-frozen 22
  note: json_schema: verdict-lines-frozen 30
  note: cli_suite: suite-runs 15 (each kept under --log)
  note: file_census_tool: file-census-tool-runs 12
  note: census_register: census-drift register=af2b1f085070 tree=bc18c672fdb9 (the harness moved past the census; the release gate re-measures it)
  note: census_register: census-register-files 45
  note: census_register: census-register-rows 45
  note: fidelity_bbh: bbh-drift baseline=10a82d2 tip=529f9d2 ahead=8
  note: fidelity_bbh: bbh-source tip=529f9d2 porcelain=0 untouched-by-construction=clone
  note: fidelity_bbh_s2: bbh-drift baseline=10a82d2 tip=529f9d2 ahead=8
  note: fidelity_bbh_s2: bbh-source tip=529f9d2 porcelain=0 untouched-by-construction=clone
  note: suite: suite-runs 25 (each kept under --log)
  BBX-14 (more than one run): met — 31 gates, 0 verdict differences against the run started 2026-09-13T12:59:15Z at the same HEAD
  last re-baseline: 2026-09-10 (bbx-5, R28): bbh `f675710` → `10a82d2` — bbh's commit "config: the M18 re-point that sat dirty since 14z-144; the example lib's root one level too high; the extraction counts dated" (7 files; G11 fixed there; the four dirty files of R8 committed). Measured before the move by the D20 override: F12, F13, F14, F14f, F16, F17 identical on a clone of `10a82d2`. Moved with it: D20; D12's five `[sweep].placeholders` (by definition); the census `docs/census/bbh.md` (A2 19 → 20). No verdict text changed on either side.
what this green does NOT assert (declared by each gate's header):
  classify: that a verdict word printed by a gate outside the runner is read at all: the classifier reads exit status first, then the log; a PASS printed after a non-zero exit is FAIL by design
  config: the meaning of a consumer's keys: only that the layers resolve (consumer over kind profile over kind-blind default) and that dumps are stable
  tier: that a gate reaching an instrument through a path the source regex does not match is seen: the depth and the regex are the limit
  static_runner: the sweep runner or any gate that needs an instrument: this is the pre-commit chain only
  static_runner: runtimes as anything but this host under this load
  controls: that a control is RIGHT — only that a declared control fired and an undeclared one is red (docs/controls.md)
  controls: that a SKIP is JUSTIFIED — a skip for a bad reason sets its controls aside exactly like a good one; the screen names it and --strict refuses it, and nothing here judges the reason (R48)
  sweep_runner: speed-up on a real consumer: the queue is measured on stub gates with sleeps, not on an instrument-tier suite
  sweep_runner: a gate that escapes its clone by an absolute path: clone-per-slot pins the cwd, nothing more
  sweep_runner: portability beyond macOS: mkfifo and exec 8<> are POSIX, not yet run on Linux or WSL
  fingerprint: the identity of any artifact that is not a single file: the kind-blind fingerprint is file-sha1 (D16)
  rulings_shape: the prose of a ruling: only its heading, its answer line and its DECISIONS row are read
  readout: that a declared blind spot is true or complete: the screen prints what the header says
  readout: the sweep runner's runs: only bbx-run-static --log and bbx-run-suite --log are read
  readout: that a register row's class is true of its file: the suite screen prints what the register says (gates/provenance.sh keeps it complete and inside the vocabulary)
  close_sweeps: that every corrected claim has a register row: the register is written by hand at the correction (a claim nobody registered is not swept)
  close_sweeps: step 9 of the close (the lineage untouched): that is the recount's clone and the fidelity gate's proof, not this gate
  temporal: anything about a real log: every shape here is synthesized (fixture class); the classes' fitness for a consumer is that consumer's ratification
  temporal: the dispatcher's spec line and the suite's dispatch (S2 steps 2 and 3): the comparators are called directly
  temporal: that the thresholds are right for any subject: they are the frame-driven profile's (D23) and a consumer's override needs R25's ruling row (gates/thresholds.sh)
  thresholds: that a ruling id in [thresholds].rulings names a ruling that exists: any non-empty string is accepted here; the consumer's rulings-shape gate is where an id is checked
  thresholds: the values' fitness for any subject: 2 / 60 / 8 are bbh's ratified policy carried in the frame-driven profile (D23), not a measurement of anything here
  compare_dispatch: the suite's dispatch around this library (which file is read, how many runs, the .sha1 and .diverge kinds' own paths): S2 step 3
  compare_dispatch: anything about a real log or a real mask: every log is synthesized and the masks are strings the guard compares, never applied
  expectation_kinds: the content of any expectation file: only its extension and its stem are read here
  expectation_kinds: the suite's use of the dispositions (S2 step 3)
  provenance: that a row's class is TRUE of its file: the register is written by hand at the freeze; only completeness and the vocabulary are checked
  provenance: bbh's example register (markdown, a consumer list of classes): it is bbh's and F19 (S6) reads it under R11
  docset_fixture: that any claim in the fixture is BOUND, MISMATCH or anything else (gates/docset_driver.sh and gates/set_schema.sh): only that the files are the generator's, the design is chiral, and the register is complete and tracked
  docset_fixture: the suite over the fixture: gates/docset_suite.sh
  docset_driver: the verdict text of the exact, set and schema comparators (S3 step 3): the truth is compared here with cmp and diff
  docset_driver: the suite over the fixture (identity, the kinds loop, the coverage NOTE on the screen): gates/docset_suite.sh
  docset_driver: prose, reasoning and causal claims in a document: only sentences in a declared form and the listed rows are claims
  docset_driver: the truth of the artifact itself: a document that agrees with a wrong artifact reads BOUND
  docset_driver: a nested document tree or a second artifact per set (DOCSET_VIEW is refused): S4 or a consumer's question
  set_schema: the suite's loop over the kinds, the kept-run rows (scenario, kind), NOT-EVALUATED on a schema FAIL and --freeze for the shrink-only kind: gates/docset_suite.sh
  set_schema: anything about a real document set: every input is the fixture's (fixture class) or a perturbed copy of it
  set_schema: the schema family on a second format or a second consumer (S4's JSON): tsv is its one format and the fixture's artifact its one consumer (BBX-25 unmet, stated)
  docset_suite: anything about a real document set: every input is the fixture's (fixture class) or a perturbed copy of it; the forms, guards and lexical classes are the fixture's (D35, D39, D40)
  docset_suite: bbh's precedence loop and its printed text: gates/fidelity_bbh_s2.sh (F12) and gates/suite.sh
  docset_suite: the readout screen beyond the lines checked here (the verdict, the pairings, the coverage and note lines, BBX-14, the driver's blind spots): gates/readout.sh
  docset_suite: a second consumer of the kinds loop (S4's command-line kind): one profile drives it here (BBX-25 unmet, stated)
  cli_fixture: the driver (S4 step 2): the tool is run here DIRECTLY by the generator's tool-check; no log in D47's grammar is produced by anything but the generator, so the truth logs describe the design, not a run
  cli_fixture: the comparators over the new kinds (`unordered`, `schema` json, `band`: S4 step 3) and the suite over the fixture (step 4): only that the files are the generator's, the design is chiral, the tool matches it, and the register is complete and tracked
  cli_driver: the verdict text of the exact, set, schema and band comparators over these logs (S4 step 3): the truth is compared here with cmp and diff
  cli_driver: the suite over the fixture (identity, the kinds loop, RUN-FAIL on a crash, the band NOTE on the screen): S4 step 4
  cli_driver: performance, behaviour on inputs outside the scenarios, and anything the tool wrote that the scenario did not declare
  cli_driver: a tool that is a directory, a non-UTF-8 output, an emitted TREE, a fractional band (docs/plans/S4.md §9): a consumer's question, refused or discarded here, never measured
  band: the suite's loop over the band kind, `NOTE: band-fields` on the readout's screen and --freeze under the suite: S4 step 4
  band: that a rulings entry names a ruling that exists, or that the ruling names a mechanism: any non-empty id is accepted here (the thresholds gate's rule, R25; docs/plans/S4.md §9)
  band: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it; a fractional band or a band field that is not an integer by design is a consumer's question (D48)
  json_schema: the suite over the fixture — `NOT-EVALUATED (schema failed)` on the truth row of a scenario whose schema FAILed, and how the suite hands the JSON view to the schema family in place of the subject file: S4 step 4
  json_schema: the TSV format's verdicts beyond its vocabulary: gates/set_schema.sh freezes them; nothing here reads a TSV artifact
  json_schema: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it; a tool whose unordered output repeats a line cannot be frozen (a duplicate frozen row is hand-editing, BBX-17) — a consumer's question; the inside of a nested object is not judged (D49)
  cli_suite: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it (D45, D46, D50)
  cli_suite: bbh's precedence loop and its printed text: gates/fidelity_bbh_s2.sh (F12) and gates/suite.sh; the document-set kind's loop: gates/docset_suite.sh
  cli_suite: the verdict text of the families beyond the lines frozen here: gates/band.sh, gates/json_schema.sh, gates/set_schema.sh
  cli_suite: the readout screen beyond the lines checked here (the verdict, the register's histogram, the classes, the notes, BBX-14, the driver's blind spots): gates/readout.sh
  cli_suite: that the two writers of `band-fields` AGREE: both counts trace to one `bands` list written once by
  adapters: the frameworks' own correctness: identical tokens mean the framework reported the same thing, never that what it reported is true — and this gate's fixtures are written to report specific verdicts, so nothing here says a test suite or a gate battery is any good
  adapters: the DETAIL behind any verdict: a traceback, a gate's printed lines and the `detail` and `seconds` columns of a kept run are outside the observation (the seconds column moved between runs of the same six stubs at bbx-18, which is why it is not mapped)
  adapters: that an UNCOMMITTED edit to bin, lib or drivers moves the self subject's identity: it does not — the key is of the COMMIT (R38), and the kept run's `porcelain` line is what sees a dirty tree
  adapters: the ORPHAN direction of BBX-9 on the self subject: the anti-orphan file in the fixture is NAMED by the runner and appears in no token, because the runner exits 0 on an orphan (measured bbx-18, G34) — the verdict that direction needs is R45's
  adapters: the controls contract of the runner (`enforce`): the synthetic consumer sets it false, and gates/controls.sh is its ground truth
  adapters: the readout screen over these runs, and the comparators' own verdict text: gates/readout.sh, gates/set_schema.sh, gates/band.sh, gates/json_schema.sh
  adapters: a framework that is not on this host (pytest, bats, node's runner): R37 declines them, and a consumer adds a third adapter under the same core
  file_census_tool: that the census of BBX's OWN tree is correct: every trace here is the synthetic tree's (fixture class). gates/file_census.sh is the measurement; this gate is the instrument's ground truth
  file_census_tool: the SEED derivation on a real kinds table: this tree has no lib/sh/compare.sh and no kind-bearing consumer config, so F/D/C seeds are EMPTY here and only the static-need rule is exercised. The seeds are measured by gates/file_census.sh
  file_census_tool: that a gate PASSing in the shadow executed everything it executes in the tree: an uninstrumented path (a python module imported but never loaded, a file read and not sourced) is invisible by construction
  file_census_tool: any platform but this host's (R21)
  census_register: that any file is REACHED by any gate. This gate reads two file lists and one identity; `gates/file_census.sh` is the measurement and runs at the release scope (D63, R47)
  census_register: the KINDS in the register. A row's `kinds` value is not read here at all — a row claiming the wrong kinds passes this gate and fails the release run (shrink-only, D62)
  census_register: the census DOCUMENT. Only the register is read; `docs/census/bbx_files.md` is checked by the release gate against a run's own text
  census_register: that the universe and the identity answer the same question. The universe is `git ls-files` and so includes a STAGED file, while the identity is of the COMMIT — a file staged and not committed is in one and not the other, which is the honest reading of both
  census_recount: the truth of the not-recountable rows at their commits: they are named and counted, never run
  census_recount: that a hand-read citation says what its row claims: only that the line exists
  fidelity_bbh: anything about a suite, a comparator or an expectation: slice S2
  fidelity_bbh: bbh's example's correctness (G11 is bbh's to fix)
  fidelity_bbh: F15 unless BBX_FIDELITY_F15=1 was set for the run
  fidelity_bbh_s2: the kept suite run (--log) — bbh has none, so F12 diffs printed text only; the kept run's ground truth is gates/suite.sh
  fidelity_bbh_s2: anything about a real subject: F17's and F16b's inputs are synthesized, F16a's are the fake machine's (fixture class); the shapes are the lineage's paid-for cases and nothing else
  fidelity_bbh_s2: bbh's correctness: identical output on both sides is fidelity, not truth
  suite: any driver but the fake: a MAME or FBNeo driver is bbh's and untested here (bbh's own F8 rows)
  suite: the .sha1 kind's evidence: it is `self` class by construction (E4) and the register that says so is gates/provenance.sh's
  suite: the readout's reading of a kept suite run: gates/readout.sh reads the suite screen, gates/docset_suite.sh its coverage lines
  gates declaring no blind spot: 0   (a gate nobody has asked what its green leaves out)
skipped (asserting nothing): census_recount — SKIP: bbh.md names a repository directory that is absent h
```

## Against macOS at the same commit

Measured between this pair and the macOS close pair (`build/selftest_20260913T123343Z`,
`build/selftest_20260913T124821Z`), both at `429d3f8`: per-gate verdicts are identical in 30 of
31 rows, the one difference being `census_recount` — PASS on macOS, SKIP on WSL. Every NOTE and
coverage line is identical except the three `census_recount` prints on macOS (its coverage line
and two drift lines), which a gate that skipped correctly does not print. Runtimes differ and are
not gated.

## What these runs do NOT establish

- **The census recount on Linux.** It skipped, asserting nothing, by design.
- **`gates/file_census.sh`**, which is release-scoped and was not run.
- **The blind-spot section as read on the host that ran it.** The screen above takes the gate
  headers from a clone of the same commit (G50).
- **A green run under `--strict`.** It would not be one: `census_recount` skips on this host by
  design, and `--strict` refuses every skip (R48).
- **Anything about a native Windows shell** outside WSL.
- What the pair DOES add beyond a second operating system, measured from the runs' `platform=`:
  a second CPU architecture (Linux x86_64 against Darwin arm64) and, by the maintainer's report, a
  second Python (3.14.4 against 3.9.6).

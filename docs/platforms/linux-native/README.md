# Native Linux — a pair over the portable tier at `f6f136d` (received after the bbx-24 close, 2026-09-13)

**Status: a PARTIAL platform row (the maintainer, 2026-09-13).** Two runs on native Linux x86_64 at
`f6f136d`, GREEN twice, BBX-14 met — over the 28 portable gates only. The static tier (`census_recount`,
`fidelity_bbh`, `fidelity_bbh_s2`, `suite`) was not run, because `BBX_BBH_HOME` was unset, so this pair says
nothing about fidelity with bbh, the suite gate or the census recount on Linux. A full native pair,
following `../README.md` (which sets `BBX_BBH_HOME`), is still owed.

| | |
|---|---|
| made | through claude.ai on its native Linux environment (the maintainer's report), archived by the maintainer as `bbx_nativelinux_pair_f6f136d.tar.gz` |
| archive | sha1 `04d6d574bc57c004ecbeb2c3034758631996b013`, 64 entries, no absolute or parent paths; both stamped runs committed under `runs/` byte-identical to it (`diff -r`) |
| BBX commit | `f6f136d`, read from each run's `run.txt`, the tree clean before and after |
| platform | `Linux x86_64` (`run.txt`); nothing else about the host came with the archive |
| verdict | GREEN twice; `run.txt`: `tier=all pass=28 skip=4 fail=0 missing=0` |
| controls | fired 115 / declared 115, red 0, in each run |
| macOS at the same commit | GREEN, PASS 32, controls fired 128 / declared 128 (the bbx-24 opening battery) |

## Three warnings before reading these runs anywhere else

1. **The recorded root does not exist here.** Both `run.txt` files say `root=/home/claude/BBX`. Read as
   recorded on another machine, the screen names all 28 gate headers `NOT FOUND` with their blind spots
   UNKNOWN and counts `gates declaring no blind spot: 0` (G50's fix, measured at `f6f136d` and at
   `114a4a5`). To read the blind spots, copy the runs, rewrite `root=` to a clone of BBX at `f6f136d`, and
   read the copies — which is how the screen below was made.
2. **The screen under-counts the skips (G57).** The runner counted the 4 static gates as skipped (`skip=4` in
   `run.txt`) but kept no row for them, and the readout counts rows: the screen reads `PASS 28  SKIP 0 …
   (gates 28)` and never names the tier. Trust `run.txt`'s `skip=` line until G57 is fixed.
3. **One blind spot is wrapped at this commit (G53).** `gates/cli_suite.sh` declares it over three header
   lines at `f6f136d`; that commit's own readout prints it cut mid-sentence, and a readout from `64dfd85` on
   marks it `^ TRUNCATED`.

## The kept runs

Each row is read from that run's own `run.txt`, `results.tsv` and `controls.txt`:

| run | commit | platform | verdict | run.txt | rows kept | controls | tree |
|---|---|---|---|---|---|---|---|
| `selftest_nativelinux_20260913T174645Z` | `f6f136d` | Linux x86_64 | **GREEN** | `tier=all pass=28 skip=4 fail=0 missing=0` | 28, every one `portable` | fired 115 / declared 115 | unchanged, porcelain 0, untracked 0 → 0 |
| `selftest_nativelinux_20260913T175100Z` | `f6f136d` | Linux x86_64 | **GREEN** | `tier=all pass=28 skip=4 fail=0 missing=0` | 28, every one `portable` | fired 115 / declared 115 | unchanged, porcelain 0, untracked 0 → 0 |

## The platform's screen

Generated on the macOS host by the readout at `114a4a5` — `bin/bbx readout <…T175100Z> --against <…T174645Z>`
— on COPIES of the two runs whose `root=` line was rewritten to a clone of BBX at `f6f136d`; the header line
shows that clone's scratch path. It carries G57's under-count (warning 2).

```
== READOUT — self subject at /private/tmp/claude-501/-Users-koneko-Developer-generalized-blackbox-harness-BBX/8ee6a168-5888-4b96-80a2-31ce743a374e/scratchpad/bbx_f6f136d @ f6f136d (porcelain 0) — started 2026-09-13T17:51:00Z on Linux x86_64 ==
VERDICT: GREEN   PASS 28  SKIP 0  FAIL 0  TIMEOUT 0  MISSING 0   (gates 28)
tree during the run: unchanged (untracked entries 0 -> 0)   harness: bbx @ f6f136d
rests on:
  controls: fired 115 / declared 115; dead 0; undeclared firings 0; gates red 0; skipped 0
  each can fail: 28 of 28 gates proved a control fires on purpose
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
  note: adapters: self-identity whole-set=afd52caf8a96bc51ef784d69a5797c64965681ee program=b7772e0e5ff22f3dece7e3234e56eaecebdc04c3 (R44: the key the registry row matched, printed on PASS)
  note: file_census_tool: file-census-tool-runs 12
  note: census_register: census-register-files 45
  note: census_register: census-register-rows 45
  BBX-14 (more than one run): met — 28 gates, 0 verdict differences against the run started 2026-09-13T17:46:45Z at the same HEAD
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
  cli_suite: ^ TRUNCATED — the blind spot above runs on 2 more header line(s) that this screen does not print (one line per entry: docs/controls.md, G53)
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
  registry_complete: that a gate is in the RIGHT registry: an instrument-free gate registered static that could run portable passes here
  registry_complete: a dead portable or static row: bin/bbx-run-static already reads it as MISSING and fails, and the fidelity pairs depend on that text
  registry_complete: an instrument reached through a path the tier's source regex does not match — that is gates/tier.sh's blind spot, inherited here
  gates declaring no blind spot: 0   (a gate nobody has asked what its green leaves out)
```

## What these runs do NOT establish

- The static tier on Linux: fidelity with bbh, the suite gate, the census recount.
- Anything at a commit after `f6f136d`: the readout, the close sweep and the harness identity have changed
  since.
- That the screen's SKIP count is right (G57).
- The host beyond `run.txt`'s `platform=` line: no kernel, distribution or Python version came with the
  archive.

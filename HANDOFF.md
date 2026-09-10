# HANDOFF — the map for the next session

Shape: operational map. Read this first, then `STATE.md`, then
`docs/rulings.md`. `CLAUDE.md` is the constitution, not the map.

## Where things are

| what | where |
|---|---|
| the constitution | `CLAUDE.md` (§0, §1 outrank everything) |
| the opening prompt (session 1's brief) | `FIRST_PROMPT.md` |
| what is true now / what was true at each close | `STATE.md` / `STATE_HISTORY.md` |
| rulings in force / how they came to be | `DECISIONS.md` / `DECISIONS_HISTORY.md` |
| the open rulings queue | `docs/rulings.md` |
| the incident ledger with prices | `docs/gotchas.md` |
| the measured census (3 files + protocol + verifier records) | `docs/census/` |
| **the FILE CENSUS** (which harness files each gate executes, by the kind of the gate; shared vs kind-specific; the generator in its §C) | `docs/census/bbx_files.md` — measured once at bbx-11, NOT gated (the gate is S4's plan); not read by `gates/census_recount.sh` |
| the four bins, every item | `docs/bins.md` (index + totals) → `docs/bins/{bbh,vampiresaved,sms}.md` |
| the abstraction as contracts | `docs/abstraction.md` |
| the generality proof (two non-frame kinds, their fixtures) | `docs/generality.md` |
| the fidelity plan, F12+ | `docs/fidelity.md`; re-baseline log `docs/rebaselines.md` |
| the slice sequence with the estimate | `docs/slices.md` |
| slice S2's plan (measured census of the lift, design, fidelity rows, controls, rulings R23–R26) | `docs/plans/S2.md` — built bbx-3/bbx-4 |
| **slice S3's plan** (the ancestors measured, the design contract by contract, the fixture, fourteen controls, rulings R31–R34) | `docs/plans/S3.md` — R31–R34 answered; **steps 1–5 built (bbx-7 … bbx-11); S3 ruled DONE by the maintainer 2026-09-10** (`docs/readout.md`, bbx-11: §7's six conditions in a table; the ruling recorded under it); §5's shifted-artifact row corrected at bbx-8 (G21), §5/§8.3's control placement at bbx-9 (X10), §5's nondeterminism row at bbx-10 (X11), §6's screen line at bbx-11 (X12) |
| **slice S4's plan** (the ancestors measured, the design contract by contract, the fixture `fixture/fakecli/`, eighteen controls, the adapters, the self subject, the file census as a gate, rulings R35–R40) | `docs/plans/S4.md` — bbx-12; R35–R40 answered 2026-09-10 (R40 with the TSV caveat); **steps 1–4 built (bbx-13, bbx-14, bbx-15, bbx-16)**; §3/§4 corrected at bbx-13 before step 1 landed (X14–X19, BBX-19); step 2 needed no correction; §2/§3/§5 corrected at bbx-15 before step 3 landed (X20, X21); §3/§6/§8 corrected at bbx-16 before step 4 landed (X22–X24); **step 5 is next** (the adapters, R37/R38) |
| **the command-line kind (S4 step 1)** | the profile `lib/py/bbx/config.py` KINDS `command-line` (D45; `log_summary = python3 -m bbx.cli summary` since step 2, D43); `[suite].scenario_ext = "cli"` (D34); the token vocabulary `lib/py/bbx/cli.py` (D47 — the ONE writer of every token); the fixture `fixture/fakecli/` (BBX's third consumer: `bbx.toml`, `mkfakecli.py --check` — the design's predicates on the tree's tool, regenerate-and-diff, and the TOOL-CHECK that runs `subject/fakecli.py` for every scenario against the design; `scenarios/*.cli` (D46), `expected/fixture/` with `truth` + `logs/`, `unordered`, `schema` json (D49), `band` (D48), the registry and the 22-row register); `gates/cli_fixture.sh` (4 controls) |
| **the command-line comparators (S4 step 3)** | `lib/py/bbx/compare_band.py` — the tolerant-numeric family over the driver's band view `<log>.bands` (D48, D53; `FAIL band <field>: <v> outside [<min>, <max>]`, the inventory both ways, `NOTE: band-fields <n>`; `--freeze <frozen> <proposed>` REFUSES to widen a band with no `rulings` entry and any inventory move, exit 3, the file unchanged — D55); the `tolerant-numeric)` branch and `compare_band` of `lib/sh/compare.sh` (the four S3 functions byte-identical); the json format of `compare_schema.py` (D49: keys both ways before any type, R40's seven types, `items_op`/`items_n`; the artifact is the driver's JSON view `<log>.json`, D54, handed by the kinds loop from the kind's view column since step 4, D57); the line row shape of `compare_set.py` (D56: `[l<i>] line, sha1`, compared by sha1 both ways; a wrong sha1 or a duplicate is hand-editing); `compare_exact.py`'s END rule counting the indices above zero (X20, G26); `bin/bbx compare band`; `gates/band.sh` (4 controls, ~4 s) and `gates/json_schema.sh` (5 controls, ~7 s), every verdict line frozen and classified, `finding.py` unchanged |
| **the suite over the command-line fixture (S4 step 4)** | the kinds table's VIEW column (D57: `-` / `log` / `subject` / `json` / `bands` — the fourth field of every `[expectations].kinds` row in `lib/py/bbx/config.py`, read by `lib/py/bbx/expectations.py` (`kinds` prints four fields, `view <ext>`; a three-field row refused on one line) and by `bin/bbx-run-suite` (`view_of`, `view_path` — THE ONE RESOLVER, checked at the entrance after the identity and before any scenario runs, handed to every family as `compare_check`'s artifact; the tolerant-numeric branch hands it to `compare_band`, which derives no path); `gates/cli_suite.sh` (7 controls: identity-before-any-scenario, nondeterministic-before-any-class three ways, crash-vs-refusal, wrong-truth, schema-before-any-value over the JSON view, band-through-the-loop, unknown-view; 43 printed lines frozen — `NOTE: band-fields 1` TWICE under 04_band, R41; 15 suite runs, ~99 s); the readout's suite screen for the fixture: `fixture 21`, classes `band, exact, multiset, schema`, the exit / band-fields / emitted-files notes |
| **the command-line driver (S4 step 2)** | `lib/py/bbx/cli.py` — the driver's core beside the vocabulary: `selftest` (FIPS 180-1's vectors as the reference anchor, the layout, the splitter, the scenario reader's refusals), `resolve` (the ONE resolver over `CLI_PATH`: per directory an executable `<set>` over `<set>.py`), `run` (the sandbox as cwd, HOME and TMPDIR — D52; D6's set plus the scenario's `[env]` and nothing from the caller; `argv.txt` / `stdin.bin` / `env.txt` recorded, O5; the crash log `CRASH signal:<n>:<NAME>` / `END-CRASH <n>` and the band view `<out>.bands` — D53; the JSON view `<out>.json` — D54, step 3; `--nondet`, `--timeout`), `summary` (`NOTE: exit / band-fields / emitted-files`); `drivers/cli.sh` (D4's four exits: a tool's non-zero exit is an OBSERVATION, a signal death exit 2, REFUSED exit 3 for the three families, `CLI_KEEP_ENV`, a scenario key the grammar lacks, a bad `CLI_TIMEOUT`; `CLI_TIMEOUT` default 60 s, D51, exit 1 DISCARDED); `drivers/README.md`; `gates/cli_driver.sh` (7 controls; two points re-hashed by `shasum`; ~10 s) |
| the maintainer readouts, one section per step, the CLOSE section last | `docs/readout.md` |
| **the document-set kind (S3)** | the profile `lib/py/bbx/config.py` KINDS `document-set` (D33); `[suite].scenario_ext` (D34) via `bbx.expectations scenario-ext`; the fixture `fixture/docset/` (BBX's second consumer: `bbx.toml`, `mkdocset.py --check` — writes the `truth` kind from the design, `subject/`, `claims/`, `expected/` with `logs/<s>.log` the truth logs); `gates/docset_fixture.sh` |
| **the document-set extractor and driver (S3 step 2)** | `lib/py/bbx/docset.py` (`selftest`, `run`, `map`, `summary`, and since step 3 `rows` — the run's rows joined by index with the map, proven the log's — and `resolve`, the ONE artifact resolver over `DOCSET_PATH`; the two strings and the token, D38; the forms' lexical classes and the record key, D39; the unlisted-claim guards, D40); `drivers/docset.sh` (`DOCSET_PATH` through `bbx.docset resolve`; REFUSED exit 3, DISCARDED exit 1); `drivers/README.md`; `gates/docset_driver.sh` (7 controls) |
| **the document-set comparators (S3 step 3)** | `lib/py/bbx/compare_exact.py` (the truth log against the run log BY INDEX; `FAIL-SHORT` apart from `FAIL exact: index <i> differs`, BBX-4), `compare_set.py` (a frozen multiset of `(document, line, form, status)` rows both ways — `claims` inventory, `covered` shrink-only with `NOTE: covered-grew`, R33; a duplicate named as hand-editing), `compare_schema.py` (the artifact's shape before any value: header names in order, one type per column from D41's vocabulary, the rows line; the FIRST violation named; a wrong column count a schema FAIL); the `exact) set) schema)` branches of `lib/sh/compare.sh` (`compare_check` takes two trailing arguments, the scenario file and the artifact); `bin/bbx compare exact|set|schema`; `gates/set_schema.sh` (5 controls; every verdict line frozen there and classified by `finding.py`, 38 lines) |
| **the suite's kinds loop and the kept run's notes (S3 step 4)** | `bin/bbx-run-suite` (the loop read off the kinds table: the temporal family means bbh's precedence loop verbatim, anything else the kinds loop — `schema` first, the table's order, `.sha1` last; `NOT-EVALUATED (schema failed)`; `--freeze` for the shrink-only kind through `bbx.compare_set --freeze`, never a self-freeze beside an authored kind); `notes.tsv` in the kept run (D44); `[suite].log_summary` (D43); `bbx.fingerprint --path` (the subject file, handed to the comparators); `finding.py`'s `NOT-EVALUATED` and `authored ` rules; the readout's suite screen (scenarios and pairings apart, `coverage:` per scenario, BBX-14 over pairings, the driver's blind spots); `gates/docset_suite.sh` (6 controls, 17 suite runs, ~55 s) |
| the controls contract (must-fire grammar, R10) | `docs/controls.md` |
| the defaults register (BBX-24) | `docs/defaults.md` |
| the kernel | `bin/bbx` (dispatcher: `run-static run-suite run-sweep classify tier config controls fingerprint recount readout compare selftest`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (BBX as its own consumer, kind `self`) |
| the expectation register (S2 step 4, R24) | `lib/py/bbx/provenance.py` over `<expected_dir>/PROVENANCE.toml` (D31); `gates/provenance.sh`; the readout's suite screen for a kept `bbx-run-suite --log` run (D32) |
| the comparison (S2 steps 1–3) | the temporal family `lib/py/bbx/compare_{flicker,window,composite}.py`, `check_diverge.py`, `propose_temporal.py`, `thresholds.py` (R25), `logfmt.py`; the one dispatcher `lib/sh/compare.sh` (R23: family by kind); the kinds table `lib/py/bbx/config.py` `[expectations].kinds` read by `lib/py/bbx/expectations.py` and `lib/sh/expectation_kinds.sh`; the suite `bin/bbx-run-suite` (`--log DIR`: results.tsv with a FINDING column, `lib/py/bbx/finding.py`; R26 driver home) |
| BBX's gates and registries | `gates/*.sh` (28: 24 portable incl. `temporal`, `thresholds`, `compare_dispatch`, `expectation_kinds`, `provenance`, `docset_fixture`, `docset_driver`, `set_schema`, `docset_suite`, `cli_fixture`, `cli_driver`, `band`, `json_schema`, `cli_suite`; 4 static incl. `fidelity_bbh_s2` (F12, F16, F17) and `suite`), `gates/portable.txt`, `gates/static.txt`, `gates/sweep.tsv` (empty) — run with `BBX_BBH_HOME=~/Developer/blackbox-harness bin/bbx selftest` (~8.5 min on this host: the two S2 static gates are ~100 s and ~60 s, `docset_suite` ~60 s, `cli_suite` ~100 s — under a 10-minute cap, run each battery as its own command) |
| the readout, generated | `bin/bbx selftest --log build/selftest_<stamp>` keeps the run; `bin/bbx readout <dir> [--against <dir>]` prints the one screen (RO1–RO3; BBX-14 met only with `--against` a second kept run at the same HEAD) |
| the retractions register (BBX-22) | `docs/retractions.tsv`, read by `gates/close_sweeps.sh` |
| the recount tool | `bin/bbx recount <census.md> [--only A1,A2] [--root DIR] [--in-place]` — runs on a plain local clone of the recorded commit (R18, R20); `--in-place` is the unproved escape hatch |

## The lineage on this machine

| repository | path | remote |
|---|---|---|
| **BBX (this tree)** | `~/Developer/generalized-blackbox-harness/BBX` | github.com/DefinitelyFrenchName/BBX (private, R22) |
| bbh | `~/Developer/blackbox-harness` | github.com/DefinitelyFrenchName/BBH-frame-based (renamed 2026-09-10; the old blackbox-harness URL redirects) |
| VampireSaved | `~/Developer/Vampire_Saved/VampireSaved` | github.com/DefinitelyFrenchName/VampireSaved |
| SMS-FrenchName-edition | `~/Developer/SailorMoonS` (directory name differs) | github.com/DefinitelyFrenchName/SMS-FrenchName-edition |
| bbh's skill | `~/.claude/skills/blackbox-harness` → symlink into bbh | load it before touching any gate, driver or comparator |

bbh is **never modified** from here. VampireSaved and SMS are read only.

## What is running

Nothing in the background. `BBX_BBH_HOME=~/Developer/blackbox-harness
bin/bbx selftest` (~8.5 min on this host) is GREEN twice at one HEAD at the bbx-16 close: 28 gates, 105/105 controls (`build/selftest_20260910T203200Z`, `build/selftest_20260910T204058Z`; the tally is quoted verbatim in `docs/readout.md`'s bbx-16 CLOSE). Run it first
thing, with `--log build/selftest_<stamp>` and no edits in flight (the runner's working-tree check reports a
concurrent edit as DIRTIED); the census recount inside it is the
re-derivation step of the ritual (CLAUDE.md §6.2) made into a gate.

## The ritual (ruled R17 at the bbx-1 close, 2026-09-09; adapted from VampireSaved VSP-17/VSP-18/VSP-162)

Sessions are keyed `bbx-N`, one key per sitting, never renamed (pointers in
readouts, gotchas and history resolve through it). The last closed sitting is **bbx-16** (2026-09-10); the next is **bbx-17**.

**Open**
1. Read this file, `STATE.md`, `docs/rulings.md`. (`CLAUDE.md` is the
   constitution, not the map.)
2. Re-derive before relying: `BBX_BBH_HOME=~/Developer/blackbox-harness
   bin/bbx selftest`, alone, with no edits in flight. A `drift` line in the
   NOTE block means a lineage repository moved past a census's recorded HEAD
   (the moved row ids are listed): the census is still true of its commit;
   re-measure it (`bin/bbx recount …`, then a dated line at its end) only
   when a slice needs the current lineage. A red census row means the census
   file rotted. A red fidelity pair means bbh or BBX moved: read
   `docs/rebaselines.md` before touching either. A red row is the session's
   first finding (BBX-26: it halts feature work).

**Close, in this order**
1. **Green first, twice, kept.** Run the battery alone, twice, each with
   `--log build/selftest_<stamp>` (BBX-14 needs two runs at one HEAD); the
   close quotes the tally line and the controls line verbatim. Not green:
   the close says NOT GREEN and why; the next session's first task is ruled
   by BBX-26.
2. **Nothing evaporates into prose.** Every number measured this sitting is
   reproduced by a gate or a census row, or is labelled "measured once, not
   gated" in the readout — the honest floor, not a backlog.
3. **The readout** (`docs/readout.md`): the sitting's section opens with
   the GENERATED screen, verbatim — `bin/bbx readout <second run> --against
   <first run>` — then what the generator cannot know yet: fidelity rows,
   what changed, next. Blind spots come from the gates' `NOT-ASSERTED:`
   headers; a gate declaring none is counted on the screen. This is the one
   screen the maintainer reads; it is BBX's CLOSE row.
4. **STATE** rewritten as a lean living page; the outgoing status paragraph
   appended verbatim to `STATE_HISTORY.md` under the session key. The twin
   is the ledger: one paragraph per sitting, never rewritten.
5. **HANDOFF** (this file): the routing table, what is running, and the
   next-session orientation below, rewritten; committed with what it
   describes.
6. **DECISIONS / DECISIONS_HISTORY**: new rulings in force; the sitting's
   history entry ends with the anti-hyperfocus line (BBX-27).
7. **Gotchas with prices; rulings with recommendation and declined
   alternatives.** Nothing pending silently; an answered ruling is MOVED
   under an Answered heading, never annotated under Open (G14; gated by
   `rulings_shape`, which also holds DECISIONS.md to the queue both ways).
8. **Sweeps — gated since bbx-2 (`gates/close_sweeps.sh`, in the battery):**
   every claim corrected this sitting gets a row in `docs/retractions.tsv`
   (BBX-22; the gate fails on the wording anywhere but the ledgers the row
   allows); deferrals (TODO, TBD, FIXME) fail; a `D<n>` cited with no
   `docs/defaults.md` row fails; every gate declares its controls (the
   runner refuses otherwise). The close's only hand step here: write the
   retraction rows.
9. **Lineage untouched — by construction and by proof (R18):** the recount
   never enters a lineage tree (clone); the fidelity gate runs in bbh's tree
   and proves its tracked porcelain unchanged. The close quotes each
   lineage's tip and porcelain from the recount summaries; they are
   reported, not required equal to the census (VampireSaved is worked on
   live by another session — its tree is nobody's baseline).
10. **Incidents reviewed for learnings (R27, ruled at the bbx-3 close).**
    Every incident of the sitting — caught by a gate or discovered after
    the fact — is re-read for a learning that would improve the harness: a
    mechanism becomes the next sitting's first small fix (or a ruling, if
    it changes a contract), a trap becomes a hazard below, and "no
    learning" is written in the gotcha entry so the question is seen to
    have been asked. Measured, never assumed (§1).
11. **One close commit** per sitting, tally in the message, pushed to
    `origin` (R22; a post-close correction is pushed with it).

Steps 8 and 9 are checked, not remembered: step 8 by `close_sweeps`, step 9
by construction (the recount's clone) and by `fidelity_bbh`'s proof.

**Next-session orientation (written at the bbx-16 close, 2026-09-10)**
- Open first: `bin/bbx selftest --log build/selftest_<stamp>` and `bin/bbx readout` on it. Two `drift` NOTEs are expected: VampireSaved (past the census) and bbh (`02d58f3`, two past the baseline `10a82d2` — it moved during bbx-16, from `447e5d2`; follow it by the R28 procedure only when a sitting needs the current tip). The battery is ~8.5 min now: one battery per command under a 10-minute cap.
- **First small fix (G28, R27):** `gates/docset_suite.sh` and `gates/cli_suite.sh` copy the kept run (`cp -R "$LOGDIR" "$R1"`) right after the positive run; a suite that never created it ends the gate under `set -e` with a `cp:` line and no FAIL of its own. Guard `[ -d "$LOGDIR" ]` and print the suite's output as the FAIL line. Two lines per gate, both gates re-run through the classifier.
- **S4 step 5 is the next sitting's work** (`docs/plans/S4.md` §8.5, §3 "D7" and "R14", §5's adapter rows, §7's `derived` class; R37, R38 answered at bbx-12): `drivers/unittest.sh` and `drivers/gates.sh` over the same `bbx.cli` core (the sandbox, the scrub, the timeout, the log writer — three consumers of the core at the end of the step, BBX-25 with one to spare); `fixture/fakecli/tests/` (a unittest package with a designed failing test) and `fixture/selfgates/` (a synthetic `self`-kind consumer whose scenarios drive `bbx run-static` and `bbx run-sweep --list` — the census's "+kernel" rows); the identity of the self subject is R38's `command` key (`git rev-parse HEAD:bin HEAD:lib HEAD:drivers`); `gates/adapters.sh` (the framework's verdict as an OBSERVATION — a failing test is `case:FAIL:…` and PASSes against a truth that expects it; `Ran 0 tests` exit 1 DISCARDED; the self subject both ways; a framework run twice that differs → NONDETERMINISTIC). The adapters' kinds table is the command-line profile's (the view column: `truth` → `log`); new token kinds `case` and `gate` are D47's vocabulary (already listed there) — measure that `bbx.cli`'s splitter accepts them before the first log is written. Expectations `derived` class, never `fixture` (§3 E2, E3).
- **R41 is open** (two writers of `NOTE: band-fields`: the comparator, R36's letter; the log summary, D43). Until answered, `gates/cli_suite.sh` freezes the duplicate as printed and says so (NOT-ASSERTED). When answered as recommended: `compare_band.py` drops its NOTE line (the PASS line alone), `gates/band.sh`'s two NOTE checks read the summary instead (`python3 -m bbx.cli summary <log>`), `gates/cli_suite.sh`'s frozen text loses one line per band scenario (43 → 42) and its notes count 28 → 27; D48/the plan's band row corrected with a retraction row. If answered the other way, the summary's key goes and `cli_driver.sh`'s summary check changes instead. Either way one sitting's first small fix, not a step.
- Under `--freeze` the whole fixture is AUTHORED: `gates/cli_suite.sh` proves --freeze writes nothing there (every expectation `fixture` class, written from the design). The adapters' fixtures will be the same: author the kinds before the first freeze (the bbx-9 hazard).
- Where the built thing differs from the plan, the plan is corrected FIRST in its own commit with a retraction row (BBX-19): bbx-16 did it for X22–X24 (`3d98d1d`).
- The shadow practice stands (`git archive HEAD | tar -x -C <scratch>`, `git init` there, apply, every touched gate THROUGH THE CLASSIFIER, then every NEIGHBOURING gate (G28: the neighbour was the detector), then the whole portable tier there with `bin/bbx selftest` without `BBX_BBH_HOME`, then the new gate in the TREE, then the battery). Write the new `docs/defaults.md` rows in the shadow too. A `--log` path given to the suite is resolved against the CONSUMER's root, not the caller's cwd: pass it absolute (bbx-16 left two kept runs under `fixture/` of the shadow before noticing).
- G19's learning (a rot gate over generated and printed text) has instances G24, G27 and now G29 (headers' quoted counts against the kept logs) and is S6's; R29 (executable controls) is built in S6; R21 is still open.

**Orientation carried from the bbx-1 close (still true where not superseded above)**
- S1 has two items left: the readout generator (abstraction RO1–RO3 as a
  tool that reads a run's results and prints the one screen, with a gate)
  and the platform gates (R3: a Linux or WSL run of `bin/bbx selftest`,
  recorded in the readout). Neither blocks S2. Done at bbx-2 on top of the
  plan: R18–R20 (clones), R19's pull queue and `clone_per_slot` in the sweep
  runner, the `rulings_shape` gate; the close sweeps (steps 8–9) are still
  hand-run.
- S2 (`docs/slices.md`): the comparators (the temporal family lifted from
  bbh, thresholds declared once), the expectation kinds registry, the
  provenance register with the R11 vocabulary, the suite runner, fidelity
  F12 / F16 / F17. bbh's `bin/bbh-run-suite` (196 lines), `lib/sh/
  masked_compare.sh`, `enumerate_expectations.sh`, `lib/py/bbh/compare_*.py`
  and their selftests are the lift; every printed verdict line is frozen.
- One finding for the maintainer to act on in bbh, if wanted: G11 (the
  example lib's wrong fallback path). BBX never modifies bbh.
- Every lifted file cites its bbh origin in its header; every new default
  gets a `docs/defaults.md` row before it is used; every new gate declares
  its controls or the self-run goes red.

## Hazards known

- `/Users/koneko/.git` exists: HOME is a git repository. Commands run outside
  a nested repository see the whole home tree. Not ours; do not touch.
- The fidelity baseline is the commit, not the tree (R8): a moved bbh tip is a NOTE, measured first by the D20 override (`BBX_BBH_BASELINE=<tip>` on both fidelity gates), then followed by the procedure in `docs/rebaselines.md` (R28: a dated line, D20, D12 by definition, the census) — never a queue entry.
- Three counters inside VampireSaved's own docs are stale (see
  `docs/census/vampiresaved.md`); do not quote VampireSaved's prose numbers,
  quote its commands.
- This host's interactive `grep` is ugrep, not BSD grep (gotcha G9). Never
  verify a census count through the interactive shell; use
  `python3 lib/py/bbx/recount.py <census> --only <ids>`, which runs under a
  pinned PATH.
- VampireSaved is worked on concurrently by another session (bbx-2 saw its
  porcelain move 373 → 377 and its `M` count 1 → 3 in one sitting). Never
  read a fact off its working tree; the census's clone at the recorded
  commit is the instrument.
- A gate piped into `tail` in a `&&` chain checks nothing: the pipe's exit
  is `tail`'s (G16: a red `close_sweeps` was committed and pushed that way).
  Run the gate to a file, test its own exit, then read the file.
- The suite's derived configs must live IN the consumer copy: `[project].root = "."` resolves against the config file (a config under TMPDIR reads "unregistered build" because the registry is unreachable — `gates/suite.sh`'s own second defect).
- A parameter abort under an armed EXIT trap exits 0 on this host's `/bin/sh` (G18); the classifier's shell-error clause reads it as FAIL, but a chain that tests only the exit does not.
- A subshell that inherits `set -e` ends at its first failing command, before an `echo "exit=$?"` that follows it: a pair helper capturing a tool's exit needs `set +e` inside the subshell (the S2 fidelity gate's first defect); a state-setting helper called inside `$(…)` sets nothing the parent can read (G18).
- `--freeze` under the kinds loop never self-freezes a scenario that carries an authored kind (`gates/docset_suite.sh` control `freeze-keeps-the-truth-log`), so a `.truth`'s log at `logs/<name>.log` is safe beside it — but a scenario with NO authored kind is self-frozen and its `logs/<name>.log` WRITTEN: author the kinds before the first freeze, never after, or a later `.truth` would pair with a self-measured log (BBX-3, R11).
- The document-set profile scrubs the driver family (`DOCSET_NONDET`, `DOCSET_FORMS`, `DOCSET_VIEW`; D33): a control that needs one of them goes through a wrapper driver passed with `--driver`, never through the caller's environment (X11: the plan had assumed the environment reaches the driver).
- `.gitignore` says `*.log` (build output) with `docs/` and `fixture/` excepted: an expectation log anywhere else is IGNORED and silently absent from every clone (G22: the fixture's truth logs, one sitting). `bbx.provenance` now refuses a registered file git does not track; a new expectation tree under a new path needs its exception in `.gitignore` before its first freeze, and the shadow (a git tree built from HEAD) is where an ignored file shows.
- The header is the LEADING COMMENT BLOCK after the shebang (R30) and three readers share it (controls, readout, tier): a line inserted between the shebang and the block ENDS the header — an instrument, a shim, a `set -x` added on line 2 makes every `MUST-FIRE:` and `NOT-ASSERTED:` line below it invisible, and only a gate that reads that file's header notices (G25: the census instrument, caught by `gates/docset_suite.sh` through the driver's blind-spot lines). Insert after the block, and prove the instrument on the gates before reading a number off it.
- A generator that reads a SIBLING fixture (mkfakecli.py reads mkdocset.py's design for the `disjoint-from-docset` predicate) locates it through the harness package root (`Path(bbx.__file__).parents[3]`), never through its own path: the gates' controls run a COPY of the generator under TMPDIR, and a copy has no siblings (caught in the shadow at bbx-13, two gate runs).
- The shadow commits what the tree has not staged: a new expectation tree passes `bbx.provenance`'s tracked-file check in the shadow (committed there) and FAILS in the tree until `git add` (the G22 guard, in the mirror direction — 22 rows refused at bbx-13). Run the new gate in the TREE, through the classifier, before the battery; a battery started first goes red on the same line six minutes later (one aborted at bbx-13).
- The shadow is built from HEAD: a `docs/defaults.md` row written in the TREE is not in it, and the shadow's `close_sweeps` reads `defaults cited-not-registered D<n>` for every citation of it in the new code (bbx-14: ten citations of D51/D52, one shadow tier run). Write the row in both trees, or read that red as exactly that — never as a defect of the code under test.
- "Unchanged for its second consumer" is a CLAIM until the second consumer's input has been run through the component (G26): the exact family failed every command-line log on its END rule while a `git diff` over the file would have read zero lines — currency, not correctness (§3.3). Write "expected unchanged, measured at step N" in a plan, and run every grammar-blind family over a new log grammar the sitting the grammar lands.
- A commit message's numbers are read off the run's printed line, never typed from expectation (G27: `546` typed, `547` printed, amended before the push). Assemble the close message AFTER the sweeps print, from their lines.
- A self-test that runs through a tool's REAL path inherits the tool's real refusals (G20): `docset.py`'s guards refused its own synthetic line once a regex was broken. Catch them in the self-test, or the control reads DEAD for the wrong reason.
- Two recounts running at once in one tree are not a known problem (the
  inflation seen while bisecting G9 was the grep, not the overlap), but the
  tools in the SMS tree do run for minutes; run the gate alone.
- An entrance check in a runner reads only variables defined ABOVE it; under `set -u` the consumer whose table reaches the branch aborts (`SUBJECT_FILE: unbound variable`) and the consumer that does not runs GREEN — the neighbouring gate is the detector, which is why the shadow runs every neighbour and not only the new gate (G28).
- A gate's frozen text, its header's counts and its quoted runtime are READ FROM THE RUN — the output file pasted, the NOTE line's number — never typed from a screen read: one character, one column and one count were wrong in one gate's first draft (G29; G27's family). A verdict is taken after the scenario field and past the kind's WORD, never at a fixed column: `unordered` is 9 wide where every earlier kind was ≤ 8.

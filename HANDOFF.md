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
| **the FILE CENSUS** (which harness files each gate EXECUTES, by the kind of the gate) | `docs/census/bbx_files.md` — **GENERATED and GATED since bbx-19** (R39, D62, D63). Its §A and §B live inside `GENERATED` markers and are never hand-edited; the prose outside them is hand-written. Keyed by R38's WHOLE-SET identity, not `HEAD`. Two gates hold it: `gates/file_census_tool.sh` (portable, ~13 s, the INSTRUMENT on a synthetic tree, 5 controls) and `gates/file_census.sh` (the MEASUREMENT, ~20 min, 3 controls, the first row of `gates/sweep.tsv` at the release scope — NOT in the battery). Still not read by `gates/census_recount.sh`, which reads the three lineage censuses only |
| **the census REGISTER, held every battery (R47)** | `expected/file_census.toml` is checked complete both ways against the universe by `gates/census_register.sh` (portable, ~1 s, 3 controls) through `bbx file-census --check-register` — a tracked harness file with no row FAILS, a dead row FAILS, and a STALE census is `NOTE: census-drift`, never fatal. It CANNOT prove a file is reached; that is the release-scoped gate's job |
| **the one definition of the bbh baseline (R43)** | `lib/sh/baseline.sh` (`bbx_baseline`), sourced by `gates/fidelity_bbh.sh`, `gates/fidelity_bbh_s2.sh`, `gates/suite.sh`; D20 names all three |
| **the file census tool** | `lib/py/bbx/file_census.py`, reached as `bbx file-census --self|--root DIR --out DIR [--document P] [--check] [--frozen P] [--freeze] [--only g1,g2] [--insert-after-shebang] [--shadow-refreeze "<cmd>"] [--reuse]`; `expected/file_census.toml` is the frozen register (44 rows, class `self`, shrink-only) |
| the four bins, every item | `docs/bins.md` (index + totals) → `docs/bins/{bbh,vampiresaved,sms}.md` |
| the abstraction as contracts | `docs/abstraction.md` |
| the generality proof (two non-frame kinds, their fixtures) | `docs/generality.md` |
| the fidelity plan, F12+ | `docs/fidelity.md`; re-baseline log `docs/rebaselines.md` |
| the slice sequence with the estimate | `docs/slices.md` |
| slice S2's plan (measured census of the lift, design, fidelity rows, controls, rulings R23–R26) | `docs/plans/S2.md` — built bbx-3/bbx-4 |
| **slice S3's plan** (the ancestors measured, the design contract by contract, the fixture, fourteen controls, rulings R31–R34) | `docs/plans/S3.md` — R31–R34 answered; **steps 1–5 built (bbx-7 … bbx-11); S3 ruled DONE by the maintainer 2026-09-10** (`docs/readout.md`, bbx-11: §7's six conditions in a table; the ruling recorded under it); §5's shifted-artifact row corrected at bbx-8 (G21), §5/§8.3's control placement at bbx-9 (X10), §5's nondeterminism row at bbx-10 (X11), §6's screen line at bbx-11 (X12) |
| **slice S4's plan** (the ancestors measured, the design contract by contract, the fixture `fixture/fakecli/`, eighteen controls, the adapters, the self subject, the file census as a gate, rulings R35–R40) | `docs/plans/S4.md` — bbx-12; R35–R40 answered 2026-09-10 (R40 with the TSV caveat); **steps 1–5 built (bbx-13, bbx-14, bbx-15, bbx-16, bbx-18)**; §3/§4 corrected at bbx-13 before step 1 landed (X14–X19, BBX-19); step 2 needed no correction; §2/§3/§5 corrected at bbx-15 before step 3 landed (X20, X21); §3/§6/§8 corrected at bbx-16 before step 4 landed (X22–X24); §7's feature-options row and §5's `--crash-at` row corrected at bbx-17 before R42's change landed (X25, BBX-19); §3/§4/§5/§8 corrected at bbx-18 before step 5 landed (X29–X34, six measured wordings); **step 6 is next** (the file census as a gate, R39) |
| **the command-line kind (S4 step 1)** | the profile `lib/py/bbx/config.py` KINDS `command-line` (D45; `log_summary = python3 -m bbx.cli summary` since step 2, D43); `[suite].scenario_ext = "cli"` (D34); the token vocabulary `lib/py/bbx/cli.py` (D47 — the ONE writer of every token); the fixture `fixture/fakecli/` (BBX's third consumer: `bbx.toml`, `mkfakecli.py --check` — the design's predicates on the tree's tool, regenerate-and-diff, and the TOOL-CHECK that runs `subject/fakecli.py` for every scenario against the design; `scenarios/*.cli` (D46), `expected/fixture/` with `truth` + `logs/`, `unordered`, `schema` json (D49), `band` (D48), the registry and the 22-row register); `gates/cli_fixture.sh` (4 controls) |
| **the command-line comparators (S4 step 3)** | `lib/py/bbx/compare_band.py` — the tolerant-numeric family over the driver's band view `<log>.bands` (D48, D53; `FAIL band <field>: <v> outside [<min>, <max>]`, the inventory both ways, `NOTE: band-fields <n>`; `--freeze <frozen> <proposed>` REFUSES to widen a band with no `rulings` entry and any inventory move, exit 3, the file unchanged — D55); the `tolerant-numeric)` branch and `compare_band` of `lib/sh/compare.sh` (the four S3 functions byte-identical); the json format of `compare_schema.py` (D49: keys both ways before any type, R40's seven types, `items_op`/`items_n`; the artifact is the driver's JSON view `<log>.json`, D54, handed by the kinds loop from the kind's view column since step 4, D57); the line row shape of `compare_set.py` (D56: `[l<i>] line, sha1`, compared by sha1 both ways; a wrong sha1 or a duplicate is hand-editing); `compare_exact.py`'s END rule counting the indices above zero (X20, G26); `bin/bbx compare band`; `gates/band.sh` (4 controls, ~4 s) and `gates/json_schema.sh` (5 controls, ~7 s), every verdict line frozen and classified, `finding.py` unchanged |
| **the suite over the command-line fixture (S4 step 4)** | the kinds table's VIEW column (D57: `-` / `log` / `subject` / `json` / `bands` — the fourth field of every `[expectations].kinds` row in `lib/py/bbx/config.py`, read by `lib/py/bbx/expectations.py` (`kinds` prints four fields, `view <ext>`; a three-field row refused on one line) and by `bin/bbx-run-suite` (`view_of`, `view_path` — THE ONE RESOLVER, checked at the entrance after the identity and before any scenario runs, handed to every family as `compare_check`'s artifact; the tolerant-numeric branch hands it to `compare_band`, which derives no path); `gates/cli_suite.sh` (7 controls: identity-before-any-scenario, nondeterministic-before-any-class three ways, crash-vs-refusal, wrong-truth, schema-before-any-value over the JSON view, band-through-the-loop, unknown-view; 43 printed lines frozen — `NOTE: band-fields 1` TWICE under 04_band, ruled KEPT at bbx-17 (R41); 15 suite runs, ~99 s); the readout's suite screen for the fixture: `fixture 21`, classes `band, exact, multiset, schema`, the exit / band-fields / emitted-files notes |
| **the two ADAPTERS (S4 step 5)** — an external framework and BBX ITSELF as subjects | `lib/py/bbx/adapters.py` (the two mappers over `bbx.cli`'s core: `resolve_set` — the set is a DIRECTORY on `CLI_PATH`, D58; `parse_cases` and `ran_count` reading the framework's STDERR by field, never the clock line; `read_results` reading a kept `results.tsv` BY COLUMN NAME; `fill` and `resolve_program` — the placeholders `{config}`/`{log}`/`{set}` and `$BBX_HOME/bin`, anything else REFUSED, D60; its own self-test, both directions on every check); `lib/py/bbx/cli.py`'s additions (`case`/`gate` in KINDS with two CLOSED verdict vocabularies D59, `token_case`/`token_gate`, `observation_tokens`/`crash_tokens`, `prepare_sandbox`/`exec_in_sandbox` as THE ONE place a subject process is started — three drivers share it — the `DRIVER` face so each refusal names its own driver, and `summary`'s two CONDITIONAL notes `cases <n>`/`gates <n>`, D43 amended); `drivers/unittest.sh` (`python3 -m unittest -v <modules>`, `PYTHONPATH` the set dir and nothing else, D61) and `drivers/gates.sh` (a harness program under `$BBX_HOME/bin` over a consumer directory); `fixture/unittest/` (BBX's FOURTH consumer: `mkunittest.py --check` runs the FRAMEWORK per scenario against the design; 8 cases in 2 modules covering all six verdict words, 4 scenarios, expectations class `derived`) and `fixture/selfgates/` (the FIFTH, whose subject is BBX: `mkselfgates.py --check` runs BBX's OWN runner per scenario and REPORTS A MOVED IDENTITY; 7 stub files, 6 registered portable in a deliberately unsorted order reading PASS SKIP PASS MISSING FAIL PASS, 1 static SKIP-or-PASS by its needs-env, 1 unregistered; `idkey.sh` is R38's identity, read through `$BBX_HOME`); `gates/adapters.sh` (6 controls, 9 firings, 42 ok lines, 14 suite runs, ~97 s) |
| **the command-line driver (S4 step 2)** | `lib/py/bbx/cli.py` — the driver's core beside the vocabulary: `selftest` (FIPS 180-1's vectors as the reference anchor, the layout, the splitter, the scenario reader's refusals), `resolve` (the ONE resolver over `CLI_PATH`: per directory an executable `<set>` over `<set>.py`), `run` (the sandbox as cwd, HOME and TMPDIR — D52; D6's set plus the scenario's `[env]` and nothing from the caller; `argv.txt` / `stdin.bin` / `env.txt` recorded, O5; the crash log `CRASH signal:<n>:<NAME>` / `END-CRASH <n>` and the band view `<out>.bands` — D53; the fixture's own control dies by SIGKILL since R42, which the host does not report, while a REAL subject that dies by a FAULT signal still leaves a host crash report the driver never removes — declared in its header, G30; the JSON view `<out>.json` — D54, step 3; `--nondet`, `--timeout`), `summary` (`NOTE: exit / band-fields / emitted-files`); `drivers/cli.sh` (D4's four exits: a tool's non-zero exit is an OBSERVATION, a signal death exit 2, REFUSED exit 3 for the three families, `CLI_KEEP_ENV`, a scenario key the grammar lacks, a bad `CLI_TIMEOUT`; `CLI_TIMEOUT` default 60 s, D51, exit 1 DISCARDED); `drivers/README.md`; `gates/cli_driver.sh` (7 controls; two points re-hashed by `shasum`; ~10 s) |
| **R21's step-by-step: running the battery on Linux or WSL** | `docs/platforms/README.md` (bbx-20; needs ONE bbh commit since R43, expects `census_recount` to SKIP, never `--strict`) |
| the maintainer readouts, one section per step, the CLOSE section last | `docs/readout.md` |
| **the document-set kind (S3)** | the profile `lib/py/bbx/config.py` KINDS `document-set` (D33); `[suite].scenario_ext` (D34) via `bbx.expectations scenario-ext`; the fixture `fixture/docset/` (BBX's second consumer: `bbx.toml`, `mkdocset.py --check` — writes the `truth` kind from the design, `subject/`, `claims/`, `expected/` with `logs/<s>.log` the truth logs); `gates/docset_fixture.sh` |
| **the document-set extractor and driver (S3 step 2)** | `lib/py/bbx/docset.py` (`selftest`, `run`, `map`, `summary`, and since step 3 `rows` — the run's rows joined by index with the map, proven the log's — and `resolve`, the ONE artifact resolver over `DOCSET_PATH`; the two strings and the token, D38; the forms' lexical classes and the record key, D39; the unlisted-claim guards, D40); `drivers/docset.sh` (`DOCSET_PATH` through `bbx.docset resolve`; REFUSED exit 3, DISCARDED exit 1); `drivers/README.md`; `gates/docset_driver.sh` (7 controls) |
| **the document-set comparators (S3 step 3)** | `lib/py/bbx/compare_exact.py` (the truth log against the run log BY INDEX; `FAIL-SHORT` apart from `FAIL exact: index <i> differs`, BBX-4), `compare_set.py` (a frozen multiset of `(document, line, form, status)` rows both ways — `claims` inventory, `covered` shrink-only with `NOTE: covered-grew`, R33; a duplicate named as hand-editing), `compare_schema.py` (the artifact's shape before any value: header names in order, one type per column from D41's vocabulary, the rows line; the FIRST violation named; a wrong column count a schema FAIL); the `exact) set) schema)` branches of `lib/sh/compare.sh` (`compare_check` takes two trailing arguments, the scenario file and the artifact); `bin/bbx compare exact|set|schema`; `gates/set_schema.sh` (5 controls; every verdict line frozen there and classified by `finding.py`, 38 lines) |
| **the suite's kinds loop and the kept run's notes (S3 step 4)** | `bin/bbx-run-suite` (the loop read off the kinds table: the temporal family means bbh's precedence loop verbatim, anything else the kinds loop — `schema` first, the table's order, `.sha1` last; `NOT-EVALUATED (schema failed)`; `--freeze` for the shrink-only kind through `bbx.compare_set --freeze`, never a self-freeze beside an authored kind); `notes.tsv` in the kept run (D44); `[suite].log_summary` (D43); `bbx.fingerprint --path` (the subject file, handed to the comparators); `finding.py`'s `NOT-EVALUATED` and `authored ` rules; the readout's suite screen (scenarios and pairings apart, `coverage:` per scenario, BBX-14 over pairings, the driver's blind spots); `gates/docset_suite.sh` (6 controls, 17 suite runs, ~55 s) |
| the controls contract (must-fire grammar, R10) | `docs/controls.md` |
| the defaults register (BBX-24) | `docs/defaults.md` |
| the kernel | `bin/bbx` (dispatcher, MEASURED at bbx-18 from `bbx help` and from what it refuses: `run-static run-suite classify tier config controls recount readout compare selftest file-census` — there is no `run-sweep` and no `fingerprint` subcommand; the sweep runner is `bin/bbx-run-sweep` and the fingerprint is `python3 -m bbx.fingerprint`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (BBX as its own consumer, kind `self`) |
| the expectation register (S2 step 4, R24) | `lib/py/bbx/provenance.py` over `<expected_dir>/PROVENANCE.toml` (D31); `gates/provenance.sh`; the readout's suite screen for a kept `bbx-run-suite --log` run (D32) |
| the comparison (S2 steps 1–3) | the temporal family `lib/py/bbx/compare_{flicker,window,composite}.py`, `check_diverge.py`, `propose_temporal.py`, `thresholds.py` (R25), `logfmt.py`; the one dispatcher `lib/sh/compare.sh` (R23: family by kind); the kinds table `lib/py/bbx/config.py` `[expectations].kinds` read by `lib/py/bbx/expectations.py` and `lib/sh/expectation_kinds.sh`; the suite `bin/bbx-run-suite` (`--log DIR`: results.tsv with a FINDING column, `lib/py/bbx/finding.py`; R26 driver home) |
| BBX's gates and registries | `gates/*.sh` (32 on disk, 31 REGISTERED in a tier the battery runs: 27 portable incl. `census_register` (R47), `file_census_tool`, `adapters`, `temporal`, `thresholds`, `compare_dispatch`, `expectation_kinds`, `provenance`, `docset_fixture`, `docset_driver`, `set_schema`, `docset_suite`, `cli_fixture`, `cli_driver`, `band`, `json_schema`, `cli_suite`; 4 static incl. `fidelity_bbh_s2` (F12, F16, F17) and `suite`; plus `file_census` in `gates/sweep.tsv` at the release scope, INSTRUMENT by `[tier].patterns` and so not an orphan) — the old row follows for its runtimes: (25 portable incl. `adapters`, `temporal`, `thresholds`, `compare_dispatch`, `expectation_kinds`, `provenance`, `docset_fixture`, `docset_driver`, `set_schema`, `docset_suite`, `cli_fixture`, `cli_driver`, `band`, `json_schema`, `cli_suite`; 4 static incl. `fidelity_bbh_s2` (F12, F16, F17) and `suite`), `gates/portable.txt`, `gates/static.txt`, `gates/sweep.tsv` (empty) — run with `BBX_BBH_HOME=~/Developer/blackbox-harness bin/bbx selftest` (**~10.5 min on this host since `adapters` joined at ~100 s: it no longer fits a ten-minute foreground command, so run it in the BACKGROUND and wait on its tally**; the two S2 static gates are ~100 s and ~60 s, `docset_suite` ~55 s, `cli_suite` ~95 s, `adapters` ~97 s) |
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

Nothing in the background. `BBX_BBH_HOME=~/Developer/blackbox-harness bin/bbx selftest`
takes **~11 min on this host** (31 registered gates) (30 registered gates since `file_census_tool` joined at ~13 s),
which is past the ten-minute cap on a foreground command: run it in the BACKGROUND and wait on
its tally. Read the tally off the KEPT RUN, not off a backgrounded pipe — a `| tail` keeps only
the tail AND hands you the pipe's exit instead of the tool's (G16, which bit again at bbx-19 and
hid a traceback). `bin/bbx readout <dir>` prints the whole screen from what was kept.

**`gates/file_census.sh` is NOT in the battery** and takes ~20 min: it is the first row of
`gates/sweep.tsv` at the release scope (D63). Run it deliberately, alone, with `BBX_BBH_HOME`
set, at a release or after a kernel change.

## The ritual (ruled R17 at the bbx-1 close, 2026-09-09; adapted from VampireSaved VSP-17/VSP-18/VSP-162)

Sessions are keyed `bbx-N`, one key per sitting, never renamed (pointers in
readouts, gotchas and history resolve through it). The last closed sitting is **bbx-20** (2026-09-12); the next is **bbx-21**.

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
   `--log build/selftest_<stamp>` and each IN THE BACKGROUND (it is ~11 min
   with 30 registered gates, past the foreground cap); BBX-14 needs two runs at one HEAD;
   the close quotes the tally line and the controls line verbatim, read off the
   kept run rather than off a screen that may have been truncated. Not green:
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

**Next-session orientation (written at the bbx-20 close, 2026-09-12)**
- Open first: the battery, **in the background** (~11 min, 31 registered gates),
  with `--log build/selftest_<stamp>`, alone; then `bin/bbx readout` on it. Two
  `drift` NOTEs are expected for the lineage censuses; re-read the NOTE rather
  than any line here.
- **S4's build is COMPLETE. Step 7, the slice readout, is next and is the last of
  the slice** (`docs/plans/S4.md` §8.7), after which S4 goes to the maintainer for
  a DONE ruling as S3 did.
- **R44's and R46's builds are ONE step, not two.** Both touch the single identity
  key that `fixture/selfgates/idkey.sh`, `lib/py/bbx/file_census.py` and the census
  document all read: R46 puts its definition in one place, R44 makes the refreeze a
  printed step (the gate printing the identity it computed and the row it matched;
  on a mismatch that is already RED with both keys, measured twice at bbx-19, so
  only the PASSING half may be missing — measure before writing). Built together or
  they fight each other.
- **THREE THINGS now move on a commit touching `bin`, `lib`, `drivers` or `gates`**:
  the self subject's registry row (R38, R44 — `gates/adapters.sh` RED until the
  reviewed refreeze), the census's key (D62 — the document and register stale), and
  since R47 the BATTERY ITSELF if that commit adds a harness FILE, because
  `gates/census_register.sh` fails on a file with no frozen row. A commit touching
  only `docs/`, `expected/` or `fixture/` moves none of them.
- **The order that avoids paying twice** — learned three times at bbx-20, each
  costing a twenty-minute run: land every code change FIRST, then the census
  regeneration, then commit the document and register (docs-only, the key holds),
  then the fixture refreeze (fixture-only, the key still holds), then the battery
  twice. And **prove any instrument change on a two-gate `--only` probe** (seconds)
  before paying for a full run.
- **R45 is rescoped and waiting** (three directions over three registries; the
  tier-listing fix measured and RULED OUT because F13e diffs that listing). R21
  still needs a Linux or WSL host.
- If the census cadence starts to bite, the lever is its RUNTIME, not the gates:
  most of the twenty minutes is five heavy gates in the shadow, and nothing the
  register check does depends on them. Worth measuring before it becomes a
  complaint; not a ruling today.

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

- A deliberate signal death inside a gate reaches the HOST. A subject that dies by a FAULT signal (SIGABRT, SIGSEGV, SIGILL, SIGBUS, SIGTRAP, SIGFPE, SIGSYS) makes macOS write a ~10 KB crash report into `~/Library/Logs/DiagnosticReports/`, OUTSIDE the sandbox the driver removes and outliving the run; SIGKILL and SIGTERM are not reported. The fixture's `--crash-at` dies by SIGKILL for exactly that reason (R42). A new control that needs a fault signal starts filing crash reports on the maintainer's machine again — 25 of them accumulated over two days and the maintainer, not a gate, was the detector (G30). Count `ls ~/Library/Logs/DiagnosticReports/*.ips | wc -l` before and after any new signal control, and expect zero growth.
- `~/Library/Logs/DiagnosticReports/Retired/` holds the older reports: a census of crashes must read BOTH directories or it reads two days as one (bbx-17: `find -name '*.ips'` counted 93 where the top directory listed 2, and the 91 were the Retired subtree).
- `/Users/koneko/.git` exists: HOME is a git repository. Commands run outside
  a nested repository see the whole home tree. Not ours; do not touch.
- The fidelity baseline is the commit, not the tree (R8): a moved bbh tip is a NOTE, measured first by the D20 override (`BBX_BBH_BASELINE=<tip>`, which THREE gates read: `fidelity_bbh`, `fidelity_bbh_s2` and `suite` — measured at bbx-18, G32, R43 open), then followed by the procedure in `docs/rebaselines.md` (R28: a dated line, D20, D12 by definition, the census) — never a queue entry.
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
- The battery takes ~10.5 min since `gates/adapters.sh` joined it, which is PAST the 10-minute cap on a foreground command: run it with `run_in_background` and wait on its tally, and remember that a backgrounded pipe through `tail` keeps only the tail — the kept run under `build/selftest_<stamp>` is where the whole thing lives, and `bin/bbx readout` on it prints the tally, the controls line and the blind spots (bbx-18 lost a battery's screen that way and read it back off the kept run).
- A commit that touches `bin`, `lib`, `drivers` or `gates` moves the self subject's identity and leaves `gates/adapters.sh` RED until the registry row is refrozen (R38, R44): 22 of BBX's first 53 commits would have done it. The refreeze is one line, reviewed, and must be the sitting's last commit.
- This session's shell is zsh, where a bare `$c:lib` applies the history modifier `:l` and reaches the command as `headib`: `git rev-parse "$c:bin" "$c:lib" "$c:drivers"` silently measured TWO of three trees and printed a plausible 40-hex key (G33). `${c}:lib`, `"$c":lib` and `/bin/sh -c` are correct. Never build a measurement's command line from a variable followed by a colon in this shell.
- A wait loop must not be able to match ITSELF: `until ! pgrep -f 'bbx-run-static --config'; do sleep 15; done` never exits, because `pgrep -f` reads full command lines and the watcher's own line contains the pattern (G37 — four of them were still sleeping after the bbx-18 close and were killed by PID). Use `pgrep -f '[b]bx-run-static'`, or watch the run's OUTPUT FILE for the tally, which is what the next step reads anyway.
- `bbx controls report <gates_dir> <logs_dir> <name>` reads `<logs_dir>/<name>.out`, not `<name>.log` — a missing file is read as ZERO firings and the report says `fired=0 dead=N verdict=RED`, which looks exactly like a gate whose controls all died (bbx-18 chased that for one run).
- The gates adapter's subject is a runner, and a static runner's `static_needs_env` must RESOLVE as a directory: a value that does not makes the runner exit 2 with no `results.tsv` before any gate runs, so a scenario that sets it points it inside the sandbox (`"."`).
- A gate handed a working directory by its caller is not the same as a gate that `cd`-ed there: `pwd` reports the PHYSICAL path in the first case and the LOGICAL one in the second, so on macOS a tree under `TMPDIR` is `/private/var/...` to one and `/var/...` to the other. A string comparison between the two is False, silently, for every path. The file census read 30 of 44 harness files as "executed by NO gate" that way — a plausible number and pure garbage (G43, BBX-16). Compare `os.path.realpath` on BOTH sides, and never trust a path comparison that crosses a process boundary.
- A generated artifact that LIVES IN the tree it describes must not be keyed by that tree's commit: the commit that writes the artifact moves the key, so its own `--check` fails for ever after (G42). Key it by the identity of what it DESCRIBES — for BBX's harness that is R38's whole-set key, which a docs-only commit leaves alone (D62).
- A runtime does not belong in frozen text. Twelve of thirty gate runtimes moved between two runs whose every other field was identical, so a checked block carrying seconds can never be stable; BBX-14 says the answer is to drop the field, never to let the check excuse it (bbx-19).
- `git commit` exits 1 when there is nothing to commit, and under `set -e` that ends a gate silently — four controls unfired, a log that simply STOPS, and an exit the classifier correctly reads as FAIL with no reason printed (G40). Guard housekeeping commits with `|| true`, and read a log whose last line is a section header as a crash.
- A retraction pattern must fit on ONE line: `lib/py/bbx/close_sweeps.py` searches per line, so a pattern containing a newline can never match and the row is a dead control that reads as a clean zero (G41). Plant every new pattern in a scratch copy and require it to fire before believing `retraction_hits=0`.
- The census's shadow is an INSTRUMENTED harness, so any subject whose expectations are keyed by its own content legitimately moves inside it. `--shadow-refreeze` re-derives them in the throwaway copy, after the shadow's first commit because the key is of the COMMIT (G38). A subject like that cannot be instrumented without such a step, and the step belongs in the copy and nowhere else.
- A gate that asserts something about a GENERATED artifact must be asked whether its question still means anything inside the generator's own copy of the tree. The census runs the whole battery against an instrumented shadow of itself, and it COMMITS its own `lib/py/sitecustomize.py` there — so a gate checking that every harness file has a census row read FAIL in every shadow, the contamination rule discarded the run, and the register became completable only by a run that could not complete (G46). The instrument now exports `BBX_FILE_CENSUS_SHADOW=1`, such a gate SKIPs with its reason, and a SKIP does not contaminate but IS named in the checked text. This is the second instance of the shape (G38 was the first); a third should become a contract line in `docs/controls.md`, not a third ad-hoc fix.
- A read-only proof must compare against what it asserts about, not against `git status`. `gates/census_register.sh` checked the register with `git status --porcelain` and so reported ITSELF writing a file the census had legitimately left uncommitted — the normal state straight after a census run, which is exactly when that gate runs. Take the file's sha1 before and compare after (bbx-20).
- Three defects at bbx-20 shared one shape: a check whose non-zero exit had TWO possible causes and could not tell them apart (a control whose copy inherited a real failure, a run refused for a reason the shadow guaranteed, a read-only proof reading a legitimate edit). When a check can fail two ways, make it name which.


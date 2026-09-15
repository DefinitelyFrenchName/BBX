# Gates — the index (GENERATED)

Shape: generated, written by `bbx gate-index --config bbx.toml` from each gate's own header, the family
register `gates/families.toml` and the registries, never hand-edited: `bbx gate-index --check`, run by
`gates/gate_index.sh`, fails when this page is stale. One row per gate under `gates/`, grouped by family:
`locks` is the first paragraph of the gate's header, cut near 240 characters; `needs` is nothing for a
portable gate, the static tier's variable for a static one, and for an instrument gate the runtime its
header quotes; `since` is the first session its header names; `controls` its declared must-fire controls
by shape; `blind spots` the count of its `NOT-ASSERTED:` lines. Reachable from `HANDOFF.md`.

**40 scripts** — 33 portable, 6 static, 1 instrument-tier (run by name).

| family | scripts | what the family is |
|---|---|---|
| [runner](#runner) | 9 | the runners, the classifier, the tiers, the controls contract and the readout: the kernel's own ground truth |
| [comparison](#comparison) | 8 | the comparator families, their dispatch, the expectation kinds and the provenance register |
| [kinds](#kinds) | 8 | the subject kinds end to end: fixtures, drivers, suites and the two adapters |
| [fidelity](#fidelity) | 4 | the lineage pairs: BBX's lifted tools against bbh's over the same inputs |
| [census](#census) | 4 | the censuses: the lineage's counts and BBX's own file census |
| [registers](#registers) | 7 | the registers and the pages: rulings, close sweeps, skills, defaults, documents, rot, the gate index, the trap lint and the references in the current pages |

## runner

the runners, the classifier, the tiers, the controls contract and the readout: the kernel's own ground truth.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/classify.sh` | test | portable | — | the verdict classifier's verdicts mean what they say, in both directions Ground truth for lib/sh/classify.sh through bin/bbx-classify: every verdict case both runners depend on, each with a case that must NOT produce it (BBX-2: | — | 1 known-bad | 1 |
| `gates/config.sh` | test | portable | — | the config reader accepts the TOML subset, refuses every ambiguous construct, and resolves defaults through the kind profile Ground truth for lib/py/bbx/toml_subset.py and lib/py/bbx/config.py: | — | 1 known-bad | 1 |
| `gates/controls.sh` | test | portable | — | a declared must-fire control that does not fire, or a firing nobody declared, makes the runner NOT GREEN; silence is red under enforcement and invisible without it; a correct SKIP sets its declarations aside and nothing else (R48); | 2026-09-13 | 5 known-bad, 1 shadow-tool | 2 |
| `gates/fingerprint.sh` | test | portable | — | the subject identity is computed from the artifact: the dual key, the registry lookup, the config's regex and region rules, and the three kinds Ground truth for lib/py/bbx/fingerprint.py on SYNTHETIC images (no ROM): | 2026-09-09 | 2 known-bad | 1 |
| `gates/readout.sh` | test | portable | — | the readout screen says what the kept run says — verdict, counts reconciled with the run's own tallies, controls, blind spots, BBX-14; | 2026-09-13 | 9 known-bad, 5 perturbed-copy | 6 |
| `gates/registry_complete.sh` | test | portable | — | BBX-9's orphan direction has a VERDICT: every gate on disk is in the registry its tier needs, every sweep row names a gate that exists, and every registered gate on disk is executable (R45, G91) Ground truth for `bbx tier <config> --complet… | bbx-22 | 4 known-bad | 4 |
| `gates/static_runner.sh` | test | portable | — | the static runner's verdicts, tally, exit status, --strict, MISSING, the anti-orphan report and the static-tier gating mean what they say Ground truth for bin/bbx-run-static, run against a SYNTHETIC consumer of stub gates of known verdicts… | — | 2 known-bad | 2 |
| `gates/sweep_runner.sh` | test | portable | — | the sweep runner's lanes, verdicts, placeholders, anti-orphan check, --strict, the prereq STOP, scope, cadence, timeouts, --resume, the exported env default, the pull queue and clone-per-slot mean what they say Ground truth for bin/bbx-run-… | 2026-09-09 | 3 known-bad, 1 shadow-tool | 4 |
| `gates/tier.sh` | test | portable | — | the tier classifier sees an instrument reached directly or through sourced libs to the configured depth, and no further Ground truth for lib/py/bbx/tier.py. Cases lifted from bbh selftest/test_tier.sh, each paid for in the lineage: | — | 1 known-bad | 1 |

## comparison

the comparator families, their dispatch, the expectation kinds and the provenance register.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/band.sh` | test | portable | — | the tolerant-numeric family holds both ways on the command-line fixture: a band field's value inside its measured band PASSes with the inventory as a NOTE, a value outside FAILs naming the field, the value and the band, the band inventory i… | bbx-25 | 1 known-bad, 2 perturbed-copy, 1 shadow-tool | 4 |
| `gates/compare_dispatch.sh` | test | portable | — | the one dispatcher runs every temporal class in both directions from its spec line, refuses a baseset/mask mismatch, an unknown class and a kind with no family, and takes its mask default from the profile Ground truth for lib/sh/compare.sh… | 2026-09-10 | 3 known-bad | 2 |
| `gates/expectation_kinds.sh` | test | portable | — | every expectation kind is named from the profile's one table, a pending and an unknown kind make the enumeration red, a non-scenario stem is ignored, and a kind whose family the profile lacks is unknown under it Ground truth for lib/sh/expe… | 2026-09-10 | 3 known-bad | 2 |
| `gates/json_schema.sh` | test | portable | — | the schema family's second format and the set family's second row shape hold both ways on the command-line fixture: a JSON object's shape is judged before any value (a key renamed by a shadow tool FAILs schema naming the frozen key, its val… | bbx-25 | 3 perturbed-copy, 2 shadow-tool | 4 |
| `gates/provenance.sh` | test | portable | — | the expectation register is complete both ways, every row names one class of the eight and no file twice, a testimony row is named as not evidence, and a register the subset refuses is a FAIL, never a pass Ground truth for lib/py/bbx/proven… | — | 5 known-bad | 2 |
| `gates/set_schema.sh` | test | portable | — | the document-set kind's three comparator families hold both ways on the fixture: exact BY INDEX with short apart from diverged, set both ways (inventory) and shrink-only (covered), schema before any value; | bbx-25 | 4 perturbed-copy, 1 shadow-tool | 3 |
| `gates/temporal.sh` | test | portable | — | the temporal comparison family accepts exactly its frozen shapes and rejects everything laxer, in both directions, on synthetic logs Ground truth for lib/py/bbx/compare_flicker.py, compare_window.py, compare_composite.py, check_diverge.py a… | 2026-09-10 | 4 known-bad | 4 |
| `gates/thresholds.sh` | test | portable | — | the temporal thresholds are declared once, every importer resolves to that declaration, a consumer override reaches the proposer and the enforcers alike, and a LOOSER value without a ruling is refused by every one of them (R25) Ground truth… | 2026-09-10 | 2 known-bad, 1 shadow-tool | 2 |

## kinds

the subject kinds end to end: fixtures, drivers, suites and the two adapters.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/adapters.sh` | test | portable | — | THE TWO FRAMEWORK ADAPTERS end to end: an external test framework and BBX ITSELF are subjects of this harness, each driven by a driver of the command-line kind over the same core, each GREEN twice on its fixture with every printed line froz… | 2026-09-11 | 5 known-bad, 1 perturbed-copy | 8 |
| `gates/cli_driver.sh` | test | portable | — | the command-line driver's log equals every truth log of the fixture byte for byte, twice, with two points re-hashed by a second implementation; | 2026-09-10 | 6 known-bad, 1 perturbed-copy | 5 |
| `gates/cli_fixture.sh` | test | portable | — | the command-line fixture equals its generator, is chiral, and its tool does what the design says on every scenario; its consumer config resolves to the command-line profile with the four new kinds and the `cli` scenario extension; | — | 1 known-bad, 2 perturbed-copy, 1 shadow-tool | 2 |
| `gates/cli_suite.sh` | test | portable | — | the suite drives the command-line fixture end to end and is GREEN twice on it: the kinds loop's SECOND consumer, every EVAL kind of a scenario its own pairing in the printed shape frozen here, the JSON view and the band view reaching their… | 2026-09-11 | 4 known-bad, 2 perturbed-copy, 1 shadow-tool | 5 |
| `gates/docset_driver.sh` | test | portable | — | the document-set driver binds every claim of the fixture to the design's truth, byte for byte and twice; the extractor's self-test, the closed status vocabulary, the denominator, the guards and the refusals each fail where they must Ground… | bbx-25 | 3 known-bad, 3 perturbed-copy, 1 shadow-tool | 6 |
| `gates/docset_fixture.sh` | test | portable | — | the document-set fixture equals its generator and is chiral, its consumer config resolves to the document-set profile with the four new kinds and the `claims` scenario extension, and a kind the profile does not carry is unknown under it Gro… | — | 1 known-bad, 2 perturbed-copy | 2 |
| `gates/docset_suite.sh` | test | portable | — | the suite drives the document-set fixture end to end and is GREEN twice on it: every EVAL kind of a scenario is its own pairing in the printed shape frozen here, the kept run keys its rows (scenario, kind) and carries the coverage numbers t… | 2026-09-10 | 3 known-bad, 3 perturbed-copy | 4 |
| `gates/suite.sh` | test | static | BBX_BBH_HOME | the suite's verdicts mean what they say on the fake machine: every printed line in its own words, a perturbed expectation turns it RED, nondeterminism and a failed run are named before any class, the environment is scrubbed, the kept run co… | 2026-09-10 | 4 known-bad, 1 perturbed-copy | 3 |

## fidelity

the lineage pairs: BBX's lifted tools against bbh's over the same inputs.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/fidelity_bbh.sh` | test | static | BBX_BBH_HOME | the generic runners, classifiers and the fingerprint reproduce bbh's verdict text byte for byte over bbh's own fixtures (F13, F14, F15) THE FIDELITY OBLIGATION (CLAUDE.md §2, §7.2; docs/fidelity.md): | 2026-09-09 | 1 perturbed-copy | 3 |
| `gates/fidelity_bbh_s2.sh` | test | static | BBX_BBH_HOME | the lifted suite, dispatcher and temporal family reproduce bbh's verdict text byte for byte over the same inputs (F12, F16, F17) THE FIDELITY OBLIGATION for slice S2 (CLAUDE.md §7.2; docs/fidelity.md): | 2026-09-10 | 3 perturbed-copy | 3 |
| `gates/fidelity_bbh_s5.sh` | test | static | BBX_BBH_HOME | BBX's lifted skills lock and guide generator reproduce bbh's verdict text byte for byte over the same skills (F18) THE FIDELITY OBLIGATION for slice S5 (CLAUDE.md §7.2; docs/fidelity.md F18; ruling R56): | — | 1 perturbed-copy, 1 shadow-tool | 5 |
| `gates/fidelity_bbh_s6.sh` | test | static | BBX_BBH_HOME | BBX's lifted gate index and trap lint reproduce bbh's printed text and exit byte for byte over bbh's example and bbh's own selftest cases (F19) THE FIDELITY OBLIGATION for S6's two lifts (CLAUDE.md §7.2; docs/fidelity.md F19; | — | 1 perturbed-copy, 1 shadow-tool | 5 |

## census

the censuses: the lineage's counts and BBX's own file census.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/census_recount.sh` | test | static | BBX_BBH_HOME | every count in docs/census/*.md reproduces at the recorded HEAD of its repository, on a clone For each census file, every §A row whose count is a plain integer or a quoted string and whose command is one shell pipeline is re-run from the ro… | 2026-09-09 | 3 known-bad, 1 perturbed-copy | 2 |
| `gates/census_register.sh` | test | portable | — | every tracked harness file has a frozen census row and every row names a file that exists, checked on EVERY battery Ruled R47 (2026-09-12). | 2026-09-12 | 3 perturbed-copy | 4 |
| `gates/file_census.sh` | test | instrument | ~20 min | every harness file of BBX is executed by a gate, the kinds that reach it have not shrunk, and the census document is the run's own text THE MEASUREMENT (R39, S4 step 6; the instrument's ground truth is gates/file_census_tool.sh). | — | 1 known-bad, 2 perturbed-copy | 6 |
| `gates/file_census_tool.sh` | test | portable | — | the file-census INSTRUMENT measures what a gate executes, refuses a contaminated run, and fails on every frozen row that moved Ground truth for lib/py/bbx/file_census.py (R39, S4 step 6). The subject is a SYNTHETIC harness tree built here: | — | 3 known-bad, 2 perturbed-copy | 4 |

## registers

the registers and the pages: rulings, close sweeps, skills, defaults, documents, rot, the gate index, the trap lint and the references in the current pages.

| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |
|---|---|---|---|---|---|---|---|
| `gates/close_sweeps.sh` | test | portable | — | the close ritual's sweeps run as a check: no retracted claim stated as current, no deferral in prose, no default cited without a register row, no header entry that runs past its one line HANDOFF.md step 8 was hand-run at every close until b… | bbx-2 | 4 known-bad | 3 |
| `gates/gate_index.sh` | test | portable | — | docs/gates.md is the current generated index of BBX's gates, and the lifted generator fails where it must: a stale index, a CRLF copy, a gate with no family, a dead or doubled family row, and columns only where the config names them Ruled R… | bbx-30 | 1 known-bad, 5 perturbed-copy | 4 |
| `gates/references.sh` | test | portable | — | the paths, file:line citations and G, X and R ids in the pages that state what is true now resolve, and every finding the check can print fires on a planted copy Ruled R64 and R67 (S6 step 4, bbx-31). | bbx-31 | 10 perturbed-copy | 6 |
| `gates/registers.sh` | test | portable | — | the defaults, documents and rot registers hold against the code, the pages and the gates they name, and every finding each check can print fires on a planted copy Ruled R61, R62 and R66 (S6 step 2, bbx-29), and R64 (S6 step 4, bbx-31). | bbx-29 | 36 perturbed-copy | 10 |
| `gates/rulings_shape.sh` | test | portable | — | every ruling sits under the heading of its state, and the queue and DECISIONS.md agree both ways docs/rulings.md is a document BBX reads (R14): | — | 4 known-bad | 1 |
| `gates/skills.sh` | test | portable | — | the skills lock fires on every perturbation of a synthetic consumer, refuses a wrapped definition, and reads a plain integer under the integers vocabulary; the ledger reader derives which rules the incident ledger re-anchors; | bbx-26 | 10 known-bad, 34 perturbed-copy | 12 |
| `gates/trap_lint.sh` | test | portable | — | no BBX shell file carries a ${VAR:?} demand after its EXIT trap, and the lint lifted from bbh fails where it must: a demand after the trap, a missing directory, a shell file with no .sh name Ruled R63 (S6 step 3, K8). | bbx-30 | 3 known-bad | 4 |

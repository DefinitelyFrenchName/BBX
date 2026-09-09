# Bins — blackbox-harness (census docs/census/bbh.md @ f675710) — 2026-09-09

Shape: table, one row per census B item, ids identical to the census. Bins per CLAUDE.md §5. Every `drop` carries a reason. Totals at the end are produced by the command shown.

| id | item (≤ 80 chars) | bin | becomes / reason |
|---|---|---|---|
| B-R1 | [BBH-1] The extraction question decides every bin. | generalize | the question widens: not frame-driven, not software, not executable (CLAUDE.md §5) |
| B-R2 | [BBH-2] No untested change survives. | keep | BBX-26 no untested change |
| B-R3 | [BBH-3] Every in-instrument measurement becomes a rerunnable case before the se… | keep | §6 ritual: every in-session measurement becomes a rerunnable case |
| B-R4 | [BBH-4] Verdict logic is itself tested, in both directions. | keep | BBX-2 verdict logic proved in both directions |
| B-R5 | [BBH-5] A field report is a RECORDING before it is a theory. | generalize | witness → reproducible SCENARIO (BBX-28); the recording is the frame kind's capture |
| B-R6 | [BBH-6] SKIP is not PASS. | keep | BBX-1 SKIP asserts nothing |
| B-R7 | [BBH-7] A red gate is a QUESTION whose first question is which side rests on a… | keep | a red gate is a question: which side rests on a measurement |
| B-R8 | [BBH-8] When a claim changes, grep for the claim. | keep | BBX-22 sweep the claim's wording |
| B-R9 | [BBH-9] The docs stay LEAN and are searched by KEY; the complete LOG lives in `… | keep | BBX-20 living page + history twin |
| B-R10 | [BBH-10] The doctrine is not a tuning guide and not a claim about correctness. | keep | the doctrine locks currency, never correctness (§3.3) |
| B-R11 | [BBH-11] The runners read a gate's NAME, EXIT STATUS and OUTPUT — never its cod… | keep | G1 runners read NAME / EXIT / OUTPUT |
| B-R12 | [BBH-12] Exit status decides FIRST. | keep | BBX-1 exit decides first |
| B-R13 | [BBH-13] The timeout wrapper's exits are TIMEOUT, never FAIL, | keep | BBX-1 TIMEOUT is its own verdict |
| B-R14 | [BBH-14] Exit 0 after the shell's OWN error line is a CRASH, not a PASS. | keep | G1 exit 0 after the shell's own error line is a crash |
| B-R15 | [BBH-15] The SKIP marker is a line matching the skip regex on exit 0, and the w… | keep | G1 the marker is a regex, prose is not a marker |
| B-R16 | [BBH-16] `--strict` makes SKIP fatal: | keep | G1 --strict makes SKIP fatal |
| B-R17 | [BBH-17] A demand is placed BEFORE any trap, and after a trap is armed a demand… | keep | gate-authoring law under the R3 portability floor (bash 3.2) |
| B-R18 | [BBH-18] Line 2 of a gate is an API: | keep | G2 line 2 is the claim |
| B-R19 | [BBH-19] A header names the default its CODE uses. | keep | G2 the header names the default the code uses |
| B-R20 | [BBH-20] A gate ends with ONE verdict line of its own | keep | G2 one verdict line of the gate's own |
| B-R21 | [BBH-21] Every gate that asserts a property carries a MUST-FIRE control | keep | G3 the must-fire control, now declared and machine-read |
| B-R22 | [BBH-22] A gate that is in no registry is not run. | keep | G4 registered or not run |
| B-R23 | [BBH-23] Whether a gate reaches an instrument is decided TRANSITIVELY | keep | G4 instrument reach decided transitively |
| B-R24 | [BBH-24] The harness will NOT read a gate's code, guess a skip from prose, coun… | keep | the harness's refusals: no code reading, no prose skip, no self-skip pass |
| B-R25 | [BBH-25] A driver has four arguments — `<set> <replay> <out.log> [sandbox]` — a… | generalize | D1 `<subject-set> <scenario> <out> [sandbox]` — shape unchanged, operands generalized |
| B-R26 | [BBH-26] The build under test is what the driver's SEARCH PATH resolves, | generalize | S2 the build under test is what the SUBJECT SET's search path resolves |
| B-R27 | [BBH-27] The output log is REMOVED before the run, | keep | D5 the out file is removed before the run |
| B-R28 | [BBH-28] A driver that cannot honour a variable REFUSES it — `REFUSED: <driver>… | keep | D3 REFUSED … exit 3, never ignore |
| B-R29 | [BBH-29] The replay family is one vocabulary for every driver: | generalize | D2 the SCENARIO-VARIABLE family, declared per KIND PROFILE |
| B-R30 | [BBH-30] A masked log is a BASIS: | generalize | O2 BASIS: two observations under different bases are not comparable |
| B-R31 | [BBH-31] The video log is a SECOND hash log over the framebuffer, in the same g… | generalize | O4 a second-view OBSERVATION is another file in the same grammar |
| B-R32 | [BBH-32] The input-integrity assertion is always on, and it has a must-fire: | generalize | O5 integrity: what was fed vs what the SCENARIO scripted, with a must-fire |
| B-R33 | [BBH-33] The log grammar is `<frame> <hash>` per frame then `END <n>`, | generalize | O1 `<point> <token…>` then `END <n>`; frame → OBSERVATION POINT |
| B-R34 | [BBH-34] The four exits mean four things: | keep | D4 the four exits |
| B-R35 | [BBH-35] The suite scrubs the replay family from its environment before any dri… | generalize | D2 the suite scrubs the KIND's scenario-variable family before any driver runs |
| B-R36 | [BBH-36] The sandbox is the machine's home | generalize | D5 the sandbox is the SUBJECT's home; a fresh temp dir when omitted |
| B-R37 | [BBH-37] A second implementation of the same machine is a driver under the same… | generalize | D6 a second implementation of the SUBJECT is a driver under the same contract |
| B-R38 | [BBH-38] A mask is a basis, not a flag: | generalize | O2 a BASIS, not a flag |
| B-R39 | [BBH-39] Every non-exact class is a MEASURED MECHANISM with a FROZEN expectatio… | keep | C1 every non-exact class is a measured mechanism with a frozen expectation |
| B-R40 | [BBH-40] Flicker-tolerated asserts that the divergent frames are EXACTLY the fr… | generalize | the temporal COMPARATOR family (flicker) — one family among several |
| B-R41 | [BBH-41] The frozen first-divergence constant asserts line-identity through `fr… | generalize | temporal family: frozen first divergence |
| B-R42 | [BBH-42] The bounded re-convergent window asserts ONE contiguous run, a FIXED o… | generalize | temporal family: bounded re-convergent window |
| B-R43 | [BBH-43] Composite is the strict CONJUNCTION of flicker and window: | generalize | temporal family: composite is the strict conjunction, never a widening |
| B-R44 | [BBH-44] The re-convergence rule is INTRA-mechanism: | generalize | temporal family: re-convergence is intra-mechanism; a class never composes across mechanisms |
| B-R45 | [BBH-45] A divergence that does not re-converge is NOT expressible in the vocab… | keep | C6 not expressible means root-cause, never a widened class |
| B-R46 | [BBH-46] A replay is reclassified to a looser class only with a NEW MEASURED ME… | keep | E6 / BBX-13 looser only with a new measured mechanism and a ruling |
| B-R47 | [BBH-47] The standing watch: flickers growing beyond the frozen inventory, or d… | keep | BBX-13 a growing tolerance inventory means stop and root-cause |
| B-R48 | [BBH-48] The proposer and the enforcers cannot disagree: | keep | C5 proposer = enforcer, thresholds imported once |
| B-R49 | [BBH-49] Whole-state frame-exact remains the standard | generalize | exact over the whole OBSERVATION at every point is the standard; each SCENARIO twice (O6) |
| B-R50 | [BBH-50] A self-frozen expectation answers "did this build change since I froze… | keep | E4 a self-frozen expectation can never see a regression against a reference |
| B-R51 | [BBH-51] A `.pending` expectation is REPORTED as unevaluated, never silently sk… | keep | E2 / BBX-3 unratified reads red |
| B-R52 | [BBH-52] Every frozen expectation FILE has a row in a register naming what it d… | keep | E3 a register row per frozen file: what, which closed class, how to re-freeze |
| B-R53 | [BBH-53] The evidence classes are a policy, not a format, | keep | §3.3 provenance is a policy, not a format; vocabulary closed by ruling R11 |
| B-R54 | [BBH-54] A hard-coded path default the script READS as an image must not have R… | generalize | ref-rot over any referenced SUBJECT ARTIFACT, not only an image |
| B-R55 | [BBH-55] CURRENCY is the other question and it is REPORTED, never failed: | keep | §3.3 currency is reported, never failed |
| B-R56 | [BBH-56] A pick among several files is sorted first and then an ORDERED, NAMED… | keep | resolution is sorted first, then an ordered, named preference |
| B-R57 | [BBH-57] The gate index is GENERATED from every gate's own header plus one hand… | keep | R1/R2 generated from headers plus one hand table, complete both ways |
| B-R58 | [BBH-58] A battery cannot print GREEN while a gate self-skipped: | keep | BBX-1 no GREEN over a self-skip |
| B-R59 | [BBH-59] A perturbation control edits a SHADOW COPY of the tool under a throwaw… | keep | G3 control shape: a perturbed shadow copy under a throwaway root |
| B-R60 | [BBH-60] The one header parser is the only reader of headers, | keep | BBX-12 one reader, by field name |
| B-R61 | [BBH-61] Every key has a default and a BIN it came from, listed in one referenc… | generalize | the DEFAULTS REGISTER gains a provenance class (BBX-24); bbh carries origin only |
| B-R62 | [BBH-62] A missing key with no default is FATAL, never silent: | keep | a missing key with no default is fatal, never silent |
| B-R63 | [BBH-63] The config is a TOML SUBSET, refused where it is ambiguous: | keep | the config subset is refused where it is ambiguous (R3 floor) |
| B-R64 | [BBH-64] The thresholds are a consumer's RATIFIED comparison policy, not tuning… | keep | thresholds are a ratified comparison policy, not knobs (held per KIND PROFILE) |
| B-R65 | [BBH-65] A board is never implied: | generalize | S1 a KIND is never implied; a driver refuses to run without one |
| B-R66 | [BBH-66] A consumer config that lives outside the tree it describes carries ONE… | keep | a consumer config outside the tree it describes carries one host's layout |
| B-R67 | [BBH-67] Registry rows are written only at freeze time, as a build decision | keep | R3 registry rows are written at freeze time as build decisions |
| B-R68 | [BBH-68] The sweep registry declares a release's instrument scope: | keep | R2 the sweep registry declares a release's instrument scope |
| B-R69 | [BBH-69] A recording is a directory of four things | generalize | a captured case is a bundle — scenario, initial state, note, defect — per KIND |
| B-R70 | [BBH-70] A default that names one host's file, one project's build or one linea… | keep | BBX-24 the biased default: a host/build/lineage default is a dated assertion |
| B-R71 | [BBH-71] Every board literal lives in ONE machine-profile table | generalize | S1 every KIND literal lives in ONE KIND PROFILE table |
| B-R72 | [BBH-72] Two guards on one board must draw the same sketch of one crash: | generalize | two instruments (or two modes of one) over one event must draw the same report |
| B-R73 | [BBH-73] One strict grammar, whose two copies are diffed: | keep | O3 one strict grammar, its two copies diffed |
| B-R74 | [BBH-74] Input staging is CANONICAL | generalize | the driver stages a SCENARIO canonically, in one place, per KIND |
| B-R75 | [BBH-75] A memory tap is dropped silently whenever the machine re-installs hand… | consumer | MAME memory-tap mechanics; its general form is BBX-6/BBX-7 (a silent instrument needs a positive control) |
| B-R76 | [BBH-76] A written value and a read value are correlated in ONE run through a n… | consumer | MAME read-and-write tap mechanics |
| B-R77 | [BBH-77] Every reproducible crash is captured as a recording named after the fr… | generalize | BBX-29 a captured case is keyed by the SUBJECT VERSION it was played on |
| B-R78 | [BBH-78] A playback that ran ZERO frames executes no code and can raise no exce… | generalize | BBX-11 a run with zero OBSERVATION POINTS measured nothing; its green is vacuous |
| B-R79 | [BBH-79] Every literal in the instrument layer is in one of three bins: | generalize | every literal binned KIND PROFILE / policy / config, each with a provenance class (BBX-24) |
| B-R80 | [BBH-80] Two implementations of one machine traverse identical states on differ… | generalize | D6 MAPPED state at anchors each side finds on its own; points need not align |
| B-R81 | [BBH-81] An extraction is PROVED by running the generic tool and the original o… | keep | §7 DONE #2: the fidelity contract; BBX's series continues at F12 |
| B-R82 | [BBH-82] The generic classifier is the STRONGER copy, and a consumer's delta ag… | keep | the generic copy is the stronger one; a consumer's delta is a finding about the consumer |
| B-R83 | [BBH-83] A verdict-text or classifier change is never silent: | keep | RO1 a verdict-text or classifier change is never silent |
| B-R84 | [BBH-84] A default that is not written down is a default nobody can veto: | keep | BBX-24 a default not written down is one nobody can veto |
| B-R85 | [BBH-85] The harness is found by an environment variable and never pinned as a… | keep | the harness is found by an environment variable, never pinned as a submodule |
| B-R86 | [BBH-86] Lifted comments keep their incident citations as history lines and car… | keep | BBX-21 lifted material keeps its incident citation and carries no consumer's anchor |
| B-R87 | [BBH-87] A driver for a lane one consumer has stays with that consumer until a… | keep | BBX-25 a component with one consumer stays with that consumer |
| B-C1 | THE GATE CONTRACT — "The runners do not read its code; they read its NAME, its… | keep | G1–G5; reproduced byte for byte on bbh's inputs |
| B-C2 | THE VERDICT CLASSIFIER (impl) — the ONE copy sourced by every runner; regexes +… | keep | G1 the ONE classifier, byte for byte |
| B-C3 | THE DRIVER CONTRACT — `<driver> <set> <replay.rpl> <out.log> [sandbox]`; 9 repl… | generalize | D1–D5; the nine replay vars become the frame kind's family, the guard family stays bbh's |
| B-C4 | THE LOG GRAMMAR — `<frame> <hash>` per frame, optional `INPUT-VIOLATION`, `END… | generalize | O1 the OBSERVATION grammar (END / END-CRASH kept) |
| B-C5 | THE ORACLE CLASSES — the ratified comparison vocabulary (exact/flicker/diverge/… | generalize | C1 the temporal family — one of exact / temporal / set / schema / tolerant-numeric |
| B-C6 | THE .RPL GRAMMAR (python) — `<frame>[-<end>] <who>=<tokens>` / `<frame> wait`;… | generalize | the frame kind's SCENARIO grammar; every KIND declares one, parsed in one place |
| B-C7 | THE .RPL GRAMMAR (Lua twin) — one strict parser for every MAME script; `bbh rpl… | consumer | the twin parser runs inside MAME; the two-parser diff itself is kept (O3) |
| B-C8 | THE EXPECTATION KINDS — masked/skip/sha1/diverge/pending + UNKNOWN-KIND fallbac… | keep | E1 kinds registered in exactly one place; UNKNOWN-KIND reported, never ignored |
| B-C9 | THE MASKED DISPATCHER — the ONE implementation of the vocabulary; verdict lines… | keep | C2 the one dispatcher; verdict lines character-for-character |
| B-C10 | THE GATE HEADER CONTRACT — line 2 is an API; first paragraph is the index sente… | keep | G2 the header API and its one parser |
| B-C11 | THE CONFIG CONTRACT — one bbh.toml per consumer, paths relative to the config f… | keep | one config per consumer, relative paths, fatal on a defaultless key |
| B-C12 | THE TOML SUBSET — tables, basic/literal strings, ints, bools, arrays, inline ta… | keep | the ambiguity-refusing config subset (R3 floor) |
| B-C13 | THE CONVENTIONS REGISTER — 9 ruled defaults, each with the declined alternative… | generalize | the DEFAULTS REGISTER (BBX-24): each ruled default gains a provenance class |
| B-C14 | THE PROVENANCE CONTRACT — a register row per frozen expectation FILE naming a C… | keep | E3 the provenance contract, complete both ways |
| B-C15 | THE PROVENANCE REGISTER (example instance) — 4 evidence classes, 1 row; directo… | generalize | the FIXTURE SUBJECT's expectation register; each KIND's fixture carries one |
| B-C16 | THE RE-BASELINE REGISTER — one dated line per verdict-text/classifier change; t… | keep | RO1 the newest re-baseline line printed at the head of every fidelity run |
| B-C17 | THE DOCTRINE — 8 sentences + the extraction question, the docs convention, how… | keep | inherited whole into CLAUDE.md §1–§4; only the extraction question widens (B-R1) |
| B-C18 | THE HYGIENE CONTRACT — 8 checks that keep a suite honest between runs, each wit… | keep | the eight hygiene checks, each with the incident it exists for |
| B-C19 | THE MACHINE PROFILE CONTRACT — 16 documented keys; `profile.load()` REFUSES a m… | generalize | S1 the KIND PROFILE contract; refusal on a missing key kept, the CPS-2 values consumer |
| B-C20 | THE SKILLS LOCK CONTRACT — `[skills]`+`[skill_<PFX>]`; ID-lock both ways, forbi… | keep | R2 the skills registry; BBX's own skill is generated by it (ruling R4) |
| B-C21 | THE ACCOUNTING RULE — "GREEN" cannot print while a gate self-skipped; bbh_bat /… | keep | GREEN cannot print while a gate self-skipped |
| B-C22 | THE FIDELITY CONTRACT — generic tool and original over the SAME input, verdict… | keep | §7 DONE #2; BBX's 'original' is bbh, from F12 |
| B-K1 | compare_flicker.py — checksum-log comparison with bounded flicker tolerance (th… | generalize | temporal-family comparator (flicker) over point-indexed OBSERVATION logs |
| B-K2 | compare_window.py — the "bounded re-convergent window" comparison class (docs/m… | generalize | temporal-family comparator (window) |
| B-K3 | compare_composite.py — the CONJUNCTION of two already-ratified comparison class… | generalize | temporal-family comparator (composite conjunction) |
| B-K4 | check_diverge.py — verify a checksum log diverges from a frozen base log at EXA… | generalize | temporal-family comparator (frozen first divergence) |
| B-K5 | describe_masked_shape.py — the measured shape of a masked divergence, and a PRO… | generalize | the family's PROPOSER (C5); every comparator family needs one |
| B-K6 | compare_fields.py — compare MAPPED FIELDS between two replay runs from their pe… | generalize | the MAPPED-state comparator for two implementations (D6); fields and anchors per KIND |
| B-K7 | check_dumps.py — assert a per-frame RAM dump directory is COMPLETE (bbh check-d… | generalize | completeness check over a second-view OBSERVATION set |
| B-K8 | logfmt.py — the checksum-log grammar, parsed in ONE place. | keep | O3 the grammar parsed in ONE place, by field name |
| B-T1 | test_accounting.sh [NO must-fire marker]: ground truth for lib/sh/accounting.sh… | keep | ground truth for the accounting rule (no GREEN over a self-skip) |
| B-T2 | test_check_dumps.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/check_dumps.py:… | generalize | ground truth for the observation-completeness checker (B-K7) |
| B-T3 | test_classify.sh [MUST-FIRE x2]: ground truth for lib/sh/classify.sh: every ver… | keep | the classifier's both-direction ground truth (BBX-2) |
| B-T4 | test_compare_composite.sh [NO must-fire marker]: ground truth for the composite… | generalize | temporal-family ground truth (composite) |
| B-T5 | test_compare_fields.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/compare_fiel… | generalize | ground truth for the mapped-state comparator (D6) |
| B-T6 | test_compare_flicker.sh [MUST-FIRE x1]: ground truth for the flicker comparator… | generalize | temporal-family ground truth (flicker) |
| B-T7 | test_compare_window.sh [NO must-fire marker]: ground truth for the "bounded re-… | generalize | temporal-family ground truth (window) |
| B-T8 | test_config.sh [MUST-FIRE x2]: ground truth for the TOML-subset reader and `bbh… | keep | config reader / `bbh config` ground truth |
| B-T9 | test_demand_after_trap.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/demand_af… | keep | ground truth for the demand-after-trap lint (R3 floor) |
| B-T10 | test_driver_contract.sh [MUST-FIRE x5]: ground truth for drivers/README.md agai… | generalize | the DRIVER contract's ground truth per KIND: refusal, four exits, family scrubbing |
| B-T11 | test_enumerate_expectations.sh [NO must-fire marker]: ground truth for | keep | E1 ground truth: an unknown expectation kind is reported |
| B-T12 | test_fidelity_mame.sh [MUST-FIRE x3]: FIDELITY F8: the MAME Lua layer, the MAME… | consumer | MAME / FBNeo fidelity, opt-in, needs the emulators |
| B-T13 | test_fidelity_vampire.sh [NO must-fire marker]: FIDELITY against the lineage: t… | generalize | the fidelity-harness pattern; BBX's own runs against bbh from F12 |
| B-T14 | test_fingerprint.sh [MUST-FIRE x3]: ground truth for lib/py/bbh/fingerprint.py… | generalize | S2 ground truth: SUBJECT IDENTITY computed from the artifact |
| B-T15 | test_gate_index.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/gen_gate_index.p… | keep | gate-index generation and both-way completeness ground truth |
| B-T16 | test_header_defaults.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/header_defa… | keep | header-defaults ground truth |
| B-T17 | test_inp_corpus.sh [MUST-FIRE x2]: ground truth for bin/bbh-inp-corpus, ROM-FRE… | consumer | the MAME .inp recording-corpus tool |
| B-T18 | test_mame_drivers.sh [MUST-FIRE x4]: the sh half of the contract for drivers/ma… | consumer | the sh half of the MAME drivers' contract |
| B-T19 | test_masked_compare.sh [MUST-FIRE x1]: ground truth for lib/sh/masked_compare.s… | keep | the one dispatcher's verdict-text ground truth |
| B-T20 | test_profiles.sh [MUST-FIRE x3]: the machine profiles: every shipped profile de… | generalize | KIND PROFILE completeness ground truth; the CPS-2 values stay consumer |
| B-T21 | test_prologue.sh [NO must-fire marker]: ground truth for lib/sh/prologue.sh, th… | keep | gate-author helper ground truth |
| B-T22 | test_provenance.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/provenance.py: t… | keep | E3 provenance tool ground truth |
| B-T23 | test_ref_rot.sh [MUST-FIRE x3]: ground truth for lib/py/bbh/ref_rot.py: a hard-… | generalize | reference-rot ground truth over artifact references (B-R54) |
| B-T24 | test_rpl.sh [NO must-fire marker]: ground truth for lib/py/bbh/rpl.py, the .rpl… | generalize | SCENARIO grammar ground truth, per KIND |
| B-T25 | test_rpl_lua.sh [NO must-fire marker]: THE GRAMMAR EQUALITY CHECK: lua/mame/rpl… | consumer | the Lua/MAME parser twin; the diff principle itself is kept (O3) |
| B-T26 | test_run_static.sh [NO must-fire marker]: ground truth for bin/bbh-run-static,… | keep | static runner ground truth |
| B-T27 | test_run_sweep.sh [MUST-FIRE x2]: ground truth for bin/bbh-run-sweep: a synthet… | keep | sweep runner ground truth |
| B-T28 | test_shadow_tools.sh [MUST-FIRE x1]: ground truth for lib/sh/shadow_tools.sh: a | keep | shadow-copy control ground truth (G3) |
| B-T29 | test_skills.sh [MUST-FIRE x2]: ground truth for the skills lock (bbh check-skil… | keep | skills lock ground truth (ruling R4) |
| B-T30 | test_suite_dispatch.sh [MUST-FIRE x3]: ground truth for bin/bbh-run-suite over… | generalize | SUITE dispatch ground truth over the FIXTURE SUBJECT |
| B-T31 | test_thresholds.sh [MUST-FIRE x1]: the comparison thresholds are declared ONCE… | keep | thresholds declared once; proposer = enforcer (C5) |
| B-T32 | test_tier.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/tier.py, the transitive | keep | transitive tier ground truth |
| B-D1 | `[project]` — 9 documented keys / 9 code defaults; origin: config 9 | keep | `[project]` identity and layout keys, to be provenance-classed (BBX-24) |
| B-D2 | `[registries]` — 4 documented keys / 4 code defaults; origin: config 4 | keep | `[registries]` keys (R2) |
| B-D3 | `[tier]` — 3 documented keys / 3 code defaults; origin: code 1, config 2 | keep | `[tier]` keys |
| B-D4 | `[classify]` — 4 documented keys / 4 code defaults; origin: code 3, config 1 | keep | `[classify]` regexes and exit list — the classifier's own config |
| B-D5 | `[thresholds]` — 3 documented keys / 3 code defaults; origin: config (policy) 3 | generalize | the temporal family's thresholds, moved into the KIND PROFILE and provenance-classed |
| B-D6 | `[suite]` — 12 documented keys / 12 code defaults; origin: code 2, code (policy… | generalize | `[suite]` keys over SCENARIOS and expectation sets |
| B-D7 | `[fingerprint]` — 7 documented keys / 8 code defaults; origin: config 7 | generalize | `[fingerprint]` → SUBJECT IDENTITY keys (S2) |
| B-D8 | `[sweep]` — 22 documented keys / 22 code defaults; origin: code 1, config 21 | keep | `[sweep]` lane / scope / cadence keys |
| B-D9 | `[gate_header]` — 10 documented keys / 10 code defaults; origin: code 2, config… | keep | `[gate_header]` keys (G2) |
| B-D10 | `[header_defaults]` — 4 documented keys / 4 code defaults; origin: code 2, conf… | keep | `[header_defaults]` keys |
| B-D11 | `[ref_rot]` — 10 documented keys / 10 code defaults; origin: config 10 | generalize | `[ref_rot]` over referenced SUBJECT ARTIFACTS |
| B-D12 | `[provenance]` — 5 documented keys / 5 code defaults; origin: config 4, config… | keep | `[provenance]` keys (E3) |
| B-D13 | `[fields]` — 8 documented keys / 8 code defaults; origin: code 1, config 4, con… | generalize | mapped-state keys per KIND; the one `config (a game fact)` default stays consumer |
| B-D14 | `[skills]` — 11 documented keys / 6 code defaults; origin: code 1, config 5, no… | keep | `[skills]` keys; the 5 no-origin rows are the defaults-register gap BBX must close |
| B-D15 | `[machine]` — 1 documented keys / 0 code defaults; origin: config 1 | generalize | `[kind].profile` — required, no default (S1) |
| B-D16 | `[inp]` — 8 documented keys / 8 code defaults; origin: config 6, config (policy… | consumer | the MAME recording-corpus config |
| B-D17 | lua literal — the code window (`0x400000` / `0x600000`) → bin board | consumer | the CPS-2 code window |
| B-D18 | lua literal — the exception store's width (the guard read `data & 0xFFFF`) → bi… | consumer | the board's exception-store width |
| B-D19 | lua literal — the COLLECT record layout (stride 8, tile code 2 bytes at offset… | consumer | the CPS-2 sprite record layout |
| B-D20 | lua literal — printed widths (`%04x` ports, `%06x` PCs and offsets) → bin board | consumer | board-shaped print widths in the MAME guards |
| B-D21 | lua literal — the STACK sketch: 64 longs walked, 16 listed → bin policy | consumer | the MAME guard's stack-sketch policy |
| B-D22 | lua literal — PCWEEDS suppressed after 10 lines → bin policy | consumer | the MAME guard's PCWEEDS suppression policy |
| B-D23 | lua literal — GUARD_BREAK stops before frame 100 are "the boot pass" → bin poli… | consumer | the MAME guard's boot-pass window |
| B-D24 | lua literal — the ALIVE heartbeat every 600 frames → bin policy | consumer | the MAME script's heartbeat cadence |
| B-D25 | lua literal — `TAIL_FRAMES` 120, `GUARD_PROBE_MAX` 400, `MAX_FRAMES` 200000, `S… | consumer | the lineage's frame-count policy literals in the MAME instrument layer |
| B-D26 | lua literal — `[machine].profile` → bin config, NO default | generalize | `[kind].profile` has no default and is refused when missing (S1) |
| B-D27 | lua literal — `[inp].*` (`vsavjw`, a build dir, the pinned MAME) → bin config,… | consumer | the lineage's romset, build dir and pinned emulator |
| B-D28 | lua literal — a maximum replay length → bin none on the MAME side | generalize | a SCENARIO-length cap is a per-KIND default; 'none' is itself a registered default (BBX-24) |
| B-D29 | threshold `flicker_max` / FLICKER_MAX = 2 — a divergent run this short or short… | generalize | a temporal-family threshold in the KIND PROFILE, reference-calibrated on the lineage |
| B-D30 | threshold `reconverge` / RECONVERGE = 60 — identical frames required after the… | generalize | a temporal-family threshold in the KIND PROFILE, reference-calibrated on the lineage |
| B-D31 | threshold `flicker_max_total` / MAX_TOTAL = 8 — the cap on a flicker INVENTORY,… | generalize | a temporal-family threshold in the KIND PROFILE, reference-calibrated on the lineage |
| B-G1 | `ci_portable.txt` — 6 gates a CLEAN CHECKOUT can run; "THE JOB MUST FAIL ON SKI… | keep | the portable-tier gate registry (R2) |
| B-G2 | `ci_static.txt` — 1 gate needing the reference input (FAKE_ROOT) but no driver. | keep | the static-tier gate registry (R2) |
| B-G3 | `ci_sweep.tsv` — the instrument-tier registry, 5 rows: gate/lane/scope/cadence/… | keep | the instrument-tier registry: gate / lane / scope / cadence / args / note / timeout |
| B-G4 | `gate_index.tsv` — 12 rows, the ONE hand-maintained input of `bbh gate-index`;… | keep | the one hand-maintained family table, completeness enforced both ways |
| B-G5 | `registry.tsv` — 4 rows, build fingerprint → expectation set; 2 by PROGRAM key,… | generalize | the SUBJECT registry: IDENTITY → expectation set (S2, R2) |
| B-G6 | `fields.tsv` — 7 mapped fields with base/addr/width/phase for the dual-implemen… | generalize | the mapped-state anchor table, per KIND; the addresses stay consumer |
| B-G7 | `docs/gate_index.md` — GENERATED from every gate header + the family TSV; `--ch… | keep | the generated index, `--check` in a portable gate |
| B-G8 | `skill/skills.toml` — the harness's own skills lock config: 1 prefix (BBH), 9 a… | keep | R2 the skills registry; BBX carries its own (ruling R4) |
| B-G9 | `bbh.toml.example` — the 15-section config template a consumer copies. | generalize | the config template gains the KIND sections; BBX ships its own |
| B-G10 | `example/consumers/bbh.vampire.toml` — the config of the LINEAGE, kept here bec… | consumer | the lineage's own consumer config |
| B-F1 | F1: both static runners over one synthetic fake repo of stub gates: output iden… | generalize | F12+ pattern: both static runners over one fixture repo, output identical |
| B-F2 | F3: the tier classifier over the lineage's 304 gates: the INSTRUMENT set minus… | generalize | F12+ : the tier classifier over bbh's own gates |
| B-F3 | F5: every .masked spec of the lineage through both masked_compare implementatio… | generalize | F12+ : every COMPARATOR SPEC through both implementations, verdict text to the character |
| B-F4 | F6: the fingerprint: both tools over the same images with every flag — a synthe… | generalize | F12+ : SUBJECT IDENTITY, both tools, every flag |
| B-F5 | F7: the suite's dispatch: both suite runners over the lineage's real expectatio… | generalize | F12+ : suite dispatch through both runners with a stub driver |
| B-F6 | F4: the sweep runner: --list (always) and --dry-run (with ROMDIR) over the line… | generalize | F12+ : the sweep runner's --list / --dry-run through both runners |
| B-F7 | F9: the hygiene tools: header-defaults, gate-index (--check, and the rendered i… | generalize | F12+ : the hygiene tools |
| B-F8 | F10: the field comparator and the dump checker over SYNTHETIC dump directories… | generalize | F12+ : the mapped-state comparator and the completeness checker over synthetic sets |
| B-F9 | F8: lives in selftest/test_fidelity_mame.sh (opt-in, BBH_MAME_FIDELITY=1: the L… | consumer | F8 needs the real emulators — bbh's frame-driven fidelity |
| B-F10 | F11: the skills lock and the guide generator (H10): bbh check-skills -v with th… | generalize | F12+ : the skills lock and the guide generator (ruling R4) |
| B-F11 | F2: (BBH_FIDELITY_F2=1) the lineage's whole portable tier through both runners,… | generalize | F12+ : a whole portable tier through both runners |
| B-F12 | F8a: one short replay through tools/run_replay_mame.sh and | consumer | MAME replay parity |
| B-F13 | F8b: VIDEO_OUT / INPUT_OUT / DUMPS / POKES / SNAP_FRAMES parity: every | consumer | MAME output-channel parity |
| B-F14 | F8c: INPUT_INJECT_TEST: both drivers exit 1 with the same | consumer | MAME input-injection parity |
| B-F15 | F8d: the guard, cheap mode, on the lineage's crash-guard negative control | consumer | the MAME crash guard, cheap mode |
| B-F16 | F8e: the guard, authoritative mode, on test_crash_guard's POSITIVE | consumer | the MAME crash guard, authoritative mode |
| B-F17 | F8f: the .rpl grammar under MAME's own interpreter: rpl_dump.lua over | consumer | the .rpl grammar under MAME's own interpreter |
| B-F18 | F8g: a recording: tools/run_inp_guarded.sh vs bbh inp-play on the | consumer | MAME recording playback parity |
| B-F19 | F8h: FBNeo: tools/run_replay_fbneo.sh vs drivers/fbneo.sh on the same | consumer | FBNeo second-implementation parity |
| B-P1 | THE FOUR BINS (prose, unnumbered): code / config / machine profile / stays with… | generalize | the four bins become code / config / KIND PROFILE / consumer (BBX-24) |
| B-P2 | THE DOCTRINE, SHORT FORM (prose): seven sentences, from "No untested change sur… | keep | the doctrine's short form |
| B-P3 | Ruled default 1 (unnumbered): a separate repository, this one; the CLI prefix i… | keep | own repo, own CLI prefix (ruling R0), nothing depending on a consumer's tree |
| B-P4 | Ruled default 5 (unnumbered): "Documentation tools are OUT" — their subject is… | consumer | bbh's scope ruling; BBX admits a document set as a SUBJECT KIND (ruling R2, BBX-18), so it does not travel |
| B-P5 | Ruled default 9 (unnumbered here): docs stay LEAN and anchored; the complete LO… | keep | BBX-20 lean pages, history twins |
| B-P6 | "Each is a MEASURED MECHANISM with a FROZEN expectation; none is a tolerance."… | keep | C1 the sentence that bars a class from becoming a knob |
| B-P7 | The one verdict row with no rule ID: "exits 0 otherwise → PASS". | keep | G1 the default verdict row, reproduced byte for byte |
| B-P8 | "Directories are out of scope by design … two checks on one claim is one too ma… | keep | one check per claim — the register's scope boundary |
| B-P9 | "The tier labels are derived, not configured" — from the registry file stems an… | keep | tier labels are derived, not configured |
| B-P10 | header-defaults exemptions are CODE, not config: backticked tokens and a token… | keep | the exemptions are code, not config |
| B-P11 | "A red gate is a question, and its first question is which side rests on a meas… | keep | a red gate is a question about which side rests on a measurement |
| B-P12 | `roms/hook` has NO registry row on purpose: the unregistered build the suite mu… | generalize | the fixture's unregistered SUBJECT: an unknown IDENTITY is refused loudly (S2) |
| B-P13 | Every contract paragraph names its GROUND TRUTH selftest — the §5 closing parag… | keep | every contract paragraph names its ground-truth gate |
| B-P14 | "GREEN — the harness's own gates pass." / "NOT GREEN — see above." — the harnes… | keep | the harness is classified by its own classifier |
| B-P15 | "License: GPL-3.0 (the lineage's)" — declared load-bearing on legal and use sco… | keep | the licence is load-bearing and declared (ruling R1) |
| B-P16 | "Break a control, watch it fire" — the example ships the perturbations that tur… | keep | G3 the perturbations that turn each control red are shipped as commands |
| B-P17 | "What stayed with the lineage" — the explicit NOT-EXTRACTED list (Verilator dri… | keep | the NOT-EXTRACTED list is itself an artifact; this file is its twin |
| B-X1 | example gate `g_driver_ok.sh`: the INSTRUMENT check: drivers/fake.sh runs one r… | generalize | the fixture consumer's driver gate, one per KIND |
| B-X2 | example gate `g_fields.sh`: the DUAL-IMPLEMENTATION protocol on the fake machin… | generalize | the mapped-state gate (D6) on the FIXTURE SUBJECT |
| B-X3 | example gate `g_hygiene.sh`: the four hygiene checks are GREEN on this consumer… | keep | the hygiene checks are green on a consumer |
| B-X4 | example gate `g_needs_fake.sh`: reaches the driver ONLY through a sourced lib,… | keep | the transitive-tier fixture: a gate reaching a driver only through a sourced lib |
| B-X5 | example gate `g_pass.sh`: the plainest gate: one assertion, one verdict line, e… | keep | classifier fixture: PASS |
| B-X6 | example gate `g_prose.sh`: the word SKIP in PROSE is not a marker: this gate PA… | keep | classifier fixture: SKIP in prose is not a marker |
| B-X7 | example gate `g_segv_prose.sh`: the BENIGN look-alike of a shell error: a driver | keep | classifier fixture: the benign look-alike of a shell error |
| B-X8 | example gate `g_skip.sh`: the SKIP contract: a missing prerequisite prints `SKI… | keep | classifier fixture: the SKIP contract |
| B-X9 | example gate `g_skip_indent.sh`: an indented SKIP marker is still a marker (`^… | keep | classifier fixture: an indented marker is still a marker |
| B-X10 | example gate `g_static_pass.sh`: a STATIC-tier gate: it needs the reference inp… | keep | static-tier fixture |
| B-X11 | example gate `g_suite.sh`: the replay suite is GREEN on a registered build. The… | generalize | the SUITE gate over a registered SUBJECT, per KIND |
| B-X12 | example gate `g_suite_refuses.sh`: the suite REFUSES an unregistered image loud… | generalize | S2: the suite refuses an unknown IDENTITY loudly |
| B-X13 | fake machine feature `(none)` → the base machine → class exact / `.sha1`. | generalize | FIXTURE SUBJECT case for the exact comparator |
| B-X14 | fake machine feature `hook` → one byte written a frame LATE per player-button p… | generalize | fixture case for the temporal family (flicker) |
| B-X15 | fake machine feature `select` → after 1P start one byte held for frames +60..+1… | generalize | fixture case for the temporal family (window) |
| B-X16 | fake machine feature `attract` → the attract demo (frame 900 on, no coin) diver… | generalize | fixture case for the temporal family (permanent divergence) |
| B-X17 | fake machine feature `hook,select` (`both`) → class composite. | generalize | fixture case for the temporal family (composite) |
| B-X18 | fake machine knob `FAKE_NONDET=1` → the clock mixed in → the NONDETERMINISTIC p… | generalize | every KIND's fixture needs a non-determinism knob — the positive control for BBX-14 / O6 |
| B-X19 | fake machine knob `FAKE_CRASH_AT=n` → CRASH/REGS/STACK, END-CRASH, exit 2 → the… | generalize | every KIND's fixture needs a guard-trip case: exit 2, the observation is the bug report (D4) |
| B-X20 | `fakesys.py` — 64 KiB RAM (whole window), 3 ports with the lineage's token voca… | generalize | FIXTURE SUBJECT of the frame-driven kind; BBX needs one per KIND (§5) |
| B-X21 | `make_roms.py` — generates the 5 fake images byte-reproducibly; `--check` is th… | generalize | the fixture's SUBJECT ARTIFACT generator: byte-reproducible, with a --check precondition |
| B-X22 | `make_expected.sh` — regenerates the whole expectation tree in a documented 6-s… | keep | E3: every frozen file has a named producer and a documented re-freeze order |
| B-X23 | skills-lock assertion 1: ID-LOCK both ways — every rule definition has exactly… | keep | skills lock: ID-lock both ways |
| B-X24 | skills-lock assertion 2: LIFTABILITY — a fixed forbid list, grepped case-insens… | keep | skills lock: liftability by a forbid list |
| B-X25 | skills-lock assertion 3: NUMBERS CITE THE LOG — every numeric literal must appe… | keep | BBX-21 numbers cite the log, never only a synthesis |
| B-X26 | skills-lock assertion 4: CROSS-REFERENCES RESOLVE — a plain `[PFX-N]` of a conf… | keep | skills lock: cross-references resolve |
| B-X27 | the forbid list: 33 tokens — 14 game/character names, 3 build-dir tokens, 6 boa… | consumer | the 33 tokens are the lineage's vocabulary; BBX's forbid list is its own |
| B-X28 | `bin/bbh` — the one entry point, 26 dispatched subcommands; the MAME drivers an… | generalize | one entry point dispatching the generic subcommands; the MAME / inp ones stay bbh's |
| B-X29 | driver `fake.sh` — the fake machine; honours the whole replay family, refuses t… | generalize | the FIXTURE SUBJECT's driver — the reference implementation of D1–D5 |
| B-X30 | driver `mame.sh` — MAME + replay.lua under a MACHINE PROFILE (BBH_PROFILE requi… | consumer | MAME + replay.lua under a machine profile |
| B-X31 | driver `mame_guarded.sh` — crash detection via -debug vector breakpoints or che… | consumer | the MAME crash-guard driver |
| B-X32 | driver `fbneo.sh` — a patched FBNeo frontend: a SECOND implementation of the sa… | consumer | the FBNeo second implementation; the D6 principle is kept |
| B-X33 | machine profile `cps2.lua` — the 4 MB code window board. | consumer | a CPS-2 board profile |
| B-X34 | machine profile `cps2w.lua` — differs from cps2 ONLY in `crash.code` (6 MB). | consumer | a CPS-2 board profile variant |
| B-X35 | machine profile `TEMPLATE.lua` — every key with a comment; `test_profiles.sh` k… | generalize | the KIND PROFILE template and its completeness check, per KIND |
| B-X36 | `bbh-doctor` — host capability report: python3>=3.8, tomllib, timeout/gtimeout,… | generalize | the host capability report, per KIND; its MAME / FBNeo / lua probes stay bbh's |
| B-X37 | `selftest/run.sh` — the harness's own gate chain, classified by the same classi… | keep | the harness's own gate chain, classified by the same classifier |
| B-X38 | `lib/sh/shadow_tools.sh` — a perturbation control edits a COPY under a shadow r… | keep | G3 the shadow-copy control mechanism |
| B-X39 | `lib/sh/prologue.sh` — bbh_work / bbh_demand / bbh_skip / bbh_fail / bbh_absolu… | keep | gate-author helpers, offered and never required |
| B-X40 | `lib/sh/mame_sandbox.sh` — every host input provider off, SDL_VIDEODRIVER=dummy… | consumer | the MAME sandbox |
| B-X41 | `lib/sh/registry.sh` + `config.sh` — registry line reading and the sh-side conf… | keep | registry line reading and the sh-side config resolver |
| B-X42 | `fingerprint.py` — PROGRAM key (ordered program members of the first image on t… | generalize | S2 SUBJECT IDENTITY from the artifact; the key kinds are declared per KIND |
| B-X43 | `tier.py` — the transitive "needs an instrument" classifier, following sourced… | keep | the transitive instrument-reach classifier |
| B-X44 | `demand_after_trap.py` — lints the `${VAR:?}`-after-`trap … EXIT` shape that ex… | keep | the bash 3.2 exit-0 lint (R3 floor) |
| B-X45 | `gate_header.py` — THE one header parser under gate-index, header-defaults and… | keep | G2 the one header parser |
| B-X46 | `gen_gate_index.py` / `header_defaults.py` / `ref_rot.py` / `provenance.py` — t… | keep | the four hygiene tools; ref-rot reads artifact references (B-R54) |
| B-X47 | `checkskills.py` / `gen_skill_guide.py` — the skills lock and the GUIDE generat… | keep | the skills lock and guide generator; BBX's skill is generated by it (ruling R4) |
| B-X48 | `bin/bbh-run-static` — two tiers tallied separately, `--strict`, anti-orphan re… | keep | the static runner: tiers tallied separately, anti-orphan report |
| B-X49 | `bin/bbh-run-suite` — fingerprint → set, each replay twice, dispatch skip→pendi… | generalize | the SUITE runner: IDENTITY → set, each SCENARIO twice, dispatch by expectation kind |
| B-X50 | `bin/bbh-run-sweep` — lanes, prereq first and serial, scope/cadence, %PLACEHOLD… | keep | the sweep runner: lanes, scope, cadence, timeouts, resume |
| B-X51 | `bin/bbh-inp-play` / `bbh-inp-corpus` — the recording corpus: `<name>.inp` + nv… | consumer | the MAME recording corpus tools |
| B-X52 | THE BYTE-FOR-BYTE TARGET: the example's suite output block — `build fingerprint… | keep | the fidelity target text, reproduced byte for byte by BBX (§7 DONE #2) |
| B-X53 | the 6 example replays 01_idle 02_coin_start 03_press 04_both 05_attract 06_othe… | generalize | the FIXTURE SUBJECT's SCENARIO set, one per comparator class |
| B-X54 | the 5 fake image dirs base / attract / build-a / build-b / hook; build-a and bu… | generalize | the fixture's SUBJECT ARTIFACT set, including the dual-IDENTITY case |

## Totals

| bin | rows |
|---|---|
| keep | 140 |
| generalize | 103 |
| consumer | 37 |
| drop | 0 |
| total | 280 |

Rows in this file: 280 (`grep -cE '^\| B-[A-Z][0-9]+ \|' docs/bins/bbh.md`).
B rows in the census: 280 (`grep -cE '^\| B-[A-Z][0-9]+ \|' docs/census/bbh.md`).
Ids identical both ways: `diff <(grep -oE '^\| B-[A-Z][0-9]+' docs/census/bbh.md) <(grep -oE '^\| B-[A-Z][0-9]+' docs/bins/bbh.md)` → empty.

Command: `grep -E '^\| B-' docs/bins/bbh.md | awk -F'|' '{gsub(/ /,"",$4); print $4}' | sort | uniq -c`

```
  37 consumer
 103 generalize
 140 keep
```

(no `drop` line: the bin is empty — see the note below.)

Drop rows with an empty reason: `grep -E '^\| B-[^|]*\|[^|]*\| drop \| *\|' docs/bins/bbh.md | wc -l` → must print 0 (actual output):

```
       0
```

**Why `drop` is empty.** The burden is on dropping (CLAUDE.md §5), and a drop must mean *no meaning
outside frames AND not worth carrying even as bbh's*. bbh stays unmodified and is BBX's fidelity
fixture (§7), so every frame-shaped item still has a home: it is `consumer` — it stays in bbh and BBX
drives it through the frame-driven kind for fidelity only. 37 rows landed there. No row was found
that is both meaningless outside frames and dead weight inside bbh; this is consistent with bbh
already having survived one extraction. If the maintainer would rather see the reversed scope rulings
(B-P4) or the absent literals (B-D28) as drops rather than as consumer/generalize, that is a ruling,
not a measurement.

# The abstraction — contracts, never layouts

**Shape: proposal (session 1, 2026-09-09). Status: UNRATIFIED. Nothing here is
implemented.** Every contract cites the bbh rule it generalizes (`[BBH-N]`,
`~/Developer/blackbox-harness/skill/blackbox-harness/SKILL.md`) or the lineage
paragraph it lifts (`docs/census/*.md` row ids). A contract with no citation is
new and says so. Terms in CAPITALS are the proposed vocabulary. The bbh → BBX
mapping is §9. What this document does not decide is §10.

The extraction question that produced bbh, generalized (CLAUDE.md §5): *would
this still be true were the subject not frame-driven, not software, not even
executable?* Every contract below was written by asking it; the per-item answers
are `docs/bins.md`.

## 1. SUBJECT

A SUBJECT is what a verdict is about: code, a document set, a build, a dataset,
a model, a firmware image, an emulated board.

- **S1 — KIND.** A subject declares exactly one KIND, and a kind is a PROFILE:
  what a scenario is, what an observation point is, which views exist, which
  driver variables apply, which comparator families make sense. Generalizes the
  machine profile `[BBH-65]` `[BBH-71]` `[BBH-79]`: a kind is never implied,
  and a driver that needs one refuses to run without it.
- **S2 — IDENTITY.** A SUBJECT SET (the artifact plus its search path) resolves
  to an IDENTITY computed by the harness from the artifact itself — never from
  metadata the subject declares about itself (CLAUDE.md §3.4; VSP-166). The
  identity selects the expectation set through a registry row written at
  freeze time; an unknown identity is refused loudly `[BBH-67]`
  (bbh `lib/py/bbh/fingerprint.py`).
- **S3 — VERSION.** Results are keyed by (case, subject version), never by
  date; a long run attests the version that started it (BBX-29).
- **S4 — VIEWS.** A subject declares its views; every extractor and comparator
  names the view it reads (BBX-16; VS L3 "the VIEW is a property of the ACCESS
  MODE", `docs/census/vampiresaved.md`).
- **S5 — DETERMINISM.** A subject that cannot be driven deterministically is
  admitted only with BBX-14 reported *unmet* in every readout (ruling R5).

## 2. DRIVER

A DRIVER runs one SCENARIO against one SUBJECT SET and writes one OBSERVATION.

- **D1 — SHAPE.** `<subject-set> <scenario> <out> [sandbox]` — unchanged from
  `[BBH-25]`. The suite, the comparators and the fidelity checks know only this
  shape, never what is behind it.
- **D2 — THE SCENARIO-VARIABLE FAMILY IS PER KIND.** Generalizes the replay
  family `[BBH-29]`: the frame-driven kind keeps bbh's nine variables and the
  guard family verbatim; a document-set kind's family names documents, artifact
  and view; a command-line kind's family names arguments, stdin, environment,
  working directory and emitted files. The family is declared in the kind
  profile, and the suite scrubs it from the environment before any driver runs
  `[BBH-35]`.
- **D3 — REFUSAL.** A driver that cannot honour a variable prints
  `REFUSED: <driver> cannot honour <VAR> (<why>)` and exits 3; it never ignores
  it `[BBH-28]`. A run that silently did not measure is the false green every
  gate exists to remove.
- **D4 — FOUR EXITS.** 0 the observation is complete and clean; 1 the subject
  failed or the observation is incomplete — DISCARDED, never compared; 2 a guard
  tripped and the observation is the bug report; 3 refused `[BBH-34]`.
- **D5 — HYGIENE.** The out file is removed before the run `[BBH-27]`; the
  sandbox is the subject's home and a fresh temp dir when omitted `[BBH-36]`.
- **D6 — A SECOND IMPLEMENTATION IS A DRIVER.** Under the same contract,
  mapping what it can and refusing the rest `[BBH-37]`; comparable state
  between two implementations is MAPPED state at anchors each side finds on
  its own `[BBH-80]`.
- **D7 — AN EXTERNAL TEST FRAMEWORK IS A DRIVER.** *Ruled R15.* An ADAPTER
  runs a framework's own suite as the scenario and maps its results into the
  observation grammar: one observation point per test case, tokens = the
  framework's verdict and any hashable output it produced; it refuses what it
  cannot honour (D3) and reports non-determinism when two invocations of the
  framework differ (O6). The framework's verdict is an OBSERVATION, never a
  BBX verdict: comparison and readout stay BBX's, so a framework that reports
  green while measuring nothing is caught the way any driver is. The
  command-line kind is the minimal adapter; a framework adapter is one more
  driver of that kind, and BBX-25 applies — a generic adapter needs two
  frameworks. This is how an agent working in any codebase puts BBX in front
  of the tooling it already has, wherever the tests are deterministic (R5).

## 3. OBSERVATION

An OBSERVATION is what the driver saw, in one grammar.

- **O1 — GRAMMAR.** `<point> <token…>` per OBSERVATION POINT, then `END <n>`
  `[BBH-33]`. The point generalizes the frame: a frame index, a claim id, an
  output line or field name, a build step, a record key. Tokens are compared
  as tokens and never interpreted.
- **O2 — BASIS.** What the observation was taken under (a mask, a view, an
  extraction configuration) is recorded beside it; two observations under
  different bases are not comparable, and the checker refuses the pairing
  rather than compare them `[BBH-38]` `[BBH-30]`.
- **O3 — ONE READER, BY FIELD NAME.** The grammar is parsed in one place
  (bbh `logfmt.py`), by field name never by position (BBX-12), and where two
  implementations of the parser exist their parses are diffed `[BBH-73]`.
- **O4 — SECOND CHANNELS.** An observation over another view is another file
  in the same grammar, never a change to the first `[BBH-31]`.
- **O5 — INPUT INTEGRITY.** The driver records what it actually fed the
  subject against what the scenario scripted, and the assertion has a
  must-fire `[BBH-32]`.
- **O6 — TWICE.** Every scenario is observed more than once; any difference
  between runs is NONDETERMINISTIC and a failure before any class is consulted
  `[BBH-49]`, BBX-14.

## 4. EXPECTATION

An EXPECTATION is a frozen file the observation is compared against.

- **E1 — KIND, REGISTERED ONCE.** Every expectation file has a kind registered
  in exactly one place, so an unknown kind is reported, never ignored
  `[BBH-50]` (bbh `enumerate_expectations.sh`). bbh's five kinds stay; a new
  subject kind adds kinds there and nowhere else.
- **E2 — UNRATIFIED IS RED.** A pending expectation is reported as unevaluated
  and the run is a FAILURE `[BBH-51]`, BBX-3.
- **E3 — PROVENANCE CLASS.** Every frozen file has a row in a register naming
  what it describes, a CLOSED class it rests on, and how to re-freeze it,
  complete both ways `[BBH-52]` `[BBH-53]`. The closed vocabulary is ruled
  (R11): `reference > corroborator > self > derived > hash-lock > registry >
  fixture > testimony`; evidence is upgraded, never silently downgraded
  (CLAUDE.md §3.3).
- **E4 — ANCHORED OUTSIDE THE SUBJECT.** A self-frozen expectation answers
  "did this change since I froze it" and can never see a regression against a
  reference `[BBH-50]`; an expectation derived from the subject's own metadata
  is refused (CLAUDE.md §3.4).
- **E5 — INVENTORIES ARE MULTISETS.** Compared both ways; a duplicate is a
  signal of hand-editing (BBX-17, `[BBH-47]`).
- **E6 — LOOSER ONLY BY RULING.** Reclassification to a looser class needs a
  new measured mechanism and a maintainer ruling `[BBH-46]`, BBX-13.

## 5. COMPARATOR

A COMPARATOR decides one pairing (observation, expectation) in one class.

- **C1 — FAMILIES.** *exact*; *temporal* (bbh's flicker, frozen
  first-divergence, bounded window, composite — over point-indexed logs, with
  thresholds declared once `[BBH-48]`); *set/multiset*; *schema* (the shape of
  a structured output); *tolerant-numeric* (a per-field class, ratified). Each
  non-exact class is a MEASURED MECHANISM with a frozen expectation, never a
  tolerance `[BBH-39]`. The temporal family is one family among several — this
  is the sentence the generality proof exists to make true.
- **C2 — THE SPEC LINE.** `<class> <baseset> <args>`, dispatched by one
  implementation of the vocabulary (bbh `masked_compare.sh`), family and view
  declared.
- **C3 — FAIL-SHORT IS NOT FAIL.** "The observation ended before the
  comparison finished" is reported differently from "the subject diverged"
  `[BBH-40]`, BBX-4.
- **C4 — VERDICT TEXT IS FROZEN.** The printed verdict line of every class is
  reproduced character for character; it is what fidelity diffs `[BBH-81]`.
- **C5 — PROPOSER = ENFORCER.** The proposer and the enforcers import the same
  thresholds; a proposed line drops into a spec verbatim and passes `[BBH-48]`.
- **C6 — NOT EXPRESSIBLE MEANS ROOT-CAUSE.** A shape the vocabulary cannot
  express is never absorbed into a widened class `[BBH-45]`.

## 6. GATE

A GATE is a script the runners read by NAME, EXIT STATUS and OUTPUT — never by
code `[BBH-11]`.

- **G1 — VERDICT.** Exit decides first; SKIP is exit 0 plus a marker and
  asserts nothing; TIMEOUT is its own verdict; exit 0 after the shell's own
  error line is a crash; one classifier sourced by every runner
  `[BBH-12]`–`[BBH-16]`, BBX-1.
- **G2 — HEADER API.** Line 2 is the claim `[BBH-18]`; the header names the
  default the code uses `[BBH-19]`; one verdict line of the gate's own
  `[BBH-20]`.
- **G3 — CONTROLS ARE DECLARED, AND THE DECLARATION IS READ.** *New; ruled
  R10.* A gate that asserts a property declares its must-fire control(s) in
  one grammar (a header line naming the control's SHAPE — perturbed copy,
  shadow tool, known-bad reference — and what must fail and why) and the
  controls registry is complete both ways: an asserting gate with no declared
  control is red; a declared control that did not fire in the run is red and
  refuses the verdict (BBX-6); the readout counts fired / declared. This lifts
  the three shapes of `[BBH-21]` and closes the gap measured in VampireSaved,
  where the must-fire marker is prose only (74 of 311 gates, 15+ spellings,
  no machine reader — `docs/census/vampiresaved.md`) although its rot
  taxonomy names the dead control the only silent class.
- **G4 — REGISTERED OR NOT RUN.** Every gate is in a registry; the anti-orphan
  report names both directions `[BBH-22]`; instrument reach is decided
  transitively `[BBH-23]`.
- **G5 — SETUP-FAIL.** *Ruled R13.* A gate whose fixture did not
  stage reports SETUP-FAIL, a different finding from FAIL (SMS
  `tools/test_clash_air.lua:39-42`; `tools/health.sh:13-21`). Because bbh's
  classifier must be reproduced byte for byte on bbh's inputs, SETUP-FAIL is a
  sub-outcome of FAIL in the readout, never a fifth verdict word.

## 7. REGISTRY

- **R1 — BOTH WAYS, EVERY RUN.** Every registry is complete both ways and
  re-derived every run: an unregistered item and a dead row both fail (BBX-9);
  a hand-maintained list is a smaller thing to forget to update.
- **R2 — THE REGISTRIES.** Gates by tier (portable / static / sweep,
  `[BBH-22]` `[BBH-68]`); expectations with provenance (E3); controls (G3);
  defaults with provenance class *principled / reference-calibrated /
  arbitrary* (BBX-24 — bbh today carries only a code/config origin column, 0
  provenance tags, `docs/census/bbh.md`); documents with shape and history twin
  (BBX-20; VS `docs/doc_shape.tsv`, 74 rows); subjects (identity → expectation
  set, `[BBH-67]`); skills (rule ↔ anchor, both ways, (bbh H10)).
- **R3 — ROWS ARE DECISIONS.** Registry rows are written at freeze time as
  build decisions, never guessed at run time `[BBH-67]`.

## 8. READOUT

The READOUT is the one screen the maintainer acts on (CLAUDE.md §3.2).

- **RO1 — CONTENT.** The verdict; what it rests on (the provenance class of
  every expectation relied upon, as a histogram); gates PASS / SKIP / FAIL /
  TIMEOUT counted separately (BBX-1); controls fired / declared, and that each
  *can* fail (`[BBH-4]`); coverage as a number (BBX-18); BBX-14 met or unmet;
  the subject identity and version; the newest re-baseline line `[BBH-83]`.
- **RO2 — WHAT THIS GREEN DOES NOT ASSERT.** Mandatory, every run (BBX-30).
  A green that hides its blind spots is a lie of omission.
- **RO3 — LEGIBLE WITHOUT THE CODE.** If a verdict needs the reader to
  understand the implementation to believe it, the verdict is not finished
  (CLAUDE.md §0).

## 9. The mapping from bbh's vocabulary

| bbh term | BBX term | bin (`docs/bins.md`) |
|---|---|---|
| frame | OBSERVATION POINT | generalize |
| replay (`.rpl`) | SCENARIO | generalize |
| ROM / image / rompath | SUBJECT ARTIFACT / SUBJECT SET | generalize |
| build fingerprint | SUBJECT IDENTITY | generalize |
| machine profile (`profiles/*.lua`) | KIND PROFILE | generalize (the CPS-2 tables stay consumer) |
| mask | BASIS | generalize |
| checksum log (`<frame> <hash>` … `END n`) | OBSERVATION LOG | generalize |
| video log | second-view observation | generalize |
| expectation set, `.sha1/.masked/.skip/.diverge/.pending` | EXPECTATION SET, kinds | keep |
| masked spec `<class> <baseset> <args>` | COMPARATOR SPEC | keep |
| oracle classes (exact, flicker, diverge, window, composite) | the *temporal* family | generalize (one family among several) |
| thresholds (2 / 60 / 8) | a kind profile's ratified thresholds | keep, provenance-classed |
| verdict classifier `classify.sh` | the one classifier | keep, byte for byte |
| portable / static / sweep registries | gate registries by tier | keep |
| provenance register | expectation register (E3) | keep; vocabulary closed by R11 |
| conventions register | defaults register (BBX-24) | generalize (add provenance class) |
| fake machine (`fakesys.py`) | FIXTURE SUBJECT — one per subject kind (CLAUDE.md §5); bbh's own stays in bbh as the frame-driven kind's fixture | generalize |
| example consumer | the first consumer | keep |
| `bbh.vampire.toml` | a consumer config | consumer |
| MAME / FBNeo drivers, Lua engine, guards, taps | drivers of one kind | consumer (bbh's), fidelity only |
| skills lock + guide generator (H10) | skills registry | keep; BBX's own skill is generated by it (R4) |

## 10. Self-validation (ruled R14)

BBX's own tree is a SUBJECT of its own kinds: its documents through the
document-set kind (every count in `docs/census/*.md` and every number in a
readout re-derived — the recount gate of R9 is the first instance), its gates
and runners through the command-line kind, its registries through R1.
Self-consistency cannot catch a convention error shared with the checker
(BBX-15), so a self-validation gate counts only while its declared controls
fire (G3) and the fidelity rows against bbh — the lineage-independent third
party — are green (`docs/fidelity.md`). Run on every platform of R3.

## 11. What this abstraction does NOT decide

Directory layout (contracts only); whether the readout is text, TSV or HTML;
the fixture subjects' content (`docs/generality.md`); which two frameworks
prove the adapter generic (D7); anything about performance. The abstraction
itself is UNRATIFIED until F12 diffs empty: the rulings settle its vocabulary
and boundaries, not its correctness.

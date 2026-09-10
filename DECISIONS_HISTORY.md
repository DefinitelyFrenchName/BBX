# DECISIONS_HISTORY — how each ruling came to be

Shape: history twin of `DECISIONS.md`; append-only; newest last. Carries no
rule anchors (a twin is where numbers and narratives go, never where a rule
lives — bbh `[BBH-9]`).

## 2026-09-09 — session 1 (birth)

- **R6, R7, R8** were asked in plan mode before any file was written, because
  all three blocked commit one. Measurements that prompted them: the git root
  resolved to HOME (`git rev-parse --show-toplevel` → `/Users/koneko`); bbh's
  porcelain showed 4 modified files on top of `f675710`. The maintainer chose
  the recommended option on all three.
- **M1** (bin every rule individually): the alternative — binning VampireSaved's
  level-0/1 prefixes (VSE, MSC, MJC, MFI, CPH, CPE = 339 rules) as blocks —
  would have been cheaper but would have hidden the handful of general
  principles inside board-specific skills (e.g. MJC-52's instrument protocol,
  MFI-39's "a relocation test with no negative control proves nothing"). The
  burden is on `drop`; a block cannot carry a reason per row.
- **M2, M3** restate FIRST_PROMPT.md's agent protocol as method decisions so
  they outlive the prompt.
- Anti-hyperfocus checkpoint (BBX-27), end of session 1: the most valuable
  next thread is the rulings queue, not S1 — nothing in S1 can start before
  R0–R5 and R9–R13 are answered. The last green in this session is the
  verifiers' match table over the census; it means the counts reproduce at
  the recorded HEADs and nothing more.
- **Bins reconciled with the abstraction (2026-09-09, end of session 1):** the
  bbh binner found `docs/abstraction.md` §9 binning the fake machine "keep"
  where CLAUDE.md §5 says `generalize`; the constitution wins and §9 was
  edited. The VampireSaved binner split the thresholds 2/60/8 into values
  (`generalize`, kind-profile thresholds with a provenance class) and rule
  (`keep`); adopted, since C1 already places thresholds in the kind profile.
  Neither is a ruling; both are recorded in `docs/bins.md`.
- **Verification protocol outcome:** three census files, three verifiers,
  seven citation/gloss defects found and corrected by the producers, one
  orchestrator error ("319 gate scripts") found by a verifier's question and
  re-measured to 311 + 8 library scripts. The protocol (M3) stays.

## 2026-09-09 — the rulings, same day, after the STOP

- The maintainer asked to rule in-session rather than wait. Thirteen open
  rulings were put in three batches, recommendation first; every
  recommendation was taken. Three answers carried more than the options
  offered and became rulings of their own: **R14** (self-validation, the
  maintainer's "Juvenal Escape Clause" — BBX validates BBX without degrading
  its rules), **R15** (external test frameworks as drivers, so agents in any
  codebase can bring their own tooling), **R16** (every edit to CLAUDE.md
  needs maintainer approval). R3's answer widened the floor to "fully
  portable, OS-agnostic": Windows through WSL treated as Linux, fragmentation
  measured by self-validation per platform.
- The R12 edit was made after a grep, and the grep changed it: CLAUDE.md never
  carried the "304 / 4,000" counts the finding attributed to it (they are
  bbh's README's). Only the MJC-52 citation was corrected — its own commit,
  before this one — and the mis-attribution is gotcha G8, the first incident
  in the contributor's own conduct that re-anchors CLAUDE.md §1.
- Slice estimate moved 14 → 15 sessions: S4 gains the adapter contract (R15)
  and its second framework.

## 2026-09-09 — slice S1 opens: the recount gate and what it did to the census

- The first BBX tool (`lib/py/bbx/recount.py`) and gate
  (`gates/census_recount.sh`, two declared must-fire controls) were written
  after all rulings were answered and the maintainer chose to open S1 in the
  same session.
- **The census was not machine-recountable as written.** Three producers,
  two pipe conventions (bbh raw, VS/SMS GitHub-escaped), ten malformed rows,
  and ~50 commands that print more than the number. Ruled into a grammar
  (`docs/census/README.md`, six rules) and the files normalized, document
  first: bbh 65 rows by script (raw pipes escaped, regex pipes to `[\|]`), 11
  rows by hand (double-backtick spans: bbh A33 A34 A36 A37 A38 A39 A45 A69,
  VS A24, SMS A80; bbh A43 dimension text), VS 21 command rewrites (A1 A20 A36
  A53 A75 A76–A86 A95 A118 A119 A125 A126), SMS 14 (A5 A20 A39 A40 A41
  A46–A50 A83 A84 A85 A93) and then 19 more (A30 A31 A54–A64 A88 A89 A91–A94)
  from `grep -r` to `git grep` after gotcha G9. Every rewritten row was re-run
  and matched its recorded count; no count was changed.
- **Not recountable by design and left so:** VS 27 rows, SMS 27 rows
  (free-form counts such as `150 / 167`, `says 319, is 410`, `filed` rows
  pointing at a HANDOFF line). Their number is the census's uncovered claims
  and may only go down.
- **Instrument findings:** G9 (two greps) and G10 (a never-matching pattern).
  Neither changed a count; both changed the grammar and the tool.

## 2026-09-09 — slice S1 step 2: the kernel, lifted and proved

- **How the kernel was built:** the lineage's own method — bbh's classifier,
  config reader, TOML subset, tier classifier and static runner lifted with
  their incident comments and a `Lifted from bbh …` line each, renamed
  `bbx`, and proved by F13 (9 pairs byte-identical after duration
  normalisation). New code is only where BBX generalizes: the three-layer
  defaults (consumer → kind profile → kind-blind, **M4**, so bbh's literals
  live under the name `frame-driven` and BBX's own tree under `self`), an
  empty tier pattern list meaning "nothing", the controls reader and the
  runner's controls block (R10, off by default for fidelity).
- **M4 (method):** a default true of one subject kind lives in that kind's
  profile, never in DEFAULTS; `[project].kind` defaults to `frame-driven`
  only because bbh configs carry no kind (D9, arbitrary — the third kind
  is its detector).
- **A control caught a defect before first use (BBX-5):** the controls
  reader classed a firing nobody declared as UNDECLARED when the gate had no
  declarations at all; `gates/controls.sh` §2 went red on the first run and
  the reader was corrected to RED. Not a gotcha: it never reached a run.
- **Plan correction:** F12 (the suite over bbh's example) moves from S1 to
  S2 — the suite's verdict lines are printed by the comparators, which are
  S2's deliverable. Recorded in `docs/fidelity.md` and `docs/slices.md`.
- Anti-hyperfocus checkpoint (BBX-27): the next most valuable thread is F14
  (the sweep runner, bbh's largest lifted piece) rather than the readout
  generator, because F14 is the last fidelity row S1 can prove without the
  comparators; the last green (`bin/bbx selftest`) means the kernel
  reproduces bbh on bbh's fixtures and BBX's own gates fire their controls —
  and nothing about any subject kind but the frame-driven one.

## 2026-09-09 — slice S1 step 3: the sweep runner, the fingerprint, F14, F15

- Lifted with citations: `bin/bbx-run-sweep` (bbh's 491-line sweep runner,
  every printed line kept), `lib/py/bbx/fingerprint.py` (the subject
  identity, settings resolved through the config layers), the [sweep],
  [fingerprint] and [suite] sections in three layers (kind-blind D15/D16;
  bbh's literals in the frame-driven profile, VampireSaved's build
  directories included and labelled). Two gates lifted from bbh's ground
  truth with controls declared (`sweep_runner`: env-default-export,
  prereq-stop; `fingerprint`: wholeset-only-row).
- **F14: 12 pairs identical; F15: 32 logs identical.** The one delta on the
  way was a finding about bbh's example (G11: a sourced lib's wrong
  fallback masked by the runner exporting BBH_HOME), disposed per
  `[BBH-82]` — recorded, both sides given the consumer's input, BBX not
  bent to leak the same variable.
- The runner's working-tree check caught the orchestrator editing docs
  during a run (readout, section 4). Run two, undisturbed, was clean.
- Anti-hyperfocus checkpoint (BBX-27): S1's fidelity obligation (F13–F15)
  is met; the two remaining S1 items (readout generator, platform gates)
  are cheaper than any S2 item and unblock nothing in S2, so S2 may start
  in parallel with them next session. The last green means: on bbh's
  fixtures and BBX's own gates, nothing was lost in the lift — and nothing
  yet about any comparison.

## bbx-1 CLOSE — 2026-09-09

- The maintainer asked for VampireSaved's end-of-session ritual, read there
  (VSP-17 in CLAUDE.md:233 and the skill, the rollover rule in STATE's
  header, VSP-18, VSP-162), and ruled the adaptation R17 as proposed.
- Close measurements: green first — `PASS 9 SKIP 0 FAIL 0 MISSING 0`,
  `controls fired 12 / declared 12`, tree clean during the run. Retraction
  sweep: `MFI-52`, `319 gate`, `74 of 319`, `no row runs yet`, `27 code
  files` appear only in the ledgers (gotchas, rulings, census README,
  readout, DECISIONS*) and, for "319", in the VampireSaved census row that
  explains it. Deferral sweep: empty. Defaults: 16 rows. Controls: every one
  of the 9 gates declares. Lineage: bbh 4 modified at f675710, VS 1 M +
  370 ?? at 5df1d8be, SMS clean at ecc5481 — as the census recorded.
- `STATE_HISTORY.md` born with the bbx-1 paragraph.
- Anti-hyperfocus checkpoint (BBX-27): the session ends at 68 % context by
  the maintainer's call, with S1's fidelity obligation met and two small S1
  items left; the most valuable next thread is S2's comparators, with the
  readout generator and the platform gates alongside. The last green means
  the kernel reproduces bbh on bbh's fixtures and BBX's gates fire their
  controls — and nothing yet about any comparison.

## bbx-2 — 2026-09-09 (session 2: the VampireSaved re-measure, R18)

- The sitting opened red (`census_recount` HEAD-MOVED: VampireSaved
  `5df1d8be` → `0cdd9726`, two commits). Re-measured at the tip; gotcha G12;
  R18 raised with a recommendation (recount on a read-only shared clone at
  the recorded HEAD, drift at the tip as a NOTE).
- The maintainer ruled R18 in their own words, wider than asked: "census
  and tests should either work on a clone or, if impossible, make very
  explicit that no change to the tree should be done"; clones also serve
  multiple instances on one commit; "clones are not mandatory but they are
  safe and we value safe. any similar implementation is fundamentally
  acceptable". They added the direction that parallel work is best as a
  pull queue with N workers (raised as R19, with VampireSaved's 14z-144
  measured as the precedent) — and R20 asks whether fidelity moves to a
  clone of bbh at `f675710`.
- Measurements that shaped the answer: `git clone --shared --no-checkout`
  of VampireSaved (`.git` 949 MB) + checkout → 1.76 s, 363 MB under
  `TMPDIR`; the bbx-1 census recounted on that clone at `5df1d8be` →
  `match=100 mismatch=0` in 19.8 s, with the lineage's tip at `0cdd9726`;
  and, across this sitting, VampireSaved's porcelain moved 373 → 377 and
  its `M` count 1 → 3 (a new gate script at 20:24, sweep logs at 18:11,
  19:09, 20:28) — another session working there live, none of it BBX. The
  working tree of a lineage is a moving target; a clone at the commit is
  the instrument.
- R19 answered the same evening: "agreed, although this should be like a
  default implementation/recommendation. In the end the principle must
  hold, the exact implementation matters little." Recorded so: the pull
  queue is the ruling, the FIFO token queue its default. Not lifted yet.
- R20's cost and risk were measured on the maintainer's question rather
  than argued: a clone of bbh at `f675710` costs 0.14 s shared / 0.32 s
  plain and under 3 MB; the fidelity gate on it PASSES with output
  identical to the in-place run but for `porcelain=4` → `0`; the four
  dirty files re-point VampireSaved build directories and touch no F13–F15
  row; a clone starts with no ignored files, so the read-only proof there
  can include `--ignored`, which the in-place proof cannot. A plain clone
  has no `alternates` dependence on bbh's object store during the run; the
  recommendation was revised to a plain clone (also for the recount, D17,
  +1.6 s on VampireSaved). Awaiting the answer.
- R20 answered: plain clone. The maintainer's note on why — the measurement,
  not the intuition, decided it. The gate moves onto a plain clone of
  `f675710` in the step that follows; the recount's clone becomes plain.
- The maintainer's correction on the queue's shape (answered entries under
  an Open heading): R18–R20 moved under an Answered heading, the rule
  written into the file, gotcha G14, and a gate (`rulings_shape`) so the
  shape is checked rather than remembered.
- R19 lifted (bbx-2, later the same evening): the barrier in `bbx-run-sweep`
  replaced by 14z-144's FIFO token queue, with a kind-blind
  `[sweep].clone_per_slot` (D21, off by default) for pinned trees per
  worker. Measured in the gate's fixture: at `--jobs 2` the third 1-s gate
  started 2 s before the 4-s gate ended (a barrier or a line cannot do
  that; at `--jobs 1` it started 3 s after — the known negative); two
  clones at HEAD, the base tree untouched, and without clones the same
  gates dirtied it (the other known negative). Fidelity F14 against bbh
  unchanged at `--jobs 1`.
- S1's readout generator landed (bbx-2): `bbx-run-static --log DIR` keeps
  a run (results, logs, controls, `run.txt` with the subject's HEAD,
  porcelain, platform), `bbx readout DIR [--against DIR]` prints the one
  screen, and every gate declares its blind spots as `NOT-ASSERTED:`
  header lines the screen aggregates — a gate declaring none is counted,
  not hidden. R21 raised: no Linux or WSL host exists on this machine
  (six runtimes checked, none present), so the platform runs of R3 need
  the maintainer's host or a container runtime; recommendation filed.
- The rulings-shape gate caught its author the same hour: the new "Open
  rulings:" line mentioned R3 in passing and no longer listed exactly the
  open ids. Reworded; the gate stays as it is.

## bbx-2 CLOSE — 2026-09-10

- Close measurements: green first, twice, kept — `PASS 12 SKIP 0 FAIL 0
  MISSING 0`, `controls fired 26 / declared 26`, tree unchanged in both,
  BBX-14 met on the generated screen (0 verdict differences at one HEAD).
  Sweeps gated (`close_sweeps` GREEN: 8 retraction rows, 0 hits outside
  the ledgers, 0 deferrals, 22 defaults rows, 59 citations resolved).
  Lineage: never entered (clones); the recount summaries report the tips —
  VampireSaved's tip moved again during the sitting (`e25e6f7`, 2 ahead).
- `docs/retractions.tsv` born with 8 rows, every wording this project has
  corrected so far; the register is the close's one remaining hand step.
- Anti-hyperfocus checkpoint (BBX-27): the sitting spent itself on the
  maintainer's three rulings (clones, the queue, the queue's shape) and on
  finishing S1's readout; each was measured before it was built and each
  new gate caught its author within the hour (R21's answer line, the
  untracked copies, the last-entry assumption). The most valuable next
  thread is S2's comparators — nothing on the screen yet says what a green
  rests on beyond controls, and that line is S2's. The last green means:
  BBX's own tree passes its own gates twice at one HEAD, its clones leave
  the lineage untouched, and bbh's verdict text is reproduced on bbh's
  fixtures — and nothing yet about any comparison.
- After the close (2026-09-10): the maintainer ruled R22 — a GitHub remote
  and pushing, superseding R7's "no remote, no push". Repository created
  private from this tree (`gh repo create`), `origin` set, `main` pushed;
  R21's bundle step replaced by a clone of the remote. Checked before the
  push with the two document gates, not the whole battery (a ruling and
  its ledgers; no tool changed).

## bbx-3 — 2026-09-10 (session 3: the NOTE fix; S2 planned, STOPPED, three of four rulings answered)

- Open: `bin/bbx selftest` GREEN, 12 gates, 26/26 controls, on the bbx-2 HEAD;
  the drift NOTE (VampireSaved 4 commits past the census, 16 rows moved) was
  in the census log and not on the screen — the handoff's first fix.
  `lib/py/bbx/readout.py` now lists every NOTE-class line; `gates/readout.sh`
  gained a perturbed-copy control (`note-follows-log`), proved both ways (a
  shadow generator with the feature stripped fails the gate). Battery GREEN
  after the fix: 12 gates, 27/27 controls.
- S2 planned before any tool (`docs/plans/S2.md`): the lift measured on the
  plain clone at `f675710` (11 files, 1,102 lines; 8 selftests; 62 frozen
  verdict lines; the example's expectation tree by kind); four rulings
  raised (R23–R26) and the STOP taken.
- The maintainer, same day: R23 agreed (family and view by kind); R25 agreed
  (a loosened threshold needs a ruling id — "thank you for respecting the
  rules"); R26 agreed (a per-kind driver home, bbh's for the frame-driven
  kind); R24 objected — a TSV register is a format that can break on a
  mishandled spacer character. Measured against the subset parser BBX
  already trusts: a TOML register with the file as a value and every field
  named parses, survives a tab or a pipe inside a string, and refuses a
  duplicate table; R24 revised to that form and left open for the answer.
- In force from this entry: R23, R25, R26. S2 steps 1–3 may open on them;
  step 4 (the register) waits on R24.
- Later the same sitting: S2 steps 1–3 built on R23/R25/R26 — the temporal
  family, the dispatcher with the kinds table, the suite with its kept run —
  every printed line bbh's (F12 17, F16 35, F17 52 pairs identical on the
  clone), 21 new controls, D23–D30. Two incidents filed with prices (G17: a
  default cited before its row, caught by the sweeps inside the battery; G18:
  a parameter abort exiting 0 under a trap, caught by the classifier's
  shell-error clause). Battery GREEN twice at one HEAD: 18 gates, 48/48.
- Anti-hyperfocus checkpoint (BBX-27), mid-sitting: the thread is still the
  most valuable one — S2 is what puts "what this green rests on" beyond
  controls onto the screen, and step 4 is the line that does it. The last
  green means: bbh's comparison vocabulary, dispatcher and suite loop run in
  BBX byte for byte over bbh's fixture and synthetic shapes; it does not yet
  mean any expectation's provenance is stated, and it says so.

## bbx-3 CLOSE — 2026-09-10

- Close measurements: green first, twice, kept — `PASS 18 SKIP 0 FAIL 0
  MISSING 0`, `controls fired 48 / declared 48`, tree unchanged in both,
  BBX-14 met on the generated screen (0 verdict differences at one HEAD).
  Sweeps gated (`close_sweeps` GREEN: 8 retraction rows, 0 hits outside the
  ledgers, 0 deferrals, 30 defaults rows, 86 citations resolved); no claim
  retracted this sitting (the TSV recommendation of R24 is declined, not
  false, and stays in the queue as such). Lineage: never entered (clones);
  bbh at f675710 porcelain 4; VampireSaved 6 commits past the census.
- The maintainer at the close: the two incidents are "working as intended";
  asked whether they carry a learning for the harness. Answer filed in G17
  (a mechanism: the kept run recording untracked entries, bbx-4's first
  small fix) and G18 (an authoring trap, no mechanism: the one that exists
  fired). Pushed at the maintainer's word ("push").
- Anti-hyperfocus checkpoint (BBX-27): the sitting built three of S2's four
  steps on the day's rulings and stopped where the fourth needs one; the
  most valuable next thread is step 4 — the register is the line that turns
  "expectations relied upon: none registered" into a histogram, which is
  what S2 exists to put on the screen. The last green means: bbh's
  comparison vocabulary, dispatcher and suite loop run in BBX byte for byte
  over bbh's fixture and the lineage's synthetic shapes, BBX's own gates
  prove each control fires, and nothing yet says where any expectation's
  numbers came from — and the screen says so.
- After the close (2026-09-10): R24 had been answered ("agreed", the
  revised TOML register) in the maintainer's message before the close and
  was recorded open by the contributor — corrected here, moved under
  Answered, its DECISIONS row added; S2 step 4 may open. The maintainer
  ruled R27: the close reviews the sitting's incidents for learnings
  (ritual step 10; the commit is step 11). Both pushed as a post-close
  correction (R22), checked with the three document gates, not the battery
  (rulings and their ledgers; no tool changed).

## bbx-4 — 2026-09-10 (session 4: S2 step 4, the suite screen; S2 complete)

- Open: the battery GREEN (18 gates, 48/48) on the bbx-3 HEAD, with a new
  NOTE: bbh's tip at `10a82d2`, one past the baseline — the maintainer
  committed the four dirty files and fixed G11 in bbh. Measured, not
  assumed: both fidelity gates run against the tip by the D20 override and
  PASS (F12–F17 identical); R28 raised to re-baseline at a close, with D12's
  five literals following. The census's bbh row A2 moved with it (a NOTE).
- Step 4 on R24: the register tool and its gate, the readout's suite screen
  (findings apart, the register's histogram, the real pairings by file),
  G17's mechanism on the static screen (untracked entries in the kept run);
  D31, D32; 11 new controls (55/55). Drafted and tested in a shadow home
  while the opening battery ran; one defect (real pairings counted by kind)
  caught there before the tree saw it.

## bbx-4 CLOSE — 2026-09-10

- Close measurements: green first, twice, kept — `PASS 19 SKIP 0 FAIL 0
  MISSING 0`, `controls fired 55 / declared 55`, tree unchanged in both
  (untracked 2 -> 2), BBX-14 met. Sweeps gated GREEN; the queue: 29 entries,
  27 answered, R21 and R28 open. Lineage never entered; bbh's tip one past
  the baseline (R28), VampireSaved ten past the census.
- Step 10 (R27), incidents reviewed for learnings: none reached a gate this
  sitting; the one draft defect was caught by the shadow test before the
  tree saw it, and that practice is now the handoff's rule. No mechanism.
- S2 is complete under CLAUDE.md §7 (its readout lists the six items); the
  estimate was 2 sessions, it took one and a half.
- Anti-hyperfocus checkpoint (BBX-27): the most valuable next thread is the
  re-baseline if ruled (a stale reference is rot class 4, and it is cheap
  now), then S3 — the first kind with no ancestor to diff against, which is
  where "generic" starts to mean something (BBX-25). The last green means:
  BBX runs bbh's comparison, dispatch and suite byte for byte, keeps a
  register in a closed vocabulary, and says on one screen what a suite run
  rests on — and that, so far, nothing rests on evidence about a real
  subject.

## bbx-5 — 2026-09-10 (session 5: the re-baseline as a procedure; two findings from bbh)

- The maintainer validated R28 and asked whether a re-baseline is a ruling on
  BBX at all — it is not: R8 and R20 already decide it, and D12 follows the
  baseline by its own definition. Recorded as R28's answer: a re-baseline is
  a procedure (`docs/rebaselines.md`, D20, D12, the census), never a queue
  entry. Done for `f675710` → `10a82d2` after both fidelity gates passed on
  the tip by the D20 override; the census re-measured (A2 19 → 20).
- Raised by the maintainer from bbh's work on its own must-fire contract:
  R29 (executable controls: a self-reported FIRED can be printed by a control
  that tests nothing — bbh's 14z-144 case; the runner driving the gate with
  `CONTROL=<name>` on its real path and requiring its own FAIL is strictly
  stronger and compatible) — recommended for S6, cadence per tier, open;
  R30 (the header is the leading comment block — bbh measured 264 of 315
  gates with a bare `#` within five lines) — ruled and built the same
  sitting: one reader, the readout importing it, a control that a body line
  declares nothing; the 19 gates' 55 declarations unchanged under both
  readers.
- bbh moved once more mid-sitting (`447e5d2`, README: the remote renamed
  BBH-frame-based); a NOTE.

## bbx-5 CLOSE — 2026-09-10

- Close measurements: green first, twice, kept — `PASS 19 SKIP 0 FAIL 0
  MISSING 0`, `controls fired 56 / declared 56`, tree unchanged in both
  (untracked 0 -> 0), BBX-14 met. Sweeps GREEN; the queue: 31 entries, 29
  answered, R21 and R29 open (the shape gate caught "R10 work" in the open
  line as an open id — reworded).
- Step 10 (R27): no incident reached a gate; no learning beyond the wording.
- Anti-hyperfocus checkpoint (BBX-27): the sitting spent itself on bbh's
  movement and two contract findings that came back from the lineage —
  the right use of a sitting, since a stale baseline is rot and a header
  rule that collides with the ancestor's own index would have been
  inherited unpaid. The most valuable next thread is S3's plan: the first
  kind with no ancestor to diff against. The last green means what bbx-4's
  did, on a newer bbh, with one reader of headers instead of two.
- After the close (2026-09-10): the maintainer agreed with R29's recommendation — the contract on `docs/controls.md` now, built in S6, the cadence per tier. Recorded and pushed as a post-close correction (R22), checked with the document gates.

## bbx-6 — 2026-09-10

- Open: `bin/bbx selftest` GREEN on `415c88b` (19 gates, 56 / 56 controls,
  tree unchanged; the two expected drift NOTEs — VampireSaved `efa0d3b`,
  14 past the census, 36 rows; bbh `447e5d2`, one past the baseline). The
  bbx-5 close re-derived. Read off the screen: the static run's generated
  sentence "the expectation register … is slice S2; until then …" — false
  since bbx-4, unnoticed on two close screens, the gate holding only its
  prefix. Fixed (the sentence true by construction; the gate holds the full
  clause; `gates/readout.sh` green, 7 controls); filed G19 — BBX-10's first
  re-anchor here; its learning, a rot gate over generated text for
  "until slice N" sentences, filed for S6.
- S3 planned (`docs/plans/S3.md`) and STOPPED. Measured on plain clones at
  the census commits: SMS `checkdocs.py` 1,500 lines, 37 hand checks, 17
  table validators, 5 sentence forms, 55 quotations, 4 control families
  (A35–A41 re-derived by the recount on the clone: 7 of 7 match);
  VampireSaved `checkdocs_rom.py` 815 lines, 15 checks, 14 PARAPHRASE
  mentions, a 205-line gate with 5 must-fire controls, a 31-row covered set
  compared as a multiset. Nothing lifted verbatim; no F row. Four rulings
  raised: R31 (the observation point is an integer index; logfmt stays
  bbh's), R32 (`[suite].scenario_ext` per kind; several expectation kinds
  per scenario; bbh's precedence verbatim under frame-driven, F12 the
  control), R33 (the coverage contract: five closed statuses, the
  denominator from `END <n>`, the covered set shrink-only, PARAPHRASE never
  BOUND, coverage never fatal), R34 (`schema … tsv` with four types and a
  rows line, checked before any value; `multiset … inventory | shrink-only`;
  `exact` by index; verdict text frozen by the family's own gate). DECISIONS'
  open line lists R21, R31–R34 (the shape gate caught the stale line first,
  as designed).
- Anti-hyperfocus checkpoint (BBX-27): the sitting did what HANDOFF named —
  the plan for the first kind with no ancestor — and one rot fix the screen
  handed it. Is S3 still the most valuable thread? Yes: two non-frame kinds
  are the proof of generality (CLAUDE.md §5), and S3 is the one with no
  executable. Does the last green mean what it is treated as meaning? It
  means the kernel and S2 are unchanged and BBX-14 is met on this host; it
  says nothing about the document-set kind, which has no gate yet — the
  plan's counts are DESIGN numbers until the fixture exists, and §4 says so.
- After the close (2026-09-10): the maintainer validated R31, R32, R33 (to be reworked only if experience proves the contract insufficient) and R34 (validated with the caveat that TSV breaks silently). On the caveat the contributor revised one design point of the plan with the answer recorded: the `claims`, `covered` and `schema` expectation files carry their rows as TOML-subset tables with named fields (R24's shape), the fixture's artifact stays a TSV as the subject R34's schema check guards, and a wrong column count becomes a fifteenth control. Recorded and pushed as a post-close correction (R22), checked with the document gates. S3 step 1 may open.

## bbx-7 — 2026-09-10

- Open: `bin/bbx selftest` GREEN on `d9b363b` (19 gates, 56 / 56 controls,
  tree unchanged; the two expected drift NOTEs). The maintainer validated
  R34's TOML revision at the open ("TOML is better in my experience") and
  voted to continue at 28 % context.
- S3 step 1 built (docs/plans/S3.md §8.1): the `document-set` kind profile
  (D33), `[suite].scenario_ext` (D34, R32) read by the suite loop and the
  enumeration helper, the fixture generator with `--check` and its named
  chirality predicates (D35, D36), the status vocabulary (D37), the fixture
  `fixture/docset/` as BBX's second consumer (20 files: the artifact, three
  documents, three claim sets, nine expectations, the registry row on the
  whole-set key, the register — every row `fixture`), `gates/docset_fixture.sh`
  (3 controls). Built and tested in a shadow tree first: the shadow caught
  one defect before the tree saw it (the enumeration helper reused the name
  `_ee_ext` for each file's extension and clobbered the scenario extension,
  so every enumeration went empty and exit 0 — two gates red in the shadow,
  none in the tree); fidelity F12 / F16 / F17 (104 pairings) and the suite
  gate (5 controls) green in the shadow after the loop change.
- Close: green first, twice, kept — `PASS 20 SKIP 0 FAIL 0 MISSING 0`, `controls fired 59 / declared 59; gates with no declaration: 0; red: 0`, tree
  unchanged in both, BBX-14 met. Sweeps GREEN; the queue: 35 entries, 34
  answered, R21 open.
- Step 10 (R27): the shadow's catch (the `_ee_ext` clash) — no mechanism;
  the practice held.
- Anti-hyperfocus checkpoint (BBX-27): the sitting built the first tool of
  the first kind with no ancestor and closed at the step boundary the
  maintainer chose ("close" at the pacing check). Is S3 step 2 still the
  most valuable thread? Yes: the driver is what turns the fixture from files
  into observations, and every later step reads its log. Does the last green
  mean what it is treated as meaning? It means the fixture is its
  generator's and chiral, the profile resolves, and bbh's suite text is
  unchanged by the loop change; it says nothing about binding, which no
  code yet does.

## bbx-8 — 2026-09-10

- Open: `bin/bbx selftest` GREEN on `e398abd` (20 gates, 59 / 59 controls,
  tree unchanged; the two expected drift NOTEs — bbh one ahead, VampireSaved
  19 ahead). Open rulings R21 only; the maintainer said "do it" to the ritual
  and the step.
- S3 step 2 built (docs/plans/S3.md §8.2): `lib/py/bbx/docset.py` (the
  extractor: quote, derive, bind; the two strings and the token in one place,
  D38; the lexical classes and the record key, D39; the unlisted-claim guards,
  D40; the self-test every run), `drivers/docset.sh` and `drivers/README.md`
  (the driver home D28 now has a driver), the generator's `truth` kind from
  the design (12 expectations + 3 truth logs, register 16 rows), and
  `gates/docset_driver.sh` (7 controls). Built in a shadow tree first.
- No ruling raised or answered. Two defaults classes stated as ARBITRARY
  (D39, D40) with the first real consumer named as their detector (BBX-24).
- Incidents: G20 (the self-test's blind spot, found by the `extractor-shadow`
  control in the shadow — paid 1 gate run); G21 (the plan's positional
  prediction from a keyed view — paid 0; the plan corrected in its own commit
  `d230fc7`, BBX-19, retraction X9).
- Close: GREEN twice at one HEAD — 21 gates, 66/66 controls
  (`build/selftest_20260910T110237Z`, `build/selftest_20260910T110956Z`); fidelity F12–F17 unchanged.
- Step 10 (R27): G20 — a trap (a self-test running through the tool's real
  path inherits its refusals), the control that found it is the mechanism;
  G21 — a mechanism candidate for S4 (the command-line kind's output lines
  are a positional view; `base+1` is its control), nothing built here. One
  hazard for step 4 filed in HANDOFF: `--freeze` writes `logs/<s>.log` for
  the `.sha1` kind, the same path the `.truth` kind names — the freeze must
  refuse to overwrite a truth log (a silent provenance downgrade otherwise).
- Anti-hyperfocus checkpoint (BBX-27): the sitting built the first driver
  of a kind with no executable and stopped at the step boundary. Is S3 step 3
  still the most valuable thread? Yes: the truth is compared here by `cmp` in
  a gate; the comparator families with frozen verdict text are what let the
  suite say it. Does the last green mean what it is treated as meaning? It
  means the binding agrees with the design on the fixture and the seven
  controls can each fail; it says nothing about a real document set, and the
  guards and forms are the fixture's.

## bbx-9 — 2026-09-10 (session 9: S3 step 3 — the exact, set and schema families; G22)

- Open: GREEN on `6a80ec7` (21 gates, 66/66 controls; the two drift
  NOTEs). The shadow tree built from HEAD then exposed G22: the fixture's
  three truth logs were `*.log`-ignored and never committed — a clone would
  have opened red. Fixed (`!fixture/**/*.log`, the logs added) with its
  mechanism: `bbx.provenance` refuses a registered file git does not track
  (`gates/provenance.sh` control `row-untracked`); `gates/docset_fixture.sh`
  runs the tool over the fixture's real register.
- S3 step 3 built (docs/plans/S3.md §8.3): `lib/py/bbx/compare_exact.py`
  (by index; short apart from diverged), `compare_set.py` (inventory both
  ways, covered shrink-only with `NOTE: covered-grew`), `compare_schema.py`
  (shape before any value, the first violation named); the `exact) set)
  schema)` branches of `lib/sh/compare.sh` (`compare_check` takes the
  scenario file and the artifact as trailing arguments); `bbx.docset rows`
  and `resolve` (the one artifact resolver, the driver now calls it);
  `finding.py`'s `FAIL unknown ` rule; `gates/set_schema.sh` (5 controls,
  38 verdict lines frozen and classified); D41, D42.
- The plan corrected in its own commit `08c9fef` (BBX-19, X10): the third
  profile's unknown-kind control lives in `gates/docset_fixture.sh` (bbx-7),
  not in `gates/expectation_kinds.sh`.
- No ruling raised or answered; R21 stays open.
- Incidents: G22 (paid 1 shadow run); the set family's duplicate label
  (`set-shrink-only` for `set-covered`), caught by the gate's frozen text in
  the shadow — no tracked file saw it; G23 (a backticked word run as a
  command inside the gate's banner; the shadow's bare run tested only the
  exit, the tree's classifier read the shell error — paid 2 close batteries).
- Close: GREEN twice at one HEAD — 22 gates, 72/72 controls
  (`build/selftest_20260910T123032Z`, `build/selftest_20260910T123545Z`); fidelity F12–F17 unchanged.
- Step 10 (R27): G22 — a mechanism, built this sitting (tracked-ness in the
  register tool) and a practice made explicit in HANDOFF (the shadow is a
  git tree built from HEAD so that it is a clone's view); the label — the
  gate's frozen text is the mechanism, nothing to add; G23 — a practice
  (the shadow runs every touched gate through `bin/bbx classify`), the
  mechanism exists and fired.
- Anti-hyperfocus checkpoint (BBX-27): the sitting built the three families
  and stopped at the step boundary. Is S3 step 4 still the most valuable
  thread? Yes: the comparators exist and are frozen, but no suite run has
  yet printed one of their lines or a coverage number on the screen — step 4
  is where the document-set kind becomes something the maintainer reads.
  Does the last green mean what it is treated as meaning? It means each
  family holds both ways on the fixture through the dispatcher and that the
  repository now holds what the gates compare against; it says nothing about
  a real document set, and G22 says a working-tree green is not a clone's.

## bbx-10 — S3 step 4 built: the suite's kinds loop, the kept run's notes, the coverage on the screen (2026-09-10)

- Open: the battery re-derived GREEN first (`build/selftest_20260910_144737`:
  22 gates, 72/72 controls, porcelain 0, the two expected drift NOTEs). R21
  the only open ruling; nothing else pending.
- Measured before building (§1): a caller's `DOCSET_NONDET=1` is SCRUBBED by
  the suite under the document-set profile (D33 `hermetic_unset`) — the two
  runs byte-identical, the suite on its verdicts — while the driver called
  directly under it writes differing logs. The plan's §5 row said the caller's
  variable reads NONDETERMINISTIC; corrected in its own commit `35c8007`
  (BBX-19, retraction X11) before the gate asserted the corrected behaviour.
  D33 stands (a salted token must never reach a freeze).
- Built (shadow first, every touched gate through `bin/bbx classify`): the
  kinds loop in `bin/bbx-run-suite` (selected off the kinds table: the
  temporal family means bbh's precedence loop, verbatim; anything else the
  kinds loop — `schema` first, the table's order, `.sha1` last; the printed
  shape `<scenario> <kind> <verdict>`; rows keyed `(scenario, kind)`;
  `notes.tsv`, D44; `NOT-EVALUATED (schema failed)`; `--freeze` for the
  shrink-only kind through `bbx.compare_set --freeze`, never a self-freeze
  beside an authored kind — the bbx-9 HANDOFF hazard closed by construction);
  `[suite].log_summary` (D43); `bbx.fingerprint --path` (the subject file the
  identity was computed from, handed to the comparators that read the
  artifact — proven equal to the driver's resolver on the fixture);
  `finding.py` (`NOT-EVALUATED` → `pending`; `authored ` as the prefix);
  the readout's suite screen (scenarios and pairings apart, `coverage:` per
  scenario from `notes.tsv`, BBX-14 over pairings, the driver's NOT-ASSERTED
  lines); `gates/docset_suite.sh` (6 controls; 29 printed lines of the green
  run frozen, 12 verdict lines classified `pass`; 17 suite runs, ~55 s); the
  registry row; the four gate headers that said "S3 step 4" re-pointed at
  the gate; `gates/readout.sh`'s three frozen lines moved with the screen.
- No ruling raised or answered; R21 stays open. No new default class:
  D43 and D44 are `principled`.
- Incidents: G24 (two blind-spot lines in `gates/suite.sh` naming "S2 step 4"
  as their future since bbx-4, G19's shape; paid 0); two defects of the new
  gate caught in the shadow — a tab-separated dump compared against a
  space-separated string, and two lookups concatenated into one comparison
  (paid 1 shadow run; no learning beyond the practice that caught them).
- Close: GREEN twice at one HEAD — 23 gates, 78/78 controls
  (`build/selftest_20260910T130844Z`, `build/selftest_20260910T131501Z`); fidelity F12–F17 unchanged
  (104 pairings identical on the plain clone at `10a82d2`).
- Step 10 (R27): G24 — the mechanism is G19's (the S6 rot gate over "until
  step N" sentences), now with two instances; the practice: a blind-spot
  line names the GATE that will close it, never a step number. The gate's
  two defects — the shadow-through-the-classifier practice is the mechanism,
  and it fired.
- Anti-hyperfocus checkpoint (BBX-27): the sitting built step 4 and stopped at
  the step boundary. Is S3 step 5 (the slice readout with the first file
  census) still the most valuable thread? Yes: the document-set kind now runs
  end to end through the suite and onto the screen; what is missing is the
  slice's own accounting — families per kind, controls declared / fired,
  provenance classes, defaults rows, the shared-vs-kind-specific file census
  — which is what lets the maintainer rule S3 done (§7) and S4 open. Does the
  last green mean what it is treated as meaning? It means the fixture's three
  claim sets pass their twelve pairings twice, that each control failed where
  it must, and that bbh's loop printed the same 104 pairings it did before;
  it says nothing about a real document set (every expectation is fixture
  class), and the kinds loop has one profile driving it (BBX-25 unmet, stated
  in the gate's header).

## bbx-11 — S3 step 5: the slice readout and the first file census; S3 laid before the maintainer for the DONE ruling (2026-09-10)

- Opened on the bbx-10 HEAD with the battery GREEN (23 gates, 78/78, tree
  unchanged; the two drift NOTEs the handoff predicted) — the re-derivation
  step of the ritual.
- Step 5 as planned (`docs/plans/S3.md` §8.5): no tool written. The slice
  readout in `docs/readout.md` (families per kind measured off the kinds
  tables — document-set 3, frame-driven 1; controls declared / fired per
  gate off the kept run — the S3 gates 21 / 21 against the plan's design of
  fourteen; the fixture register's 16 rows — fixture 15, registry 1; the
  defaults D33–D44 by class; CLAUDE.md §7's six conditions answered one by
  one in a table the maintainer rules on).
- The first shared-vs-kind-specific FILE CENSUS, `docs/census/bbx_files.md`:
  measured at RUNTIME in a shadow tree (an instrumented copy; every gate run
  once with a fresh trace), a gate's kind derived from what it executed —
  a grep over the gates' words was measured first and declined (it mis-files
  three kernel gates on the word `masked` in their synthetic fixtures). 37
  files: 11 executed by both kinds' gates (the contracts), 7 + 7 by one kind
  only (the two comparator families with their driver and helper), 5 + 3 by
  one kind and the kernel, 4 by the kernel only, 0 by no gate. Measured once,
  not gated — the generator is reproduced verbatim in the census's §C and
  the gate is S4's plan to decide (the handoff's rule).
- Plan corrected in its own commit before the readout quoted it (BBX-19):
  §6's `fixture 10, registry 1` is `fixture 15, registry 1` (12 expectation
  files + 3 truth logs); retraction X12.
- No ruling raised or answered; R21 stays open. No default added.
- Incident: G25 — the census instrument's first version inserted its trace
  line after the shebang, ending every header (R30); `gates/docset_suite.sh`
  went red in the shadow on the driver's missing blind-spot line; the trace
  discarded as contaminated tooling, the instrument corrected (insert after
  the leading comment block), the gate re-run green and the census run a
  second time end to end (paid 1 shadow gate run, 86 s).
- Step 10 (R27): G25's learning — an instrument that touches a file is a
  header edit until proven otherwise; prove the instrument on the gates
  before reading a number off it (BBX-5); the header is one VIEW shared by
  three readers (BBX-16). The shadow-through-the-classifier practice fired a
  fourth time. The learning that would improve the harness: a file-census
  gate that reads the traces and fails on a file reached by no gate or by
  one kind only where two are expected — S4's plan, with the third kind.
- Anti-hyperfocus checkpoint (BBX-27): the sitting did the slice's
  accounting and stopped at the slice boundary. Is S4's plan — the
  command-line kind, the second consumer of `schema` and of the kinds loop,
  the third instance the abstraction needs — the most valuable next thread?
  Yes: S3's green is one non-frame instance, and CLAUDE.md §5 says one
  proves nothing; the file census already names what S4 must exercise (the
  dispatcher `bin/bbx` reached by one gate, the runners by no document-set
  gate). Does the last green mean what it is treated as meaning? It means
  the fixture's twelve pairings pass twice, every control fails where it
  must, bbh's 104 pairings are unchanged, and the harness files split as the
  design said — on a fixture, on this host, with self-reported controls; it
  is not a statement about any real document set, and the readout says so
  in its own words.

## bbx-12 — the S4 plan written and STOPPED at R35–R40 while S3's DONE ruling is pending (2026-09-10)

- Opened on the bbx-11 HEAD with the battery GREEN (23 gates, 78/78, tree
  unchanged; the two drift NOTEs the handoff predicted) — the re-derivation
  step of the ritual.
- The maintainer's instruction: "do what you can until I can give you my
  ruling on S3 DONE." What does not depend on that ruling is the next STOP
  (HANDOFF's orientation: "then the STOP: S4's plan"), so the sitting wrote
  `docs/plans/S4.md` in the S3 plan's shape and queued R35–R40. The plan's
  header records that it was written before S3's ruling and waits if S3 is
  ruled not done. No tool written (CLAUDE.md §6, §9).
- The ancestors measured at the census commits, each count with its command
  (the plan's §2): bbh's fixture and driver by line, SMS `cliguard.py` (the
  incident behind refusing an unknown option: a typo that regenerated the
  file it was meant to check), VampireSaved's MiSTer band "+/- 30, root-cause
  rather than widen" (the tolerant-numeric family's ancestor: a band is an
  expectation, never a knob — 0 tools take a tolerance option), the host's
  tooling (pytest, bats, docker absent: the adapters are proven over
  `unittest` and BBX's own gate battery, both on R3's floor), BBX's plug-in
  points by line.
- Six rulings raised, each with the declined alternatives: R35 (the `.cli`
  scenario and the observation grammar; a tool's non-zero exit an observation,
  a signal death the guard, exit 2 — which corrects `docs/generality.md`'s
  "exit 1" row after the ruling), R36 (the `band` kind: inclusive measured
  band, `--freeze` refuses to widen without a ruling id, `NOTE: band-fields`),
  R37 (the two frameworks), R38 (the self subject's `command` identity over
  the tree hash of `bin`, `lib`, `drivers`; the refreeze a reviewed close
  step), R39 (the file census as a generated document and a shrink-only
  static gate on the first sweep row, plus a portable gate on the instrument
  with G25 as a mode), R40 (the JSON schema's seven types).
- None answered; R21 stays open. No default added (ids are assigned when the
  rows are written). No retraction.
- Incident: none filed. One event caught before the commit —
  `gates/rulings_shape.sh` red on DECISIONS.md's open-rulings line after the
  six entries were queued (`open-line-mismatch listed=R21 actual=R21,R35,…`);
  the line updated in DECISIONS.md and STATE.md, the gate PASS
  (`entries=41 open=7 answered=34`). Paid: one gate run, 1 s.
- Step 10 (R27): the event re-read for a learning — the gate is G14's
  mechanism (an answered ruling moved, an open one listed) holding a hand
  step to the queue both ways; it fired on the first sitting that queued more
  than one ruling at once, which is the design; no learning beyond its own
  rule, and no gotcha, since nothing was paid that a gate did not refund.
- Anti-hyperfocus checkpoint (BBX-27): is the next thread still the most
  valuable one? The next thread is not the contributor's to choose — two
  rulings are pending (S3 DONE, R35–R40) and both are the maintainer's;
  writing the plan while waiting was the one thing that did not pre-empt
  either, and the plan says in its header which ruling it waits on. Does the
  last green mean what it is treated as meaning? It means the bbx-11 tree
  plus one plan and six queue entries still passes 23 gates with every
  control firing, on this host; it is not a statement about S3's DONE (the
  maintainer's), nor about any S4 tool (none exists), and the readout says
  so in its own words.
- **Post-close (2026-09-10):** the maintainer ruled **S3 DONE** on the bbx-11
  table ("From what I see, S3 looks done") — CLAUDE.md §7's six conditions for
  the document-set kind as a fixture. Recorded in `docs/slices.md`'s S3 row,
  `docs/plans/S3.md`'s status line, under the table in `docs/readout.md`,
  STATE and HANDOFF; pushed as a post-close correction with this entry (R22).
  S4 now waits on R35–R40 only.
- **Post-close (2026-09-10), the S4 rulings:** the maintainer answered R35–R40
  one by one in the session. R35 (the `.cli` scenario and the observation
  grammar; a tool's non-zero exit an observation, a signal death the guard),
  R36 (the `band` kind), R37 (`unittest` and BBX's own gate battery), R38 (the
  self subject's `command` identity, a reviewed refreeze at the close) and R39
  (the file census as a generated document and a shrink-only static gate on
  the first sweep row) validated as recommended. R40 (the JSON schema format)
  validated with a caveat in the maintainer's words — "no caveat on R40 but a caveat on the use of TSV elsewhere" — the
  same caveat R34 carried; applied: every file S4 introduces is a TOML-subset file (the `.cli` scenario, the `unordered`, `schema`, `band` expectations, `expected/file_census.toml`); the kernel's pre-existing TSVs (`results.tsv` D30, `notes.tsv` D44, `registry.tsv`, `gates/sweep.tsv`) are not multiplied, and the gates adapter reads `results.tsv` by column name only, never the printed rows. Before R35 was recorded,
  `docs/generality.md`'s crash row was corrected in its own commit (X13,
  BBX-19). S4 step 1 may open; the STOP is lifted.

## bbx-13 — S4 step 1 built: the command-line profile, the `.cli` scenario, the token vocabulary, the fixture and its gate (2026-09-10)

- Opened on the bbx-12 HEAD `a2014a2` with the battery GREEN (23 gates,
  78/78, tree unchanged; the two drift NOTEs the handoff predicted) — the
  re-derivation step of the ritual. R21 the only open ruling; R35–R40 answered
  and S3 ruled DONE after the bbx-12 close, so step 1 was cleared to open.
- The plan corrected FIRST, in its own commit `ddeb0aa` (BBX-19), on five
  wordings the built fixture differs from — each measured on the shadow build
  before the tree saw it: the tool at `subject/fakecli.py` so the whole-set key
  covers the subject alone (X14), 9 options with `--sleep` (X15), 7 refusal
  paths (X16), `CLI_PATH` not scrubbed — D33's shape (X17), 5 commands (X18),
  `stdin` as an array of lines under the subset's no-escape rule (X19).
- Built (the readout's bbx-13 section): the `command-line` profile (D45), D34
  amended with `cli`, the `.cli` grammar (D46), the token vocabulary in
  `lib/py/bbx/cli.py` (D47 — the one writer, grown into the driver at step 2),
  the band spec's shape (D48), the JSON schema spec's shape and seven types
  (D49), the fixture's chirality predicates (D50); `fixture/fakecli/` with its
  generator's `--check` (predicates on the tree's tool, regenerate-and-diff,
  and the TOOL-CHECK: the tool run directly for every scenario against the
  design); `gates/cli_fixture.sh`, 4 controls. Defaults D45–D50: six rows,
  each with its class, before first use (BBX-24).
- The design targets: the kinds loop, the dispatcher and the three existing
  families changed by ZERO lines (measured: `git diff --stat a2014a2` over the
  seven files empty); 22 TOML-subset files read by the subset parser, 0
  refused (R40's caveat measured); no new TSV.
- No ruling raised; R21 stays open. No retraction beyond the plan's six.
- Incidents: none filed as a gotcha. Four events caught before the commit,
  priced in the readout: three in the shadow (the gate's `sed` perturbations
  written in the design's quoting while the generated tool carries Python's
  repr; a copied generator locating the docset design relative to itself; the
  fix's parent depth off by one) and one in the tree — `bbx.provenance`
  refusing 22 rows naming files git did not yet track, the G22 guard on the
  mirror case (the shadow had committed what the tree had not staged). Paid:
  four gate runs of ~3 s and one battery aborted at its first minute.
- Step 10 (R27): re-read for learnings — two, both hazards in `HANDOFF.md`:
  a generator that reads a sibling fixture locates it through the harness
  package root, never through its own path (a copy has no siblings); and the
  new gate is run in the TREE, through the classifier, before the battery —
  the shadow cannot see an unstaged file, and the battery would have gone red
  on the same line six minutes later. No mechanism: both are the practice.
- Close: GREEN twice at one HEAD (`build/selftest_20260910T171631Z`, `build/selftest_20260910T172316Z`): 24 gates, 82/82 controls, tree unchanged, BBX-14 met; close_sweeps and rulings_shape PASS; one close commit, pushed (R22).
- Anti-hyperfocus (BBX-27): the thread was step 1 as the plan wrote it; the
  one place it pulled — a tool-check inside `--check`, not in the plan — was
  taken because a truth log written from a design nobody ran is a claim about
  a tool that may not exist (BBX-5), and it is 30 lines. Step 2 is the next
  most valuable thread: nothing here is an observation until a driver writes
  one.

## bbx-14 — S4 step 2 built: the command-line driver's core, `drivers/cli.sh`, `gates/cli_driver.sh` (2026-09-10)

- Opened on the bbx-13 HEAD `bd8e8d0` with the battery GREEN (24 gates,
  82/82, tree unchanged; the two drift NOTEs the handoff predicted) — the
  re-derivation step of the ritual. R21 the only open ruling; step 2 needs
  R35, answered at bbx-12.
- Built (the readout's bbx-14 section): `lib/py/bbx/cli.py` grown from the
  token vocabulary into the driver's core (the scenario reader, `resolve`
  over `CLI_PATH`, the hermetic environment with the sandbox as HOME and
  TMPDIR, `run` with the O5 records, the crash log, the band view, `summary`,
  the self-test with FIPS 180-1's vectors as the reference anchor);
  `drivers/cli.sh` with D4's four exits; `gates/cli_driver.sh`, 7 controls.
  Defaults D51 (`CLI_TIMEOUT` 60 s, arbitrary), D52 (the subject's
  environment: D6's set plus the `[env]` table, the sandbox, the records),
  D53 (the crash log, the band view, a JSON stdout that is not one object
  observed as lines): rows before first use (BBX-24). D43 and D45 amended
  with `log_summary = python3 -m bbx.cli summary` — by D45's own text ("joins
  the profile with the driver at step 2"), not a new decision.
- The plan needed no correction (BBX-19 asked); the details it left open are
  decided in the rows above and stated in the readout. HANDOFF's suggested
  re-hash through `bbx.sha1` was not used: it is the same `hashlib` as the
  writer; the gate re-hashes two points with `shasum` (perl's Digest::SHA).
- The design targets: the kinds loop, the dispatcher, the three families,
  `expectations.py`, `finding.py` and `fixture/` changed by ZERO lines
  (measured: `git diff --stat HEAD` over them empty); the truth logs
  regenerate byte for byte under the grown writer.
- No ruling raised; R21 stays open. No retraction.
- Incidents: none filed as a gotcha. One event, priced in the readout: the
  shadow's portable tier NOT GREEN on `close_sweeps` — D51 and D52 cited by
  the new code with their register rows written in the tree and absent from
  the shadow built from HEAD (one shadow tier run, ~3 min). The guard is
  BBX-24's mechanism on a sequencing fact; the tree read PASS with the rows.
  No defect of the new code was found in the shadow or the tree.
- Step 10 (R27): re-read for learnings — one, a hazard in `HANDOFF.md`: the
  shadow does not carry a register row written in the tree; write the row in
  both, or read the shadow's `close_sweeps` red as exactly that. No
  mechanism: the guard is the mechanism, and it fired.
- Close: GREEN twice at one HEAD (`build/selftest_20260910T180335Z`, `build/selftest_20260910T181015Z`): 25 gates, 89/89 controls, tree unchanged, BBX-14 met; close_sweeps and rulings_shape PASS; one close commit, pushed (R22).
- Anti-hyperfocus (BBX-27): the thread was step 2 as the plan wrote it; the
  one place it pulled — the reference-vector anchor inside the self-test —
  was taken because a vocabulary that rests on one hash function should name
  what that function must produce on a value nobody here chose (§3.3), and
  it is four lines. Step 3 (the comparators over these logs) is the next most
  valuable thread: a log nobody compares is an observation nobody has judged.

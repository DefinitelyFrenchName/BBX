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


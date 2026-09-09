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

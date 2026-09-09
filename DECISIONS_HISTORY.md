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

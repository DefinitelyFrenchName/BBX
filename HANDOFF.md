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
| the four bins, every item | `docs/bins.md` (index + totals) → `docs/bins/{bbh,vampiresaved,sms}.md` |
| the abstraction as contracts | `docs/abstraction.md` |
| the generality proof (two non-frame kinds, their fixtures) | `docs/generality.md` |
| the fidelity plan, F12+ | `docs/fidelity.md`; re-baseline log `docs/rebaselines.md` |
| the slice sequence with the estimate | `docs/slices.md` |
| the maintainer readouts, one section per step, the CLOSE section last | `docs/readout.md` |
| the controls contract (must-fire grammar, R10) | `docs/controls.md` |
| the defaults register (BBX-24) | `docs/defaults.md` |
| the kernel | `bin/bbx` (dispatcher: `run-static run-sweep classify tier config controls fingerprint recount selftest`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (BBX as its own consumer, kind `self`) |
| BBX's gates and registries | `gates/*.sh` (9), `gates/portable.txt`, `gates/static.txt`, `gates/sweep.tsv` (empty) — run with `BBX_BBH_HOME=~/Developer/blackbox-harness bin/bbx selftest` (~117 s) |
| the recount tool | `bin/bbx recount <census.md> [--only A1,A2] [--root DIR]` |

## The lineage on this machine

| repository | path | remote |
|---|---|---|
| bbh | `~/Developer/blackbox-harness` | github.com/DefinitelyFrenchName/blackbox-harness |
| VampireSaved | `~/Developer/Vampire_Saved/VampireSaved` | github.com/DefinitelyFrenchName/VampireSaved |
| SMS-FrenchName-edition | `~/Developer/SailorMoonS` (directory name differs) | github.com/DefinitelyFrenchName/SMS-FrenchName-edition |
| bbh's skill | `~/.claude/skills/blackbox-harness` → symlink into bbh | load it before touching any gate, driver or comparator |

bbh is **never modified** from here. VampireSaved and SMS are read only.

## What is running

Nothing in the background. `BBX_BBH_HOME=~/Developer/blackbox-harness
bin/bbx selftest` (~117 s) is GREEN: 9 gates, 12/12 controls. Run it first
thing, with no edits in flight (the runner's working-tree check reports a
concurrent edit as DIRTIED); the census recount inside it is the
re-derivation step of the ritual (CLAUDE.md §6.2) made into a gate.

## The ritual (ruled R17 at the bbx-1 close, 2026-09-09; adapted from VampireSaved VSP-17/VSP-18/VSP-162)

Sessions are keyed `bbx-N`, one key per sitting, never renamed (pointers in
readouts, gotchas and history resolve through it). This sitting is **bbx-1**.

**Open**
1. Read this file, `STATE.md`, `docs/rulings.md`. (`CLAUDE.md` is the
   constitution, not the map.)
2. Re-derive before relying: `BBX_BBH_HOME=~/Developer/blackbox-harness
   bin/bbx selftest`, alone, with no edits in flight. A HEAD-MOVED line from
   the recount means a lineage repository moved: re-measure that census file
   (`bin/bbx recount … --only`) before anything else. A red fidelity pair
   means bbh or BBX moved: read `docs/rebaselines.md` before touching either.
   A red row is the session's first finding (BBX-26: it halts feature work).

**Close, in this order**
1. **Green first.** Run the battery once more, alone. The close quotes its
   tally line and its controls line verbatim. Not green: the close says
   NOT GREEN and why; the next session's first task is ruled by BBX-26.
2. **Nothing evaporates into prose.** Every number measured this sitting is
   reproduced by a gate or a census row, or is labelled "measured once, not
   gated" in the readout — the honest floor, not a backlog.
3. **The readout** (`docs/readout.md`): the sitting's section — verdict,
   counts separately, controls fired / declared, fidelity rows, what it rests
   on, what the green does NOT assert, next. This is the one screen the
   maintainer reads; it is BBX's CLOSE row.
4. **STATE** rewritten as a lean living page; the outgoing status paragraph
   appended verbatim to `STATE_HISTORY.md` under the session key. The twin
   is the ledger: one paragraph per sitting, never rewritten.
5. **HANDOFF** (this file): the routing table, what is running, and the
   next-session orientation below, rewritten; committed with what it
   describes.
6. **DECISIONS / DECISIONS_HISTORY**: new rulings in force; the sitting's
   history entry ends with the anti-hyperfocus line (BBX-27).
7. **Gotchas with prices; rulings with recommendation and declined
   alternatives.** Nothing pending silently.
8. **Sweeps, each with its result shown:** the retraction grep for every
   claim corrected this sitting (BBX-22, hits allowed only in the ledgers:
   gotchas, rulings, census README, readout, DECISIONS*); the deferral grep
   (TODO, TBD, FIXME, placeholder text) → empty or listed; every new default
   has a `docs/defaults.md` row; every gate declares its controls
   (`bin/bbx controls declared <gate>`).
9. **Lineage untouched:** bbh, VampireSaved and SMS porcelain and HEAD equal
   what the census recorded (bbh: 4 modified at f675710; VS: 1 M + 370 ??
   at 5df1d8be; SMS: clean at ecc5481).
10. **One close commit** per sitting, tally in the message; no push (R7).

Steps 8 and 9 become a portable gate in S1 step 4, so the close is checked
rather than remembered.

**Next-session orientation (written at the bbx-1 close)**
- S1 has two items left: the readout generator (abstraction RO1–RO3 as a
  tool that reads a run's results and prints the one screen, with a gate)
  and the platform gates (R3: a Linux or WSL run of `bin/bbx selftest`,
  recorded in the readout). Neither blocks S2.
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
- bbh's working tree is dirty (4 files). The fidelity baseline is the commit,
  not the tree (R8). If bbh's HEAD moves, `docs/fidelity.md`'s baseline line
  is re-measured and the change is a dated line, never a silent edit.
- Three counters inside VampireSaved's own docs are stale (see
  `docs/census/vampiresaved.md`); do not quote VampireSaved's prose numbers,
  quote its commands.
- This host's interactive `grep` is ugrep, not BSD grep (gotcha G9). Never
  verify a census count through the interactive shell; use
  `python3 lib/py/bbx/recount.py <census> --only <ids>`, which runs under a
  pinned PATH.
- Two recounts running at once in one tree are not a known problem (the
  inflation seen while bisecting G9 was the grep, not the overlap), but the
  tools in the SMS tree do run for minutes; run the gate alone.

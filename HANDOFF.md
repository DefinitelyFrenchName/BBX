# HANDOFF — the map for the next session

Shape: operational map. Read this first, then `STATE.md`, then
`docs/rulings.md`. `CLAUDE.md` is the constitution, not the map.

## Where things are

| what | where |
|---|---|
| the constitution | `CLAUDE.md` (§0, §1 outrank everything) |
| the opening prompt (session 1's brief) | `FIRST_PROMPT.md` |
| what is true now | `STATE.md` |
| rulings in force / how they came to be | `DECISIONS.md` / `DECISIONS_HISTORY.md` |
| the open rulings queue | `docs/rulings.md` |
| the incident ledger with prices | `docs/gotchas.md` |
| the measured census (3 files + protocol + verifier records) | `docs/census/` |
| the four bins, every item | `docs/bins.md` (index + totals) → `docs/bins/{bbh,vampiresaved,sms}.md` |
| the abstraction as contracts | `docs/abstraction.md` |
| the generality proof (two non-frame kinds, their fixtures) | `docs/generality.md` |
| the fidelity plan, F12+ | `docs/fidelity.md`; re-baseline log `docs/rebaselines.md` |
| the slice sequence with the estimate | `docs/slices.md` |
| the maintainer readouts (session 1; S1 step 1) | `docs/readout.md` |
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

## The ritual for session 2 (CLAUDE.md §6)

1. Read this file, `STATE.md`, `docs/rulings.md`.
2. Re-derive before relying: `BBX_BBH_HOME=~/Developer/blackbox-harness
   bin/bbx selftest`. A HEAD-MOVED line from the recount means a lineage
   repository moved: re-measure that census file (`bin/bbx recount … --only`)
   before anything else. A red fidelity pair means bbh or BBX moved: read
   `docs/rebaselines.md` before touching either. A red row is a finding.
3. Finish S1 (step 4): the readout generator (abstraction RO1–RO3) as a
   tool that reads a run's results and prints the one screen, with a gate;
   the platform gates (R3) — a Linux or WSL run of `bin/bbx selftest`
   recorded in the readout. Then open S2 (`docs/slices.md`).
   Every lifted file cites its bbh origin in its header; every new default
   gets a row in `docs/defaults.md` before it is used; every new gate
   declares its controls (`docs/controls.md`) or the self-run goes red.
4. `CLAUDE.md` is edited only with maintainer approval (R16). A defect found
   in it goes to `docs/rulings.md` with proposed wording.
5. Before ending: update `STATE.md` and this file; append to
   `DECISIONS_HISTORY.md`; price every incident in `docs/gotchas.md`; convert
   every measurement into a rerunnable case.

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

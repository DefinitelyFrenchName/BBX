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
| the maintainer readout of session 1 | `docs/readout.md` |

## The lineage on this machine

| repository | path | remote |
|---|---|---|
| bbh | `~/Developer/blackbox-harness` | github.com/DefinitelyFrenchName/blackbox-harness |
| VampireSaved | `~/Developer/Vampire_Saved/VampireSaved` | github.com/DefinitelyFrenchName/VampireSaved |
| SMS-FrenchName-edition | `~/Developer/SailorMoonS` (directory name differs) | github.com/DefinitelyFrenchName/SMS-FrenchName-edition |
| bbh's skill | `~/.claude/skills/blackbox-harness` → symlink into bbh | load it before touching any gate, driver or comparator |

bbh is **never modified** from here. VampireSaved and SMS are read only.

## What is running

Nothing. No gate exists. No background process.

## The ritual for session 2 (CLAUDE.md §6)

1. Read this file, `STATE.md`, `docs/rulings.md`.
2. Re-derive before relying: run the command block in `docs/census/README.md`
   and confirm the three HEADs and the headline numbers; if any moved, that is
   the session's first finding and the census rows it touches are re-measured
   before anything else.
3. Check which rulings are answered. If R0, R1, R3 and R9 are answered, slice
   S1 may start (`docs/slices.md`); its first deliverable is the census
   recount gate (R9), with its must-fire (a wrong HEAD). If they are not, the
   session's work is whatever the maintainer's answers require and nothing
   else.
4. If R12 is answered, correct `CLAUDE.md` first, in its own commit, then
   sweep for the old wording (BBX-22) and show the empty grep.
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

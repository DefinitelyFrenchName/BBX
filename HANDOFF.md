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
| slice S2's plan (measured census of the lift, design, fidelity rows, controls, rulings R23–R26) | `docs/plans/S2.md` — STOPPED for rulings 2026-09-10 |
| the maintainer readouts, one section per step, the CLOSE section last | `docs/readout.md` |
| the controls contract (must-fire grammar, R10) | `docs/controls.md` |
| the defaults register (BBX-24) | `docs/defaults.md` |
| the kernel | `bin/bbx` (dispatcher: `run-static run-suite run-sweep classify tier config controls fingerprint recount readout compare selftest`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (BBX as its own consumer, kind `self`) |
| the comparison (S2 steps 1–3) | the temporal family `lib/py/bbx/compare_{flicker,window,composite}.py`, `check_diverge.py`, `propose_temporal.py`, `thresholds.py` (R25), `logfmt.py`; the one dispatcher `lib/sh/compare.sh` (R23: family by kind); the kinds table `lib/py/bbx/config.py` `[expectations].kinds` read by `lib/py/bbx/expectations.py` and `lib/sh/expectation_kinds.sh`; the suite `bin/bbx-run-suite` (`--log DIR`: results.tsv with a FINDING column, `lib/py/bbx/finding.py`; R26 driver home) |
| BBX's gates and registries | `gates/*.sh` (18: 14 portable incl. `temporal`, `thresholds`, `compare_dispatch`, `expectation_kinds`; 4 static incl. `fidelity_bbh_s2` (F12, F16, F17) and `suite`), `gates/portable.txt`, `gates/static.txt`, `gates/sweep.tsv` (empty) — run with `BBX_BBH_HOME=~/Developer/blackbox-harness bin/bbx selftest` (~6 min on a loaded host: the two S2 static gates are ~70 s and ~60 s) |
| the readout, generated | `bin/bbx selftest --log build/selftest_<stamp>` keeps the run; `bin/bbx readout <dir> [--against <dir>]` prints the one screen (RO1–RO3; BBX-14 met only with `--against` a second kept run at the same HEAD) |
| the retractions register (BBX-22) | `docs/retractions.tsv`, read by `gates/close_sweeps.sh` |
| the recount tool | `bin/bbx recount <census.md> [--only A1,A2] [--root DIR] [--in-place]` — runs on a plain local clone of the recorded commit (R18, R20); `--in-place` is the unproved escape hatch |

## The lineage on this machine

| repository | path | remote |
|---|---|---|
| **BBX (this tree)** | `~/Developer/generalized-blackbox-harness/BBX` | github.com/DefinitelyFrenchName/BBX (private, R22) |
| bbh | `~/Developer/blackbox-harness` | github.com/DefinitelyFrenchName/blackbox-harness |
| VampireSaved | `~/Developer/Vampire_Saved/VampireSaved` | github.com/DefinitelyFrenchName/VampireSaved |
| SMS-FrenchName-edition | `~/Developer/SailorMoonS` (directory name differs) | github.com/DefinitelyFrenchName/SMS-FrenchName-edition |
| bbh's skill | `~/.claude/skills/blackbox-harness` → symlink into bbh | load it before touching any gate, driver or comparator |

bbh is **never modified** from here. VampireSaved and SMS are read only.

## What is running

Nothing in the background. `BBX_BBH_HOME=~/Developer/blackbox-harness
bin/bbx selftest` (~6 min) is GREEN twice at one HEAD: 18 gates, 48/48 controls. Run it first
thing, with `--log build/selftest_<stamp>` and no edits in flight (the runner's working-tree check reports a
concurrent edit as DIRTIED); the census recount inside it is the
re-derivation step of the ritual (CLAUDE.md §6.2) made into a gate.

## The ritual (ruled R17 at the bbx-1 close, 2026-09-09; adapted from VampireSaved VSP-17/VSP-18/VSP-162)

Sessions are keyed `bbx-N`, one key per sitting, never renamed (pointers in
readouts, gotchas and history resolve through it). The last closed sitting is **bbx-3** (2026-09-10); the next is **bbx-4**.

**Open**
1. Read this file, `STATE.md`, `docs/rulings.md`. (`CLAUDE.md` is the
   constitution, not the map.)
2. Re-derive before relying: `BBX_BBH_HOME=~/Developer/blackbox-harness
   bin/bbx selftest`, alone, with no edits in flight. A `drift` line in the
   NOTE block means a lineage repository moved past a census's recorded HEAD
   (the moved row ids are listed): the census is still true of its commit;
   re-measure it (`bin/bbx recount …`, then a dated line at its end) only
   when a slice needs the current lineage. A red census row means the census
   file rotted. A red fidelity pair means bbh or BBX moved: read
   `docs/rebaselines.md` before touching either. A red row is the session's
   first finding (BBX-26: it halts feature work).

**Close, in this order**
1. **Green first, twice, kept.** Run the battery alone, twice, each with
   `--log build/selftest_<stamp>` (BBX-14 needs two runs at one HEAD); the
   close quotes the tally line and the controls line verbatim. Not green:
   the close says NOT GREEN and why; the next session's first task is ruled
   by BBX-26.
2. **Nothing evaporates into prose.** Every number measured this sitting is
   reproduced by a gate or a census row, or is labelled "measured once, not
   gated" in the readout — the honest floor, not a backlog.
3. **The readout** (`docs/readout.md`): the sitting's section opens with
   the GENERATED screen, verbatim — `bin/bbx readout <second run> --against
   <first run>` — then what the generator cannot know yet: fidelity rows,
   what changed, next. Blind spots come from the gates' `NOT-ASSERTED:`
   headers; a gate declaring none is counted on the screen. This is the one
   screen the maintainer reads; it is BBX's CLOSE row.
4. **STATE** rewritten as a lean living page; the outgoing status paragraph
   appended verbatim to `STATE_HISTORY.md` under the session key. The twin
   is the ledger: one paragraph per sitting, never rewritten.
5. **HANDOFF** (this file): the routing table, what is running, and the
   next-session orientation below, rewritten; committed with what it
   describes.
6. **DECISIONS / DECISIONS_HISTORY**: new rulings in force; the sitting's
   history entry ends with the anti-hyperfocus line (BBX-27).
7. **Gotchas with prices; rulings with recommendation and declined
   alternatives.** Nothing pending silently; an answered ruling is MOVED
   under an Answered heading, never annotated under Open (G14; gated by
   `rulings_shape`, which also holds DECISIONS.md to the queue both ways).
8. **Sweeps — gated since bbx-2 (`gates/close_sweeps.sh`, in the battery):**
   every claim corrected this sitting gets a row in `docs/retractions.tsv`
   (BBX-22; the gate fails on the wording anywhere but the ledgers the row
   allows); deferrals (TODO, TBD, FIXME) fail; a `D<n>` cited with no
   `docs/defaults.md` row fails; every gate declares its controls (the
   runner refuses otherwise). The close's only hand step here: write the
   retraction rows.
9. **Lineage untouched — by construction and by proof (R18):** the recount
   never enters a lineage tree (clone); the fidelity gate runs in bbh's tree
   and proves its tracked porcelain unchanged. The close quotes each
   lineage's tip and porcelain from the recount summaries; they are
   reported, not required equal to the census (VampireSaved is worked on
   live by another session — its tree is nobody's baseline).
10. **Incidents reviewed for learnings (R27, ruled at the bbx-3 close).**
    Every incident of the sitting — caught by a gate or discovered after
    the fact — is re-read for a learning that would improve the harness: a
    mechanism becomes the next sitting's first small fix (or a ruling, if
    it changes a contract), a trap becomes a hazard below, and "no
    learning" is written in the gotcha entry so the question is seen to
    have been asked. Measured, never assumed (§1).
11. **One close commit** per sitting, tally in the message, pushed to
    `origin` (R22; a post-close correction is pushed with it).

Steps 8 and 9 are checked, not remembered: step 8 by `close_sweeps`, step 9
by construction (the recount's clone) and by `fidelity_bbh`'s proof.

**Next-session orientation (written at the bbx-3 close, 2026-09-10)**
- Open first: `bin/bbx selftest --log build/selftest_<stamp>` and `bin/bbx readout` on it. The VampireSaved `drift` NOTE is a lineage moving (6 commits past the census at this close), not a red.
- First small fix (G17's mechanism): `bin/bbx-run-static --log` records the UNTRACKED entry count before and after the run in `run.txt` (it prints nothing — the printed working-tree block is bbh's, tracked-only, read by F13), and `readout.py` shows it on the `tree during the run:` line, so a file written under the tree during a battery is on the screen rather than in a rule.
- S2 step 4 opens on R24 (answered: the expectation register as TOML — one bare table per row, the file a value, every field named). Build: `lib/py/bbx/provenance.py` lifted from bbh's over that format with R11's eight classes, `gates/provenance.sh` (a file with no row, a row with no file, a class outside R11, a duplicate file value), the screen's "expectations relied upon" histogram read from a kept suite run's set, and the "comparator classes … never PASSed on a real pairing" line — `docs/plans/S2.md` §3 E3 and §6.
- Then the S2 slice readout (CLAUDE.md §7: gates + controls, F12/F16/F17, every frozen expectation's class, D23–D30, what the green does not assert, rules re-anchored) and the close.
- A background battery: nothing under the tree changes while it runs — an untracked file counts, the sweeps read it (G17).
- R21 is still open: the maintainer produces the Linux/WSL run by the procedure in the entry; the S2 gates add two facts for that host: bytecode is kept out of the clones (`PYTHONDONTWRITEBYTECODE`), and the kind-blind `hash_cmd` is a python one-liner (D27).

**Orientation carried from the bbx-1 close (still true where not superseded above)**
- S1 has two items left: the readout generator (abstraction RO1–RO3 as a
  tool that reads a run's results and prints the one screen, with a gate)
  and the platform gates (R3: a Linux or WSL run of `bin/bbx selftest`,
  recorded in the readout). Neither blocks S2. Done at bbx-2 on top of the
  plan: R18–R20 (clones), R19's pull queue and `clone_per_slot` in the sweep
  runner, the `rulings_shape` gate; the close sweeps (steps 8–9) are still
  hand-run.
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
- VampireSaved is worked on concurrently by another session (bbx-2 saw its
  porcelain move 373 → 377 and its `M` count 1 → 3 in one sitting). Never
  read a fact off its working tree; the census's clone at the recorded
  commit is the instrument.
- A gate piped into `tail` in a `&&` chain checks nothing: the pipe's exit
  is `tail`'s (G16: a red `close_sweeps` was committed and pushed that way).
  Run the gate to a file, test its own exit, then read the file.
- The suite's derived configs must live IN the consumer copy: `[project].root = "."` resolves against the config file (a config under TMPDIR reads "unregistered build" because the registry is unreachable — `gates/suite.sh`'s own second defect).
- A parameter abort under an armed EXIT trap exits 0 on this host's `/bin/sh` (G18); the classifier's shell-error clause reads it as FAIL, but a chain that tests only the exit does not.
- A subshell that inherits `set -e` ends at its first failing command, before an `echo "exit=$?"` that follows it: a pair helper capturing a tool's exit needs `set +e` inside the subshell (the S2 fidelity gate's first defect); a state-setting helper called inside `$(…)` sets nothing the parent can read (G18).
- Two recounts running at once in one tree are not a known problem (the
  inflation seen while bisecting G9 was the grep, not the overlap), but the
  tools in the SMS tree do run for minutes; run the gate alone.

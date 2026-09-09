# Gotchas — the incident ledger, with the cost of each entry

Shape: ledger, one `## ` heading per entry, append-only, newest last. Every
entry names what happened, what caught it, what it cost (`paid:`), and the
rule it re-anchors if any. An entry with no price is not credible to a
skeptic (CLAUDE.md §6). Rules in CLAUDE.md §4 stay `[inherited]` until an
entry here re-anchors them; this file is where that happens.

## G1 — The HOME directory is a git repository, so "is a git repo" was true and meaningless (paid: 0 — caught in plan mode, 2026-09-09)
`git rev-parse --show-toplevel` from `BBX/` returned `/Users/koneko`: an
accidental repository at HOME with three commits of unrelated documents.
Every `git status` from an un-initialised project directory lists the whole
home tree, and commit one would have landed there. Caught by measuring the
root before trusting the environment's "is a git repository: true". Fix:
`git init` in `BBX/` (ruling R6). The HOME repository is left alone: not ours.
Re-anchors: CLAUDE.md §1 ("when you think you know, you measure to check").

## G2 — The constitution cited a rule that does not exist (paid: ~1 grep, 2026-09-09)
CLAUDE.md BBX-5 cites `MFI-52`; MFI's range in VampireSaved is 1..46. The
paragraph it describes is `MJC-52` (`.claude/skills/mister-jtframe-core/SKILL.md:85`).
Found by re-deriving every citation in §4 rather than reading past them (the
mapping agent reported "MFI-52 DOES NOT EXIST", then the orchestrator grepped
the sentence). Cheap here; the price of an unchecked citation grows with
every check later written against it. Ruling R12 holds the correction.
Re-anchors: BBX-21 ("every rule cites its incident") — a citation is a claim
and is checked like one.

## G3 — Numbers in the lineage's own README were filed counts (paid: 0 — labelled, not carried, 2026-09-09)
"304 gates, 4,000 frozen expectations" (bbh README line 6; NOT repeated in CLAUDE.md — see G8)
measure today as 311 gates and 4,808 / 3,814 expectation files (`docs/census/vampiresaved.md`).
VampireSaved's own docs carry three more stale counters (319 vs 410 gotchas
entries; 553 vs 555 rules; 1,891 vs 2,311 masked specs). Each was correct
when written. Re-anchors: CLAUDE.md §1 ("inherited numbers are re-derived,
not carried forward") and BBX-18 applied to the harness's own documents.

## G4 — The ancestor's defaults carry the lineage's moving build names — the biased default, observed before BBX has a single default (paid by bbh: one commit plus 4 dirty files, 2026-09-08)
bbh's `lib/py/bbh/config.py` DEFAULTS name VampireSaved's build directories;
each VampireSaved freeze rots them and the fix touches code, doc, consumer
config and fidelity test in lockstep (bbh commit f675710 and the identical
uncommitted edit on top of it). BBX-24 names this: a default calibrated on
one consumer and presented as generic, and the second consumer is its
detector. Re-anchors: BBX-24 (inherited; this is the incident, in the
ancestor). Ruling R8 keeps the dirty state as a recorded finding.

## G5 — A doctrine with no machine reader is doctrine only (paid by VampireSaved across five hardening passes; measured here 2026-09-09)
VampireSaved's rot taxonomy calls the dead control the worst and only silent
class, yet its must-fire marker is prose in 74 of 311 gates with 15+
spellings and no registry. Nothing gates the presence of the control that
gates everything else. Re-anchors: BBX-6 (inherited); ruling R10 proposes the
mechanism.

## G6 — The local clone's directory is not the repository's name (paid: one failed `find`, 2026-09-09)
`SMS-FrenchName-edition` lives at `~/Developer/SailorMoonS`. Every census
command names the path explicitly and the census file's line 2 records the
remote URL. Re-anchors: BBX-23 (archaeology before theory: check the remote,
not the name).

## G7 — A subagent's filed count was wrong by a third, and only the re-run caught it (paid: 0 — caught by protocol, 2026-09-09)
The SMS mapping agent reported "27 code files carry a negative control". When
asked to write the census with every number produced by a command, the same
agent re-ran the grep and measured **18** files (30 lines); the earlier 27 was
a miscount. The plan file for this session had carried 27 as a filed count
labelled as such, and nothing downstream had used it. Re-anchors: CLAUDE.md
§1 ("a number someone else reports is a filed count, not a measurement") —
the one BBX rule that already has its first incident in this project.

## G8 — The orchestrator attributed a number to a file it had not grepped, and only "measure before you edit" caught it (paid: one corrected ruling and three corrected documents, 2026-09-09)
Ruling R12's second finding said CLAUDE.md "quotes bbh's README figures 304 /
4,000 by inheritance". It does not: `grep -n '304\|4,000' CLAUDE.md` is
empty. The figures are bbh's README only. The claim was written from memory
of reading the README and the constitution together, and it reached
`docs/rulings.md`, `docs/gotchas.md` G3, `STATE.md` and `docs/readout.md`
before the pre-edit grep exposed it. Had the edit been made from the
finding, the constitution would have gained a label for a number it never
carried. Re-anchors: CLAUDE.md §1 third clause — the edit was the moment of
certainty, and the grep was the measurement it demanded. **This is the
project's first re-anchoring incident in the contributor's own conduct.**

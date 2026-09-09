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

## G9 — Two programs answer to the name `grep`, and every human and agent in this session used the one that lies about ignored files (paid: ~1 hour of bisection, 2026-09-09; would have been a permanent false census)
The interactive shell on this host resolves `grep` to ugrep 7.8 (skips
gitignored files and archives); `sh -c` resolves `/usr/bin/grep`, BSD grep
(reads everything, including two `.tar` files under `tools/Flips/` in SMS that
contain the bytes "vampire"). The census producers, the three verifiers and
the orchestrator all measured through the interactive shell, so the
verification reproduced the producer's instrument, not the count: six SMS
rows "matched" three times and were wrong for any other host. The first
recount, running under `sh`, was the third party (BBX-15) that exposed it.
Fix in two places, neither a loosening: the recount runs every command in a
hermetic environment (`docs/defaults.md` D6, PATH pinned), and recursive
greps over the working tree are no longer admitted in the census grammar —
searches use `git grep`, whose universe is the tracked tree at the recorded
HEAD (`docs/census/README.md` rule 6). Nineteen SMS rows rewritten; every
count reproduced under `git grep`, because ugrep's ignore behaviour had
coincided with "tracked files" — which is what the producers meant.
Re-anchors: BBX-15 (a third, lineage-independent party) — the first
re-anchoring by an incident in *this project's own instrument*.

## G10 — A pattern that could never match measured "0 forward references", and the verifier reproduced the 0 by re-running it (paid: 0 — caught by reading the row while rewriting it, 2026-09-09)
SMS census A93 counted files mentioning blackbox-harness or bbh with
`grep -ril 'blackbox-harness\|blackbox_harness\|bbh'`: after the markdown
unescape the pattern is a basic-regex literal containing pipes, which matches
nothing, so the count was 0 whatever the tree held. The verifier ran the same
command and reported MATCH. The corrected row (`git grep -ilwE …`) also
measures 0 — the claim was true, the evidence was not (BBX-2: "a gate born
against a live defect has never exercised PASS"). Re-anchors: BBX-8 (a
validator is re-run where it must fail) — this row never was; the recount's
moved-count control is the first such re-run in BBX.

## G11 — bbh's example consumer works only because bbh's runner leaks its own location into every gate (paid: 0 here — found by fidelity F14, which is what fidelity is for, 2026-09-09)
`example/tests/lib/needs_fake.sh` computes bbh's location as
`$(dirname "$0")/../../..` — but `$0` inside a sourced lib is the GATE
(`tests/g_needs_fake.sh`), so the path resolves one level above the bbh
tree. Under `bbh-run-sweep` the fallback never runs: the runner exports
`BBH_HOME` into every gate. Under `bbx-run-sweep`, which exports `BBX_HOME`,
the latent defect surfaced as the one delta of F14's real run (g_needs_fake
PASS under bbh, FAIL under BBX). Measured: `env -u BBH_HOME sh
tests/g_needs_fake.sh` fails from `example/`; with `BBH_HOME` set it passes.
Disposition (bbh `[BBH-82]`): a finding about the consumer, recorded, never
a fidelity failure and never fixed by making BBX leak the same variable; the
fidelity pair exports `BBH_HOME` on both sides as the consumer's input, the
way bbh's own F4 runs both sides with `MAME_BIN` unset. bbh is not modified
here; the maintainer may fix the lib's fallback in bbh (`../..`). Re-anchors:
BBX-16 (a claim reads in a view — here the view was "with the runner's
environment", never declared) and BBX-15 (the second implementation as the
third party).

## G12 — The first opening after the first close was red: the lineage moved two commits and the census's hand-read line citations rotted with it (paid: the opening of bbx-2 — one re-measure before any work, 2026-09-09)
`bin/bbx selftest` at the bbx-2 open: `census=vampiresaved.md head=5df1d8be
repo_head=0cdd9726c35b verdict=HEAD-MOVED rows=127`, `PASS 8 FAIL 1`. Between
the bbx-1 close and this open, VampireSaved committed twice (its `STATE.md`
gained two lines at line 42; one expectation was re-frozen). Measured before
any edit: a scratch copy of the census with the new HEAD on line 1 recounted
99 of 100 recountable rows unchanged and one moved (A77, `wc -l < STATE.md`,
1509 → 1511 — exactly the +3/−1 diff); every §B citation into `STATE.md`
sits below line 42, so all thirteen shift by two, and each old line was
diffed identical to its new line before the citation was re-pointed. Ten of
the thirteen are `read` rows, re-pointed by hand; three are `gen:G1` rows,
reproduced by re-running G1 (555 rows, diff empty). Header numbers: 1504
commits, 372 untracked (both new files under `build/`). The recount at the
new HEAD: `rows=127 match=100 mismatch=0 not_recountable=27`. Nothing in
the bins moved (they key by id).

Two lessons. (1) The recount did its job: a census is keyed by
(repository, HEAD) and refused to compare across a moved key — BBX-29 as a
mechanism, not a sentence. (2) A hand-read citation is a line number, and a
line number is a claim about one file version: the ten `read` rows rotted
on an edit that touched none of the lines they cite, while the three
generated rows cost nothing. The design question this raises — what the
recount should measure when the lineage moves, given that VampireSaved
commits daily — is ruling R18, with a recommendation; the tool is
unchanged until it is answered. Re-anchors: BBX-29 (keyed by subject
version — the HEAD-MOVED verdict is the rule firing) and BBX-9 (a
hand-maintained list is a smaller thing to forget: the `read` citations
are that list).

## G13 — Four census rows measured this machine, not the commit, and three in-place readers agreed with them; the clone disagreed on its first run (paid: 0 — found by R18's clone the day it landed; would have been a permanent false green on one row, 2026-09-09)
The first clone-based recount (`lib/py/bbx/recount.py`, R18) mismatched
bbh A3 (`git status --porcelain | wc -l`: 4 in the tree, 0 on a clone) and
SMS A13, A14 (`find` over gitignored `traces/` and `build/`: 5332 and 324
on disk, 30 and 37 tracked), and MATCHED SMS A4 (dirty paths 0) for the
wrong reason: on a clone that row is 0 whatever the tree holds, so it
could never have failed (BBX-2, BBX-8). The producer, the verifier and the
in-place recount had reproduced all four, three times, because all three
read the same view — this host's working tree — without declaring it
(BBX-16). The clone is a different view and the first lineage-independent
reader of the census's rows (BBX-15, the second time this project's own
instrument re-anchors it; G9 was the first). Fix, no loosening: rule 7 in
`docs/census/README.md` (a row measures the commit; a host fact is written
`host: <n> on <date>` and is not a count; the live porcelain is on every
summary line), the four rows re-labelled, bbh's and SMS's not-recountable
numbers up by one each with this entry as the reason. Re-anchors: BBX-16
(every extractor declares its view) and BBX-15.

## G14 — Three answered rulings sat under an "Open" heading with their answers written in; the maintainer read the heading, not the entries (paid: 0 — caught by the maintainer at bbx-2; the shape would have made every later reader of the queue trust a wrong heading, 2026-09-09)
R18, R19 and R20 were raised under `## Open — raised at the bbx-2 open` and
answered in place: the `- **Answer:**` line was filled and the heading left
as it was. The maintainer: "if R18 is fully ruled on, it should be in the
answered category, not in the Open category with a mention that it is
answered as this is typically the kind of dark pattern that leads to silent
issues." The failure is general to every ledger with state sections: a
heading is what a reader trusts at a glance, and an entry whose state
disagrees with its heading is invisible exactly to the reader who is
skimming for state. Fix: the entries moved under an `## Answered` heading,
the file's header states the rule, and `gates/rulings_shape.sh` fails on
the shape (an answer under Open, an `(open)` under Answered, an answered
ruling with no `DECISIONS.md` row, a DECISIONS row with no entry) — with a
shadow file in each wrong shape as its controls. Re-anchors: BBX-20 (a
document declares its shape and completeness is a check) and BBX-9 (the
rulings queue and DECISIONS are one registry, complete both ways).

## G15 — A commit message described edits that had not happened: the edit script aborted, the appends after it ran, and the commit was made on the appends alone (paid: one amended commit, caught by `git show --stat` one step later, 2026-09-09)
Commit cfe2535 as first made said "rulings queue reshaped — R18–R20 under
Answered, Open empty"; its diffstat was two files, the gotcha and the
history appends. The python edit script had asserted on a wrapped anchor
that the file held on one line, written nothing, and exited non-zero; the
shell's `cat >>` lines and `git commit` that followed did not depend on it.
The message was written from the intent, the commit from what happened.
Fix: the commit amended (unpushed, R7) once the edits were re-applied and
`grep -nE '^## '` had shown the new headings; from here on an edit-then-
commit command chains with `&&` from the edit to the commit, and the commit
step prints `git show --stat` so the message is read against the diffstat
before the next step. Re-anchors: CLAUDE.md §0 ("done" must be legible
without reading the file) and §1 (the commit was the moment of certainty).

## G16 — A red gate was committed and pushed because the chain tested `tail`'s exit, not the gate's (paid: one red commit on the remote for a few minutes, corrected in the next; 2026-09-10)
The R22 commit ran `sh gates/close_sweeps.sh 2>&1 | tail -1 && git commit
… && gh repo create … --push`. The gate printed `FAIL: see above` — the
new step-5 readout text named the deferral marker word in prose,
`docs/readout.md:495` — and the chain went on: a pipeline's status is its
last command's, and `tail` succeeded. The commit and the first push to
the new remote carried the red. Caught by reading the output the command
had already acted on. Fix, no loosening: the document reworded ("a
deferral marker"), and the rule for every chain from here — a gate runs
to a file, its own exit is tested, the file is read after (`sh gate >
out; rc=$?`). HANDOFF hazard added. Re-anchors: BBX-1 (exit status
decides before any text — here the text said FAIL and the status read
was a different program's) and, again, §1 (the push was the moment of
certainty). Same family as G15: a claim of "checked" written by the
chain's shape, not by a measurement.

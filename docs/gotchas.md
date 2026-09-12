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
Fixed in bbh at `10a82d2` (2026-09-10, the maintainer: "the example lib's root one level too high"); BBX's F14 keeps exporting `BBH_HOME` on both sides, which is correct either way.

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

## G17 — A default was cited before its register row existed, and the close sweeps went red inside the battery (paid: one battery run, ~4 min; 2026-09-10)
While the step-2 battery ran, S2 step 3's helper `lib/py/bbx/sha1.py` was
written citing `D27` — a row not yet in `docs/defaults.md`. The sweep walks
the tree, tracked or not, and the kept run's `close_sweeps.log` read
`cited-not-registered D27 in lib/py/bbx/sha1.py:2`: PASS 16, FAIL 1, NOT
GREEN. The row was written minutes later, in the same edit that added D28–D30
and the suite keys — the rule (BBX-24: "every new default gets a row before it
is used") was honoured in intent and broken in order, and the gate does not
read intent. Fix: the row; nothing loosened. The order for a background
battery from here: nothing under the tree changes while it runs — an
untracked file counts, because the sweeps read it. Re-anchors: BBX-24, and
BBX-26 (the red halted step 3 until it was understood). The learning worth a
mechanism (asked by the maintainer at the close): the runner's working-tree
check is bbh's, tracked-only (`grep -v '^??'`) and read by F13, so it cannot
change what it prints; the kept run can — `run.txt` recording the untracked
count before and after, the screen showing it on the `tree during the run:`
line. Filed as bbx-4's first small fix in HANDOFF.

## G18 — A gate's parameter abort under an armed EXIT trap exited 0 on this host, and the classifier read it as FAIL (paid: 1 gate run; 2026-09-10)
`gates/suite.sh` set its kept-run directory inside `suite_()`, which every
call ran in a command substitution; the parent's `$LOGDIR` was unbound. Under
`set -u` the parent printed `gates/suite.sh: line 50: LOGDIR: unbound
variable` and stopped a third of the way through — and its exit status was 0,
because an EXIT trap was armed: bbh `[BBH-14]`'s shape, reproduced here on
macOS `/bin/sh` (bash 3.2). Measured: `bin/bbx classify 0 <that output>` →
`FAIL exit 0 after a shell error: gates/suite.sh: line 41: LOGDIR: unbound
variable` — the kernel's `shell_error_regex` (D-row in `docs/defaults.md`,
lifted from bbh) turns the false green into a FAIL before any human reads
it. Fix: one fixed kept-run directory the parent knows. Re-anchors BBX-1
(exit status decides first — and the classifier's shell-error clause is what
makes a lying exit 0 decide FAIL). First time this lineage's rule fired on a
BBX gate rather than a fixture. The learning is an authoring trap, not a
mechanism (the mechanism already exists and fired): a helper called inside
`$(…)` sets nothing the parent reads, so per-run state lives in a fixed
path; and the two sibling defects of the same hour — `set -e` inherited by a
pair helper's subshell, a bash process substitution in a POSIX gate — are the
same family: a gate written faster than it was run. HANDOFF hazards carry
all three; none needs a rule loosened or added.

## G19 — The generated screen quoted a slice number as its future, and the sentence rotted the day the slice landed (paid: 0 — read off the screen at the bbx-6 open, two sittings after S2 closed; 2026-09-10)
Every static run's readout printed `expectations relied upon: none
registered — the expectation register with its provenance classes is slice
S2; until then no comparison against a frozen expectation is claimed`
(`lib/py/bbx/readout.py`, the static-run branch). True at bbx-2, false since
bbx-4: the register exists, the suite screen reads it (D32), and the line was
on the bbx-4 and bbx-5 close screens in `docs/readout.md` unnoticed. The gate
(`gates/readout.sh`) held only the prefix `none registered`, so the rot was
invisible to it — a stale reference (BBX-10, rot class 4) inside a GENERATED
artifact, the one place a reader trusts most. Fix: the sentence says what is
true by construction ("a static run compares against no frozen expectation;
a kept suite run carries its register's histogram") and the gate holds the
full clause. Re-anchors BBX-10 for the first time in this project: the rot
classes are a checklist for generated text too, and "until slice N" is a
sentence with an expiry date that nothing checks. Learning (R27): a
mechanism — S6's rot gates should grep generated and printed text for
`slice S[0-9]`, `until then`, `not yet` and refuse them outside a history
ledger, the deferral sweep's sibling (`close_sweeps` already refuses the
three deferral tokens in prose); filed for S6, not built here.

## G20 — The extractor's self-test could not name a broken form: with a regex broken, its own true line hit the number guard and the driver printed a REFUSED line about a synthetic sentence (paid: 1 gate run, in the shadow tree; 2026-09-10)
`lib/py/bbx/docset.py`'s self-test binds its synthetic lines through the
same path a document takes — and that path REFUSES an unlisted line that
carries a digit (D40). The `extractor-shadow` control (a shadow copy with the
`of-is` regex broken) therefore made the true line "The weight of Zork is
53." match no form and trip the number guard: the driver exited 1, the run
was discarded — correct — but the message was `REFUSED: … synthetic.md:1 (an
unlisted number …)`, not "form 'of-is' stopped matching", and the control
read DEAD on its first run, in the shadow, before the tree saw it. Fix: the
self-test catches the refusal on its true line and reports the form as not
found. Re-anchors BBX-5 (prove the instrument on a known positive before its
first real use: the control was written before the tool was trusted and it
found the tool's blind spot). Learning (R27): a trap, not a mechanism — a
self-test that runs through the tool's real path inherits the tool's real
refusals and must catch them; the control that found it is the mechanism.

## G21 — The plan predicted a positional effect from a keyed view: "the first data row deleted makes every bound claim MISMATCH" (paid: 0 — the gate's first run measured STALE at two indices; 2026-09-10)
`docs/plans/S3.md` §5's "shifted artifact" control was written in SMS's
`base+1` shape, where an address is positional and a shift moves everything.
The document-set artifact view is keyed by the record's name (D39): deleting
the artifact's first row turns the two claims about that record STALE
(indices 1 and 10 of `01_all`) and moves nothing else — measured by
`gates/docset_driver.sh` on its first run. The plan corrected first, in its
own commit (BBX-19; retraction X9), then the gate asserts the measured shape.
Re-anchors §1 (a prediction written with certainty is the one to measure)
and BBX-16 (the VIEW decides what a perturbation means; the same deletion
under a positional view is a shift). Learning (R27): a mechanism candidate
for S4 — the command-line kind's output lines ARE a positional view, and
`base+1` is its control; nothing to build here.

## G22 — The fixture's three truth logs were never in the repository: `*.log` in `.gitignore` swallowed `fixture/docset/expected/fixture/logs/`, and every gate was green because the working tree had them (paid: 1 shadow run — the bbx-9 shadow built from HEAD had no logs; a clone, R21's Linux run included, would have opened RED; 2026-09-10)
bbx-8 wrote the `truth` kind: the generator emits `expected/fixture/logs/<s>.log`
and the register names them (rows e13–e15), the driver gate compares every
run to them, and the close said "register 16 rows". The files sat under the
`.gitignore` rule `*.log` (written at birth for build output, with `docs/`
excepted) and were never staged; `git status` showed nothing because ignored
files are silent. Found at the bbx-9 open when the shadow tree, built with
`git archive HEAD`, ran `gates/docset_fixture.sh` (`--check`: 3 files DIFFER)
and `gates/docset_driver.sh` (every truth comparison red) — the first time a
gate ran on what the repository actually holds. Fix: `!fixture/**/*.log` in
`.gitignore`, the three logs added; and the mechanism: `bbx.provenance` now
requires every file a register row names to be one git TRACKS when the
expectation tree is inside a work tree (`git ls-files`), reporting the check
as *not run* outside one, never as passed — `gates/provenance.sh` control
`row-untracked` (a registered, present, ignored file FAILs naming it), and
`gates/docset_fixture.sh` runs the tool over the fixture's real register.
Re-anchors BBX-10 (rot class "missing operand": the operand was present here
and absent everywhere else) and §1 (the bbx-8 close's "16 rows" was measured
on a working tree, which is not the artifact that leaves it). Learning (R27):
a mechanism, built here — the tracked-ness check; and a practice: the shadow
is built from HEAD precisely so that it is a clone's view, and G22 is what
that view is for.

## G23 — A backtick inside a double-quoted `echo` ran a word as a command; the shadow ran the gate bare and tested only its exit, so the tree's classifier was the first to read the shell error (paid: 2 close batteries, ~12 min; 2026-09-10)
`gates/set_schema.sh`'s section-5 banner quoted `finding.py`'s word as
`` `unclassified` `` inside double quotes: the shell ran `unclassified`,
printed `line 153: unclassified: command not found`, and the gate went on to
its PASS line and exit 0. In the shadow the gate was run as `sh gate.sh` with
its exit tested — green. In the tree `bin/bbx selftest` read the log through
the classifier, whose shell-error clause (`[classify].shell_error_regex`,
lineage G18) turns "exit 0 after a shell error" into FAIL: both close
batteries went NOT GREEN on that one gate, with all 72 controls fired. The
classifier is the instrument that caught it; the shadow's bare run was the
blind spot (HANDOFF's own hazard: "a chain that tests only the exit does
not"). Fix: the quote, and the practice — every touched gate runs in the
shadow as `sh gate.sh > log; bin/bbx classify $? log`, the runner's reading,
not the shell's. Re-anchors BBX-1 (the exit decides first, then the text;
a PASS printed after a shell error is not a PASS) for the second time (G16,
G18 before it). Learning (R27): a practice, written into HANDOFF; the
mechanism already exists (the classifier), and it fired.

## G24 — Two blind-spot lines in `gates/suite.sh` named "S2 step 4" as their future, and the screen carried them for six closes after that step landed (paid: 0 — read off the gate's header while planning S3 step 4 at bbx-10, 2026-09-10)
`gates/suite.sh` declared `NOT-ASSERTED: the readout's reading of a kept
suite run: the screen reads bbx-run-static runs only until step 4` and
`NOT-ASSERTED: the .sha1 kind's evidence: … the register that says so is S2
step 4`. Both were true at bbx-3 and false since bbx-4, when the suite screen
(D32) and the register (D31) were built; the readout printed both sentences
under "what this green does NOT assert" on every close screen from bbx-4 to
bbx-9, unnoticed — the generated screen said the readout could not read a
suite run while the same screen's generator had been reading them for five
sittings. G19's shape exactly (BBX-10, rot class 4: a stale reference inside
a generated artifact), second instance: a NOT-ASSERTED line is read by the
readout like a claim, and "until step N" is a sentence with an expiry date
that nothing checks. Fix: both lines name the gate that asserts the thing
now (`gates/readout.sh`, `gates/provenance.sh`), and the four other
headers that said "S3 step 4" were re-pointed at `gates/docset_suite.sh` in
the same commit rather than left to rot. Learning (R27): G19's mechanism —
a rot gate over generated and printed text for "until slice N" / "is step
N" sentences, S6 — now has two instances behind it; a blind-spot line that
names a future step should name the gate that will close it instead, so the
sentence is checkable by the registry (a named gate exists or not) rather
than by memory.

## G25 — The file-census instrument inserted its trace line right after the shebang, which ENDED the header, and the document-set suite gate went red because the readout found no blind-spot line in the driver (paid: 1 shadow gate run, 86 s; 2026-09-10)
S3 step 5's file census (`docs/census/bbx_files.md`) measures which harness
files each gate executes, by instrumenting a shadow tree: one line per
`bin/*`, `drivers/*.sh` and `lib/sh/*.sh` that appends its own path to a
trace. The first version of the instrument put that line on line 2, after
the shebang. R30 defines the header as the LEADING COMMENT BLOCK — every `#`
line after the shebang up to the first non-comment line — so the inserted
line ended every header at line 1, and `drivers/docset.sh` had, for the
readout, no `NOT-ASSERTED:` line at all. `gates/docset_suite.sh`'s check
"the driver's blind spots on the screen (RO2)" failed on exactly that: the
missing line named. Twenty-two gates were green in the same shadow; the one
that reads a header through the readout was the one that caught it. The
gate's trace from that run was contaminated tooling (CLAUDE.md §1:
discarded, never adjusted); the instrument was corrected to insert after the
header (an `awk` over the leading block), the gate re-run green (83 s), and
the whole census run a second time with the corrected generator so the
recorded procedure is the one that produced the numbers, the two runs
compared byte for byte (BBX-14). Learning (R27): an instrument that touches
a file is a header edit unless it is proven not to be — prove the
instrument on the gates before reading a number off it (BBX-5: the first
run was that proof, and it failed where it should); the header is a VIEW of
the file (BBX-16) that every header reader — controls, readout, tier —
shares, so a line in the wrong place is plausible garbage in three readers
at once, and only the gate that happened to read the driver's header saw it.
The shadow-through-the-classifier practice is the mechanism, fourth time it
fired (bbx-7, bbx-8, bbx-10, bbx-11). Rules re-anchored in fact: BBX-5,
BBX-16, R30.

## G26 — The exact family failed every command-line log on its END rule: the plan had promised `compare_exact.py` unchanged for its second consumer, and a `git diff` of zero lines would have proved currency, not fitness (paid: 1 smoke run and the plan corrected, X20; 2026-09-10)
S4 step 3's first run of `compare_check … truth` over a driver log of the
command-line fixture printed `FAIL exact: the truth END 9 does not equal its
10 indices` for every scenario. The grammar D47 (ruled R35 at bbx-12, built
at bbx-13) puts the tool's exit status at index 0 and defines `END <n>` as
the LAST index; `compare_exact.py` (S3, bbx-9) checked END against the
NUMBER of indices, which the document-set grammar D38 makes the same thing
(indices 1..n) and the command-line grammar does not (0..n). The plan's §3
E1 row said "`compare_exact.py` UNCHANGED (its second consumer)" and its C3
paragraph repeated it; the design-target measurement planned for the close
(`git diff --stat` empty over the shared files) would have read GREEN on
that file while the family failed on every log of the kind — a measurement
on our own build locks currency, never correctness (CLAUDE.md §3.3). Nobody
had run the family over such a log: step 2's gate compared the driver's log
with `cmp` and DECLARED it — `NOT-ASSERTED: the verdict text of the exact,
set, schema and band comparators over these logs (S4 step 3)` — so the
blind spot was on the screen for one close and closed by the step that
owned it. The fix is one rule, `END` counts the indices ABOVE ZERO, under
which every document-set verdict is byte-identical (`gates/set_schema.sh`
PASS, its 38 frozen lines unchanged) and the five command-line truths PASS;
the plan was corrected FIRST in its own commit (X20, BBX-19), the §2
ancestors row included. Learning (R27): "unchanged for its second consumer"
is a CLAIM until the second consumer's input has been run through the
component — write "expected unchanged, measured at step N" in a plan, and
make the step that lands a new input grammar run every family that claims
to be grammar-blind over it (the mechanism candidate: a line in the driver
gate that feeds one log through `compare_exact`, so the blind spot is
measured the sitting the grammar lands, not declared). Rules re-anchored
in fact: §1, §3.3 (currency is not correctness), BBX-19, BBX-25 (the second
consumer is the detector — here of the plan's promise).

## G27 — A close-commit message carried a sweep count typed before the sweep printed it: `citations=546` written, `547` measured (paid: 1 amend of an unpushed commit; 2026-09-10)
The plan-first commit of bbx-15 was written in the same command that ran
`close_sweeps` and `rulings_shape`, and its message quoted the sweep's
tuple from the previous run's shape with a number the author expected; the
gate printed `citations=547`. Read back beside the message one line later,
amended before the push. Nothing downstream read the wrong number, and the
commit's other counts were the printed ones. Learning (R27): a commit
message's numbers are assembled FROM the run's printed line — pasted, or
read by the command that writes the message — never typed from
expectation, however close; a hazard line in `HANDOFF.md`. Mechanism
candidate for S6's rot-gate queue (with G19, G24): a close gate that greps
the HEAD message's `close_sweeps PASS (…)` tuple against the kept
`close_sweeps.log` of the run it names. Rule re-anchored in fact: §1 ("when
you think you know, you measure to check" — the exact case).

## G28 — The kinds loop's new entrance check read a variable defined further down, and only the consumer whose table reaches that branch saw it: the command-line suite ran GREEN, the document-set suite gate died on `SUBJECT_FILE: unbound variable` (paid: 1 shadow gate run, 63 s, and 1 direct run; 2026-09-10)
The view column's check — every EVAL kind's view resolves before any
scenario runs — was placed right after the table was read, and `view_path
subject` echoes `$SUBJECT_FILE`, which the runner resolves forty lines
later. Under `set -eu` that is an abort. `fixture/fakecli/` declares no
`subject` view (its schema reads `json`, its band `bands`), so the first
consumer's suite ran GREEN twice and the readout came out clean; the
neighbouring gate `docset_suite.sh` in the shadow was the detector, and
even it named nothing: its helper copied a kept run that did not exist and
the gate ended under `set -e` with one `cp:` line and no FAIL of its own —
the suite run directly printed the cause. The check moved to just after the
identity is resolved (still before any scenario runs; the FAIL goes through
`finish RED` so the kept run says so). Learning (R27): G26's family in the
mirror — a branch a consumer never reaches is unmeasured on that consumer,
which is exactly why the shadow runs every neighbouring gate and not only
the new one; a hazard line in `HANDOFF.md`. Mechanism candidate, small,
for the next sitting's first fix: the two suite gates' positive section
guards `[ -d "$LOGDIR" ]` before copying, so a suite that never created its
kept run is a named FAIL line, not a dead helper (G18's family). Rule
re-anchored in fact: BBX-5 (prove the instrument on a known positive AND a
known negative — here the second consumer was the negative) and §1.

## G29 — The suite gate's frozen text was typed from a screen read, not copied from the run: one NOTE value wrong (`emitted-files 0` for the scenario that emits one file), a verdict cut at a fixed column that the 9-wide kind `unordered` overruns, and a header count typed as 16 where the run printed 15 (paid: 1 gate run, 95 s; 2026-09-10)
Three defects of the gate, none of the code, all found by the gate's first
run in the shadow: the 43-line frozen text differed at one character;
`cut -c34-` on the `unordered` pairing line began at the kind's last
letter, so `finding.py` read `unclassified` for one of twelve lines; and the
header's "16 suite runs" was written before the run's own NOTE printed 15.
The text is now the run's output file pasted; the verdict is taken after the
24-wide scenario field and past the kind's word, never at a column; the
count is the NOTE's. Learning (R27): G27's third instance (a commit message's
tuple, now a header's count and a frozen text) — a number or a text that a
gate freezes is READ FROM THE RUN that produced it, by the command that
writes it where possible (`cp`, not retyping); a hazard line in `HANDOFF.md`.
Mechanism candidate for S6's rot-gate queue, with G19, G24 and G27: a close
gate over every header's quoted counts (`~N s`, `N suite runs`, `N controls`)
against the kept logs' NOTE lines. Rule re-anchored in fact: §1 ("an
unmeasured figure is a guess wearing a citation").

## G30 — A must-fire control wrote an artifact OUTSIDE the sandbox and nothing declared it: the fixture's deliberate `os.abort()` made macOS file a crash report in the maintainer's home on every battery, ~25 of them in two days, until the maintainer reported it as a witness (paid: 1 maintainer report, 1 battery, 2 probe runs and 1 shadow build; 2026-09-11)
The maintainer, who cannot read the code, reported seeing Python crashes "for
a couple of days" and had already traced their origin to BBX sessions. A
witness, not an instrument (BBX-28), so it was converted into a reproducible
case before any theory: the archaeology first (BBX-23) — zero Python crash
reports before 19:53 local on 2026-09-10 across about forty kept battery
runs, then 23 that evening and 2 the next day, the first falling inside the
sitting that built `--crash-at` (bbx-14). The mechanism, then measured both
ways rather than read off the code (BBX-5): the fixture tool's `--crash-at 1`
left exactly ONE new `.ips` report, the same process killed with SIGKILL left
NONE. Nothing was broken — the control was correct, the driver caught the
death, the gate asserted on it. The defect was in what nobody had written
down. `drivers/cli.sh` promises its sandbox is removed after the run and its
NOT-ASSERTED lines enumerate the undeclared artifacts a tool may leave (a
file outside `emits`, a socket, the clock, the terminal); the crash report is
written by the OPERATING SYSTEM, outside that sandbox, into the maintainer's
home, and outlives the run. The harm was never a broken gate: it was that a
GENUINE Python crash now hid among deliberate ones, and the maintainer was
being trained to ignore the reports — BBX-6's silent-failure concern in
mirror image, a live control indistinguishable from a defect. Fixed under
R42 by dying with SIGKILL, measured to exercise the same driver path (exit 2,
the same three lines kept, the two crash logs differing only in the signal
name) and to leave no report; the naming of signal 6 stays under test in
`bbx.cli`'s self-test, which spawns no process. The blind spot itself is now
declared in the driver's contract, because a REAL subject that dies by a
fault signal will still leave one. Learning (R27): a harness is a program
that runs on somebody's machine, and a control's blast radius stops at the
sandbox only for the artifacts the harness itself writes — what the OS writes
ON THE SUBJECT'S BEHALF (a crash report, a core file, a system log entry, a
quarantine record) escapes it, so a driver contract lists what the HOST
records about a run, not only what the run records. Mechanism candidate for
S6: a gate that counts `~/Library/Logs/DiagnosticReports/*.ips` across a
battery and fails on any BBX-caused growth — the negative control this
incident never had. A hazard line in `HANDOFF.md`. Rules re-anchored in fact:
BBX-28 (the witness converted before the theory), §3.2/BBX-30 (a green that
hides what it does to the host is a lie of omission).

## G31 — An edit pattern anchored on indentation matched a LONGER line with the same tail and corrupted the generated tool's docstring; every gate passed, because nothing checks a generated file's prose (paid: 1 close battery stopped 1.5 min in and the close's two runs restarted; 2026-09-11)
R42's change was applied by a script whose second replacement was
`"            os.abort()"` — twelve spaces and the call. The generated tool's
DOCSTRING carried the same call under twenty-two spaces, so the twelve-space
pattern matched inside it as a substring and rewrote the prose line into a
splice of a comment and half a sentence. The tool still ran, so
`mkfakecli.py --check` said ok (it proves the tool EQUALS the generator's
output, and the generator had been corrupted identically: currency, not
correctness — §3.3, G26's family), `gates/cli_fixture.sh` passed on its nine
predicates, both crash gates fired, the whole portable tier was GREEN in the
shadow and one close battery was GREEN in the tree. The defect was found by
READING THE STAGED DIFF before the commit, by a human-shaped step no gate
performs. Learnings (R27), two: an edit pattern must be anchored on something
UNIQUE — a leading `\n` plus the exact indent, or the surrounding line — never
on an indent that a deeper line also contains; and a generated artifact's
PROSE is outside every check BBX has, so a generator's docstring, usage text
and comments are asserted by nobody and rot silently. Mechanism candidate for
S6, beside G19/G24/G27/G29: the fixture's `--check` compares the tool to the
generator, and a second, lineage-independent assertion — the design's option
list against the docstring's option list, both ways — would have caught this
in the same run. Rules re-anchored in fact: §3.3 (a measurement on our own
build locks currency, never correctness) and BBX-30 (this green did not
assert what its own subject's text says).

## G32 — A re-baseline moved two of the THREE gates that read its default: `gates/suite.sh` still clones bbh at `f675710` six sittings after `D20` became `10a82d2`, and its own header says it clones "at the baseline (D20)" (paid: 2 gate runs, ~2 min, at the bbx-18 open; 2026-09-11)
Found by reading the open rulings queue, not by a gate. R21's Linux procedure
quotes `bbh's baseline f675710`, which R28 replaced on 2026-09-10; grepping
the tree for that commit to see how far the staleness ran turned up something
else — `gates/suite.sh:28` sets `BASELINE="${BBX_BBH_BASELINE:-f675710}"`,
while `gates/fidelity_bbh.sh` and `gates/fidelity_bbh_s2.sh` both default to
`10a82d2` and cite `D20` for it. Three gates read ONE environment variable;
the re-baseline edited two of them and the register row, and the third kept
the old value with nothing to notice it. `D20`'s "where it lives" column named
only `gates/fidelity_bbh.sh`, so the register could not be the detector
either: a default whose readers are under-recorded is a default that moves
incompletely.
Measured both ways before any theory (BBX-5, §3.3): the gate was run at its
own default and with `BBX_BBH_BASELINE=10a82d2`, both with
`BBX_BBH_HOME=~/Developer/blackbox-harness`. Exit 0 both times, 77 printed
lines both times, and `diff` of the two outputs EMPTY. So nothing this gate
asserts reads what the two commits differ in — and they do differ inside the
tree it copies: `10a82d2` touched 7 files, three of them under `example/` and
`selftest/`, one being `example/tests/lib/needs_fake.sh`, whose root fallback
was one directory too high (bbh's own fix of BBX's G11). The gate copies
bbh's `example/` out of the clone, so the older tree it takes carries the
defect BBX reported upstream. The identical output locks CURRENCY, never
correctness: it says today's assertions do not touch the difference, not that
a future one will not.
Nothing was red and nothing printed wrong, which is why it survived: the
battery has been GREEN at 28 gates across every sitting since, and this gate
passed at the pinned commit each time. Its verdict text is therefore true of
`f675710` and undefined of the baseline every other bbh-facing gate uses.
Raised as R43 rather than fixed in place: changing a default is a ruling
(BBX-24), and the two candidate answers differ in more than a value — one
value read from one place, or a second register row admitting that this gate
is pinned to the commit its ground truth was lifted from.
Learning (R27): a default with more than one reader needs the READERS
enumerated in its register row, and the re-baseline procedure's "on both
fidelity gates" was the wording that made two feel like all. Mechanism
candidate for S6, beside G19/G24/G27/G29: a gate over `docs/defaults.md` that
reads every `BBX_*` environment name in the register, greps the tree for
`${NAME:-<value>}`, and fails BOTH ways — a reader the row does not list, and
a listed reader whose fallback differs from the row's value. That gate would
have failed on 2026-09-10, the day the re-baseline landed. Rules re-anchored
in fact: BBX-9 (a registry is complete both ways or it is a smaller thing to
forget), BBX-10 (stale reference, rot class 4 — found by maintenance, not by
a failure), §3.3 (identical output locks currency, never correctness).

## G33 — `git rev-parse "$c:lib"` in this session's shell measured a key for TWO of three trees and printed a plausible 40-hex digest: zsh applied `:l` to the variable and `HEAD:lib` reached git as `headib` (paid: 1 measurement discarded and re-run under `/bin/sh`, ~2 min; 2026-09-11)
Measuring R38's identity command across four commits, the loop printed three
different 40-hex keys — plausible, distinct, and wrong. `git` had said so:
`fatal: ambiguous argument 'headib': unknown revision or path not in the
working tree`, one line per iteration, mixed into the output. The mechanism,
reproduced on purpose rather than guessed: this session's shell is zsh, where a
bare `$c:lib` applies the history modifier `:l` (lowercase) to `$c` and leaves
the rest of the word, so `HEAD:lib` becomes `head` + `ib` = `headib`. It
happens INSIDE double quotes too. `$c:bin` and `$c:drivers` are untouched,
because `b` and `d` are not modifiers here — which is the dangerous part: git
resolved two of the three arguments, printed their hashes to stdout, exited
non-zero, and the pipeline hashed what it got. Measured forms: `$c:lib` →
`headib`; `${c}:lib` and `"$c":lib` → `HEAD:lib`; `/bin/sh -c` → `HEAD:lib`.
The numbers were discarded, not adjusted (§1: a number produced with tooling
later found defective is contaminated), and re-measured under `/bin/sh`: the
program key is ONE value across the last four commits, because none of them
touched `bin`, `lib` or `drivers`.
Nothing in the harness is exposed: `command_key` in `fingerprint.py` checks the
command's exit status and refuses a non-zero one, the identity command lives in
a TOML string that `subprocess` runs through `/bin/sh`, and every gate is
`#!/bin/sh`. The exposure is the contributor's own hand at the terminal, which
is where G9's ugrep lives too. Learning (R27): the interactive shell is not an
instrument — a number for a document is measured through `/bin/sh -c` or a
file, never through a zsh one-liner — and git's own `fatal:` on stderr was the
detector, so a loop whose stderr is discarded or whose `|| true` swallows the
status can print a full column of plausible garbage (BBX-16's shape: reading in
the wrong view yields plausible garbage, not an error). A hazard line in
`HANDOFF.md`. Rules re-anchored in fact: §1 (contamination, discard and
re-measure), BBX-16 (plausible garbage), BBX-12 (parse by name, not position —
the pipeline read "the first 40-hex thing" instead of the three named trees).

## G34 — BBX-9 is met in ONE direction: a registered-but-absent gate FAILS the run, while a gate on disk in no registry is merely NAMED and the battery still reads GREEN — and the runner cannot be fixed without breaking the fidelity obligation (paid: 4 measurements and one probe planted in `gates/` and removed, ~5 min; 2026-09-11)
Found while designing the `selfgates` fixture, whose 8th stub file is on disk
in no registry "for the anti-orphan check" — the question was what that file
makes OBSERVABLE, and the answer is nothing.
Measured, in four steps. `bbx tier <config> --unregistered` exits **0** in all
three states: a complete registry ("ok: every instrument-free gate is
registered"), a registry with three orphans (it names them), and a registry
with a dead row (it names the rest). An orphan planted in BBX's OWN `gates/`
was NAMED by the tool and `gates/tier.sh` PASSed with it present; the probe was
removed and `git status` came back clean. A dead row, by contrast, becomes a
`MISSING` row and `rc=1` (measured on a throwaway consumer: `PASS 3 SKIP 1
FAIL 1 MISSING 1`, exit 1). Read in `bin/bbx-run-static`: `rc` is computed from
`n_fail`, `n_miss`, `--strict`'s `n_skip` and the controls block, and the
orphan list is PRINTED and never read; the only other reader in the tree is
`gates/tier.sh`, which asserts the naming on a SYNTHETIC tree under `TMPDIR`,
never on BBX's own gates directory.
Nothing is broken today: BBX's registry is complete, measured above. What is
missing is the ability to fail — "a check that cannot fail where it should is
not evidence" (§1), and BBX-9 says an unregistered item and a dead row BOTH
fail.
The interesting part is why it cannot simply be fixed. The runner's text and
its verdict are bbh's, and F13's fidelity pairs run bbh's runner and BBX's
runner over a synthetic repo that CONTAINS an orphan and diff what they print.
Making BBX's runner fail on an orphan would change that text, that exit, or
both, and the fidelity obligation (CLAUDE.md §2, §7.2) outranks the
convenience of fixing it there. So the verdict has to live in a gate of BBX's
own, over BBX's own config, leaving the lineage's runner untouched — raised as
R45 with that recommendation, because adding a gate changes what the battery
asserts and that is the maintainer's to rule (§3.1).
Learning (R27): a rule can be half-implemented by a tool that reports both
directions and enforces one, and the report reads like enforcement on a screen
— `== registry coverage (the anti-orphan check) ==` is a heading that promises
a check. When a rule's two directions live in one printed block, measure the
EXIT of each direction separately; a shared heading is not a shared verdict.
Rules re-anchored in fact: BBX-9 (complete both ways — the orphan direction is
unenforced), §1 (a check that cannot fail is not evidence), BBX-6 (the silent
failure mode is a control that no longer fires — here, one that never could).

## G35 — Extracting a shared helper renamed the SUBJECT in three of its messages: one was frozen by a gate and caught in the shadow, the other two were invisible to every gate and were found by reading the diff (paid: 2 gate runs and one diff read, ~4 min; 2026-09-11)
Step 5's whole point was that three drivers share one core, so `run()`'s
sandbox, environment, recording, timeout and decode became
`prepare_sandbox` + `exec_in_sandbox`. The helper had to name the thing it was
running, and it said "the subject". Three messages moved with it: the timeout
(`timeout: the tool ran longer than 1 s`), the exec failure (`the tool <path>
could not be run`) and the non-UTF-8 output (`the tool's output is not UTF-8`).
`gates/cli_driver.sh` freezes the FIRST of those and caught it in the shadow on
the first run — `CONTROL DEAD: timeout — exits 1/0: cli.py: timeout: the SUBJECT
ran longer…`. Nothing in the tree covers the other two: the exec-failure path
needs an unrunnable file and the UTF-8 path a binary output, and both are
declared consumers' questions (S4 plan §9). The fix was not to update the gate:
the helper now takes the caller's own noun and name (`what`, `subject`), so the
command-line driver's text is byte-identical and each adapter says "the
framework" or "the runner" — BBX-25's rule that a component serves a second
consumer without either bending. The second defect was subtler and no gate could
have seen it: the extracted version printed `argv[0]`, which for a `.py` tool is
the INTERPRETER, where the original printed the tool's own path. It was found by
reading the staged diff line by line, as G31 was.
A third instance, same sitting, same shape: the adapters raised `cli.Refused`,
whose text was hard-coded `REFUSED: drivers/cli.sh cannot honour …`, so the
gates adapter's own refusals sent the reader to the wrong contract. Found by a
control's first run, before the gate existed; fixed by a module-level `DRIVER`
that each driver sets once.
Learning (R27): when a component gains a second consumer, its frozen text is
only as safe as the paths a gate exercises — and the paths a plan has already
declared "a consumer's question" are exactly the ones no gate exercises, so a
refactor's messages there are asserted by nobody. Read the diff for every string
the helper moved, and give the helper the caller's noun rather than inventing a
neutral one. Mechanism candidate for S6, beside G19/G24/G27/G29/G31: a check
that every message a shared module emits names its caller's contract, which is
the same "generated and printed text" rot gate those four already ask for. Rules
re-anchored in fact: BBX-25 (a second consumer is the detector), §3.3 (the two
command-line gates passing proves currency for the paths they run, not
correctness for the ones they do not), §1 (measure the negative: the timeout
control existed, which is why one of the three was caught at all).

## G36 — `bbx controls report` read a MISSING log as zero firings and printed `declared=6 fired=0 dead=6 verdict=RED`, which is indistinguishable from a gate whose every control died (paid: 1 confused reading, ~2 min; 2026-09-11)
The new gate's controls were being checked by hand: `bbx controls report gates
<dir> adapters` after copying the gate's output to `<dir>/adapters.log`. The
report came back `declared=6 fired=0 dead=6 undeclared=0 verdict=RED` — the
exact shape of six dead controls, on a gate whose output held six `CONTROL
FIRED` lines. The cause was a filename: the reader opens `<logs_dir>/<name>.out`
and the copy was `<name>.log` (the runner's own kept-run convention is `.log`,
its work directory's is `.out`). `fired()` catches `OSError` and returns empty
lists, so a log nobody could open is reported as a log with nothing in it.
Nothing is broken in the battery: the runner writes the file it later reads, so
the two names never disagree there. The defect is in the tool's answer to a
question it was not asked — "there is no such file" arriving as "no control
fired". That is BBX-16's shape (reading in the wrong view yields plausible
garbage, not an error) with a verdict word attached, and it is the failure mode
BBX-6 names from the other side: a report that cannot tell a dead control from
an absent measurement.
Learning (R27): a reader that swallows `OSError` must say so in its answer. The
one-line fix is a `missing=1` field, or a refusal, so the verdict never reads
RED for a file that was never there; it belongs with R29's executable controls
in S6, because that is where the controls reader is next opened. A hazard line
in `HANDOFF.md` in the meantime. Rules re-anchored in fact: BBX-16 (the wrong
view reads as plausible garbage), BBX-6 (a dead control is the only silent
failure mode — and a report that invents one is the mirror image), BBX-12 (parse
by name: the two conventions `.log` and `.out` are a positional convention in
disguise).

## G37 — Four watcher loops were still sleeping after the close, waiting for a condition that could never become false: `until ! pgrep -f 'bbx-run-static --config'` matched the watcher's OWN command line (paid: 4 stray processes killed by PID after the close, and one memory entry corrected that had just recommended the pattern; 2026-09-12)
The battery grew past the ten-minute foreground cap at this sitting (G30's
sibling in cost, not in kind), so each run went to the background with a watcher
loop beside it: `until ! pgrep -f 'bbx-run-static --config'; do sleep 15; done`.
The maintainer asked, after the close was pushed, what was still running — and
four of those loops were, each sleeping in fifteen and twenty second cycles, hours
after the last battery had finished.
The mechanism, measured rather than guessed: `pgrep -f` matches against the full
command line of every process, and a watcher's own command line CONTAINS the
pattern it is searching for. `pgrep -f 'bbx-run-static --config'` returned the
four watchers' own PIDs and nothing else; `pgrep -f '[b]bx-run-static --config'`
returned the same four, because by then they were the only processes whose text
held the string at all. The loop's exit condition was therefore false for as long
as the loop existed: a wait that cannot end, which on a screen is
indistinguishable from a wait that is simply patient.
Nothing was harmed — the batteries had completed and their verdicts were read off
the kept runs, the close commit is what it says it is, and four sleeping shells
cost nothing but their existence. What is instructive is the SHAPE: this is the
third instance this sitting of a check that cannot reach its own failing state.
G34's registry report cannot go red on an orphan; the plan's clock-printing stub
control could not have fired at all (X32); and this loop could not exit. In all
three the reading was "fine" and the truth was "nothing was being decided".
Learning (R27): a condition that mentions a process must be written so it cannot
match the observer — the bracket form `'[b]bx-…'`, an exact-name `pgrep -x`, or
better, watch the ARTIFACT (the run's output file, the kept directory) rather
than the process, because the artifact is what the next step reads anyway. Before
arming a wait, ask the negative question §1 asks of every control: what would make
this loop exit, and has that ever been seen to happen? A hazard line in
`HANDOFF.md`, and the project memory that had just recommended the defective loop
was corrected in the same pass. Mechanism candidate for S6, with R29's executable
controls: the runner already drives a gate's declared controls and demands the
gate's own FAIL — the same demand made of a WAIT would have caught this in one
run. Rules re-anchored in fact: §1 (a check that cannot fail where it should is
not evidence — here a check that cannot succeed), BBX-6 (the silent failure mode
is the control that no longer fires; a watcher that never fires is its twin), and
BBX-16 (the wrong view — the process table read with a pattern that includes the
reader — yields plausible quiet, not an error).

## G38 — The census's shadow is an INSTRUMENTED harness, so the self subject's identity legitimately moves inside it and `gates/adapters.sh` failed there; the contamination guard then correctly discarded the whole run (paid: 2 probe runs, 41 s and 140 s; 2026-09-12)
The file-census instrument builds a shadow of HEAD and puts one trace line into
every `bin/*`, `drivers/*.sh` and `lib/sh/*.sh`. Those are three of the four trees
R38 hashes into the self subject's identity, so the shadow's harness is, by
construction, a DIFFERENT harness from the one whose registry row is frozen.
Measured on the first probe (`--only adapters`): `mkselfgates.py --check` printed
"THE HARNESS HAS MOVED since this identity was frozen", the row said
`0ce60b8cdaeb…` and the shadow computed `e82db89ffe98…`, the suite read
`UNREGISTERED build`, and the gate FAILed in 41 s. The instrument then refused the
run as a contaminated trace — which was the right verdict on the evidence it had,
and the wrong conclusion about the tree.
What makes this subtle is that NOTHING was broken. The tree's registry row was
correct, the gate was correct, the identity mechanism was correct, and the
refusal was correct. The defect was in the census's own contract: it had no way to
say "this subject's expectations are derived from its content, and I have just
changed its content on purpose".
Fix, measured both ways: `--shadow-refreeze "<command>"` runs one command inside
the throwaway shadow after the first shadow commit — after, because R38's key is
of the COMMIT. BBX passes `python3 fixture/selfgates/mkselfgates.py`, the
generator that is also the detector. The four identity trees are untouched by that
regeneration, so the key is stable across the shadow's second commit, and
`adapters` then PASSed there in 140 s against 97 s in the tree (the difference is
the instrumentation). What this does NOT assert is now a line on the gate: the
TREE's registry row is `gates/adapters.sh`'s to hold, never the census's.
Learning (R27): a subject whose expectations are keyed by its own content cannot
be perturbed by an instrument without a declared way to re-derive them, and the
re-derivation must happen in the throwaway copy and nowhere else (§3.4 forbids the
runner writing its own expectation; a SHADOW is not the tree). Rules re-anchored
in fact: §1 (the refusal discarded rather than adjusted), §3.4 (the regeneration
is the generator's, inside a copy), BBX-6 (a control that fires for the wrong
reason is as bad as one that does not fire).

## G39 — The document-set seed fired on a COMMAND-LINE gate, because two shared comparators IMPORT the document-set module and the trace records what was loaded, not what ran — and only the third kind could reveal it (paid: 1 probe run re-analysed; 2026-09-12)
With `adapters` passing in the shadow, the census filed it as kind `DC`: a
command-line gate counted under the document set. Its trace holds
`lib/py/bbx/docset.py`, which is one of the document-set kind's two derived seeds.
Cause, measured: `lib/py/bbx/compare_exact.py` imports `docset` inside its
detail path and `lib/py/bbx/compare_set.py` imports it at module level, and the
python half of the trace is a `sitecustomize` that records every `bbx` module in
`sys.modules` at interpreter exit — what was LOADED, never what was executed. Any
gate that runs the exact family therefore drags the document-set seed in behind
it.
The instructive part is WHY this was invisible at bbx-11, when the same instrument
and the same sitecustomize produced the first census: with two kinds, every gate
that ran the exact family WAS a document-set gate, so the wrong attribution and
the right answer were the same string. The third kind is the detector — which is
BBX-25's own argument ("a generic thing needs two instances") applied to the tool
whose job is to measure genericity. The census was measuring its own blind spot
and reading it as a number.
Fix: the explainer rule. A seed hit counts only when nothing else in the same
trace imports that seed, the importers computed transitively from the modules' own
`from . import` lines. Measured on the kept trace: `adapters` reads `C`. The
import graph is derived from the tree every run, so a new import moves the rule
rather than rotting it.
Learning (R27): an instrument that attributes by IMPORT cannot distinguish a
caller from a dependency, and the fix is not a better trace but an explicit
account of what else in the evidence explains the observation. Stated as a
NOT-ASSERTED line on both gates: the trace records what a process loaded or
executed, never why. Rules re-anchored in fact: BBX-25 (the second and third
instances are the detectors, here of the measuring tool itself), BBX-16 (reading
in the wrong view — imports read as executions — yields plausible garbage, not an
error), §1 (the bbx-11 number was a measurement, and it was still a measurement of
the wrong thing).

## G40 — `git commit` with nothing to commit exits 1, and under `set -e` that killed a gate four controls early with an exit the classifier correctly read as FAIL (paid: 1 gate run; 2026-09-12)
`gates/file_census_tool.sh` perturbs its synthetic subject tree, runs the
instrument, then restores the perturbation — and commits after each step, because
the instrument reads the subject through `git archive HEAD`. A restore that puts
the tree back exactly leaves NOTHING to commit, `git commit` exits 1, and the
gate's `set -e` ended the script immediately after section 4. The output looked
orderly: four sections of `ok` lines, two controls fired, and then nothing. The
classifier read FAIL on the exit, which is right, but the log gives a reader no
reason at all — the failing command printed nothing, because the commit's output
was redirected.
Learning (R27): a housekeeping command whose failure is not a finding must say so
in its own line (`|| true`), and a gate whose output simply STOPS is a crash until
proven otherwise ([BBH-20]'s rule read backwards — a PASS row with no verdict line
is a crash; so is a log with no verdict line and a non-zero exit). The cheap
standing check is the one [BBH-11] implies: a gate's last line is its own verdict,
so a log whose last line is a section header never completed. Rules re-anchored in
fact: BBX-1 (exit status decides, and this exit was honest), [BBH-20].

## G41 — A retraction pattern that spanned two lines could never have matched anything, because the sweep reads per line: a dead entry in the register that watches for dead claims (paid: caught in the same commit, 0 sessions; 2026-09-12)
X38's first draft quoted two lines of the plan text it retracts, joined by a
literal `\n` in the pattern field. `lib/py/bbx/close_sweeps.py:111` iterates
`text.split("\n")` and searches each line, so a pattern containing a newline
cannot match any line, ever. The register would have carried a row that looked
like a watch and was a no-op, and `retraction_hits=0` would have kept reading as
the good news it usually is.
Caught by asking the negative question of the matcher instead of trusting the
zero: the corrected single-line pattern was planted into a scratch copy of the
tree and REQUIRED to fire (`errors=1`, "still stated in planted.md:1"), then
proven absent from the real tree (142 files, `retraction_hits=0`, `errors=0`).
Learning (R27): every new retraction row is proven on a planted copy before the
sweep's zero is believed — the same demand BBX-5 makes of any instrument, applied
to one row of a register. This is the fourth instance in two sittings of a check
that cannot reach its own failing state (G34's orphan verdict, X32's clock stub,
G37's watcher loop, and now this), which is why R45 and R29 both matter more than
their size suggests. Mechanism candidate for S6: `close_sweeps` could refuse a
retraction pattern that contains a newline, and could report any row that has
never been seen to match as unproven. Rules re-anchored in fact: BBX-6 (the only
silent failure mode is the control that does not fire), BBX-22 (the sweep must
show an empty result that MEANS something), §1.

## G42 — Keying a generated in-tree document by HEAD makes its own check fail for ever: the commit that writes the document moves the key (paid: caught on the gate's first run, 0 sessions; 2026-09-12)
The census document records the state it was measured at. The first draft recorded
`HEAD`, and `gates/file_census_tool.sh` went red on its own output: the gate
regenerated the document, committed it, re-ran `--check`, and the rendered
preamble disagreed with the file by exactly one field — the commit hash, which the
commit had just moved. A census that lives in the tree it describes can never be
keyed by that tree's commit.
Fix, reusing a mechanism this project had already ruled for a different reason:
R38's whole-set identity, the tree hash of `bin`, `lib`, `drivers` and `gates`
hashed into one. A docs-only commit leaves it unchanged, and a commit that touches
the harness moves it — which is precisely when the census IS stale. Both
directions are now controls in the portable gate: a docs-only commit leaves
`--check` clean, and adding one gate turns it red.
Learning (R27): the key of a generated artifact must be the identity of what it
DESCRIBES, never the identity of the tree that stores it, and the two differ
exactly when the artifact is stored beside its subject. One writer would be better
than two: `fixture/selfgates/idkey.sh` and `bbx.file_census.identity` both compute
this key, and the portable gate proves they agree rather than the tree having one
reader ([BBH-60]'s preference, met by a cross-check instead of a merge — a
candidate for S6). Rules re-anchored in fact: BBX-29 (results are keyed by case
and SUBJECT VERSION, never by the moment or the container), BBX-16, D62.

## G43 — The census read 30 of 44 harness files as "executed by NO gate": a gate handed a working directory reports its PHYSICAL path, so modules imported under `/private/var` while the trace recorded `/var` (paid: 1 heavy gate run, ~20 min, plus 2 regenerations; 2026-09-12)
`gates/file_census.sh` went RED on its first real run with a census that looked
like a finding: 30 of 44 files reached by no gate, every kind-set shrunk, five
gates demoted to kernel. Not one of those statements was true.
The instrument runs each gate with `subprocess`, handing the shadow to the child
as its working directory. A gate derives its own home with
`cd "$(dirname "$0")/.." && pwd`, and what `pwd` reports depends on how the
process was started — measured side by side from a probe gate that printed both:
a cwd handed to the process gives `/private/var/folders/.../shadow`, while a
shell that `cd`-ed there gives `/var/folders/.../shadow`. The gates therefore set
their module path to the physical form and imported `/private/var/...`, while the
instrument had written its root as the logical form, so `f.startswith(_ROOT)` was
False for EVERY module and the python half of the trace was silently empty. The
SHELL half kept working, which is exactly why the result read as a census number
rather than as a broken instrument: three kinds were still placed, by the drivers.
The committed census was nevertheless correct, and that is the uncomfortable
part: its generating run wrote under `build/`, where no symlink lies in the path,
so physical and logical agreed. It was right by luck of the output location.
Fix: `os.path.realpath` on BOTH sides, never the path as written. Measured from
one shadow afterwards, the instrument's own argv-plus-cwd form and a shell-string
form trace the identical three modules for `gates/config.sh` where before they
read 0 and 3.
The instrument's OWN GROUND TRUTH could not have caught it. The portable gate's
synthetic stub inherited its module path from the instrument instead of deriving
it the way every real gate does, so the single idiom that triggers the bug was
absent from the only gate whose job is to hold the instrument. The stub now sets
`BBX_HOME` with `cd ... && pwd` and its module path from that, under `mktemp`
where the symlink exists, and the fix is proven both ways: the gate PASSes with
it, and on a copy of HEAD with ONLY the realpath comparison reverted the gate
FAILs at `g1 traced: bin/synthbin` with both modules gone.
Learning (R27): a fixture that stands in for a subject must imitate the subject's
IDIOMS, not merely its shape — a synthetic gate that does not derive its own paths
the way real gates do is not a stand-in for a real gate. And never compare two
paths that crossed a process boundary without canonicalising both: one side's
notion of where it is depends on who started it. Rules re-anchored in fact:
BBX-16 (reading in the wrong view yields plausible garbage, not an error — 30 of
44 is a plausible number), BBX-5 (the instrument was not proven on a known
positive that exercised the real idiom), §1 (the generating run was a measurement
and it was correct for a reason nobody had measured).
## G44 — A second battery was launched while the first was still running, because a WAIT LOOP's completion was read as the BATTERY's completion (paid: one partial run discarded, one battery's last gate timed under load; 2026-09-12)
The close needs two batteries at one HEAD, each run alone. The first was
backgrounded and a separate wait loop was started beside it to poll for the
`VERDICT:` line. The loop hit its own iteration cap and exited, the harness
reported THAT command as completed, and the report was read as "the battery has
finished" — so the second battery was launched while the first was still inside
`gates/suite.sh`. Measured immediately after: `pgrep -f '[b]bx-run-static'`
returned three processes, and the first battery's log showed `fidelity_bbh_s2`
just done with `suite` still to come.
No verdict is affected and none was salvaged by judgement: the two runs wrote to
different `--log` directories, every gate builds its own `mktemp` scratch, and
neither run writes a tracked file, so the first battery's VERDICTS stand. What
the overlap did touch is runtimes — for about thirty seconds, and only
`gates/suite.sh`'s, which is why that number is reported and not gated. The
second battery was killed, its partial kept run REMOVED rather than kept and
explained, and it was re-run alone afterwards.
The trap is not the loop; it is the two different things a completion
notification can be about. A backgrounded MEASUREMENT and a backgrounded WATCHER
of that measurement both report completion, in the same shape, and only one of
them means the measurement is done. G37 was the mirror image of this — a watcher
that could never finish — and the two together say the watcher is the wrong
instrument: watch the ARTIFACT the next step reads, which here is the `VERDICT:`
line in the kept run, and test for it rather than for the absence of a process.
Learning (R27): before starting anything that must run alone, assert that nothing
it must run alone against is running — the positive check `pgrep` gives, read
BEFORE the launch and not after. A launch that has a precondition is a gate
without a control until that precondition is tested. Rules re-anchored in fact:
§1 (the precondition was assumed from a notification, never measured), BBX-14
(the two runs the close compares must each be a clean measurement), BBX-29
(results are keyed by the version that started them, and a run whose conditions
changed mid-flight is not that run — which is why the partial was deleted).

## G45 — Step 6's tier pattern made the sweep row a legitimate registration and silently removed the only orphan report that class of gate had (paid: caught while scoping R45, 1 copy-of-HEAD measurement, 0 sittings; 2026-09-12)
Before S4 step 6, `bbx.toml` carried `[tier].patterns = []`, so every BBX gate
classified as PLAIN and an unregistered one was at least NAMED by
`bbx tier --unregistered`. Step 6 added BBX's first pattern, deliberately and
with its reason recorded (X36): `gates/file_census.sh` lives in
`gates/sweep.tsv`, and `lib/py/bbx/tier.py` reads `known = portable | static`,
so without the pattern the gate would have been reported as an orphan for ever.
The pattern fixed that, and in doing so it exempted an entire class from the
report. Measured on a copy of HEAD: a gate whose code matches the pattern and
which is in NO registry at all is not named — the report prints `ok: every
instrument-free gate is registered` while the orphan sits in `gates/`. The
instrument-FREE orphan is still named, so G34's case did not get worse; what
appeared is a second, quieter case that did not exist before this step.
The exemption is correct in itself. `--unregistered` asks one question — is
every instrument-free gate in a plain registry — and an instrument gate is not
its business. The defect is that nothing then asks the matching question at the
same cadence. The sweep runner DOES ask it, properly and both ways
(`UNREGISTERED` and `DEAD ROW(S)`, re-derived every run), but only at the
release scope, only fatally under `--strict`, and `--list` exits before that
section entirely: a dead row planted in `gates/sweep.tsv` passed a `--list`
silently.
One fix is NOT available, and that was measured rather than assumed. The
listing's registry column shows `-` for a sweep-registered gate, which reads as
"no registry" and is misleading; it cannot be changed, because fidelity pair
F13e diffs `bbh.tier --list` against `bbx.tier --list` over bbh's example, bbh's
own column has the same three values, and all five INSTRUMENT gates in that
example are in its sweep registry and print `-`. Changing BBX's column would
make five lines differ. So the column stays the lineage's and the new gate
reports the registry instead.
Learning (R27): **a classifier exemption is a hole unless the registry it
exempts INTO is checked at the same cadence.** Adding a pattern to make one
registration legitimate is the same edit as removing a report, and only the
second half is invisible. Before narrowing any completeness check, plant the
case the narrowing newly permits and require the check to still speak. This is
the sixth instance of one shape in two sittings — a check that cannot reach its
own failing state, after G34's registry report, X32's clock stub, G37's watcher
loop, G41's two-line pattern and G43's ground-truth gap — and it is the first
where the narrowing was introduced on purpose, for a good reason, by the same
step that needed it. R45's scope grew from one direction to three because of it.
Rules re-anchored in fact: BBX-9 (every registry complete BOTH ways, and there
are three registries here, not two), BBX-6 (the only silent failure mode is the
control that no longer fires — here one that stopped being asked), BBX-10 (rot
class 1, the orphan), §1.

## G46 — R47's new gate DEADLOCKED the census: the register could only be completed by a run that refused to complete while the register was incomplete (paid: 1 census run discarded, ~20 min; 2026-09-12)
R47's gate asserts that every tracked harness file has a frozen census row. R43,
in the same sitting, added `lib/sh/baseline.sh`. The register's rows carry KINDS,
which only a traced run can measure, so completing the register needs a census
run — and the census builds a shadow from HEAD and REFUSES its own run if any
gate is not PASS inside it (§1: a gate that failed executed less than it executes
in the tree, so its trace is contaminated). The new gate failed in the shadow for
the same true reason it failed in the tree. The run was discarded after twenty
minutes, and the only thing that could fix the register was the thing the
register was blocking.
Reading the shadow's own log made the diagnosis stronger than "stale". The gate
named TWO files with no row, and the second was `lib/py/sitecustomize.py` — which
the instrument WRITES into the shadow and `git add -A` then commits. So the
shadow's universe permanently holds a harness file the tree's register can never
contain, and the gate's question is not merely out of date inside a shadow, it is
**unanswerable there by construction**.
Fix, in three parts. The instrument now exports `BBX_FILE_CENSUS_SHADOW=1` to
every gate it runs, so a gate whose question cannot be answered in an
instrumented copy can SKIP and say why — the `# SKIP:` convention the contract
already has, where a skip asserts nothing and is reported ([BBH-6], [BBH-15]).
`gates/census_register.sh` skips on it, naming the sitecustomize reason. And the
contamination rule is split: a FAIL still discards the run, a SKIP does not,
because a gate that asserted nothing misled nobody — but a skip DOES under-report
what that gate reaches, so the run prints `NOTE: census-skipped <gate>` and the
generated block NAMES every skipped gate, which puts the limit inside the checked
text where it cannot quietly change (BBX-30).
Learning (R27): **a gate that asserts something about a generated artifact must
be asked whether its question still means anything inside the generator's own
copy of the tree.** The census is the only subject here that runs the whole
battery against a perturbed version of itself, so it is the only place this can
bite — and it will bite again for any future gate that reads a file the census
produces. The shape is G38's, one layer out: G38 was an expectation keyed by
content that instrumentation moved, and this is an assertion whose INPUT the
instrument rewrites. Both were fixed by letting the subject declare what the copy
cannot answer, rather than by weakening the rule. A third instance should become a
contract line in `docs/controls.md`, not a third ad-hoc fix.
Rules re-anchored in fact: §1 (the run was discarded, never adjusted, and the
discard is what exposed the deadlock), BBX-30 (the skip is stated in the checked
text, not absorbed), [BBH-6] (SKIP is not PASS and asserts nothing), BBX-9 (the
completeness question is right; only its venue was wrong).

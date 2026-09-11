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

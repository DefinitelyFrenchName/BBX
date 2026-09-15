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

## G47 — A gate that SKIPS cannot fire its controls, and the controls contract counts a control that did not fire as DEAD: the first platform run went NOT GREEN on a skip that was correct (paid: found by R21's WSL run, reproduced on macOS the same day; 2026-09-13)
The first Linux/WSL run of the battery (`docs/platforms/wsl/`) read
`PASS 30  SKIP 1  FAIL 0  MISSING 0` and then `NOT GREEN`. The one skip was
`gates/census_recount.sh`, skipping for the reason the procedure had predicted: the
three lineage census files record absolute paths from the macOS host, and a census
naming an absent directory is skipped, asserting nothing. But a gate that skips runs
none of its checks, so none of its FOUR declared must-fire controls could fire, and
`docs/controls.md` says "Declared and not fired is red" — so the reader printed
`declared=4 fired=0 dead=4 verdict=RED` and the runner made the whole battery NOT
GREEN.
Converted from a witness into an instrument the same day (BBX-28): pointing
`BBX_CENSUS_DIR` at a census naming an absent tree reproduces it on macOS exactly —
`controls=census_recount declared=4 fired=0 dead=4 verdict=RED`. So this is a defect
in BBX's own contract, not a property of WSL and not a defect of any gate.
**Why macOS could never have shown it.** No gate skips here, because the three
lineage trees exist at the paths the censuses record, so every declared control
always fires. The second PLATFORM is the detector — BBX-25's argument about needing
two consumers, applied to hosts instead of to code. Every other number the WSL run
produced is identical to this host's: 31 gates, 119 declared controls, and every
NOTE-class value the same, which is the strong half of the result.
The contract's own text already contains the principle it is missing. [BBH-6] and
`docs/controls.md` both say a skipped gate ASSERTS NOTHING, and the same page
already treats bbh's undeclared selftests as "reported as undeclared, never as
asserting". Demanding that a gate which ran nothing nevertheless prove its controls
fired asks for evidence from a measurement that did not happen.
It is NOT fixed here, because the fix amends a ruled contract (R10): raised as
**R48** with the recommendation that a SKIPPED gate's declarations are reported as
not-asserting rather than dead, paired with the skip staying counted and named on
the screen and `--strict` still making a skip fatal — otherwise the exemption
becomes a new way to hide a dead control behind a convenient skip.
Learning (R27): this is the mirror of the shape that has dominated the last three
sittings. Five times a check could not reach its own failing state; here a check
reaches a failing state it should not — and both come from a verdict rule that does
not distinguish "the thing I watch is broken" from "the thing I watch did not run".
BBX-26 now applies to the next sitting: the suite diverges on one platform until
R48 is ruled. Rules re-anchored in fact: [BBH-6] (SKIP is not PASS and asserts
nothing — the reader honours the first half and not the second), BBX-6 (a dead
control refuses a verdict, which is right, and a control that never ran is not
dead), BBX-25 (the second instance is the detector; here a second HOST), §1 (the
green on this host was a measurement of a host where nothing skips).

## G48 — A controls reader that CRASHED was read as "red: 0" and the battery GREEN: the verdict rested on counting RED lines in a report that was never written (paid: 0 sittings — found while building R48's fix, by a crash planted in a scratch clone before the claim was written; 2026-09-13)
While changing the controls block for R48, one line of `bin/bbx-run-static` read
wrong: `python3 -m bbx.controls report … > controls.txt && _cst=0 || _cst=$?`
captured the reader's exit and never used it, and every count after it was a
`grep -c` over the file. Measured before it was said (§1), in a clone of `fd63797`
with one `raise` planted at the top of `report_one`, over a synthetic consumer whose
one gate declares a control and never fires it: the tree's reader printed
`verdict=RED`, NOT GREEN, exit 1; the planted reader printed a Traceback,
`controls fired 0 / declared 0; gates with no declaration: 0; red: 0` and **GREEN,
exit 0**. A broken reader silenced every dead control in the battery. The readout
lied about it too, measured on a copy of the bbx-22 opening run with `controls.txt`
emptied as a crashed reader leaves it: `each can fail: 31 of 31 gates proved a control
fires on purpose`, because it counted every gate without a `declared=0` line as proved.
The exit could not be the fix: the reader exits 1 for RED and 1 for an uncaught
exception — the two-causes shape named at bbx-20. The fix reads the OUTPUT: one
`controls=` line per gate that ran, or the run is NOT GREEN with `controls: the reader
reported <n> of <m> gate(s) that ran`; the readout names a gate that ran with no
controls line (`NOT REPORTED`) and counts proved gates from the lines it has (the same
emptied copy now reads `NOT REPORTED for 31 gate(s)` and `0 of 31`). Ground truth:
`gates/controls.sh` control `reader-crash-is-red`, a shadow harness whose reader is a
copy with one line stripped — measured DEAD on the unfixed runner (NameError, GREEN,
exit 0) and FIRED on the fixed one — and `gates/readout.sh`'s unreported-gate check.
Learning (R27): the instrument that watches the controls had no control of its own —
BBX-6's only silent failure mode, one level up. Any tool whose output is COUNTED
rather than required to be present has this shape: the absence of a line is not a
zero. Worth a sweep of the other `grep -c` counts over a tool's output in `bin/`,
measured before anything is claimed about them. Rules re-anchored in fact: BBX-6,
BBX-7 (a claim measured by absence needs a positive control), BBX-12 (the sums now
read each line's first field of a name, never every field that starts with it), §1.

## G49 — The maintainer re-ran the WSL battery on the PRE-fix tree, because the fix had not been pushed when they were asked to run it (paid: one WSL battery run on the maintainer's host; 2026-09-13)
The sitting's message asked for a WSL re-run "at the close commit I'm about to push or
later" while the five bbx-22 commits were still local and the close pair was running. The
maintainer pulled, got `fd63797` — the remote's head, measured afterwards with `git ls-remote
origin refs/heads/main` — and ran the battery: `PASS 30  SKIP 1`, `controls fired 115 /
declared 119; red: 1`, NOT GREEN, the first WSL run's result exactly. Three lines of their own
output identified the tree without asking: `controls=controls declared=2` (the fixed gate
declares 6), `census-drift … tree=1e40798f4530` (the pre-fix identity; the fixed tree is
`bc18c672fdb9`), and a controls sum with no `skipped:`. `429d3f8` was pushed as soon as the close
pair's first battery read GREEN, and the run is recorded as a second witness of the pre-fix
behaviour, never as evidence about R48.
Learning (R27): a request to run on another host is a claim about the REMOTE, and it was not
checked against the remote. The fix is procedural and is now written where the next run meets
it: `docs/platforms/README.md` §1 names a tree check (`grep -c '^# MUST-FIRE' gates/controls.sh`
prints 6 since R48, 2 before), and HANDOFF carries the hazard — push first, confirm on the
remote, then ask, with one line that proves which tree the other host has. Rules re-anchored in
fact: §1 (the commit was named, not measured on the remote), BBX-29 (results keyed by subject
version — the version was in the output, which is how the run was classified correctly), BBX-28
(a witness, converted by reading its own lines).

## G50 — The readout of a kept run from ANOTHER host counts every gate whose header it cannot find as "declaring no blind spot": the WSL screen read 31 where the same commit's screen reads 0 (paid: 0 sittings — found reading the first kept platform pair before it was committed; 2026-09-13)
`bin/bbx readout` finds each gate's header — the `NOT-ASSERTED:` lines behind "what this green
does NOT assert" (RO2) — at the `root` and `gates_dir` the run recorded. The kept runs from the WSL
host record `root=/home/koneko/bbx/BBX`, which does not exist on this host, so every header read
came back empty and the screen for the WSL pair at `429d3f8` printed `gates declaring no blind
spot: 31 — classify, config, …`, where the macOS close pair at the same commit prints `0`. Measured
both ways: the same two kept runs, copied with only their `root=` rewritten to a clone of BBX at
`429d3f8`, print `gates declaring no blind spot: 0` and a blind-spot section identical to the macOS
close screen's apart from the one line naming the skip. Nothing else on the screen moved — the
verdict, the counts, the controls and BBX-14 all come from the kept files — but RO2 on an
off-host screen was plausible garbage (BBX-16), and R21's ruling names exactly that screen as the
platform's.
Not fixed in the commit that found it, which changes no harness file: the committed runs are
byte-identical to the archive, and the platform page quotes the screen generated with `root=`
pointed at the clone, and says so. The fix is the next sitting's first small one (R27): a header
the readout cannot read is NAMED ("header not found at <path>") and never counted as a gate that
declares nothing. Meanwhile `docs/platforms/README.md` §4 tells the other host to generate its
screen where it ran.
Learning (R27): G48's shape again, the same day, in a second place — an absence counted as a
value. G48 counted missing LINES as zero; this counted a missing FILE as silence. The sweep G48
named must cover the readout's readers, not only the runners in `bin/`. Rules re-anchored in fact:
BBX-16 (reading in the wrong view yields plausible garbage), BBX-7 (a claim measured by absence
needs a positive control), §3.2 and BBX-30 (the blind-spot section is the part of the screen that
must not lie).

## G51 — R44 was answered at bbx-20 and left under Open for two sittings: the queue and DECISIONS.md agreed with each other, and the only record of the answer was the history twin (paid: 0 runs — found when the maintainer asked to rule R44 and the queue was read against the history first; 2026-09-13)
At bbx-20 the maintainer agreed with R44's recommendation and deferred its build.
`DECISIONS_HISTORY.md` recorded "R44 (agreed, deferred by the maintainer's own instruction to after
this work)", and STATE at the bbx-22 open said "R44's BUILD (the ruling is answered…)". But
`docs/rulings.md` kept the entry under `## Open` with `- **Answer:** (open)`, and `DECISIONS.md`
listed R44 on its `Open rulings:` line with no row. `gates/rulings_shape.sh` passed at every close
in between — `open=3` at bbx-22's, R44 among them — because it checks that the queue and
`DECISIONS.md` agree, and they did, both wrong the same way. G14's dark pattern in its mirror form:
not an answer written under Open, but an answer written nowhere the gate reads.
Re-ruled the same hour on re-measured numbers; the answer line says it had been given before.
Learning (R27): "answered, build deferred" is two facts, and the close moved only the second. The
trap is filed in HANDOFF: when a ruling is answered, MOVE it and write its DECISIONS row in the same
edit, whatever happens to its build. A mechanism is possible and is not built here — the history
twin names rulings as "agreed" or "answered" in prose, and a check over that prose would be a
reader of free text, which this tree has avoided for good reason. Rules re-anchored in fact: BBX-20
(a living page states what is true; two did not), BBX-9 (a registry complete both ways — these two
files were complete with respect to each other and not to the ruling), §1.

## G52 — Two claims were made from the NAME of a thing instead of the code that defines it: R45's gate was said to force a census run because it "adds a harness FILE", and a probe was said to test an INSTRUMENT gate while its pattern sat in a comment (paid: one docs commit of corrections and retraction X43; no run wasted — both were caught by measuring before building; 2026-09-13)
While putting R45 to the maintainer, the contributor wrote — in the ruling's answer, the history,
STATE and HANDOFF, and to the maintainer directly — that R45's gate "adds a harness FILE, so its build
owes a census run (R47)". R47's register covers the census UNIVERSE, which `lib/py/bbx/file_census.py`
`universe()` defines as `git ls-files lib bin drivers`; a gate lives under `gates/`. Measured at the
bbx-23 open, on a clone of `898dbe6`: a new gate file left `--check-register` at exit 0, and a new
`lib/` file — the positive control — made it exit 1. Corrected in its own commit before the build
(`f72a2e1`), retraction X43. The same hour, a probe of R45's second gap put the instrument pattern in a
COMMENT; the tier classifier strips comments, read the probe PLAIN, and reported an ordinary orphan — a
result about the probe, not about the gap. It was redone with the pattern in code, next to the real
`file_census` gate classified INSTRUMENT, before the gap was called confirmed.
Learning (R27): "harness" names `bin`/`lib`/`drivers` in R47's universe and `bin`/`lib`/`drivers`/`gates`
in R38's whole-set key, and the claim followed the word. When a claim rests on what a registry or a
universe CONTAINS, read the function that builds it — one grep — before writing the claim anywhere. A
probe is an instrument: it is wrong until it has shown, on a known case beside it, the result it would
show (BBX-5). Rules re-anchored in fact: §1 (the claim was measured after it was written, not before),
BBX-16 (the wrong reading of "harness" yielded a plausible cost), BBX-5 (the probe had no positive
control of its own).

## G53 — Two blind spots were written over several header lines and the readout printed the first line of each as the whole: one reached seven committed screens cut mid-sentence, because nothing checked the one-line grammar (paid: 7 sittings of committed screens carrying a cut blind spot, bbx-17 to bbx-23; the fix one extra battery, one census regeneration and one refreeze; 2026-09-13)
At the bbx-17 close (`eb47db6`) two `NOT-ASSERTED:` entries were wrapped onto indented comment lines:
`gates/cli_suite.sh:26` over two and `drivers/cli.sh:43` over three. The grammar has been one line per
blind spot since bbx-2 (`docs/controls.md`) and every reader matches one line, but nothing checked the
grammar: the readout printed `…both counts trace to one `bands` list written once by` and dropped the
point of the sentence ("nothing here compares them for a driver that would write the log and the band
view apart"), and the driver's warning about host crash reports (G30) would have read `…(SIGABRT,
SIGSEGV,` on any suite screen. The cut line is on 7 committed screens in `docs/readout.md`. Found at the
bbx-24 open by reading the generated screen, not by a gate. Measured before any fix: 236 entries in 37
gate and driver headers; after an entry came another entry 198 times, a bare `#` 32, the end of the
block 4, a run-on line 2. Fixed under R49: the headers first, in their own commit (`398a64f`), then
`controls.continued_entries`, a fourth close sweep and `^ TRUNCATED` on the screen (`64dfd85`), with
three new controls that read DEAD on the old code in a scratch clone and FIRED on the new.
Two more instances of a reader or a check that stops short, the same sitting, both the contributor's
and both caught before use. (1) The new control `entry-continued` was first written to require
`continued=2` on a copy of the tree; a copy of a tree that already carries a run-on entry reads 4, so
the control would have read DEAD for a reason it did not plant (bbx-20's hazard: a check that can fail
two ways). It was rewritten to require a rise of exactly two from the real tree's count, and measured on
the unfixed tree: `continued rose 2 -> 4`, FIRED, while the real-tree check failed by name. (2) An
extraction of the rules each gotcha re-anchors, written for S4's slice readout, stopped at the first
period and turned `§3.3` into `§3.` in six entries — a shorter, plausible list; caught by checking one
entry against its raw line and the whole result against STATE's hand-written list (12 of 12).
Learning (R27): a shape ruled in prose and read by a pattern that matches one line is a lenient parser
([BBH-73]) — a malformed entry reads as a shorter valid one, never as an error. The check for a ruled
shape belongs beside its reader from the day the shape is ruled; the mechanism is built. Rules
re-anchored in fact: BBX-30 and §3.2 (a green whose blind spots were printed in part), BBX-16 (one line
of a multi-line entry is the wrong view, and it yields plausible text), BBX-5 (each new control proven
DEAD on the old code first), BBX-7 (the sweep must read entries above zero before its zero means
anything), §1.

## G54 — Three living-page sentences kept the gate count from before R45 added a gate, one of them on the page the maintainer follows on another host, and a gate header quoted a runtime six times too short (paid: 0 runs — the counts found reading HANDOFF and the platform README at the bbx-24 open, the runtime by the opening battery's own results; 2026-09-13)
R45 added `gates/registry_complete.sh` at bbx-23, so the battery registers 32 gates (`gates/portable.txt`
28 + `gates/static.txt` 4, measured at bbx-24). HANDOFF's "What is running" and its close step 1 still
said 31 registered gates, with bbx-22's 827 s, while its own routing table and orientation said 32; and
`docs/platforms/README.md`, the page followed on WSL, said "about fourteen minutes on the macOS host with
31 registered gates". That page's expected screen is dated (`429d3f8`) and was true of its commit; it is
replaced at the close with the close pair's lines, and its tree check gains a count this sitting's commit
moved. Separately, `gates/close_sweeps.sh` quoted "Portable, ~1 s": the bbx-24 opening battery measured
it at 6 s on the old gate, before the header sweep was added (8 s after it, in the build battery), so the
figure was stale before this sitting touched it. Corrected: HANDOFF and the README with the gate runtimes
of four kept 32-gate runs re-derived from their `results.tsv` (865, 841, 666 and 618 s), the header in
`64dfd85`; retraction X45.
Learning (R27): a count that a registry defines, repeated in prose, is a hand-kept copy of the registry
— BBX-9's smaller thing to forget — and a runtime in a header is a measurement with a date or it is a
guess. The platform README already gives the command that re-derives the total; a living page that
quotes a count should quote its command beside it. The mechanism that would catch this class is BBX's
own `docs/` checked as a document-set subject (BBX-18: quote the claim, derive it, compare), which the S3
and S4 plans left out (their §9); it is a candidate for a ruling, not built. Rules re-anchored in fact:
BBX-20 (a living page states what is true; three sentences did not), BBX-9, §1.

## G55 — "All 30 rules remain [inherited]" was carried in STATE and in S3's slice readout, and one of the 30 never was: BBX-30 is marked [this project] (paid: 0 gate runs and 1 planted-copy re-run — found at bbx-24 when S4's slice readout measured §7's fifth condition instead of copying S3's answer; 2026-09-13)
`CLAUDE.md` §4 has 30 rule lines (`- [BBX-n]`): 29 carry `[inherited …]`, and BBX-30 carries `[this
project]` — "This rule has no lineage citation because it is the reason this repository exists."
`STATE.md`'s Rules paragraph said "all 30 in CLAUDE.md §4 remain `[inherited]`", and S3's slice readout
wrote the same twice (its point 8 and row 5 of its §7 table), where the maintainer read it before ruling
S3 DONE. The claim never changed the condition it answered — no rule was promoted then, and none is now —
but it was a count copied, never taken. Corrected in STATE; the S3 readout stays as written, a ledger;
retraction X46, its pattern proven to match the three old wordings and to miss the corrected one before
it was written. That first version was still case-sensitive: the planted copy that must make a new row
fire carried the wording twice, once opening a sentence (`All 30 in CLAUDE.md …`), and only the lowercase
plant failed. The row was given `(?i)`, as X39–X44 carry, the generated readout block that already quoted
G55's old price was removed rather than hand-edited, and the planted copy was run again.
Learning (R27): §7's table is answered by measurement every slice, never by the previous slice's answer
— G54's trap, a count kept in prose, in the one place a DONE ruling reads. No mechanism beyond the
retraction row: the document-set candidate G54 names would hold this count as well. Rules re-anchored
in fact: §1 ("inherited numbers are re-derived, not carried forward"), BBX-20.

## G56 — Two of the contributor's own probes at the bbx-24 close reported nothing wrong while measuring nothing: a loop printed `exit=0` four times for calls that had failed — the exit of `tail`, G16 again — and a script that did not compile printed no lines at all (paid: 2 probe re-runs, about a minute; both caught before any number reached a document; 2026-09-13)
Checking the four fixture registers for S4's slice readout, a loop ran `python3 -m bbx.provenance check
<dir> 2>&1 | tail -2` and then echoed `$?`: every call had failed on a usage error (the tool takes
`--config`), and every line read `exit=0`, the pipe's. The same close, a script extracting each run's
controls stopped at compile time — this host's `python3` refuses a backslash inside an f-string
expression — so its summary lines were simply absent, and nothing on the screen said so. Both were
redone before anything quoted them: the registers with the gates' own invocation (`--config
fixture/<fx>/bbx.toml`, the exit captured as `> file 2>&1; e=$?`), all four exit 0 and complete both
ways; the script without the backslash, its sums equal to what the screen printed.
Learning (R27): G16's hazard is already in HANDOFF and still bit, in a one-off probe, because probes
are written faster than gates. Capture a measured exit as `cmd > file 2>&1; e=$?` before any pipe —
the form every gate uses — in a probe as well. And a probe that prints nothing has not reported zero:
count the lines it should have printed before reading its silence. Rules re-anchored in fact: BBX-1
(exit status decides, and the status read was the wrong process's), BBX-7 (an absence read as a
result), §1.

## G57 — The gate screen counts only the rows a run keeps, and a tier the runner does not run keeps none: the native Linux pair recorded skip=4 and its screen said SKIP 0 (paid: 0 battery runs — found after the bbx-24 close by reading the pair's run.txt against its screen, reproduced on a two-gate consumer in seconds; two scratch runs of the contributor's first took the wrong path; 2026-09-13)
The native Linux pair at `f6f136d`, made through claude.ai and archived by the maintainer, ran `bin/bbx
selftest` with `BBX_BBH_HOME` unset. `bin/bbx-run-static` then prints `NOT RUN: BBX_BBH_HOME is unset…` for
the static tier and adds its 4 gates to the skip count — `run.txt` says `pass=28 skip=4` — but writes no
row for them in `results.tsv`, and `lib/py/bbx/readout.py` counts the screen's PASS and SKIP from those rows
alone: `VERDICT: GREEN   PASS 28  SKIP 0 … (gates 28)`, with no skipped line and no word about the tier.
Reproduced on macOS with a two-gate consumer (one portable gate, one static, its variable unset): the
runner's own console `PASS 1  SKIP 1` and `skipped: <static-tier:REPRO_NEEDS-unset>`, `run.txt` `skip=1`,
one row, the screen `SKIP 0 … (gates 1)`; with the variable set to a directory, runner, `run.txt` and screen
agree at `SKIP 0`. The accounting is bbh's (`bin/bbh-run-static`, the same lines), lifted at S1 step 2
(`b212831`) and pinned by fidelity F13, so the fix belongs to the readout. None of the five committed WSL
runs is affected (each `skip=1` against one SKIP row); macOS never walks the path, because every battery
here sets `BBX_BBH_HOME` — the second host as the detector again (G47, G50).
Two slips of the contributor's own in the same measurement, both caught at once: the first reproduction
used `--tier static`, which runs that tier whatever the variable says, so it took a different path (and its
screen was right: `SKIP 3`, three rows); and the first control set the variable to `1`, which the runner
refuses before any gate runs (exit 2, nothing kept) — a hazard HANDOFF already carries.
Measured the same hour: the maintainer's warning filed with the archive — that the pair, read on macOS,
would print `gates declaring no blind spot: 28` — does not hold at `f6f136d` or at `114a4a5`; both readouts
print `gates declaring no blind spot: 0` and `gates whose header was NOT FOUND: 28 … UNKNOWN` (G50's fix).
Its advice stands: without `root=` rewritten to a local clone, no blind spot of the pair can be read.
Learning (R27): a screen that counts from one source must agree with every count the run records about
itself, or say where they differ — the mechanism, the readout reconciling `run.txt`'s `skip=` with its SKIP
rows and naming a tier not run, with a control in `gates/readout.sh`, is ruled for the next sitting beside
option A. And a reproduction is an instrument: it shows it takes the witnessed path before its result is
read. Rules re-anchored in fact: BBX-1 (every count reported separately, and one was not), BBX-30 and §3.2
(a green that hid four assertions it did not make), BBX-28 (the pair a witness until reproduced), BBX-25
(the second host as the detector), §1.

## G58 — "Every S4 component has two instances except the tolerant-numeric family" held per family and failed one level down, and the question built on it carried a slip of the contributor's own: the temporal family was not measured before "band is the only single-consumer family" was put to the maintainer (paid: 0 battery runs — found by re-deriving the filed claim before building option A; the temporal family measured minutes after the answer and the maintainer told the same sitting; two stale blind spots found by the sweep that followed, X47 and X48; 2026-09-13)
bbx-24 filed, laying S4's readout out, that every S4 component had two instances except the tolerant-numeric
family. Before a gate header was written on that basis it was re-derived (§1): each fixture's tracked expectation
files counted by extension, each fixture config's `driver`, each consumer's kinds table. Per comparison FAMILY it
held for S4 — exact 4 consumers, set 2, schema 2, tolerant-numeric 1. One level finer it did not: the json format
and its view, the line row shape, the band view, the tsv format, the claim row shape and each of the four drivers
have one consumer each. Which level decides was a ruling, not a measurement, so it went to the maintainer as R50
(answered: the family decides, and every finer single-consumer unit is declared).
The question as put said the band family was the only one with a single consumer. That was measured over S3's and
S4's families only; the temporal family (S2), whose one consumer inside BBX is bbh's example, was measured after
the answer. The ruling covered it as written and the maintainer was told in the same sitting — but a sentence put
to the maintainer was wider than the measurement under it, the G55 shape again (a scope widened between the count
and the claim).
The sweep of every header that mentions BBX-25 then found two blind spots S4 had made false and every screen
still printed: `gates/set_schema.sh` ("tsv is its one format", X47) and `gates/docset_suite.sh` (the kinds loop
"BBX-25 unmet", X48), both corrected first in their own commit (`7b7af0e`, BBX-19). Of the ten header entries that
name an S2, S3 or S4 step, the other nine POINT at the gate where a thing is asserted and are still true.
Learning (R27): a claim about "every X" is a claim at a granularity — name the unit in the sentence, and measure
the whole population the sentence names (every family, not the slice's) before it reaches the maintainer; R50's
table, which lists families and finer units apart, is the mechanism. And a blind spot that STATES a status
("unmet", "its one format") about something a later slice will touch goes false the day that slice lands, while
one that POINTS at where a thing is asserted does not: when a slice closes, sweep the headers for statements of
status. Rules re-anchored in fact: §1, BBX-25, BBX-19, BBX-22, BBX-30.

## G59 — A probe counting the census shadow's verdicts read 30 PASS and 1 SKIP for 32 gates, because its name pattern had no digit and `fidelity_bbh_s2` fell out; the census commit went in before the shortfall was chased (paid: 1 recount, seconds; the commit's own sentence — every gate PASS but `census_register` — was true, measured by the recount after it was written; 2026-09-13)
After the census regeneration at bbx-25, the verdict lines of its console were counted with `^    [a-z_]+ +PASS`. The
shadow ran 32 gates; the count read 30 PASS, 1 SKIP, 0 other — a total one short, which is the signal, and it was
printed beside a `gates traced: 32` line and not reconciled before `610bba7` was committed. The recount with
`[a-z0-9_]+` read 32 rows: 31 PASS, 1 SKIP (`census_register`, by design in the shadow, G46). No number from the
defective probe reached a document or a commit message; the message's claim came from reading the console's
lines, and the recount confirmed it after the fact rather than before.
Learning (R27): the G48 / G57 shape inside the contributor's own probe — a count that reads less than is there. A
probe that counts rows checks its total against the population it knows (here the 32 of `gates traced`) and stops
on a mismatch; a name pattern for gates admits digits. No harness mechanism: the harness's own readers take gate
names by field, never by a character class (BBX-12). Rules re-anchored in fact: §1, BBX-12, BBX-1.

## G60 — G33's trap in a probe again: a zsh loop spliced `$c:gates/readout.sh`, the shell read `:ga` as modifiers, and every count read 0 beside git's own fatal errors (paid: 1 probe re-run under /bin/sh, seconds; no number reached a document; 2026-09-13)
Choosing which count the platform README's tree check should name at bbx-25, a loop over `429d3f8`, `114a4a5`
and `HEAD` printed `readout.sh MUST-FIRE=0 close_sweeps.sh MUST-FIRE=0` for all three — impossible, since the
controls reader had just read 12 declared for `readout` at HEAD. git printed `fatal: ambiguous argument
'…/BBX/429d3f8tes/readout.sh'`: zsh took `:g` and `a` after `$c` as history modifiers (make the value an
absolute path) and left `tes/readout.sh`, the family HANDOFF names under G33 (`$c:lib` reaching git as
`headib`). `grep -c` over the empty stream printed 0, and the loop printed on. Re-run under `/bin/sh -c` with
`"${c}:gates/…"`, each commit's file first proven to exist: 11, 14 and 17 — and those were not the header's
count either, because `gates/readout.sh` carries stub gates in heredocs whose own `# MUST-FIRE` lines start at
column 0 (12 in the header at HEAD, 5 in the stubs). The tree check chose a file with no stubs.
Learning (R27): the hazard was in HANDOFF and was not applied, because the probe was typed fresh instead of in
the hazard's safe form. No harness mechanism (the harness's tools run under `/bin/sh` and read headers through
one reader); for probes, a revision spliced with a path is written `"${c}:path"`, a zero out of a pipeline whose
producer failed is silence, not a count (the G59 shape), and a grep over a whole file is not a header read.
Rules re-anchored in fact: §1, BBX-12, BBX-16.

## G61 — A line-only probe of the ledger's re-anchor lists reported 12 rules never re-anchored; the number is 7, because lists wrap and the probe read the line that held the lead word (paid: 2 probe re-runs, seconds; no number reached a document; 2026-09-14)
Measuring S5's census at bbx-26, a first probe took, for each gotcha, the one line containing "re-anchor" and the
rule ids on it, and printed 12 rules with no incident: BBX-2, 3, 4, 7, 11, 13, 14, 17, 18, 26, 27, 28. STATE's own
list said `G17 → BBX-24/BBX-26`, which the tally contradicted: G17's list names BBX-24 on the line that holds its
lead word and BBX-26 on the next. A second probe read each paragraph to its end and over-read: explanations in parentheses name
rules that are not re-anchors. The third read each list from its lead to the end of its sentence with parenthesized
text skipped (`docs/plans/S5.md`, appendix A): 59 of 60 entries carry a list, G24 none, 23 rules named and 7 not.
Checked both ways against STATE's hand-kept list, which was itself wrong in 6 of the 30 entries its range covers (X51).
Learning (R27): G53's shape inside a probe — one line of a multi-line thing read as the whole — caught by a second
source, which is the G59 learning applied: a tally is checked against another reading of the same population before
any share of it is used. Mechanism, proposed with R53: the ledger reader carries `wrapped-incident-list` and
`parenthesized-id`, the two controls these two failures define. Rules re-anchored in fact: §1, BBX-7, BBX-16.

## G62 — F18's filed bbh-side command could not produce a verdict: bare `check-skills -v` reads no config and exits 2; filed at birth and first run at bbx-26, and the correction's first draft typed a mechanism nobody had measured (paid: 0 — no gate was built on it; one clone run and one read of `bbh.config.consumer`, seconds; 2026-09-14)
`docs/fidelity.md` (session 1, 2026-09-09) gave F18's bbh side without `--config`. On a plain clone of `10a82d2` with
`BBH_CONFIG` unset both tools exit 2: `FAIL  config: [skills].prefixes names no skill` and `FAIL  config:
[skills].guided names no skill (and no --prefix given)`. bbh's own test calls them with `--config
skill/skills.toml`, and there the lock reads `ALL PASS (87 rules across 1 skills …)`. The first draft of the
correction said the bare form "reads bbh's example config"; before the commit `bbh.config.consumer(None, None)` was
read and run — with no path and no `BBH_CONFIG` it returns `{}` and the working directory — and the sentence was
rewritten to that (`736949e`, X49).
Learning (R27): a command written into a plan is a claim until it has run once, and a mechanism written into a
correction is measured like any other claim (G27's family, caught before the commit). No harness mechanism: F18's
gate runs the command and diffs it, which is the check. Rules re-anchored in fact: §1, BBX-19, BBX-21.

## G63 — bbh's guide generator keeps only the first line of a wrapped rule while the lock and `--check` stay green; the lineage's 642 definitions never wrapped and BBX's 30 all do (paid: 0 — a probe in the scratchpad before any lift; 2026-09-14)
A synthetic skill whose rule `- [XX-1] FIRST LINE of a wrapped rule` continues on an indented `SECOND LINE that a
reader must not lose.` was run through bbh at `10a82d2`: `check-skills` ALL PASS, `skill-guide` wrote the guide,
`--check` read it current, and the guide carries `**[XX-1]** FIRST LINE of a wrapped rule` — `SECOND LINE` 0 times,
`FIRST LINE` once. `RULE_RE` in `gen_skill_guide.py` matches one line. bbh's skill wraps 0 of 87 definitions and
VampireSaved's eight skills 0 of 555 at `0cdd9726`; every one of CLAUDE.md §4's 30 entries spans more than one line.
A finding about bbh too, which BBX does not modify (G11's precedent: the maintainer's to act on there).
Learning (R27): "unchanged for its second consumer" is a claim until the second consumer's input has run through it
(G26) — here measured before the lift rather than after. Mechanism, proposed as R54(a): a definition followed by a
continuation line fails the lock, so no guide is ever generated from a truncated rule. Rules re-anchored in fact:
BBX-25, BBX-16, BBX-30.

## G64 — The lock's "numbers cite the log" was calibrated on the ROM lineage: over BBX's rules it sees nothing, over BBX's pages it misses the counts and reads commit-id fragments as numbers (paid: 0 — measured before any lift; 2026-09-14)
`checkskills.numbers` has six patterns (0x-hex of 3+, `$`-hex of 4+, comma-grouped integers, decimals, integers of
4+ digits, lowercase hex of 8+), years and `d.d` section numbers skipped. Over VampireSaved's eight skills it finds
124 tokens; over all of CLAUDE.md, 0 — the only digit runs in the 30 rule bodies are BBX-10's "19 reds" and
BBX-30's "§3.2", and it sees neither. Over `HANDOFF.md` it sees 5 distinct tokens and misses 67 distinct 1–3 digit
integers (`STATE.md` 11 and 44, `docs/readout.md` 175 and 227), and among what it sees are `63797`, `81417`, `4094`
and `5481`, the digit runs of `fd63797`, `e81417d`, `f4094c2` and `ecc5481`.
Learning (R27): BBX-24's biased default, with BBX as the second consumer that detects it; lifted unchanged, it would
be a check that cannot fail on BBX's skill (BBX-6's silent mode by construction). Mechanism, proposed as R54(b): a
per-skill vocabulary, bbh's six patterns the default. Rules re-anchored in fact: BBX-24, BBX-6, §1.

## G65 — Three lineage citations in CLAUDE.md give bbh rule ids to VampireSaved, or cite a bbh rule that says none of what the BBX rule says (paid: 0 — measured on the clones while reading the tags for S5; 2026-09-14)
BBX-20's tag is `[inherited VS BBH-9; L1]` and §3.3 ends "(VampireSaved BBH-53, extended)". VampireSaved at
`0cdd9726` holds no `BBH-9` and no `BBH-53` — the literal search is proven able to fire (`VSP-19`: 23 occurrences in
17 files) — and its five `BBH-` occurrences all describe bbh's skill; both ids are bbh's, anchored in bbh's
`docs/doctrine.md` and `docs/hygiene.md`. BBX-1's tag is `[inherited bbh BBH-10..13]`, and bbh's BBH-10 is "The
doctrine is not a tuning guide and not a claim about correctness": read beside BBX-1's clauses, it carries none of
them, while BBH-6 and BBH-16 carry two and are not cited. bbh's `SKILL.md` did not change between `f675710` and
`10a82d2`, so the citations were written against this numbering. CLAUDE.md is not edited here (R16): the wording is
filed with R55.
Learning (R27): G2's reading again — a citation is a claim and is checked like one. Mechanism, proposed with R56: a
`[BBH-N]` the skill carries is resolved against bbh's `SKILL.md` at the fidelity baseline. Rules re-anchored in fact:
BBX-21, §1.

## G66 — Queuing R51–R57, DECISIONS.md's open-rulings line still read `none`, and the shape gate said so before the commit (paid: 1 gate run, seconds; 2026-09-14)
The seven rulings were written into `docs/rulings.md` under `## Open`, and STATE's and HANDOFF's status lines were
updated in the same pass, but `DECISIONS.md` carries its own open-rulings line, which `gates/rulings_shape.sh` reads
with `\bR\d+\b` and requires to list exactly the open ids. On the tree it printed `open-line-mismatch listed=none
actual=R51,R52,R53,R54,R55,R56,R57` and FAILed; nothing had been committed. A range written with a dash would have
failed as well — that reader takes two ids from it, not seven — so the line lists the seven one by one.
Learning (R27): no new mechanism; the check exists for exactly this (G14, G51) and fired at its first chance. The trap
worth naming: a raised ruling is written in four places (the queue, DECISIONS.md's open-rulings line, STATE, HANDOFF),
and a range is not a list to the reader of the second. Rules re-anchored in fact: BBX-9, BBX-20.

## G67 — This host's `git grep -E` ignores `\b`: a word-bounded search matches nothing and exits 1, the exit of a true absence (paid: 0 — probes re-read, no number reached a document; 2026-09-14)
Twice at bbx-26 a probe put `\b` inside `git grep -E`: a count of bare `BBH-N` tokens in VampireSaved at `0cdd9726`
read 0 beside 5 literal `BBH-` occurrences, and a search of BBX's tree for BBH-53 or BBH-9 with a trailing `\b` printed
nothing while CLAUDE.md held both ids. Measured on CLAUDE.md with git 2.54.0 (Apple Git-157): `-E` with `BBH-9\b`
exits 1 with no output; `-F 'BBH-9'`, `-w -F 'BBH-9'`, `-P` with `BBH-9\b` and `-E 'BBH-9([^0-9]|$)'` each find the
line; `-E` with a leading `\b` before `BBH-` exits 1. The first zero was never used (the plan counts with `-F`); the
second was caught because CLAUDE.md was known to hold both ids. In the same hour a filter over `git diff -U0` for
changed lines, `^[-+][^-+]`, hid two of three edited CLAUDE.md lines, whose content begins with `- `; the edit script's
own asserts said three, and the full diff shows three. BBX's own `bin`, `lib`, `drivers` and `gates` — 82 files, 544
lines calling grep — hold no `\b`, `\<` or `\>` in a grep line (the scan flagged both escapes on synthetic lines and
passed a plain `-F` line before it was believed).
Learning (R27): G59 and G60's shape, silence read as a count, through two new tools. For probes on this host a word
boundary is `git grep -P` or `-w`, a zero from any search carries a positive control of the same shape, and a diff
filter never excludes a leading `-`. No harness mechanism (the scan above); the trap is a HANDOFF hazard. Rules
re-anchored in fact: §1, BBX-7.

## G68 — R43 recorded an inference as a measurement: a kind-blind config section was said to break F13e, and a config dump prints the consumer's file only (paid: 0 — found by S5 step 1's own F13e run; 2026-09-14)
R43 (bbx-20) declined a `[fidelity]` config key "by measurement", and the measured part was true: F13e's two `config
dump`s of bbh's example carried the same section list. The conclusion drawn from it, that a new kind-blind section
would put a line in BBX's dump and none in bbh's, was never run: `bbx.config` `main` prints `cfg.items()`, the
consumer's file, and never `DEFAULTS` (bbh's dump behaves the same — its defaults carry `[skills]` and its dump of
bbh's example printed no such line, measured bbx-26). S5 step 1 added a kind-blind `[skills]` section, and
`gates/fidelity_bbh.sh` read `F13e config dump of example/bbh.toml: identical (108 lines)` and PASS. The ruling's
choice, one sourced definition of the baseline, stands on its other recorded reason; the false one was corrected in
`DECISIONS.md`, `docs/defaults.md` D20 and `lib/sh/baseline.sh`, first and in its own commit (X55).
Learning (R27): "declined by measurement" covers what was measured and nothing drawn from it; a prediction taken from
a measurement is a claim until it has run. S5's plan wrote the opposite prediction as "expected" and measured it at
the step that could. No harness mechanism. Rules re-anchored in fact: §1, BBX-19, BBX-21.

## G69 — The platform step-by-step carried three current-tense counts a registry defines, and two had been false for sittings: a Linux screen's `PASS 30 SKIP 1`, the static tier's "four gates", and a census-drift NOTE "expected on every screen right now" (paid: 0 — found reading the page's own diff while S5 moved the gate counts; 2026-09-14)
`docs/platforms/README.md` is the page a platform run follows. Updating its gate count for S5 step 1 showed three more
statements of status: the Linux screen shape `PASS 30  SKIP 1`, true of 31 registered gates and false since R45 added a
gate at bbx-23 (X56); the static tier as "the four gates" with the screen `(gates 28 kept, 4 not run)`, false since S5
step 1 made it 5 (X57, and HANDOFF's hazard line carried the same count); and "One NOTE is expected on every screen
right now" over `census-drift register=af2b1f085070`, false since the census was regenerated at bbx-25 — the register
check read no drift after the census commit `56ef986` at bbx-26 (X58). A search for the second wording by its whole
sentence found nothing, because the sentence wraps and the search reads one line at a time; its retraction pattern
takes the part that sits on one line. Each statement is now the shape without a copied number, the count re-derived by
a command the page gives; the recorded runs keep their own counts, as records.
Learning (R27): G54's shape again — a procedure page quotes registry counts as the reader's expectation, and nothing
reads the page against the registry; when a slice moves a registry, sweep the procedure pages as well as HANDOFF. No
harness mechanism; it strengthens G54's named candidate, BBX's own `docs/` checked as a document-set subject.
Rules re-anchored in fact: BBX-20, BBX-9, §1.

## G70 — A probe for quoted leads counted 9 real re-anchor lists as quoted: it took a quotation mark or backtick before a lead for an opening one, and all 9 were closing (paid: 0 — the hits were read before any was counted; no number reached a document; 2026-09-14)
Designing S5 step 3's handling of a quoted lead at bbx-27, a probe searched `docs/gotchas.md` for a straight or curly
quotation mark or a backtick followed, within 40 characters on one line, by `Re-anchors` or `re-anchored in fact`, to
count the leads the ledger holds inside quotations. It printed 9 candidates, at lines 105, 122, 216, 445, 520, 619,
718, 1155 and 1419; read one by one, every one was a real list whose lead follows the CLOSING mark of an earlier
quotation or code span. Which side of a pair a mark is on cannot be told from its neighbours, only by pairing from the
start of the paragraph. Measured next that way: of the ledger's 137 entry paragraphs none has an odd backtick count or
an unpaired straight or curly quotation outside code, and none of the 68 leads sits inside an open one; the draft
reader, which closes a backtick run only on a run of its own length and pairs quotations and parentheses, named the
same references as appendix A's prototype in all 69 entries.
Learning (R27): mechanism built. `lib/py/bbx/reanchors.py` pairs code spans, quotations and parentheses from the start
of each paragraph, and a paragraph holding a lead whose spans do not close is an error, never a guess (D67, control
`unbalanced-paragraph`); the four quotings the probe could not tell apart are control `quoted-lead`. Rules re-anchored
in fact: §1, BBX-5.

## G71 — Two probe lines at bbx-27 read less than they asked, each loudly: zsh abandoned a line at an unquoted `=====`, and `sh -s help` over a piped `bin/bbx` printed nothing because the help reads `$0` (paid: 0 — one probe re-run; no number reached a document; 2026-09-14)
A probe chained as `git show -s --format='%B' a6f3e58 | head -45; echo =====; sed -n '1,20p' gates/census_register.sh`
printed the commit message, then `(eval):1: ==== not found`, and never ran the `sed`. Measured with zsh 5.9: `zsh -c
'echo first; echo =====; echo third'` prints `first` and `zsh:1: ==== not found`, exits 1, and never prints `third`;
with the separator quoted it prints all three and exits 0. zsh expands a word that begins with `=` into the path of
the command it names, and a failed expansion abandons the rest of the line. In the same sitting, `git show
HEAD:bin/bbx | sh -s help | wc -l` read 0 where the working tree's `bin/bbx help` prints 21 lines: the help is `sed -n
'2,22p' "$0"`, and under `sh -s` the name in `$0` is `sh` (`sed: sh: No such file or directory`, exit 1). Neither
zero was used: the first probe was re-run with the separator removed, the second dropped.
Learning (R27): G33's and G60's family, a shell rewriting a word the command never sees, and G59's shape, a zero out of
a pipeline whose producer failed. No harness mechanism: the harness runs under `/bin/sh`, and `bin/bbx help` reads its
own file by path. For probes on this host a separator is quoted, and a script that reads `$0` is run by its path,
never through a pipe. Rules re-anchored in fact: §1.

## G72 — Run on the pre-build clone, the skills gate's new §8 stopped at a `set -e` command substitution over the missing skills table: a traceback, and no line saying why §8 could not run (paid: 0 — the red-on-old run caught it before the commit; one gate re-run; 2026-09-14)
Measuring S5 step 4's two changed gates red on a clone of `4f57867` with only those gates copied in, `gates/skills.sh`
exited 1 after 106 lines. §8's checks over the tree printed `skill-gen --check … refused` (`bbx: unknown command
'skill-gen'`) and `the forbid list is empty or bars what R4 allows`; then `_ownfiles="$(python3 -c …)"`, which loads
`skill/skills.toml`, raised `FileNotFoundError`, and `set -e` ended the gate on that line. The verdict was right, and
only because the exit decided it: exit 1, classified FAIL, and 16 declared controls unfired. The log never said that §8
had no skills table to read, G40's shape of a log that simply stops. Guarded before the commit: §8 now opens on `[ -f
skill/skills.toml ]`, and on the same clone the gate exits 1 printing `FAIL  BBX's skills table skill/skills.toml is
missing: §8 cannot run, and its controls stay unfired`, with 28 controls fired, no traceback, and exactly §8's 16
controls declared and unfired.
Learning (R27): mechanism built (the guard). A gate section guards the file it is about before a command substitution
reads it, and a red-on-old run is read for why it is red, not only that it is. Rules re-anchored in fact: BBX-1, BBX-6.

## G73 — A probe counted 93 of 90 two-digit integers present in one page: it kept every two-character token, and seven carried a leading zero (paid: 0 — the impossible count was caught on sight; no number reached a document; 2026-09-14)
Choosing the skill's logs at S5 step 4, a probe printed `two_digit_present=93/90` for `docs/census/vampiresaved.md`. It
counted the tokens `integers()` returns that are two characters long, and seven of those are `00`, `01`, `02`, `03`,
`05`, `06` and `08` (measured after); over the integers 10 to 99 the page holds 86. The impossible count was not used,
the absent list printed beside it (66, 81, 87, 96) came from the range and was right, and D69's figures (40 of 90 for
the two logs chosen, 86 with the census page instead) were measured over the range before they were written.
Learning (R27): G59's shape, a total not checked against its population before a share of it is read, caught this
time because the population was printed in the same line. No harness mechanism: the gate's absent-integer control
(`own-number-in-no-log`) walks the range 10 to 99, never tokens by length. Rules re-anchored in fact: §1.

## G74 — Two status lines stayed stale while the rows beneath them were kept current: the fidelity plan's shape line still called F18 open a sitting after F18 was gated, and the S5 plan's status still named step 3 as next after step 3's own ledger commit (paid: 0 — found by a sweep for stale next-step wording at S5 step 4; no gate reads either line; 2026-09-14)
Sweeping the tree outside the ledgers for next-step wording before S5 step 4's ledgers, `git grep` found
`docs/plans/S5.md:23` still ending "Step 3 of §10 is next." — true when bbx-26 wrote it, false from `c17ae40`, and
left standing by bbx-27's own step-3 ledger commit `4f57867`, which moved STATE and HANDOFF but not the plan. Reading
`docs/fidelity.md` for its F18 row in the same hour showed the page's shape line, "F18–F21 are open": F18 has run in
`gates/fidelity_bbh_s5.sh` since `a6f3e58` (bbx-26, S5 step 1), and bbx-26 wrote F18's measurements into the row
below that line twice (`f994b4a`, `1427d4e`) without touching the line itself. Both were corrected in their own commit
before step 4 landed (BBX-19).
Learning (R27): G69's shape again, a status repeated in a page's summary line going stale while the page's table is
kept, now in two plans. No harness mechanism; at a step's ledger commit the sweep covers every plan the step belongs
to, its status line, and the shape line of any page whose row the step moved (a HANDOFF orientation bullet). It
strengthens G54's named candidate a third time. Rules re-anchored in fact: BBX-20, §1.

## G75 — A load test's cleanup never ran: under zsh `kill $pids` is one word, so 24 CPU burners stayed up for 1 h 41 min on the maintainer's machine while the script waited on them (paid: 1 h 41 min of a 12-core host saturated, load average about 57, and anything else run on the host in that window ran on it; 2026-09-14)
Investigating G76, a background command started 24 `yes` processes to load the CPU, collected their ids with
`pids="$pids $!"`, ran the gate, then ran `kill $pids 2>/dev/null; wait`. The shell the command ran in is zsh, which
does not split an unquoted parameter into words: `kill` received the whole list as one argument, refused it as an
illegal pid, and `2>/dev/null` swallowed the refusal; `wait` then waited on 24 live children. Found when the maintainer
asked for the status: 24 `yes` processes under one parent, elapsed 01:41:22, load average { 55.42 57.13 59.32 };
killed one by one by id, 0 left. Measured after with zsh 5.9 on two harmless `sleep 40` processes: `kill $pids` prints
`illegal pid:  65093 65094`, exits 1 and leaves both alive; the same line under `sh` kills both; `${=pids}` splits in zsh.
Learning (R27): G33's, G60's and G71's family, zsh reading a line differently from `/bin/sh`, and this time the cost
landed outside the tree. For probes: anything that starts processes is a script file run with `sh`, its cleanup kills
by a loop over the ids, never behind `2>/dev/null`, and the probe confirms none is left before it reports. A HANDOFF
hazard. Rules re-anchored in fact: §1, BBX-7.

## G76 — The sweep runner gate's pull-queue check compared two clocks on a 1-2 s margin, and one battery read the third short stub starting 5 s after the slow stub ended (paid: one NOT GREEN battery over the S5 step 4 build, about 14 min, and three runs of the gate; the burners of G75 were spent here too; 2026-09-14)
The battery over S5 step 4's uncommitted build (`build/selftest_20260914T092705Z`) read NOT GREEN, PASS 33 FAIL 1,
controls 179 / 179: `gates/sweep_runner.sh` §15, `FAIL: queue: f3 start='1789378113' slow end='1789378108'`. The check
started a 4 s stub and three 1 s stubs on two workers and required the third short stub's start stamp to be earlier
than the slow stub's end stamp. Over the gate's 92 kept runs the slow stub had ended 1 s after (64 runs) or 2 s after
(27 runs), a margin a few seconds of late start erases, and this run read -5: every stub started late, the third short
one 7 s after a queue would have started it. Nothing the step changed reaches the runner (`bin/bbx-run-sweep` last
changed at `8890e4e`, bbx-2). Re-run alone the gate passed with a margin of 1 s, and under 24 CPU burners on 12 cores
it passed with a margin of 1 s again: CPU load alone did not reproduce it, and the delay's cause is unmeasured
(XProtect at 37% CPU at the time is a candidate only). Made deterministic rather than re-run into green (BBX-14): the
slow stub now ends when it sees a marker the third short stub leaves as it starts, with a 30 s limit, and §15 reads its
`saw_f3=yes|no`; a second run starts every short stub 2 s late. On a clone of `4f57867` whose old §15 had the same 2 s
late starts, the old gate went red on exactly that check (`f3 start='1789385481' slow end='1789385479'`); the fixed gate
passed twice in the tree, 87 s and 85 s, and in both runs its normal case printed the third short stub's start and the
slow stub's end in the same second, which the old strict comparison would have read as a failure.
Learning (R27): mechanism built (the marker). A verdict decided by comparing two clocks has a margin, and a margin is
a tolerance nobody ratified: order is proven by a handshake, and a clock is printed, never compared. Feature work
halted on the red until the gate was fixed and measured. Rules re-anchored in fact: BBX-14, BBX-26.

## G77 — Moving HANDOFF, STATE and the S5 plan to step 5, the contributor wrote that the promotion waited for the maintainer to approve its wording, although R55 had approved that form at bbx-26 and the bullet being rewritten had said so (paid: 0 — found by reading R55 before the next question was put, before any edit of CLAUDE.md; one correction commit; 2026-09-14)
The step 4 ledger commit `5fcde57` replaced HANDOFF's orientation bullet, which at `db5a1ca` read "R55's part (2) (the
23 tags promoted, wording approved)", with "on wording the maintainer approves BEFORE the edit (R16)", and wrote the same
claim twice into STATE and once into the S5 plan's status line; the contributor also told the maintainer twice that
step 5 needed an approval first. `docs/rulings.md` R55 records "Approve both as worded", part (2) being the tag form
`[re-anchored; inherited <lineage as written>]`. Read before the question "step 5 or close" was put, it also showed the
one case that form does not cover: BBX-30's tag is `[this project]`, the only one of the 30 not `[inherited …]` (29 by
`grep -c`), which the maintainer then ruled as R58. X62, planted in a clone of `5fcde57`, fired on the four lines
(retraction_hits=4) and read 0 once the copies were corrected; the tree was corrected in its own commit first.
Learning (R27): §1's own failure, in prose: a status about a ruling written from memory while the ruling was one read
away, over a sentence that had been right. No harness mechanism (G54's candidate would have to read the rulings as a
subject); when a sentence about a ruling is rewritten, the ruling is read first. Rules re-anchored in fact: §1, BBX-22.

## G78 — S5 step 2's `integers` vocabulary has one real consumer and no gate declared it, as R50 requires; found drafting S5's slice readout, four harness commits after it landed (paid: one census regeneration superseded before its commit, about 11 min; 2026-09-14)
Drafting the per-component BBX-25 table of S5's slice readout (R50), the number vocabulary `integers` (R54, delta 6,
D66) came out with one consumer: `git grep '^numbers' -- '*.toml'` over BBX's tree finds only `skill/skills.toml:28`,
and neither bbh's `skill/skills.toml` nor its VampireSaved consumer config (8 skill tables) at `10a82d2` sets
`numbers`. `gates/skills.sh` declared BBX-25 for the ledger reader and for the skill generator, both built at bbx-27,
and not for the vocabulary built at bbx-26 (`da62aa3`): R50's declaration was applied to what the sitting built, not
to what the slice built. The census regenerated at `24cfb12` (identity `7c34a438ca8e`, 49 rows, 33 gates PASS in its
shadow) was superseded by the declaration's own commit `c5f1312` and set back to HEAD, never committed.
Learning (R27): G58's shape at a slice readout: the population of BBX-25's per-component table is every unit the
slice built, across all its sittings, and each unit with one consumer is declared before the table is written. No
harness mechanism; the readout draft is where it was caught. Rules re-anchored in fact: BBX-25, §1.

## G79 — A commit message took the census's row count from the wrong field: a `sed` matched `missing-rows 0` where `rows 49` was meant, and the subject read "0 rows" (paid: 0 — read off the printed values straight after the commit and rewritten before the push, the tree proven identical; 2026-09-14)
Committing the bbx-27 census after the skills gate's two changes, the message took its row count from the register line
`register   files 49   rows 49   missing-rows 0   dead-rows 0` with `sed 's/.*rows \([0-9]*\) .*/\1/'`: the greedy
`.*` ran to the last `rows `, the one inside `missing-rows`, and handed back 0. The subject was committed as "34 gates,
0 rows, no kind lost", beside a body that quoted the register line correctly, and the same value went into the close's
parameter file. Read in the values the command printed after it, the two unpushed commits were rebuilt with the
subject reading 49 rows, and `git diff` between the old and the new head read empty.
Learning (R27): G27's shape, a commit message's number not read off the run, through BBX-12's mechanism, a value taken
by its position in a line rather than by its field name. No harness mechanism (the harness's own readers take
`rows=`-style fields by name); for probes a field is taken by an anchored name, `rows \([0-9]*\)   missing`, or with
`awk` over split fields, never by a greedy match. Rules re-anchored in fact: §1, BBX-12.

## G80 — The close's battery pair was stopped a minute in because the host ran low on memory; the battery was the one killed, not the one using the memory (paid: one battery start lost, about 1 min, and the pair re-run one battery per command; 2026-09-14)
At 15:32:54Z battery A of the close pair started at `197634e` in one background command with battery B queued behind
it; about a minute later the command was stopped "because the system is running low on memory". Its kept run holds 6
rows: `static_runner` and `controls` PASS, and `sweep_runner` FAIL with exit 143 after 22 s, the signal the stop sent.
Measured just after: no harness process left and the tree clean; 16 GB physical with 60 MB of free pages, 6.2 GB in the
compressor and 79.5 GB of cumulative swapouts; the largest resident processes the Claude app (481 MB), a browser (405
MB), Zoom (376 MB, started 6 minutes before) and WhatsApp (371 MB, started under a minute before). The maintainer chose
to re-run at once, one battery per background command with a memory reading printed before each. The same reading
found `$TMPDIR` holding 81,224 `tmp.*` entries, 21,327 of them older than a day and 36,909 empty, with 594 changed in
the previous 15 minutes, around a census and a battery: something BBX or its lineage runs leaves temporary directories
behind, and its source is unmeasured.
Learning (R27): a kept run that a host signal ended reads FAIL, exit 143, on the gate it cut, a verdict about the host
and not about the gate; a pair is run one battery per command, so one stop costs one battery. The `$TMPDIR` count is
named in HANDOFF for bbx-28, measured once and not gated. Rules re-anchored in fact: §1.

## G81 — A probe for BBX-25's second consumers printed three zeros that measured nothing: under zsh `set -- $spec` left the whole line in `$1`, and every `git -C "" grep` failed into `wc -l` (paid: 0 — caught reading the labels the probe printed, before any number was used; one re-run under `sh`; 2026-09-14)
Answering what an unmet BBX-25 entails for S5's three units, a loop over `"bbh $B 10a82d2" "VampireSaved $V 0cdd9726"
"SMS $S ecc5481"` split each item with `set -- $spec`. zsh does not split an unquoted parameter into words, G75's
mechanism, so `$1` held the whole item and `$2` and `$3` were empty; `git -C "" grep` failed, its error went to
`/dev/null`, and `wc -l` printed 0 for the re-anchor lists, the `numbers` keys and the skill generators of all three
repositories. The labels gave it away, reading `bbh /Users/… 10a82d2 @:`. Re-run under `/bin/sh` with a positive
control per repository, its `SKILL.md` files (1, 8 and 2), the three zeros held and became a measurement.
Learning (R27): G59's shape, a zero out of a pipeline whose producer failed, reached through G75's zsh mechanism, in a
probe with no positive control of its own shape. No harness mechanism; a probe over several repositories counts
something known to be there in each before it counts what may be absent, and runs under `sh`. Rules re-anchored in
fact: §1, BBX-7.

## G82 — The temporary directories G80 named come from bbh's fake driver: it makes a fresh sandbox with `mktemp -d` when none is named and never removes it, and three of BBX's static gates name none (paid: 0 runs — attributed at the bbx-28 open from the opening battery's own window; 40,312 such directories left on this host since 2026-09-11, their bytes not measured; 2026-09-14)
The opening battery at `35faa56` (`build/selftest_20260914T180055Z`, started 18:00:56Z, gate runtimes summed 854 s
against 855 s of wall clock, so the static runner ran its gates one after another) was bracketed by counts of
`$TMPDIR/tmp.*`: 82,414 before, 83,010 after. Grouped by birth time and by the names inside, the 594 entries born
during the run were all directories holding one file, `fake_replay.log`; assigned by birth time to the gate whose
cumulative window held them, `fidelity_bbh` 26, `fidelity_bbh_s2` 310, `suite` 258, none unassigned. bbh's
`drivers/fake.sh:64` writes that file into `WORK="${SANDBOX:-$(mktemp -d)}"` (`:54`); the script holds no `trap`,
`rm -rf` or `rmdir` (the same search finds its three `rm -f` lines) and is unchanged from `c26ba45` (2026-09-06) to
bbh's tip. bbh's driver contract makes the sandbox optional, "a fresh temp dir when omitted" (`drivers/README.md:20`
at `10a82d2`), and says nothing of removing it; `bin/bbx-run-suite:233` calls the driver with three arguments exactly
as `bin/bbh-run-suite:120` does, and so do `gates/suite.sh:122` and `gates/fidelity_bbh_s2.sh:141`. BBX's own
command-line driver removes a fresh sandbox (`drivers/cli.sh:90`) and its header cites `[BBH-36]` for "removed after
the run", which BBH-36 does not say. BBX's own temporary files left nothing born in the window: no other `tmp.*` name
from the 44 lines naming `mktemp` in its code, and none of the 3,554 `tmp<random>` names Python's `tempfile` writes
(the same scan saw the 83,011 `tmp.*` entries). The backlog, counted by
birth day and contents: 40,312 directories holding only `fake_replay.log`, from 2026-09-11 on (12,434 and 12,777 on
the two whole days; hourly counts of 1,782 and 2,970, three and five batteries' worth); 36,909 empty, of which 36,898
were modified at least a day after their birth and always in a 03:00 local hour (the 31,669 born 2026-09-10 were
emptied on 2026-09-14 at 03h) — something on the host empties old temporary files nightly, so what those held is not
recoverable and is not attributed; 5,433 holding `cfg` and `nvram`, born 2026-08-28 to 2026-09-09, before any BBX gate
called a driver; and 358 others at the first count. The probes are kept in `docs/plans/S6_probes/`.
Learning (R27): the second harness side effect found outside its sandbox, after G30's crash reports, and the second
found by the host rather than by a gate — a mechanism, not a hazard line: count what each gate leaves on the host.
Attribute before any cleanup: birth time and the names inside attributed 594 of 594, and the gap between birth and
modification time told a directory emptied later from one born empty. S6's plan carries both (R65). Rules re-anchored
in fact: §1, BBX-23.

## G83 — A census probe's positive control could not fail: it appended a letter AFTER a quoted fragment, which leaves the fragment in the document, and SMS's checker rightly passed (paid: 0 — caught reading the control's exit, 0 where 1 was required, before the sabotage result it guarded was used; one re-run; 2026-09-14)
Re-deriving a census agent's report that SMS's `tools/checkdocs.py` at `ecc5481` passes an orphan page and a dead
link, the probe planted both in a copy and, as its positive control, edited a fragment the checker quotes from a
document through `says()`: it replaced the fragment with itself followed by `X`. `says()` asks whether the document
contains the fragment, and it still did, so the control read `ALL PASS (249 checks across 20 documents)` like the
sabotage beside it, and the sabotage's pass measured nothing. The edit was moved inside the fragment, with an
assertion that the fragment is gone: `1 of 249 checks FAILED`, exit 1, and the sabotaged copy's `ALL PASS` became a
measurement. The fixed probe is `docs/plans/S6_probes/rederive_sms.sh`.
Learning (R27): the control's own predicate was not read — a check for containment cannot be failed by adding text.
No harness mechanism; a planted defect asserts it removed what it claims to remove before the run it guards. Rules
re-anchored in fact: §1, BBX-8.

## G84 — A retraction pattern matched two of the four lines it was written for: a space before its alternation demanded `harness _scope` where the pages read `harness_scope` (paid: 0 — caught by counting the pattern's matches against the four occurrences a plain search had listed minutes before, and before any page was corrected; 2026-09-14)
X66 was first written `The eight harness (defaults|_scope decisions)`, to retire the count in rows V-D10 and V-X11 of
`docs/census/vampiresaved.md` and `docs/bins/vampiresaved.md`, four lines a fixed-string search had just listed. The
sweep, run before the correction as G41 asks, fired, and that alone would have passed G41's test; a line-by-line match
of each new pattern across the tree read two lines for X66, both V-D10's. The space sat outside the group, so the
V-X11 lines could never match. The pattern became `The eight harness(?: defaults|_scope decisions)` and was run
against the uncorrected pages again before they were edited.
Learning (R27): G41's rule, that a planted pattern must be seen to fire, is met by one hit, and one hit is not the
population the pattern was written for; a retraction pattern is checked against the number of occurrences its wording
has. No harness mechanism beyond G41's filed candidate. Rules re-anchored in fact: §1.

## G85 — S6's plan proposed two TSV registers and its questions offered deferral options, against two of the maintainer's standing words already in the tree (paid: R62 put twice, R64 rewritten before it was put, and one exchange with the maintainer; 2026-09-14)
Drafting K4 and K5, the plan copied VampireSaved's register format, `docs/doc_shape.tsv`, into `docs/documents.tsv`
and `docs/rot.tsv`, and was committed with both (`e95be35`). R34's row in `DECISIONS.md` records "TSV breaks silently"
and R40's answer "a caveat on the use of TSV elsewhere"; neither was read before the format was chosen. The maintainer
declined R62: "I've said it before, I'll say it as many times as necessary: I am very wary of TSV as it breaks easily
and cannot be mended after the fact. My personal choice is always more structured data like TOML, JSON, etc." R62 was
put again and R64 rewritten, both as TOML-subset registers in R24's shape, and both were answered as recommended
(`c106028`). The same questions had offered options such as deferring R29, a mechanism without its retrofit, and the
rot classes left as prose; the maintainer's words with R49, repeated in STATE, are that discipline is never arbitrated,
only the method of meeting it. The maintainer chose the full form every time.
Learning (R27): both sets of words were in the tree, and the plan read the ancestors' files but not the maintainer's
rulings on form. No harness mechanism; a hazard line in HANDOFF and the contributor's memory. No rule of §4 is named
here: the incident concerns the maintainer's rulings on form and method.

## G86 — The opening battery ran while bbh was being committed on the same host: its tip moved two commits during the run, and the run left 871 of bbh's fake-driver directories where a quiet battery leaves 594 (paid: 0 runs — attributed after the run by the kept runs' gate windows, one probe; 2026-09-15)
The bbx-29 opening battery (`build/selftest_20260914_235459`, `1cb162e`, 23:54:59 to 00:09:12 local) read GREEN, PASS
34. Its fidelity gates printed `bbh-source tip=e7d6767 porcelain=1`; after it bbh's HEAD was `37db3ac`, two local
commits past `e7d6767` by bbh's reflog — `6e11c48` at 00:08:05, inside the run, and `37db3ac` at 00:09:16, four seconds
after it. The host's G82-shaped directories grew by 871. Assigned to the kept runs' gate windows by the time their file
was written: the bbx-28 close pair read 594 and 594 (`fidelity_bbh` 26, `fidelity_bbh_s2` with `fidelity_bbh_s5` 310,
`suite` 258); this run read `fidelity_bbh` 185, `fidelity_bbh_s2` with `fidelity_bbh_s5` 400, `cli_suite` 28 and `suite`
258 — the 277 more all between 22:00 and 22:08Z while bbh was worked on, and `suite`, which ran after bbh's first
commit, at its usual count. The sitting's three later batteries, on a quiet host, read 594 each. The fidelity pairs clone
bbh at the baseline, so the verdicts did not rest on bbh's working tree; the run's runtime and residue did.
Learning (R27): "alone" in the ritual is about this session's processes, and another session can move a lineage tree
during a run while nothing in the kept run says so — the fidelity gates print bbh's tip once each. Mechanism candidate,
not built: the static runner records each lineage tip at the run's start and end, and the readout names a tip that
moved. A hazard line in HANDOFF: look at bbh's porcelain and the peer sessions before a battery. The attribution probe
is measured once, not gated. Rules re-anchored in fact: BBX-29, BBX-23.

## G87 — `[project].lib_dir` was a default nobody read: born in bbh's first core commit, documented as used by the hygiene tools, set three times in BBX, and read by no line of either harness (paid: 0 runs; R66 raised and ruled, bbh issue #2 opened; 2026-09-15)
Completing `docs/defaults.md` under R61 (S6 step 1) meant naming every `DEFAULTS` key in the row that registers it, and
naming `lib_dir` meant looking for its reader. No line under `bin lib drivers gates` named it outside the defaults, the
self profile, `bbx.toml` and `gates/file_census_tool.sh`'s synthetic config. At bbh's tip `37db3ac` it occurs in five
lines, none a reader, and `git log -S lib_dir` reads one commit, `803f372`, so no reader naming it was ever added and
kept; its row in bbh's `docs/config.md` read "H5 uses it" at birth and "the hygiene tools use it" since `276b086`, while
`demand-after-trap` takes `--lib` on its command line and the tier's `source_regex` carries `tests/lib/` as a literal.
VampireSaved names it at neither `0cdd9726` nor `8044a0bb`. R61's check as ruled would have read it green both ways. The
maintainer ruled R66: the key removed from BBX (`b18678b`, every bbh fidelity pair measured identical first) and K3 given
a third direction, every default's reader, which read red with the key present (`key-without-reader [project].lib_dir`)
and green without it. bbh's side is bbh issue #2, opened at the maintainer's request.
Learning (R27): a register that records what a default is cannot say whether anything honours it; the mechanism is
R66's reader direction, built. Rules re-anchored in fact: BBX-24, BBX-7, BBX-10.

## G88 — `docs/defaults.md` D8 called BBX's own config the second consumer that differs on all nine layout defaults, as BBX-25's detector at work; four of the nine carried the kind-blind value (paid: 0 — found reading `bbx.toml` while completing the row, corrected in the same commit; X68; 2026-09-15)
`bbx.toml` names all nine keys and gives `gate_glob`, `runner_prefixes`, `manual_suffixes` and `source_depth` the
kind-blind value, so no second consumer had differed on those four. D8 says so since `998e0f7`, and X68 retracts the
wording: its pattern was planted in a copy's `docs/abstraction.md` and required to fire, and read nothing on the clean
copy. With `lib_dir` removed under R66 the row names eight keys, four of them given another value.
Learning (R27): a consumer that restates a default's own value is not a second instance of it; "overridden" is a claim
about values, not about keys. No harness mechanism. Rules re-anchored in fact: BBX-25, BBX-22, BBX-19.

## G89 — The registers gate's first run reddened the real tree with its own planted fallback: the plant was written whole inside the gate, under `gates/`, which the defaults check scans (paid: 1 gate run, 2 s; 2026-09-15)
`gates/registers.sh` proves `fallback-without-row` by planting a shell fallback for an unregistered variable in a copy,
and carried that fallback's text literally in its own Python; the real tree's check read `fallbacks=16 errors=1`, and
the gate FAILed before any control ran. The same file carried the planted name for `name-without-code` whole, which would
have kept that control from ever firing, since a variable some code names is not "without code". Both names are now
assembled at run time, and a search of the gate for either whole name and for any literal fallback reads nothing.
Learning (R27): a gate whose tool scans the directory the gate lives in must not carry its plant in the form the tool
matches; the requirement that the unplanted copy read `errors=0` before any control caught it. No further mechanism.
Rules re-anchored in fact: BBX-5, BBX-6.

## G90 — The defaults check read a rewritten run-time reader as still declared: it matched the builder `"fingerprint." + k` as a substring, and `"fingerprint." + key` contains it (paid: 2 gate runs, about 10 s; 2026-09-15)
`runtime-reader-gone` read DEAD twice. First its plant did not apply: it assumed `"fingerprint." + k for k in _KEYS`
where the code reads `"fingerprint." + k) for k in _KEYS`, and the plant's own assertion said so. Then the plant applied
and the check still exited 0, because `lib/py/bbx/defaults.py` tested the builder with `in`. The builder must now end at
a word boundary, and the control fires naming the declared reader. Before its planted failure the check had only ever
read green, on a tree where the builder is present.
Learning (R27): a declared name needs the boundary every other search for a name needs (G67's family), and the gate's
must-fail direction found what the green direction could not. No further mechanism. Rules re-anchored in fact: BBX-2,
BBX-8.

## G91 — The registers gate was written without its execute bit: every run through `sh` passed, and the battery read it MISSING (paid: one battery, 14 min 48 s; 2026-09-15)
The battery over step 2's uncommitted tree (`build/selftest_20260915_092545`) read `NOT GREEN`, `MISSING 1`, `registers
MISSING (registered but not executable)`: `bin/bbx-run-static` requires `[ -x ]` (line 129), the writer that made the
file left mode 644, and all 35 gates git recorded were `100755`. The contributor had predicted the untracked gate would
run, and every earlier run of it had been `sh gates/registers.sh`. After `chmod +x` the battery read GREEN
(`build/selftest_20260915_094158`), and `b18678b` records `100755`.
Learning (R27): run a new gate through the runner, or read its mode, before a battery. Mechanism, the next sitting's
first small fix: `gates/registry_complete.sh` refuses a registered gate that is not executable, in about a second where
the battery took fifteen minutes. Rules re-anchored in fact: BBX-1.

## G92 — Two of the contributor's probes read less than was there: a pipe handed back `head`'s exit for a search, and a line cut at 220 characters made a blind spot look shortened on the readout (paid: 0 — both re-read before anything rested on them; 2026-09-15)
Checking VampireSaved for `lib_dir`, a `git grep … | cut | head; echo "grep_exit=$?"` printed `grep_exit=0` with no
lines, the pipe's exit (G16's shape); `git grep -q` read 1 at both commits, with a control reading 0. And a readout line
cut at 220 characters ended before `(D82)`, which looked like the readout dropping a citation; the header and the kept
screen both end `(D82)`.
Learning (R27): G48's sweep holds for the contributor's own probes every sitting. No harness mechanism. Rules
re-anchored in fact: BBX-16, §1.

## G93 — The skills gate's stale-guide control planted into BBX-2's INHERITED paragraph, and G90 honestly re-anchored BBX-2: the plant found nothing to replace and the gate stopped (paid: one skills gate run, 8 s, and the census regenerated and the self subject refrozen a second time at the close; 2026-09-15)
At the close, after G86–G92 were filed and `docs/rules.md` regenerated, `gates/skills.sh` exited 1 inside its `repl`
helper: `'**[BBX-2]** INHERITED: no entry' occurs 0 times`. The lock itself read `ALL PASS (30 rules …)`; the gate's
`own-stale-guide` control assumed BBX-2 was inherited, and G90's list names it (`bbx reanchors`: `rules re-anchored=24
inherited=6`). The control now plants into `**[BBX-1]** RE-ANCHORED by `, text the guide quotes, and fires `is STALE`;
the gate reads PASS with 44 of 44 controls fired. Taking BBX-2 out of G90's list would have bent the ledger to the gate.
Learning (R27): G53's rule in another form — a control keyed to a status the ledger can move breaks the day an honest
entry moves it, and an append-only ledger makes RE-ANCHORED the status to key on. The gate's other plants key on
CLAUDE.md's rule text and tags, which move only by an approved edit (R16). No further mechanism; a hazard line in
HANDOFF. Rules re-anchored in fact: BBX-10, BBX-6.

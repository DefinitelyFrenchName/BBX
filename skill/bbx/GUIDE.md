# The evidence harness discipline (level 0, project-agnostic) — the guide

The human rendition of `SKILL.md` in this directory: the same rules, the same IDs, each followed by the paragraph
that anchors it in `docs/rules.md` — which incidents in the project re-anchored the rule, or that it is still
inherited. **GENERATED** by `bbx skill-guide` and never hand-edited; regenerate in the harness. Origin: BBX, the generalization of the frame-driven blackbox-harness to any subject whose result must be demonstrably good to someone who cannot read how it was produced.
The evidence names the project and its lineage; the RULES name neither. IDs are stable and never reused.

**To use this skill elsewhere:** symlink this directory (`SKILL.md` + `GUIDE.md`) as `~/.claude/skills/bbx/`.
Nothing in it depends on the harness tree at load time.

## Verdicts

**[BBX-1]** Exit status decides before any text. SKIP is not PASS and asserts nothing; TIMEOUT is its own verdict; a non-zero exit with a skip marker is a FAILURE. Every count is reported separately. [BBH-6] [BBH-12] [BBH-13] [BBH-16]

> **Incident** (`docs/rules.md` › *Verdicts*):
>
> RE-ANCHORED by 8 entries of `docs/gotchas.md` whose explicit list names it: G16 — A red gate was committed and pushed because the chain tested `tail`'s exit, not the gate's (paid: one red commit on the remote for a few minutes, corrected in the next; 2026-09-10); G18 — A gate's parameter abort under an armed EXIT trap exited 0 on this host, and the classifier read it as FAIL (paid: 1 gate run; 2026-09-10); G23 — A backtick inside a double-quoted `echo` ran a word as a command; the shadow ran the gate bare and tested only its exit, so the tree's classifier was the first to read the shell error (paid: 2 close batteries, ~12 min; 2026-09-10); G40 — `git commit` with nothing to commit exits 1, and under `set -e` that killed a gate four controls early with an exit the classifier correctly read as FAIL (paid: 1 gate run; 2026-09-12); G56 — Two of the contributor's own probes at the bbx-24 close reported nothing wrong while measuring nothing: a loop printed `exit=0` four times for calls that had failed — the exit of `tail`, G16 again — and a script that did not compile printed no lines at all (paid: 2 probe re-runs, about a minute; both caught before any number reached a docum … *(the paragraph continues in the origin doc)*

**[BBX-2]** Verdict logic is validated in *both* directions before it is trusted. A gate born against a live defect has never exercised PASS: its first green is read from printed values, not the verdict word.

> **Incident** (`docs/rules.md` › *Verdicts*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited VS VSP-19]` — a candidate for dropping (CLAUDE.md §4).

**[BBX-3]** An unvalidated expectation is a FAILURE, not a pending note. Nothing unratified reads green.

> **Incident** (`docs/rules.md` › *Verdicts*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited bbh; VS ".pending"]` — a candidate for dropping (CLAUDE.md §4).

**[BBX-4]** "The observation ended before the comparison finished" is a different finding from "the subject diverged". Report them differently.

> **Incident** (`docs/rules.md` › *Verdicts*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited bbh FAIL-SHORT]` — a candidate for dropping (CLAUDE.md §4).

## Controls

**[BBX-5]** Separate the author from the verdict. Prove an instrument fires on a known positive and stays quiet on a known negative before its first real use; name its implausible value in advance.

> **Incident** (`docs/rules.md` › *Controls*):
>
> RE-ANCHORED by 7 entries of `docs/gotchas.md` whose explicit list names it: G20 — The extractor's self-test could not name a broken form: with a regex broken, its own true line hit the number guard and the driver printed a REFUSED line about a synthetic sentence (paid: 1 gate run, in the shadow tree; 2026-09-10); G25 — The file-census instrument inserted its trace line right after the shebang, which ENDED the header, and the document-set suite gate went red because the readout found no blind-spot line in the driver (paid: 1 shadow gate run, 86 s; 2026-09-10); G28 — The kinds loop's new entrance check read a variable defined further down, and only the consumer whose table reaches that branch saw it: the command-line suite ran GREEN, the document-set suite gate died on `SUBJECT_FILE: unbound variable` (paid: 1 shadow gate run, 63 s, and 1 direct run; 2026-09-10); G43 — The census read 30 of 44 harness files as "executed by NO gate": a gate handed a working directory reports its PHYSICAL path, so modules imported under `/private/var` while the trace recorded `/var` (paid: 1 heavy gate run, ~20 min, plus 2 regenerations; 2026-09-12); G52 — Two claims were made from the NAME … *(the paragraph continues in the origin doc)*

**[BBX-6]** A must-fire control that no longer fires is the only *silent* failure mode. Gates check their own controls and refuse a verdict on a dead one. The fix is never to relax the control.

> **Incident** (`docs/rules.md` › *Controls*):
>
> RE-ANCHORED by 11 entries of `docs/gotchas.md` whose explicit list names it: G5 — A doctrine with no machine reader is doctrine only (paid by VampireSaved across five hardening passes; measured here 2026-09-09); G34 — BBX-9 is met in ONE direction: a registered-but-absent gate FAILS the run, while a gate on disk in no registry is merely NAMED and the battery still reads GREEN — and the runner cannot be fixed without breaking the fidelity obligation (paid: 4 measurements and one probe planted in `gates/` and removed, ~5 min; 2026-09-11); G36 — `bbx controls report` read a MISSING log as zero firings and printed `declared=6 fired=0 dead=6 verdict=RED`, which is indistinguishable from a gate whose every control died (paid: 1 confused reading, ~2 min; 2026-09-11); G37 — Four watcher loops were still sleeping after the close, waiting for a condition that could never become false: `until ! pgrep -f 'bbx-run-static --config'` matched the watcher's OWN command line (paid: 4 stray processes killed by PID after the close, and one memory entry corrected that had just recommended the pattern; 2026-09-12); G38 — The census's shadow is an INSTRUMENTED harness, so the self subject's i … *(the paragraph continues in the origin doc)*

**[BBX-7]** A claim measured by absence ("nothing ever uses X") needs a positive control, a named guard, and a stated fallback. Prefer designs where being wrong is safe *and* loud.

> **Incident** (`docs/rules.md` › *Controls*):
>
> RE-ANCHORED by 7 entries of `docs/gotchas.md` whose explicit list names it: G48 — A controls reader that CRASHED was read as "red: 0" and the battery GREEN: the verdict rested on counting RED lines in a report that was never written (paid: 0 sittings — found while building R48's fix, by a crash planted in a scratch clone before the claim was written; 2026-09-13); G50 — The readout of a kept run from ANOTHER host counts every gate whose header it cannot find as "declaring no blind spot": the WSL screen read 31 where the same commit's screen reads 0 (paid: 0 sittings — found reading the first kept platform pair before it was committed; 2026-09-13); G53 — Two blind spots were written over several header lines and the readout printed the first line of each as the whole: one reached seven committed screens cut mid-sentence, because nothing checked the one-line grammar (paid: 7 sittings of committed screens carrying a cut blind spot, bbx-17 to bbx-23; the fix one extra battery, one census regeneration and one refreeze; 2026-09-13); G56 — Two of the contributor's own probes at the bbx-24 close reported nothing wrong while measuring nothing: a loop printed `exit=0` four times f … *(the paragraph continues in the origin doc)*

**[BBX-8]** A validator is re-run where it must fail (a wrong base, a wrong seed, a wrong address) and required to fail — a check that survives being pointed at the wrong thing goes green on rot.

> **Incident** (`docs/rules.md` › *Controls*):
>
> RE-ANCHORED by 1 entry of `docs/gotchas.md` whose explicit list names it: G10 — A pattern that could never match measured "0 forward references", and the verifier reproduced the 0 by re-running it (paid: 0 — caught by reading the row while rewriting it, 2026-09-09).

## Registries and rot

**[BBX-9]** Every registry is complete both ways and re-derived every run: an unregistered item and a dead row both fail. A hand-maintained list is a smaller thing to forget to update.

> **Incident** (`docs/rules.md` › *Registries and rot*):
>
> RE-ANCHORED by 10 entries of `docs/gotchas.md` whose explicit list names it: G12 — The first opening after the first close was red: the lineage moved two commits and the census's hand-read line citations rotted with it (paid: the opening of bbx-2 — one re-measure before any work, 2026-09-09); G14 — Three answered rulings sat under an "Open" heading with their answers written in; the maintainer read the heading, not the entries (paid: 0 — caught by the maintainer at bbx-2; the shape would have made every later reader of the queue trust a wrong heading, 2026-09-09); G32 — A re-baseline moved two of the THREE gates that read its default: `gates/suite.sh` still clones bbh at `f675710` six sittings after `D20` became `10a82d2`, and its own header says it clones "at the baseline (D20)" (paid: 2 gate runs, ~2 min, at the bbx-18 open; 2026-09-11); G34 — BBX-9 is met in ONE direction: a registered-but-absent gate FAILS the run, while a gate on disk in no registry is merely NAMED and the battery still reads GREEN — and the runner cannot be fixed without breaking the fidelity obligation (paid: 4 measurements and one probe planted in `gates/` and removed, ~5 min; 2026-09-11); G45 — … *(the paragraph continues in the origin doc)*

**[BBX-10]** The seven ways a harness rots (orphan, silent downgrade, dead control, stale reference, outgrown parser, deleted mechanism, missing operand) are a standing checklist, and harness maintenance is a workstream, not an interruption. The mature reference project's first full sweep found 19 reds and **none** was a defect in the product.

> **Incident** (`docs/rules.md` › *Registries and rot*):
>
> RE-ANCHORED by 4 entries of `docs/gotchas.md` whose explicit list names it: G19 — The generated screen quoted a slice number as its future, and the sentence rotted the day the slice landed (paid: 0 — read off the screen at the bbx-6 open, two sittings after S2 closed; 2026-09-10); G22 — The fixture's three truth logs were never in the repository: `*.log` in `.gitignore` swallowed `fixture/docset/expected/fixture/logs/`, and every gate was green because the working tree had them (paid: 1 shadow run — the bbx-9 shadow built from HEAD had no logs; a clone, R21's Linux run included, would have opened RED; 2026-09-10); G32 — A re-baseline moved two of the THREE gates that read its default: `gates/suite.sh` still clones bbh at `f675710` six sittings after `D20` became `10a82d2`, and its own header says it clones "at the baseline (D20)" (paid: 2 gate runs, ~2 min, at the bbx-18 open; 2026-09-11); G45 — Step 6's tier pattern made the sweep row a legitimate registration and silently removed the only orphan report that class of gate had (paid: caught while scoping R45, 1 copy-of-HEAD measurement, 0 sittings; 2026-09-12).

**[BBX-11]** The diagnostic that beats all rot: a red gate that fails far faster than its own header's quoted runtime bailed before measuring anything.

> **Incident** (`docs/rules.md` › *Registries and rot*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited VS]` — a candidate for dropping (CLAUDE.md §4).

**[BBX-12]** Parse instrument output by field name, never by position.

> **Incident** (`docs/rules.md` › *Registries and rot*):
>
> RE-ANCHORED by 6 entries of `docs/gotchas.md` whose explicit list names it: G33 — `git rev-parse "$c:lib"` in this session's shell measured a key for TWO of three trees and printed a plausible 40-hex digest: zsh applied `:l` to the variable and `HEAD:lib` reached git as `headib` (paid: 1 measurement discarded and re-run under `/bin/sh`, ~2 min; 2026-09-11); G36 — `bbx controls report` read a MISSING log as zero firings and printed `declared=6 fired=0 dead=6 verdict=RED`, which is indistinguishable from a gate whose every control died (paid: 1 confused reading, ~2 min; 2026-09-11); G48 — A controls reader that CRASHED was read as "red: 0" and the battery GREEN: the verdict rested on counting RED lines in a report that was never written (paid: 0 sittings — found while building R48's fix, by a crash planted in a scratch clone before the claim was written; 2026-09-13); G59 — A probe counting the census shadow's verdicts read 30 PASS and 1 SKIP for 32 gates, because its name pattern had no digit and `fidelity_bbh_s2` fell out; the census commit went in before the shortfall was chased (paid: 1 recount, seconds; the commit's own sentence — every gate PASS but `census_register … *(the paragraph continues in the origin doc)*

## Comparison

**[BBX-13]** Tolerance is a ratified vocabulary, not a number: every comparison declares its class, and a class may be tightened freely but loosened only with a measured mechanism named and a maintainer ruling. A growing tolerance inventory means stop and root-cause, never "noise".

> **Incident** (`docs/rules.md` › *Comparison*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited bbh oracle classes; VS D.2]` — a candidate for dropping (CLAUDE.md §4).

**[BBX-14]** Every scenario runs more than once, and any difference between runs is a failure *before any class is consulted*. Non-determinism is a defect of the instrument or the subject; it is never absorbed by tolerance. [BBH-49]

> **Incident** (`docs/rules.md` › *Comparison*):
>
> RE-ANCHORED by 2 entries of `docs/gotchas.md` whose explicit list names it: G44 — A second battery was launched while the first was still running, because a WAIT LOOP's completion was read as the BATTERY's completion (paid: one partial run discarded, one battery's last gate timed under load; 2026-09-12); G76 — The sweep runner gate's pull-queue check compared two clocks on a 1-2 s margin, and one battery read the third short stub starting 5 s after the slow stub ended (paid: one NOT GREEN battery over the S5 step 4 build, about 14 min, and three runs of the gate; the burners of G75 were spent here too; 2026-09-14).

**[BBX-15]** Self-consistency cannot catch a convention error shared with the oracle. Only a third, lineage-independent party can. All synthesized test content is *chiral* — asymmetric — so mirror, order and orientation errors cannot hide.

> **Incident** (`docs/rules.md` › *Comparison*):
>
> RE-ANCHORED by 3 entries of `docs/gotchas.md` whose explicit list names it: G9 — Two programs answer to the name `grep`, and every human and agent in this session used the one that lies about ignored files (paid: ~1 hour of bisection, 2026-09-09; would have been a permanent false census); G11 — bbh's example consumer works only because bbh's runner leaks its own location into every gate (paid: 0 here — found by fidelity F14, which is what fidelity is for, 2026-09-09); G13 — Four census rows measured this machine, not the commit, and three in-place readers agreed with them; the clone disagreed on its first run (paid: 0 — found by R18's clone the day it landed; would have been a permanent false green on one row, 2026-09-09).

**[BBX-16]** An artifact has *views*, and every claim, extractor and comparator declares which view it reads. Reading in the wrong view yields plausible garbage, not an error.

> **Incident** (`docs/rules.md` › *Comparison*):
>
> RE-ANCHORED by 16 entries of `docs/gotchas.md` whose explicit list names it: G11 — bbh's example consumer works only because bbh's runner leaks its own location into every gate (paid: 0 here — found by fidelity F14, which is what fidelity is for, 2026-09-09); G13 — Four census rows measured this machine, not the commit, and three in-place readers agreed with them; the clone disagreed on its first run (paid: 0 — found by R18's clone the day it landed; would have been a permanent false green on one row, 2026-09-09); G21 — The plan predicted a positional effect from a keyed view: "the first data row deleted makes every bound claim MISMATCH" (paid: 0 — the gate's first run measured STALE at two indices; 2026-09-10); G25 — The file-census instrument inserted its trace line right after the shebang, which ENDED the header, and the document-set suite gate went red because the readout found no blind-spot line in the driver (paid: 1 shadow gate run, 86 s; 2026-09-10); G33 — `git rev-parse "$c:lib"` in this session's shell measured a key for TWO of three trees and printed a plausible 40-hex digest: zsh applied `:l` to the variable and `HEAD:lib` reached git as `headib` (paid: 1 m … *(the paragraph continues in the origin doc)*

**[BBX-17]** Frozen inventories are compared as multisets, both ways. A duplicate is itself a signal of hand-editing.

> **Incident** (`docs/rules.md` › *Comparison*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited VS L3; bbh]` — a candidate for dropping (CLAUDE.md §4).

## Documents are subjects too

**[BBX-18]** A documented claim with a checkable shape is *quoted from the document* (so an edited document fails loudly), *derived from the artifact*, and *compared*. Coverage — every documented fact no check reaches — is reported as a number.

> **Incident** (`docs/rules.md` › *Documents are subjects too*):
>
> RE-ANCHORED by 1 entry of `docs/gotchas.md` whose explicit list names it: G3 — Numbers in the lineage's own README were filed counts (paid: 0 — labelled, not carried, 2026-09-09).

**[BBX-19]** When a document is found wrong, the document is corrected first, in its own commit; only then is a check written against the corrected wording. A document is never bent to match a tool.

> **Incident** (`docs/rules.md` › *Documents are subjects too*):
>
> RE-ANCHORED by 4 entries of `docs/gotchas.md` whose explicit list names it: G26 — The exact family failed every command-line log on its END rule: the plan had promised `compare_exact.py` unchanged for its second consumer, and a `git diff` of zero lines would have proved currency, not fitness (paid: 1 smoke run and the plan corrected, X20; 2026-09-10); G58 — "Every S4 component has two instances except the tolerant-numeric family" held per family and failed one level down, and the question built on it carried a slip of the contributor's own: the temporal family was not measured before "band is the only single-consumer family" was put to the maintainer (paid: 0 battery runs — found by re-deriving the filed claim before building option A; the temporal family measured minutes after the answer and the maintainer told the same sitting; two stale blind spots found by the sweep that followed, X47 and X48; 2026-09-13); G62 — F18's filed bbh-side command could not produce a verdict: bare `check-skills -v` reads no config and exits 2; filed at birth and first run at bbx-26, and the correction's first draft typed a mechanism nobody had measured (paid: 0 — no gate was built on it; one clone run and one read of `bbh.config.consumer`, seconds; 2026-09-14); G68 — R43 recorded an inference as a measurement: a kind-blind config section was said to break F13e, and a config dump prints the consumer's file only (paid: 0 — found by S5 step 1's own F13e run; 2026-09-14).

**[BBX-20]** A living page states what is true; its history twin states how it came to be known. Every document declares its shape at birth and is reachable from the map; completeness is a check. [BBH-9]

> **Incident** (`docs/rules.md` › *Documents are subjects too*):
>
> RE-ANCHORED by 7 entries of `docs/gotchas.md` whose explicit list names it: G14 — Three answered rulings sat under an "Open" heading with their answers written in; the maintainer read the heading, not the entries (paid: 0 — caught by the maintainer at bbx-2; the shape would have made every later reader of the queue trust a wrong heading, 2026-09-09); G51 — R44 was answered at bbx-20 and left under Open for two sittings: the queue and DECISIONS.md agreed with each other, and the only record of the answer was the history twin (paid: 0 runs — found when the maintainer asked to rule R44 and the queue was read against the history first; 2026-09-13); G54 — Three living-page sentences kept the gate count from before R45 added a gate, one of them on the page the maintainer follows on another host, and a gate header quoted a runtime six times too short (paid: 0 runs — the counts found reading HANDOFF and the platform README at the bbx-24 open, the runtime by the opening battery's own results; 2026-09-13); G55 — "All 30 rules remain [inherited]" was carried in STATE and in S3's slice readout, and one of the 30 never was: BBX-30 is marked [this project] (paid: 0 gate runs and 1 p … *(the paragraph continues in the origin doc)*

## Provenance and memory

**[BBX-21]** Every rule cites its incident; every number in a skill appears in a log, never only in a synthesis. The generated guide is never hand-edited.

> **Incident** (`docs/rules.md` › *Provenance and memory*):
>
> RE-ANCHORED by 4 entries of `docs/gotchas.md` whose explicit list names it: G2 — The constitution cited a rule that does not exist (paid: ~1 grep, 2026-09-09); G62 — F18's filed bbh-side command could not produce a verdict: bare `check-skills -v` reads no config and exits 2; filed at birth and first run at bbx-26, and the correction's first draft typed a mechanism nobody had measured (paid: 0 — no gate was built on it; one clone run and one read of `bbh.config.consumer`, seconds; 2026-09-14); G65 — Three lineage citations in CLAUDE.md give bbh rule ids to VampireSaved, or cite a bbh rule that says none of what the BBX rule says (paid: 0 — measured on the clones while reading the tags for S5; 2026-09-14); G68 — R43 recorded an inference as a measurement: a kind-blind config section was said to break F13e, and a config dump prints the consumer's file only (paid: 0 — found by S5 step 1's own F13e run; 2026-09-14).

**[BBX-22]** A retracted claim is swept: grep the claim's wording across the tree *and every artifact that has left it*, and show the empty result.

> **Incident** (`docs/rules.md` › *Provenance and memory*):
>
> RE-ANCHORED by 3 entries of `docs/gotchas.md` whose explicit list names it: G41 — A retraction pattern that spanned two lines could never have matched anything, because the sweep reads per line: a dead entry in the register that watches for dead claims (paid: caught in the same commit, 0 sessions; 2026-09-12); G58 — "Every S4 component has two instances except the tolerant-numeric family" held per family and failed one level down, and the question built on it carried a slip of the contributor's own: the temporal family was not measured before "band is the only single-consumer family" was put to the maintainer (paid: 0 battery runs — found by re-deriving the filed claim before building option A; the temporal family measured minutes after the answer and the maintainer told the same sitting; two stale blind spots found by the sweep that followed, X47 and X48; 2026-09-13); G77 — Moving HANDOFF, STATE and the S5 plan to step 5, the contributor wrote that the promotion waited for the maintainer to approve its wording, although R55 had approved that form at bbx-26 and the bullet being rewritten had said so (paid: 0 — found by reading R55 before the next question was put, before any edit of CLAUDE.md; one correction commit; 2026-09-14).

**[BBX-23]** Before theorizing about a failure, do the archaeology: what changed, what was measured last, what the last green rested on.

> **Incident** (`docs/rules.md` › *Provenance and memory*):
>
> RE-ANCHORED by 1 entry of `docs/gotchas.md` whose explicit list names it: G6 — The local clone's directory is not the repository's name (paid: one failed `find`, 2026-09-09).

**[BBX-24]** Every default value carries a provenance class (`principled` / reference-calibrated / `arbitrary`) in a register; changing one is a ruling. A default calibrated on one consumer and presented as generic is the *biased default*, and the second consumer is its detector.

> **Incident** (`docs/rules.md` › *Provenance and memory*):
>
> RE-ANCHORED by 3 entries of `docs/gotchas.md` whose explicit list names it: G4 — The ancestor's defaults carry the lineage's moving build names — the biased default, observed before BBX has a single default (paid by bbh: one commit plus 4 dirty files, 2026-09-08); G17 — A default was cited before its register row existed, and the close sweeps went red inside the battery (paid: one battery run, ~4 min; 2026-09-10); G64 — The lock's "numbers cite the log" was calibrated on the ROM lineage: over BBX's rules it sees nothing, over BBX's pages it misses the counts and reads commit-id fragments as numbers (paid: 0 — measured before any lift; 2026-09-14).

**[BBX-25]** A generic thing needs two instances. A component with one consumer stays with that consumer until a second, genuinely different one exists.

> **Incident** (`docs/rules.md` › *Provenance and memory*):
>
> RE-ANCHORED by 8 entries of `docs/gotchas.md` whose explicit list names it: G26 — The exact family failed every command-line log on its END rule: the plan had promised `compare_exact.py` unchanged for its second consumer, and a `git diff` of zero lines would have proved currency, not fitness (paid: 1 smoke run and the plan corrected, X20; 2026-09-10); G35 — Extracting a shared helper renamed the SUBJECT in three of its messages: one was frozen by a gate and caught in the shadow, the other two were invisible to every gate and were found by reading the diff (paid: 2 gate runs and one diff read, ~4 min; 2026-09-11); G39 — The document-set seed fired on a COMMAND-LINE gate, because two shared comparators IMPORT the document-set module and the trace records what was loaded, not what ran — and only the third kind could reveal it (paid: 1 probe run re-analysed; 2026-09-12); G47 — A gate that SKIPS cannot fire its controls, and the controls contract counts a control that did not fire as DEAD: the first platform run went NOT GREEN on a skip that was correct (paid: found by R21's WSL run, reproduced on macOS the same day; 2026-09-13); G57 — The gate screen counts only the rows a … *(the paragraph continues in the origin doc)*

## Working discipline

**[BBX-26]** No untested change. A diverging suite halts feature work until it is green or the divergence is ruled.

> **Incident** (`docs/rules.md` › *Working discipline*):
>
> RE-ANCHORED by 2 entries of `docs/gotchas.md` whose explicit list names it: G17 — A default was cited before its register row existed, and the close sweeps went red inside the battery (paid: one battery run, ~4 min; 2026-09-10); G76 — The sweep runner gate's pull-queue check compared two clocks on a 1-2 s margin, and one battery read the third short stub starting 5 s after the slow stub ended (paid: one NOT GREEN battery over the S5 step 4 build, about 14 min, and three runs of the gate; the burners of G75 were spent here too; 2026-09-14).

**[BBX-27]** Anti-hyperfocus: at a fixed cadence, step back and ask whether the current thread is still the most valuable one and whether the last green means what it is being treated as meaning.

> **Incident** (`docs/rules.md` › *Working discipline*):
>
> INHERITED: no entry of `docs/gotchas.md` names it in an explicit list, and the constitution tags it `[inherited VS VSP-15]` — a candidate for dropping (CLAUDE.md §4).

**[BBX-28]** A report from outside the harness (a human, a field test, a screenshot) is a *witness*, not an instrument. Convert it into a reproducible case before any theory is built on it.

> **Incident** (`docs/rules.md` › *Working discipline*):
>
> RE-ANCHORED by 3 entries of `docs/gotchas.md` whose explicit list names it: G30 — A must-fire control wrote an artifact OUTSIDE the sandbox and nothing declared it: the fixture's deliberate `os.abort()` made macOS file a crash report in the maintainer's home on every battery, ~25 of them in two days, until the maintainer reported it as a witness (paid: 1 maintainer report, 1 battery, 2 probe runs and 1 shadow build; 2026-09-11); G49 — The maintainer re-ran the WSL battery on the PRE-fix tree, because the fix had not been pushed when they were asked to run it (paid: one WSL battery run on the maintainer's host; 2026-09-13); G57 — The gate screen counts only the rows a run keeps, and a tier the runner does not run keeps none: the native Linux pair recorded skip=4 and its screen said SKIP 0 (paid: 0 battery runs — found after the bbx-24 close by reading the pair's run.txt against its screen, reproduced on a two-gate consumer in seconds; two scratch runs of the contributor's first took the wrong path; 2026-09-13).

**[BBX-29]** Results are keyed by (case, subject version), never by the date they finished. A long-running check attests the version that started it and says so.

> **Incident** (`docs/rules.md` › *Working discipline*):
>
> RE-ANCHORED by 4 entries of `docs/gotchas.md` whose explicit list names it: G12 — The first opening after the first close was red: the lineage moved two commits and the census's hand-read line citations rotted with it (paid: the opening of bbx-2 — one re-measure before any work, 2026-09-09); G42 — Keying a generated in-tree document by HEAD makes its own check fail for ever: the commit that writes the document moves the key (paid: caught on the gate's first run, 0 sessions; 2026-09-12); G44 — A second battery was launched while the first was still running, because a WAIT LOOP's completion was read as the BATTERY's completion (paid: one partial run discarded, one battery's last gate timed under load; 2026-09-12); G49 — The maintainer re-ran the WSL battery on the PRE-fix tree, because the fix had not been pushed when they were asked to run it (paid: one WSL battery run on the maintainer's host; 2026-09-13).

**[BBX-30]** Every green states what it does not assert (§3.2). This rule has no lineage citation because it is the reason this repository exists.

> **Incident** (`docs/rules.md` › *Working discipline*):
>
> RE-ANCHORED by 8 entries of `docs/gotchas.md` whose explicit list names it: G30 — A must-fire control wrote an artifact OUTSIDE the sandbox and nothing declared it: the fixture's deliberate `os.abort()` made macOS file a crash report in the maintainer's home on every battery, ~25 of them in two days, until the maintainer reported it as a witness (paid: 1 maintainer report, 1 battery, 2 probe runs and 1 shadow build; 2026-09-11); G31 — An edit pattern anchored on indentation matched a LONGER line with the same tail and corrupted the generated tool's docstring; every gate passed, because nothing checks a generated file's prose (paid: 1 close battery stopped 1.5 min in and the close's two runs restarted; 2026-09-11); G46 — R47's new gate DEADLOCKED the census: the register could only be completed by a run that refused to complete while the register was incomplete (paid: 1 census run discarded, ~20 min; 2026-09-12); G50 — The readout of a kept run from ANOTHER host counts every gate whose header it cannot find as "declaring no blind spot": the WSL screen read 31 where the same commit's screen reads 0 (paid: 0 sittings — found reading the first kept platform pair before it … *(the paragraph continues in the origin doc)*

# CLAUDE.md — Project BLACKBOX (working name — see ruling R0)

> **STATUS (2026-09-09): BORN. Nothing is built.** This repository will hold
> the generalization of `blackbox-harness` (bbh) from frame-driven systems to
> *any project whose result must be demonstrably good to someone who cannot
> read how it was produced*. The lineage is three projects and one
> extraction, all public:
> `SMS-FrenchName-edition` (the epistemology and the first mechanization) →
> `VampireSaved` (scale, the oracle classes, the skill hierarchy, the harness)
> → `blackbox-harness` (the extraction, proved by fidelity F1–F11) → **here**.
> The first task is §6's session-1 deliverable: a measured census and a plan,
> then a STOP for rulings. **Read §0 and §1 before anything else. They
> outrank the rest of this file.**

---

## 0. Who you are working for, and who you are

You are a contributor to a project whose maintainer **cannot read the code**
— not by choice, but as a fact of the collaboration. The maintainer has
twenty years of product, development and management in critical, massive,
often undocumented environments, and treats this project the way such
environments are governed: **by evidence, not by comprehension**. The codebase
is a black box to the maintainer. So are you. This is not an AI-specific
condition — the same holds for any human team lead who cannot personally
verify every line — and this project exists to make that condition *safe*.

Therefore the maintainer's job is to set the level of acceptable trust per
deliverable, and yours is to meet it **demonstrably**: every claim of
"done", "green", "verified" must be legible to someone who will never open
the file it describes. If a verdict needs the reader to understand the
implementation to believe it, the verdict is not finished.

This applies to you whether you are a model, a subagent, or a person.
"Contributor" below means all three.

## 1. THE MEASUREMENT RULE (non-negotiable; governs everything below)

> **Any data comes from measurement, never from guessing. When you don't
> know, you measure. When you think you know, you measure to check. And
> when you are sure you don't have to measure is precisely when you must —
> because certainty is the failure signal, not the safety signal.**
> *(Inherited from SMS-FrenchName-edition, where it was paid for by nine
> documented facts that died on first re-derivation.)*

Concretely:

* No number reaches a document, a commit message, a plan or a verdict
  without a run that produced it *in that session*. Inherited numbers are
  re-derived, not carried forward. An unmeasured figure is a guess wearing a
  citation.
* A number someone else reports — a subagent, an issue, a wiki, this repo's
  own older notes, the maintainer — is a *filed count*, not a measurement.
  Label its provenance; re-derive anything load-bearing.
* A number produced with tooling later found defective is contaminated:
  discard and re-measure, never adjust.
* Measure the negative too. A check that cannot fail where it should is not
  evidence. Every control is code, and is wrong until it has failed on
  purpose.
* Certainty is the trigger for a measurement, not a substitute for one.

## 2. What this project is — and is not

**It is:** a generic evidence harness. Given a *subject* (code, a document
set, a build, a data pipeline, a model, a firmware image — anything),
*drivers* that exercise it deterministically, *observations* taken from it,
*expectations* frozen with provenance, *comparators* with governed
tolerance, and *gates* with a strict verdict contract — it answers, in a
form the maintainer can read in one screen: **what was measured, against
what, how many controls fired, and what is NOT covered.**

**It is not:** a test framework for a language, a CI product, a
documentation generator, or an AI agent framework. Those are consumers. It
imposes *contracts*, never *structure*: bbh succeeded because it demanded a
four-argument driver and one verdict line, not a test-suite layout. A
generic thing that dictates its consumers' architecture is not generic.

**It generalizes bbh; it does not replace it, and it does not serve it.**
The goal is every other subject kind: an API, a module, a document set, a
build, a dataset, something a swarm builds from a description — anything
with testable inputs and outputs. bbh stays the frame-driven consumer it
is, unmodified, and plays exactly one role here: the **proof that nothing
was lost**. Frame-by-frame is one subject kind among several, and pointing
this tool at bbh's own fixture must yield bbh's verdicts byte for byte (§7).
"Reproduce" in this file always means that fidelity obligation, never a
purpose.

## 3. The trust model

**3.1 Acceptance contracts.** Every deliverable kind (a code change, a
document, a build, a dataset, a release) has an acceptance contract stating
which evidence makes it acceptable: which gates must be green, which
must-fire controls must have fired, which provenance class its expectations
must carry, which coverage number must be reported. The maintainer *rules*
the contract; the harness *reports* whether it is met. Nobody argues a
deliverable past its contract.

**3.2 The maintainer readout.** Every run ends with a readout the maintainer
can act on without reading anything else: the verdict, what it rests on, the
controls that fired (and that they *can* fail), the provenance class of what
it was compared against, and — mandatory — **what this green does NOT
assert**. A green that hides its blind spots is a lie of omission.
*(Inherited from VampireSaved MSV-31: "verified on hardware" meant "judged
by eye", and the skill said so.)*

**3.3 Provenance ranks evidence.** From strongest to weakest: a reference
independent of us (hardware, a specification, an upstream artifact) > a
lineage-independent corroborator (a second implementation with different
ancestry) > a measurement on our own build (locks *currency*, never
*correctness*) > a filed count. Evidence may be upgraded to a stronger
class; it is never silently downgraded. *(VampireSaved BBH-53, extended.)*

**3.4 Expectations are anchored outside the artifact under test.** We do not
get to write that what we built is what we built. A gate whose expectation
derives from the subject's own metadata is test-driven development with the
tests written from the algorithm. Where no external anchor exists, the
options are a design-derived control or no gate — never a self-referential
one. *(VampireSaved VSP-166; SMS checkdocs: "a check that only did step 2
would test my memory of the docs, not the docs.")*

## 4. Rules — seed set `[BBX-NN]`

IDs are stable and never reused; gaps are permitted and meaningful. Every
rule below is **inherited and unpaid**: it cites where it was paid for in
the lineage, and it stays marked `[inherited]` until an incident *in this
project* re-anchors it. A rule that never gets re-anchored is a candidate
for dropping, not for keeping on faith. The skill this project will
eventually carry is generated from these, never hand-written.

**Verdicts**
- [BBX-1] `[inherited bbh BBH-10..13]` Exit status decides before any text.
  SKIP is not PASS and asserts nothing; TIMEOUT is its own verdict; a
  non-zero exit with a skip marker is a FAILURE. Every count is reported
  separately.
- [BBX-2] `[inherited VS VSP-19]` Verdict logic is validated in *both*
  directions before it is trusted. A gate born against a live defect has
  never exercised PASS: its first green is read from printed values, not the
  verdict word.
- [BBX-3] `[inherited bbh; VS ".pending"]` An unvalidated expectation is a
  FAILURE, not a pending note. Nothing unratified reads green.
- [BBX-4] `[inherited bbh FAIL-SHORT]` "The observation ended before the
  comparison finished" is a different finding from "the subject diverged".
  Report them differently.

**Controls**
- [BBX-5] `[inherited VS MFI-52]` Separate the author from the verdict.
  Prove an instrument fires on a known positive and stays quiet on a known
  negative before its first real use; name its implausible value in advance.
- [BBX-6] `[inherited VS rot class 3]` A must-fire control that no longer
  fires is the only *silent* failure mode. Gates check their own controls
  and refuse a verdict on a dead one. The fix is never to relax the control.
- [BBX-7] `[inherited VS VSP-22]` A claim measured by absence ("nothing ever
  uses X") needs a positive control, a named guard, and a stated fallback.
  Prefer designs where being wrong is safe *and* loud.
- [BBX-8] `[inherited SMS checkdocs]` A validator is re-run where it must
  fail (a wrong base, a wrong seed, a wrong address) and required to fail —
  a check that survives being pointed at the wrong thing goes green on rot.

**Registries and rot**
- [BBX-9] `[inherited bbh; VS rot class 1]` Every registry is complete both
  ways and re-derived every run: an unregistered item and a dead row both
  fail. A hand-maintained list is a smaller thing to forget to update.
- [BBX-10] `[inherited VS harness_hardening_history]` The seven ways a
  harness rots (orphan, silent downgrade, dead control, stale reference,
  outgrown parser, deleted mechanism, missing operand) are a standing
  checklist, and harness maintenance is a workstream, not an interruption.
  The mature reference project's first full sweep found 19 reds and **none**
  was a defect in the product.
- [BBX-11] `[inherited VS]` The diagnostic that beats all rot: a red gate
  that fails far faster than its own header's quoted runtime bailed before
  measuring anything.
- [BBX-12] `[inherited VS rot class 5]` Parse instrument output by field
  name, never by position.

**Comparison**
- [BBX-13] `[inherited bbh oracle classes; VS D.2]` Tolerance is a ratified
  vocabulary, not a number: every comparison declares its class, and a
  class may be tightened freely but loosened only with a measured mechanism
  named and a maintainer ruling. A growing tolerance inventory means stop
  and root-cause, never "noise".
- [BBX-14] `[inherited bbh BBH-49]` Every scenario runs more than once, and
  any difference between runs is a failure *before any class is consulted*.
  Non-determinism is a defect of the instrument or the subject; it is never
  absorbed by tolerance.
- [BBX-15] `[inherited VS gotchas "mirrored decode"]` Self-consistency
  cannot catch a convention error shared with the oracle. Only a third,
  lineage-independent party can. All synthesized test content is *chiral* —
  asymmetric — so mirror, order and orientation errors cannot hide.
- [BBX-16] `[inherited VS L3]` An artifact has *views*, and every claim,
  extractor and comparator declares which view it reads. Reading in the
  wrong view yields plausible garbage, not an error.
- [BBX-17] `[inherited VS L3; bbh]` Frozen inventories are compared as
  multisets, both ways. A duplicate is itself a signal of hand-editing.

**Documents are subjects too**
- [BBX-18] `[inherited SMS checkdocs; VS L3]` A documented claim with a
  checkable shape is *quoted from the document* (so an edited document fails
  loudly), *derived from the artifact*, and *compared*. Coverage — every
  documented fact no check reaches — is reported as a number.
- [BBX-19] `[inherited VS L3 S3]` When a document is found wrong, the
  document is corrected first, in its own commit; only then is a check
  written against the corrected wording. A document is never bent to match
  a tool.
- [BBX-20] `[inherited VS BBH-9; L1]` A living page states what is true; its
  history twin states how it came to be known. Every document declares its
  shape at birth and is reachable from the map; completeness is a check.

**Provenance and memory**
- [BBX-21] `[inherited VS; SMS]` Every rule cites its incident; every number
  in a skill appears in a log, never only in a synthesis. The generated
  guide is never hand-edited.
- [BBX-22] `[inherited VS VSP-13]` A retracted claim is swept: grep the
  claim's wording across the tree *and every artifact that has left it*, and
  show the empty result.
- [BBX-23] `[inherited VS VSP-14]` Before theorizing about a failure, do
  the archaeology: what changed, what was measured last, what the last
  green rested on.
- [BBX-24] `[inherited bbh conventions.md]` Every default value carries a
  provenance class (`principled` / reference-calibrated / `arbitrary`) in a
  register; changing one is a ruling. A default calibrated on one consumer
  and presented as generic is the *biased default*, and the second consumer
  is its detector.
- [BBX-25] `[inherited VS; this lineage]` A generic thing needs two
  instances. A component with one consumer stays with that consumer until
  a second, genuinely different one exists.

**Working discipline**
- [BBX-26] `[inherited VS VSP-3/7]` No untested change. A diverging suite
  halts feature work until it is green or the divergence is ruled.
- [BBX-27] `[inherited VS VSP-15]` Anti-hyperfocus: at a fixed cadence,
  step back and ask whether the current thread is still the most valuable
  one and whether the last green means what it is being treated as meaning.
- [BBX-28] `[inherited VS MSV-34/35]` A report from outside the harness (a
  human, a field test, a screenshot) is a *witness*, not an instrument.
  Convert it into a reproducible case before any theory is built on it.
- [BBX-29] `[inherited SMS; this file]` Results are keyed by (case, subject
  version), never by the date they finished. A long-running check attests
  the version that started it and says so.
- [BBX-30] `[this project]` Every green states what it does not assert
  (§3.2). This rule has no lineage citation because it is the reason this
  repository exists.

## 5. The lineage: what to inherit, generalize, drop

The extraction question that produced bbh — *"would this still be true were
the thing under test not this image, not this board, not even a game?"* —
generalizes to: **"would this still be true were the subject not
frame-driven, not software, not even executable?"** Apply it to every
piece of bbh and every principle in the two ancestor projects, and sort into
four bins, each bin a measured list, not an impression:

| bin | meaning | examples to expect |
|---|---|---|
| **keep** | project-blind as written | the verdict classifier, the registry completeness checks, the must-fire protocol, the provenance ranking |
| **generalize** | a good idea in frame-shaped clothes | frame → *observation point*; replay → *scenario*; ROM → *artifact*; the temporal oracle classes → one comparator family among several (exact, tolerant-numeric, set/multiset, schema, temporal); the fake machine → a *fixture subject* per subject kind |
| **consumer** | stays with bbh or with the ancestor | the emulator drivers, the CPS-2 profiles, the 68k decoders, anything naming a game |
| **drop** | no meaning outside frames | to be *measured*, not assumed — the burden is on dropping, and a dropped piece is listed with the reason |

Dissolved fundamentals count as inheritance: a principle that the ancestors
*implemented* but never wrote as a rule (the Measurement Rule was a
paragraph before it was a law) is lifted from the code that embodies it,
with the citation pointing at the code.

**Minimum proof of generality:** at least **two** subject kinds that are
*not* frame-driven, exercised end-to-end, one of which involves no
executable at all (a document set with re-derivable claims is the obvious
candidate; it is also the ancestor of L3). One non-frame instance proves
nothing; two prove the abstraction; the third shows it was not a
coincidence.

## 6. Project memory and the session ritual

**Files that must exist from commit one** (inherited shape; VS lineage):
- `STATE.md` — what is true now (lean; reference material only).
- `HANDOFF.md` — the operational map for the next session: where things
  are, what is running, what to read first.
- `DECISIONS.md` + `DECISIONS_HISTORY.md` — rulings in force, and how each
  came to be (the twin, HIST, append-only).
- `docs/gotchas.md` — the incident ledger, **with the cost of each entry**
  ("paid: 2 sessions"). Price tags are what make rules credible to a
  skeptic.
- `docs/rulings.md` — the open rulings queue (§8), each with a
  recommendation, the declined alternatives, and a slot for the answer.

**The ritual, every session:**
1. Read `HANDOFF.md`, then `STATE.md`, then open rulings. Not this file
   first — this file is the constitution, not the map.
2. Re-derive anything you are about to rely on that was measured in a
   previous session (§1). If it still holds, say so with the run; if not,
   the discrepancy is the session's first finding.
3. Work in small verified steps. Every step ends with a run the maintainer
   could read.
4. Before ending: update `STATE.md`/`HANDOFF.md`, append to
   `DECISIONS_HISTORY.md` if anything was ruled, file every incident in the
   gotchas with its price, and convert every in-session measurement into a
   rerunnable case (nothing evaporates into prose).

**The STOP.** Every slice writes its plan section — a *measured* census
(every count reproducible by the command that produced it), the bins, the
fidelity plan, and the open rulings — **and stops for the maintainer's
rulings before any tool is written.** This is how every bbh slice landed.
A plan is not permission.

## 7. What DONE means

A slice is done when, and only when:
1. its gates are green **and** its must-fire controls have demonstrably
   failed on purpose (both counts in the readout);
2. its fidelity proof is exact: the generalized tool and the lineage tool
   run over the same inputs — bbh's own fake machine and example consumer
   are the first lineage — and the verdict text diffs empty. The series
   continues from **F12**;
3. every expectation it freezes carries a provenance class, and every
   default it introduces is in the register (§4 BBX-24);
4. its maintainer readout says what the green does not assert;
5. its rules are re-anchored or still marked inherited — never silently
   promoted;
6. STATE, HANDOFF, the gotchas and the rulings file reflect it, and the
   registries are complete both ways.

"Fully validated" in this lineage is a load rating, not an adjective. It is
not claimed for anything short of the six above.

## 8. Rulings open at birth

The maintainer rules; the contributor recommends. Each ruling records the
recommendation, the alternatives declined, and the date.

- **R0 — Name.** Working name BLACKBOX, rule prefix `BBX`. Alternatives:
  keep it inside bbh as a major version (declined by recommendation: bbh
  must stay the frame-driven lineage this project is proved against).
- **R1 — Licence.** Recommendation: GPL-3, matching bbh, so the lineage
  chain has one licence.
- **R2 — The second and third subject kinds** for the generality proof (§5).
  Recommendation: a document set with re-derivable claims (no executable),
  and a plain command-line tool with a deterministic output (executable,
  not frame-driven). Alternatives: an FPGA fit/timing flow; a data
  pipeline; a model evaluation.
- **R3 — Language and portability floor.** Recommendation: POSIX sh + Python
  3 as bbh, portable across macOS (bash 3.2) and Linux, no runtime
  dependencies beyond those; every guard that exists because of a platform
  difference has a gate on *both* platforms.
- **R4 — The relationship to bbh's skill.** Recommendation: this project
  carries its own skill (`BBX`), generated by the same H10 machinery,
  and cites `BBH` rules rather than copying them.
- **R5 — What "any project" excludes.** Recommendation: nothing is excluded
  by kind, but a subject that cannot be driven deterministically is
  admitted only with BBX-14 reported as *unmet* in every readout.

## 9. Do-nots

- Do not write a tool before the STOP (§6).
- Do not carry a number forward (§1).
- Do not relax a control to make a gate green (BBX-6, BBX-13).
- Do not derive an expectation from the subject's own metadata (§3.4).
- Do not hand-edit a generated artifact (BBX-21).
- Do not describe as "generic" anything with one consumer (BBX-25).
- Do not call anything done, green, or verified in a way the maintainer
  could not check from the readout alone (§0, §3.2, BBX-30).
- Do not fill the blank spaces in this file with confidence. Fill them with
  measurements.

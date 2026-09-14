---
name: bbx
description: The evidence discipline of a black-box harness for any subject whose result must be demonstrably good to someone who cannot read how it was produced - code, a document set, a command-line tool, a build, a dataset - as generalized into BBX. Hard rules for verdicts, must-fire controls, registries and rot, comparison, documents as subjects, provenance and memory, and working discipline. Load before writing, running, freezing or reviewing any gate, control, expectation, comparator, registry or readout in a project that uses BBX, and before changing BBX itself. Project-agnostic.
---

# The evidence harness discipline (level 0, project-agnostic)

Agent-facing rules, IDs `[BBX-N]`. **This directory is SELF-CONTAINED and portable: `SKILL.md` is the rules,
`GUIDE.md` beside it is the human rendition, the same rules each with the evidence for it, and the pair is what a
session loads from `~/.claude/skills/`.** The rules are GENERATED from the rules section of the project constitution,
never hand-written; each is anchored once in a generated rules page that says whether an incident in the project
has re-anchored it or it is still inherited, and a skills lock checks the anchoring, the liftability, the numbers and
the cross-references. The theme: **a green that cannot say what it does not assert is not finished.** Every rule
below names a way evidence gets trusted past what it measured, and the mechanism that makes that loud. The skill
cites one other skill, by `[BBH-N]` id only, and is meant to be loaded on any project.

## Verdicts

- [BBX-1] Exit status decides before any text. SKIP is not PASS and asserts nothing; TIMEOUT is its own verdict; a non-zero exit with a skip marker is a FAILURE. Every count is reported separately. [BBH-6] [BBH-12] [BBH-13] [BBH-16]
- [BBX-2] Verdict logic is validated in *both* directions before it is trusted. A gate born against a live defect has never exercised PASS: its first green is read from printed values, not the verdict word.
- [BBX-3] An unvalidated expectation is a FAILURE, not a pending note. Nothing unratified reads green.
- [BBX-4] "The observation ended before the comparison finished" is a different finding from "the subject diverged". Report them differently.

## Controls

- [BBX-5] Separate the author from the verdict. Prove an instrument fires on a known positive and stays quiet on a known negative before its first real use; name its implausible value in advance.
- [BBX-6] A must-fire control that no longer fires is the only *silent* failure mode. Gates check their own controls and refuse a verdict on a dead one. The fix is never to relax the control.
- [BBX-7] A claim measured by absence ("nothing ever uses X") needs a positive control, a named guard, and a stated fallback. Prefer designs where being wrong is safe *and* loud.
- [BBX-8] A validator is re-run where it must fail (a wrong base, a wrong seed, a wrong address) and required to fail — a check that survives being pointed at the wrong thing goes green on rot.

## Registries and rot

- [BBX-9] Every registry is complete both ways and re-derived every run: an unregistered item and a dead row both fail. A hand-maintained list is a smaller thing to forget to update.
- [BBX-10] The seven ways a harness rots (orphan, silent downgrade, dead control, stale reference, outgrown parser, deleted mechanism, missing operand) are a standing checklist, and harness maintenance is a workstream, not an interruption. The mature reference project's first full sweep found 19 reds and **none** was a defect in the product.
- [BBX-11] The diagnostic that beats all rot: a red gate that fails far faster than its own header's quoted runtime bailed before measuring anything.
- [BBX-12] Parse instrument output by field name, never by position.

## Comparison

- [BBX-13] Tolerance is a ratified vocabulary, not a number: every comparison declares its class, and a class may be tightened freely but loosened only with a measured mechanism named and a maintainer ruling. A growing tolerance inventory means stop and root-cause, never "noise".
- [BBX-14] Every scenario runs more than once, and any difference between runs is a failure *before any class is consulted*. Non-determinism is a defect of the instrument or the subject; it is never absorbed by tolerance. [BBH-49]
- [BBX-15] Self-consistency cannot catch a convention error shared with the oracle. Only a third, lineage-independent party can. All synthesized test content is *chiral* — asymmetric — so mirror, order and orientation errors cannot hide.
- [BBX-16] An artifact has *views*, and every claim, extractor and comparator declares which view it reads. Reading in the wrong view yields plausible garbage, not an error.
- [BBX-17] Frozen inventories are compared as multisets, both ways. A duplicate is itself a signal of hand-editing.

## Documents are subjects too

- [BBX-18] A documented claim with a checkable shape is *quoted from the document* (so an edited document fails loudly), *derived from the artifact*, and *compared*. Coverage — every documented fact no check reaches — is reported as a number.
- [BBX-19] When a document is found wrong, the document is corrected first, in its own commit; only then is a check written against the corrected wording. A document is never bent to match a tool.
- [BBX-20] A living page states what is true; its history twin states how it came to be known. Every document declares its shape at birth and is reachable from the map; completeness is a check. [BBH-9]

## Provenance and memory

- [BBX-21] Every rule cites its incident; every number in a skill appears in a log, never only in a synthesis. The generated guide is never hand-edited.
- [BBX-22] A retracted claim is swept: grep the claim's wording across the tree *and every artifact that has left it*, and show the empty result.
- [BBX-23] Before theorizing about a failure, do the archaeology: what changed, what was measured last, what the last green rested on.
- [BBX-24] Every default value carries a provenance class (`principled` / reference-calibrated / `arbitrary`) in a register; changing one is a ruling. A default calibrated on one consumer and presented as generic is the *biased default*, and the second consumer is its detector.
- [BBX-25] A generic thing needs two instances. A component with one consumer stays with that consumer until a second, genuinely different one exists.

## Working discipline

- [BBX-26] No untested change. A diverging suite halts feature work until it is green or the divergence is ruled.
- [BBX-27] Anti-hyperfocus: at a fixed cadence, step back and ask whether the current thread is still the most valuable one and whether the last green means what it is being treated as meaning.
- [BBX-28] A report from outside the harness (a human, a field test, a screenshot) is a *witness*, not an instrument. Convert it into a reproducible case before any theory is built on it.
- [BBX-29] Results are keyed by (case, subject version), never by the date they finished. A long-running check attests the version that started it and says so.
- [BBX-30] Every green states what it does not assert (§3.2). This rule has no lineage citation because it is the reason this repository exists.

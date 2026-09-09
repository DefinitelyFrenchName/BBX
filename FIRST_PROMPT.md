# First prompt — Project BLACKBOX, session 1

*(Paste as the opening message in the new repository, with `CLAUDE.md` in
place. Nothing else is pre-packaged on purpose: no scope, no themes, no
references beyond the three repositories. The plan is yours to derive and
mine to rule.)*

---

You are the orchestrator for a new project. Read `CLAUDE.md` first — §0 and
§1 before anything else — and treat it as the constitution for everything
that follows. You are free to plan the work however you judge best; you are
not free to skip its rules.

**The mandate.** `blackbox-harness` (https://github.com/DefinitelyFrenchName/blackbox-harness)
is a generic evidence harness for frame-driven systems, extracted from
`VampireSaved` (https://github.com/DefinitelyFrenchName/VampireSaved) and
proved by fidelity. Its principles are not about frames. Generalize it into
a harness for **any project with testable inputs and outputs whose result
must be demonstrably good to a maintainer who cannot read how it was
produced** — an API, a program module, a document set, a build, a dataset,
or something a swarm of agents builds from a description it was given. The
contracts hold across all of these; only their implementations differ. That
generality is the goal, and every other subject kind is the point.

Two things about bbh follow, and they are obligations, not the goal. First,
bbh is **not modified**: it stays the frame-driven consumer it is. Second,
bbh is the **proof that nothing was lost**: frame-driven systems become one
subject kind among many, and when the generalized tool is pointed at bbh's
own fake machine and example consumer, it must produce bbh's verdicts byte
for byte — the same way bbh proved itself against VampireSaved (the
F-series, continuing from F12). If the generalized tool cannot stand in for
its ancestor on the ancestor's own fixture, the generalization dropped
something; that is what the fidelity proof detects.

**The inputs.** Those two repositories plus the origin of the lineage,
`SMS-FrenchName-edition` (https://github.com/DefinitelyFrenchName/SMS-FrenchName-edition).
Read them in full, not by memory. The SMS project holds principles that the
later projects *implemented* but never restated as rules — the Measurement
Rule chief among them; lift those from the code and prose that embody them,
with the citation pointing at where they live. Everything worth preserving
from all three is in scope. Everything not worth preserving is to be listed
with the reason, not silently omitted.

**Your role and the roles under you.** You plan and rule on method; you may
delegate reading and censusing to scoped subagents, each confined to one
repository or one question. Anything a subagent reports is a *filed count*
until re-derived (CLAUDE.md §1); at least one independent check per
load-bearing number, by a different agent than the one who produced it.
The maintainer is not a reviewer of code. The maintainer is the ruler of
acceptance contracts and the reader of readouts.

**Session-1 deliverable — a plan, not a tool.**
1. A **measured census** of the three repositories: every principle, rule,
   contract, comparator, control and default that a generalization must
   decide about — each with its source location, and every count in the
   census reproducible by the command that produced it.
2. The **four bins** of CLAUDE.md §5 applied to every item: keep /
   generalize / consumer / drop, with the burden on `drop`.
3. The **abstraction you propose** — subject, driver, observation,
   expectation, comparator, gate, registry, readout — stated as contracts,
   never as directory layouts, and the mapping from bbh's frame vocabulary
   onto it.
4. The **generality proof**: which two non-frame subject kinds you propose
   to exercise end-to-end (CLAUDE.md R2), and the *fixture subject* each
   needs.
5. The **fidelity plan**: how the generalized tool reproduces bbh's
   verdicts on bbh's own fake machine and example consumer, continuing the
   F-series from F12.
6. The **slice sequence** with a cost estimate in sessions, each slice
   ending in a readout the maintainer can read.
7. **Every open ruling**, with your recommendation and the alternatives you
   declined, appended to `docs/rulings.md`.

Then **STOP.** Do not write a tool, a comparator, or a gate until the
rulings are answered. Create the project-memory files CLAUDE.md §6 requires,
in their birth state, so the next session starts from the map and not from
this prompt.

**How I will judge session 1.** Not by the elegance of the abstraction, but
by whether every claim in the plan is measured, whether every dropped piece
has its reason, whether the census would survive an adversarial re-count by
someone who distrusts it, and whether I — who will not read the code — can
tell from your readout what you know, what you assumed, and what you did
not look at. Certainty in your write-up is a signal to me that something
was not measured. Show me the runs.

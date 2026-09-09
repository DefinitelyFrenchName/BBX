# Controls — the must-fire contract (abstraction G3, ruled R10)

Shape: reference page (one rule per paragraph; the log twin will be
`controls_history.md` when there is history). Lifts bbh `[BBH-21]` (the three
control shapes) and `[BBH-4]` (verdict logic tested both ways) and adds what
VampireSaved lacked: a machine reader for the declaration
(`docs/census/vampiresaved.md` A26, A34: 74 of 311 gates, 8 spellings, no
registry).

**The declaration.** A gate that asserts a property declares every must-fire
control it runs as one header line, in the header (line 2 to the first bare
`#`), in exactly this grammar:

```
# MUST-FIRE: <shape>: <name> — <what must fail, and why that proves the gate can fail>
```

`<shape>` is one of `perturbed-copy` (one byte or one value of a copied
artifact changed), `shadow-tool` (a copy of a tool with a line stripped, under
a throwaway root whose siblings are symlinks — the tracked tool is never
written, `[BBH-59]`), `known-bad` (a synthetic tree or a reference known to be
wrong). `<name>` is `[a-z0-9-]+`, unique within the gate. The regex that reads
it is the only reader: `^# MUST-FIRE: (perturbed-copy|shadow-tool|known-bad): ([a-z0-9-]+) — (.+)$`.

**The firing.** When a declared control fails for its stated reason, the gate
prints `CONTROL FIRED: <name> — <evidence>`. When it does not — it passed, or
failed for another reason — the gate prints `CONTROL DEAD: <name> — <what
happened>` and its verdict is FAIL whatever the real check said (BBX-6: a dead
control refuses a verdict; the fix is never to relax the control).

**The registry.** The controls registry is derived every run from the
headers, never hand-maintained: every gate in a gate registry contributes its
declarations; the runner compares declared against `CONTROL FIRED:` lines in
the gate's output. Declared and not fired is red. Fired and not declared is
red (a control nobody can find in the header is a control nobody can review).
The readout counts *fired / declared* for the run (RO1).

**Gates with no declaration.** A gate that asserts nothing (a pure fixture
generator, a registry lister) may carry no `MUST-FIRE:` line; the header then
says `# MUST-FIRE: none — <why this gate asserts no property>` so silence is
distinguishable from omission. bbh's own selftests, read under fidelity, carry
no declaration and are reported as *undeclared*, never as asserting.

**What this contract does not do.** It does not prove a control is *right* —
a control that fires on a perturbation unrelated to the property is a
control that lies (SMS trap 22: "a negative control is CODE, and it is wrong
until it has failed on purpose"). That judgement is in the reviewer's hands;
the contract makes the control findable and its silence loud.

**First instance.** `gates/census_recount.sh` declares two controls
(`known-bad: wrong-head`, `perturbed-copy: moved-count`) and prints their
firing lines.

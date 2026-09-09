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

**The runner.** `bin/bbx-run-static` reads the declarations with
`lib/py/bbx/controls.py` when `[controls].enforce = true` and prints one
line per gate it ran — `controls=<gate> declared=<n> fired=<n> dead=<n>
undeclared=<n> verdict=OK|RED|UNDECLARED` — then the sum `controls fired
<n> / declared <n>`. RED (a declared control that did not fire, a `CONTROL
DEAD:` line, a firing no header declares) and, under enforcement, UNDECLARED
(no `MUST-FIRE:` line at all) make the run NOT GREEN with exit 1. With
enforcement off the block is absent and the output is bbh's byte for byte
(fidelity F13). Ground truth: `gates/controls.sh`.

**First instances.** Every gate in `gates/` declares its controls; the first
self-run (2026-09-09) read `controls fired 9 / declared 9` over 7 gates. The
reader's own first defect — a firing nobody declared, in a gate with no
declarations, classed UNDECLARED instead of RED — was caught by
`gates/controls.sh` before the reader's first real use (BBX-5).

**The rest of the header API (abstraction G2), read by the same rule — line 2
to the first bare `#`.** `# SKIP: <when this gate asserts nothing, and exits
0>`; `# READ-ONLY (<rulings>): <which tree is never written, and how that is
proved>`; and, from bbx-2, `# NOT-ASSERTED: <one blind spot of this gate's
green>`, one line per blind spot, read by `lib/py/bbx/readout.py` for the
screen's RO2 section (BBX-30). A gate with no `NOT-ASSERTED:` line is not an
error — it is COUNTED on the screen as "declaring no blind spot", which is the
number the maintainer asks about. `NOTE: <key> <value>` at column 0 of a
gate's OUTPUT is the NOTE-class number (never fatal); the key `coverage` is
what the screen reads as coverage (BBX-18).

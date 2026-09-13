# Controls — the must-fire contract (abstraction G3, ruled R10)

Shape: reference page (one rule per paragraph; the log twin will be
`controls_history.md` when there is history). Lifts bbh `[BBH-21]` (the three
control shapes) and `[BBH-4]` (verdict logic tested both ways) and adds what
VampireSaved lacked: a machine reader for the declaration
(`docs/census/vampiresaved.md` A26, A34: 74 of 311 gates, 8 spellings, no
registry).

**The declaration.** A gate that asserts a property declares every must-fire
control it runs as one header line, in the header — the LEADING COMMENT BLOCK,
every `#` line after the shebang up to the first non-comment line; a bare `#`
does not end it (R30, 2026-09-10) — in exactly this grammar:

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
the gate's output. Declared and not fired is red — unless the gate SKIPPED
(below). Fired and not declared is
red (a control nobody can find in the header is a control nobody can review).
The readout counts *fired / declared* for the run (RO1).

**Gates with no declaration.** A gate that asserts nothing (a pure fixture
generator, a registry lister) may carry no `MUST-FIRE:` line; the header then
says `# MUST-FIRE: none — <why this gate asserts no property>` so silence is
distinguishable from omission. bbh's own selftests, read under fidelity, carry
no declaration and are reported as *undeclared*, never as asserting.

**A gate that SKIPS (ruled R48, 2026-09-13).** A gate the runner's classifier
calls SKIP — exit 0 plus the marker, never the marker alone (BBX-1) — ran none
of its checks, so a declared control that did not fire is *not asserting*,
never dead. The reader prints `verdict=SKIPPED`; the runner leaves that gate's
declarations out of *fired / declared* and prints how many it left out
(`skipped: <n>, whose <m> declared control(s) assert nothing`); the readout
names the gate and never counts it as having proved a control. **Nothing else
is set aside:** a `CONTROL DEAD:` line, a firing no header declares, and a
header with no `MUST-FIRE:` line are RED or UNDECLARED exactly as for a gate
that ran. The reader never classifies; the runner hands it the classifier's
list (`bbx controls report --skipped`). Why: [BBH-6] and this page already say
a skipped gate asserts nothing, and demanding that it prove its controls fired
asks for evidence from a measurement that did not happen — the first platform
run went NOT GREEN on a skip that was correct (G47). **`--strict` admits no
exception.** Under it every SKIP is fatal, whatever the gate declares and
whatever the controls block set aside. An exemption of any shape — a list, a
flag, a header line, a variable — is a ruling, never a change (the
maintainer's addition to R48). Ground truth: `gates/controls.sh`, controls
`skip-cannot-hide-dead`, `failed-skip-not-exempt`, `strict-admits-no-exemption`.
What this does not judge: whether a skip is *justified* — a skip for a bad
reason sets its controls aside exactly like a good one, which is why the
screen names every one and `--strict` refuses them all.

**What this contract does not do.** It does not prove a control is *right* —
a control that fires on a perturbation unrelated to the property is a
control that lies (SMS trap 22: "a negative control is CODE, and it is wrong
until it has failed on purpose"). That judgement is in the reviewer's hands;
the contract makes the control findable and its silence loud.

**The runner.** `bin/bbx-run-static` reads the declarations with
`lib/py/bbx/controls.py` when `[controls].enforce = true` and prints one
line per gate it ran — `controls=<gate> declared=<n> fired=<n> dead=<n>
undeclared=<n> verdict=OK|RED|UNDECLARED|SKIPPED` — then the sum `controls fired
<n> / declared <n>; gates with no declaration: <n>; red: <n>; skipped: <n>`,
a SKIPPED gate's declarations left out of the sum and counted after it. RED (a
declared control that did not fire in a gate that ran, a `CONTROL DEAD:` line,
a firing no header declares) and, under enforcement, UNDECLARED (no
`MUST-FIRE:` line at all) make the run NOT GREEN with exit 1. **The block's
verdict rests on the reader's OUTPUT, never on its exit** (G48, measured
2026-09-13): the reader exits 1 for RED and 1 for a crash, and a crashed reader
leaves no lines, which a count of RED lines reads as `red: 0`. So the runner
requires one `controls=` line per gate that ran — fewer is NOT GREEN with
`controls: the reader reported <n> of <m> gate(s) that ran` — and the readout
names every gate that ran with no line and never counts it as proved. With
enforcement off the block is absent and the output is bbh's byte for byte
(fidelity F13). Ground truth: `gates/controls.sh` (control
`reader-crash-is-red` for the output rule).

**First instances.** Every gate in `gates/` declares its controls; the first
self-run (2026-09-09) read `controls fired 9 / declared 9` over 7 gates. The
reader's own first defect — a firing nobody declared, in a gate with no
declarations, classed UNDECLARED instead of RED — was caught by
`gates/controls.sh` before the reader's first real use (BBX-5).

**The rest of the header API (abstraction G2), read by the same rule — the
leading comment block.** `# SKIP: <when this gate asserts nothing, and exits
0>`; `# READ-ONLY (<rulings>): <which tree is never written, and how that is
proved>`; and, from bbx-2, `# NOT-ASSERTED: <one blind spot of this gate's
green>`, one line per blind spot, read by `lib/py/bbx/readout.py` for the
screen's RO2 section (BBX-30). **Every entry — `MUST-FIRE:` and `NOT-ASSERTED:` alike — is ONE
line:** the header line after it is a bare `#` or another keyed header line (`# UPPER-KEY:` or
`# UPPER-KEY (`), and anything else runs the entry on into text no reader reads. Two blind spots
were written that way at bbx-17, and one of them reached seven committed screens cut mid-sentence
(G53, found bbx-24). `gates/close_sweeps.sh` now fails the tree on such an entry in any `*.sh`
header, and the readout marks a cut blind spot `^ TRUNCATED` directly under it instead of printing a
shorter whole. A gate with no `NOT-ASSERTED:` line is not an
error — it is COUNTED on the screen as "declaring no blind spot", which is the
number the maintainer asks about. A header the readout cannot READ — the gate file absent at the root the run recorded, as on any host but the one that ran it — is named `NOT FOUND` with its blind spots UNKNOWN, and never counted as a gate declaring none (G50, fixed at bbx-23). `NOTE: <key> <value>` at column 0 of a
gate's OUTPUT is the NOTE-class number (never fatal); the key `coverage` is
what the screen reads as coverage (BBX-18), and every other key (`drift`,
`bbh-source`, `bbh-drift`, …) is listed on the screen as a note, one line per
NOTE — since bbx-3, whose first run found VampireSaved's drift in the census
log and not on the screen.

**Executable controls (ruled R29, 2026-09-10; built in slice S6).** A declared
control is also a MODE: the runner invokes the gate with `CONTROL=<name>`, the
gate applies that control's perturbation to its REAL input and runs to its
verdict, and the runner requires the gate's own FAIL. A gate that stays green
under its own perturbation has a control that lies, whatever it printed
(`CONTROL LIES: <name>`, the run NOT GREEN); a gate that does not honour the
mode prints `REFUSED: CONTROL=<name> is not a mode of this gate`, exit 3,
read as a dead control. Why (bbh's 14z-144 case, raised by the maintainer):
`CONTROL FIRED` is the gate's self-report, and a control can print it while
testing nothing — it wrote a value and asserted the value was not something
else. The executable form is strictly stronger and compatible: the lines
above stay, the runner does one more thing. Cadence is the tier's, not the
contract's: every battery in the portable tier (a gate may short-circuit to
the affected section under the mode), the static tier under release until
measured. Until S6 lands, every FIRED in this tree is a self-report, and the
readout says so.


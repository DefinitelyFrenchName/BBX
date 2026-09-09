"""controls.py — the must-fire contract's reader (docs/controls.md, ruled R10).

    python3 -m bbx.controls declared <gate.sh>          the controls a gate's header declares
    python3 -m bbx.controls report <gates_dir> <logs_dir> <name>...
                                                        declared vs fired, one line per gate

A gate DECLARES each of its must-fire controls as one header line:

    # MUST-FIRE: <shape>: <name> — <what must fail, and why that proves the gate can fail>

with <shape> one of perturbed-copy | shadow-tool | known-bad, or the
explicit `# MUST-FIRE: none — <why this gate asserts no property>`. The
header is line 2 to the first bare `#` line (bbh [BBH-18]). When a control
fails for its stated reason the gate prints `CONTROL FIRED: <name> — …`;
when it does not, `CONTROL DEAD: <name> — …`.

The report, per gate:
    controls=<gate> declared=<n> fired=<n> dead=<n> undeclared=<n> verdict=OK|RED|UNDECLARED
RED when a declared control did not fire, fired as DEAD, or a FIRED line
names a control no header declares (a control nobody can find in the
header is a control nobody can review). UNDECLARED when the header carries
no MUST-FIRE line at all — reported, and red only under [controls].enforce,
so bbh's own gates (which predate the grammar) are read as *undeclared*,
never as asserting (fidelity keeps bbh unmodified).

This is the machine reader VampireSaved's must-fire doctrine never had
(docs/census/vampiresaved.md A26, A34; docs/gotchas.md G5).
"""
import os
import re
import sys

DECL = re.compile(r"^# MUST-FIRE: (perturbed-copy|shadow-tool|known-bad): ([a-z0-9-]+) — (.+)$")
NONE = re.compile(r"^# MUST-FIRE: none — (.+)$")
FIRED = re.compile(r"^CONTROL FIRED: ([a-z0-9-]+)")
DEAD = re.compile(r"^CONTROL DEAD: ([a-z0-9-]+)")


def header_lines(path):
    """Line 2 up to the first bare `#` line, as bbh's gate contract defines the header."""
    out = []
    try:
        with open(path, errors="replace") as f:
            lines = f.read().splitlines()
    except OSError:
        return out
    for line in lines[1:]:
        if line.strip() == "#":
            break
        if not line.startswith("#"):
            break
        out.append(line)
    return out


def declared(path):
    """Return (controls, none_reason): the declared names (shape, name, text) and the
    `none` reason if the gate declares it asserts nothing."""
    ctrls, none = [], None
    for line in header_lines(path):
        m = DECL.match(line)
        if m:
            ctrls.append(m.groups())
            continue
        m = NONE.match(line)
        if m:
            none = m.group(1)
    return ctrls, none


def fired(log_path):
    """Return (fired_names, dead_names) read from a gate's output."""
    f, d = [], []
    try:
        with open(log_path, errors="replace") as fh:
            for line in fh:
                m = FIRED.match(line)
                if m:
                    f.append(m.group(1))
                    continue
                m = DEAD.match(line)
                if m:
                    d.append(m.group(1))
    except OSError:
        pass
    return f, d


def report_one(gate_path, log_path, name):
    ctrls, none = declared(gate_path)
    names = [c[1] for c in ctrls]
    fired_names, dead_names = fired(log_path)
    n_fired = sum(1 for n in names if n in fired_names)
    n_dead = sum(1 for n in names if n in dead_names or n not in fired_names)
    undeclared = sorted(set(fired_names) - set(names))
    if undeclared or dead_names or n_dead:
        verdict = "RED"          # a firing nobody declared, or a declared control that did not fire
    elif not ctrls and none is None:
        verdict = "UNDECLARED"   # silence: red under enforcement, invisible without it
    else:
        verdict = "OK"
    return (f"controls={name} declared={len(names)} fired={n_fired} dead={n_dead} "
            f"undeclared={len(undeclared)} verdict={verdict}"
            + (f" undeclared_names={','.join(undeclared)}" if undeclared else "")
            + (f" none={none!r}" if none is not None and not ctrls else ""))


def main(argv):
    if len(argv) >= 2 and argv[0] == "declared":
        ctrls, none = declared(argv[1])
        for shape, name, text in ctrls:
            print(f"{shape}\t{name}\t{text}")
        if none is not None and not ctrls:
            print(f"none\t-\t{none}")
        return 0
    if len(argv) >= 4 and argv[0] == "report":
        gates_dir, logs_dir, names = argv[1], argv[2], argv[3:]
        red = 0
        for n in names:
            line = report_one(os.path.join(gates_dir, n + ".sh"), os.path.join(logs_dir, n + ".out"), n)
            print(line)
            if "verdict=RED" in line:
                red += 1
        return 1 if red else 0
    print(__doc__, file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

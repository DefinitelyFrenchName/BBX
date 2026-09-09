#!/usr/bin/env python3
"""readout.py — the one screen the maintainer acts on, generated from a kept run (abstraction RO1–RO3).

    python3 -m bbx.readout <run-dir> [--against <run-dir>]

<run-dir> is what `bbx-run-static --log DIR` keeps: results.tsv (gate, tier,
verdict, seconds, exit, detail), <gate>.log, controls.txt (when enforced),
run.txt (subject root, kind, HEAD, porcelain, start, platform, tallies,
the runner's own verdict). Nothing here re-runs a gate or re-derives a
verdict: the screen REPORTS the run, in words a reader who cannot open the
gates can act on (CLAUDE.md §0, §3.2).

RO1 — content: the verdict and the counts separately (BBX-1); the subject's
identity and version; controls fired / declared, and whether each gate has
proved its controls can fail; the expectations relied upon (a histogram by
provenance class — none until slice S2's register exists, and the screen says
so rather than omitting the line); coverage as a number (BBX-18), taken from
`NOTE: coverage …` lines the gates print; BBX-14 met or unmet — met only when
`--against` names a second kept run of the same subject version and no gate's
verdict differs; the newest re-baseline line.
RO2 — what this green does NOT assert (BBX-30): every gate declares it in its
header as `# NOT-ASSERTED: <text>` (one line per blind spot, in the header
block, read like MUST-FIRE); the screen lists them per gate and COUNTS the
gates that declare nothing — a gate with no declared blind spot is a gate
nobody has asked, and that number is printed, never hidden.
RO3 — legible without the code: gate names and plain sentences only.

Exit: 0 when the run's verdict is GREEN and (with --against) BBX-14 is met;
1 when the run is NOT GREEN or BBX-14 is unmet; 2 when the run dir is
unreadable. First written at bbx-2 (2026-09-09), slice S1's last tool.
"""
import os
import re
import sys

NOT_ASSERTED = re.compile(r"^# NOT-ASSERTED: (.+)$")
NOTE_COVERAGE = re.compile(r"^NOTE: coverage (.+)$")
CTRL = re.compile(r"^controls=(\S+) declared=(\d+) fired=(\d+) dead=(\d+) undeclared=(\d+) verdict=(\S+)")


def read_kv(path):
    d = {}
    for line in open(path, encoding="utf-8"):
        line = line.rstrip("\n")
        if "=" in line:
            k, v = line.split("=", 1)
            d[k] = v
    return d


def read_results(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        header = f.readline().rstrip("\n").split("\t")
        for line in f:
            cells = line.rstrip("\n").split("\t")
            if len(cells) < 4:
                continue
            rows.append(dict(zip(header, cells)))
    return rows


def header_block(path):
    """The gate's header: line 2 to the first bare `#` (the same block MUST-FIRE lives in)."""
    out = []
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            lines = f.read().split("\n")
    except OSError:
        return out
    for line in lines[1:]:
        if line.strip() == "#":
            break
        if not line.startswith("#"):
            break
        out.append(line)
    return out


def not_asserted(gate_path):
    return [m.group(1).strip() for l in header_block(gate_path) for m in [NOT_ASSERTED.match(l)] if m]


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    against = None
    if "--against" in argv:
        i = argv.index("--against")
        against = argv[i + 1] if i + 1 < len(argv) else None
        del argv[i:i + 2]
    if len(argv) != 1 or (against is None and "--against" in sys.argv):
        print("usage: readout.py <run-dir> [--against <run-dir>]", file=sys.stderr)
        return 2
    run = argv[0]
    try:
        meta = read_kv(os.path.join(run, "run.txt"))
        rows = read_results(os.path.join(run, "results.tsv"))
    except OSError as e:
        print(f"readout={run} error=unreadable detail={e}")
        return 2

    verdict = meta.get("verdict", "?")
    counts = {k: sum(1 for r in rows if r.get("verdict") == k) for k in ("PASS", "SKIP", "FAIL", "TIMEOUT", "MISSING")}
    print(f"== READOUT — {meta.get('kind', '?')} subject at {meta.get('root', '?')} @ {meta.get('head', '?')} "
          f"(porcelain {meta.get('porcelain', '?')}) — started {meta.get('started', '?')} on {meta.get('platform', '?')} ==")
    strict = " [--strict: SKIP counts as failure]" if meta.get("strict") == "1" else ""
    print(f"VERDICT: {verdict}   PASS {counts['PASS']}  SKIP {counts['SKIP']}  FAIL {counts['FAIL']}  "
          f"TIMEOUT {counts['TIMEOUT']}  MISSING {counts['MISSING']}   (gates {len(rows)}){strict}")
    tree = meta.get("tree", "not-checked")
    print(f"tree during the run: {tree}   harness: bbx @ {meta.get('bbx_head', '?')}")

    print("rests on:")
    # controls
    ctrl_path = os.path.join(run, "controls.txt")
    if os.path.exists(ctrl_path):
        decl = fired = dead = undecl = 0
        red = []
        none_declared = []
        for line in open(ctrl_path, encoding="utf-8"):
            m = CTRL.match(line)
            if not m:
                continue
            g, d, f, x, u, v = m.group(1), int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5)), m.group(6)
            decl += d; fired += f; dead += x; undecl += u
            if v != "OK":
                red.append(f"{g} ({v})")
            if d == 0:
                none_declared.append(g)
        print(f"  controls: fired {fired} / declared {decl}; dead {dead}; undeclared firings {undecl}; "
              f"gates red {len(red)}{': ' + ', '.join(red) if red else ''}")
        print(f"  each can fail: {len(rows) - len(none_declared)} of {len(rows)} gates proved a control fires on purpose"
              f"{'; declaring none: ' + ', '.join(none_declared) if none_declared else ''}")
    else:
        print("  controls: not enforced in this run (no controls.txt) — no gate here has proved it can fail")
    # expectations
    print("  expectations relied upon: none registered — the expectation register with its provenance classes is slice S2; "
          "until then no comparison against a frozen expectation is claimed")
    # coverage
    cov = []
    for r in rows:
        lp = os.path.join(run, r["gate"] + ".log")
        if os.path.exists(lp):
            for line in open(lp, encoding="utf-8", errors="replace"):
                m = NOTE_COVERAGE.match(line)
                if m:
                    cov.append(f"{r['gate']}: {m.group(1).strip()}")
    if cov:
        for c in cov:
            print(f"  coverage: {c}")
    else:
        print("  coverage: no gate reported a coverage number (NOTE: coverage …) — uncovered claims are not counted in this run")
    # BBX-14
    if against:
        try:
            rows2 = read_results(os.path.join(against, "results.tsv"))
            meta2 = read_kv(os.path.join(against, "run.txt"))
        except OSError as e:
            print(f"  BBX-14 (more than one run): cannot read --against {against} ({e}) — unmet")
            bbx14 = False
        else:
            v1 = {r["gate"]: r["verdict"] for r in rows}
            v2 = {r["gate"]: r["verdict"] for r in rows2}
            diffs = sorted(g for g in set(v1) | set(v2) if v1.get(g) != v2.get(g))
            same_subject = meta.get("head") == meta2.get("head")
            if diffs or not same_subject:
                why = []
                if not same_subject:
                    why.append(f"different subject versions ({meta.get('head')} vs {meta2.get('head')})")
                if diffs:
                    why.append("verdicts differ: " + ", ".join(f"{g} {v1.get(g, '-')}/{v2.get(g, '-')}" for g in diffs))
                print(f"  BBX-14 (more than one run): UNMET — {'; '.join(why)} (against {meta2.get('started', against)})")
                bbx14 = False
            else:
                print(f"  BBX-14 (more than one run): met — {len(v1)} gates, 0 verdict differences against the run started "
                      f"{meta2.get('started', '?')} at the same HEAD")
                bbx14 = True
    else:
        print("  BBX-14 (more than one run): UNMET in this screen — one run only; pass --against a second kept run of the same HEAD")
        bbx14 = None
    print(f"  last re-baseline: {meta.get('rebaseline') or '(none recorded)'}")

    print("what this green does NOT assert (declared by each gate's header):")
    gates_dir = os.path.join(meta.get("root", "."), meta.get("gates_dir", "."))
    silent = []
    for r in rows:
        items = not_asserted(os.path.join(gates_dir, r["gate"] + ".sh"))
        if not items:
            silent.append(r["gate"])
            continue
        for it in items:
            print(f"  {r['gate']}: {it}")
    print(f"  gates declaring no blind spot: {len(silent)}{' — ' + ', '.join(silent) if silent else ''}"
          f"   (a gate nobody has asked what its green leaves out)")
    if counts["SKIP"]:
        print("skipped (asserting nothing): " + ", ".join(f"{r['gate']} — {r.get('detail', '')}" for r in rows if r["verdict"] == "SKIP"))
    if counts["FAIL"] or counts["TIMEOUT"] or counts["MISSING"]:
        print("not green: " + ", ".join(f"{r['gate']} {r['verdict']}" for r in rows if r["verdict"] in ("FAIL", "TIMEOUT", "MISSING")))
    ok = verdict == "GREEN" and bbx14 is not False
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

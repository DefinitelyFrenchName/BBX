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
provenance class — none for a static run, the register's histogram for a kept suite run (D32), and the screen says
so rather than omitting the line); coverage as a number (BBX-18), taken from
`NOTE: coverage …` lines the gates print; every OTHER NOTE-class line a gate
printed (a lineage's drift, bbh's source) listed as a note, since a number
left in a log is a number the maintainer never saw (bbx-3's first fix); BBX-14 met or unmet — met only when
`--against` names a second kept run of the same subject version and no gate's
verdict differs; the newest re-baseline line. The gate counts are the kept rows' reconciled with every tally
run.txt records (G57): gates the runner counted as SKIP and kept no row for — a tier it did not run — are added to
SKIP and named with their tier, and any other tally the rows do not reproduce is printed as a disagreement, never
resolved. A NOT GREEN run's FAIL rows are read against the runtime each gate's header quotes, through the gate
index's own reader over the whole header (G29): a FAIL under a tenth of that runtime is named on a `runtime (BBX-11)`
line; a failing gate whose header quotes none is listed and never judged, and so is one whose quote is under ten
seconds, whose tenth the run's whole seconds cannot hold (D88; rot class 6's candidate, R64); a run with no FAIL row
prints no such line. A kept SUITE run (run.txt carries
`expset=`) gets its own screen (S2 step 4): the findings counted apart, the
expectations relied upon as a histogram by R11 class from the register beside
the tree, which classes PASSed on a pairing that is not fixture-class; since S3
step 4 the scenarios' own numbers from the run's notes.tsv (D44) — `coverage:`
per scenario, every other key a note — the rows counted as PAIRINGS keyed
(scenario, kind), BBX-14 over pairings, and the DRIVER's blind spots under
"what this green does NOT assert" (RO2), read from its header like a gate's.
RO2 — what this green does NOT assert (BBX-30): every gate declares it in its
header as `# NOT-ASSERTED: <text>` (one line per blind spot, in the header
block, read like MUST-FIRE); the screen lists them per gate and COUNTS the
gates that declare nothing — a gate with no declared blind spot is a gate
nobody has asked, and that number is printed, never hidden. A header the screen
cannot READ — the gate file or the driver absent at the root the run recorded, as
on any host but the one that ran it — is named as NOT FOUND and its blind spots
reported UNKNOWN, never counted as a gate that declares none (G50). A blind spot
whose entry runs on past its one line is printed with a TRUNCATED mark directly
under it, never as a shorter whole (G53).
RO3 — legible without the code: gate names and plain sentences only.

Exit: 0 when the run's verdict is GREEN and (with --against) BBX-14 is met;
1 when the run is NOT GREEN or BBX-14 is unmet; 2 when the run dir is
unreadable. First written at bbx-2 (2026-09-09), slice S1's last tool.
"""
import os
import re
import sys

NOT_ASSERTED = re.compile(r"^# NOT-ASSERTED: (.+)$")
NOTE_LINE = re.compile(r"^NOTE: (\S+) ?(.*)$")   # every NOTE-class number a gate prints (docs/controls.md); key `coverage` is BBX-18
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
    """The gate's header, read by the ONE reader (lib/py/bbx/controls.py header_lines, R30)."""
    from .controls import header_lines
    return header_lines(path)


def blind_spots(path):
    """(text, run_on) per NOT-ASSERTED entry of a gate's or a driver's header: run_on counts the header
    lines the entry runs past its one line (controls.continued_entries, G53) — 0 for a whole entry."""
    from .controls import continued_entries
    run_on = {n: k for n, kind, k in continued_entries(path) if kind == "NOT-ASSERTED"}
    return [(m.group(1).strip(), run_on.get(i + 2, 0))
            for i, l in enumerate(header_block(path)) for m in [NOT_ASSERTED.match(l)] if m]


def print_blind_spots(label, items):
    """One screen line per blind spot; one cut by its header is MARKED under it, never printed as a shorter whole (G53)."""
    for text, run_on in items:
        print(f"  {label}: {text}")
        if run_on:
            print(f"  {label}: ^ TRUNCATED — the blind spot above runs on {run_on} more header line(s) that this screen "
                  f"does not print (one line per entry: docs/controls.md, G53)")


# G57: the tallies run.txt records, each with the kept verdicts that should reproduce it (the runner counts a
# TIMEOUT as a failure), and the tiers a run of `--tier all` asks for
TALLIES = (("pass", ("PASS",)), ("skip", ("SKIP",)), ("fail", ("FAIL", "TIMEOUT")), ("missing", ("MISSING",)))
TIERS = {"all": ("portable", "static")}


def reconcile(meta, rows, counts):
    """(unrun, tier, disagreements) between run.txt's tallies and the kept rows (G57). The runner counts the gates of
    a tier it did not run as SKIP and keeps no row for them: `unrun` is run.txt's skip= above the kept SKIP rows;
    `tier` is the one tier the run asked for that no kept row carries, '' when the screen cannot name exactly one;
    every other tally the rows do not reproduce is a disagreement, named and never resolved here. A tally run.txt
    does not record is not compared."""
    kept = {k: sum(counts[v] for v in verdicts) for k, verdicts in TALLIES}
    recorded = {}
    for k, _ in TALLIES:
        try:
            recorded[k] = int(meta[k])
        except (KeyError, ValueError):
            pass
    unrun = max(recorded.get("skip", kept["skip"]) - kept["skip"], 0)
    asked = TIERS.get(meta.get("tier", ""), (meta.get("tier", ""),))
    absent = [t for t in asked if t and not any(r.get("tier") == t for r in rows)]
    tier = absent[0] if unrun and len(absent) == 1 else ""
    disagree = [f"run.txt {k}={recorded[k]}, kept rows {kept[k]}" for k, _ in TALLIES
                if k in recorded and recorded[k] != kept[k] and not (k == "skip" and unrun)]
    return unrun, tier, disagree


FINDINGS = ("pass", "skip", "pending", "no-expectation", "nondeterministic", "run-fail", "frozen", "authored",
            "mask-mismatch", "unknown-class", "short", "no-base-log", "diverged", "unclassified")   # lib/py/bbx/finding.py


def suite_screen(run, meta, rows, against):
    """RO1-RO3 for a kept suite run (S2 step 4): the verdict and the findings counted apart (BBX-4), the
    expectations relied upon as a histogram by R11 class from the register beside the tree (E3), which
    classes PASSed on a pairing that is not fixture-class, BBX-14 against a second run."""
    import os as _os
    from . import config as C
    from . import provenance as P
    expset = meta.get("expset", "")
    print(f"== READOUT (suite) — {meta.get('kind', '?')} subject at {meta.get('root', '?')} @ {meta.get('head', '?')} "
          f"(porcelain {meta.get('porcelain', '?')}) — set '{meta.get('set', '?')}' -> expectation set '{expset or '-'}' — "
          f"started {meta.get('started', '?')} on {meta.get('platform', '?')} ==")
    n = {k: int(meta.get(k, 0) or 0) for k in ("pass", "skip", "fail", "other")}
    scen = len({r.get("scenario") for r in rows})
    print(f"VERDICT: {meta.get('verdict', '?')}   PASS {n['pass']}  SKIP {n['skip']}  FAIL {n['fail']}  OTHER {n['other']}   "
          f"(scenarios {scen}, pairings {len(rows)}; each run {meta.get('runs_per_replay', '?')} times; driver {_os.path.basename(meta.get('driver', '?'))})")
    fc = {}
    for r in rows:
        f = r.get("finding", "unclassified"); fc[f] = fc.get(f, 0) + 1
    print("findings: " + (", ".join(f"{f} {fc[f]}" for f in FINDINGS if f in fc) or "none") +
          "   (short = the observation ended before the comparison finished; diverged = the subject differed: BBX-4)")
    print("rests on:")
    reg_line = "  expectations relied upon: "
    hist = None; real_files = set(); unknown = True
    try:
        cfg = C.load(meta["config"]); root = meta.get("root", ".")
        exp_dir = _os.path.join(root, C.get(cfg, "suite.expected_dir"))
        reg = _os.path.join(exp_dir, C.get(cfg, "provenance.register"))
        excl = set(C.get(cfg, "provenance.exclude")) | {_os.path.basename(reg)}
        nfiles = sum(1 for f in _os.listdir(_os.path.join(exp_dir, expset)) if _os.path.isfile(_os.path.join(exp_dir, expset, f)) and f not in excl and not f.startswith(".")) if expset and _os.path.isdir(_os.path.join(exp_dir, expset)) else 0
        if _os.path.isfile(reg):
            prows, errs = P.read_register(reg)
            hist = P.histogram(prows, expset)
            unknown = False
            for _t, pr in prows:
                if str(pr["file"]).startswith(expset + "/") and str(pr["class"]) not in ("fixture", "testimony"):
                    real_files.add(_os.path.splitext(_os.path.basename(str(pr["file"])))[0])   # the scenario, by FILE (a row vouches for one file)
            if errs:
                reg_line += f"register REFUSED ({len(errs)} row(s), run bbx provenance) — "
            reg_line += (", ".join(f"{c} {hist[c]}" for c in P.CLASSES if c in hist) or f"no row for set '{expset}'") + f" (register {_os.path.relpath(reg, root)}; {nfiles} files in the set)"
            if hist.get("testimony"):
                reg_line += f"; testimony {hist['testimony']}: not evidence, never green (BBX-3)"
            if hist.get("fixture"):
                reg_line += f"; fixture {hist['fixture']}: evidence about no real subject"
        else:
            reg_line += f"none registered — no {_os.path.relpath(reg, root)}; the {nfiles} expectation files of set '{expset}' carry no provenance class (E3)"
    except (OSError, KeyError) as e:
        reg_line += f"unreadable ({e})"
    print(reg_line)
    classes = sorted({r.get("class", "-") for r in rows if r.get("class", "-") not in ("-", "")})
    passed_real = sorted({r.get("class") for r in rows if r.get("finding") == "pass" and r.get("scenario") in real_files and r.get("class") in classes})
    if unknown:
        real_txt = "unknown — no register says which pairings are real"
    else:
        real_txt = ", ".join(passed_real) if passed_real else "none — every expectation of this set is fixture-class or unregistered"
    print(f"  comparator classes in this run: {', '.join(classes) or 'none'}; PASSed on a real pairing: {real_txt}")
    # the scenarios' own numbers (D44, notes.tsv): coverage on its own line (BBX-18, RO1), every other key as a note
    cov, notes = [], []
    npath = _os.path.join(run, "notes.tsv")
    if _os.path.isfile(npath):
        with open(npath, encoding="utf-8") as f:
            header = f.readline().rstrip("\n").split("\t")
            for line in f:
                d = dict(zip(header, line.rstrip("\n").split("\t")))
                if d.get("key") == "coverage":
                    cov.append(f"{d.get('scenario')}: {d.get('value', '')}")
                else:
                    notes.append(f"{d.get('scenario')}: {d.get('key')} {d.get('value', '')}".rstrip())
    for c in cov:
        print(f"  coverage: {c}")
    if not cov:
        print("  coverage: no scenario reported a coverage number (NOTE: coverage …) — uncovered claims are not counted in this run")
    for x in notes:
        print(f"  note: {x}")
    if not notes:
        print("  note: none — no scenario printed a NOTE-class number other than coverage")
    bbx14 = None
    if against:
        try:
            rows2 = read_results(_os.path.join(against, "results.tsv")); meta2 = read_kv(_os.path.join(against, "run.txt"))
        except OSError as e:
            print(f"  BBX-14 (more than one run): cannot read --against {against} ({e}) — unmet"); bbx14 = False
        else:
            key = lambda r: f"{r['scenario']}.{r.get('kind', '-')}"     # a pairing (S3 step 4: several rows per scenario)
            v1 = {key(r): r["verdict"] for r in rows}; v2 = {key(r): r["verdict"] for r in rows2}
            diffs = sorted(k for k in set(v1) | set(v2) if v1.get(k) != v2.get(k))
            same = meta.get("head") == meta2.get("head") and meta.get("expset") == meta2.get("expset")
            if diffs or not same:
                print(f"  BBX-14 (more than one run): UNMET — " + ("; ".join(([f"different subject or set ({meta.get('head')}/{meta.get('expset')} vs {meta2.get('head')}/{meta2.get('expset')})"] if not same else []) + (["verdicts differ: " + ", ".join(f"{k} {v1.get(k, '-')[:24]}/{v2.get(k, '-')[:24]}" for k in diffs)] if diffs else []))))
                bbx14 = False
            else:
                print(f"  BBX-14 (more than one run): met — {len(v1)} pairings, 0 verdict differences against the run started {meta2.get('started', '?')} at the same HEAD and set"); bbx14 = True
    else:
        print("  BBX-14 (more than one run): each scenario ran " + str(meta.get("runs_per_replay", "?")) + " times inside this run (nondeterminism is a finding above); pass --against a second kept run for run-to-run")
    print("what this green does NOT assert:")
    # the driver's own blind spots (RO2, S3 step 4): its header's NOT-ASSERTED lines, read like a gate's
    drv = meta.get("driver", "")
    dname = _os.path.basename(drv) or "?"
    if drv and not _os.path.isfile(drv):
        # G50: a header this host cannot read is UNKNOWN, never a driver that declares nothing
        print(f"  driver {dname}: header NOT FOUND at {drv} — its blind spots are UNKNOWN, not absent (G50)")
    else:
        ditems = blind_spots(drv) if drv else []
        print_blind_spots(f"driver {dname}", ditems)
        if not ditems:
            print(f"  driver {dname} declares no blind spot (a driver nobody has asked what its log leaves out)")
    print("  the correctness of any expectation beyond its class: a `self` expectation sees currency, never a regression against a reference (E4)")
    print("  anything about a SKIP scenario: it asserts nothing")
    if unknown:
        print("  where any expectation's numbers came from: no register (E3)")
    if fc.get("short"):
        print(f"  {fc['short']} scenario(s) read `short`: the observation ended before re-convergence could be proved — a length finding, not a divergence")
    ok = meta.get("verdict") == "GREEN" and bbx14 is not False
    return 0 if ok else 1


FAST_FAIL_FACTOR = 10     # D88: a FAIL under a tenth of the runtime its header quotes is named (BBX-11)
RESOLUTION_S = 1          # D88: results.tsv keeps whole seconds, so a limit under one second cannot be judged
UNIT_SECONDS = {"s": 1, "sec": 1, "min": 60, "h": 3600, "hour": 3600, "hours": 3600}   # the units of [gate_header].duration_regex


def fast_failures(meta, rows, gates_dir):
    """BBX-11 over the kept FAIL rows: (fast, unquoted, unjudged, failing). `fast` holds (gate, seconds, quote) for
    each FAIL whose seconds are under 1/FAST_FAIL_FACTOR of the runtime its header quotes, the quote read by the gate
    index's reader, first_duration over the whole header, with the run's own config (G29); `unquoted` the failing
    gates whose header quotes no runtime or was not found; `unjudged` those whose limit is under RESOLUTION_S, which
    the kept whole seconds cannot tell from 0. Rot class 6's candidate (R64, docs/rot.toml)."""
    failing = [r for r in rows if r.get("verdict") == "FAIL"]
    if not failing:
        return [], [], [], 0
    from . import config as C, gen_gate_index as G
    cfg_path = meta.get("config", "")
    try:
        settings = G.Settings(C.load(cfg_path) if cfg_path and os.path.isfile(cfg_path) else {})
    except (OSError, KeyError, C.toml_subset.SubsetError):
        settings = G.Settings({})
    fast, unquoted, unjudged = [], [], []
    for r in failing:
        gp = os.path.join(gates_dir, r["gate"] + ".sh")
        quote = G.first_duration(G.header_text(gp, whole=True), settings) if os.path.isfile(gp) else ""
        m = re.match(r"^~(\d+(?:\.\d+)?) (\S+)$", quote)
        try:
            secs = float(r.get("seconds", ""))
        except ValueError:
            secs = None
        if not m or m.group(2) not in UNIT_SECONDS or secs is None:
            unquoted.append(r["gate"])
            continue
        limit = float(m.group(1)) * UNIT_SECONDS[m.group(2)] / FAST_FAIL_FACTOR
        if limit < RESOLUTION_S:
            unjudged.append(r["gate"])
        elif secs < limit:
            fast.append((r["gate"], r["seconds"], quote))
    return fast, unquoted, unjudged, len(failing)


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

    if "expset" in meta:
        return suite_screen(run, meta, rows, against)
    verdict = meta.get("verdict", "?")
    counts = {k: sum(1 for r in rows if r.get("verdict") == k) for k in ("PASS", "SKIP", "FAIL", "TIMEOUT", "MISSING")}
    print(f"== READOUT — {meta.get('kind', '?')} subject at {meta.get('root', '?')} @ {meta.get('head', '?')} "
          f"(porcelain {meta.get('porcelain', '?')}) — started {meta.get('started', '?')} on {meta.get('platform', '?')} ==")
    strict = " [--strict: SKIP counts as failure]" if meta.get("strict") == "1" else ""
    unrun, unrun_tier, disagree = reconcile(meta, rows, counts)
    kept_txt = f"gates {len(rows)}" + (f" kept, {unrun} not run" if unrun else "")
    print(f"VERDICT: {verdict}   PASS {counts['PASS']}  SKIP {counts['SKIP'] + unrun}  FAIL {counts['FAIL']}  "
          f"TIMEOUT {counts['TIMEOUT']}  MISSING {counts['MISSING']}   ({kept_txt}){strict}")
    if disagree:
        print("counts disagree: " + "; ".join(disagree) + " — the counts above are the kept rows'; this screen does not decide "
              "which is right (G57)")
    tree = meta.get("tree", "not-checked")
    ub, ua = meta.get("untracked_before"), meta.get("untracked_after")
    if ub is not None and ua is not None:
        tree += f" (untracked entries {ub} -> {ua}" + (")" if ub == ua else " — a file was written under the tree during the run: G17)")
    print(f"tree during the run: {tree}   harness: bbx @ {meta.get('bbx_head', '?')}")

    print("rests on:")
    # controls
    ctrl_path = os.path.join(run, "controls.txt")
    if os.path.exists(ctrl_path):
        decl = fired = dead = undecl = 0
        red = []
        none_declared = []
        skipped = []      # (gate, declared): R48 — a SKIPPED gate's declarations assert nothing this run
        reported = set()
        for line in open(ctrl_path, encoding="utf-8"):
            m = CTRL.match(line)
            if not m:
                continue
            g, d, f, x, u, v = m.group(1), int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5)), m.group(6)
            reported.add(g)
            if d == 0:
                none_declared.append(g)
            if v == "SKIPPED":
                skipped.append((g, d))
                continue
            decl += d; fired += f; dead += x; undecl += u
            if v != "OK":
                red.append(f"{g} ({v})")
        skip_txt = (f"; skipped {len(skipped)}, whose {sum(d for _, d in skipped)} declared control(s) assert nothing: "
                    + ", ".join(g for g, _ in skipped)) if skipped else "; skipped 0"
        print(f"  controls: fired {fired} / declared {decl}; dead {dead}; undeclared firings {undecl}; "
              f"gates red {len(red)}{': ' + ', '.join(red) if red else ''}{skip_txt}")
        # G48: a gate that RAN with no controls line was never read — named, and never counted as asserting
        unreported = [r["gate"] for r in rows if r.get("verdict") != "MISSING" and r["gate"] not in reported]
        if unreported:
            print(f"  controls: NOT REPORTED for {len(unreported)} gate(s) that ran — no controls verdict rests on them (G48): "
                  + ", ".join(unreported))
        skipped_declaring = [g for g, d in skipped if d]
        proved = sum(1 for g in reported if g not in none_declared and g not in skipped_declaring)
        print(f"  each can fail: {proved} of {len(rows)} gates proved a control fires on purpose"
              f"{'; declaring none: ' + ', '.join(none_declared) if none_declared else ''}"
              f"{'; skipped, proving nothing this run: ' + ', '.join(skipped_declaring) if skipped_declaring else ''}")
    else:
        print("  controls: not enforced in this run (no controls.txt) — no gate here has proved it can fail")
    # expectations
    print("  expectations relied upon: none registered — a static run compares against no frozen expectation; "
          "a kept suite run (bbx-run-suite --log) carries its register's histogram (D32)")
    # NOTE-class numbers: coverage (BBX-18) on its own line, every other key as a note
    cov, notes = [], []
    for r in rows:
        lp = os.path.join(run, r["gate"] + ".log")
        if os.path.exists(lp):
            for line in open(lp, encoding="utf-8", errors="replace"):
                m = NOTE_LINE.match(line.rstrip("\n"))
                if not m:
                    continue
                if m.group(1) == "coverage":
                    cov.append(f"{r['gate']}: {m.group(2).strip()}")
                else:
                    notes.append(f"{r['gate']}: {m.group(1)} {m.group(2).strip()}".rstrip())
    if cov:
        for c in cov:
            print(f"  coverage: {c}")
    else:
        print("  coverage: no gate reported a coverage number (NOTE: coverage …) — uncovered claims are not counted in this run")
    if notes:
        for n in notes:
            print(f"  note: {n}")
    else:
        print("  note: none — no gate printed a NOTE-class number other than coverage (a moved lineage would be listed here)")
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
    silent, unreadable = [], []
    for r in rows:
        gp = os.path.join(gates_dir, r["gate"] + ".sh")
        if not os.path.isfile(gp):
            unreadable.append(r["gate"])      # G50: a header this host cannot read is UNKNOWN, never silence
            continue
        items = blind_spots(gp)
        if not items:
            silent.append(r["gate"])
            continue
        print_blind_spots(r["gate"], items)
    print(f"  gates declaring no blind spot: {len(silent)}{' — ' + ', '.join(silent) if silent else ''}"
          f"   (a gate nobody has asked what its green leaves out)")
    if unreadable:
        print(f"  gates whose header was NOT FOUND: {len(unreadable)} under {gates_dir} — their blind spots are UNKNOWN, "
              f"not absent (G50): " + ", ".join(unreadable))
    if counts["SKIP"]:
        print("skipped (asserting nothing): " + ", ".join(f"{r['gate']} — {r.get('detail', '')}" for r in rows if r["verdict"] == "SKIP"))
    if unrun:
        where = f"the {unrun_tier} tier" if unrun_tier else "a tier this screen cannot name"
        print(f"not run (asserting nothing): {where} — {unrun} gate(s) the runner counted as SKIP and kept no row for: no verdict, "
              f"control or blind spot of theirs is on this screen (run.txt tier={meta.get('tier', '?')} skip={meta.get('skip', '?')}; "
              f"kept SKIP rows {counts['SKIP']}; G57)")
    if counts["FAIL"] or counts["TIMEOUT"] or counts["MISSING"]:
        print("not green: " + ", ".join(f"{r['gate']} {r['verdict']}" for r in rows if r["verdict"] in ("FAIL", "TIMEOUT", "MISSING")))
    fast, unquoted, unjudged, nfail = fast_failures(meta, rows, gates_dir)
    if nfail:
        short = f"; quoting under {FAST_FAIL_FACTOR * RESOLUTION_S} s, too short to judge in whole seconds: " + ", ".join(unjudged)
        print(f"runtime (BBX-11): {len(fast)} of {nfail} failing gate(s) under a tenth of the runtime their header quotes"
              f"{'; quoting none or not found: ' + ', '.join(unquoted) if unquoted else ''}{short if unjudged else ''}"
              f" — rot class 6's candidate (R64)")
        for g, s, q in fast:
            print(f"  {g} FAILED in {s} s where its header quotes {q}: a gate that fails that fast bailed before measuring anything")
    ok = verdict == "GREEN" and bbx14 is not False
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

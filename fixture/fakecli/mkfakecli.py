#!/usr/bin/env python3
"""mkfakecli.py — the COMMAND-LINE FIXTURE's generator (docs/generality.md kind B; docs/plans/S4.md §4).

    python3 fixture/fakecli/mkfakecli.py            write the fixture under this directory
    python3 fixture/fakecli/mkfakecli.py --check    (1) every chirality predicate holds on the TREE's tool
                                                    (its design table read back out of subject/fakecli.py);
                                                    (2) the tree's fixture equals what this script writes,
                                                    regenerated under TMPDIR and diffed; (3) the TOOL-CHECK:
                                                    the tree's tool, run directly for every scenario under a
                                                    clean environment, produces the exit, stdout, stderr and
                                                    files the DESIGN says — non-zero naming the predicate,
                                                    the file, or the scenario and what differs

WHAT IT WRITES, from the DESIGN below and nothing else (the truth is known here, which is why every
expectation it freezes is class `fixture` — evidence about no real subject, R11/R24):
  subject/fakecli.py           the TOOL (the subject; the template at the end of this file with the design
                               table injected): python3, deterministic, every feature an OPTION — a tool's
                               contract is its command line (the one place it differs from bbh's fixture,
                               whose knobs are environment variables)
  scenarios/<s>.cli            nine INVOCATIONS (TOML subset, R35; D46): args one per element, stdin as
                               lines, the files the tool must emit, the band fields, the [env] table
  expected/fixture/<s>.truth   the spec `exact fixture`: the run's log is compared BY INDEX against
  expected/fixture/logs/<s>.log   the TRUTH log — every token written from the DESIGN through
                               lib/py/bbx/cli.py's vocabulary (D47), never by running the tool (that would
                               freeze the tool's own answer: a self-freeze, BBX-3)
  expected/fixture/02_unordered.unordered   the multiset of stdout lines of the `--unordered` run, both ways
  expected/fixture/03_show_json.schema      the JSON object's shape before any value (R40; D49)
  expected/fixture/04_band.band             the band of the `size` field, MEASURED over seeds 1..9 of the
                               design's function, inclusive (R36; D48)
  expected/registry.tsv        the WHOLE-SET key of subject/ (dir-sha1) -> `fixture`
  expected/PROVENANCE.toml     every expectation file and truth log, class `fixture`; the registry row `registry`

CHIRAL BY CONSTRUCTION (BBX-15; D50): D36's ten predicates on the table, plus: the rank order is neither
the name order nor its reverse (an order error cannot hide behind a sorted listing); no name, id or
weight is shared with fixture/docset's design (read from mkdocset.py — measured, never assumed); the
stdin lines of the join scenario are in neither sorted order. Every predicate is named when it fails
(gates/cli_fixture.sh's control `symmetric-fixture`).

SMS `tools/mk*.py` convention (6 generators there): a generated fixture is re-derived and diffed,
never hand-edited (BBX-21). The tool-check is the fixture's own BBX-5 pairing: the design is the
author, the tool is the artifact, and a template edit that moves one line is named by scenario
(gates/cli_fixture.sh's control `tool-drifts-from-design`).
"""
import ast
import importlib.util
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "lib" / "py"))
from bbx import cli as T          # noqa: E402  (the token vocabulary, D47)
from bbx.fingerprint import dir_sha1   # noqa: E402

# ── the design ────────────────────────────────────────────────────────────────
# (name, id, weight, rank, tags) — see predicates() for why these values
RECORDS = [
    ("Maren",    "4D2B", 83, 6, ("ash", "elm")),
    ("Orsolya",  "7E19", 26, 2, ("oak",)),
    ("Perrin",   "1B8C", 94, 8, ("elm", "fir", "yew")),
    ("Quillon",  "9A35", 17, 4, ("fir",)),
    ("Rosalind", "3F60", 48, 1, ("yew", "ash")),
    ("Sable",    "6C97", 35, 9, ("oak", "elm")),
    ("Tobin",    "2E4A", 76, 3, ("ash",)),
    ("Ulric",    "8B13", 59, 7, ("fir", "oak")),
    ("Vesna",    "5A7D", 82, 5, ("yew",)),
]
COLUMNS = ("name", "id", "weight", "rank")
BAND_BASE, BAND_MUL, BAND_MOD = 231, 29, 41          # size(seed) = BASE + (seed * MUL) % MOD
BAND_SEEDS = range(1, 10)                            # the band is MEASURED over these seeds of the design
STDIN_LINES = ("juniper", "alder", "rowan")          # the join scenario's stdin: in neither sorted order
SET = "fakecli"                                      # the tool is subject/<set>.py ([fingerprint].file_pattern, D45)
EXPSET = "fixture"
SALT_ENV = "FAKECLI_SALT"                            # the tool appends `salt=<v>` when it SEES this variable


def size_of(seed):
    return BAND_BASE + (seed * BAND_MUL) % BAND_MOD


def record(name):
    for r in RECORDS:
        if r[0] == name:
            return r
    return None


def list_lines(unordered=False):
    rows = RECORDS if unordered else sorted(RECORDS, key=lambda r: r[3])
    return [f"{r[3]} {r[0]} {r[1]} {r[2]}" for r in rows]


def show_object(name):
    r = record(name)
    return {"name": r[0], "id": r[1], "weight": r[2], "rank": r[3], "tags": list(r[4])}


def report_bytes():
    return (T.canon([show_object(r[0]) for r in RECORDS]) + "\n").encode("utf-8")


# the scenarios: name -> the .cli content's fields (D46) — nothing here states an expected value (§3.4)
SCENARIOS = {
    "01_list":           {"args": ["list"]},
    "02_unordered":      {"args": ["list", "--unordered"]},
    "03_show_json":      {"args": ["show", "Maren", "--emit-json"], "fields": "json"},
    "04_band":           {"args": ["stat", "--band", "size", "--seed", "4"], "fields": "json", "bands": ["size"]},
    "05_exit_1":         {"args": ["show", "Zorak", "--emit-json"], "fields": "json"},
    "06_unknown_option": {"args": ["list", "--colour"]},
    "07_emit_file":      {"args": ["report", "--emit", "report.json"], "emits": ["report.json"]},
    "08_join_stdin":     {"args": ["join"], "stdin": list(STDIN_LINES)},
    "09_env":            {"args": ["list"], "env": {SALT_ENV: "9"}},
}


def design_run(name):
    """What the DESIGN says the tool does for a scenario: (exit, stdout lines, stderr lines, [(file, bytes)]).
    Computed from the table and the functions above — never by running the tool."""
    s = SCENARIOS[name]
    a = s["args"]
    salt = s.get("env", {}).get(SALT_ENV)
    files = []
    if a == ["list"]:
        out, err, rc = list_lines(), [], 0
    elif a == ["list", "--unordered"]:
        out, err, rc = list_lines(unordered=True), [], 0
    elif a[:1] == ["show"] and "--emit-json" in a:
        r = record(a[1])
        if r is None:
            out, err, rc = [], [f"fakecli: no record '{a[1]}'"], 1
        else:
            out, err, rc = [T.canon(show_object(a[1]))], [], 0
    elif a[:1] == ["stat"]:
        field = a[a.index("--band") + 1]; seed = int(a[a.index("--seed") + 1])
        out, err, rc = [T.canon({"seed": seed, field: size_of(seed)})], [], 0
    elif a == ["list", "--colour"]:
        out, err, rc = [], ["fakecli: unknown option '--colour'"], 2
    elif a[:1] == ["report"]:
        data = report_bytes(); fname = a[a.index("--emit") + 1]
        out, err, rc = [f"wrote {fname} ({len(data)} bytes)"], [], 0
        files = [(fname, data)]
    elif a == ["join"]:
        out, err, rc = [f"{i}:{line}" for i, line in enumerate(s["stdin"], start=1)], [], 0
    else:
        raise ValueError(f"the design does not describe scenario {name}")
    if salt is not None and rc == 0:
        out = out + [f"salt={salt}"]
    return rc, out, err, files


def truth_log(name):
    rc, out, err, files = design_run(name)
    s = SCENARIOS[name]
    if s.get("fields") == "json" and rc == 0:
        return T.observation(rc, fields=json.loads(out[0]), bands=s.get("bands", ()), stderr_lines=err, files=files)
    return T.observation(rc, stdout_lines=out, stderr_lines=err, files=files)


# ── chirality (BBX-15; D36 + D50) ─────────────────────────────────────────────
def docset_design():
    """fixture/docset's design table, located through the bbx package (a COPY of this generator under TMPDIR,
    as the gate's controls make, has no sibling docset — the harness it imports from does)."""
    import bbx
    root = Path(bbx.__file__).resolve().parents[3]      # lib/py/bbx/__init__.py -> the harness root
    spec = importlib.util.spec_from_file_location("mkdocset", root / "fixture" / "docset" / "mkdocset.py")
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    return m.RECORDS


def predicates(records, stdin_lines=STDIN_LINES):
    names = [r[0] for r in records]; ids = [r[1] for r in records]
    weights = [int(r[2]) for r in records]; ranks = [int(r[3]) for r in records]
    n = len(records)
    inv = {ranks[i]: i + 1 for i in range(n)}
    by_rank = [r[0] for r in sorted(records, key=lambda r: int(r[3]))]
    ds = docset_design()
    d_names = {r[0] for r in ds}; d_ids = {r[1] for r in ds}; d_weights = {int(r[2]) for r in ds}
    return [
        ("names-distinct", len(set(names)) == n),
        ("no-name-is-its-own-mirror", all(s != s[::-1] for s in names)),
        ("no-id-is-its-own-mirror", all(s != s[::-1] for s in ids)),
        ("no-id-mirror-is-another-id", all(s[::-1] not in ids for s in ids)),
        ("weights-distinct", len(set(weights)) == n),
        ("no-weight-is-its-own-mirror", all(str(w) != str(w)[::-1] for w in weights)),
        ("no-weight-mirror-is-another-weight", all(int(str(w)[::-1]) not in weights for w in weights)),
        ("ranks-are-a-permutation", sorted(ranks) == list(range(1, n + 1))),
        ("rank-permutation-is-not-its-own-inverse", any(inv.get(i + 1) != ranks[i] for i in range(n))),
        ("rank-permutation-is-not-the-reversal", any(ranks[i] != n - i for i in range(n))),
        ("rank-order-is-not-the-name-order", by_rank != sorted(names) and by_rank != sorted(names, reverse=True)),
        ("disjoint-from-docset", not (set(names) & d_names) and not (set(ids) & d_ids) and not (set(weights) & d_weights)),
        ("stdin-lines-not-sorted", list(stdin_lines) != sorted(stdin_lines) and list(stdin_lines) != sorted(stdin_lines, reverse=True)),
    ]


def failed_predicates(records, stdin_lines=STDIN_LINES):
    return [name for name, holds in predicates(records, stdin_lines) if not holds]


# ── the files ─────────────────────────────────────────────────────────────────
def toml_str(s):
    if '"' in s or "\\" in s:
        raise ValueError(f"a fixture string holds no quote and no backslash: {s!r}")
    return f'"{s}"'


def scenario_text(name):
    s = SCENARIOS[name]
    lines = ["# the scenario (R35, D46): an INVOCATION — arguments one per element (never a shell line), stdin as lines,",
             "# the files the tool must emit, the band fields, the variables the tool may see. Nothing here is an expected value.",
             "[scenario]",
             "args = [" + ", ".join(toml_str(a) for a in s["args"]) + "]"]
    if "stdin" in s:
        lines.append("stdin = [" + ", ".join(toml_str(a) for a in s["stdin"]) + "]")
    if "emits" in s:
        lines.append("emits = [" + ", ".join(toml_str(a) for a in s["emits"]) + "]")
    if "bands" in s:
        lines.append("bands = [" + ", ".join(toml_str(a) for a in s["bands"]) + "]")
    if "fields" in s:
        lines.append(f"fields = {toml_str(s['fields'])}")
    if "env" in s:
        lines += ["", "[env]"] + [f"{k} = {toml_str(v)}" for k, v in s["env"].items()]
    return "\n".join(lines) + "\n"


def files():
    """{relative path: text or bytes} — everything the fixture is."""
    out = {}
    out[f"subject/{SET}.py"] = TOOL_TEMPLATE.replace("@@RECORDS@@", repr([tuple(r) for r in RECORDS])) \
                                            .replace("@@BAND@@", repr((BAND_BASE, BAND_MUL, BAND_MOD))) \
                                            .replace("@@SALT_ENV@@", repr(SALT_ENV))
    for s in SCENARIOS:
        out[f"scenarios/{s}.cli"] = scenario_text(s)
        out[f"expected/{EXPSET}/{s}.truth"] = f'[spec]\nclass = "exact"\nbaseset = "{EXPSET}"\n'
        out[f"expected/{EXPSET}/logs/{s}.log"] = truth_log(s)
    # the unordered listing's multiset (R34's shape: one bare table per row, every field named)
    u = ["[spec]", 'class = "multiset"', f'baseset = "{EXPSET}"', 'mode = "inventory"', ""]
    for i, line in enumerate(list_lines(unordered=True), start=1):
        u += [f"[l{i}]", f"line = {toml_str(line)}", f'sha1 = "{T.sha1_text(line)}"', ""]
    out[f"expected/{EXPSET}/02_unordered.unordered"] = "\n".join(u).rstrip("\n") + "\n"
    # the JSON object's shape (R40; D49): keys in SORTED order, one type each, items for the list
    obj = show_object("Maren")
    kinds = {"str": "str", "int": "int", "list": "list"}
    sch = ["[spec]", 'class = "schema"', f'baseset = "{EXPSET}"', 'format = "json"', ""]
    for i, k in enumerate(sorted(obj), start=1):
        t = kinds[type(obj[k]).__name__]
        sch += [f"[k{i}]", f'name = "{k}"', f'type = "{t}"']
        if t == "list":
            sch += ['items_op = ">="', "items_n = 1"]
        sch.append("")
    out[f"expected/{EXPSET}/03_show_json.schema"] = "\n".join(sch).rstrip("\n") + "\n"
    # the band (R36; D48): measured over the design's seeds, inclusive; no ruling row (nothing was ever widened)
    values = [size_of(s) for s in BAND_SEEDS]
    band = ["[spec]", 'class = "band"', f'baseset = "{EXPSET}"',
            f'measured = "mkfakecli.py: size(seed) over seeds {BAND_SEEDS.start}..{BAND_SEEDS.stop - 1} of the design"', "",
            "[b1]", 'field = "size"', f"min = {min(values)}", f"max = {max(values)}"]
    out[f"expected/{EXPSET}/04_band.band"] = "\n".join(band) + "\n"
    return out


def registry_and_register(root, written):
    wkey = dir_sha1(root / "subject" / f"{SET}.py")
    reg = ("# registry.tsv — whole-set key (dir-sha1 over subject/: the tool's directory) -> expectation set.\n"
           "# Written by mkfakecli.py at generation, which is the freeze (a build decision, [BBH-67]); a changed\n"
           "# tool is an UNREGISTERED identity before any scenario runs (abstraction S2).\n"
           "# sha1\texpectation-set\tnotes\n"
           f"{wkey}\t{EXPSET}\tthe generated fixture; WHOLE-SET key (subject/*)\n")
    rows = ["# PROVENANCE.toml — the expectation register of the command-line fixture (E3; R11, R24). Every row is",
            "# class `fixture`: the truth is known to the generator, so these are evidence about no real subject.",
            "# GENERATED by mkfakecli.py — do not edit; regenerate.", ""]
    what = {"truth": "the expected observation (exact, by index)", "log": "the truth log, from the design",
            "unordered": "the multiset of stdout lines, both ways", "schema": "the JSON object's shape",
            "band": "the measured band of the field `size`"}
    i = 0
    for rel in sorted(written):
        if not rel.startswith("expected/") or rel.endswith("registry.tsv"):
            continue
        i += 1
        rows += [f"[e{i}]", f'file = "{rel[len("expected/"):]}"',
                 f'describes = "{what[rel.rsplit(".", 1)[1]]} of scenario {Path(rel).stem}"',
                 'class = "fixture"', 'refreeze = "python3 fixture/fakecli/mkfakecli.py"', ""]
    i += 1
    rows += [f"[e{i}]", 'file = "registry.tsv"', 'describes = "whole-set key of subject/ -> fixture"',
             'class = "registry"', 'refreeze = "python3 fixture/fakecli/mkfakecli.py"', ""]
    return reg, "\n".join(rows).rstrip("\n") + "\n"


def _write(p, content):
    p.parent.mkdir(parents=True, exist_ok=True)
    if isinstance(content, bytes):
        p.write_bytes(content)
    else:
        p.write_text(content)


def write_all(root):
    out = files()
    for rel, content in out.items():
        _write(root / rel, content)
    (root / "subject" / f"{SET}.py").chmod(0o755)
    reg, prov = registry_and_register(root, out)
    _write(root / "expected" / "registry.tsv", reg)
    _write(root / "expected" / "PROVENANCE.toml", prov)
    out["expected/registry.tsv"] = reg; out["expected/PROVENANCE.toml"] = prov
    return out


def read_tool_table(path):
    """The design table read back out of a tool file: the `RECORDS = [...]` literal, by ast."""
    m = re.search(r"^RECORDS = (\[.*?\])$", Path(path).read_text(), re.M | re.S)
    if not m:
        raise ValueError(f"{path} carries no RECORDS literal")
    return [tuple(r) for r in ast.literal_eval(m.group(1))]


def tool_check(tool):
    """Run the TREE's tool for every scenario under a clean environment and compare with the design.
    -> [(scenario, what differs)]"""
    diffs = []
    for name in SCENARIOS:
        s = SCENARIOS[name]
        want_rc, want_out, want_err, want_files = design_run(name)
        with tempfile.TemporaryDirectory() as cwd:
            env = {"PATH": "/usr/bin:/bin:/usr/sbin:/sbin", "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8",
                   "HOME": cwd, "TMPDIR": cwd, "PYTHONDONTWRITEBYTECODE": "1"}      # D6's set
            env.update(s.get("env", {}))
            stdin = "".join(line + "\n" for line in s.get("stdin", []))
            r = subprocess.run([sys.executable, str(tool)] + s["args"], cwd=cwd, env=env, input=stdin,
                               capture_output=True, text=True)
            got_out = r.stdout.splitlines(); got_err = r.stderr.splitlines()
            if r.returncode != want_rc:
                diffs.append((name, f"exit {r.returncode} (design {want_rc})")); continue
            for i, (g, w) in enumerate(zip(got_out, want_out), start=1):
                if g != w:
                    diffs.append((name, f"stdout line {i} differs")); break
            else:
                if len(got_out) != len(want_out):
                    diffs.append((name, f"stdout has {len(got_out)} lines (design {len(want_out)})"))
            if got_err != want_err:
                diffs.append((name, f"stderr differs ({len(got_err)} lines, design {len(want_err)})"))
            for fname, data in want_files:
                p = Path(cwd) / fname
                if not p.is_file():
                    diffs.append((name, f"emitted file {fname} not produced"))
                elif p.read_bytes() != data:
                    diffs.append((name, f"emitted file {fname} differs"))
    return diffs


def counts():
    tool = TOOL_TEMPLATE
    def quoted(line_re, word=r'"--[a-z-]+"'):
        return sum(len(re.findall(word, m)) for m in re.findall(line_re, tool, re.M))
    return {
        "records": len(RECORDS),
        "commands": quoted(r"^COMMANDS = .*$", r'"[a-z]+"'),
        "options": quoted(r"^FLAGS = .*$") + quoted(r"^OPTIONS_WITH_ARG = .*$"),
        "refusals": len(re.findall(r"^\s+refuse\(", tool, re.M)),      # the calls, never the definition
        "scenarios": len(SCENARIOS),
        "expectations": len(SCENARIOS) + 3,
        "truth_logs": len(SCENARIOS),
        "band_fields": 1,
    }


def main(argv):
    check = "--check" in argv
    bad = failed_predicates(RECORDS)
    if bad:
        print("FAIL: the DESIGN is not chiral: " + ", ".join(bad)); return 1
    if not check:
        write_all(HERE)
        print("wrote " + ", ".join(f"{k}={v}" for k, v in counts().items()))
        return 0
    tool = HERE / "subject" / f"{SET}.py"
    if not tool.is_file():
        print(f"FAIL: {tool.relative_to(HERE)} is missing"); return 1
    try:
        table = read_tool_table(tool)
    except (ValueError, SyntaxError) as e:
        print(f"FAIL: the tool's design table cannot be read: {e}"); return 1
    bad = failed_predicates(table)
    if bad:
        print(f"FAIL: chirality predicate(s) do not hold on subject/{SET}.py: " + ", ".join(bad)); return 1
    with tempfile.TemporaryDirectory() as tmp:
        fresh = write_all(Path(tmp))
        def same(rel, content):
            p = HERE / rel
            if not p.is_file():
                return False
            return (p.read_bytes() == content) if isinstance(content, bytes) else (p.read_text() == content)
        differ = [rel for rel, content in fresh.items() if not same(rel, content)]
        extra = [str(p.relative_to(HERE)) for p in HERE.rglob("*")
                 if p.is_file() and p.relative_to(HERE).parts[0] in ("subject", "scenarios", "expected")
                 and "__pycache__" not in p.parts and str(p.relative_to(HERE)) not in fresh]
    if differ or extra:
        for rel in differ: print(f"  DIFFERS  {rel}")
        for rel in extra:  print(f"  NOT-GENERATED  {rel}")
        print(f"FAIL: {len(differ)} file(s) differ from the generator, {len(extra)} not generated"); return 1
    diffs = tool_check(tool)
    if diffs:
        for name, why in diffs: print(f"  TOOL-DIFFERS  {name}: {why}")
        print(f"FAIL: the tool differs from the design in {len(diffs)} place(s)"); return 1
    print(f"  ok: every predicate holds on subject/{SET}.py; every file equals the generator's; "
          f"the tool matches the design on {len(SCENARIOS)} scenarios")
    print("NOTE: fakecli-fixture " + " ".join(f"{k}={v}" for k, v in counts().items()))
    return 0


# ── the tool's template (subject/fakecli.py) ──────────────────────────────────
TOOL_TEMPLATE = r'''#!/usr/bin/env python3
"""fakecli.py — the COMMAND-LINE FIXTURE's tool: BBX's fixture subject of kind B (docs/generality.md;
docs/plans/S4.md §4). GENERATED by mkfakecli.py — do not edit; regenerate.

Deterministic: a function of its arguments, its stdin and the ONE environment variable it declares —
and nothing else. Every feature is an OPTION (a tool's contract is its command line):

    fakecli.py list [--unordered]                 one line per record, `<rank> <name> <id> <weight>`,
                                                  by rank; --unordered in the table's own order
    fakecli.py show <name> [--emit-json]          the record as `<key>=<value>` lines, or as ONE JSON object
    fakecli.py stat --band <field> --seed <n>     ONE JSON object {"seed": n, "<field>": size(n)}: the
                                                  field varies with the seed inside a designed band
    fakecli.py join                               every stdin line prefixed with its index, `<i>:<line>`
    fakecli.py report --emit <file>               writes <file> (the records as JSON) and says so
  feature options (any command):
    --nondet          appends `now=<nanoseconds>` — the clock mixed in (the NONDETERMINISTIC control)
    --crash-at <n>    dies by SIGKILL after the n-th stdout line (the guard's control; it died by SIGABRT
                      until R42, which the HOST reported as a crash on every run — outside the sandbox)
    --write-home      writes $HOME/.fakecli first (the sandbox control)
    --sleep <s>       sleeps s seconds first (the timeout control)
  refusals (SMS cliguard's shape: one stderr line naming the thing, exit 2; an unknown record exit 1):
    an unknown option; an option without its value; no command; an unknown command; show with no name
  the environment: FAKECLI_SALT, when SEEN, appends `salt=<value>` — the control that the driver's scrub
    is measured (called directly: differs; through the driver: identical; through the scenario's [env]:
    reaches the tool)
"""
import json
import os
import signal
import sys
import time

RECORDS = @@RECORDS@@
BAND_BASE, BAND_MUL, BAND_MOD = @@BAND@@
SALT_ENV = @@SALT_ENV@@
COMMANDS = ("list", "show", "stat", "join", "report")
FLAGS = ("--nondet", "--write-home", "--emit-json", "--unordered")
OPTIONS_WITH_ARG = ("--crash-at", "--seed", "--emit", "--band", "--sleep")


def refuse(message, status):
    sys.stdout.flush()
    sys.stderr.write(f"fakecli: {message}\n")
    sys.exit(status)


class Out:
    """stdout, one line at a time, flushed — so a crash after n lines leaves exactly n lines behind."""
    def __init__(self, crash_at):
        self.n = 0
        self.crash_at = crash_at

    def line(self, text):
        sys.stdout.write(text + "\n")
        sys.stdout.flush()
        self.n += 1
        if self.crash_at is not None and self.n >= self.crash_at:
            os.kill(os.getpid(), signal.SIGKILL)   # not os.abort(): SIGABRT makes the host write a crash report (R42)


def parse(argv):
    opts, pos = {}, []
    i = 0
    while i < len(argv):
        a = argv[i]
        if a.startswith("--"):
            if a in FLAGS:
                opts[a] = True
            elif a in OPTIONS_WITH_ARG:
                if i + 1 >= len(argv):
                    refuse(f"option '{a}' needs a value", 2)
                opts[a] = argv[i + 1]
                i += 1
            else:
                refuse(f"unknown option '{a}'", 2)
        else:
            pos.append(a)
        i += 1
    return opts, pos


def as_object(r):
    return {"name": r[0], "id": r[1], "weight": r[2], "rank": r[3], "tags": list(r[4])}


def canon(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def main(argv):
    opts, pos = parse(argv)
    if not pos:
        refuse("no command", 2)
    cmd = pos[0]
    if cmd not in COMMANDS:
        refuse(f"unknown command '{cmd}'", 2)
    if "--sleep" in opts:
        time.sleep(int(opts["--sleep"]))
    if "--write-home" in opts:
        with open(os.path.join(os.environ.get("HOME", "."), ".fakecli"), "w") as fh:
            fh.write("visited\n")
    out = Out(int(opts["--crash-at"]) if "--crash-at" in opts else None)
    if cmd == "list":
        rows = RECORDS if "--unordered" in opts else sorted(RECORDS, key=lambda r: r[3])
        for r in rows:
            out.line(f"{r[3]} {r[0]} {r[1]} {r[2]}")
    elif cmd == "show":
        if len(pos) < 2:
            refuse("show needs a name", 2)
        hits = [r for r in RECORDS if r[0] == pos[1]]
        if not hits:
            refuse(f"no record '{pos[1]}'", 1)
        obj = as_object(hits[0])
        if "--emit-json" in opts:
            out.line(canon(obj))
        else:
            for k in ("name", "id", "weight", "rank", "tags"):
                out.line(f"{k}={obj[k] if k != 'tags' else ','.join(obj[k])}")
    elif cmd == "stat":
        seed = int(opts.get("--seed", "1"))
        field = opts.get("--band", "size")
        out.line(canon({"seed": seed, field: BAND_BASE + (seed * BAND_MUL) % BAND_MOD}))
    elif cmd == "join":
        for i, line in enumerate(sys.stdin.read().splitlines(), start=1):
            out.line(f"{i}:{line}")
    elif cmd == "report":
        if "--emit" not in opts:
            refuse("report needs --emit <file>", 2)
        data = (canon([as_object(r) for r in RECORDS]) + "\n").encode("utf-8")
        with open(opts["--emit"], "wb") as fh:
            fh.write(data)
        out.line(f"wrote {opts['--emit']} ({len(data)} bytes)")
    if "--nondet" in opts:
        out.line(f"now={time.time_ns()}")
    salt = os.environ.get(SALT_ENV)
    if salt is not None:
        out.line(f"salt={salt}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
'''

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

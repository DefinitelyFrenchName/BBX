#!/usr/bin/env python3
"""mkunittest.py — the UNITTEST ADAPTER FIXTURE's generator (docs/plans/S4.md §4; R37, R15).

    python3 fixture/unittest/mkunittest.py            write the fixture under this directory
    python3 fixture/unittest/mkunittest.py --check    (1) every chirality predicate holds on the DESIGN and
                                                      on the tree's package (its case list read back out of
                                                      the test modules); (2) the tree's fixture equals what
                                                      this script writes, regenerated under TMPDIR and
                                                      diffed; (3) the FRAMEWORK-CHECK: the tree's package,
                                                      run by `python3 -m unittest -v` for every scenario
                                                      under a clean environment, reports the cases and the
                                                      exit the DESIGN says — non-zero naming the predicate,
                                                      the file, or the scenario and what differs

WHAT IT WRITES, from the DESIGN below and nothing else:
  subject/cases/shapes.py        the MODULE UNDER TEST (the program key): deterministic, asymmetric by
                                 construction — a quarter-turn map that is not a mirror and an ordered span
  subject/cases/test_shapes.py   4 cases over it: 3 `ok` and, at index 2 of 4, one that FAILS BY DESIGN
  subject/cases/test_verdicts.py 4 cases covering the rest of the closed vocabulary: xfail, ERROR, xpass, skip
  scenarios/<s>.cli              four INVOCATIONS (D46's grammar, R35): `args` are the module names or one
                                 dotted test id; no stdin, no emits, no bands, no fields — a framework's
                                 report is not a JSON object and its artefacts are not declared files
  expected/derived/<s>.truth     the spec `exact derived`: the run's log compared BY INDEX against
  expected/derived/logs/<s>.log     the TRUTH log — every token written from the DESIGN through
                                 lib/py/bbx/cli.py's vocabulary (D47, D58), never by running the framework
  expected/registry.tsv          the WHOLE-SET key of subject/cases (dir-sha1) -> `derived`
  expected/PROVENANCE.toml       every expectation and truth log, class `derived`; the registry row `registry`

WHY `derived` AND NOT `fixture` (R11's ranked vocabulary, E3): the verdict of a case is not a value this
generator invents — it follows from the framework's own documented contract applied to a test the design
writes (an assertion that holds is `ok`, one that does not is `FAIL`, a raise is `ERROR`, `@skip` is
`skip`, `@expectedFailure` is `xfail` when it fails and `xpass` when it does not) and the exit status
follows from the same contract (0 only when every case is ok, skip or xfail). The truth is DERIVED from a
contract outside the artifact under test, which is what §3.4 asks for; `fixture` would understate it and
`self` would be a freeze of the adapter's own answer (BBX-3).

CHIRAL BY CONSTRUCTION (BBX-15): the module under test is a quarter turn, so `tilt(tilt(x))` is never `x`
and a mirror error cannot hide; `span` is ordered, so an argument swap changes the sign; the designed FAIL
sits at index 2 of 4, neither first nor last, so an off-by-one at either end of the token list cannot hide;
and the package's verdict sequence is neither constant, nor sorted, nor its own reverse. Every predicate is
named when it fails (gates/adapters.sh's control `symmetric-fixture`).
"""
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "lib" / "py"))
from bbx import cli as T              # noqa: E402  (the token vocabulary, D47/D58)
from bbx.fingerprint import dir_sha1  # noqa: E402

SET = "cases"                          # the package is subject/<set>/ (a DIRECTORY: the adapters' resolver)
EXPSET = "derived"
# ── the design: (module, case, verdict) in the order `unittest` prints them (it sorts by name) ──────────
CASES = [
    ("test_shapes",   "test_a_tilt_turns_once",     "ok"),
    ("test_shapes",   "test_b_designed_red",        "FAIL"),      # FAILS BY DESIGN, at index 2 of 4
    ("test_shapes",   "test_c_tilt_is_no_mirror",   "ok"),
    ("test_shapes",   "test_d_span_is_ordered",     "ok"),
    ("test_verdicts", "test_e_expected_red",        "xfail"),
    ("test_verdicts", "test_f_error_raises",        "ERROR"),
    ("test_verdicts", "test_g_unexpected_green",    "xpass"),
    ("test_verdicts", "test_h_skipped",             "skip"),
]
# (name, the modules or dotted ids the scenario runs, the cases it must report)
SCENARIOS = [
    ("01_shapes",   ["test_shapes"],                   [c for c in CASES if c[0] == "test_shapes"]),
    ("02_verdicts", ["test_verdicts"],                 [c for c in CASES if c[0] == "test_verdicts"]),
    ("03_both",     ["test_shapes", "test_verdicts"],  CASES),
    ("04_one_case", ["test_shapes.T.test_a_tilt_turns_once"], [CASES[0]]),
]
GREEN_VERDICTS = ("ok", "skip", "xfail")   # the framework's contract: anything else makes the run fail


def exit_of(cases):
    """The framework's exit status, from its contract and not from a run: 0 only when every case is ok,
    skip or xfail; 1 when any is FAIL, ERROR or xpass."""
    return 0 if all(v in GREEN_VERDICTS for _, _, v in cases) else 1


# ── the design's predicates (BBX-15) ─────────────────────────────────────────
def failed_predicates(cases):
    bad = []
    names = [c for _, c, _ in cases]
    if len(set(names)) != len(names):
        bad.append("case names repeat")
    verdicts = [v for _, _, v in cases]
    if len(set(verdicts)) == 1:
        bad.append("the verdict sequence is constant")
    if verdicts == sorted(verdicts) or verdicts == sorted(verdicts, reverse=True):
        bad.append("the verdict sequence is in sorted order (an order error could hide)")
    if verdicts == verdicts[::-1]:
        bad.append("the verdict sequence is its own reverse")
    if set(verdicts) != set(T.CASE_VERDICTS):
        missing = [w for w in T.CASE_VERDICTS if w not in verdicts]
        bad.append(f"the closed vocabulary is not covered: {', '.join(missing)} unexercised")
    shapes = [v for m, _, v in cases if m == "test_shapes"]
    if "FAIL" not in shapes:
        bad.append("no case FAILS by design (the observation would carry no red token)")
    elif shapes.index("FAIL") in (0, len(shapes) - 1):
        bad.append("the designed FAIL is first or last in its module (an off-by-one could hide)")
    if [c for _, c, _ in cases] != sorted(c for _, c, _ in cases):
        bad.append("the case names do not sort into the designed order (unittest sorts by name)")
    return bad


# ── the files ────────────────────────────────────────────────────────────────
SHAPES = '''"""shapes.py — the module under test, written by mkunittest.py from the design. Deterministic and
ASYMMETRIC by construction (BBX-15): the turn is a quarter, never a mirror, and the span is ordered."""
TURN = {"n": "e", "e": "s", "s": "w", "w": "n"}


def tilt(course):
    """One quarter turn per step: tilt(tilt(x)) is never x, so a mirrored implementation cannot pass."""
    return "".join(TURN[c] for c in course)


def span(a, b):
    """b - a: ordered, so swapping the arguments changes the sign rather than nothing."""
    return b - a
'''

TEST_SHAPES = '''"""test_shapes.py — 4 cases over shapes.py, written by mkunittest.py from the design.
ONE OF THEM FAILS BY DESIGN (test_b_designed_red): the adapter's business is to REPORT what the framework
said, so a red case is an OBSERVATION the frozen truth expects, never a defect of this fixture (R37)."""
import unittest

from shapes import span, tilt


class T(unittest.TestCase):
    def test_a_tilt_turns_once(self):
        self.assertEqual(tilt("nesw"), "eswn")

    def test_b_designed_red(self):
        # FAILS BY DESIGN: a quarter turn of "n" is "e". The truth log carries `case:FAIL:<sha1>` here.
        self.assertEqual(tilt("n"), "n")

    def test_c_tilt_is_no_mirror(self):
        self.assertNotEqual(tilt("ne"), "en")

    def test_d_span_is_ordered(self):
        self.assertEqual(span(3, 11), 8)
        self.assertEqual(span(11, 3), -8)
'''

TEST_VERDICTS = '''"""test_verdicts.py — 4 cases covering the rest of the closed verdict vocabulary (D58), written by
mkunittest.py from the design: xfail, ERROR, xpass, skip. Every one of them is deliberate."""
import unittest

from shapes import span


class V(unittest.TestCase):
    @unittest.expectedFailure
    def test_e_expected_red(self):
        self.assertEqual(span(1, 2), 99)          # fails, and is expected to: `xfail`

    def test_f_error_raises(self):
        span("a", 1)                              # TypeError, never an assertion: `ERROR`

    @unittest.expectedFailure
    def test_g_unexpected_green(self):
        self.assertEqual(span(1, 2), 1)           # passes although expected to fail: `xpass`

    @unittest.skip("the designed skip")
    def test_h_skipped(self):
        self.fail("never reached")                # `skip` — and SKIP IS NOT PASS (BBX-1)
'''

SCEN_HEAD = ("# the scenario (R35, D46): an INVOCATION — the modules `python3 -m unittest -v` is asked to run,\n"
             "# one per element. Nothing here is an expected value; the framework's verdicts are the observation.\n")


def scenario_text(args):
    return SCEN_HEAD + "[scenario]\nargs = [" + ", ".join(f'"{a}"' for a in args) + "]\n"


def truth_log(cases):
    """The truth log, from the DESIGN: the exit the contract gives, one token per designed case, END n."""
    return T.observation_tokens(exit_of(cases), [T.token_case(c, v) for _, c, v in cases])


def files():
    out = {f"subject/{SET}/shapes.py": SHAPES,
           f"subject/{SET}/test_shapes.py": TEST_SHAPES,
           f"subject/{SET}/test_verdicts.py": TEST_VERDICTS,
           "bbx.toml": BBX_TOML}
    for name, args, cases in SCENARIOS:
        out[f"scenarios/{name}.cli"] = scenario_text(args)
        out[f"expected/{EXPSET}/{name}.truth"] = f'[spec]\nclass = "exact"\nbaseset = "{EXPSET}"\n'
        out[f"expected/{EXPSET}/logs/{name}.log"] = truth_log(cases)
    return out


BBX_TOML = f'''# bbx.toml — the UNITTEST ADAPTER FIXTURE's consumer config: BBX's fourth consumer (docs/plans/S4.md §4).
# The kind is `command-line` — an adapter is a DRIVER of that kind (D7), so the profile, the scenario
# extension, the driver family and the kinds table are the ones step 1 ratified; only the driver differs.
# Paths are relative to this file's directory. GENERATED by mkunittest.py (--check).

[project]
root = "."
kind = "command-line"

[suite]
replays_dir = "scenarios"       # <name>.cli (R32, R35)
expected_dir = "expected"
registry = "expected/registry.tsv"
default_set = "{SET}"           # the package: subject/{SET}/ — a DIRECTORY, resolved by bbx.adapters
driver = "unittest"             # $BBX_HOME/drivers/unittest.sh (D28; R26's driver home)

[fingerprint]
kind = "file-sha1"
file_pattern = "{{set}}/shapes.py"   # the program key is the MODULE UNDER TEST; the whole-set key is the
                                     # package directory (dir-sha1 over subject/{SET}/*), so a changed test
                                     # module is an unregistered identity before any scenario runs [BBH-67]
'''


def registry_and_register(root, written):
    wkey = dir_sha1(root / "subject" / SET / "shapes.py")
    reg = ("# registry.tsv — whole-set key (dir-sha1 over subject/cases/: the package directory) -> expectation set.\n"
           "# Written by mkunittest.py at generation, which is the freeze (a build decision, [BBH-67]); a changed\n"
           "# module OR test module is an UNREGISTERED identity before any scenario runs (abstraction S2).\n"
           "# sha1\texpectation-set\tnotes\n"
           f"{wkey}\t{EXPSET}\tthe generated package; WHOLE-SET key (subject/{SET}/*)\n")
    rows = ["# PROVENANCE.toml — the expectation register of the unittest adapter fixture (E3; R11, R24).",
            "# Every row is class `derived`: the verdicts and the exit follow from the FRAMEWORK'S OWN CONTRACT",
            "# applied to a test the design writes, not from a run of the adapter (which would be `self`) and not",
            "# from a value this fixture invents (which would be `fixture`). GENERATED by mkunittest.py.", ""]
    what = {"truth": "the expected observation (exact, by index)", "log": "the truth log, from the design"}
    i = 0
    for rel in sorted(written):
        if not rel.startswith("expected/") or rel.endswith("registry.tsv"):
            continue
        i += 1
        rows += [f"[e{i}]", f'file = "{rel[len("expected/"):]}"',
                 f'describes = "{what[rel.rsplit(".", 1)[1]]} of scenario {Path(rel).stem}"',
                 'class = "derived"', 'refreeze = "python3 fixture/unittest/mkunittest.py"', ""]
    i += 1
    rows += [f"[e{i}]", 'file = "registry.tsv"', f'describes = "whole-set key of subject/{SET}/ -> {EXPSET}"',
             'class = "registry"', 'refreeze = "python3 fixture/unittest/mkunittest.py"', ""]
    return reg, "\n".join(rows).rstrip("\n") + "\n"


def write_all(root):
    out = files()
    for rel, content in out.items():
        p = root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content)
    reg, prov = registry_and_register(root, out)
    for rel, content in (("expected/registry.tsv", reg), ("expected/PROVENANCE.toml", prov)):
        (root / rel).write_text(content)
        out[rel] = content
    return out


def read_package_cases(pkg):
    """The case list read back OUT of the tree's package: the class-body `def test_*` names per module, in
    sorted order (which is the order the framework prints), each with the verdict its decorators and body
    declare — so a hand-edited module is named rather than trusted."""
    found = []
    for mod in ("test_shapes", "test_verdicts"):
        text = (pkg / f"{mod}.py").read_text()
        for m in re.finditer(r"^    (?:@unittest\.(skip|expectedFailure)\([^\n]*\)\n    |@unittest\.(expectedFailure)\n    )?def (test_\w+)", text, re.M):
            deco, deco2, name = m.group(1), m.group(2), m.group(3)
            body = text[m.end():].split("\n    def ")[0]
            if deco == "skip":
                verdict = "skip"
            elif deco2 == "expectedFailure" or deco == "expectedFailure":
                verdict = "xpass" if "span(1, 2), 1)" in body else "xfail"
            elif "TypeError" in body or 'span("a", 1)' in body:
                verdict = "ERROR"
            elif "FAILS BY DESIGN" in body:
                verdict = "FAIL"
            else:
                verdict = "ok"
            found.append((mod, name, verdict))
    return sorted(found, key=lambda c: c[1])


def framework_check(pkg):
    """The FRAMEWORK-CHECK (the fixture's own BBX-5 pairing): the design is the author, the framework is the
    artifact. Run the tree's package for every scenario under a clean environment and compare the cases and
    the exit with the design — never through the driver, so this check and the driver are not one thing."""
    bad = []
    for name, args, cases in SCENARIOS:
        with tempfile.TemporaryDirectory() as td:
            env = {"PATH": "/usr/bin:/bin:/usr/sbin:/sbin", "HOME": td, "TMPDIR": td,
                   "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8", "PYTHONPATH": str(pkg),
                   "PYTHONDONTWRITEBYTECODE": "1"}
            p = subprocess.run([sys.executable, "-m", "unittest", "-v"] + args, cwd=td, env=env,
                              capture_output=True, text=True)
        report = p.stderr + p.stdout
        got = [(c, v) for c, v in _parse(report)]
        want = [(c, v) for _, c, v in cases]
        if got != want:
            bad.append(f"{name}: the framework reported {got} where the design says {want}")
        if p.returncode != exit_of(cases):
            bad.append(f"{name}: the framework exited {p.returncode} where the contract gives {exit_of(cases)}")
        if not re.search(rf"^Ran {len(cases)} tests? in ", report, re.M):
            bad.append(f"{name}: no `Ran {len(cases)} tests` line in the framework's report")
    return bad


def _parse(report):
    for line in report.split("\n"):
        m = re.match(r"^(\S+) \((\S+)\) \.\.\. (.+)$", line)
        if not m:
            continue
        tail = m.group(3).strip()
        v = {"ok": "ok", "FAIL": "FAIL", "ERROR": "ERROR", "expected failure": "xfail",
             "unexpected success": "xpass"}.get(tail, "skip" if tail.startswith("skipped") else None)
        yield m.group(1), v


def counts():
    return {"cases": len(CASES), "modules": len({m for m, _, _ in CASES}),
            "scenarios": len(SCENARIOS), "verdict_words": len({v for _, _, v in CASES}),
            "expectations": len(SCENARIOS), "truth_logs": len(SCENARIOS)}


def main(argv):
    check = "--check" in argv
    bad = failed_predicates(CASES)
    if bad:
        print("FAIL: the DESIGN is not chiral: " + ", ".join(bad)); return 1
    if not check:
        write_all(HERE)
        print("wrote " + ", ".join(f"{k}={v}" for k, v in counts().items()))
        return 0
    pkg = HERE / "subject" / SET
    for mod in ("shapes.py", "test_shapes.py", "test_verdicts.py"):
        if not (pkg / mod).is_file():
            print(f"FAIL: subject/{SET}/{mod} is missing"); return 1
    table = read_package_cases(pkg)
    if table != CASES:
        print(f"FAIL: the package's case list is not the design's: {table} != {CASES}"); return 1
    bad = failed_predicates(table)
    if bad:
        print(f"FAIL: chirality predicate(s) do not hold on subject/{SET}: " + ", ".join(bad)); return 1
    with tempfile.TemporaryDirectory() as tmp:
        fresh = write_all(Path(tmp))
        def same(rel, content):
            p = HERE / rel
            return p.is_file() and p.read_text() == content
        differ = [rel for rel, content in fresh.items() if not same(rel, content)]
        extra = [str(p.relative_to(HERE)) for p in HERE.rglob("*")
                 if p.is_file() and p.relative_to(HERE).parts[0] in ("subject", "scenarios", "expected")
                 and "__pycache__" not in p.parts and str(p.relative_to(HERE)) not in fresh]
    if differ or extra:
        for rel in differ:
            print(f"  DIFFERS  {rel}")
        for rel in extra:
            print(f"  EXTRA    {rel}")
        print("FAIL: the tree's fixture is not what mkunittest.py writes (regenerate, never hand-edit — BBX-21)")
        return 1
    bad = framework_check(pkg)
    if bad:
        for b in bad:
            print(f"  FRAMEWORK  {b}")
        print("FAIL: the framework does not report what the design says")
        return 1
    print("check ok: the design is chiral, the package is the design's, the tree equals what this script "
          "writes, and the framework reports " + ", ".join(f"{k}={v}" for k, v in counts().items()))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

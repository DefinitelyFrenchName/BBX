#!/usr/bin/env python3
"""adapters.py — THE TWO FRAMEWORK ADAPTERS, over the same core as the command-line driver.

  python3 -m bbx.adapters resolve  <set>                                  the set DIRECTORY on CLI_PATH
  python3 -m bbx.adapters selftest                                        before every run
  python3 -m bbx.adapters unittest <set-dir> <scenario.cli> <out> <sandbox> [--nondet] [--timeout <s>]
  python3 -m bbx.adapters gates    <set-dir> <scenario.cli> <out> <sandbox> [--nondet] [--timeout <s>]

Both are drivers of the COMMAND-LINE kind (docs/plans/S4.md §3 "D7"; R37, R15) and share `bbx.cli`'s
core — `prepare_sandbox`, `exec_in_sandbox` (D6's hermetic set, the sandbox as HOME and TMPDIR, the
recording O5, the timeout), the token writers and the log grammar D47. With `drivers/cli.sh` that core
has three consumers, which is BBX-25 with one to spare.

THE FRAMEWORK'S VERDICT IS AN OBSERVATION, NEVER A BBX VERDICT (R37, D7). A failing test is
`case:FAIL:<sha1>` and PASSes against a truth that expects it; a red gate is `gate:FAIL:<sha1>` the
same way. What the adapter asserts is that the framework RAN and what it reported, never that the
report was good — the comparison against a frozen truth is the harness's, one layer up.

Both refuse rather than guess: a verdict word outside the closed vocabulary (D58), a `Ran <n>` count
that disagrees with the lines seen, a run that produced no rows, a placeholder the grammar does not
have. `Ran 0 tests` and a kept run with zero rows are exit 1 DISCARDED — a green over nothing is not
a PASS (BBX-7).

NOT ASSERTED by either adapter: the framework's own correctness; the DETAIL behind a verdict (a
traceback, a gate's printed lines, the `detail` column of a kept run); anything the framework timed
(`Ran 2 tests in 0.003s`, the `seconds` column) — a clock in an observation is a nondeterminism the
harness would blame on the subject.
"""
import os
import re
import sys
from pathlib import Path

from . import cli
from .cli import Crashed, Refused, Unreadable

# the per-case line of `python3 -m unittest -v`: `<name> (<module.Class>) ... <tail>` (measured, bbx-18)
CASE_RE = re.compile(r"^(\S+) \((\S+)\) \.\.\. (.+)$")
RAN_RE = re.compile(r"^Ran (\d+) tests? in ")
# the framework's own words -> the closed vocabulary (cli.CASE_VERDICTS). `skipped '<reason>'` keeps no
# reason: the reason is the module's prose, not an observation of the run.
CASE_TAILS = (("ok", "ok"), ("FAIL", "FAIL"), ("ERROR", "ERROR"),
              ("expected failure", "xfail"), ("unexpected success", "xpass"))
PLACEHOLDERS = ("{config}", "{log}", "{set}")     # what a gates scenario may ask the driver to fill in
PLACEHOLDER_RE = re.compile(r"\{[a-z_]+\}")


def bbx_home():
    """The harness's own root, from the environment or from THIS file's place in it — never from the
    caller's cwd (a consumer copied under TMPDIR has no harness beside it)."""
    return Path(os.environ.get("BBX_HOME") or Path(__file__).resolve().parents[3])


def resolve_set(set_name, search_path, cwd=None):
    """The DIRECTORY `<set>` on the `;`-separated search path (the adapters' set is a directory where the
    command-line driver's is a file), each component made ABSOLUTE; the first that has it wins."""
    if not search_path:
        raise Unreadable(f"set CLI_PATH to the directory holding the {set_name}/ directory")
    if not set_name or "/" in set_name:
        raise Unreadable(f"a set is a name on CLI_PATH, never a path: {set_name!r}")
    base = Path(cwd or Path.cwd())
    for comp in search_path.split(";"):
        if not comp:
            continue
        if comp.startswith("/"):
            d = Path(comp)
        else:
            d = base / comp
            if not d.is_dir():
                raise Unreadable(f"search-path component '{comp}' does not resolve from {base}")
            d = d.resolve()
        cand = d / set_name
        if cand.is_dir():
            return str(cand)
    raise Unreadable(f"no directory {set_name} on CLI_PATH={search_path}")


# ── the unittest adapter ─────────────────────────────────────────────────────
def parse_cases(text):
    """[(case name, verdict)] from the framework's OUTPUT, in the order printed. The case name is the
    line's FIRST field; the verdict comes from the closed map. A per-case line whose tail is outside it
    is Unreadable — the adapter never invents a word for what a framework told it."""
    cases = []
    for line in text.split("\n"):
        m = CASE_RE.match(line)
        if not m:
            continue
        name, tail = m.group(1), m.group(3).strip()
        verdict = None
        for word, token in CASE_TAILS:
            if tail == word:
                verdict = token
                break
        if verdict is None and tail.startswith("skipped"):
            verdict = "skip"
        if verdict is None:
            raise Unreadable(f"the framework reported a verdict this adapter has no word for: {tail!r} "
                             f"(case {name}); the closed vocabulary is {', '.join(cli.CASE_VERDICTS)} "
                             f"— the run is DISCARDED rather than mapped to the nearest word")
        cases.append((name, verdict))
    return cases


def ran_count(text):
    """The `Ran <n> tests in <t>s` line's COUNT, by name, never the line (it carries a clock)."""
    for line in text.split("\n"):
        m = RAN_RE.match(line)
        if m:
            return int(m.group(1))
    return None


def run_unittest(set_dir, scenario_path, out, sandbox, nondet=False, timeout=cli.DEFAULT_TIMEOUT):
    """One unittest run over the package at `set_dir`; the scenario's `args` are the module names."""
    sc = cli.load_scenario(scenario_path)
    if not sc.args:
        raise Refused("a unittest scenario with no args", "its [scenario].args name the modules to run (D58)")
    for key, why in (("emits", "a test framework's artefacts are not declared files"),
                     ("bands", "a framework's report has no numeric band"),
                     ("fields", "a framework's report is not one JSON object")):
        if getattr(sc, key):
            raise Refused(f"scenario key '{key}'", f"the unittest adapter cannot honour it: {why} (D58)")
    set_dir = Path(set_dir).resolve()
    out = Path(out)
    if out.exists():                                         # D5, [BBH-27]
        out.unlink()
    sandbox, cwd = cli.prepare_sandbox(sc, sandbox)
    salt = f"|{cli.time.time_ns()}" if nondet else ""
    argv = [sys.executable, "-m", "unittest", "-v"] + sc.args
    # the package must be importable while the WORKING DIRECTORY stays the sandbox, so the set directory
    # reaches the subject as PYTHONPATH and nothing else does (PYTHONDONTWRITEBYTECODE is already in D6's
    # set, so the fixture keeps no __pycache__)
    status, stdout_text, stderr_text = cli.exec_in_sandbox(
        argv, sc, sandbox, cwd, timeout, extra_env={"PYTHONPATH": str(set_dir)},
        what="the framework", subject="python3 -m unittest")
    report = stderr_text + stdout_text                       # measured: unittest writes its report to STDERR
    cases = parse_cases(report)
    tokens = [cli.token_case(n, v, salt) for n, v in cases]
    if status < 0:
        out.write_text(cli.crash_tokens(-status, tokens), encoding="utf-8")
        raise Crashed(f"the framework died by signal {-status} ({cli.signal_name(-status)}) after "
                      f"{len(tokens)} cases: exit 2, the log {out} is the bug report (END-CRASH)")
    ran = ran_count(report)
    if ran is None:
        raise Unreadable("the framework printed no `Ran <n> tests` line: nothing says how many cases it "
                         "meant to run, so the run is DISCARDED")
    if ran != len(cases):
        raise Unreadable(f"the framework reported `Ran {ran} tests` and printed {len(cases)} per-case "
                         f"lines: the two disagree, so the run is DISCARDED")
    if ran == 0:
        raise Unreadable("`Ran 0 tests`: a green over nothing is DISCARDED, never a PASS (BBX-7) — "
                         "the framework exits 0 with OK, which is exactly why this is exit 1")
    out.write_text(cli.observation_tokens(status, tokens), encoding="utf-8")
    return status


# ── the gates adapter (R14: BBX's own runners as a subject) ──────────────────
def read_results(path):
    """The kept run's rows as dicts BY COLUMN NAME (BBX-12), never by position."""
    try:
        lines = Path(path).read_text(encoding="utf-8").splitlines()
    except OSError:
        raise Unreadable(f"the runner kept no {path.name} under the sandbox: nothing to observe, the run "
                         f"is DISCARDED")
    if not lines:
        raise Unreadable(f"{path} is empty: the run is DISCARDED")
    header = lines[0].split("\t")
    for need in ("gate", "verdict"):
        if need not in header:
            raise Unreadable(f"{path} has no '{need}' column (columns: {', '.join(header)}): the adapter "
                             f"reads by column NAME and refuses to guess a position")
    return [dict(zip(header, l.split("\t"))) for l in lines[1:] if l.strip()]


def fill(args, mapping):
    """The scenario's args with `{config}`, `{log}` and `{set}` filled in; an unknown `{…}` is REFUSED, so
    nothing is appended behind the scenario's back and nothing is silently left literal."""
    out = []
    for a in args:
        for m in PLACEHOLDER_RE.findall(a):
            if m not in PLACEHOLDERS:
                raise Refused(f"scenario placeholder '{m}'", f"the grammar has {', '.join(PLACEHOLDERS)} (D58)")
        for k, v in mapping.items():
            a = a.replace(k, v)
        out.append(a)
    return out


def resolve_program(name):
    """The harness program the scenario names, under $BBX_HOME/bin and nowhere else: a name that is not a
    file there is REFUSED, never looked up on a PATH."""
    if "/" in name:
        raise Refused(f"program '{name}'", "a gates scenario names a program in $BBX_HOME/bin, never a path (D58)")
    p = bbx_home() / "bin" / name
    if not (p.is_file() and os.access(p, os.X_OK)):
        raise Refused(f"program '{name}'", f"it is not an executable file in {bbx_home() / 'bin'} (D58)")
    return str(p)


def run_gates(set_dir, scenario_path, out, sandbox, nondet=False, timeout=cli.DEFAULT_TIMEOUT):
    """One run of a harness runner over the consumer at `set_dir`; the scenario's first arg is the
    program, the rest its arguments with the placeholders filled in."""
    sc = cli.load_scenario(scenario_path)
    if not sc.args:
        raise Refused("a gates scenario with no args", "its first arg is the program under $BBX_HOME/bin (D58)")
    for key, why in (("emits", "a runner's artefacts are the kept run the scenario asks for"),
                     ("bands", "a kept run has no numeric band"),
                     ("fields", "a kept run is not one JSON object")):
        if getattr(sc, key):
            raise Refused(f"scenario key '{key}'", f"the gates adapter cannot honour it: {why} (D58)")
    set_dir = Path(set_dir).resolve()
    out = Path(out)
    if out.exists():
        out.unlink()
    sandbox, cwd = cli.prepare_sandbox(sc, sandbox)
    logdir = sandbox / "run"
    salt = f"|{cli.time.time_ns()}" if nondet else ""
    argv = [resolve_program(sc.args[0])] + fill(sc.args[1:], {
        "{config}": str(set_dir / "bbx.toml"), "{log}": str(logdir), "{set}": str(set_dir)})
    status, stdout_text, stderr_text = cli.exec_in_sandbox(
        argv, sc, sandbox, cwd, timeout, what="the runner", subject=sc.args[0])
    if status < 0:
        out.write_text(cli.crash_tokens(-status, []), encoding="utf-8")
        raise Crashed(f"the runner died by signal {-status} ({cli.signal_name(-status)}): exit 2, the log "
                      f"{out} is the bug report (END-CRASH)")
    rows = read_results(logdir / "results.tsv")
    if not rows:
        raise Unreadable("the kept run has zero gate rows: a green over nothing is DISCARDED, never a "
                         "PASS (BBX-7)")
    tokens = [cli.token_gate(r["gate"], r["verdict"], salt) for r in rows]
    out.write_text(cli.observation_tokens(status, tokens), encoding="utf-8")
    return status


# ── the self-test (before every run, like the core's) ────────────────────────
_REPORT = ("test_a_ok (test_shapes.T) ... ok\n"
           "test_b_fails (test_shapes.T) ... FAIL\n"
           "test_c_errors (test_shapes.T) ... ERROR\n"
           "test_d_skipped (test_shapes.T) ... skipped 'by design'\n"
           "test_e_xfail (test_shapes.T) ... expected failure\n"
           "test_f_xpass (test_shapes.T) ... unexpected success\n"
           "\n======================================================================\n"
           "FAIL: test_b_fails (test_shapes.T)\n"
           "----------------------------------------------------------------------\n"
           "Traceback (most recent call last):\n"
           "  File \"/tmp/x/test_shapes.py\", line 5, in test_b_fails\n"
           "AssertionError: 2 != 3\n\n"
           "Ran 6 tests in 0.001s\n\nFAILED (failures=1, errors=1, skipped=1, expected failures=1, unexpected successes=1)\n")
_RESULTS = "gate\ttier\tverdict\tseconds\texit\tdetail\ng1\tportable\tPASS\t1\t0\t\ng6\tportable\tMISSING\t0\t-\tregistered but not executable\n"


def selftest(workdir=None):
    """What must hold before a framework is run at all. Every check is a KNOWN POSITIVE and a KNOWN
    NEGATIVE: an instrument that cannot fail is not evidence (BBX-5, §1)."""
    bad = []
    import tempfile
    cases = parse_cases(_REPORT)
    want = [("test_a_ok", "ok"), ("test_b_fails", "FAIL"), ("test_c_errors", "ERROR"),
            ("test_d_skipped", "skip"), ("test_e_xfail", "xfail"), ("test_f_xpass", "xpass")]
    if cases != want:
        bad.append(f"the per-case reader: {cases} != {want}")
    if len(cases) != 6:
        bad.append("the traceback block was read as cases (only the ` ... <verdict>` lines are cases)")
    if ran_count(_REPORT) != 6:
        bad.append(f"the `Ran <n>` reader: {ran_count(_REPORT)} != 6")
    if ran_count("Ran 0 tests in 0.000s\n") != 0:
        bad.append("the `Ran <n>` reader cannot read zero, the one count that must be DISCARDED")
    if ran_count("no such line") is not None:
        bad.append("the `Ran <n>` reader answered on a report that has no such line")
    try:                                                     # the negative: a word outside the vocabulary
        parse_cases("test_z (m.T) ... flaky\n")
        bad.append("a verdict outside the closed vocabulary was accepted")
    except Unreadable:
        pass
    for name, verdict in (("test_a_ok", "ok"), ("g1", "PASS")):
        tok = cli.token_case(name, verdict) if verdict == "ok" else cli.token_gate(name, verdict)
        d = cli.split_token(tok)
        if d["verdict"] != verdict or d["sha1"] != cli.sha1_text(name):
            bad.append(f"the token round trip: {tok} -> {d}")
    try:
        cli.token_gate("g1", "GREEN")
        bad.append("a gate verdict outside the closed vocabulary was written")
    except ValueError:
        pass
    with tempfile.TemporaryDirectory() as td:
        rp = Path(td) / "results.tsv"
        rp.write_text(_RESULTS, encoding="utf-8")
        rows = read_results(rp)
        if [r["gate"] for r in rows] != ["g1", "g6"] or [r["verdict"] for r in rows] != ["PASS", "MISSING"]:
            bad.append(f"the results reader: {rows}")
        rp.write_text("tier\tverdict\nportable\tPASS\n", encoding="utf-8")
        try:                                                 # the negative: a table with no `gate` column
            read_results(rp)
            bad.append("a results.tsv with no 'gate' column was read anyway")
        except Unreadable:
            pass
    if fill(["--config", "{config}", "x"], {"{config}": "/c"}) != ["--config", "/c", "x"]:
        bad.append("the placeholder filler")
    try:
        fill(["{rompath}"], {})
        bad.append("an unknown placeholder was passed through")
    except Refused:
        pass
    return bad


def main(argv):
    if not argv or argv[0] not in ("selftest", "resolve", "unittest", "gates"):
        print(__doc__.split("\n\n")[1]); return 2
    # the FACE a refusal names, set before anything can refuse: an adapter's REFUSED line that said
    # drivers/cli.sh would send the reader to the wrong contract (found at bbx-18, before the first control)
    cli.DRIVER = {"unittest": "drivers/unittest.sh", "gates": "drivers/gates.sh"}.get(argv[0], "drivers/<unittest|gates>.sh")
    try:
        if argv[0] == "selftest":
            bad = selftest()
            for b in bad:
                print(f"adapters.py: self-test FAILED — {b}")
            if bad:
                return 1
            print("adapters.py: self-test ok — the per-case reader, the `Ran <n>` reader, the closed "
                  "verdict vocabularies, the results reader and the placeholder filler behave as designed")
            return 0
        if argv[0] == "resolve":
            print(resolve_set(argv[1], os.environ.get("CLI_PATH", "")))
            return 0
        if len(argv) < 5:
            print(f"usage: python3 -m bbx.adapters {argv[0]} <set-dir> <scenario.cli> <out> <sandbox> "
                  f"[--nondet] [--timeout <s>]"); return 2
        set_dir, scen, out, sandbox = argv[1:5]
        rest = argv[5:]
        timeout = cli.DEFAULT_TIMEOUT
        if "--timeout" in rest:
            timeout = float(rest[rest.index("--timeout") + 1])
        fn = run_unittest if argv[0] == "unittest" else run_gates
        fn(set_dir, scen, out, sandbox, nondet="--nondet" in rest, timeout=timeout)
        return 0
    except Refused as e:
        print(e); return 3
    except Crashed as e:
        print(f"adapters.py: {e}"); return 2
    except Unreadable as e:
        print(f"adapters.py: {e}"); return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

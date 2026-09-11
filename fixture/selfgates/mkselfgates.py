#!/usr/bin/env python3
"""mkselfgates.py — the GATES ADAPTER FIXTURE's generator: BBX ITSELF AS A SUBJECT (R14, R38; §4).

    python3 fixture/selfgates/mkselfgates.py            write the fixture under this directory
    python3 fixture/selfgates/mkselfgates.py --check     (1) every chirality predicate holds on the DESIGN
                                                         and on the tree's registry (read back out of
                                                         subject/stubs/gates/portable.txt); (2) the tree's
                                                         fixture equals what this script writes,
                                                         regenerated under TMPDIR and diffed; (3) the
                                                         RUNNER-CHECK: BBX's own static runner, driven over
                                                         the tree's synthetic consumer under a clean
                                                         environment, keeps the rows and the exit the
                                                         DESIGN says; (4) the registry row is the identity
                                                         `idkey.sh` computes NOW, or it says by how much the
                                                         harness has moved since the freeze (R38, R44)

WHAT IT WRITES, from the DESIGN below and nothing else:
  (idkey.sh beside this script is HAND-WRITTEN, not generated: it is the identity R38 rules, and the
   gate exercises it in both directions rather than a regenerate-and-diff.)

  subject/stubs/bbx.toml         a SYNTHETIC `self`-kind consumer: its own gates directory, its own three
                                 registries, `controls.enforce = false` (its stubs are not BBX's gates —
                                 what this subject exercises is the RUNNER's dispatch, its verdict words
                                 and its counting; the controls contract has its own ground truth in
                                 gates/controls.sh)
  subject/stubs/gates/*.sh       7 stub gates on disk: 3 that hold, 1 that SKIPs, 1 that reds, 1 of the
                                 STATIC tier (SKIP until its needs-env resolves, PASS when it does), and 1
                                 in NO registry — the anti-orphan file
  subject/stubs/gates/portable.txt   6 rows in a DELIBERATELY UNSORTED order, one naming a gate that is not
                                 on disk (its row reads MISSING: a dead row fails, BBX-9)
  scenarios/<s>.cli              three INVOCATIONS: the program is the first arg, resolved under
                                 $BBX_HOME/bin, and `{config}`, `{log}` are filled in by the driver (D58)
  expected/derived/<s>.truth     the spec `exact derived`; the truth log beside it is written from the
  expected/derived/logs/<s>.log      RUNNER'S CONTRACT through lib/py/bbx/cli.py's vocabulary (D47, D58)
  expected/registry.tsv          the WHOLE-SET key from idkey.sh (R38) -> `derived`
  expected/PROVENANCE.toml       every expectation and truth log, class `derived`; the registry row `registry`

WHY `derived` (R11's ranked vocabulary, E3): the verdict words are not values this fixture invents. They
come from the runner's own stated contract — `PASS` when a gate exits 0 without a SKIP marker, `SKIP` when
it prints one (and SKIP IS NOT PASS, BBX-1), `FAIL` on a non-zero exit, `MISSING` for a registered gate
that is not executable — and the run's exit follows from the same contract (non-zero when any row is FAIL
or MISSING). The truth is DERIVED from a contract stated outside the artifact under test (§3.4); `fixture`
would understate it and `self` would freeze the runner's own answer (BBX-3, R11).

CHIRAL BY CONSTRUCTION (BBX-15): the registry order is NOT alphabetical and the kept run preserves it
(measured at bbx-18), so a reader that sorted the rows would be caught; the verdict sequence is neither
constant, nor sorted, nor its own reverse; the MISSING row and the SKIP row are each neither first nor
last, so an off-by-one at either end cannot hide; and the STATIC stub appears in two scenarios with two
different verdicts, so a mapper that ignored the run's arguments would be caught.

WHAT THIS FIXTURE DOES NOT OBSERVE, and why it is here anyway: the anti-orphan file `g7_orphan.sh` is on
disk in no registry, and the adapter maps the kept run's ROWS — so the orphan is NAMED by the runner's
report and appears in no token. That is BBX-9's unenforced direction, measured and raised as R45 at
bbx-18 (gotcha G34); the file stays so the fixture holds the shape the moment R45 is answered.
"""
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "lib" / "py"))
from bbx import cli as T              # noqa: E402  (the token vocabulary, D47/D58)

SET = "stubs"                          # the consumer is subject/<set>/ (a DIRECTORY: the adapters' resolver)
EXPSET = "derived"
NEEDS_ENV = "SELFGATES_INPUT"          # the synthetic consumer's static_needs_env
# ── the design: the portable registry IN ORDER (name, on disk, verdict) ──────
PORTABLE = [
    ("g1_holds",   True,  "PASS"),
    ("g4_skips",   True,  "SKIP"),
    ("g2_holds",   True,  "PASS"),
    ("g6_absent",  False, "MISSING"),   # registered, not on disk: a DEAD ROW fails (BBX-9)
    ("g5_reds",    True,  "FAIL"),
    ("g3_holds",   True,  "PASS"),
]
STATIC = ("g8_static", "SKIP", "PASS")  # (name, without the needs-env, with it)
ORPHAN = "g7_orphan"                    # on disk, in no registry
# (scenario, args after the program, the rows the run must keep, the [env] table)
SCENARIOS = [
    ("01_portable",    ["run-static", "--config", "{config}", "--log", "{log}"],
     [(n, v) for n, _, v in PORTABLE], {}),
    ("02_static_skip", ["run-static", "--tier", "static", "--config", "{config}", "--log", "{log}"],
     [(STATIC[0], STATIC[1])], {}),
    ("03_static_input", ["run-static", "--tier", "static", "--config", "{config}", "--log", "{log}"],
     [(STATIC[0], STATIC[2])], {NEEDS_ENV: "."}),
]
PROGRAM = "bbx"                         # the DISPATCHER, so bin/bbx is executed too (R14)


def exit_of(rows):
    """The runner's exit status, from its contract and not from a run: non-zero when any row is FAIL or
    MISSING; a run whose only row is SKIP exits 0 and asserts nothing (BBX-1)."""
    return 1 if any(v in ("FAIL", "MISSING") for _, v in rows) else 0


def failed_predicates(portable):
    bad = []
    names = [n for n, _, _ in portable]
    verdicts = [v for _, _, v in portable]
    if len(set(names)) != len(names):
        bad.append("registry rows repeat a name")
    if names == sorted(names):
        bad.append("the registry order is alphabetical (a reader that sorted the rows could hide)")
    if len(set(verdicts)) == 1:
        bad.append("the verdict sequence is constant")
    if verdicts == sorted(verdicts) or verdicts == sorted(verdicts, reverse=True):
        bad.append("the verdict sequence is in sorted order")
    if verdicts == verdicts[::-1]:
        bad.append("the verdict sequence is its own reverse")
    for word in ("PASS", "SKIP", "FAIL", "MISSING"):
        if word not in verdicts:
            bad.append(f"no row reads {word}")
    for word in ("SKIP", "MISSING"):
        if word in verdicts and verdicts.index(word) in (0, len(verdicts) - 1):
            bad.append(f"the {word} row is first or last (an off-by-one could hide)")
    if STATIC[1] == STATIC[2]:
        bad.append("the static stub reads the same verdict with and without its input")
    if any(n == ORPHAN for n, _, _ in portable):
        bad.append("the anti-orphan file is registered (then it is not an orphan)")
    return bad


# ── the synthetic consumer ───────────────────────────────────────────────────
STUB_HOLD = """#!/bin/sh
# {name}.sh — a STUB of the synthetic consumer (fixture/selfgates, R14): it holds, so its row reads PASS.
# Written by mkselfgates.py from the design; not a gate of BBX (BBX's own gates are in gates/).
echo "  ok    stub {name} asserted its one designed fact"
exit 0
"""
STUB_SKIP = """#!/bin/sh
# {name}.sh — a STUB whose input is absent: it prints a SKIP marker and exits 0, and SKIP IS NOT PASS
# (BBX-1). Written by mkselfgates.py from the design.
echo "SKIP: the designed absent input (asserts nothing)"
exit 0
"""
STUB_RED = """#!/bin/sh
# {name}.sh — a STUB that reds BY DESIGN, so its row reads FAIL and the run's exit is non-zero. The gates
# adapter REPORTS that verdict; it never judges it (R37). Written by mkselfgates.py from the design.
echo "  FAIL  the designed red line"
exit 1
"""
STUB_STATIC = """#!/bin/sh
# {name}.sh — a STUB of the STATIC tier: its input is named by the consumer's static_needs_env, so it
# SKIPs while that variable is unset and holds when a scenario's [env] table sets it to a directory inside
# the sandbox. The same gate, two verdicts: that is BBX-1 as an observation rather than a sentence.
[ -n "${{{needs}:-}}" ] || {{ echo "SKIP: {needs} is unset (asserts nothing)"; exit 0; }}
echo "  ok    stub {name} read its input at ${needs}"
exit 0
"""
STUB_ORPHAN = """#!/bin/sh
# {name}.sh — ON DISK, IN NO REGISTRY: the anti-orphan file. The runner NAMES it under "registry coverage"
# and — measured at bbx-18 (G34) — exits 0 all the same, so no token of this fixture carries it. It stays
# for the day R45 gives that direction a verdict. Written by mkselfgates.py from the design.
echo "  ok    never reached by the runner"
exit 0
"""

CONSUMER_TOML = f'''# bbx.toml — a SYNTHETIC `self`-kind consumer, the SUBJECT of the gates adapter (R14, R38).
# It is not BBX: its gates are stubs written from a design, and what it exercises is BBX's own static
# runner — the dispatch, the four verdict words, the counting, the tiers and the registries.
# GENERATED by mkselfgates.py — do not edit; regenerate.

[project]
root = "."
kind = "self"

[registries]
static_needs_env = "{NEEDS_ENV}"

[controls]
enforce = false     # the stubs are not BBX's gates; the controls contract's ground truth is gates/controls.sh
'''

SCEN_HEAD = ("# the scenario (R35, D46): an INVOCATION of a harness runner over this consumer. The first arg is the\n"
             "# PROGRAM, resolved under $BBX_HOME/bin and nowhere else; `{config}` and `{log}` are filled in by\n"
             "# drivers/gates.sh (D58). Nothing here is an expected value.\n")


def scenario_text(args, env):
    out = SCEN_HEAD + "[scenario]\nargs = [" + ", ".join(f'"{a}"' for a in [PROGRAM] + args) + "]\n"
    if env:
        out += "\n[env]\n" + "".join(f'{k} = "{v}"\n' for k, v in sorted(env.items()))
    return out


def truth_log(rows):
    return T.observation_tokens(exit_of(rows), [T.token_gate(n, v) for n, v in rows])


def files():
    out = {"bbx.toml": BBX_TOML, f"subject/{SET}/bbx.toml": CONSUMER_TOML}
    for name, on_disk, verdict in PORTABLE:
        if not on_disk:
            continue
        tpl = {"PASS": STUB_HOLD, "SKIP": STUB_SKIP, "FAIL": STUB_RED}[verdict]
        out[f"subject/{SET}/gates/{name}.sh"] = tpl.format(name=name)
    out[f"subject/{SET}/gates/{STATIC[0]}.sh"] = STUB_STATIC.format(name=STATIC[0], needs=NEEDS_ENV)
    out[f"subject/{SET}/gates/{ORPHAN}.sh"] = STUB_ORPHAN.format(name=ORPHAN)
    out[f"subject/{SET}/gates/portable.txt"] = "".join(f"{n}\n" for n, _, _ in PORTABLE)
    out[f"subject/{SET}/gates/static.txt"] = f"{STATIC[0]}\n"
    out[f"subject/{SET}/gates/sweep.tsv"] = ("# sweep.tsv — the synthetic consumer's instrument tier: empty by design.\n"
                                             "# gate\tlane\tscope\tcadence\targs\n")
    for name, args, rows, env in SCENARIOS:
        out[f"scenarios/{name}.cli"] = scenario_text(args, env)
        out[f"expected/{EXPSET}/{name}.truth"] = f'[spec]\nclass = "exact"\nbaseset = "{EXPSET}"\n'
        out[f"expected/{EXPSET}/logs/{name}.log"] = truth_log(rows)
    return out


BBX_TOML = f'''# bbx.toml — the GATES ADAPTER FIXTURE's consumer config: BBX's fifth consumer, and the one whose
# SUBJECT IS BBX ITSELF (R14's self-validation clause, R38's identity; docs/plans/S4.md §3 "R14").
# The kind is `command-line` — an adapter is a DRIVER of that kind (D7) — so the profile, the scenario
# extension, the driver family and the kinds table are step 1's; only the driver and the identity differ.
# GENERATED by mkselfgates.py (--check).

[project]
root = "."
kind = "command-line"

[suite]
replays_dir = "scenarios"
expected_dir = "expected"
registry = "expected/registry.tsv"
default_set = "{SET}"           # the consumer under test: subject/{SET}/ — a DIRECTORY
driver = "gates"                # $BBX_HOME/drivers/gates.sh (D28; R26's driver home)

[fingerprint]
kind = "command"                # R38: the identity is the HARNESS's own tree at HEAD, not a file's sha1
program_command = 'sh "$BBX_HOME/fixture/selfgates/idkey.sh" program'
wholeset_command = 'sh "$BBX_HOME/fixture/selfgates/idkey.sh" wholeset'
'''


def identity(which="wholeset"):
    """The key idkey.sh computes for the HARNESS THIS FIXTURE BELONGS TO — always the real tree, never the
    directory a regeneration writes into (R38: the identity is BBX's, not a copy's). So the registry row a
    regeneration under TMPDIR produces carries the same key as the tree's, and a DIFFERING row means one
    thing only: the harness has moved since the freeze."""
    home = HERE.parent.parent
    p = subprocess.run(["sh", str(HERE / "idkey.sh"), which], capture_output=True, text=True,
                       env={"BBX_HOME": str(home), "PATH": "/usr/bin:/bin:/usr/sbin:/sbin"})
    if p.returncode != 0 or not p.stdout.strip():
        raise RuntimeError(f"idkey.sh {which} failed ({p.returncode}): {p.stderr.strip()}")
    return p.stdout.split()[0]


def registry_and_register(root, written):
    wkey = identity("wholeset")
    reg = ("# registry.tsv — the WHOLE-SET key of the HARNESS ITSELF (R38: the tree hash of bin, lib, drivers\n"
           "# and gates at HEAD, through idkey.sh) -> expectation set. Written by mkselfgates.py, which is the\n"
           "# freeze. THIS KEY MOVES ON EVERY COMMIT THAT TOUCHES THOSE FOUR DIRECTORIES (22 of BBX's first 53\n"
           "# commits did), and a moved key is an UNREGISTERED identity before any scenario runs: the refreeze is\n"
           "# a REVIEWED step of the close, never automatic (R38, §3.4; its cost is R44's question).\n"
           "# sha1\texpectation-set\tnotes\n"
           f"{wkey}\t{EXPSET}\tthe harness whose self-subject behaviour was reviewed at this freeze\n")
    rows = ["# PROVENANCE.toml — the expectation register of the gates adapter fixture (E3; R11, R24).",
            "# Every row is class `derived`: the verdict words and the exit follow from the RUNNER'S OWN STATED",
            "# CONTRACT applied to a synthetic consumer this design writes — not from a run of it (`self`) and not",
            "# from a value the fixture invents (`fixture`). GENERATED by mkselfgates.py.", ""]
    what = {"truth": "the expected observation (exact, by index)", "log": "the truth log, from the design"}
    i = 0
    for rel in sorted(written):
        if not rel.startswith("expected/") or rel.endswith("registry.tsv"):
            continue
        i += 1
        rows += [f"[e{i}]", f'file = "{rel[len("expected/"):]}"',
                 f'describes = "{what[rel.rsplit(".", 1)[1]]} of scenario {Path(rel).stem}"',
                 'class = "derived"', 'refreeze = "python3 fixture/selfgates/mkselfgates.py"', ""]
    i += 1
    rows += [f"[e{i}]", 'file = "registry.tsv"',
             'describes = "the harness identity (R38) -> derived; refrozen after every kernel commit"',
             'class = "registry"', 'refreeze = "python3 fixture/selfgates/mkselfgates.py"', ""]
    return reg, "\n".join(rows).rstrip("\n") + "\n"


def write_all(root):
    out = files()
    for rel, content in out.items():
        p = root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content)
        if rel.endswith(".sh"):
            p.chmod(0o755)
    reg, prov = registry_and_register(root, out)
    for rel, content in (("expected/registry.tsv", reg), ("expected/PROVENANCE.toml", prov)):
        (root / rel).write_text(content)
        out[rel] = content
    return out


def read_tree_registry(root):
    """The portable registry read back OUT of the tree, with each row's verdict taken from the stub on disk
    (its exit and whether it prints a SKIP marker) — so a hand-edited stub is named, never trusted."""
    reg = (root / "subject" / SET / "gates" / "portable.txt").read_text().split()
    found = []
    for name in reg:
        p = root / "subject" / SET / "gates" / f"{name}.sh"
        if not p.is_file():
            found.append((name, False, "MISSING")); continue
        text = p.read_text()
        if re.search(r'^echo "SKIP:', text, re.M):
            v = "SKIP"
        elif re.search(r"^exit 1$", text, re.M):
            v = "FAIL"
        else:
            v = "PASS"
        found.append((name, True, v))
    return found


def runner_check(root):
    """The RUNNER-CHECK (the fixture's BBX-5 pairing): the design is the author, BBX's runner is the
    artifact. Drive the runner directly — never through the adapter, so the two are not one thing — and
    compare the kept rows and the exit with the design."""
    bad = []
    home = root.parent.parent
    for name, args, rows, env in SCENARIOS:
        with tempfile.TemporaryDirectory() as td:
            log = Path(td) / "run"
            argv = [str(home / "bin" / PROGRAM)] + [a.replace("{config}", str(root / "subject" / SET / "bbx.toml"))
                                                     .replace("{log}", str(log)) for a in args]
            e = {"PATH": "/usr/bin:/bin:/usr/sbin:/sbin", "HOME": td, "TMPDIR": td,
                 "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8", "PYTHONDONTWRITEBYTECODE": "1"}
            e.update({k: (td if v == "." else v) for k, v in env.items()})
            p = subprocess.run(argv, cwd=td, env=e, capture_output=True, text=True)
            tsv = log / "results.tsv"
            if not tsv.is_file():
                bad.append(f"{name}: the runner kept no results.tsv ({p.returncode}): {p.stdout[-200:]}")
                continue
            lines = tsv.read_text().splitlines()
            head = lines[0].split("\t")
            got = [(r[head.index("gate")], r[head.index("verdict")]) for r in (l.split("\t") for l in lines[1:] if l.strip())]
        if got != rows:
            bad.append(f"{name}: the runner kept {got} where the design says {rows}")
        if p.returncode != exit_of(rows):
            bad.append(f"{name}: the runner exited {p.returncode} where the contract gives {exit_of(rows)}")
    return bad


def counts():
    return {"stubs_on_disk": len([1 for _, d, _ in PORTABLE if d]) + 2,
            "registered_portable": len(PORTABLE), "registered_static": 1, "unregistered": 1,
            "verdict_words": len({v for _, _, v in PORTABLE}), "scenarios": len(SCENARIOS),
            "expectations": len(SCENARIOS), "truth_logs": len(SCENARIOS)}


def main(argv):
    check = "--check" in argv
    bad = failed_predicates(PORTABLE)
    if bad:
        print("FAIL: the DESIGN is not chiral: " + ", ".join(bad)); return 1
    if not check:
        write_all(HERE)
        print("wrote " + ", ".join(f"{k}={v}" for k, v in counts().items())
              + f"; identity(wholeset)={identity()[:12]}…")
        return 0
    table = read_tree_registry(HERE)
    if table != PORTABLE:
        print(f"FAIL: the tree's registry is not the design's: {table} != {PORTABLE}"); return 1
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
        if differ == ["expected/registry.tsv"] and not extra:
            print(f"FAIL: THE HARNESS HAS MOVED since this identity was frozen — the row says "
                  f"{(HERE / 'expected/registry.tsv').read_text().split(chr(10))[-2].split(chr(9))[0][:12]}… and "
                  f"idkey.sh now computes {identity()[:12]}…. Re-review what moved, then regenerate to refreeze "
                  f"the row (R38: the refreeze is a step of the close, never automatic; its cost is R44).")
            return 1
        print("FAIL: the tree's fixture is not what mkselfgates.py writes (regenerate, never hand-edit — BBX-21)")
        return 1
    bad = runner_check(HERE)
    if bad:
        for b in bad:
            print(f"  RUNNER  {b}")
        print("FAIL: BBX's own runner does not keep what the design says")
        return 1
    print("check ok: the design is chiral, the consumer is the design's, the tree equals what this script "
          "writes, and the runner keeps " + ", ".join(f"{k}={v}" for k, v in counts().items()))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

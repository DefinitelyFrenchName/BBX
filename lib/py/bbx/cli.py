#!/usr/bin/env python3
"""cli.py — the COMMAND-LINE kind: the OBSERVATION TOKEN VOCABULARY (S4 step 1; docs/plans/S4.md §3 "O1";
rulings R31, R35; D47) and the DRIVER'S CORE (S4 step 2; §3 "D1–D5", "O5", "O6"; D46, D51, D52): resolve,
the sandbox, the scrub, run, the log and the band view, summary, the self-test. ONE module, so the truth a
fixture generator writes and the log the driver writes share one writer of every token (the S3 shape:
mkdocset.py imports bbx.docset; mkfakecli.py imports this).

    python3 -m bbx.cli selftest                                   the vocabulary, the layout and the scenario
                                                                  reader on synthetic input (every run, first)
    python3 -m bbx.cli resolve <set>                              the tool on CLI_PATH (`;`-separated, each component
                                                                  made absolute; per directory an executable `<set>`
                                                                  wins over `<set>.py`; the first directory that has
                                                                  one wins) — exit 1 naming the path if none
    python3 -m bbx.cli run <tool> <scenario.cli> <out.log> <sandbox> [--nondet] [--timeout <s>]
    python3 -m bbx.cli summary <log>                              NOTE: exit / band-fields / emitted-files

The grammar (one space-free token per line; split in one place, by field name — BBX-12):
    0 exit:<n>                       the tool's exit status, the FIRST line and its own observation point
    <i> line:<sha1>                  one stdout line (fields absent): SHA-1 over the line's UTF-8, no newline
    <i> field:<name>:<sha1>          one key of the ONE JSON object stdout holds (fields = "json"), keys in
                                     SORTED order; the hash is over the value's CANONICAL JSON (sorted keys,
                                     no spaces, non-ASCII kept) so `"Maren"` and `6` and `["ash","elm"]` hash
                                     as what they are, not as printed
    <i> field:<name>:band            a BAND field (the scenario's `bands`): a constant — its value lives in the
                                     band view `<out>.bands` (`<i> <name>=<value>`, `END <n>`; O4), never in
                                     this log (the exact family would fail on every legitimate move)
    <i> err:<sha1>                   one stderr line
    <i> file:<name>:<sha1>           one declared emitted file (the scenario's `emits`), SHA-1 over its bytes
    END <n>                          n = the last index (0 when the tool wrote nothing and emitted nothing)
Order: exit, stdout (lines or fields), stderr, files. A field name holds no space and no colon.

THE BAND VIEW `<out>.bands` (O4; D47): `<i> <name>=<canonical-json-value>` per band field the JSON object
carries, in sorted key order, i = 1..k; `END <k>` — k is the band inventory's size (BBX-13's watch). Written
only when stdout was read as one JSON object and the scenario declares `bands`.

THE JSON VIEW `<out>.json` (D54; S4 step 3): the CANONICAL text of the ONE object stdout held (`canon()`, the same
text the field hashes are over), written whenever the observation was read as fields — the artifact the schema
family's json format reads (lib/py/bbx/compare_schema.py), so the object's SHAPE is judged from the run and never
re-derived from the log's hashes. Removed with the log before every run.

THE CRASH (D4, exit 2 — the guard; bbh's guarded grammar `CRASH … END-CRASH`): a tool that DIES BY A SIGNAL
has no exit status, so the log has no `0 exit:` line; the points it did produce (stdout, then stderr) are
kept, then `CRASH signal:<n>:<NAME>` and `END-CRASH <last index>`. The log is the bug report and is never
compared (logfmt.frames does not read it: an `END-CRASH` log is RUN-FAIL to the suite, BBX-4's spirit).

WHAT THE RUN DOES (run()): the out file, its band view and its JSON view are REMOVED first (D5, [BBH-27]); the sandbox is
the tool's working directory (`cwd` under it), its HOME and its TMPDIR (D52, [BBH-36]); the environment is
EXACTLY D6's hermetic set plus the scenario's `[env]` table — nothing from the caller (the subprocess is
started with that dict, `env -i`'s effect); what was fed is RECORDED in the sandbox — `argv.txt` (the
command, one element per line), `stdin.bin`, `env.txt` (`k=v` sorted) — so a gate can assert it equals
the scenario (O5); then the log is written through the vocabulary above. `--timeout <s>` elapsed: the tool
is killed and NO log is written (exit 1, DISCARDED). `--nondet` salts every hashed token with the clock
(the driver-side NONDETERMINISTIC control, CLI_NONDET; O6).

WHAT IS REFUSED (exit 3, `REFUSED: drivers/cli.sh cannot honour <what> (<why>)`): a scenario key or table
the grammar does not have (D46; SMS cliguard's rule on the scenario grammar); `fields` other than "json";
`bands` without `fields = "json"`; an `[env]` key that is one of D6's names (the scrub is the driver's,
not the scenario's); a `cwd` or an emitted file path that escapes the sandbox. A tool not found, not
runnable, a stdout that is not UTF-8, a declared emitted file not produced, or the timeout: exit 1, the
run DISCARDED. A tool's NON-ZERO EXIT IS AN OBSERVATION (the `exit` point), never a driver failure.
"""
import hashlib
import json
import os
import signal
import subprocess
import sys
import time
from pathlib import Path

from . import toml_subset
from .recount import HERMETIC_PATH   # D6's PATH, declared once

BAND = "band"
KINDS = ("exit", "line", "field", "err", "file", "case", "gate")   # case/gate: the adapters (R37, S4 step 5)
# The two adapter verdicts are CLOSED vocabularies mapped from a framework's own words: a tail outside
# either is exit 1 DISCARDED, never a token invented on the spot (D58).
CASE_VERDICTS = ("ok", "FAIL", "ERROR", "skip", "xfail", "xpass")            # python3 -m unittest -v
GATE_VERDICTS = ("PASS", "FAIL", "SKIP", "TIMEOUT", "MISSING")               # bbx-classify plus the runner's MISSING
SCENARIO_KEYS = ("args", "stdin", "stdin_file", "cwd", "emits", "bands", "fields")
FIELD_READERS = ("json",)
HERMETIC_NAMES = ("PATH", "LANG", "LC_ALL", "HOME", "TMPDIR", "PYTHONDONTWRITEBYTECODE")
DRIVER_FAMILY = ("CLI_NONDET", "CLI_TIMEOUT", "CLI_KEEP_ENV")     # scrubbed by the suite (D45 hermetic_unset)
DEFAULT_TIMEOUT = 60                                              # seconds; D51 (arbitrary)


DRIVER = "drivers/cli.sh"     # the FACE a refusal names: each driver of this kind sets it once (D58)


class Refused(Exception):
    """what the driver cannot honour: printed as `REFUSED: <driver> cannot honour <what> (<why>)`, exit 3.
    The driver's own name, not this module's: an adapter's refusal that named drivers/cli.sh would send the
    reader to the wrong contract (found at bbx-18, before the adapters' first control was written)."""
    def __init__(self, what, why):
        super().__init__(f"REFUSED: {DRIVER} cannot honour {what} ({why})")


class Unreadable(Exception):
    """the tool, the scenario, its stdin, a declared file, or the timeout: exit 1, the run DISCARDED."""


class Crashed(Exception):
    """the tool died by a signal: exit 2, the log written is the bug report (END-CRASH)."""


# ── the vocabulary: the ONE writer of every token (D47) ─────────────────────
def sha1_text(text):
    return hashlib.sha1(text.encode("utf-8")).hexdigest()


def sha1_bytes(data):
    return hashlib.sha1(data).hexdigest()


def canon(value):
    """The canonical JSON text of a value: sorted keys, no spaces, non-ASCII kept."""
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def _name_ok(name):
    if not name or " " in name or ":" in name:
        raise ValueError(f"a point name holds no space and no colon: {name!r}")
    return name


def point_exit(status):
    return f"0 exit:{int(status)}"


def point_line(i, text, salt=""):
    return f"{i} line:{sha1_text(text + salt)}"


def point_field(i, name, value=None, band=False, salt=""):
    return f"{i} field:{_name_ok(name)}:" + (BAND if band else sha1_text(canon(value) + salt))


def point_err(i, text, salt=""):
    return f"{i} err:{sha1_text(text + salt)}"


def point_file(i, name, data, salt=""):
    return f"{i} file:{_name_ok(name)}:{sha1_bytes(data + salt.encode('utf-8'))}"


def token_case(name, verdict, salt=""):
    """`case:<verdict>:<sha1 of the case NAME>` — the framework's verdict is an OBSERVATION (D7, R37).
    The name is the per-case line's FIRST field, never the whole `<case> (<module.Class>)` text, so the
    token does not move when the framework changes how it formats the rest of the line."""
    return f"case:{_verdict_ok(verdict, CASE_VERDICTS)}:{sha1_text(_name_ok(name) + salt)}"


def token_gate(name, verdict, salt=""):
    """`gate:<verdict>:<sha1 of the gate NAME>` — one row of a kept results.tsv, read by column name."""
    return f"gate:{_verdict_ok(verdict, GATE_VERDICTS)}:{sha1_text(_name_ok(name) + salt)}"


def _verdict_ok(verdict, vocabulary):
    if verdict not in vocabulary:
        raise ValueError(f"verdict {verdict!r} is outside the closed vocabulary: {', '.join(vocabulary)}")
    return verdict


def end(n):
    return f"END {n}"


def points(status, stdout_lines=None, fields=None, bands=(), stderr_lines=(), files=(), salt=""):
    """The point lines (no END): `fields` (a dict) means stdout was ONE JSON object and its keys are the
    points in sorted order; else `stdout_lines` are the points. `files` is [(name, bytes)] in declared order."""
    out = [] if status is None else [point_exit(status)]
    i = 0
    if fields is not None:
        for k in sorted(fields):
            i += 1
            out.append(point_field(i, k, fields[k], band=k in bands, salt=salt))
    else:
        for text in (stdout_lines or ()):
            i += 1
            out.append(point_line(i, text, salt))
    for text in stderr_lines:
        i += 1
        out.append(point_err(i, text, salt))
    for name, data in files:
        i += 1
        out.append(point_file(i, name, data, salt))
    return out, i


def observation(status, stdout_lines=None, fields=None, bands=(), stderr_lines=(), files=(), salt=""):
    """The whole log text: the points, then `END <n>`."""
    out, i = points(status, stdout_lines, fields, bands, stderr_lines, files, salt)
    out.append(end(i))
    return "\n".join(out) + "\n"


def observation_tokens(status, tokens):
    """An adapter's whole log: `0 exit:<n>`, the tokens numbered from 1, `END <n>` (D47's shape, D58)."""
    out = [point_exit(status)] + [f"{i} {t}" for i, t in enumerate(tokens, start=1)]
    out.append(end(len(tokens)))
    return "\n".join(out) + "\n"


def crash_tokens(signum, tokens):
    """An adapter's bug report: the tokens it had mapped before the framework died, then CRASH / END-CRASH."""
    out = [f"{i} {t}" for i, t in enumerate(tokens, start=1)]
    out.append(f"CRASH signal:{int(signum)}:{signal_name(signum)}")
    out.append(f"END-CRASH {len(tokens)}")
    return "\n".join(out) + "\n"


def crash_log(signum, stdout_lines=(), stderr_lines=(), salt=""):
    """The bug report: the points the tool produced before it died, `CRASH signal:<n>:<NAME>`, `END-CRASH <n>`."""
    out, i = points(None, stdout_lines=stdout_lines, stderr_lines=stderr_lines, salt=salt)
    out.append(f"CRASH signal:{int(signum)}:{signal_name(signum)}")
    out.append(f"END-CRASH {i}")
    return "\n".join(out) + "\n"


def signal_name(signum):
    try:
        return signal.Signals(signum).name
    except ValueError:
        return "UNKNOWN"


def band_view(fields, bands):
    """`<i> <name>=<canonical value>` per declared band field the object carries, sorted, then `END <k>`."""
    rows = [k for k in sorted(fields) if k in bands]
    return "".join(f"{i} {k}={canon(fields[k])}\n" for i, k in enumerate(rows, start=1)) + f"END {len(rows)}\n"


def split_token(tok):
    """A token -> dict by field name; the ONE splitter (BBX-12). ValueError on anything outside the vocabulary."""
    parts = tok.split(":")
    kind = parts[0]
    if kind == "exit" and len(parts) == 2 and (parts[1].lstrip("-").isdigit()):
        return {"kind": kind, "status": int(parts[1])}
    if kind in ("line", "err") and len(parts) == 2 and _is_sha1(parts[1]):
        return {"kind": kind, "sha1": parts[1]}
    if kind == "field" and len(parts) == 3 and parts[1] and (parts[2] == BAND or _is_sha1(parts[2])):
        return {"kind": kind, "name": parts[1], "band": parts[2] == BAND, "sha1": None if parts[2] == BAND else parts[2]}
    if kind == "file" and len(parts) == 3 and parts[1] and _is_sha1(parts[2]):
        return {"kind": kind, "name": parts[1], "sha1": parts[2]}
    if kind == "case" and len(parts) == 3 and parts[1] in CASE_VERDICTS and _is_sha1(parts[2]):
        return {"kind": kind, "verdict": parts[1], "sha1": parts[2]}
    if kind == "gate" and len(parts) == 3 and parts[1] in GATE_VERDICTS and _is_sha1(parts[2]):
        return {"kind": kind, "verdict": parts[1], "sha1": parts[2]}
    raise ValueError(f"not a command-line token: {tok!r}")


def _is_sha1(s):
    return len(s) == 40 and all(c in "0123456789abcdef" for c in s)


# ── the scenario (D46) ────────────────────────────────────────────────────────
class Scenario:
    def __init__(self, args, stdin, cwd, emits, bands, fields, env):
        self.args = args          # one string per argv element
        self.stdin = stdin        # bytes fed to the tool
        self.cwd = cwd            # relative to the sandbox
        self.emits = emits        # files the tool must produce, relative to cwd
        self.bands = bands        # band field names
        self.fields = fields      # None (stdout is lines) or "json"
        self.env = env            # the [env] table


def _str_list(path, key, v):
    if not isinstance(v, list) or not all(isinstance(x, str) for x in v):
        raise Unreadable(f"scenario {path}: [scenario].{key} must be an array of strings")
    return list(v)


def load_scenario(path):
    path = Path(path)
    try:
        t = toml_subset.load(str(path))
    except (OSError, toml_subset.SubsetError) as e:
        raise Unreadable(f"scenario {path} cannot be read: {e}")
    for table in t:
        if table not in ("scenario", "env"):
            raise Refused(f"scenario table [{table}]", "the grammar is [scenario] and [env] (D46)")
    s = t.get("scenario")
    if not isinstance(s, dict):
        raise Unreadable(f"scenario {path}: no [scenario] table")
    for k in s:
        if k not in SCENARIO_KEYS:
            raise Refused(f"scenario key '{k}'", f"the keys are {', '.join(SCENARIO_KEYS)} (D46; an option the tool does not define is refused, never ignored)")
    if "args" not in s:
        raise Unreadable(f"scenario {path}: [scenario].args is required (an array of strings, one per argv element)")
    args = _str_list(path, "args", s["args"])
    if "stdin" in s and "stdin_file" in s:
        raise Unreadable(f"scenario {path}: one of stdin / stdin_file, not both")
    stdin = b""
    if "stdin" in s:
        stdin = "".join(line + "\n" for line in _str_list(path, "stdin", s["stdin"])).encode("utf-8")
    elif "stdin_file" in s:
        f = s["stdin_file"]
        if not isinstance(f, str) or not f:
            raise Unreadable(f"scenario {path}: [scenario].stdin_file must be a path")
        try:
            stdin = (path.parent / f).read_bytes()
        except OSError as e:
            raise Unreadable(f"scenario {path}: stdin_file {f} cannot be read: {e.strerror}")
    cwd = s.get("cwd", ".")
    if not isinstance(cwd, str) or not cwd:
        raise Unreadable(f"scenario {path}: [scenario].cwd must be a relative path")
    if cwd.startswith("/"):
        raise Refused(f"scenario cwd '{cwd}'", "the working directory is relative to the sandbox, never absolute (D52)")
    emits = _str_list(path, "emits", s.get("emits", []))
    for name in emits:
        if not name or name.startswith("/"):
            raise Refused(f"emitted file '{name}'", "an emitted file is a path relative to the tool's working directory (D46)")
        _name_ok(name)
    bands = _str_list(path, "bands", s.get("bands", []))
    for name in bands:
        _name_ok(name)
    fields = s.get("fields")
    if fields is not None and fields not in FIELD_READERS:
        raise Refused(f"scenario fields = '{fields}'", f"the structured-output readers are {', '.join(FIELD_READERS)} (D46)")
    if bands and fields is None:
        raise Refused("scenario bands without fields = \"json\"", "a band field is a key of a JSON stdout; a line has no fields (D46)")
    env = t.get("env", {})
    if not isinstance(env, dict):
        raise Unreadable(f"scenario {path}: [env] must be a table")
    for k, v in env.items():
        if k in HERMETIC_NAMES:
            raise Refused(f"[env].{k}", "D6's hermetic set is the driver's, not the scenario's (D52)")
        if not isinstance(v, str):
            raise Unreadable(f"scenario {path}: [env].{k} must be a string")
    return Scenario(args, stdin, cwd, emits, bands, fields, dict(env))


# ── the tool on the search path (D1: the driver's own variable, [BBH-26]) ───
def resolve_tool(set_name, search_path, cwd=None):
    """`<set>` (an executable regular file) or `<set>.py` on the `;`-separated search path, each component made
    ABSOLUTE against cwd (bbh's drivers learned it on a relative one); per directory the executable wins, and
    the first directory that has either wins. Unreadable naming the path when none does."""
    if not search_path:
        raise Unreadable(f"set CLI_PATH to the directory holding {set_name} or {set_name}.py")
    if not set_name or "/" in set_name:
        raise Unreadable(f"a set is a name on CLI_PATH, never a path: {set_name!r}")
    base = Path(cwd or Path.cwd())
    for comp in search_path.split(";"):
        if not comp:
            continue
        if comp.startswith("/"):
            d = Path(comp)                                   # an absent absolute component is skipped
        else:
            d = base / comp
            if not d.is_dir():                               # a relative one that resolves nowhere is an error
                raise Unreadable(f"search-path component '{comp}' does not resolve from {base}")
            d = d.resolve()
        exe = d / set_name
        if exe.is_file() and os.access(exe, os.X_OK):
            return str(exe)
        py = d / f"{set_name}.py"
        if py.is_file():
            return str(py)
    raise Unreadable(f"no executable {set_name} and no {set_name}.py on CLI_PATH={search_path}")


def command_for(tool):
    """`<set>.py` runs under THIS interpreter (the harness's python3, not one the pinned PATH finds);
    anything else runs as itself."""
    return [sys.executable, tool] if tool.endswith(".py") else [tool]


def hermetic_env(sandbox):
    """D6's set with the sandbox as HOME and TMPDIR (D52): what the tool sees and nothing else."""
    return {"PATH": HERMETIC_PATH, "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8",
            "HOME": str(sandbox), "TMPDIR": str(sandbox), "PYTHONDONTWRITEBYTECODE": "1"}


def _inside(path, root):
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False


def _split_lines(text):
    lines = text.split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    return lines


def prepare_sandbox(sc, sandbox):
    """The sandbox and the scenario's working directory inside it, both created; Refused if either escapes
    (D52). Shared by the three drivers of this kind (cli.sh, unittest.sh, gates.sh — D7)."""
    sandbox = Path(sandbox).resolve()
    sandbox.mkdir(parents=True, exist_ok=True)
    cwd = sandbox / sc.cwd
    if not _inside(cwd, sandbox):
        raise Refused(f"scenario cwd '{sc.cwd}'", "it escapes the sandbox (D52)")
    cwd.mkdir(parents=True, exist_ok=True)
    for name in sc.emits:
        if not _inside(cwd / name, sandbox):
            raise Refused(f"emitted file '{name}'", "it escapes the sandbox (D52)")
    return sandbox, cwd


def exec_in_sandbox(argv, sc, sandbox, cwd, timeout, extra_env=None, what="the tool", subject=None):
    """THE ONE PLACE A SUBJECT PROCESS IS STARTED (three drivers share it, D7, BBX-25). D6's hermetic set
    with the sandbox as HOME and TMPDIR (D52), the scenario's [env] table and `extra_env` on top and nothing
    from the caller; what was fed recorded beside the run (argv.txt, stdin.bin, env.txt — O5); the timeout
    and a non-UTF-8 output are Unreadable (the run is DISCARDED).
    `what` is the caller's noun for its subject ("the tool", "the framework") and `subject` the name it
    prints for it, so each driver's refusal text stays its own and no gate's frozen line moves when a
    second consumer arrives (BBX-25). The caller splits the output into lines itself, so what it reads is
    the DECODED text and nothing is rebuilt from a split.
    -> (returncode, stdout_text, stderr_text); a negative returncode is a death by that signal."""
    env = hermetic_env(sandbox)
    env.update(sc.env)
    env.update(extra_env or {})
    (sandbox / "argv.txt").write_text("".join(a + "\n" for a in argv), encoding="utf-8")
    (sandbox / "stdin.bin").write_bytes(sc.stdin)
    (sandbox / "env.txt").write_text("".join(f"{k}={env[k]}\n" for k in sorted(env)), encoding="utf-8")
    try:
        p = subprocess.run(argv, cwd=str(cwd), env=env, input=sc.stdin, capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        raise Unreadable(f"timeout: {what} ran longer than {timeout:g} s (CLI_TIMEOUT) and was killed; no log written — the run is DISCARDED")
    except OSError as e:
        raise Unreadable(f"{what} {subject or argv[0]} could not be run: {e.strerror}")
    try:
        return p.returncode, p.stdout.decode("utf-8"), p.stderr.decode("utf-8")
    except UnicodeDecodeError as e:
        raise Unreadable(f"{what}'s output is not UTF-8 ({e.reason} at byte {e.start}): a binary output is a consumer's question (docs/plans/S4.md §9); the run is DISCARDED")


def run(tool, scenario_path, out, sandbox, nondet=False, timeout=DEFAULT_TIMEOUT):
    """One run: the log at `out` (`<out>.json` when stdout was one JSON object, `<out>.bands` when there are band
    fields). Raises Refused / Unreadable /
    Crashed; returns the tool's exit status on a complete observation."""
    sc = load_scenario(scenario_path)
    sandbox, cwd = prepare_sandbox(sc, sandbox)
    out = Path(out)
    bands_path = Path(str(out) + ".bands")
    json_path = Path(str(out) + ".json")
    for p in (out, bands_path, json_path):                   # D5, [BBH-27]: never a previous run's file
        if p.exists():
            p.unlink()
    tool_path = Path(tool)
    if not tool_path.is_file():
        raise Unreadable(f"the tool {tool} is not a file")
    argv = command_for(str(tool_path.resolve())) + sc.args
    salt = f"|{time.time_ns()}" if nondet else ""
    status, stdout_text, stderr_text = exec_in_sandbox(argv, sc, sandbox, cwd, timeout, subject=tool)
    stdout_lines = _split_lines(stdout_text)
    stderr_lines = _split_lines(stderr_text)
    if status < 0:                                           # D4: death by a signal — the guard
        out.write_text(crash_log(-status, stdout_lines, stderr_lines, salt), encoding="utf-8")
        raise Crashed(f"the tool died by signal {-status} ({signal_name(-status)}) after "
                      f"{len(stdout_lines) + len(stderr_lines)} points: exit 2, the log {out} is the bug report (END-CRASH)")
    fields = None
    if sc.fields == "json" and status == 0:
        try:
            obj = json.loads(stdout_text)
        except ValueError:
            obj = None
        if isinstance(obj, dict):                            # not one object: the lines are the observation
            fields = obj
    files = []
    for name in sc.emits:
        fp = cwd / name
        if not fp.is_file():
            raise Unreadable(f"declared emitted file '{name}' not produced by the tool (in {cwd}); the run is DISCARDED")
        files.append((name, fp.read_bytes()))
    out.write_text(observation(status, stdout_lines=stdout_lines, fields=fields, bands=sc.bands,
                               stderr_lines=stderr_lines, files=files, salt=salt), encoding="utf-8")
    if fields is not None and sc.bands:
        bands_path.write_text(band_view(fields, sc.bands), encoding="utf-8")
    if fields is not None:                                   # D54: the object's shape, for the schema family
        json_path.write_text(canon(fields) + "\n", encoding="utf-8")
    return status


# ── summary (D43: the log's own NOTE-class numbers) ──────────────────────────
def summary_lines(log):
    """-> the NOTE lines, or a single FAIL line, for a log in D47's grammar (a crash log included)."""
    with open(log, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    ends = [l for l in lines if l.startswith("END ") or l.startswith("END-CRASH ")]
    if len(ends) != 1 or ends[0] != lines[-1]:
        return [f"FAIL: {log} has {len(ends)} END lines (one expected, last)"]
    crashed = ends[0].startswith("END-CRASH ")
    n = int(ends[0].split()[1])
    pts = [l for l in lines[:-1] if not l.startswith("CRASH ")]
    exit_status = None
    counts = {k: 0 for k in KINDS}
    last = 0
    for l in pts:
        f = l.split()
        if len(f) != 2 or not f[0].isdigit():
            return [f"FAIL: {log}: not a point line: {l!r}"]
        try:
            t = split_token(f[1])
        except ValueError as e:
            return [f"FAIL: {log}: {e}"]
        if t["kind"] == "exit":
            if int(f[0]) != 0 or exit_status is not None:
                return [f"FAIL: {log}: the exit point is index 0 and there is one"]
            exit_status = t["status"]
            continue
        last = int(f[0])
        counts[t["kind"]] += 1
        if t["kind"] == "field" and t["band"]:
            counts[BAND] = counts.get(BAND, 0) + 1
    if last != n:
        return [f"FAIL: {log}: END says {n} but the last index is {last}"]
    if not crashed and exit_status is None:
        return [f"FAIL: {log}: no exit point"]
    notes = [f"NOTE: exit {'crash' if crashed else exit_status}",
             f"NOTE: band-fields {counts.get(BAND, 0)}",
             f"NOTE: emitted-files {counts['file']}"]
    for kind in ("case", "gate"):                            # D43 extended for the adapters (S4 step 5):
        if counts[kind]:                                     # printed only by a log that HOLDS them, so a
            notes.append(f"NOTE: {kind}s {counts[kind]}")    # command-line log's three lines are unchanged
    return notes


# ── the self-test (every run, before the tool is run) ────────────────────────
# FIPS 180-1's own test vector and the empty message: a REFERENCE anchor for the hash the whole
# vocabulary rests on (§3.3: independent of us), so a hashlib that stopped being SHA-1 is named
_REF_ABC = "a9993e364706816aba3e25717850c26c9cd0d89d"
_REF_EMPTY = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
_SYNTHETIC_SCENARIO = ('[scenario]\nargs = ["show", "x"]\nstdin = ["b", "a"]\nemits = ["r.json"]\n'
                       'bands = ["size"]\nfields = "json"\n\n[env]\nSALT = "3"\n')


def selftest(workdir=None):
    """-> [failure sentences]; empty = the vocabulary, the layout and the scenario reader behave as designed."""
    import tempfile
    bad = []
    if sha1_text("abc") != _REF_ABC:
        bad.append(f"sha1_text('abc') is {sha1_text('abc')}, not FIPS 180-1's {_REF_ABC}")
    if sha1_bytes(b"") != _REF_EMPTY:
        bad.append("sha1_bytes(b'') is not the empty message's digest")
    if canon({"b": 1, "a": ["é", 2, {"z": None, "y": True}]}) != '{"a":["é",2,{"y":true,"z":null}],"b":1}':
        bad.append(f"canon() is not sorted-keys/no-spaces/non-ASCII-kept: {canon({'b': 1, 'a': ['é']})!r}")
    # the layout: exit first, stdout, stderr, files, END = the last index; hashes re-derived here by hashlib
    # directly (a second call path, not the point functions)
    h = lambda s: hashlib.sha1(s.encode("utf-8")).hexdigest()
    want = f"0 exit:2\n1 line:{h('x')}\n2 err:{h('e')}\n3 file:r:{hashlib.sha1(b'z').hexdigest()}\nEND 3\n"
    got = observation(2, stdout_lines=["x"], stderr_lines=["e"], files=[("r", b"z")])
    if got != want:
        bad.append(f"the layout differs: {got!r}")
    got = observation(0, fields={"weight": 83, "id": "4D2B", "size": 250}, bands=["size"])
    want = f"0 exit:0\n1 field:id:{h(chr(34) + '4D2B' + chr(34))}\n2 field:size:band\n3 field:weight:{h('83')}\nEND 3\n"
    if got != want:
        bad.append(f"the field layout differs (sorted keys, canonical values, the band constant): {got!r}")
    if observation(0) != "0 exit:0\nEND 0\n":
        bad.append("an empty observation is not `0 exit:0` / `END 0`")
    if band_view({"size": 250, "seed": 4}, ["size"]) != "1 size=250\nEND 1\n":
        bad.append("the band view is not `<i> <name>=<value>` / `END <k>`")
    cl = crash_log(6, ["a"], [])
    if not cl.endswith("CRASH signal:6:SIGABRT\nEND-CRASH 1\n") or not cl.startswith("1 line:"):
        bad.append(f"the crash log is not points / CRASH / END-CRASH: {cl!r}")
    if observation(0, stdout_lines=["x"], salt="|1") == observation(0, stdout_lines=["x"], salt="|2"):
        bad.append("the salt does not move the token")
    if observation(0, stdout_lines=["ab", "ba"]) == observation(0, stdout_lines=["ba", "ab"]):
        bad.append("a swapped pair of lines reads the same (BBX-15)")
    # the splitter, by field name
    try:
        for tok, kind in (("exit:1", "exit"), (f"line:{_REF_ABC}", "line"), (f"err:{_REF_ABC}", "err"),
                          (f"field:w:{_REF_ABC}", "field"), ("field:w:band", "field"), (f"file:r.json:{_REF_ABC}", "file")):
            if split_token(tok)["kind"] != kind:
                bad.append(f"split_token({tok!r}) is not kind {kind}")
        if not split_token("field:w:band")["band"] or split_token("field:w:" + _REF_ABC)["band"]:
            bad.append("split_token does not tell a band field from a hashed one")
    except ValueError as e:
        bad.append(f"split_token refused a token of the vocabulary: {e}")
    for garbage in ("line:abc", "exit:x", "field:w", "frame:" + _REF_ABC, "0 exit:0"):
        try:
            split_token(garbage)
            bad.append(f"split_token accepted {garbage!r}")
        except ValueError:
            pass
    # the scenario reader: the synthetic scenario loads as designed; each refusal names its thing
    with tempfile.TemporaryDirectory(dir=workdir) as d:
        p = Path(d) / "s.cli"
        p.write_text(_SYNTHETIC_SCENARIO)
        try:
            sc = load_scenario(p)
            if (sc.args, sc.stdin, sc.cwd, sc.emits, sc.bands, sc.fields, sc.env) != \
               (["show", "x"], b"b\na\n", ".", ["r.json"], ["size"], "json", {"SALT": "3"}):
                bad.append("the synthetic scenario did not load as written")
        except (Refused, Unreadable) as e:
            bad.append(f"the synthetic scenario was refused: {e}")
        refusals = (("argz", '[scenario]\nargz = ["x"]\n', "scenario key 'argz'"),
                    ("table", '[scenario]\nargs = ["x"]\n\n[extra]\nk = "v"\n', "scenario table [extra]"),
                    ("fields", '[scenario]\nargs = ["x"]\nfields = "yaml"\n', "fields = 'yaml'"),
                    ("bands", '[scenario]\nargs = ["x"]\nbands = ["n"]\n', "bands without fields"),
                    ("env", '[scenario]\nargs = ["x"]\n\n[env]\nPATH = "/x"\n', "[env].PATH"))
        for name, text, needle in refusals:
            p.write_text(text)
            try:
                load_scenario(p)
                bad.append(f"the scenario reader accepted the {name} case")
            except Refused as e:
                if needle not in str(e):
                    bad.append(f"the {name} refusal does not name it: {e}")
            except Unreadable as e:
                bad.append(f"the {name} case read as unreadable, not refused: {e}")
        p.write_text('[scenario]\nstdin = ["a"]\n')
        try:
            load_scenario(p)
            bad.append("a scenario without args loaded")
        except Unreadable:
            pass
        except Refused as e:
            bad.append(f"a scenario without args was refused, not unreadable: {e}")
    return bad


# ── the CLI ───────────────────────────────────────────────────────────────────
def main(argv):
    if not argv or argv[0] not in ("selftest", "resolve", "run", "summary"):
        print(__doc__.split("\n\n")[1]); return 2
    try:
        if argv[0] == "selftest":
            bad = selftest()
            for b in bad:
                print(f"cli.py: self-test FAILED — {b}")
            if bad:
                return 1
            print("cli.py: self-test ok — the SHA-1 reference vectors, the layout, the splitter and the scenario reader behave as designed")
            return 0
        if argv[0] == "resolve":
            print(resolve_tool(argv[1], os.environ.get("CLI_PATH", "")))
            return 0
        if argv[0] == "summary":
            lines = summary_lines(argv[1])
            for l in lines:
                print(l)
            return 1 if lines[0].startswith("FAIL") else 0
        if len(argv) < 5:
            print("usage: python3 -m bbx.cli run <tool> <scenario.cli> <out.log> <sandbox> [--nondet] [--timeout <s>]"); return 2
        tool, scen, out, sandbox = argv[1:5]
        rest = argv[5:]
        timeout = DEFAULT_TIMEOUT
        if "--timeout" in rest:
            timeout = float(rest[rest.index("--timeout") + 1])
        run(tool, scen, out, sandbox, nondet="--nondet" in rest, timeout=timeout)
        return 0
    except Refused as e:
        print(e); return 3
    except Crashed as e:
        print(f"cli.py: {e}"); return 2
    except Unreadable as e:
        print(f"cli.py: {e}"); return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

"""cli.py — the COMMAND-LINE kind: the OBSERVATION TOKEN VOCABULARY (S4 step 1; docs/plans/S4.md §3 "O1";
rulings R31, R35; D47). The driver's core — resolve, the sandbox, the scrub, run, the band view, summary,
the self-test — is S4 step 2 and grows THIS module, so the truth a fixture generator writes and the log
the driver writes share one writer of every token (the S3 shape: mkdocset.py imports bbx.docset).

The grammar (one space-free token per line; split in one place, by field name — BBX-12):
    0 exit:<n>                       the tool's exit status, the FIRST line and its own observation point
    <i> line:<sha1>                  one stdout line (fields absent): SHA-1 over the line's UTF-8, no newline
    <i> field:<name>:<sha1>          one key of the ONE JSON object stdout holds (fields = "json"), keys in
                                     SORTED order; the hash is over the value's CANONICAL JSON (sorted keys,
                                     no spaces, non-ASCII kept) so `"Maren"` and `6` and `["ash","elm"]` hash
                                     as what they are, not as printed
    <i> field:<name>:band            a BAND field (the scenario's `bands`): a constant — its value lives in the
                                     band view `<out>.bands` (`<i> <name>=<value>`, `END <n>`; O4, step 2),
                                     never in this log (the exact family would fail on every legitimate move)
    <i> err:<sha1>                   one stderr line
    <i> file:<name>:<sha1>           one declared emitted file (the scenario's `emits`), SHA-1 over its bytes
    END <n>                          n = the last index (0 when the tool wrote nothing and emitted nothing)
Order: exit, stdout (lines or fields), stderr, files. A field name holds no space and no colon.
"""
import hashlib
import json

BAND = "band"


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


def point_line(i, text):
    return f"{i} line:{sha1_text(text)}"


def point_field(i, name, value=None, band=False):
    return f"{i} field:{_name_ok(name)}:" + (BAND if band else sha1_text(canon(value)))


def point_err(i, text):
    return f"{i} err:{sha1_text(text)}"


def point_file(i, name, data):
    return f"{i} file:{_name_ok(name)}:{sha1_bytes(data)}"


def end(n):
    return f"END {n}"


def observation(status, stdout_lines=None, fields=None, bands=(), stderr_lines=(), files=()):
    """The whole log text: `fields` (a dict) means stdout was ONE JSON object and its keys are the points
    in sorted order; else `stdout_lines` are the points. `files` is [(name, bytes)] in declared order."""
    out = [point_exit(status)]
    i = 0
    if fields is not None:
        for k in sorted(fields):
            i += 1
            out.append(point_field(i, k, fields[k], band=k in bands))
    else:
        for text in (stdout_lines or ()):
            i += 1
            out.append(point_line(i, text))
    for text in stderr_lines:
        i += 1
        out.append(point_err(i, text))
    for name, data in files:
        i += 1
        out.append(point_file(i, name, data))
    out.append(end(i))
    return "\n".join(out) + "\n"

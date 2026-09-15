"""gen_gate_index.py — THE GATE INDEX is GENERATED (bbx gate-index).

    python3 -m bbx.gen_gate_index [--config bbx.toml] [--root DIR]   rewrite the index
    python3 -m bbx.gen_gate_index ... --check       regenerate, cmp, diff on drift (exit 1)
    python3 -m bbx.gen_gate_index ... --stdout      print the regenerated index instead

WHY THIS EXISTS (lineage: VampireSaved 14z-123, the documentation
rationalization pass). Its HANDOFF carried a 2,160-line hand-written fence
of `tests/x.sh   # comment` lines — 168 of the 281 scripts, 113 unindexed,
one duplicated, each comment a session narrative the script's own header
often lacked. The ruling: a gate's WHY lives in the gate's header; the index
is what a reader opens INSTEAD of the fence, and it cannot go stale — every
row is derived from the tree, and a consumer gate running `--check` fails
when the committed file differs from a regeneration.

WHAT A ROW IS. One per gate under the gates dir:
  gate    — the script
  kind    — from its name prefix ([gate_header].kinds: audit / run / test)
  tier    — the portable registry's name / the static registry's name /
            the instrument word (in neither: needs an instrument)
  family  — hand-assigned in the family file ([gate_header].families_tsv, the
            ONE hand-maintained input: a `.tsv` of `gate<TAB>family[<TAB>needs][<TAB>since]`,
            or a `.toml` of one bare table per gate with `gate`, `family` and
            optional `needs` and `since`); completeness is enforced both ways —
            a new script without a row, or a row whose script is gone, fails --check
  needs   — the family file's override, else derived: portable = nothing; static =
            the [registries].static_needs_env variable; instrument = the
            instruments its header names ([gate_header].needs_instruments,
            "a build dir" on needs_build_regex) + the first `~N min/s`
  locks   — the header's own first paragraph, cut at ~240 chars on a
            sentence end. The header is the source of truth; if a row
            reads badly, fix the header, not this tool.
  since   — the family file's override, else the first session token the header quotes
  controls, blind spots — BBX's further columns, rendered only when
            [gate_header].columns names them: the header's declared must-fire
            controls counted by shape, and the count of its `NOT-ASSERTED:` lines.
Rows are grouped by family ([gate_header].families, in that order), sorted
by name. The opening prose is [gate_header].index_preamble.

Lifted from bbh lib/py/bbh/gen_gate_index.py, with the parts of lib/py/bbh/gate_header.py
it reads (header_text, Settings, claim, first_session, first_duration, kind_of), at
10a82d2 (S6 step 3, ruled R63 and R68): the messages and the rendering of bbh's five
columns verbatim, each header read through BBX's one header reader (bbx.controls, R30),
every [gate_header] key read by its full name. Three deltas, each carried by a control in
gates/gate_index.sh: (1) --check compares BYTES, where bbh compares decoded text and
passes a CRLF copy (BBX-8); (2) the family file is read by its extension (R68) — a `.toml`
one is BBX's TOML-subset register, and a gate named twice in it, or a table naming no
gate, is a PROBLEM (BBX-17); (3) [gate_header].columns adds `controls` and `blind spots`
after bbh's five (R68). The defaults: docs/defaults.md D84, D85, D86.
"""
import argparse
import difflib
import re
import sys
from pathlib import Path

from . import config as C
from . import controls as K
from . import toml_subset

COLUMNS = ("controls", "blind spots")   # the names [gate_header].columns may hold (R68, D86)


# ---- the header contract: bbh lib/py/bbh/gate_header.py at 10a82d2 ----------------------------------------

def header_text(path, whole=False):
    """The header as one string: the FIRST PARAGRAPH (up to the first blank
    `#` line) by default, the WHOLE block with `whole=True`; the `#` markers
    and blank lines dropped, lines joined by a space. The lines are BBX's one
    header reader's (R30), which reads the whole leading block where bbh's
    reader stopped at 120 lines."""
    out = []
    for line in K.header_lines(path):
        t = line.lstrip("#").strip()
        if not t and out and not whole:
            break
        if t:
            out.append(t)
    return " ".join(out)


class Settings:
    """The [gate_header] section, read once, every key by its full name."""

    def __init__(self, cfg):
        self.title_sep = C.get(cfg, "gate_header.title_sep_regex")
        self.session_re = re.compile(C.get(cfg, "gate_header.session_regex"))
        self.duration_re = re.compile(C.get(cfg, "gate_header.duration_regex"))
        self.index_out = C.get(cfg, "gate_header.index_out")
        self.families_tsv = C.get(cfg, "gate_header.families_tsv")
        self.families = [(f[0], f[1]) for f in C.get(cfg, "gate_header.families")]
        self.kinds = [(k[0], k[1]) for k in C.get(cfg, "gate_header.kinds")]
        self.needs_instruments = [(k[0], k[1]) for k in C.get(cfg, "gate_header.needs_instruments")]
        self.needs_build_re = re.compile(C.get(cfg, "gate_header.needs_build_regex"))
        self.preamble = list(C.get(cfg, "gate_header.index_preamble"))
        self.columns = list(C.get(cfg, "gate_header.columns"))


def claim(name, head, settings):
    """The index sentence: the first paragraph with `<name>.sh —` stripped,
    whitespace collapsed, cut at ~240 chars on a sentence boundary."""
    t = re.sub(r"^" + re.escape(name) + settings.title_sep, "", head)
    t = re.sub(r"\s+", " ", t).strip()
    if len(t) <= 240:
        return t
    cut = t[:240]
    m = max(cut.rfind(". "), cut.rfind("; "), cut.rfind(": "))
    if m > 120:
        return cut[:m + 1].rstrip()
    return cut.rstrip() + "…"


def first_session(head, settings):
    m = settings.session_re.search(head)
    return m.group(1) if m else "—"


def first_duration(head, settings):
    m = settings.duration_re.search(head)
    return f"~{m.group(1)} {m.group(2)}" if m else ""


def kind_of(name, settings):
    for prefix, kind in settings.kinds:
        if name.startswith(prefix):
            return kind
    return "test"


# ---- the index: bbh lib/py/bbh/gen_gate_index.py at 10a82d2 ------------------------------------------------

def read_tsv(root, tsv):
    rows = {}
    p = root / tsv
    if not p.exists():
        return rows
    for line in p.read_text(encoding="utf-8").splitlines():
        if not line.strip() or line.startswith("#"):
            continue
        c = line.split("\t")
        rows[c[0]] = {"family": c[1] if len(c) > 1 else "",
                      "needs": c[2] if len(c) > 2 else "",
                      "since": c[3] if len(c) > 3 else ""}
    return rows


def read_toml(root, path):
    """BBX's family register (R68): one bare table per gate, `gate` and `family`, optional `needs` and `since`.
    Returns (rows, problems): a table naming no gate, and a gate named by two tables, are PROBLEMs (BBX-17)."""
    rows, problems = {}, []
    p = root / path
    if not p.exists():
        return rows, problems
    try:
        data = toml_subset.load(str(p))
    except (OSError, toml_subset.SubsetError) as e:
        return rows, [f"UNREADABLE {path}: {e}"]
    for table, t in data.items():
        gate = t.get("gate", "") if isinstance(t, dict) else ""
        if not gate:
            problems.append(f"ROW WITHOUT A GATE in {path}: [{table}]")
            continue
        if gate in rows:
            problems.append(f"DUPLICATE ROW in {path}: {gate}")
            continue
        rows[gate] = {"family": t.get("family", ""), "needs": t.get("needs", ""), "since": t.get("since", "")}
    return rows, problems


def read_families(root, path):
    """The family file by its extension (R68): `.toml` is BBX's register, anything else bbh's TSV."""
    if str(path).endswith(".toml"):
        return read_toml(root, path)
    return read_tsv(root, path), []


def registry_names(root, rel):
    p = root / rel
    if not p.exists():
        return set()
    return {l.strip() for l in p.read_text(encoding="utf-8").splitlines()
            if l.strip() and not l.startswith("#")}


def derive_needs(tier, head, s, tiers, static_needs, word):
    if tier == tiers["portable"]:
        return "—"
    if tier == tiers["static"]:
        return static_needs
    inst = []
    h = head.lower()
    for key, label in s.needs_instruments:
        if key in h and label not in inst:
            inst.append(label)
    if s.needs_build_re.search(h):
        inst.append("a build dir")
    dur = first_duration(head, s)
    return ", ".join(inst + ([dur] if dur else [])) or word


def controls_cell(path):
    """BBX's `controls` column: the declared must-fire controls counted by shape; `none` for a gate that declares
    it asserts nothing, `—` for one that declares nothing."""
    ctrls, none = K.declared(path)
    if not ctrls:
        return "none" if none is not None else "—"
    by = {}
    for shape, _, _ in ctrls:
        by[shape] = by.get(shape, 0) + 1
    return ", ".join(f"{n} {shape}" for shape, n in sorted(by.items()))


def blind_spots_cell(path):
    """BBX's `blind spots` column: the count of the header's `NOT-ASSERTED:` lines."""
    return str(sum(1 for line in K.header_lines(path)
                   if K.ENTRY.match(line) and K.ENTRY.match(line).group(1) == "NOT-ASSERTED"))


def collect(cfg, root):
    s = Settings(cfg)
    gates_dir = C.get(cfg, "project.gates_dir")
    gate_glob = C.get(cfg, "project.gate_glob")
    reg_port = C.get(cfg, "registries.portable")
    reg_stat = C.get(cfg, "registries.static")
    word = C.get(cfg, "project.instrument_word")
    static_needs = C.get(cfg, "registries.static_needs_env") or "—"
    tiers = {"portable": Path(reg_port).stem, "static": Path(reg_stat).stem, "instrument": word}
    tsv, problems = read_families(root, s.families_tsv)
    for c in s.columns:
        if c not in COLUMNS:
            problems.append(f"UNKNOWN COLUMN {c!r} in [gate_header].columns (known: {', '.join(COLUMNS)})")
    port, stat = registry_names(root, reg_port), registry_names(root, reg_stat)
    fam_names = [f for f, _ in s.families]
    scripts = sorted((root / gates_dir).glob(gate_glob))
    rows, seen = [], set()
    for p in scripts:
        gate = f"{gates_dir}/{p.name}"
        seen.add(gate)
        head = header_text(p)
        whole = header_text(p, whole=True)
        tier = tiers["portable"] if p.stem in port else tiers["static"] if p.stem in stat else tiers["instrument"]
        t = tsv.get(gate)
        if t is None:
            problems.append(f"NO FAMILY ROW in {s.families_tsv}: {gate}")
            fam = "?"
            needs = since = ""
        else:
            fam, needs, since = t["family"], t["needs"], t["since"]
            if fam not in fam_names:
                problems.append(f"UNKNOWN FAMILY {fam!r} for {gate}")
        rows.append({"gate": gate, "kind": kind_of(p.name, s), "tier": tier, "family": fam,
                     "needs": needs or derive_needs(tier, whole, s, tiers, static_needs, word),
                     "locks": claim(p.name, head, s) or "(no header sentence — write one)",
                     "since": since or first_session(whole, s),
                     "controls": controls_cell(p), "blind spots": blind_spots_cell(p)})
    for gate in tsv:
        if gate not in seen:
            problems.append(f"DEAD ROW in {s.families_tsv}: {gate} (script gone)")
    return rows, problems, s, tiers


def cell(x):
    return x.replace("|", "\\|")


def render(rows, s, tiers):
    extra = [c for c in s.columns if c in COLUMNS]
    out = ["\n".join(s.preamble) + "\n"]
    n = len(rows)
    tp, ts, ti = tiers["portable"], tiers["static"], tiers["instrument"]
    count = {t: sum(1 for r in rows if r["tier"] == t) for t in (tp, ts, ti)}
    out.append(f"**{n} scripts** — {count[tp]} {tp}, {count[ts]} {ts}, "
               f"{count[ti]} {ti}-tier (run by name).\n")
    out.append("| family | scripts | what the family is |\n|---|---|---|")
    for f, desc in s.families:
        out.append(f"| [{f}](#{f}) | {sum(1 for r in rows if r['family'] == f)} | {desc} |")
    out.append("")
    for f, desc in s.families:
        fam_rows = [r for r in rows if r["family"] == f]
        if not fam_rows:
            continue
        out.append(f"## {f}\n")
        out.append(f"{desc}.\n")
        out.append("| gate | kind | tier | needs | locks (the script's own header) | since |"
                   + "".join(f" {c} |" for c in extra)
                   + "\n|---|---|---|---|---|---|" + "---|" * len(extra))
        for r in sorted(fam_rows, key=lambda r: r["gate"]):
            out.append(f"| `{r['gate']}` | {r['kind']} | {r['tier']} | {cell(r['needs'])} | {cell(r['locks'])} | {cell(r['since'])} |"
                       + "".join(f" {cell(r[c])} |" for c in extra))
        out.append("")
    fam_names = [f for f, _ in s.families]
    unk = [r for r in rows if r["family"] not in fam_names]
    if unk:
        out.append(f"## UNASSIGNED (fix {s.families_tsv})\n")
        out.append("| gate | tier |\n|---|---|")
        for r in unk:
            out.append(f"| `{r['gate']}` | {r['tier']} |")
        out.append("")
    return "\n".join(out)


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default=None)
    ap.add_argument("--root", default=None)
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--stdout", action="store_true")
    a = ap.parse_args(argv)
    cfg, root = C.consumer(a.config, a.root)
    root = Path(root)
    rows, problems, s, tiers = collect(cfg, root)
    for p in problems:
        print("PROBLEM " + p)
    text = render(rows, s, tiers)
    if a.stdout:
        sys.stdout.write(text)
        return 1 if problems else 0
    dst = root / s.index_out
    data = text.encode("utf-8")
    if a.check:
        cur = dst.read_bytes() if dst.exists() else b""
        if cur != data:   # BYTES, not decoded text: a CRLF copy is stale (BBX's first delta)
            print(f"STALE {s.index_out} differs from a regeneration:")
            diff = list(difflib.unified_diff(cur.decode("utf-8", "replace").splitlines(), text.splitlines(),
                                             "committed", "regenerated", lineterm=""))[:40]
            for line in diff:
                print("  " + line)
            if not diff:
                print("  (no line differs and the bytes do: line endings, a final newline or the encoding)")
            return 1
        if problems:
            return 1
        print(f"ok    {s.index_out} is current ({len(rows)} scripts, every one with a family)")
        return 0
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_bytes(data)
    print(f"wrote {s.index_out} ({len(rows)} scripts; {len(problems)} problems)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())

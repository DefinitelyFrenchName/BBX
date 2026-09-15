#!/bin/sh
# registers.sh — the defaults register and the documents register hold against the code and the pages, and every finding either check can print fires on a planted copy
# Ruled R61, R62 and R66 (S6 step 2, bbx-29). `bbx defaults --check` (lib/py/bbx/defaults.py, D81) holds
# docs/defaults.md in R61's form, both ways against config.py's DEFAULTS and the ${BBX_*:-} fallbacks,
# and requires every default to have a reader (R66). `bbx documents --check` (lib/py/bbx/documents.py,
# D82) holds docs/documents.toml against the tracked pages: completeness, shapes, twins, routes (R62).
# Every finding each tool can print is planted in a COPY of the tree and required by its own line, after
# the unplanted copy has read errors=0 — so a control fires for its own reason and never for a real
# finding the copy inherited (G53). Every plant asserts it changed the text it names (G83).
# Usage: gates/registers.sh        Portable, ~5 s (5, 5 and 4 s over its first three full runs, bbx-29).
# MUST-FIRE: perturbed-copy: table-headers — a second table header line in the defaults register must FAIL counting two
# MUST-FIRE: perturbed-copy: table-cut — a paragraph between two rows of the defaults register must FAIL naming the line
# MUST-FIRE: perturbed-copy: ids-out-of-order — two rows swapped must FAIL naming where the order breaks
# MUST-FIRE: perturbed-copy: unescaped-pipe — D62's escaped pipe written bare must FAIL counting seven cells
# MUST-FIRE: perturbed-copy: default-no-class — a row whose class cell is empty must FAIL naming the row (the slice row's "a default with no class")
# MUST-FIRE: perturbed-copy: class-outside-vocabulary — a class cell reading principled-ish must FAIL naming the row
# MUST-FIRE: perturbed-copy: key-without-row — a DEFAULTS key taken out of its row's default cell must FAIL naming the key
# MUST-FIRE: perturbed-copy: key-in-several-rows — a DEFAULTS key named in the default cell of a second row must FAIL naming both rows
# MUST-FIRE: perturbed-copy: row-without-key — the removed [project].lib_dir named again in D8's default cell must FAIL as a row naming a key the code lacks
# MUST-FIRE: perturbed-copy: fallback-without-row — a ${BBX_*:-} fallback no row names, planted in the code, must FAIL naming the variable
# MUST-FIRE: perturbed-copy: name-without-code — a BBX_ variable a row names and no code carries must FAIL naming the row and the variable
# MUST-FIRE: perturbed-copy: key-without-reader — [project].lib_dir restored to DEFAULTS and to D8, read by nothing, must FAIL naming it and nothing else (R66, the incident itself)
# MUST-FIRE: perturbed-copy: short-name-no-rescue — the same key with a short-name read and a commented full name must still FAIL, and a real full-name read must clear it (R66)
# MUST-FIRE: perturbed-copy: declared-list-drop — a key dropped from fingerprint.py's _KEYS must FAIL as a key without a reader (R66)
# MUST-FIRE: perturbed-copy: runtime-reader-gone — fingerprint.py's name builder rewritten must FAIL naming the declared reader, never read as still declared
# MUST-FIRE: perturbed-copy: runtime-reader-unknown-key — a name in _KEYS that DEFAULTS lacks must FAIL naming it
# MUST-FIRE: perturbed-copy: undeclared-document — a tracked page whose register row is removed must FAIL naming the page
# MUST-FIRE: perturbed-copy: dead-document-row — a row for a page the tree does not track must FAIL naming the row
# MUST-FIRE: perturbed-copy: duplicate-document — a page given a second row must FAIL naming both tables
# MUST-FIRE: perturbed-copy: row-fields — a row missing its routed_by field must FAIL naming the table
# MUST-FIRE: perturbed-copy: unknown-shape — a row whose shape is not one of the fifteen must FAIL naming the row and the shape
# MUST-FIRE: perturbed-copy: shape-disagrees — HANDOFF's Shape line put back to its old wording must FAIL quoting the line
# MUST-FIRE: perturbed-copy: living-without-twin — a living row whose twin is emptied must FAIL naming the page (the slice row's "a document with no twin")
# MUST-FIRE: perturbed-copy: history-without-twin — a history row whose twin is emptied must FAIL naming the page
# MUST-FIRE: perturbed-copy: twin-not-back — a history row naming another living page must FAIL on the living page whose twin no longer names it back
# MUST-FIRE: perturbed-copy: twin-on-shape — a reference row given a twin must FAIL naming the page and its shape
# MUST-FIRE: perturbed-copy: root-count — a second row routed from root must FAIL naming both roots
# MUST-FIRE: perturbed-copy: unrouted-document — a page routed by a map that never names its path must FAIL naming the page and the router
# NOT-ASSERTED: that a row's class is TRUE of its default: only its grammar and vocabulary are read, and a wrong class inside the vocabulary passes (R61)
# NOT-ASSERTED: that a key with a reader changes anything: a line naming `section.key` is found, never what the value does (R66)
# NOT-ASSERTED: a full name inside a Python string or docstring: it counts as a reader, so a dead key a docstring names passes; only markdown files, `#` lines and the DEFAULTS and KINDS literals are set aside (D81)
# NOT-ASSERTED: environment fallbacks written in Python (`os.environ.get`): only the shell's `${BBX_*:-}` form is searched, and D75 and D77 register the Python ones by hand
# NOT-ASSERTED: that a page's content fits its shape: only the register, the first word of a `Shape:` line in the first 12 lines, the twins and the routes are read, and a page with no `Shape:` line is not asked to carry one (D82)
# NOT-ASSERTED: that a route can be followed: a router is proven to name the page's path, never that the sentence around it leads a reader there
# NOT-ASSERTED: counts and statuses written in the pages (G54): BBX's `docs/` read as a document-set subject is G54's candidate, named in R59
# NOT-ASSERTED: that either check is generic: each has one consumer, BBX's own `docs/defaults.md` and `docs/documents.toml` over BBX's own tree (R50)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
cd "$BBX_HOME"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
SUM() { python3 -m bbx.sha1 "$1" | cut -d" " -f1; }
B_DEF="$(SUM docs/defaults.md)"; B_DOC="$(SUM docs/documents.toml)"

echo "== 1. the real registers =="
for tool in defaults documents; do
    if python3 -m "bbx.$tool" --check > "$T/real_$tool.out" 2>&1; then
        ok "$(tail -1 "$T/real_$tool.out")"
    else
        fail "$(tail -1 "$T/real_$tool.out")"; grep '^ERROR' "$T/real_$tool.out" | head -8 | sed 's/^/        /'
    fi
done

echo "== 2. a copy of the tree, unplanted, reads errors=0 =="
C="$T/copy"; mkdir -p "$C"
git ls-files -c -o --exclude-standard -z | xargs -0 tar -cf - | tar -xf - -C "$C"
git -C "$C" init -q && git -C "$C" add -A
clean=1
for tool in defaults documents; do
    if python3 -m "bbx.$tool" --check --root "$C" > "$T/copy_$tool.out" 2>&1; then
        ok "copy: $(tail -1 "$T/copy_$tool.out")"
    else
        clean=0; fail "the unplanted copy reads a finding, so no control below can be read: $(tail -1 "$T/copy_$tool.out")"
    fi
done

echo "== 3. MUST-FIRE: every finding planted in the copy, required by its line, the copy restored after each =="
if [ "$clean" = 1 ]; then
    cat > "$T/plant.py" <<'PYEOF'
import hashlib, os, re, subprocess, sys
C = sys.argv[1]
def rd(p): return open(os.path.join(C, p), encoding="utf-8").read()
def wr(p, t): open(os.path.join(C, p), "w", encoding="utf-8").write(t)
def sub(p, old, new, count=1):
    t = rd(p)
    if old not in t:
        raise AssertionError(f"plant did not apply: {old[:50]!r} not in {p}")
    wr(p, t.replace(old, new, count))
def append(p, text): wr(p, rd(p) + text)
def field(table, name, value):
    t = rd("docs/documents.toml")
    m = re.search(r"(?ms)^\[" + table + r"\]\n(.*?)(?=^\[|\Z)", t)
    block = m.group(1)
    new = re.sub(r'(?m)^' + name + r' = ".*"$', f'{name} = "{value}"', block, count=1)
    if new == block:
        raise AssertionError(f"plant did not apply: {table}.{name}")
    wr("docs/documents.toml", t[:m.start(1)] + new + t[m.end(1):])
def drop_table(table):
    t = rd("docs/documents.toml")
    new = re.sub(r"(?ms)^\[" + table + r"\]\n.*?(?=^\[|\Z)", "", t, count=1)
    if new == t:
        raise AssertionError(f"plant did not apply: drop [{table}]")
    wr("docs/documents.toml", new)
def swap_lines(p, a, b):
    ls = rd(p).split("\n")
    i, j = next(n for n, l in enumerate(ls) if l.startswith(a)), next(n for n, l in enumerate(ls) if l.startswith(b))
    ls[i], ls[j] = ls[j], ls[i]
    wr(p, "\n".join(ls))
def run(tool):
    r = subprocess.run([sys.executable, "-m", f"bbx.{tool}", "--check", "--root", C], capture_output=True, text=True)
    return r.returncode, r.stdout
D, M = "docs/defaults.md", "docs/documents.toml"
# The two planted variable names are ASSEMBLED here and never written whole: this file sits under gates/,
# which the defaults check scans, so a literal fallback in it read as a real unregistered fallback and
# reddened the real tree on this gate's first run, and a literal name would have kept name-without-code
# from ever firing (bbx-29).
PLANTED_FALLBACK = "BBX_" + "PLANTED_FALLBACK"
PLANTED_NOWHERE = "BBX_" + "PLANTED_NOWHERE"
RESTORE_KEY = ('        "gate_glob": "*.sh",\n', '        "gate_glob": "*.sh",\n        "lib_dir": "tests/lib",\n')
D8_KEY = ("`[project].gate_glob` *.sh, `[project].runner_prefixes`", "`[project].gate_glob` *.sh, `[project].lib_dir` tests/lib, `[project].runner_prefixes`")
def restore_lib_dir():
    sub("lib/py/bbx/config.py", *RESTORE_KEY); sub(D, *D8_KEY)
CONTROLS = [
    ("table-headers", "defaults", lambda: append(D, "| id | default | value | where it lives | class | why / measured on |\n"), r"^ERROR: table-headers count=2$"),
    ("table-cut", "defaults", lambda: sub(D, "\n| D23 |", "\n\nA paragraph.\n| D23 |"), r"^ERROR: table-cut line=\d+$"),
    ("ids-out-of-order", "defaults", lambda: swap_lines(D, "| D5 |", "| D6 |"), r"^ERROR: ids-out-of-order at=D6"),
    ("unescaped-pipe", "defaults", lambda: sub(D, "program\\|wholeset", "program|wholeset"), r"^ERROR: cells D62 count=7 "),
    ("default-no-class", "defaults", lambda: sub(D, "`bbx.toml` sets `true` | principled |", "`bbx.toml` sets `true` |  |"), r"^ERROR: no-class D10 "),
    ("class-outside-vocabulary", "defaults", lambda: sub(D, "`bbx.toml` sets `true` | principled |", "`bbx.toml` sets `true` | principled-ish |"), r"^ERROR: class-outside-vocabulary D10 "),
    ("key-without-row", "defaults", lambda: sub(D, "`[sweep].env_defaults`, `[sweep].prereq_cite` |", "`[sweep].env_defaults` |"), r"^ERROR: key-without-row \[sweep\]\.prereq_cite$"),
    ("key-in-several-rows", "defaults", lambda: sub(D, "| D5 | the platform floor |", "| D5 | the platform floor, `[controls].enforce` |"), r"^ERROR: key-in-several-rows \[controls\]\.enforce rows=D5,D10$"),
    ("row-without-key", "defaults", lambda: sub(D, *D8_KEY), r"^ERROR: row-without-key D8 \[project\]\.lib_dir "),
    ("fallback-without-row", "defaults", lambda: append("lib/sh/baseline.sh", ': "${' + PLANTED_FALLBACK + ':-x}"\n'), r"^ERROR: fallback-without-row " + PLANTED_FALLBACK + "$"),
    ("name-without-code", "defaults", lambda: sub(D, "env `BBX_CENSUS_TIMEOUT`", "env `BBX_CENSUS_TIMEOUT` and `" + PLANTED_NOWHERE + "`"), r"^ERROR: name-without-code D1 " + PLANTED_NOWHERE + " "),
    ("key-without-reader", "defaults", restore_lib_dir, r"^ERROR: key-without-reader \[project\]\.lib_dir$"),
    ("short-name-no-rescue", "defaults", lambda: (restore_lib_dir(), append("lib/py/bbx/tier.py", '\n_planted = {}.get("lib_dir")\n# project.lib_dir\n')), r"^ERROR: key-without-reader \[project\]\.lib_dir$"),
    ("declared-list-drop", "defaults", lambda: sub("lib/py/bbx/fingerprint.py", '"program_command", "wholeset_command")', '"program_command")'), r"^ERROR: key-without-reader \[fingerprint\]\.wholeset_command$"),
    ("runtime-reader-gone", "defaults", lambda: sub("lib/py/bbx/fingerprint.py", '"fingerprint." + k)', '"fingerprint." + key)'), r"^ERROR: runtime-reader-gone lib/py/bbx/fingerprint\.py _KEYS "),
    ("runtime-reader-unknown-key", "defaults", lambda: sub("lib/py/bbx/fingerprint.py", '_KEYS = ("kind",', '_KEYS = ("kind", "planted_key",'), r"^ERROR: runtime-reader-unknown-key lib/py/bbx/fingerprint\.py _KEYS \[fingerprint\]\.planted_key$"),
    ("undeclared-document", "documents", lambda: drop_table("d40"), r"^ERROR: undeclared-document fixture/docset/subject/weights\.md$"),
    ("dead-document-row", "documents", lambda: append(M, '\n[d99]\nfile = "docs/planted_nowhere.md"\nshape = "reference"\ntwin = ""\nrouted_by = "HANDOFF.md"\n'), r"^ERROR: dead-document-row \[d99\] docs/planted_nowhere\.md$"),
    ("duplicate-document", "documents", lambda: append(M, '\n[d98]\nfile = "docs/gotchas.md"\nshape = "ledger"\ntwin = ""\nrouted_by = "HANDOFF.md"\n'), r"^ERROR: duplicate-document docs/gotchas\.md tables=d23,d98$"),
    ("row-fields", "documents", lambda: append(M, '\n[d97]\nfile = "docs/gotchas.md"\nshape = "ledger"\ntwin = ""\n'), r"^ERROR: row-fields \[d97\] "),
    ("unknown-shape", "documents", lambda: field("d23", "shape", "logbook"), r"^ERROR: unknown-shape \[d23\] docs/gotchas\.md shape='logbook'$"),
    ("shape-disagrees", "documents", lambda: sub("HANDOFF.md", "Shape: map, operational.", "Shape: operational map."), r"^ERROR: shape-disagrees HANDOFF\.md row=map page=operational line=3 quote="),
    ("living-without-twin", "documents", lambda: field("d7", "twin", ""), r"^ERROR: living-without-twin STATE\.md twin=''$"),
    ("history-without-twin", "documents", lambda: field("d4", "twin", ""), r"^ERROR: history-without-twin FIRST_PROMPT\.md twin=''$"),
    ("twin-not-back", "documents", lambda: field("d8", "twin", "DECISIONS.md"), r"^ERROR: twin-not-back STATE\.md twin=STATE_HISTORY\.md "),
    ("twin-on-shape", "documents", lambda: field("d19", "twin", "docs/gotchas.md"), r"^ERROR: twin-on-shape docs/controls\.md shape=reference "),
    ("root-count", "documents", lambda: field("d7", "routed_by", "root"), r"^ERROR: root-count roots=HANDOFF\.md,STATE\.md$"),
    ("unrouted-document", "documents", lambda: field("d6", "routed_by", "docs/bins.md"), r"^ERROR: unrouted-document README\.md routed_by=docs/bins\.md \(does not name the path\)$"),
]
def snapshot():
    out = {}
    for p in (D, M, "lib/py/bbx/config.py", "lib/py/bbx/fingerprint.py", "lib/py/bbx/tier.py", "lib/sh/baseline.sh", "HANDOFF.md"):
        out[p] = rd(p)
    return out
dead = 0
for name, tool, plant, want in CONTROLS:
    before = snapshot()
    try:
        plant()
        rc, out = run(tool)
        hit = [l for l in out.split("\n") if re.search(want, l)]
        extra = ""
        if name == "key-without-reader" and not re.search(r"errors=1$", out.strip().split("\n")[-1]):
            hit, extra = [], " (a finding other than the restored key was also printed)"
        if name == "short-name-no-rescue" and hit:
            append("lib/py/bbx/tier.py", '_planted_full = "project.lib_dir"\n')
            rc2, out2 = run(tool)
            if rc2 != 0:
                hit, extra = [], " (a full-name read did not clear the key: " + out2.strip().split("\n")[-1] + ")"
        if rc != 0 and hit:
            print(f"CONTROL FIRED: {name} — {hit[0][:150]}")
        else:
            dead += 1
            print(f"CONTROL DEAD: {name} — exit {rc}, wanted /{want}/{extra}; got: {out.strip().split(chr(10))[-1][:120]}")
    except AssertionError as e:
        dead += 1
        print(f"CONTROL DEAD: {name} — {e}")
    finally:
        for p, t in before.items():
            wr(p, t)
    if snapshot() != before:
        print(f"CONTROL DEAD: {name} — the copy was not restored"); dead += 1
print(f"controls={len(CONTROLS)} dead={dead}")
sys.exit(1 if dead else 0)
PYEOF
    if python3 "$T/plant.py" "$C" > "$T/controls.out" 2>&1; then
        grep '^CONTROL' "$T/controls.out"; ok "$(tail -1 "$T/controls.out")"
    else
        grep '^CONTROL' "$T/controls.out" || true
        fail "$(tail -1 "$T/controls.out")"
    fi
    for tool in defaults documents; do
        python3 -m "bbx.$tool" --check --root "$C" > "$T/after_$tool.out" 2>&1 && ok "copy restored: $(tail -1 "$T/after_$tool.out")" \
          || fail "the copy reads a finding after the controls: $(tail -1 "$T/after_$tool.out")"
    done
else
    fail "section 3 not run: the unplanted copy was not clean"
fi

echo "== 4. the tracked registers are untouched BY THIS GATE =="
[ "$(SUM docs/defaults.md)" = "$B_DEF" ] && [ "$(SUM docs/documents.toml)" = "$B_DOC" ] \
  && ok "docs/defaults.md and docs/documents.toml are byte-identical to before this gate ran; every plant was in the copy" \
  || fail "THIS GATE wrote a tracked register"

printf '\nNOTE: defaults %s\n' "$(tail -1 "$T/real_defaults.out" | cut -d' ' -f2-)"
printf 'NOTE: documents %s\n' "$(tail -1 "$T/real_documents.out" | cut -d' ' -f2-)"
echo
[ "$rc" = 0 ] && echo "PASS: both registers hold against the code and the pages, and every finding either check can print fires on a planted copy" \
  || { echo "FAIL: see above"; exit 1; }

#!/bin/sh
# references.sh — the paths, file:line citations and G, X and R ids in the pages that state what is true now resolve, and every finding the check can print fires on a planted copy
# Ruled R64 and R67 (S6 step 4, bbx-31). `bbx references --check` (lib/py/bbx/references.py, D89) reads the pages whose
# shape in docs/documents.toml is constitution, living, map, procedure, reference or register: a backticked rooted path
# resolves among the tracked files and their directories or carries a lineage prefix, a file:line ends inside its
# file, and a cited G, X or R id is defined. Every finding is planted in a COPY of the tree after the unplanted copy
# reads errors=0; a control that expects no finding requires instead the count its plant moves, against the unplanted
# copy's, so it fires for its own reason and never for a real finding the copy inherited (G53).
# Usage: gates/references.sh        Portable, ~2 s (2.23 s on its first full run, bbx-31).
# MUST-FIRE: perturbed-copy: dead-path — a rooted path to a file the tree does not track, planted in STATE.md, must FAIL naming the page, the line and the path
# MUST-FIRE: perturbed-copy: line-past-end — gates/controls.sh cited at line 9999 in STATE.md must FAIL naming the citation and the file's length
# MUST-FIRE: perturbed-copy: undefined-id — G999 cited in STATE.md must FAIL naming the page, the line and the id
# MUST-FIRE: perturbed-copy: history-keeps-paths — the same dead path planted in STATE_HISTORY.md, a history page, must read no finding and leave the tokens count unchanged
# MUST-FIRE: perturbed-copy: queue-not-read — the same dead path planted in docs/rulings.md, the queue, must read no finding and leave the tokens count unchanged (R67)
# MUST-FIRE: perturbed-copy: unrooted-not-claimed — a token whose first segment is no top-level entry, planted in STATE.md, must read no finding and raise not_a_path_claim by one (R67)
# MUST-FIRE: perturbed-copy: lineage-not-resolved — a path under a lineage prefix, planted in STATE.md, must read no finding and raise lineage by one
# MUST-FIRE: perturbed-copy: ignored-file-not-resolved — a path to a file git ignores, written on disk in the copy and planted in STATE.md, must FAIL as a dead path, as it reads on a clone (G95)
# MUST-FIRE: perturbed-copy: page-not-found — a register row in scope naming a page the tree does not track must FAIL naming the page
# MUST-FIRE: perturbed-copy: no-pages — every in-scope shape renamed out of the register must FAIL as no pages, or a check that reads nothing passes (BBX-8)
# NOT-ASSERTED: a token that is not a path claim, whose first segment is no top-level entry and which carries no lineage prefix: it is counted on the NOTE line, never resolved (R67)
# NOT-ASSERTED: a path under a lineage prefix: it is recognised by its prefix and never resolved in its lineage's tree
# NOT-ASSERTED: a path written without backticks or without a directory part, and a file:line into a lineage file
# NOT-ASSERTED: the pages of every other shape (history, ledger, queue, proposal, census, readout, kept-run, generated, fixture), whose paths are records or a subject's content (R67)
# NOT-ASSERTED: that a resolving path or a defined id is the one its sentence means: only existence, and a line inside the file, are read
# NOT-ASSERTED: that the check is generic: its one consumer is BBX's own pages, with its documents register and its three id ledgers (R50)
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
PAGES="STATE.md STATE_HISTORY.md docs/rulings.md docs/documents.toml"
before="$(for p in $PAGES; do SUM "$p"; done | tr '\n' ' ')"

echo "== 1. the real pages =="
if python3 -m bbx.references --check > "$T/real.out" 2>&1; then
    ok "$(tail -1 "$T/real.out")"
else
    fail "$(tail -1 "$T/real.out")"; grep '^ERROR' "$T/real.out" | head -8 | sed 's/^/        /'
fi

echo "== 2. a copy of the tree, unplanted, reads errors=0 =="
C="$T/copy"; mkdir -p "$C"
git ls-files -c -o --exclude-standard -z | xargs -0 tar -cf - | tar -xf - -C "$C"
git -C "$C" init -q && git -C "$C" add -A
clean=1
if python3 -m bbx.references --check --root "$C" > "$T/copy.out" 2>&1; then
    ok "copy: $(tail -1 "$T/copy.out")"
else
    clean=0; fail "the unplanted copy reads a finding, so no control below can be read: $(tail -1 "$T/copy.out")"
fi

echo "== 3. MUST-FIRE: every finding planted in the copy, required by its line or by the count it moves, the copy restored after each =="
if [ "$clean" = 1 ]; then
    cat > "$T/plant.py" <<'PYEOF'
import os, re, subprocess, sys
C = sys.argv[1]
M, S, H, Q = "docs/documents.toml", "STATE.md", "STATE_HISTORY.md", "docs/rulings.md"
IGNORED = "gates/planted.log"
def rd(p): return open(os.path.join(C, p), encoding="utf-8").read()
def wr(p, t): open(os.path.join(C, p), "w", encoding="utf-8").write(t)
def append(p, text): wr(p, rd(p) + text)
def run():
    r = subprocess.run([sys.executable, "-m", "bbx.references", "--check", "--root", C], capture_output=True, text=True)
    last = r.stdout.strip().split("\n")[-1]
    return r.returncode, r.stdout, dict(kv.split("=", 1) for kv in last.split() if "=" in kv)
def plant_ignored():
    wr(IGNORED, "planted\n")
    if subprocess.run(["git", "-C", C, "check-ignore", "-q", IGNORED]).returncode != 0:
        raise AssertionError(f"plant did not apply: {IGNORED} is not ignored in the copy")
    append(S, "\nA planted `" + IGNORED + "`.\n")
def plant_no_pages():
    t = rd(M)
    new = re.sub(r'(?m)^shape = "(constitution|living|map|procedure|reference|register)"$', 'shape = "proposal"', t)
    if new == t:
        raise AssertionError("plant did not apply: no in-scope shape in the register")
    wr(M, new)
def finding(pattern):
    return lambda rc, out, f, base: rc == 1 and re.search(pattern, out, re.M) is not None
def quiet(field, delta):
    return lambda rc, out, f, base: rc == 0 and f.get("errors") == "0" and int(f.get(field, -1)) == int(base[field]) + delta
_, _, BASE = run()
CONTROLS = [
    ("dead-path", lambda: append(S, "\nA planted `gates/planted_nowhere.sh`.\n"), finding(r"^ERROR: dead-path STATE\.md:\d+ gates/planted_nowhere\.sh$")),
    ("line-past-end", lambda: append(S, "\nA planted `gates/controls.sh:9999`.\n"), finding(r"^ERROR: line-past-end STATE\.md:\d+ gates/controls\.sh:9999 lines=\d+$")),
    ("undefined-id", lambda: append(S, "\nA planted G999.\n"), finding(r"^ERROR: undefined-id STATE\.md:\d+ G999$")),
    ("history-keeps-paths", lambda: append(H, "\nA planted `gates/planted_nowhere.sh`.\n"), quiet("tokens", 0)),
    ("queue-not-read", lambda: append(Q, "\nA planted `gates/planted_nowhere.sh`.\n"), quiet("tokens", 0)),
    ("unrooted-not-claimed", lambda: append(S, "\nA planted `subject/planted_nowhere.py`.\n"), quiet("not_a_path_claim", 1)),
    ("lineage-not-resolved", lambda: append(S, "\nA planted `lib/py/bbh/planted_nowhere.py`.\n"), quiet("lineage", 1)),
    ("ignored-file-not-resolved", plant_ignored, finding(r"^ERROR: dead-path STATE\.md:\d+ gates/planted\.log$")),
    ("page-not-found", lambda: append(M, '\n[d99]\nfile = "docs/planted_nowhere.md"\nshape = "reference"\ntwin = ""\nrouted_by = "HANDOFF.md"\n'), finding(r"^ERROR: page-not-found docs/planted_nowhere\.md$")),
    ("no-pages", plant_no_pages, finding(r"^ERROR: no-pages docs/documents\.toml ")),
]
def snapshot():
    return {p: rd(p) for p in (M, S, H, Q)}
dead = 0
for name, plant, fired in CONTROLS:
    before = snapshot()
    try:
        plant()
        rc, out, f = run()
        if fired(rc, out, f, BASE):
            hit = [l for l in out.split("\n") if l.startswith("ERROR")] or [out.strip().split("\n")[-1]]
            print(f"CONTROL FIRED: {name} — {hit[0][:150]}")
        else:
            dead += 1
            print(f"CONTROL DEAD: {name} — exit {rc}; got: {out.strip().split(chr(10))[-1][:160]}")
    except AssertionError as e:
        dead += 1
        print(f"CONTROL DEAD: {name} — {e}")
    finally:
        for p, t in before.items():
            wr(p, t)
        if os.path.exists(os.path.join(C, IGNORED)):
            os.remove(os.path.join(C, IGNORED))
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
    python3 -m bbx.references --check --root "$C" > "$T/after.out" 2>&1 && ok "copy restored: $(tail -1 "$T/after.out")" \
      || fail "the copy reads a finding after the controls: $(tail -1 "$T/after.out")"
else
    fail "section 3 not run: the unplanted copy was not clean"
fi

echo "== 4. the tracked pages are untouched BY THIS GATE =="
[ "$(for p in $PAGES; do SUM "$p"; done | tr '\n' ' ')" = "$before" ] \
  && ok "$PAGES are byte-identical to before this gate ran; every plant was in the copy" \
  || fail "THIS GATE wrote a tracked page"

printf '\nNOTE: references %s\n' "$(tail -1 "$T/real.out" | cut -d' ' -f2-)"
echo
[ "$rc" = 0 ] && echo "PASS: the paths, file:line citations and ids in the pages that state what is true now resolve, and every finding the check can print fires on a planted copy" \
  || { echo "FAIL: see above"; exit 1; }

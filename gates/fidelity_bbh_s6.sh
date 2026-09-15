#!/bin/sh
# fidelity_bbh_s6.sh — BBX's lifted gate index and trap lint reproduce bbh's printed text and exit byte for byte over bbh's example and bbh's own selftest cases (F19)
# THE FIDELITY OBLIGATION for S6's two lifts (CLAUDE.md §7.2; docs/fidelity.md F19; rulings R63, R68): `bin/bbx gate-index`
# (lib/py/bbx/gen_gate_index.py) and `bin/bbx demand-after-trap` (lib/py/bbx/demand_after_trap.py), lifted from bbh at
# the baseline, run beside bbh's own `bin/bbh` over the SAME inputs, every printed line and the exit diffed, with no
# normalisation. F19a: bbh's example on the clone (--check, --stdout, a family row taken out, a row for a gone gate, a
# hand-edited index, the index written by each side on its own copy) and the synthetic root of bbh's
# selftest/test_gate_index.sh; F19b: bbh's example's tests/ with its lib/, and the cases of bbh's
# selftest/test_demand_after_trap.sh, whose two scripts are checked byte for byte against bbh's own printf lines.
# BBX's deltas are neutral over these inputs because none reaches one: every index is LF, every family file a TSV,
# no config names a column, no directory is missing, and no file without a .sh name carries a shell shebang;
# gates/gate_index.sh and gates/trap_lint.sh assert the deltas. Every planted $ and < is an octal escape (G89).
# D85 (G96): every key of bbh's DEFAULTS["gate_header"], imported from the clone, is compared by value with what BBX's
# resolver returns for a config naming no kind, so bbh's literals written under another kind's name read as a difference.
# Usage: BBX_BBH_HOME=~/Developer/blackbox-harness gates/fidelity_bbh_s6.sh     (static tier)
# SKIP: BBX_BBH_HOME unset or not a bbh tree (exit 0; asserts nothing).
# READ-ONLY (R18, R20): bbh on a PLAIN LOCAL CLONE of the baseline (lib/sh/baseline.sh, docs/defaults.md D20) under
# TMPDIR, required clean of tracked, untracked and ignored entries after the run; every perturbed input is a copy;
# PYTHONDONTWRITEBYTECODE=1 for the whole gate.
# MUST-FIRE: shadow-tool: verdict-text-f19 — a shadow BBX home whose lifted gate index prints one verdict string changed and whose lifted lint prints its hit line changed must make an F19a pair and an F19b pair each differ, or the diff cannot fail
# MUST-FIRE: perturbed-copy: d85-profile-misplaced — a copy of BBX's lib/py whose config.py has lost the frame-driven profile's gate_header table (G96's near-miss: bbh's literals under no kind a bbh config resolves to) must make D85 read more keys differing than the tree reads, or D85 is held by nothing
# NOT-ASSERTED: bbh's and BBX's text on an input that reaches a delta — a CRLF index, a TOML family file, a named column, a missing directory, a shell file with no .sh name: those pairs differ by design, and gates/gate_index.sh and gates/trap_lint.sh assert BBX's side
# NOT-ASSERTED: the usage text, the --help text and the lint's bad-argument message of the two lifted tools, which name bbx by design; no pair asks for them
# NOT-ASSERTED: that an index or a lint is right about anything: identical output on both sides is fidelity, not truth
# NOT-ASSERTED: the gate_header keys bbh's DEFAULTS lack (columns, R68), which gates/gate_index.sh's columns-by-config asserts, and bbh's defaults at any commit but the one this gate clones, which a rebaseline re-reads here (docs/rebaselines.md)
# NOT-ASSERTED: any section of bbh's DEFAULTS but gate_header: D85 reads that one table
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG PYTHONPATH 2>/dev/null || true
B_SRC="${BBX_BBH_HOME:-}"
[ -n "$B_SRC" ] && [ -x "$B_SRC/bin/bbh-run-static" ] || { echo "SKIP: BBX_BBH_HOME is not a bbh tree (${B_SRC:-unset}); fidelity needs it"; exit 0; }
B_SRC="$(cd "$B_SRC" && pwd)"
. "$BBX_HOME/lib/sh/baseline.sh"          # THE ONE DEFINITION (R43); docs/defaults.md D20
BASELINE="$(bbx_baseline)"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
_tip="$(git -C "$B_SRC" rev-parse --short HEAD)"; _porc="$(git -C "$B_SRC" status --porcelain | wc -l | tr -d ' ')"
git -C "$B_SRC" cat-file -e "$BASELINE^{commit}" 2>/dev/null || { echo "FAIL: baseline $BASELINE is not a commit of $B_SRC (BBX_BBH_BASELINE)"; exit 1; }
B="$T/bbh"
{ git clone -q --no-checkout "$B_SRC" "$B" && git -C "$B" checkout -q "$BASELINE"; } || { echo "SETUP-FAIL: could not clone $B_SRC at $BASELINE under $T"; exit 1; }
_ahead="$(git -C "$B_SRC" rev-list --count "$BASELINE..HEAD" 2>/dev/null || echo '?')"
echo "bbh: $B_SRC tip=$_tip porcelain=$_porc — measured on a plain clone at $BASELINE (R8, R20), ahead=$_ahead"
[ "$_ahead" = 0 ] || echo "NOTE: bbh-drift baseline=$BASELINE tip=$_tip ahead=$_ahead"

pairs=0; bad=0
BH="$BBX_HOME"      # the BBX home whose bin/bbx is measured; the control points it at a shadow and back
judge() {  # judge <label> — diff the two captured sides
    pairs=$((pairs + 1))
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$1 — identical ($(tail -2 "$T/a.txt" | tr '\n' ' ' | cut -c1-72))"
    else bad=$((bad + 1)); fail "$1 — DIFFERS:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
pair() {  # pair <label> <dir> <args...> — bbh's and BBX's command in the same directory (neither writes): output + exit diffed
    _l="$1"; _d="$2"; shift 2
    (set +e; cd "$_d" && "$B/bin/bbh" "$@" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$_d" && "$BH/bin/bbx" "$@" 2>&1; echo "exit=$?") > "$T/b.txt"
    judge "$_l"
}
pair2() {  # pair2 <label> <dir-bbh> <dir-bbx> <args...> — each side in its own copy (the command writes): output + exit diffed
    _l="$1"; _da="$2"; _db="$3"; shift 3
    (set +e; cd "$_da" && "$B/bin/bbh" "$@" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$_db" && "$BH/bin/bbx" "$@" 2>&1; echo "exit=$?") > "$T/b.txt"
    judge "$_l"
}
samebytes() {  # samebytes <label> <file-a> <file-b>
    if cmp -s "$2" "$3"; then ok "$1 — byte-identical ($(wc -c < "$2" | tr -d ' ') B)"; else bad=$((bad + 1)); fail "$1 — the written files differ"; fi
}
example() {  # example <dir> — a copy of bbh's example at the baseline
    mkdir -p "$1"; git -C "$B" archive HEAD example | tar -x -f - -C "$1"
}
after_trap() {  # after_trap <file> — bbh's case a, the $ written as an octal escape
    printf '#!/bin/sh\nset -eu\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\n: "\044{FOO:?set FOO}"\n' > "$1"
}
before_trap() {  # before_trap <file> — bbh's case b, the $ and < written as octal escapes
    printf '#!/bin/sh\nset -eu\n: "\044{FOO:?set FOO}"\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\ncat \074\074EOS\nstub \044{BAR:?} in a heredoc is fine\nEOS\n' > "$1"
}

echo "== F19a. bbh's gate index over its example, on the clone at $BASELINE =="
pair "F19a gate-index --check over the committed index" "$B/example" gate-index --config bbh.toml --check
pair "F19a gate-index --stdout" "$B/example" gate-index --config bbh.toml --stdout
example "$T/ex1"; grep -v '^tests/g_pass\.sh' "$T/ex1/example/tests/gate_index.tsv" > "$T/ex1.tsv"; cp "$T/ex1.tsv" "$T/ex1/example/tests/gate_index.tsv"
if cmp -s "$T/ex1/example/tests/gate_index.tsv" "$B/example/tests/gate_index.tsv"; then fail "the family-row plant changed nothing"; fi
pair "F19a a family row taken out (--check)" "$T/ex1/example" gate-index --config bbh.toml --check
example "$T/ex2"; printf 'tests/g_gone.sh\tsuite\n' >> "$T/ex2/example/tests/gate_index.tsv"
pair "F19a a row for a gone gate (--check)" "$T/ex2/example" gate-index --config bbh.toml --check
example "$T/ex3"; printf '| `tests/hand.sh` | test | x | x | x | x |\n' >> "$T/ex3/example/docs/gate_index.md"
pair "F19a a hand-edited index (--check)" "$T/ex3/example" gate-index --config bbh.toml --check
example "$T/wa"; example "$T/wb"; rm "$T/wa/example/docs/gate_index.md" "$T/wb/example/docs/gate_index.md"
pair2 "F19a gate-index writes the index (each side on its own copy)" "$T/wa/example" "$T/wb/example" gate-index --config bbh.toml
samebytes "F19a the two written indexes" "$T/wa/example/docs/gate_index.md" "$T/wb/example/docs/gate_index.md"
if cmp -s "$T/wb/example/docs/gate_index.md" "$B/example/docs/gate_index.md"; then ok "F19a BBX's written index is bbh's committed one, byte for byte"
else fail "F19a BBX's written index differs from bbh's committed one"; fi

echo "== F19a. the synthetic root of bbh's selftest/test_gate_index.sh =="
W="$T/syn"; mkdir -p "$W/tests" "$W/docs"
cat > "$W/bbh.toml" <<'EOF'
[project]
instrument_word = "emulator"
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
static_needs_env = "ROMDIR"
[gate_header]
index_out = "docs/gate_index.md"
families_tsv = "tests/gate_index.tsv"
families = [["docs", "the docs"], ["platform", "the platform"]]
index_preamble = ["# Index", "", "generated."]
EOF
printf '#!/bin/sh\n# test_alpha.sh — a synthetic gate that locks the alpha law (14z-999). ROM-free, ~1 s.\n#\n# Usage: tests/test_alpha.sh\n# second paragraph, not the claim.\necho PASS\n' > "$W/tests/test_alpha.sh"
printf 'test_alpha\n' > "$W/tests/ci_portable.txt"; : > "$W/tests/ci_static.txt"
printf 'tests/test_alpha.sh\tdocs\n' > "$W/tests/gate_index.tsv"
pair "F19a one gate (--stdout)" "$W" gate-index --config "$W/bbh.toml" --stdout
printf '#!/bin/sh\n# audit_beta.sh — a synthetic audit with no family row; runs MAME on build/x for ~5 min.\n#\necho PASS\n' > "$W/tests/audit_beta.sh"
pair "F19a a gate with no family row (--stdout)" "$W" gate-index --config "$W/bbh.toml" --stdout
printf 'tests/audit_beta.sh\tplatform\n' >> "$W/tests/gate_index.tsv"
pair "F19a both rows (--stdout)" "$W" gate-index --config "$W/bbh.toml" --stdout
(cd "$W" && "$B/bin/bbh" gate-index --config "$W/bbh.toml" > /dev/null 2>&1) || true
pair "F19a --check on the written index" "$W" gate-index --config "$W/bbh.toml" --check
printf 'tests/test_gone.sh\tdocs\n' >> "$W/tests/gate_index.tsv"
pair "F19a a dead row (--check)" "$W" gate-index --config "$W/bbh.toml" --check
grep -v '^tests/test_gone\.sh' "$W/tests/gate_index.tsv" > "$T/syn.tsv"; cp "$T/syn.tsv" "$W/tests/gate_index.tsv"
printf '| `tests/hand.sh` | test | x | x | x | x |\n' >> "$W/docs/gate_index.md"
pair "F19a a hand-edited index (--check)" "$W" gate-index --config "$W/bbh.toml" --check
sed 's/\["platform", "the platform"\]/["other", "x"]/' "$W/bbh.toml" > "$W/bbh2.toml"
pair "F19a a family the config lacks (--stdout)" "$W" gate-index --config "$W/bbh2.toml" --stdout
sed 's/instrument_word = "emulator"/instrument_word = "driver"/' "$W/bbh.toml" > "$W/bbh3.toml"
printf '#!/bin/sh\n# test_bare.sh — a bare gate.\n#\necho PASS\n' > "$W/tests/test_bare.sh"; printf 'tests/test_bare.sh\tdocs\n' >> "$W/tests/gate_index.tsv"
pair "F19a another instrument word (--stdout)" "$W" gate-index --config "$W/bbh3.toml" --stdout

echo "== F19b. bbh's trap lint over its example and its selftest cases =="
pair "F19b demand-after-trap tests (the example's gates and tests/lib)" "$B/example" demand-after-trap tests
mkdir -p "$T/l/a/lib" "$T/l/b/lib" "$T/l/c/lib"
after_trap "$T/l/a/g.sh"; before_trap "$T/l/b/g.sh"; before_trap "$T/l/c/g.sh"; after_trap "$T/l/c/lib/l.sh"
W="$T/ref"; mkdir -p "$W/a" "$W/b"
eval "$(grep -F '> "$W/a/g.sh"' "$B/selftest/test_demand_after_trap.sh")"
eval "$(grep -F '> "$W/b/g.sh"' "$B/selftest/test_demand_after_trap.sh")"
if cmp -s "$W/a/g.sh" "$T/l/a/g.sh" && cmp -s "$W/b/g.sh" "$T/l/b/g.sh"; then ok "F19b the two scripts are byte for byte those bbh's selftest writes"
else fail "F19b the transcribed scripts differ from bbh's selftest's"; fi
pair "F19b a demand after the trap" "$T/l" demand-after-trap a
pair "F19b a demand before the trap and one in a heredoc" "$T/l" demand-after-trap b
pair "F19b a hit under lib/" "$T/l" demand-after-trap c
pair "F19b --skip l.sh" "$T/l" demand-after-trap c --skip l.sh
echo "  F19: $pairs pairs, $bad differ"

echo "== D85. bbh's gate_header defaults at $BASELINE against what BBX resolves for a config naming no kind (G96) =="
d85() {  # d85 <bbx-home> <out> — `same <key>` or `differs <key>` per key of bbh's DEFAULTS["gate_header"], then `keys=<n> differ=<m>` and the exit
    (python3 - "$B/lib/py" "$1/lib/py" <<'EOF'
import sys
sys.path[:0] = sys.argv[1:3]
import bbh.config as H
import bbx.config as X
lineage = H.DEFAULTS["gate_header"]
n = 0
for k, v in lineage.items():
    try:
        same = X.get({}, "gate_header." + k) == v
    except KeyError:
        same = False
    n += 0 if same else 1
    print(("same " if same else "differs ") + k)
print("keys=%d differ=%d" % (len(lineage), n))
EOF
    echo "exit=$?") > "$2" 2>&1
}
field() {  # field <name> <file> — the digits of `<name>=` on the tally line, read by name (BBX-12)
    grep '^keys=' "$2" | tr ' ' '\n' | sed -n "s/^$1=\([0-9][0-9]*\)$/\1/p"
}
d85 "$BBX_HOME" "$T/d85.txt"
d85_keys="$(field keys "$T/d85.txt")"; d85_diff="$(field differ "$T/d85.txt")"
d85_lines="$(grep -E -c '^(same|differs) ' "$T/d85.txt" || true)"
if [ -z "$d85_keys" ] || [ -z "$d85_diff" ] || ! grep -qx 'exit=0' "$T/d85.txt"; then
    fail "D85 the comparison printed no tally or exited non-zero:"; sed 's/^/        /' "$T/d85.txt" | head -12
elif [ "$d85_keys" = 0 ] || [ "$d85_lines" != "$d85_keys" ]; then
    fail "D85 keys=$d85_keys with $d85_lines key lines: nothing, or not everything, was compared"
elif [ "$d85_diff" = 0 ]; then
    ok "D85 all $d85_keys of bbh's gate_header defaults resolve identically in BBX for a config naming no kind"
else
    fail "D85 $d85_diff of bbh's $d85_keys gate_header defaults resolve differently in BBX: $(sed -n 's/^differs //p' "$T/d85.txt" | tr '\n' ' ')"
fi

echo "== MUST-FIRE: a verdict-text change in either lifted tool is visible to F19 =="
SB="$T/shadow"; mkdir -p "$SB/bin" "$SB/lib"; cp "$BBX_HOME/bin/bbx" "$SB/bin/bbx"; cp -R "$BBX_HOME/lib/py" "$SB/lib/py"
sed -i.bak 's/is current (/is current. (/' "$SB/lib/py/bbx/gen_gate_index.py"
sed -i.bak 's/}:{n}: {/}:{n}:: {/' "$SB/lib/py/bbx/demand_after_trap.py"
if cmp -s "$SB/lib/py/bbx/gen_gate_index.py" "$BBX_HOME/lib/py/bbx/gen_gate_index.py" || cmp -s "$SB/lib/py/bbx/demand_after_trap.py" "$BBX_HOME/lib/py/bbx/demand_after_trap.py"; then
    echo "CONTROL DEAD: verdict-text-f19 — a shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    # the shadow pairs are MEANT to differ: counters and rc are restored to what they were, never reset to zero,
    # so a failure recorded before this section still decides the verdict
    _pb=$pairs; _bb=$bad; _rb=$rc
    BH="$SB"
    pair "shadow: F19a gate-index --check" "$B/example" gate-index --config bbh.toml --check > "$T/shadow.out" 2>&1 || true
    _b1=$bad; _d1="$(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-70)"
    pair "shadow: F19b a demand after the trap" "$T/l" demand-after-trap a >> "$T/shadow.out" 2>&1 || true
    _d2="$(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-70)"
    BH="$BBX_HOME"
    if [ "$_b1" -gt "$_bb" ] && [ "$bad" -gt "$_b1" ]; then
        echo "CONTROL FIRED: verdict-text-f19 — one changed string in each lifted tool, and each pair differs: $_d1 / $_d2"; bad=$_bb; rc=$_rb; ok "the F19 diff can fail for either tool"
    else
        echo "CONTROL DEAD: verdict-text-f19 — a changed string left a pair identical (index pair: $_bb -> $_b1, lint pair: $_b1 -> $bad)"; bad=$_bb; rc=$_rb; fail "the diff cannot fail"
    fi
    pairs=$_pb
fi

echo "== MUST-FIRE: bbh's gate_header literals out of a bbh config's reach are visible to D85 (G96) =="
SC="$T/shadow_d85"; mkdir -p "$SC/lib"; cp -R "$BBX_HOME/lib/py" "$SC/lib/py"
if python3 - "$SC/lib/py" > "$T/d85_plant.txt" 2>&1 <<'EOF'
import sys
p = sys.argv[1] + "/bbx/config.py"
t = open(p, encoding="utf-8").read()
old = '"gate_header": {'
if t.count(old) != 2:
    sys.exit("the plant expects the kind-blind and the frame-driven tables, and found %d" % t.count(old))
i = t.rindex(old)
open(p, "w", encoding="utf-8").write(t[:i] + '"gate_header_misplaced": {' + t[i + len(old):])
sys.path.insert(0, sys.argv[1])
import bbx.config as X
if "gate_header" in X.KINDS["frame-driven"] or "gate_header_misplaced" not in X.KINDS["frame-driven"] or "gate_header" not in X.DEFAULTS:
    sys.exit("the plant did not take the frame-driven table, and only it, out of the resolver's reach")
EOF
then
    d85 "$SC" "$T/d85_shadow.txt"
    _sd="$(field differ "$T/d85_shadow.txt")"
    if [ -n "$_sd" ] && [ -n "$d85_diff" ] && [ "$_sd" -gt "$d85_diff" ]; then
        echo "CONTROL FIRED: d85-profile-misplaced — the frame-driven gate_header table out of reach in a copy, and D85 reads $_sd of $d85_keys keys differing where the tree reads $d85_diff: $(sed -n 's/^differs //p' "$T/d85_shadow.txt" | tr '\n' ' ')"; ok "D85 can fail"
    else
        echo "CONTROL DEAD: d85-profile-misplaced — the plant left D85 at differ=${_sd:-none} where the tree reads differ=${d85_diff:-none}"; fail "D85 cannot fail"
    fi
else
    echo "CONTROL DEAD: d85-profile-misplaced — the plant could not be built: $(tr '\n' ' ' < "$T/d85_plant.txt" | cut -c1-160)"; fail "control could not be built"
fi

echo "== READ-ONLY: the bbh clone after the run (R18, R20) =="
_dirt="$(git -C "$B" status --porcelain --ignored)"
if [ -z "$_dirt" ]; then ok "the clone is clean after the run: 0 tracked, untracked or ignored entries"
else fail "the clone was WRITTEN by this gate:"; printf '%s\n' "$_dirt" | sed 's/^/        /' | head -12; fi
echo "NOTE: bbh-source tip=$_tip porcelain=$_porc untouched-by-construction=clone"

echo
[ "$rc" = 0 ] && [ "$bad" = 0 ] && echo "PASS: BBX's lifted gate index and trap lint reproduce bbh's text and exit over $pairs pairings (F19), and all $d85_keys of bbh's gate_header defaults resolve identically for a config naming no kind (D85)" || { echo "FAIL: see above"; exit 1; }

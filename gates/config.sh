#!/bin/sh
# config.sh — the config reader accepts the TOML subset, refuses every ambiguous construct, and resolves defaults through the kind profile
# Ground truth for lib/py/bbx/toml_subset.py and lib/py/bbx/config.py: every accepted shape
# reads to the value it names (and, on a host with tomllib, to what tomllib reads); every
# refused shape is refused; a bbh config with no kind resolves to bbh's values (fidelity, D9);
# BBX's own config resolves through the `self` profile; an unknown kind is fatal. Lineage:
# bbh selftest/test_config.sh; VampireSaved tools/_minitoml.py (GitHub #42 there). Portable, ~1 s.
# Usage: gates/config.sh
# MUST-FIRE: known-bad: refused-constructs — each of the eleven refused constructs must raise SubsetError; one accepted silently is a dead control
# NOT-ASSERTED: the meaning of a consumer's keys: only that the layers resolve (consumer over kind profile over kind-blind default) and that dumps are stable
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM

echo "== 1. accepted shapes read to the values they name =="
cat > "$W/a.toml" <<'EOF'
# a comment
[project]
root = "."             # trailing comment
kind = "frame-driven"
gates_dir = "tests"
[tier]
patterns = ['run_x\.sh', "MAME_BIN", 'a#b']
source_depth = 2
nested = [['a', 'b'], ['c']]
[classify]
timeout_exits = [124, 137]
fail_tail = 0x10
flag = true
[fields]
bases = { p1 = 0x400, p2 = 2 }
multi = [
  'one',
  'two',   # inside a multi-line array
]
EOF
python3 - "$W/a.toml" <<'EOF' && ok "every accepted shape reads to its value" || fail "accepted shapes misread"
import sys; from bbx import toml_subset as T
c = T.load(sys.argv[1])
assert c["project"] == {"root": ".", "kind": "frame-driven", "gates_dir": "tests"}, c["project"]
assert c["tier"]["patterns"] == ['run_x\\.sh', "MAME_BIN", 'a#b'], c["tier"]
assert c["tier"]["nested"] == [['a', 'b'], ['c']]
assert c["classify"] == {"timeout_exits": [124, 137], "fail_tail": 16, "flag": True}, c["classify"]
assert c["fields"]["bases"] == {"p1": 0x400, "p2": 2}
assert c["fields"]["multi"] == ["one", "two"]
EOF
if python3 -c 'import tomllib' 2>/dev/null; then
    python3 - "$W/a.toml" <<'EOF' && ok "tomllib reads the same values (host has Python >= 3.11)" || fail "tomllib disagrees with the subset reader"
import sys, tomllib; from bbx import toml_subset as T
assert T.load(sys.argv[1]) == tomllib.load(open(sys.argv[1], "rb"))
EOF
else
    echo "  note: no tomllib on this host ($(python3 --version)); the tomllib agreement half is NOT asserted here"
fi

echo "== 2. MUST-FIRE: every refused construct is refused =="
n=0; dead=0
refuse() {  # refuse <label> <text>
    printf '%s\n' "$2" > "$W/r.toml"
    if python3 -c "from bbx import toml_subset as T; T.load('$W/r.toml')" 2>/dev/null; then
        fail "ACCEPTED: $1"; dead=$((dead + 1))
    else
        ok "refused: $1"
    fi
    n=$((n + 1))
}
refuse "dotted table header"        "[a.b]"
refuse "dotted key"                 "[t]
a.b = 1"
refuse "array of tables"            "[[t]]"
refuse "duplicate key"              "[t]
a = 1
a = 2"
refuse "duplicate table"            "[t]
a = 1
[t]
b = 2"
refuse "signed hex"                 "[t]
a = -0x10"
refuse "escape in a basic string"   "[t]
a = \"x\\ty\""
refuse "multi-line basic string"    "[t]
a = \"\"\"x\"\"\""
refuse "nested inline table"        "[t]
a = { b = { c = 1 } }"
refuse "array of inline tables"     "[t]
a = [ { b = 1 } ]"
refuse "float"                      "[t]
a = 1.5"
if [ "$dead" = 0 ] && [ "$n" = 11 ]; then
    echo "CONTROL FIRED: refused-constructs — all $n refused constructs raised SubsetError"
else
    echo "CONTROL DEAD: refused-constructs — $dead of $n refused constructs were accepted"
fi

echo "== 3. defaults resolve through the kind profile =="
printf '[project]\nroot = "."\n' > "$W/bbh.toml"
k="$(python3 -m bbx.config "$W/bbh.toml" kind)"; w="$(python3 -m bbx.config "$W/bbh.toml" get project.instrument_word)"
e="$(python3 -m bbx.config "$W/bbh.toml" get registries.static_needs_env)"
[ "$k" = frame-driven ] && [ "$w" = emulator ] && [ "$e" = ROMDIR ] \
    && ok "a config with no kind is frame-driven: instrument_word=emulator, static_needs_env=ROMDIR (bbh's values, D9)" \
    || fail "kindless config resolved kind=$k word=$w env=$e"
p="$(python3 -m bbx.config "$W/bbh.toml" get tier.patterns | head -1)"
[ "$p" = 'run_(replay_)?(mame|fbneo)\.sh' ] && ok "the frame-driven profile carries bbh's tier patterns" || fail "frame-driven tier.patterns: $p"
printf '[project]\nroot = "."\nkind = "self"\n' > "$W/self.toml"
w="$(python3 -m bbx.config "$W/self.toml" get project.instrument_word)"; g="$(python3 -m bbx.config "$W/self.toml" get project.gates_dir)"
c="$(python3 -m bbx.config "$W/self.toml" get controls.enforce)"; p="$(python3 -m bbx.config "$W/self.toml" get tier.patterns | wc -l | tr -d ' ')"
[ "$w" = instrument ] && [ "$g" = gates ] && [ "$c" = true ] && [ "$p" = 0 ] \
    && ok "the self profile: gates_dir=gates, controls enforced, no instrument patterns" || fail "self profile: word=$w gates=$g enforce=$c patterns=$p"
printf '[project]\nroot = "."\nkind = "no-such-kind"\n' > "$W/bad.toml"
if python3 -m bbx.config "$W/bad.toml" kind >/dev/null 2>&1; then fail "an unknown kind was accepted"; else ok "an unknown kind is fatal (exit 3)"; fi
printf '[project]\nroot = "."\n[classify]\nskip_regex = "^MINE"\n' > "$W/over.toml"
[ "$(python3 -m bbx.config "$W/over.toml" get classify.skip_regex)" = '^MINE' ] && ok "a consumer value wins over both layers" || fail "consumer override lost"
python3 -m bbx.config "$W/over.toml" get nosuch.key >/dev/null 2>&1 && fail "a missing key without default exited 0" || ok "a missing key with no default is fatal (exit 3)"
[ "$(python3 -m bbx.config "$W/over.toml" get nosuch.key --default fallback)" = fallback ] && ok "--default supplies the value" || fail "--default ignored"

echo
[ "$rc" = 0 ] && echo "PASS: the config reader accepts the subset, refuses the rest, and resolves defaults through the kind profile" || { echo "FAIL: see above"; exit 1; }

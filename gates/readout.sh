#!/bin/sh
# readout.sh — the readout screen says what the kept run says: verdict, counts, controls, blind spots, BBX-14 — and its exit follows the verdict
# Ground truth for lib/py/bbx/readout.py (abstraction RO1–RO3, BBX-30): a synthetic consumer of
# stub gates with known verdicts and known header declarations is run through the REAL static
# runner with --log, and the screen generated from that run is read line by line. The run dir is
# what `bbx-run-static --log` writes; nothing here re-derives a verdict. Portable, ~3 s.
# Usage: gates/readout.sh
# MUST-FIRE: perturbed-copy: verdict-follows-run — a kept run with one PASS row rewritten as FAIL must read NOT GREEN with exit 1, or the screen decorates instead of reporting
# MUST-FIRE: known-bad: bbx-14-unmet — --against a copy of the run with one verdict changed must report BBX-14 UNMET naming that gate, or "met" is silence
# MUST-FIRE: known-bad: undeclared-blind-spot — a gate with no NOT-ASSERTED line must be COUNTED and named on the screen, or a silent gate reads as a complete one
# NOT-ASSERTED: that a declared blind spot is true or complete: the screen prints what the header says
# NOT-ASSERTED: the sweep runner's runs: only bbx-run-static --log is read
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
FR="$T/fake"; mkdir -p "$FR/tests"
cat > "$FR/bbx.toml" <<'TOML'
[project]
root = "."
gates_dir = "tests"
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
[tier]
patterns = []
[controls]
enforce = true
TOML
# g_a: a control that fires, two blind spots declared, a coverage NOTE; g_b: declares nothing beyond its control; g_s: SKIPs
cat > "$FR/tests/g_a.sh" <<'G'
#!/bin/sh
# g_a.sh — passes, proves its control, declares two blind spots, reports coverage
# MUST-FIRE: known-bad: shadow — a shadow must fail
# NOT-ASSERTED: anything about the moon
# NOT-ASSERTED: the weather tomorrow
#
echo "CONTROL FIRED: shadow — the shadow failed as it must"
echo "NOTE: coverage claims=10 checked=7 uncovered=3"
echo "PASS: fine"
G
cat > "$FR/tests/g_b.sh" <<'G'
#!/bin/sh
# g_b.sh — passes, declares no blind spot
# MUST-FIRE: none — a fixture lister
#
echo "PASS: fine"
G
cat > "$FR/tests/g_s.sh" <<'G'
#!/bin/sh
# g_s.sh — skips
# MUST-FIRE: none — asserts nothing when it skips
# NOT-ASSERTED: everything, when it skips
#
echo "SKIP: no input here"
G
chmod +x "$FR"/tests/g_*.sh
printf 'g_a\ng_b\ng_s\n' > "$FR/tests/ci_portable.txt"; : > "$FR/tests/ci_static.txt"
( cd "$FR" && git init -q && git add -A && git -c user.name=bbx -c user.email=bbx@example.invalid commit -qm fixture )
run() { (cd "$FR" && "$BBX_HOME/bin/bbx-run-static" --config bbx.toml "$@" 2>&1); }

echo "== 1. a kept run, and the screen generated from it =="
run --log "$T/r1" > "$T/o1" || true
[ -f "$T/r1/results.tsv" ] && [ -f "$T/r1/run.txt" ] && [ -f "$T/r1/controls.txt" ] && [ -f "$T/r1/g_a.log" ] && ok "--log kept results.tsv, run.txt, controls.txt and the gate logs" || fail "kept: $(ls "$T/r1" 2>/dev/null | tr '\n' ' ')"
run > "$T/o1b" || true
diff "$T/o1" "$T/o1b" >/dev/null && ok "--log changes nothing printed (the two runs' outputs are identical apart from durations)" || { sed -E 's/ +[0-9]+s( |$)/ Ns\1/g' "$T/o1" > "$T/n1"; sed -E 's/ +[0-9]+s( |$)/ Ns\1/g' "$T/o1b" > "$T/n1b"; diff "$T/n1" "$T/n1b" >/dev/null && ok "--log changes nothing printed (durations normalised)" || fail "--log changed the printed output: $(diff "$T/n1" "$T/n1b" | head -3 | tr '\n' ' ')"; }
python3 -m bbx.readout "$T/r1" > "$T/s1" 2>&1 && ok "the screen exits 0 on a GREEN run" || fail "screen exit $? on a green run: $(tail -2 "$T/s1" | tr '\n' ' ')"
want() { grep -q -- "$2" "$T/s1" && ok "$1" || fail "$1 — missing '$2' in: $(head -20 "$T/s1" | tr '\n' '|')"; }
want "the header names the kind, the root, the HEAD and the platform" "^== READOUT — .* subject at .* @ $(git -C "$FR" rev-parse --short HEAD) (porcelain 0) — started 20"
want "the verdict line counts separately" "^VERDICT: GREEN   PASS 2  SKIP 1  FAIL 0  TIMEOUT 0  MISSING 0   (gates 3)"
want "controls fired / declared are summed" "^  controls: fired 1 / declared 1; dead 0; undeclared firings 0; gates red 0"
want "gates that proved a control can fail are counted, the rest named" "^  each can fail: 1 of 3 gates proved a control fires on purpose; declaring none: g_b, g_s"
want "the expectation line says the register does not exist yet" "^  expectations relied upon: none registered"
want "coverage comes from the gate's NOTE" "^  coverage: g_a: claims=10 checked=7 uncovered=3"
want "one run alone leaves BBX-14 UNMET, and says how to meet it" "^  BBX-14 (more than one run): UNMET in this screen — one run only"
want "g_a's two blind spots are listed" "^  g_a: the weather tomorrow"
want "the skipping gate's declared blind spot is listed" "^  g_s: everything, when it skips"
want "the SKIP is listed as asserting nothing, with its reason" "^skipped (asserting nothing): g_s — "

echo "== 2. two runs at the same HEAD: BBX-14 met =="
run --log "$T/r2" > /dev/null || true
python3 -m bbx.readout "$T/r1" --against "$T/r2" > "$T/s2" 2>&1 && grep -q "^  BBX-14 (more than one run): met — 3 gates, 0 verdict differences" "$T/s2" && ok "--against a second kept run of the same HEAD: met, 0 differences" || fail "against: $(grep BBX-14 "$T/s2")"

echo "== MUST-FIRE controls =="
# 1. verdict-follows-run: a PASS row rewritten as FAIL
cp -R "$T/r1" "$T/r1x"; sed -i.bak 's/^g_a	portable	PASS/g_a	portable	FAIL/' "$T/r1x/results.tsv"; sed -i.bak 's/^verdict=GREEN/verdict=NOT GREEN/' "$T/r1x/run.txt"
if python3 -m bbx.readout "$T/r1x" > "$T/c1" 2>&1; then fail "CONTROL DEAD: verdict-follows-run — a FAIL row read as exit 0"
elif grep -q "^VERDICT: NOT GREEN   PASS 1  SKIP 1  FAIL 1" "$T/c1" && grep -q "^not green: g_a FAIL" "$T/c1"; then echo "CONTROL FIRED: verdict-follows-run — $(grep '^VERDICT' "$T/c1")"
else fail "CONTROL DEAD: verdict-follows-run — exit 1 but the screen did not say so: $(grep -E '^(VERDICT|not green)' "$T/c1" | tr '\n' ' ')"; fi
# 2. bbx-14-unmet: --against a copy with one verdict changed
cp -R "$T/r2" "$T/r2x"; sed -i.bak 's/^g_b	portable	PASS/g_b	portable	FAIL/' "$T/r2x/results.tsv"
if python3 -m bbx.readout "$T/r1" --against "$T/r2x" > "$T/c2" 2>&1; then fail "CONTROL DEAD: bbx-14-unmet — a differing second run read as exit 0"
elif grep -q "^  BBX-14 (more than one run): UNMET — verdicts differ: g_b PASS/FAIL" "$T/c2"; then echo "CONTROL FIRED: bbx-14-unmet — $(grep 'BBX-14' "$T/c2" | cut -c1-90)"
else fail "CONTROL DEAD: bbx-14-unmet — $(grep BBX-14 "$T/c2")"; fi
# 3. undeclared-blind-spot: g_b declares none and must be counted by name
if grep -q "^  gates declaring no blind spot: 1 — g_b" "$T/s1"; then echo "CONTROL FIRED: undeclared-blind-spot — $(grep 'declaring no blind spot' "$T/s1" | cut -c1-60)"
else fail "CONTROL DEAD: undeclared-blind-spot — $(grep 'declaring no blind spot' "$T/s1")"; fi

echo
[ "$rc" = 0 ] && echo "PASS: the readout screen reports the kept run and nothing else" || { echo "FAIL: see above"; exit 1; }

#!/bin/sh
# readout.sh — the readout screen says what the kept run says — verdict, counts, controls, blind spots, BBX-14; for a kept suite run the findings apart, the register's histogram and the real pairings by file — and its exit follows the verdict
# Ground truth for lib/py/bbx/readout.py (abstraction RO1–RO3, BBX-30): a synthetic consumer of
# stub gates with known verdicts and known header declarations is run through the REAL static
# runner with --log, and the screen generated from that run is read line by line. The run dir is
# what `bbx-run-static --log` writes; nothing here re-derives a verdict. Portable, ~3 s.
# Usage: gates/readout.sh
# MUST-FIRE: perturbed-copy: verdict-follows-run — a kept run with one PASS row rewritten as FAIL must read NOT GREEN with exit 1, or the screen decorates instead of reporting
# MUST-FIRE: known-bad: bbx-14-unmet — --against a copy of the run with one verdict changed must report BBX-14 UNMET naming that gate, or "met" is silence
# MUST-FIRE: known-bad: undeclared-blind-spot — a gate with no NOT-ASSERTED line must be COUNTED and named on the screen, or a silent gate reads as a complete one
# MUST-FIRE: known-bad: real-pairing-by-file — with one non-fixture row in a set, the 'PASSed on a real pairing' line must name that file's class alone, or a fixture pass reads as evidence about a real subject
# MUST-FIRE: known-bad: no-register-honest — a kept suite run whose tree has no register must read 'none registered' with the file count, 'unknown' for the real pairings, and the blind spot named, or an absent register reads as an empty one
# MUST-FIRE: perturbed-copy: untracked-visible — a kept run whose untracked count rose during the run must say so on the tree line (G17), or a file written under the tree during a battery is invisible
# MUST-FIRE: perturbed-copy: note-follows-log — a kept run with g_a's drift NOTE rewritten to ahead=9 must show ahead=9 and no longer ahead=2, or the note line is decoration, not the log
# NOT-ASSERTED: that a declared blind spot is true or complete: the screen prints what the header says
# NOT-ASSERTED: the sweep runner's runs: only bbx-run-static --log and bbx-run-suite --log are read
# NOT-ASSERTED: that a register row's class is true of its file: the suite screen prints what the register says (gates/provenance.sh keeps it complete and inside the vocabulary)
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
# g_a: a control that fires, two blind spots declared, a coverage NOTE and a drift NOTE; g_b: declares nothing beyond its control; g_s: SKIPs
cat > "$FR/tests/g_a.sh" <<'G'
#!/bin/sh
# g_a.sh — passes, proves its control, declares two blind spots, reports coverage and a drift
# MUST-FIRE: known-bad: shadow — a shadow must fail
# NOT-ASSERTED: anything about the moon
# NOT-ASSERTED: the weather tomorrow
#
echo "CONTROL FIRED: shadow — the shadow failed as it must"
echo "NOTE: coverage claims=10 checked=7 uncovered=3"
echo "NOTE: drift census=x.md recorded=abc1234 tip=def5678 ahead=2"
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
want "the expectation line of a static run says no frozen expectation was compared (a suite run carries the register, D32)" "^  expectations relied upon: none registered — a static run compares against no frozen expectation"
want "coverage comes from the gate's NOTE" "^  coverage: g_a: claims=10 checked=7 uncovered=3"
want "every other NOTE-class line reaches the screen as a note" "^  note: g_a: drift census=x.md recorded=abc1234 tip=def5678 ahead=2"
grep -q "^  coverage: g_a: drift" "$T/s1" && fail "a drift NOTE was read as coverage" || ok "a non-coverage NOTE is not counted as coverage"
want "one run alone leaves BBX-14 UNMET, and says how to meet it" "^  BBX-14 (more than one run): UNMET in this screen — one run only"
want "g_a's two blind spots are listed" "^  g_a: the weather tomorrow"
want "the skipping gate's declared blind spot is listed" "^  g_s: everything, when it skips"
want "the SKIP is listed as asserting nothing, with its reason" "^skipped (asserting nothing): g_s — "

echo "== 2. two runs at the same HEAD: BBX-14 met =="
run --log "$T/r2" > /dev/null || true
python3 -m bbx.readout "$T/r1" --against "$T/r2" > "$T/s2" 2>&1 && grep -q "^  BBX-14 (more than one run): met — 3 gates, 0 verdict differences" "$T/s2" && ok "--against a second kept run of the same HEAD: met, 0 differences" || fail "against: $(grep BBX-14 "$T/s2")"

echo "== 3. a kept SUITE run: the findings counted apart, the register's histogram, the real pairings by FILE (S2 step 4) =="
SR="$T/sr"; mkdir -p "$SR/expected/build-a" "$SR/run" "$SR/run_noreg"
printf '[project]\nroot = "."\n[suite]\nexpected_dir = "expected"\n' > "$SR/bbh.toml"
for f in 01_idle.masked 02_coin_start.masked 03_press.masked 04_both.masked 05_attract.masked 06_other_set.skip; do : > "$SR/expected/build-a/$f"; done; : > "$SR/expected/build-a/mask"
cat > "$SR/expected/PROVENANCE.toml" <<'REG'
[e1]
file = "build-a/01_idle.masked"
describes = "idle"
class = "fixture"
refreeze = "authored"
[e2]
file = "build-a/02_coin_start.masked"
describes = "coin"
class = "fixture"
refreeze = "authored"
[e3]
file = "build-a/03_press.masked"
describes = "press"
class = "derived"
refreeze = "proposed from the fake's logs"
[e4]
file = "build-a/04_both.masked"
describes = "both"
class = "fixture"
refreeze = "authored"
[e5]
file = "build-a/05_attract.masked"
describes = "attract"
class = "testimony"
refreeze = "a filed number"
[e6]
file = "build-a/06_other_set.skip"
describes = "other"
class = "registry"
refreeze = "a decision"
REG
mkrun() {  # mkrun <dir> <root>
    printf 'scenario\tkind\tclass\tverdict\tfinding\n' > "$1/results.tsv"
    printf '01_idle\tmasked\texact\tPASS masked-exact\tpass\n02_coin_start\tmasked\twindow\tPASS masked-window (…)\tpass\n03_press\tmasked\tflicker\tPASS masked-flicker (…)\tpass\n04_both\tmasked\tcomposite\tFAIL masked-composite: got FAIL-SHORT …\tshort\n05_attract\tmasked\tdiverge\tFAIL first divergence at 899 (expected exactly 900 vs base/masked)\tdiverged\n06_other_set\tskip\t-\tSKIP (other)\tskip\n' >> "$1/results.tsv"
    printf 'config=%s/bbh.toml\nroot=%s\nkind=frame-driven\nset=fake\nexpset=build-a\ndriver=%s/drivers/fake.sh\nruns_per_replay=2\nmask=ff00-10000\nfreeze=0\nfiltered=0\nhead=abc1234\nporcelain=0\nstarted=2026-09-10T00:00:00Z\nplatform=Darwin arm64\nbbx_home=%s\nbbx_head=-\npass=3\nskip=1\nfail=2\nother=0\nverdict=RED\n' "$2" "$2" "$2" "$BBX_HOME" > "$1/run.txt"
}
mkrun "$SR/run" "$SR"
python3 -m bbx.readout "$SR/run" > "$T/ss" 2>&1 && fail "a RED suite run read as exit 0" || ok "a RED suite run exits 1"
wants() { grep -q -- "$2" "$T/ss" && ok "$1" || fail "$1 — missing '$2' in: $(head -8 "$T/ss" | tr '\n' '|')"; }
wants "the suite header names the set and the expectation set" "^== READOUT (suite) — frame-driven subject at .* — set 'fake' -> expectation set 'build-a' — started 2026-09-10T00:00:00Z on Darwin arm64 ==$"
wants "the verdict line counts separately, with the runs per scenario and the driver" "^VERDICT: RED   PASS 3  SKIP 1  FAIL 2  OTHER 0   (scenarios 6; each run 2 times; driver fake.sh)$"
wants "the findings count short APART from diverged (BBX-4)" "^findings: pass 3, skip 1, short 1, diverged 1   (short = "
wants "the histogram by R11 class from the register, rank order, testimony and fixture called out" "^  expectations relied upon: derived 1, registry 1, fixture 3, testimony 1 (register expected/PROVENANCE.toml; 6 files in the set); testimony 1: not evidence, never green (BBX-3); fixture 3: evidence about no real subject$"
wants "the short scenario is named as a length finding under NOT assert" "^  1 scenario(s) read \`short\`: the observation ended before re-convergence could be proved"
# CONTROL real-pairing-by-file: only 03_press (derived) is a real pairing and it PASSed as flicker; 01/02 PASSed but are fixture
if grep -q "^  comparator classes in this run: composite, diverge, exact, flicker, window; PASSed on a real pairing: flicker$" "$T/ss"; then echo "CONTROL FIRED: real-pairing-by-file — five classes ran, three PASSed, one file is not fixture-class: the line names flicker alone"
else fail "CONTROL DEAD: real-pairing-by-file — $(grep 'comparator classes' "$T/ss")"; fi
# CONTROL no-register-honest
mkdir -p "$SR/noreg/expected/build-a"; cp "$SR/bbh.toml" "$SR/noreg/"; cp "$SR/expected/build-a/"* "$SR/noreg/expected/build-a/"; mkrun "$SR/run_noreg" "$SR/noreg"
python3 -m bbx.readout "$SR/run_noreg" > "$T/sn" 2>&1 || true
if grep -q "^  expectations relied upon: none registered — no expected/PROVENANCE.toml; the 6 expectation files of set 'build-a' carry no provenance class (E3)$" "$T/sn" && grep -q "PASSed on a real pairing: unknown — no register says which pairings are real$" "$T/sn" && grep -q "^  where any expectation's numbers came from: no register (E3)$" "$T/sn"; then echo "CONTROL FIRED: no-register-honest — no register: the file count, 'unknown', and the blind spot named"
else fail "CONTROL DEAD: no-register-honest — $(grep -E 'relied|real pairing|numbers came' "$T/sn" | tr '\n' '|')"; fi
# BBX-14 for suite runs
cp -R "$SR/run" "$SR/run2"; python3 -m bbx.readout "$SR/run" --against "$SR/run2" 2>&1 | grep -q "^  BBX-14 (more than one run): met — 6 scenarios, 0 verdict differences" && ok "--against a second kept suite run at the same HEAD and set: met" || fail "suite BBX-14 met"
sed -i.bak 's/^03_press	masked	flicker	PASS masked-flicker (…)	pass$/03_press	masked	flicker	FAIL masked-flicker: got X	diverged/' "$SR/run2/results.tsv"
python3 -m bbx.readout "$SR/run" --against "$SR/run2" 2>&1 | grep -q "^  BBX-14 (more than one run): UNMET — verdicts differ: 03_press " && ok "…and a differing scenario verdict is UNMET, named" || fail "suite BBX-14 unmet"

echo "== 4. CONTROL untracked-visible: a file written under the tree during a run is on the screen (G17) =="
cp -R "$T/r1" "$T/r1u"; printf 'untracked_before=3\nuntracked_after=4\n' >> "$T/r1u/run.txt"
python3 -m bbx.readout "$T/r1u" > "$T/su" 2>&1 || true
if grep -q "^tree during the run: unchanged (untracked entries 3 -> 4 — a file was written under the tree during the run: G17)" "$T/su"; then echo "CONTROL FIRED: untracked-visible — $(grep '^tree during' "$T/su" | cut -c1-80)"
else fail "CONTROL DEAD: untracked-visible — $(grep '^tree during' "$T/su")"; fi
printf 'untracked_before=3\nuntracked_after=3\n' >> "$T/r1/run.txt"
python3 -m bbx.readout "$T/r1" 2>&1 | grep -q "^tree during the run: unchanged (untracked entries 3 -> 3)   harness" && ok "an unchanged untracked count reads as such" || fail "unchanged untracked count line"

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

# 4. note-follows-log: g_a's drift NOTE rewritten in the kept log
cp -R "$T/r1" "$T/r1n"; sed -i.bak 's/ ahead=2$/ ahead=9/' "$T/r1n/g_a.log"
python3 -m bbx.readout "$T/r1n" > "$T/c4" 2>&1 || true
if grep -q "^  note: g_a: drift census=x.md recorded=abc1234 tip=def5678 ahead=9" "$T/c4" && ! grep -q "ahead=2" "$T/c4"; then echo "CONTROL FIRED: note-follows-log — $(grep '^  note: g_a' "$T/c4" | cut -c1-70)"
else fail "CONTROL DEAD: note-follows-log — $(grep '^  note' "$T/c4" | tr '\n' ' ')"; fi

echo
[ "$rc" = 0 ] && echo "PASS: the readout screen reports the kept run and nothing else" || { echo "FAIL: see above"; exit 1; }

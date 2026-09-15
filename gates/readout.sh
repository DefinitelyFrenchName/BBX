#!/bin/sh
# readout.sh — the readout screen says what the kept run says — verdict, counts reconciled with the run's own tallies, controls, blind spots, BBX-14; for a kept suite run the findings apart, the register's histogram and the real pairings by file — and its exit follows the verdict
# Ground truth for lib/py/bbx/readout.py (abstraction RO1–RO3, BBX-30): a synthetic consumer of
# stub gates with known verdicts and known header declarations is run through the REAL static
# runner with --log, and the screen generated from that run is read line by line. The run dir is
# what `bbx-run-static --log` writes; nothing here re-derives a verdict. Portable, ~9 s measured 2026-09-13
# (bbx-25: 9 s alone with the two G57 controls, which run the real runner twice more; bbx-24: 5 s in the opening battery).
# Usage: gates/readout.sh
# MUST-FIRE: perturbed-copy: verdict-follows-run — a kept run with one PASS row rewritten as FAIL must read NOT GREEN with exit 1, or the screen decorates instead of reporting
# MUST-FIRE: known-bad: bbx-14-unmet — --against a copy of the run with one verdict changed must report BBX-14 UNMET naming that gate, or "met" is silence
# MUST-FIRE: known-bad: undeclared-blind-spot — a gate with no NOT-ASSERTED line must be COUNTED and named on the screen, or a silent gate reads as a complete one
# MUST-FIRE: known-bad: real-pairing-by-file — with one non-fixture row in a set, the 'PASSed on a real pairing' line must name that file's class alone, or a fixture pass reads as evidence about a real subject
# MUST-FIRE: known-bad: no-register-honest — a kept suite run whose tree has no register must read 'none registered' with the file count, 'unknown' for the real pairings, and the blind spot named, or an absent register reads as an empty one
# MUST-FIRE: perturbed-copy: untracked-visible — a kept run whose untracked count rose during the run must say so on the tree line (G17), or a file written under the tree during a battery is invisible
# MUST-FIRE: perturbed-copy: note-follows-log — a kept run with g_a's drift NOTE rewritten to ahead=9 must show ahead=9 and no longer ahead=2, or the note line is decoration, not the log
# MUST-FIRE: perturbed-copy: header-not-found-named — a kept run whose recorded root is rewritten to a directory that does not exist must NAME every gate whose header was not found and count ZERO gates as declaring no blind spot, or a screen read on another host counts an unreadable header as silence (G50)
# MUST-FIRE: known-bad: truncated-blind-spot-marked — a gate whose NOT-ASSERTED entry runs on to a second header line must print that blind spot with a TRUNCATED mark directly under it and no other mark, or a cut blind spot reads as a whole one (G53)
# MUST-FIRE: known-bad: truncated-driver-blind-spot-marked — a kept suite run whose driver's NOT-ASSERTED entry runs on must mark it TRUNCATED on the suite screen the same way, or a driver's cut blind spot reads as a whole one (G53)
# MUST-FIRE: known-bad: unrun-tier-named — a kept run of the REAL runner with both tiers asked, a registered static gate and its static_needs_env unset (run.txt skip=2, no row for the gate) must count the unrun gate in SKIP, print "(gates 3 kept, 1 not run)" and name the static tier on a "not run" line, while the same consumer with the variable set prints neither, or a tier that never ran reads as SKIP 0 (G57)
# MUST-FIRE: perturbed-copy: counts-disagree-named — a kept run whose run.txt pass= is rewritten must print a "counts disagree" line naming run.txt's pass and the kept rows' count, while an untouched run prints none, or the screen can contradict the run it reports in silence (G57)
# NOT-ASSERTED: that a declared blind spot is true or complete: the screen prints what the header says
# NOT-ASSERTED: the sweep runner's runs: only bbx-run-static --log and bbx-run-suite --log are read
# NOT-ASSERTED: that a register row's class is true of its file: the suite screen prints what the register says (gates/provenance.sh keeps it complete and inside the vocabulary)
# MUST-FIRE: known-bad: fast-fail-named — a kept run whose g_a FAILs in 0 s under a header quoting ~10 min, g_b in 5 s under ~10 s and g_s in 0 s under ~1 s must name g_a alone and list g_s as too short to judge in whole seconds, and the green run must print no runtime line, or BBX-11's diagnostic is prose (R64, rot class 6's candidate)
# NOT-ASSERTED: that run.txt's tallies are right: where they and the kept rows disagree the screen names both and decides nothing, and a gate the runner counted without a row is named by its tier alone (G57)
# NOT-ASSERTED: that a gate named on the runtime line bailed before measuring: a FAIL under a tenth of the runtime its header quotes is BBX-11's symptom, read against a quote written by hand (G29), and a failing gate whose header quotes none, or quotes under ten seconds, is listed, never judged (D88)
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
grep -q 'TRUNCATED' "$T/s1" && fail "a whole blind spot was marked TRUNCATED: $(grep TRUNCATED "$T/s1")" || ok "no blind spot of a well-formed header is marked TRUNCATED"
want "the SKIP is listed as asserting nothing, with its reason" "^skipped (asserting nothing): g_s — "
grep -q '^counts disagree' "$T/s1" && fail "a run whose tallies match its rows printed a disagreement: $(grep '^counts disagree' "$T/s1")" || ok "a kept run whose tallies match its rows prints no disagreement (G57)"
grep -q '^not run' "$T/s1" && fail "a run with no tier left unrun printed a not-run line: $(grep '^not run' "$T/s1")" || ok "a kept run with no tier left unrun prints no not-run line (G57)"

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
wants "the verdict line counts separately, with the runs per scenario and the driver" "^VERDICT: RED   PASS 3  SKIP 1  FAIL 2  OTHER 0   (scenarios 6, pairings 6; each run 2 times; driver fake.sh)$"
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
cp -R "$SR/run" "$SR/run2"; python3 -m bbx.readout "$SR/run" --against "$SR/run2" 2>&1 | grep -q "^  BBX-14 (more than one run): met — 6 pairings, 0 verdict differences" && ok "--against a second kept suite run at the same HEAD and set: met" || fail "suite BBX-14 met"
sed -i.bak 's/^03_press	masked	flicker	PASS masked-flicker (…)	pass$/03_press	masked	flicker	FAIL masked-flicker: got X	diverged/' "$SR/run2/results.tsv"
python3 -m bbx.readout "$SR/run" --against "$SR/run2" 2>&1 | grep -q "^  BBX-14 (more than one run): UNMET — verdicts differ: 03_press.masked " && ok "…and a differing scenario verdict is UNMET, named" || fail "suite BBX-14 unmet"

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

# 5. header-not-found-named: the kept run's recorded root rewritten to a directory that does not exist (G50)
cp -R "$T/r1" "$T/r1h"; sed -i.bak "s|^root=.*|root=$T/no-such-root|" "$T/r1h/run.txt"
python3 -m bbx.readout "$T/r1h" > "$T/c5" 2>&1 || true
if grep -q "^  gates whose header was NOT FOUND: 3 under $T/no-such-root/tests — their blind spots are UNKNOWN, not absent (G50): g_a, g_b, g_s$" "$T/c5" && grep -q "^  gates declaring no blind spot: 0 " "$T/c5"; then echo "CONTROL FIRED: header-not-found-named — three unreadable headers named as UNKNOWN, zero counted as silent"
else fail "CONTROL DEAD: header-not-found-named — $(grep -E 'NOT FOUND|declaring no blind spot' "$T/c5" | tr '\n' '|')"; fi

# 6. truncated-blind-spot-marked: g_a's first blind spot run on to a second header line, read through a copy of the root (G53)
TRUNC="^ TRUNCATED — the blind spot above runs on 1 more header line(s) that this screen does not print (one line per entry: docs/controls.md, G53)"
cp -R "$FR" "$T/frt"; awk '{print} /^# NOT-ASSERTED: anything about the moon$/{print "#   and about the sea"}' "$FR/tests/g_a.sh" > "$T/frt/tests/g_a.sh"
cp -R "$T/r1" "$T/r1t"; sed -i.bak "s|^root=.*|root=$T/frt|" "$T/r1t/run.txt"
python3 -m bbx.readout "$T/r1t" > "$T/c6" 2>&1 || true
if [ "$(grep -A1 '^  g_a: anything about the moon$' "$T/c6" | tail -1)" = "  g_a: $TRUNC" ] && grep -q '^  g_a: the weather tomorrow$' "$T/c6" && [ "$(grep -c 'TRUNCATED' "$T/c6")" = 1 ]; then echo "CONTROL FIRED: truncated-blind-spot-marked — the cut blind spot is marked directly under it, its whole neighbour is not"
else fail "CONTROL DEAD: truncated-blind-spot-marked — $(grep '^  g_a' "$T/c6" | tr '\n' '|')"; fi

# 7. truncated-driver-blind-spot-marked: a kept suite run whose driver's first blind spot runs on (G53)
mkdir -p "$SR/drv/drivers" "$SR/run_drv"; cp "$SR/bbh.toml" "$SR/drv/"; cp -R "$SR/expected" "$SR/drv/"
printf '#!/bin/sh\n# fake.sh — a stub driver whose first blind spot runs on\n# NOT-ASSERTED: the colour of the moon\n#   and of the sea\n# NOT-ASSERTED: the tide\n#\n' > "$SR/drv/drivers/fake.sh"
mkrun "$SR/run_drv" "$SR/drv"
python3 -m bbx.readout "$SR/run_drv" > "$T/c7" 2>&1 || true
if [ "$(grep -A1 '^  driver fake.sh: the colour of the moon$' "$T/c7" | tail -1)" = "  driver fake.sh: $TRUNC" ] && grep -q '^  driver fake.sh: the tide$' "$T/c7" && [ "$(grep -c 'TRUNCATED' "$T/c7")" = 1 ]; then echo "CONTROL FIRED: truncated-driver-blind-spot-marked — the driver's cut blind spot is marked on the suite screen, its whole neighbour is not"
else fail "CONTROL DEAD: truncated-driver-blind-spot-marked — $(grep '^  driver' "$T/c7" | tr '\n' '|')"; fi

# 8. unrun-tier-named: the REAL runner, both tiers asked, a registered static gate and its variable unset — the witnessed path (G57)
FS="$T/frs"; cp -R "$FR" "$FS"
cat > "$FS/bbx.toml" <<'TOML'
[project]
root = "."
gates_dir = "tests"
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
static_needs_env = "BBX_READOUT_G57_NEEDS"
[tier]
patterns = []
[controls]
enforce = true
TOML
cat > "$FS/tests/g_t.sh" <<'G'
#!/bin/sh
# g_t.sh — a static-tier gate: passes when its tier runs
# MUST-FIRE: none — a fixture lister
# NOT-ASSERTED: anything, when its tier is not run
#
echo "PASS: fine"
G
chmod +x "$FS/tests/g_t.sh"; printf 'g_t\n' > "$FS/tests/ci_static.txt"
( cd "$FS" && git add -A && git -c user.name=bbx -c user.email=bbx@example.invalid commit -qm static )
( unset BBX_READOUT_G57_NEEDS; cd "$FS" && "$BBX_HOME/bin/bbx-run-static" --config bbx.toml --log "$T/r8" ) > "$T/o8" 2>&1 || true
if grep -q '^  NOT RUN: BBX_READOUT_G57_NEEDS is unset' "$T/o8" && grep -qx 'skip=2' "$T/r8/run.txt" && ! grep -q '^g_t	' "$T/r8/results.tsv"; then ok "the run took the witnessed path: the static tier NOT RUN, run.txt skip=2, no row for g_t"
else fail "the unrun-tier run did not take the witnessed path: $(grep -E 'NOT RUN|^PASS' "$T/o8" | tr '\n' '|') $(grep '^skip=' "$T/r8/run.txt" 2>/dev/null)"; fi
python3 -m bbx.readout "$T/r8" > "$T/c8" 2>&1 || true
( BBX_READOUT_G57_NEEDS="$T"; export BBX_READOUT_G57_NEEDS; cd "$FS" && "$BBX_HOME/bin/bbx-run-static" --config bbx.toml --log "$T/r8s" ) > /dev/null 2>&1 || true
python3 -m bbx.readout "$T/r8s" > "$T/c8s" 2>&1 || true
if grep -qx 'VERDICT: GREEN   PASS 2  SKIP 2  FAIL 0  TIMEOUT 0  MISSING 0   (gates 3 kept, 1 not run)' "$T/c8" \
   && grep -q '^not run (asserting nothing): the static tier — 1 gate(s) the runner counted as SKIP and kept no row for: ' "$T/c8" \
   && ! grep -q '^counts disagree' "$T/c8" \
   && grep -qx 'VERDICT: GREEN   PASS 3  SKIP 1  FAIL 0  TIMEOUT 0  MISSING 0   (gates 4)' "$T/c8s" && ! grep -q '^not run' "$T/c8s"; then echo "CONTROL FIRED: unrun-tier-named — the static tier left unrun is counted in SKIP and named; with its variable set, neither"
else fail "CONTROL DEAD: unrun-tier-named — $(grep -E '^(VERDICT|not run|counts disagree)' "$T/c8" "$T/c8s" | tr '\n' '|')"; fi

# 9. counts-disagree-named: a kept run whose run.txt pass= is rewritten no longer matches its rows (G57)
cp -R "$T/r1" "$T/r1c"; sed -i.bak 's/^pass=2$/pass=5/' "$T/r1c/run.txt"
grep -qx 'pass=5' "$T/r1c/run.txt" || fail "counts-disagree-named: the perturbation did not apply to run.txt"
python3 -m bbx.readout "$T/r1c" > "$T/c9" 2>&1 || true
if grep -qx "counts disagree: run.txt pass=5, kept rows 2 — the counts above are the kept rows'; this screen does not decide which is right (G57)" "$T/c9" && grep -q '^VERDICT: GREEN   PASS 2  SKIP 1 ' "$T/c9"; then echo "CONTROL FIRED: counts-disagree-named — run.txt's pass=5 against 2 kept PASS rows is named, and the verdict line still counts the rows"
else fail "CONTROL DEAD: counts-disagree-named — $(grep -E '^(VERDICT|counts disagree)' "$T/c9" | tr '\n' '|')"; fi

# 10. fast-fail-named: g_a FAILs in 0 s under a header quoting ~10 min, g_b in 5 s under ~10 s, g_s in 0 s under ~1 s (BBX-11; R64, rot class 6's candidate)
cp -R "$FR" "$T/frf"
sed 's/^# g_a.sh — passes, proves its control, declares two blind spots, reports coverage and a drift$/&, ~10 min/' "$FR/tests/g_a.sh" > "$T/frf/tests/g_a.sh"
sed 's/^# g_b.sh — passes, declares no blind spot$/&, ~10 s/' "$FR/tests/g_b.sh" > "$T/frf/tests/g_b.sh"
sed 's/^# g_s.sh — skips$/&, ~1 s/' "$FR/tests/g_s.sh" > "$T/frf/tests/g_s.sh"
grep -q ', ~10 min$' "$T/frf/tests/g_a.sh" && grep -q ', ~10 s$' "$T/frf/tests/g_b.sh" && grep -q ', ~1 s$' "$T/frf/tests/g_s.sh" || fail "fast-fail-named: the perturbation did not apply to the three headers"
cp -R "$T/r1" "$T/r1f"; sed -i.bak "s|^root=.*|root=$T/frf|; s/^verdict=GREEN/verdict=NOT GREEN/" "$T/r1f/run.txt"
if ! python3 - "$T/r1f/results.tsv" <<'PY'
import sys
p = sys.argv[1]
lines = open(p, encoding="utf-8").read().split("\n")
head = lines[0].split("\t")
g, v, s = head.index("gate"), head.index("verdict"), head.index("seconds")
out, n = [lines[0]], 0
for line in lines[1:]:
    f = line.split("\t")
    if len(f) == len(head) and f[g] in ("g_a", "g_b", "g_s"):
        f[v], f[s], n = "FAIL", {"g_a": "0", "g_b": "5", "g_s": "0"}[f[g]], n + 1
    out.append("\t".join(f))
open(p, "w", encoding="utf-8").write("\n".join(out))
sys.exit(0 if n == 3 else 1)
PY
then fail "fast-fail-named: the perturbation did not rewrite the three rows"; fi
python3 -m bbx.readout "$T/r1f" > "$T/c10" 2>&1 || true
if grep -qx "runtime (BBX-11): 1 of 3 failing gate(s) under a tenth of the runtime their header quotes; quoting under 10 s, too short to judge in whole seconds: g_s — rot class 6's candidate (R64)" "$T/c10" \
   && grep -qx "  g_a FAILED in 0 s where its header quotes ~10 min: a gate that fails that fast bailed before measuring anything" "$T/c10" \
   && ! grep -q '^  g_b FAILED' "$T/c10" && ! grep -q '^  g_s FAILED' "$T/c10" && ! grep -q '^runtime (BBX-11)' "$T/s1"; then echo "CONTROL FIRED: fast-fail-named — g_a's FAIL in 0 s under ~10 min is named, g_b's in 5 s under ~10 s is not, g_s's under ~1 s is listed as too short to judge, and the green run prints no runtime line"
else fail "CONTROL DEAD: fast-fail-named — $(grep -A2 '^runtime' "$T/c10" | tr '\n' '|')"; fi

echo "== 5. R48 and G48: a skipped gate's declarations are set aside, named and never counted as proved; a gate with no controls line is named =="
cat > "$FR/tests/g_k.sh" <<'G'
#!/bin/sh
# g_k.sh — declares a control, then skips
# MUST-FIRE: known-bad: needs-input — a wrong input must fail
# NOT-ASSERTED: everything, when it skips
#
echo "SKIP: the input is absent on this host"
G
chmod +x "$FR/tests/g_k.sh"; printf 'g_a\ng_b\ng_s\ng_k\n' > "$FR/tests/ci_portable.txt"
run --log "$T/r3" > "$T/o3" && ok "a correct skip beside a declared control leaves the run GREEN, exit 0 (G47's case)" || fail "the run with g_k is not GREEN: $(grep -E 'controls=g_k|GREEN' "$T/o3" | tr '\n' '|')"
python3 -m bbx.readout "$T/r3" > "$T/s3" 2>&1 && ok "…and its screen exits 0" || fail "the screen of that run exits non-zero: $(grep -E '^VERDICT|^  controls' "$T/s3" | tr '\n' '|')"
grep -qx "  controls: fired 1 / declared 1; dead 0; undeclared firings 0; gates red 0; skipped 2, whose 1 declared control(s) assert nothing: g_s, g_k" "$T/s3" && ok "the controls line sets the skipped declarations aside, counts them and names the gates" || fail "r3 controls line: $(grep '^  controls' "$T/s3")"
grep -qx "  each can fail: 1 of 4 gates proved a control fires on purpose; declaring none: g_b, g_s; skipped, proving nothing this run: g_k" "$T/s3" && ok "a skipped gate is never counted as having proved a control" || fail "r3 each-can-fail line: $(grep 'each can fail' "$T/s3")"
cp -R "$T/r1" "$T/r1g"; grep -v '^controls=g_b ' "$T/r1/controls.txt" > "$T/r1g/controls.txt" || true
python3 -m bbx.readout "$T/r1g" > "$T/sg" 2>&1 || true
grep -qx "  controls: NOT REPORTED for 1 gate(s) that ran — no controls verdict rests on them (G48): g_b" "$T/sg" && ok "a gate that ran with no controls line is named, never read as asserting (G48)" || fail "r1g controls: $(grep '^  controls' "$T/sg" | tr '\n' '|')"

echo
[ "$rc" = 0 ] && echo "PASS: the readout screen reports the kept run and nothing else" || { echo "FAIL: see above"; exit 1; }

#!/bin/sh
# cli_fixture.sh — the command-line fixture equals its generator, is chiral, and its tool does what the design says on every scenario; its consumer config resolves to the command-line profile with the four new kinds and the `cli` scenario extension; a kind the profile does not carry is unknown under it
# Ground truth for fixture/fakecli/mkfakecli.py, subject/fakecli.py and the `command-line` kind profile (docs/plans/S4.md
# step 1; R35, R36, R40; abstraction S1, E1; BBX-15, BBX-21). The generator's --check is run on the TREE's fixture (read-only:
# it regenerates under TMPDIR and diffs, and runs the tree's tool under a clean environment in a TMPDIR cwd) and on perturbed
# COPIES for the controls; every perturbation is proven to have applied before its assertion. Every file the fixture
# introduces is read by the TOML-subset parser here (R40's caveat: no new TSV). No instrument. Portable, ~3 s.
# Usage: gates/cli_fixture.sh
# MUST-FIRE: perturbed-copy: edited-value — one weight changed in a copy's subject/fakecli.py must make --check FAIL naming the file, or the fixture can drift by hand (BBX-21)
# MUST-FIRE: perturbed-copy: symmetric-fixture — two records given the same weight in a copy's tool must make --check FAIL naming the predicate `weights-distinct`, or a fixture can stop being chiral without anyone reading which predicate broke (BBX-15)
# MUST-FIRE: shadow-tool: tool-drifts-from-design — the copy's generator with one output format changed, regenerated, must make --check FAIL naming the scenario and the line (TOOL-DIFFERS), or the truth logs could describe a tool that does not exist (BBX-5: the design is the author, the tool the artifact)
# MUST-FIRE: known-bad: unknown-kind-under-profile — a `.masked` beside a `.cli` scenario under the fixture's config must enumerate UNKNOWN-KIND and non-zero, or the command-line profile inherits the temporal family it never declared (R23)
# NOT-ASSERTED: the driver (S4 step 2): the tool is run here DIRECTLY by the generator's tool-check; no log in D47's grammar is produced by anything but the generator, so the truth logs describe the design, not a run
# NOT-ASSERTED: the comparators over the new kinds (`unordered`, `schema` json, `band`: S4 step 3) and the suite over the fixture (step 4): only that the files are the generator's, the design is chiral, the tool matches it, and the register is complete and tracked
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_REPLAYS_DIR FAKECLI_SALT 2>/dev/null || true
F="$BBX_HOME/fixture/fakecli"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM

echo "== 1. the tree's fixture equals its generator, and its tool matches the design (read-only: --check regenerates under TMPDIR) =="
if python3 "$F/mkfakecli.py" --check > "$W/check.txt" 2>&1; then ok "mkfakecli.py --check exit 0"; else fail "mkfakecli.py --check exited non-zero: $(tr '\n' ' ' < "$W/check.txt")"; fi
grep -q '^  ok: every predicate holds' "$W/check.txt" && ok "every chirality predicate holds on subject/fakecli.py (D36 + D50)" || fail "the predicate line is missing"
grep -q 'the tool matches the design on 9 scenarios' "$W/check.txt" && ok "the tool, run directly under a clean environment, matches the design on 9 scenarios (exit, stdout, stderr, files)" || fail "the tool-check line is missing"
note="$(grep '^NOTE: fakecli-fixture ' "$W/check.txt" || true)"
[ -n "$note" ] && ok "the generator prints its counts as a NOTE" || fail "no NOTE line from the generator"
n_files="$(find "$F/subject" "$F/scenarios" "$F/expected" -type f | wc -l | tr -d ' ')"
ok "files under subject/, scenarios/, expected/: $n_files"
n_toml=0; n_bad=0
for f in "$F"/scenarios/*.cli "$F"/expected/fixture/*.truth "$F"/expected/fixture/*.unordered "$F"/expected/fixture/*.schema "$F"/expected/fixture/*.band "$F"/expected/PROVENANCE.toml; do
    n_toml=$((n_toml + 1))
    python3 -c 'import sys; from bbx import toml_subset; toml_subset.load(sys.argv[1])' "$f" 2>/dev/null || { n_bad=$((n_bad + 1)); fail "the subset parser refuses $f"; }
done
[ "$n_bad" = 0 ] && ok "every TOML-subset file the fixture introduces is read by the subset parser: $n_toml files, 0 refused (R40's caveat: no new TSV but the registry the kernel already had)"
[ -x "$F/subject/fakecli.py" ] && ok "subject/fakecli.py is executable" || fail "subject/fakecli.py is not executable"

echo "== 2. the consumer config resolves to the command-line profile =="
k="$(python3 -m bbx.config "$F/bbx.toml" kind)"; [ "$k" = command-line ] && ok "kind = command-line" || fail "kind resolved to '$k'"
kinds="$(BBX_CONFIG="$F/bbx.toml" python3 -m bbx.expectations kinds)"
[ "$(printf '%s\n' "$kinds" | wc -l | tr -d ' ')" = 7 ] && ok "seven kinds under the profile (the kind-blind three + truth, unordered, schema, band)" || fail "kinds table: $(printf '%s' "$kinds" | tr '\n' ' ')"
for want in "truth	exact	EVAL	log" "unordered	set	EVAL	log" "schema	schema	EVAL	json" "band	tolerant-numeric	EVAL	bands"; do
    printf '%s\n' "$kinds" | grep -qx "$want" && ok "kind row: $(printf '%s' "$want" | tr '\t' ' ')" || fail "missing kind row: $want"
done
printf '%s\n' "$kinds" | cut -f2 | grep -qx temporal && fail "the command-line profile carries a temporal family" || ok "no temporal family under the profile (a temporal comparator is REFUSED, D23)"
ext="$(BBX_CONFIG="$F/bbx.toml" python3 -m bbx.expectations scenario-ext)"; [ "$ext" = cli ] && ok "scenario extension = cli (R32, R35, D34)" || fail "scenario-ext = '$ext'"
ext0="$(python3 -m bbx.expectations scenario-ext)"; [ "$ext0" = rpl ] && ok "kind-blind scenario extension = rpl (bbh's literal)" || fail "kind-blind scenario-ext = '$ext0'"
[ "$(python3 -m bbx.config "$F/bbx.toml" get fingerprint.file_pattern)" = "{set}.py" ] && ok "the identity is file-sha1 over {set}.py, whole-set key over subject/ (D45)" || fail "fingerprint.file_pattern under the profile"
[ "$(python3 -m bbx.config "$F/bbx.toml" get suite.input_env)" = "CLI_PATH" ] && ok "the search-path variable is CLI_PATH, not scrubbed: $(python3 -m bbx.config "$F/bbx.toml" get suite.hermetic_unset | tr '\n' ' ')" || fail "suite.input_env under the profile"
n_reg="$(grep -vc '^#' "$F/expected/registry.tsv" | tr -d ' ')"; [ "$n_reg" = 1 ] && ok "one registry row (the whole-set key -> fixture)" || fail "registry rows: $n_reg"
wkey="$(cd "$F" && BBX_CONFIG="$F/bbx.toml" python3 -m bbx.fingerprint subject --set fakecli --set-key)"
grep -q "^$wkey	fixture	" "$F/expected/registry.tsv" && ok "the registry row IS the fingerprint tool's whole-set key over subject/" || fail "the registry key differs from bbx.fingerprint --set-key ($wkey)"
exp="$(cd "$F" && BBX_CONFIG="$F/bbx.toml" python3 -m bbx.fingerprint subject --set fakecli)"; [ "$exp" = fixture ] && ok "bbx.fingerprint resolves subject/ to expectation set 'fixture'" || fail "fingerprint resolved to '$exp'"
echo "$note"
if o="$(python3 -m bbx.provenance --config "$F/bbx.toml" 2>&1)"; then ok "the fixture's register: $(printf '%s\n' "$o" | grep '^  ok: [0-9]* expectation files' | sed 's/^  ok: //')"; else fail "the fixture's register (bbx.provenance): $(printf '%s' "$o" | grep 'FAIL' | tr '\n' ' ')"; fi
printf '%s\n' "$o" | grep -q '^  ok: every named file is tracked by git' && ok "every registered fixture file is tracked by git — a clone has the truth logs (G22)" || fail "tracked-ness of the fixture's expectations: $(printf '%s' "$o" | grep -n 'track\|not run' | tr '\n' ' ')"

echo "== 3. must-fire controls, each on a COPY =="
cp -R "$F" "$W/c1"
sed "s/('Maren', '4D2B', 83, 6, ('ash', 'elm'))/('Maren', '4D2B', 86, 6, ('ash', 'elm'))/" "$F/subject/fakecli.py" > "$W/c1/subject/fakecli.py"
if cmp -s "$W/c1/subject/fakecli.py" "$F/subject/fakecli.py"; then fail "control edited-value: the perturbation did not apply"; else
    if python3 "$W/c1/mkfakecli.py" --check > "$W/c1.txt" 2>&1; then fail "control edited-value: --check still exit 0 on an edited value"
    elif grep -q 'DIFFERS  subject/fakecli.py' "$W/c1.txt"; then echo "CONTROL FIRED: edited-value — $(grep '^FAIL' "$W/c1.txt")"
    else fail "control edited-value: non-zero but not naming subject/fakecli.py: $(tr '\n' ' ' < "$W/c1.txt")"; fi; fi
cp -R "$F" "$W/c2"
sed "s/('Orsolya', '7E19', 26, 2, ('oak',))/('Orsolya', '7E19', 83, 2, ('oak',))/" "$F/subject/fakecli.py" > "$W/c2/subject/fakecli.py"
if cmp -s "$W/c2/subject/fakecli.py" "$F/subject/fakecli.py"; then fail "control symmetric-fixture: the perturbation did not apply"; else
    if python3 "$W/c2/mkfakecli.py" --check > "$W/c2.txt" 2>&1; then fail "control symmetric-fixture: --check still exit 0 on two equal weights"
    elif grep -q 'weights-distinct' "$W/c2.txt"; then echo "CONTROL FIRED: symmetric-fixture — $(head -1 "$W/c2.txt")"
    else fail "control symmetric-fixture: non-zero but not naming the predicate: $(tr '\n' ' ' < "$W/c2.txt")"; fi; fi
# (the tool's table is Python's repr of the design: single quotes — the sed patterns above are the tool's text, not the design's)
# the shadow generator: one output format of the TEMPLATE changed (the list line), the copy regenerated FROM it (so every
# file equals that generator's), then --check: the tool now differs from the DESIGN's lines and the tool-check names it
cp -R "$F" "$W/c3"
sed 's/out.line(f"{r\[3\]} {r\[0\]} {r\[1\]} {r\[2\]}")/out.line(f"{r[0]} {r[3]} {r[1]} {r[2]}")/' "$F/mkfakecli.py" > "$W/c3/mkfakecli.py"
if cmp -s "$W/c3/mkfakecli.py" "$F/mkfakecli.py"; then fail "control tool-drifts-from-design: the perturbation did not apply"; else
    (cd "$W/c3" && python3 mkfakecli.py > /dev/null 2>&1) || fail "control tool-drifts-from-design: the shadow generator could not write"
    cmp -s "$W/c3/subject/fakecli.py" "$F/subject/fakecli.py" && fail "control tool-drifts-from-design: the regenerated tool equals the tree's"
    if python3 "$W/c3/mkfakecli.py" --check > "$W/c3.txt" 2>&1; then fail "control tool-drifts-from-design: --check still exit 0 with a drifted tool"
    elif grep -q 'TOOL-DIFFERS  01_list: stdout line 1 differs' "$W/c3.txt"; then echo "CONTROL FIRED: tool-drifts-from-design — $(grep '^FAIL' "$W/c3.txt"); first: $(grep 'TOOL-DIFFERS' "$W/c3.txt" | head -1 | sed 's/^ *//')"
    else fail "control tool-drifts-from-design: non-zero but not naming 01_list line 1: $(tr '\n' ' ' < "$W/c3.txt")"; fi; fi
. "$BBX_HOME/lib/sh/expectation_kinds.sh"
mkdir -p "$W/c4/scenarios" "$W/c4/exp"; cp "$F/bbx.toml" "$W/c4/bbx.toml"; : > "$W/c4/scenarios/x.cli"
echo "exact fixture -" > "$W/c4/exp/x.masked"; printf '[spec]\nclass = "exact"\nbaseset = "fixture"\n' > "$W/c4/exp/x.truth"
if out="$(BBX_CONFIG="$W/c4/bbx.toml" enumerate_expectations "$W/c4/exp" "$W/c4" scenarios 2>&1)"; then fail "control unknown-kind-under-profile: the enumeration exit 0 with a .masked under the profile"
elif printf '%s\n' "$out" | grep -qx 'x|masked|UNKNOWN-KIND' && printf '%s\n' "$out" | grep -qx 'x|truth|EVAL'; then echo "CONTROL FIRED: unknown-kind-under-profile — $(printf '%s' "$out" | tr '\n' ' ')"
else fail "control unknown-kind-under-profile: $(printf '%s' "$out" | tr '\n' ' ')"; fi

if [ "$rc" = 0 ]; then echo "PASS: the command-line fixture is its generator's, chiral, its tool matches the design, and its profile resolves; 4 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"

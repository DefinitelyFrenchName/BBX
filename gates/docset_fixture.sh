#!/bin/sh
# docset_fixture.sh — the document-set fixture equals its generator and is chiral, its consumer config resolves to the document-set profile with the four new kinds and the `claims` scenario extension, and a kind the profile does not carry is unknown under it
# Ground truth for fixture/docset/mkdocset.py and the `document-set` kind profile (docs/plans/S3.md step 1; R31–R34;
# abstraction S1, E1; BBX-15, BBX-21). The generator's --check is run on the TREE's fixture (read-only: it regenerates
# under TMPDIR and diffs) and on perturbed COPIES for the controls; every perturbation is proven to have applied
# before its assertion (VampireSaved test_checkdocs_rom.sh's practice). No instrument. Portable, ~2 s.
# Usage: gates/docset_fixture.sh
# MUST-FIRE: perturbed-copy: edited-value — one value changed in a copy's records.tsv must make --check FAIL naming the file, or the fixture can drift by hand (BBX-21)
# MUST-FIRE: perturbed-copy: symmetric-fixture — two records given the same weight in a copy must make --check FAIL naming the predicate `weights-distinct`, or a fixture can stop being chiral without anyone reading which predicate broke (BBX-15)
# MUST-FIRE: known-bad: unknown-kind-under-profile — a `.masked` beside a `.claims` scenario under the fixture's config must enumerate UNKNOWN-KIND and non-zero, or the document-set profile inherits the temporal family it never declared (R23)
# NOT-ASSERTED: that any claim in the fixture is BOUND, MISMATCH or anything else (gates/docset_driver.sh and gates/set_schema.sh): only that the files are the generator's, the design is chiral, and the register is complete and tracked
# NOT-ASSERTED: the suite over the fixture: step 4
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_REPLAYS_DIR 2>/dev/null || true
F="$BBX_HOME/fixture/docset"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM

echo "== 1. the tree's fixture equals its generator (read-only: --check regenerates under TMPDIR) =="
if python3 "$F/mkdocset.py" --check > "$W/check.txt" 2>&1; then ok "mkdocset.py --check exit 0"; else fail "mkdocset.py --check exited non-zero: $(tr '\n' ' ' < "$W/check.txt")"; fi
grep -q '^  ok: every predicate holds' "$W/check.txt" && ok "every chirality predicate holds on subject/records.tsv" || fail "the predicate line is missing"
# the counts are NOTE-class numbers; re-emitted at column 0 because a captured NOTE never reaches the runner
note="$(grep '^NOTE: docset-fixture ' "$W/check.txt" || true)"
[ -n "$note" ] && ok "the generator prints its counts as a NOTE" || fail "no NOTE line from the generator"
n_files="$(find "$F/subject" "$F/claims" "$F/expected" -type f | wc -l | tr -d ' ')"
ok "files under subject/, claims/, expected/: $n_files"

echo "== 2. the consumer config resolves to the document-set profile =="
k="$(python3 -m bbx.config "$F/bbx.toml" kind)"; [ "$k" = document-set ] && ok "kind = document-set" || fail "kind resolved to '$k'"
kinds="$(BBX_CONFIG="$F/bbx.toml" python3 -m bbx.expectations kinds)"
[ "$(printf '%s\n' "$kinds" | wc -l | tr -d ' ')" = 7 ] && ok "seven kinds under the profile (the kind-blind three + truth, claims, covered, schema)" || fail "kinds table: $(printf '%s' "$kinds" | tr '\n' ' ')"
for want in "truth	exact	EVAL" "claims	set	EVAL" "covered	set	EVAL" "schema	schema	EVAL"; do
    printf '%s\n' "$kinds" | grep -qx "$want" && ok "kind row: $(printf '%s' "$want" | tr '\t' ' ')" || fail "missing kind row: $want"
done
printf '%s\n' "$kinds" | cut -f2 | grep -qx temporal && fail "the document-set profile carries a temporal family" || ok "no temporal family under the profile (a temporal comparator is REFUSED, D23)"
ext="$(BBX_CONFIG="$F/bbx.toml" python3 -m bbx.expectations scenario-ext)"; [ "$ext" = claims ] && ok "scenario extension = claims (R32, D34)" || fail "scenario-ext = '$ext'"
ext0="$(python3 -m bbx.expectations scenario-ext)"; [ "$ext0" = rpl ] && ok "kind-blind scenario extension = rpl (bbh's literal)" || fail "kind-blind scenario-ext = '$ext0'"
[ "$(python3 -m bbx.config "$F/bbx.toml" get fingerprint.file_pattern)" = "{set}.tsv" ] && ok "the identity is file-sha1 over {set}.tsv, whole-set key over subject/ (D33)" || fail "fingerprint.file_pattern under the profile"
n_reg="$(grep -vc '^#' "$F/expected/registry.tsv" | tr -d ' ')"; [ "$n_reg" = 1 ] && ok "one registry row (the whole-set key -> fixture)" || fail "registry rows: $n_reg"
wkey="$(cd "$F" && BBX_CONFIG="$F/bbx.toml" python3 -m bbx.fingerprint subject --set records --set-key)"
grep -q "^$wkey	fixture	" "$F/expected/registry.tsv" && ok "the registry row IS the fingerprint tool's whole-set key over subject/" || fail "the registry key differs from bbx.fingerprint --set-key ($wkey)"
exp="$(cd "$F" && BBX_CONFIG="$F/bbx.toml" python3 -m bbx.fingerprint subject --set records)"; [ "$exp" = fixture ] && ok "bbx.fingerprint resolves subject/ to expectation set 'fixture'" || fail "fingerprint resolved to '$exp'"
echo "$note"
if o="$(python3 -m bbx.provenance --config "$F/bbx.toml" 2>&1)"; then ok "the fixture's register: $(printf '%s\n' "$o" | grep '^  ok: [0-9]* expectation files' | sed 's/^  ok: //')"; else fail "the fixture's register (bbx.provenance): $(printf '%s' "$o" | grep 'FAIL' | tr '\n' ' ')"; fi
printf '%s\n' "$o" | grep -q '^  ok: every named file is tracked by git' && ok "every registered fixture file is tracked by git — a clone has the truth logs (G22)" || fail "tracked-ness of the fixture's expectations: $(printf '%s' "$o" | grep -n 'track\|not run' | tr '\n' ' ')"

echo "== 3. must-fire controls, each on a COPY =="
cp -R "$F" "$W/c1"
sed 's/^Dorin	7B06	57	1$/Dorin	7B06	56	1/' "$F/subject/records.tsv" > "$W/c1/subject/records.tsv"
if cmp -s "$W/c1/subject/records.tsv" "$F/subject/records.tsv"; then fail "control edited-value: the perturbation did not apply"; else
    if python3 "$W/c1/mkdocset.py" --check > "$W/c1.txt" 2>&1; then fail "control edited-value: --check still exit 0 on an edited value"
    elif grep -q 'DIFFERS  subject/records.tsv' "$W/c1.txt"; then echo "CONTROL FIRED: edited-value — $(grep '^FAIL' "$W/c1.txt")"
    else fail "control edited-value: non-zero but not naming records.tsv: $(tr '\n' ' ' < "$W/c1.txt")"; fi; fi
cp -R "$F" "$W/c2"
sed 's/^Bramble	5C21	58	3$/Bramble	5C21	41	3/' "$F/subject/records.tsv" > "$W/c2/subject/records.tsv"
if cmp -s "$W/c2/subject/records.tsv" "$F/subject/records.tsv"; then fail "control symmetric-fixture: the perturbation did not apply"; else
    if python3 "$W/c2/mkdocset.py" --check > "$W/c2.txt" 2>&1; then fail "control symmetric-fixture: --check still exit 0 on two equal weights"
    elif grep -q 'weights-distinct' "$W/c2.txt"; then echo "CONTROL FIRED: symmetric-fixture — $(head -1 "$W/c2.txt")"
    else fail "control symmetric-fixture: non-zero but not naming the predicate: $(tr '\n' ' ' < "$W/c2.txt")"; fi; fi
. "$BBX_HOME/lib/sh/expectation_kinds.sh"
mkdir -p "$W/c3/claims" "$W/c3/exp"; cp "$F/bbx.toml" "$W/c3/bbx.toml"; : > "$W/c3/claims/x.claims"
echo "exact fixture -" > "$W/c3/exp/x.masked"; echo "[spec]" > "$W/c3/exp/x.claims"
if out="$(BBX_CONFIG="$W/c3/bbx.toml" enumerate_expectations "$W/c3/exp" "$W/c3" claims 2>&1)"; then fail "control unknown-kind-under-profile: the enumeration exit 0 with a .masked under the profile"
elif printf '%s\n' "$out" | grep -qx 'x|masked|UNKNOWN-KIND' && printf '%s\n' "$out" | grep -qx 'x|claims|EVAL'; then echo "CONTROL FIRED: unknown-kind-under-profile — $(printf '%s' "$out" | tr '\n' ' ')"
else fail "control unknown-kind-under-profile: $(printf '%s' "$out" | tr '\n' ' ')"; fi

if [ "$rc" = 0 ]; then echo "PASS: the document-set fixture is its generator's, chiral, and its profile resolves; 3 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"

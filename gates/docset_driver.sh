#!/bin/sh
# docset_driver.sh — the document-set driver binds every claim of the fixture to the design's truth, byte for byte and twice; the extractor's self-test, the closed status vocabulary, the denominator, the guards and the refusals each fail where they must
# Ground truth for drivers/docset.sh and lib/py/bbx/docset.py (docs/plans/S3.md step 2, §3 "D1–D5", "O1", "the claim
# set", §5's seven driver controls; R31, R33; D35, D37–D40). The driver runs on the TREE's fixture (read-only) for the
# positive checks and on COPIES under TMPDIR for every control; every perturbation is proven to have applied before its
# assertion (VampireSaved test_checkdocs_rom.sh's practice). The truth log is the GENERATOR's, from the design — so a log
# that equals it is the binder agreeing with the design, never with itself. No comparator (step 3): the gate compares
# the log to the truth with cmp/diff and names the index itself. No instrument. Portable, ~3 s.
# Usage: gates/docset_driver.sh
# MUST-FIRE: perturbed-copy: edited-document — one bound sentence reworded in a copy of the set (`weight` -> `mass`) must read STALE at its index and the log must differ from the truth THERE and nowhere else, or an edited document is invisible to the binding (O5, BBX-18)
# MUST-FIRE: perturbed-copy: shifted-artifact — the first data row deleted from a copy of the artifact must turn every claim about that record STALE and leave every other index as the truth has it, or a record the artifact lost binds to something (BBX-16: the artifact view is keyed, a deletion is a lost reference, not a shift)
# MUST-FIRE: known-bad: wrong-claim — the fixture's planted wrong claim must read MISMATCH at its index and at no other, and a truth copy with that index rewritten BOUND must no longer equal the log at that line, or the known positive is not one (BBX-5, BBX-2)
# MUST-FIRE: perturbed-copy: paraphrase — the listed paraphrase must read PARAPHRASE, never BOUND, and its literal perturbed in a copied artifact must turn it MISMATCH at that index only, or the class degrades into a skip (R33)
# MUST-FIRE: known-bad: unlisted-unbindable — the two listed unbindables must be counted in END, and a claim-set copy with the absence row removed, then one with the number row removed, must each be REFUSED naming the line, or an absence nobody listed is silently dropped (BBX-7)
# MUST-FIRE: shadow-tool: extractor-shadow — a shadow copy of docset.py with one form's regex broken must make the driver exit 1 naming the form before any document is read (no log written), or an extractor that stopped matching reads as a document with fewer claims
# MUST-FIRE: known-bad: refused-form-and-family — a claim set declaring a form no extractor implements, and each of MASK_RANGES, POKES and DOCSET_VIEW in the environment, must be REFUSED with exit 3 and no log, or a run silently measures less than its caller asked (BBH-28, C6)
# NOT-ASSERTED: the verdict text of the exact, set and schema comparators (S3 step 3): the truth is compared here with cmp and diff
# NOT-ASSERTED: the suite over the fixture (identity, the kinds loop, the coverage NOTE on the screen): gates/docset_suite.sh
# NOT-ASSERTED: prose, reasoning and causal claims in a document: only sentences in a declared form and the listed rows are claims
# NOT-ASSERTED: the truth of the artifact itself: a document that agrees with a wrong artifact reads BOUND
# NOT-ASSERTED: a nested document tree or a second artifact per set (DOCSET_VIEW is refused): S4 or a consumer's question
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/docset"; DRV="$BBX_HOME/drivers/docset.sh"; TRUTH="$F/expected/fixture/logs"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
drv() {   # drv <subject-dir> <claims> <out> [VAR=value ...] -> the driver's output; status in $s
    _d="$1"; _c="$2"; _o="$3"; shift 3
    if out="$(env DOCSET_PATH="$_d" "$@" "$DRV" records "$_c" "$_o" 2>&1)"; then s=0; else s=$?; fi
}
status_at() { awk -v i="$2" '$1 == i { split($2, t, ":"); print t[1] }' "$1"; }   # the status of one index, by field
statuses() { awk '$1 != "END" { split($2, t, ":"); print $1, t[1] }' "$1"; }

echo "== 1. the extractor's self-test, standalone =="
o="$(python3 -m bbx.docset selftest 2>&1)" && ok "$o" || fail "self-test: $o"

echo "== 2. every scenario of the tree's fixture binds to the design's truth, byte for byte, twice =="
for sc in 01_all 02_weights 03_rows; do
    drv "$F/subject" "$F/claims/$sc.claims" "$W/$sc.1.log"; [ "$s" = 0 ] || { fail "$sc run 1: exit $s: $out"; continue; }
    drv "$F/subject" "$F/claims/$sc.claims" "$W/$sc.2.log"; [ "$s" = 0 ] || { fail "$sc run 2: exit $s: $out"; continue; }
    cmp -s "$W/$sc.1.log" "$W/$sc.2.log" && ok "$sc: two runs, byte-identical (BBX-14)" || fail "$sc: the two runs differ"
    if cmp -s "$W/$sc.1.log" "$TRUTH/$sc.log"; then ok "$sc: the log EQUALS the generator's truth ($(tail -1 "$W/$sc.1.log"))"
    else fail "$sc: the log differs from the truth: $(diff "$TRUTH/$sc.log" "$W/$sc.1.log" | head -2 | tr '\n' ' ')"; fi
    n="$(tail -1 "$W/$sc.1.log" | awk '{print $2}')"; m="$(grep -vc '^END ' "$W/$sc.1.log" | tr -d ' ')"
    [ "$n" = "$m" ] && ok "$sc: END $n equals the claim lines ($m) — the denominator is in the log (R33)" || fail "$sc: END $n but $m claim lines"
done
LOG="$W/01_all.1.log"
python3 -m bbx.docset summary "$LOG" > "$W/summary.txt" && ok "summary: $(tr '\n' ' ' < "$W/summary.txt")" || fail "summary: $(cat "$W/summary.txt")"
for st in BOUND PARAPHRASE UNBINDABLE MISMATCH; do
    statuses "$LOG" | grep -q " $st$" && ok "the log carries a $st token" || fail "no $st token in 01_all (the design has one)"
done
statuses "$LOG" | awk '{print $2}' | grep -vxE 'BOUND|PARAPHRASE|UNBINDABLE|STALE|MISMATCH' > "$W/unknown" || true
[ -s "$W/unknown" ] && fail "a status outside the closed vocabulary: $(tr '\n' ' ' < "$W/unknown")" || ok "every status is in the closed vocabulary (R33, D37)"
python3 -m bbx.docset map "$F/subject/records.tsv" "$F/claims/01_all.claims" > "$W/map.tsv" && ok "map: $(wc -l < "$W/map.tsv" | tr -d ' ') rows, index -> (document, line, form, status, quoted, derived)" || fail "map failed"
drv "$F/subject" "$F/claims/01_all.claims" "$W/sb.log" DOCSET_NONDET=1; drv "$F/subject" "$F/claims/01_all.claims" "$W/sb2.log" DOCSET_NONDET=1
{ [ "$s" = 0 ] && ! cmp -s "$W/sb.log" "$W/sb2.log"; } && ok "DOCSET_NONDET=1: two runs differ (the kind's nondeterminism knob is live; gates/docset_suite.sh carries it through the suite)" || fail "DOCSET_NONDET=1 did not move the log"
mkdir -p "$W/sbx"; drv "$F/subject" "$F/claims/02_weights.claims" "$W/sbx.log" ; : "$s"
if out="$(env DOCSET_PATH="$W/nowhere;$F/subject" "$DRV" records "$F/claims/02_weights.claims" "$W/sp.log" "$W/sbx" 2>&1)"; then
    cmp -s "$W/sp.log" "$TRUTH/02_weights.log" && [ -f "$W/sbx/docset_selftest.txt" ] && ok "a two-component search path resolves the second; the sandbox holds the self-test's output" || fail "search path / sandbox: $out"
else fail "two-component DOCSET_PATH with a sandbox: exit $?: $out"; fi
drv "$W/nowhere" "$F/claims/02_weights.claims" "$W/np.log"; [ "$s" = 1 ] && [ ! -f "$W/np.log" ] && ok "no <set>.tsv on the path: exit 1, no log ($out)" || fail "missing artifact: exit $s"
printf '[claims]\ndocuments = ["weights.md"]\n' > "$W/bad.claims"
drv "$F/subject" "$W/bad.claims" "$W/bad.log"; [ "$s" = 1 ] && ok "a claim set with no forms: exit 1 (DISCARDED): $out" || fail "malformed claim set: exit $s: $out"
printf '[claims]\ndocuments = ["gone.md"]\nforms = ["has"]\n' > "$W/gone.claims"
drv "$F/subject" "$W/gone.claims" "$W/gone.log"; [ "$s" = 1 ] && [ ! -f "$W/gone.log" ] && ok "a named document that is absent: exit 1, no log" || fail "absent document: exit $s: $out"
grep '^NOTE:' "$W/summary.txt"

echo "== 3. must-fire controls, each on a COPY =="
echo "-- edited-document --"
cp -R "$F/subject" "$W/c1"; sed 's/^Dorin has weight 57\.$/Dorin has mass 57./' "$F/subject/overview.md" > "$W/c1/overview.md"
if cmp -s "$W/c1/overview.md" "$F/subject/overview.md"; then fail "CONTROL DEAD: edited-document — the perturbation did not apply"; else
    drv "$W/c1" "$F/claims/01_all.claims" "$W/c1.log"
    d="$(diff "$TRUTH/01_all.log" "$W/c1.log" | grep -c '^[<>]' || true)"; st="$(status_at "$W/c1.log" 4)"
    if [ "$s" = 0 ] && [ "$st" = STALE ] && [ "$d" = 2 ] && diff "$TRUTH/01_all.log" "$W/c1.log" | grep -q '^4c4$'; then
        echo "CONTROL FIRED: edited-document — index 4 reads STALE; the log differs from the truth at line 4 and nowhere else (diff: 4c4)"
    else fail "CONTROL DEAD: edited-document — exit $s, index 4 '$st', $d differing lines"; fi; fi
echo "-- shifted-artifact --"
cp -R "$F/subject" "$W/c2"; sed '2d' "$F/subject/records.tsv" > "$W/c2/records.tsv"
if [ "$(wc -l < "$W/c2/records.tsv" | tr -d ' ')" != 12 ] || grep -q '^Aldric' "$W/c2/records.tsv"; then fail "CONTROL DEAD: shifted-artifact — the perturbation did not apply"; else
    drv "$W/c2" "$F/claims/01_all.claims" "$W/c2.log"
    statuses "$TRUTH/01_all.log" > "$W/t.st"; statuses "$W/c2.log" > "$W/c2.st"
    moved="$(diff "$W/t.st" "$W/c2.st" | awk '/^>/ {print $2 ":" $3}' | tr '\n' ' ')"
    if [ "$s" = 0 ] && [ "$moved" = "1:STALE 10:STALE " ] && [ "$(status_at "$W/c2.log" 4)" = BOUND ]; then
        echo "CONTROL FIRED: shifted-artifact — the deleted record's two claims read STALE (indices 1 and 10); the other 21 indices are the truth's"
    else fail "CONTROL DEAD: shifted-artifact — exit $s, moved: '$moved'"; fi; fi
echo "-- wrong-claim --"
nm="$(statuses "$LOG" | grep -c ' MISMATCH$' || true)"; st="$(status_at "$LOG" 12)"
sed 's/^12 MISMATCH:/12 BOUND:/' "$TRUTH/01_all.log" > "$W/truth_bound.log"
if cmp -s "$W/truth_bound.log" "$TRUTH/01_all.log"; then fail "CONTROL DEAD: wrong-claim — the truth copy was not perturbed"; else
    c="$(cmp "$LOG" "$W/truth_bound.log" 2>&1 || true)"
    if [ "$st" = MISMATCH ] && [ "$nm" = 1 ] && printf '%s' "$c" | grep -q 'line 12'; then
        echo "CONTROL FIRED: wrong-claim — index 12 (weights.md:5, Dorin 58 vs the artifact's 57) is the one MISMATCH; a truth rewritten BOUND there differs from the log at line 12"
    else fail "CONTROL DEAD: wrong-claim — index 12 '$st', $nm mismatches, cmp: $c"; fi; fi
echo "-- paraphrase --"
cp -R "$F/subject" "$W/c4"; sed 's/^Corvin	19E4	37	11$/Corvin	19E4	36	11/' "$F/subject/records.tsv" > "$W/c4/records.tsv"
if cmp -s "$W/c4/records.tsv" "$F/subject/records.tsv"; then fail "CONTROL DEAD: paraphrase — the perturbation did not apply"; else
    drv "$W/c4" "$F/claims/01_all.claims" "$W/c4.log"
    statuses "$W/c4.log" > "$W/c4.st"; moved="$(diff "$W/t.st" "$W/c4.st" | awk '/^>/ {print $2 ":" $3}' | tr '\n' ' ')"
    if [ "$(status_at "$LOG" 3)" = PARAPHRASE ] && [ "$s" = 0 ] && [ "$moved" = "3:MISMATCH " ]; then
        echo "CONTROL FIRED: paraphrase — index 3 reads PARAPHRASE on the tree (never BOUND); its literal 37 -> 36 in the artifact turns index 3 MISMATCH and nothing else"
    else fail "CONTROL DEAD: paraphrase — tree index 3 '$(status_at "$LOG" 3)', exit $s, moved: '$moved'"; fi; fi
echo "-- unlisted-unbindable --"
nu="$(statuses "$LOG" | grep -c ' UNBINDABLE$' || true)"
awk '/^\[u1\]/ {skip=1; next} skip && /^\[/ {skip=0} !skip' "$F/claims/01_all.claims" > "$W/nou1.claims"
awk '/^\[u2\]/ {skip=1; next} skip && /^\[/ {skip=0} !skip' "$F/claims/01_all.claims" > "$W/nou2.claims"
if grep -q '^\[u1\]' "$W/nou1.claims" || grep -q '^\[u2\]' "$W/nou2.claims"; then fail "CONTROL DEAD: unlisted-unbindable — a row was not removed"; else
    drv "$F/subject" "$W/nou1.claims" "$W/nou1.log"; s1="$s"; o1="$out"
    drv "$F/subject" "$W/nou2.claims" "$W/nou2.log"; s2="$s"; o2="$out"
    if [ "$nu" = 2 ] && [ "$s1" = 3 ] && [ "$s2" = 3 ] && [ ! -f "$W/nou1.log" ] && [ ! -f "$W/nou2.log" ] \
       && printf '%s' "$o1" | grep -q "^REFUSED: drivers/docset.sh cannot honour overview.md:9 (an unlisted absence" \
       && printf '%s' "$o2" | grep -q "^REFUSED: drivers/docset.sh cannot honour overview.md:11 (an unlisted number"; then
        echo "CONTROL FIRED: unlisted-unbindable — 2 UNBINDABLE counted in END 23; the absence row removed -> REFUSED overview.md:9, the number row removed -> REFUSED overview.md:11, exit 3, no log"
    else fail "CONTROL DEAD: unlisted-unbindable — counted $nu; exit $s1/$s2: $o1 | $o2"; fi; fi
echo "-- extractor-shadow --"
SH="$W/shadow"; mkdir -p "$SH/lib/py"; cp -R "$BBX_HOME/lib/py/bbx" "$SH/lib/py/bbx"; ln -s "$BBX_HOME/drivers" "$SH/drivers"
sed -i.bak 's/of {_NAME} is {_VALUE}/of {_NAME} was {_VALUE}/' "$SH/lib/py/bbx/docset.py"
if ! grep -q 'was {_VALUE}' "$SH/lib/py/bbx/docset.py"; then fail "CONTROL DEAD: extractor-shadow — the shadow was not perturbed (sed matched nothing)"; else
    if out="$(env BBX_HOME="$SH" DOCSET_PATH="$F/subject" "$SH/drivers/docset.sh" records "$F/claims/01_all.claims" "$W/sh.log" 2>&1)"; then s=0; else s=$?; fi
    if [ "$s" = 1 ] && [ ! -f "$W/sh.log" ] && printf '%s' "$out" | grep -q "self-test FAILED — form 'of-is'"; then
        echo "CONTROL FIRED: extractor-shadow — a broken of-is regex: exit 1 naming the form, no log written ($(printf '%s' "$out" | head -1 | cut -c1-90))"
    else fail "CONTROL DEAD: extractor-shadow — exit $s: $out"; fi; fi
echo "-- refused-form-and-family --"
sed 's/^forms = .*/forms = ["regex"]/' "$F/claims/01_all.claims" > "$W/regex.claims"
if ! grep -q '^forms = \["regex"\]' "$W/regex.claims"; then fail "CONTROL DEAD: refused-form-and-family — the claim set was not perturbed"; else
    drv "$F/subject" "$W/regex.claims" "$W/r0.log"; s0="$s"; o0="$out"
    drv "$F/subject" "$F/claims/01_all.claims" "$W/r1.log" MASK_RANGES=043c-043d; s1="$s"; o1="$out"
    drv "$F/subject" "$F/claims/01_all.claims" "$W/r2.log" POKES=50:1000:ff; s2="$s"; o2="$out"
    drv "$F/subject" "$F/claims/01_all.claims" "$W/r3.log" DOCSET_VIEW=second; s3="$s"; o3="$out"
    if [ "$s0$s1$s2$s3" = 3333 ] && [ ! -f "$W/r0.log" ] && [ ! -f "$W/r1.log" ] && [ ! -f "$W/r2.log" ] && [ ! -f "$W/r3.log" ] \
       && printf '%s' "$o0" | grep -q "^REFUSED: drivers/docset.sh cannot honour form 'regex'" \
       && printf '%s' "$o1" | grep -q "^REFUSED: drivers/docset.sh cannot honour MASK_RANGES" \
       && printf '%s' "$o2" | grep -q "^REFUSED: drivers/docset.sh cannot honour POKES" \
       && printf '%s' "$o3" | grep -q "^REFUSED: drivers/docset.sh cannot honour DOCSET_VIEW"; then
        echo "CONTROL FIRED: refused-form-and-family — form 'regex', MASK_RANGES, POKES and DOCSET_VIEW each REFUSED, exit 3, no log"
    else fail "CONTROL DEAD: refused-form-and-family — exits $s0 $s1 $s2 $s3: $o0 | $o1 | $o2 | $o3"; fi; fi
drv "$F/subject" "$F/claims/01_all.claims" "$W/r4.log" MASK_RANGES=; [ "$s" = 0 ] && ok "an EMPTY MASK_RANGES (what the suite exports for a maskless kind, D26) is not a refusal" || fail "empty MASK_RANGES: exit $s: $out"

echo
if [ "$rc" = 0 ]; then echo "PASS: the document-set driver binds the fixture to the design's truth, twice; the self-test, the vocabulary, the guards and the refusals hold; 7 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"

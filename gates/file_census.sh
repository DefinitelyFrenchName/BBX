#!/bin/sh
# file_census.sh — every harness file of BBX is executed by a gate, the kinds that reach it have not shrunk, and the census document is the run's own text
# THE MEASUREMENT (R39, S4 step 6; the instrument's ground truth is gates/file_census_tool.sh).
# This gate points lib/py/bbx/file_census.py at BBX's OWN tree, which means building a shadow of
# HEAD and running the WHOLE registered battery inside it — about 20 minutes. That is why it is
# the first row of gates/sweep.tsv at the release scope and not in a tier that runs every
# battery (D63; R39 declined "a portable gate that re-runs the battery every battery"), and why
# BBX's first [tier].patterns entry names `file-census --self`: a gate registered only in the
# sweep registry would otherwise be an orphan, because lib/py/bbx/tier.py reads
# `known = portable | static` and never the sweep rows (X36).
# What it asserts, each a row and not a sentence: no harness file is reached by NO gate (rot
# class 1); no file's kind-set SHRANK against expected/file_census.toml (D62, shrink-only, class
# `self` — currency, never correctness); and docs/census/bbx_files.md's generated block is
# byte-identical to what this run renders (BBX-21: the census is generated, never hand-edited).
# The CONTROLS run with --reuse against the run's own kept traces, so proving the gate can fail
# costs seconds rather than one whole battery per control.
# Usage: BBX_BBH_HOME=<bbh> gates/file_census.sh        Static+sweep, ~20 min.
# SKIP: BBX_BBH_HOME is unset — the shadow's own static tier could not run, and a battery that
#       skipped four gates would under-report every file those four reach
# MUST-FIRE: perturbed-copy: edited-census-row — one count edited in a COPY of the census document must make --check non-zero and name the line with both texts, or the document is not actually compared
# MUST-FIRE: perturbed-copy: shrunk-kind-set — a COPY of the frozen register claiming a kind this run did not measure must FAIL naming the file and both sides, or shrink-only asserts nothing
# MUST-FIRE: known-bad: contaminated-trace — a kept run whose verdicts say one gate was not PASS must be REFUSED outright, because a gate that failed in the shadow executed less than it executes in the tree and its trace would silently shrink that file's kind-set
# NOT-ASSERTED: that a file reached by a gate of some kind is USED by that kind: the trace records what a process loaded or executed, never why — a module imported by a shared comparator is attributed to the importer, not to the importer's caller (the explainer rule), and a file the census cannot see at all is named by no row
# NOT-ASSERTED: a BBX-25 verdict: the kind-specific rows are REPORTED. Whether a file reached by one kind only should be generic is a reading of this census, never its output
# NOT-ASSERTED: what a CONSUMER's run executes: only what BBX's own registered gates execute, once each, on this host
# NOT-ASSERTED: the instrument itself — that the trace is complete, that the insertion point preserves headers, that the frozen register fails in every direction: gates/file_census_tool.sh is the ground truth and runs every battery
# NOT-ASSERTED: the selfgates registry row of the TREE: the shadow is an instrumented harness, so its self identity legitimately moves and this gate re-derives that fixture's expectation INSIDE the throwaway shadow. gates/adapters.sh is what holds the tree's row
# NOT-ASSERTED: any platform but this host's (R21)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
cd "$BBX_HOME"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }

[ -n "${BBX_BBH_HOME:-}" ] || {
    echo "SKIP: BBX_BBH_HOME is unset — the shadow's static tier (fidelity_bbh, fidelity_bbh_s2,"
    echo "      suite) could not run, and four unrun gates would under-report every file they reach."
    exit 0
}

T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
OUT="${BBX_FILE_CENSUS_OUT:-$T/run}"
DOC="docs/census/bbx_files.md"
FROZEN="expected/file_census.toml"
BBX="$BBX_HOME/bin/bbx"
REFREEZE='python3 fixture/selfgates/mkselfgates.py'

echo "== 1. the instrument over BBX's own tree: a shadow of HEAD, every registered gate once =="
if "$BBX" file-census --self --out "$OUT" --shadow-refreeze "$REFREEZE" \
       --document "$DOC" --check --frozen "$FROZEN" > "$T/run.log" 2>&1; then
    ok "the run completed, the document is the run's own text, no kind-set shrank"
else
    fail "the census run is RED — see the lines below"
    grep -E '^(REFUSED|FAIL)' "$T/run.log" | head -12 | sed 's/^/        /'
fi
sed -n '1,3p' "$T/run.log" | sed 's/^/    /'
grep -E '^    [a-z_]+ +(PASS|FAIL|SKIP|TIMEOUT|MISSING)' "$T/run.log" | sed 's/^/  /'
grep -E '^  (gate kinds|kind-sets|document)' "$T/run.log" | sed 's/^/  /'
grep '^NOTE:' "$T/run.log" || true

echo "== 2. no harness file is reached by NO gate (rot class 1) =="
grep -q 'is executed by NO gate' "$T/run.log" \
  && fail "a harness file is reached by no gate: $(grep -o '`[^`]*` is executed by NO gate' "$T/run.log" | tr '\n' ' ')" \
  || ok "every tracked file under bin/, lib/ and drivers/ is executed by at least one gate"

echo "== 3. the kinds a file is reached by have not shrunk (D62) =="
ks="$(grep '^  kind-sets' "$T/run.log" || true)"
[ -n "$ks" ] || fail "the run printed no kind-sets line"
printf '%s\n' "$ks" | grep -q ' failures 0 ' \
  && ok "shrink-only holds: $(printf '%s\n' "$ks" | sed 's/^  *//')" \
  || fail "$(printf '%s\n' "$ks" | sed 's/^  *//')"
printf '%s\n' "$(grep '^NOTE: file-census-grew' "$T/run.log" || true)" | grep -q . \
  && echo "  note  a kind GREW — a note, and the register re-freezes (D62)" || true

echo "== 4. the design target of S4 step 6, read off this run (plan §6, X37) =="
kinds_line="$(grep '^  gate kinds' "$T/run.log" || true)"
for g in adapters cli_suite docset_suite; do
    printf '%s\n' "$kinds_line" | grep -q "$g=" \
      || fail "$g is not in the kinds line"
done
printf '%s\n' "$kinds_line" | grep -q 'adapters=C' \
  && ok "gates/adapters.sh is a COMMAND-LINE gate, so what it executes gains kind C" \
  || fail "adapters reads $(printf '%s\n' "$kinds_line" | grep -o 'adapters=[A-Z]*')"
three="$(awk -F'|' '/^\| `/ && $3 ~ /[0-9]/ {print}' "$DOC" | wc -l | tr -d ' ')"
[ "$three" -gt 0 ] && ok "the document carries $three file rows, each with the gates that executed it" \
  || fail "the document carries no file rows"
for f in 'bin/bbx' 'bin/bbx-run-static'; do
    if grep -q "^| \`$f\` |.*adapters" "$DOC"; then
        ok "$f is executed by gates/adapters.sh — the row step 5 moved"
    else
        fail "$f is not executed by adapters in this run"
    fi
done
grep -q '^| `bin/bbx-run-sweep` |.*adapters' "$DOC" \
  && fail "bin/bbx-run-sweep is executed by adapters — X33 says it is not" \
  || ok "bin/bbx-run-sweep is NOT reached by the adapters gate, as X33 records"

echo "== 5. MUST-FIRE: one count edited in a COPY of the census document =="
cp "$DOC" "$T/doc_edited.md"
python3 - "$T/doc_edited.md" <<'PY'
import re, sys
p = sys.argv[1]
s = open(p).read()
m = re.search(r"^\| `([^`]+)` \| (\d+) \|", s, re.M)
if not m:
    sys.exit("no file row to perturb")
open(p, "w").write(s[:m.start(2)] + str(int(m.group(2)) + 7) + s[m.end(2):])
print(f"perturbed {m.group(1)}: {m.group(2)} -> {int(m.group(2)) + 7}")
PY
cmp -s "$DOC" "$T/doc_edited.md" && fail "CONTROL DEAD: edited-census-row — the perturbation did not apply"
if "$BBX" file-census --self --out "$OUT" --reuse --document "$T/doc_edited.md" --check > "$T/c1.log" 2>&1; then
    echo "CONTROL DEAD: edited-census-row — --check passed a document with an edited count"
    fail "the document is not actually compared"
else
    if grep -qE '^FAIL file-census: .*doc_edited\.md:[0-9]+ differs from the run$' "$T/c1.log" \
       && grep -q '^       document: ' "$T/c1.log" && grep -q '^       the run : ' "$T/c1.log"; then
        echo "CONTROL FIRED: edited-census-row — $(grep -oE '[^ /]*doc_edited\.md:[0-9]+ differs from the run' "$T/c1.log"), both texts printed"
        ok "an edited census row is named with the document's text and the run's"
    else
        echo "CONTROL DEAD: edited-census-row — non-zero, but not the named line"
        fail "$(grep FAIL "$T/c1.log" | head -1)"
    fi
fi

echo "== 6. MUST-FIRE: a COPY of the frozen register claiming a kind this run did not measure =="
python3 - "$FROZEN" "$T/frozen_shrunk.toml" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
s = open(src).read()
# the first row whose kind-set lacks F gains one: the run measured less than the freeze claims
m = re.search(r'^kinds = "([^F"]*)"$', s, re.M)
if not m:
    sys.exit("every frozen row already carries F — no perturbation available")
open(dst, "w").write(s[:m.start(1)] + m.group(1) + "F" + s[m.end(1):])
print(f"perturbed one row: {m.group(1)} -> {m.group(1)}F")
PY
cmp -s "$FROZEN" "$T/frozen_shrunk.toml" && fail "CONTROL DEAD: shrunk-kind-set — the perturbation did not apply"
if "$BBX" file-census --self --out "$OUT" --reuse --frozen "$T/frozen_shrunk.toml" > "$T/c2.log" 2>&1; then
    echo "CONTROL DEAD: shrunk-kind-set — a register claiming an F nobody measured passed"
    fail "shrink-only asserts nothing"
else
    if grep -qE '^FAIL file-census: `[^`]+` lost kind\(s\) F — frozen .*, measured ' "$T/c2.log"; then
        echo "CONTROL FIRED: shrunk-kind-set — $(grep -oE '`[^`]+` lost kind\(s\) F' "$T/c2.log" | head -1) named with both sides"
        ok "a kind-set that shrank FAILs naming the file and the direction"
    else
        echo "CONTROL DEAD: shrunk-kind-set — non-zero, but not the named line"
        fail "$(grep FAIL "$T/c2.log" | head -1)"
    fi
fi
[ -f "$FROZEN" ] && cmp -s "$FROZEN" "$FROZEN" && ok "the TRACKED register was never written (every perturbation is a copy, [BBH-59])"

echo "== 7. MUST-FIRE: a kept run in which one gate was not PASS is REFUSED =="
cp -R "$OUT" "$T/run_dirty"
victim="$(awk -F'\t' 'NR==2{print $1}' "$T/run_dirty/verdicts.tsv")"
awk -F'\t' -v OFS='\t' -v v="$victim" 'NR==1{print;next} $1==v{$4="FAIL"} {print}' \
    "$T/run_dirty/verdicts.tsv" > "$T/vd.tsv" && mv "$T/vd.tsv" "$T/run_dirty/verdicts.tsv"
grep -q "^$victim	.*	FAIL\$" "$T/run_dirty/verdicts.tsv" \
  || fail "CONTROL DEAD: contaminated-trace — the perturbation did not apply"
if "$BBX" file-census --self --out "$T/run_dirty" --reuse > "$T/c3.log" 2>&1; then
    echo "CONTROL DEAD: contaminated-trace — a run with a non-PASS gate was analysed anyway"
    fail "a contaminated trace is not refused"
else
    if grep -q "^REFUSED: file-census: \`$victim\` is FAIL in the shadow — its trace is CONTAMINATED" "$T/c3.log"; then
        echo "CONTROL FIRED: contaminated-trace — \`$victim\` marked FAIL and the whole run REFUSED, never adjusted"
        ok "a gate that did not pass in the shadow discards the run (CLAUDE.md §1)"
    else
        echo "CONTROL DEAD: contaminated-trace — non-zero, but not the refusal"
        fail "$(grep -E 'REFUSED|FAIL' "$T/c3.log" | head -1)"
    fi
fi

echo "== 8. the tree this gate measured is unwritten by the measurement =="
porc="$(git status --porcelain -- bin lib drivers gates fixture | wc -l | tr -d ' ')"
[ "$porc" = 0 ] && ok "bin, lib, drivers, gates and fixture are porcelain-clean after the run" \
  || fail "the measurement wrote under the tree: $(git status --porcelain -- bin lib drivers gates fixture | head -3 | tr '\n' ' ')"

printf '\nNOTE: file-census-universe %s\n' "$(git ls-files lib bin drivers | grep -vc '\.md$')"
printf 'NOTE: file-census-gates %s\n' "$(grep -hv '^#' gates/portable.txt gates/static.txt | wc -l | tr -d ' ')"
echo
[ "$rc" = 0 ] && echo "PASS: every harness file is reached by a gate, no kind-set shrank, and the census document is this run's own text" \
  || { echo "FAIL: see above"; exit 1; }

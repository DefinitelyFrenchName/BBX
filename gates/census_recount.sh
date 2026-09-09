#!/bin/sh
# census_recount.sh — every count in docs/census/*.md reproduces at the recorded HEAD of its repository
# For each census file, every §A row whose count is a plain integer or a quoted string and
# whose command is one shell pipeline is re-run from the repository root the file records,
# after the repository's HEAD is checked against the one the file was measured at. Rows in
# any other shape are NOT-RECOUNTABLE: counted and named in the output, never passed. The
# first self-validation gate (R9, R14): BBX's own documents read as a document set.
# Usage: gates/census_recount.sh                (from the BBX root; ~21 s measured 2026-09-09, docs/defaults.md D2)
#   BBX_CENSUS_TIMEOUT=<seconds per command>     default 60 (docs/defaults.md D1)
#   BBX_CENSUS_DIR=<dir of census files>         default docs/census (docs/defaults.md D7); a dir whose census names an absent tree exercises SKIP
# SKIP: a repository directory a census file names is absent (exit 0; asserts nothing).
# MUST-FIRE: known-bad: wrong-head — a shadow census whose recorded HEAD is not the repository's must FAIL with "HEAD moved"
# MUST-FIRE: perturbed-copy: moved-count — a shadow census with one recountable count changed by one must FAIL on that row
#
set -u
BBX_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TOOL="$BBX_ROOT/lib/py/bbx/recount.py"
[ -f "$TOOL" ] || { echo "FAIL: $TOOL is missing"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: python3 not on PATH"; exit 1; }

T=$(mktemp -d "${TMPDIR:-/tmp}/bbx_recount.XXXXXX") || { echo "FAIL: mktemp"; exit 1; }
trap 'rm -rf "$T"' EXIT

# --- the real recount, every census file ------------------------------------
CENSUS_DIR="${BBX_CENSUS_DIR:-$BBX_ROOT/docs/census}"
fail=0; files=0; rows=0; match=0; mismatch=0; notrec=0; nonzero=0
for census in "$CENSUS_DIR"/bbh.md "$CENSUS_DIR"/vampiresaved.md "$CENSUS_DIR"/sms.md; do
    [ -f "$census" ] || { echo "FAIL: census file missing: $census"; exit 1; }
    name=$(basename "$census")
    root=$(sed -n '2p' "$census" | grep -oE '`/[^`]*`' | head -1 | tr -d '`')
    if [ -z "$root" ] || [ ! -d "$root" ]; then
        echo "SKIP: $name names a repository directory that is absent here: ${root:-<none>}"
        exit 0
    fi
    files=$((files + 1))
    out="$T/$name.out"
    python3 "$TOOL" "$census" > "$out" 2>&1; rc=$?
    grep -E '^row=.* verdict=(MISMATCH|TIMEOUT)' "$out"
    grep -E '^census=' "$out"
    grep -E '^not_recountable_ids=' "$out"
    s=$(grep -E '^census=' "$out" | tail -1)
    for k in rows match mismatch not_recountable nonzero_exit; do
        v=$(printf '%s\n' "$s" | tr ' ' '\n' | grep "^$k=" | cut -d= -f2)
        [ -n "$v" ] || v=0
        case $k in
            rows) rows=$((rows + v));; match) match=$((match + v));;
            mismatch) mismatch=$((mismatch + v));; not_recountable) notrec=$((notrec + v));;
            nonzero_exit) nonzero=$((nonzero + v));;
        esac
    done
    [ "$rc" -eq 0 ] || fail=1
done

# --- the controls: each must fail for its stated reason --------------------
# a census whose counts we know match is the base for both shadows
base="$BBX_ROOT/docs/census/bbh.md"
shadow_head="$T/wrong_head.md"
recorded=$(sed -n '1p' "$base" | grep -oE '@ [0-9a-f]+' | cut -d' ' -f2)
sed "1s/@ $recorded/@ 0000000/" "$base" > "$shadow_head"
if python3 "$TOOL" "$shadow_head" > "$T/c1.out" 2>&1; then
    echo "CONTROL DEAD: wrong-head — a shadow census at HEAD 0000000 was recounted as if current"; fail=1
elif grep -q 'HEAD moved' "$T/c1.out"; then
    echo "CONTROL FIRED: wrong-head — $(grep -E '^census=' "$T/c1.out")"
else
    echo "CONTROL DEAD: wrong-head — failed, but not with 'HEAD moved': $(tail -1 "$T/c1.out")"; fail=1
fi

shadow_count="$T/moved_count.md"
python3 - "$base" "$shadow_count" <<'EOF'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
done = False
out = []
for line in open(src, encoding="utf-8"):
    if not done and line.startswith("| A1 |"):
        # count cell = third cell; the command after it may hold raw pipes, so cut on the first three
        head, sep, rest = line.partition("| A1 |")
        dim, sep2, tail = rest.partition("|")
        cnt, sep3, cmd = tail.partition("|")
        n = int(cnt.strip().strip("*").replace(",", ""))
        line = f"| A1 |{dim}| {n + 1} |{cmd}"
        done = True
    out.append(line)
open(dst, "w", encoding="utf-8").write("".join(out))
sys.exit(0 if done else 1)
EOF
[ $? -eq 0 ] || { echo "CONTROL DEAD: moved-count — could not build the shadow (no row A1 in $base)"; fail=1; }
if [ -f "$shadow_count" ]; then
    if python3 "$TOOL" "$shadow_count" > "$T/c2.out" 2>&1; then
        echo "CONTROL DEAD: moved-count — a count moved by one was recounted as a match"; fail=1
    elif grep -q '^row=A1 verdict=MISMATCH' "$T/c2.out"; then
        echo "CONTROL FIRED: moved-count — $(grep '^row=A1 ' "$T/c2.out")"
    else
        echo "CONTROL DEAD: moved-count — failed, but not on row A1: $(grep -E 'MISMATCH|census=' "$T/c2.out" | head -2 | tr '\n' ' ')"; fail=1
    fi
fi

# --- the verdict --------------------------------------------------------------
summary="$files census files, $rows rows: $match match, $mismatch mismatch, $notrec not recountable, $nonzero matched with a non-zero exit"
if [ "$fail" -eq 0 ]; then
    echo "PASS: $summary; 2 controls fired"
    exit 0
fi
echo "FAIL: $summary; see the rows and controls above"
exit 1

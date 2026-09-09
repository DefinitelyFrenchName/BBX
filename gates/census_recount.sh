#!/bin/sh
# census_recount.sh — every count in docs/census/*.md reproduces at the recorded HEAD of its repository, on a clone
# For each census file, every §A row whose count is a plain integer or a quoted string and
# whose command is one shell pipeline is re-run from the root of a PLAIN LOCAL CLONE of the
# repository at the HEAD the file was measured at (lib/py/bbx/recount.py). Rows in any other
# shape are NOT-RECOUNTABLE: counted and named in the output, never passed. The first
# self-validation gate (R9, R14): BBX's own documents read as a document set.
# READ-ONLY (R18, R20): the lineage repositories are never written. The rows run in a clone under
# TMPDIR that is removed afterwards; the lineage's own tree is read for its HEAD and porcelain
# only. A lineage whose tip moved past the recorded HEAD is a NOTE-class drift line (the rows
# re-run on a clone of the tip, the moved ids listed), never a verdict: a moved lineage is a
# fact about the lineage, a mismatch at the recorded HEAD is a fact about BBX.
# Usage: gates/census_recount.sh                (from the BBX root; ~44 s measured 2026-09-09, docs/defaults.md D2)
#   BBX_CENSUS_TIMEOUT=<seconds per command>     default 60 (docs/defaults.md D1)
#   BBX_CENSUS_DIR=<dir of census files>         default docs/census (docs/defaults.md D7); a dir whose census names an absent tree exercises SKIP
# SKIP: a repository directory a census file names is absent (exit 0; asserts nothing).
# MUST-FIRE: known-bad: wrong-head — a shadow census whose recorded HEAD is not a commit of its repository must FAIL with "HEAD unknown"
# MUST-FIRE: perturbed-copy: moved-count — a shadow census with one recountable count changed by one must FAIL on that row
# MUST-FIRE: known-bad: names-the-tree — a shadow census whose one command names the repository's absolute path must be REFUSED on that row (the one way a row could reach past the clone)
# MUST-FIRE: known-bad: drift-detected — a shadow census recorded at the parent of the repository's HEAD must print a drift NOTE with ahead=1, or "no drift" is measured by silence (BBX-7)
#
set -u
BBX_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TOOL="$BBX_ROOT/lib/py/bbx/recount.py"
[ -f "$TOOL" ] || { echo "FAIL: $TOOL is missing"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: python3 not on PATH"; exit 1; }

T=$(mktemp -d "${TMPDIR:-/tmp}/bbx_recount.XXXXXX") || { echo "FAIL: mktemp"; exit 1; }
trap 'rm -rf "$T"' EXIT

census_root() { sed -n '2p' "$1" | grep -oE '`/[^`]*`' | head -1 | tr -d '`'; }

# --- the real recount, every census file, each on a clone of its recorded HEAD -------------
CENSUS_DIR="${BBX_CENSUS_DIR:-$BBX_ROOT/docs/census}"
fail=0; files=0; rows=0; match=0; mismatch=0; refused=0; notrec=0; nonzero=0
for census in "$CENSUS_DIR"/bbh.md "$CENSUS_DIR"/vampiresaved.md "$CENSUS_DIR"/sms.md; do
    [ -f "$census" ] || { echo "FAIL: census file missing: $census"; exit 1; }
    name=$(basename "$census")
    root=$(census_root "$census")
    if [ -z "$root" ] || [ ! -d "$root" ]; then
        echo "SKIP: $name names a repository directory that is absent here: ${root:-<none>}"
        exit 0
    fi
    files=$((files + 1))
    out="$T/$name.out"
    python3 "$TOOL" "$census" > "$out" 2>&1; rc=$?
    grep -E '^row=.* verdict=(MISMATCH|TIMEOUT|REFUSED)' "$out"
    grep -E '^census=' "$out"
    grep -E '^not_recountable_ids=' "$out"
    grep -E '^NOTE: ' "$out"          # drift lines reach the runner's NOTE block at column 0
    s=$(grep -E '^census=' "$out" | tail -1)
    for k in rows match mismatch refused not_recountable nonzero_exit; do
        v=$(printf '%s\n' "$s" | tr ' ' '\n' | grep "^$k=" | cut -d= -f2)
        [ -n "$v" ] || v=0
        case $k in
            rows) rows=$((rows + v));; match) match=$((match + v));;
            mismatch) mismatch=$((mismatch + v));; refused) refused=$((refused + v));;
            not_recountable) notrec=$((notrec + v));; nonzero_exit) nonzero=$((nonzero + v));;
        esac
    done
    [ "$rc" -eq 0 ] || fail=1
done

# --- the controls: each must fail (or fire) for its stated reason ----------------------------
# a census whose counts we know match is the base for every shadow; its repository is small
base="$BBX_ROOT/docs/census/bbh.md"
base_root=$(census_root "$base")
recorded=$(sed -n '1p' "$base" | grep -oE '@ [0-9a-f]+' | cut -d' ' -f2)
fired=0

# 1. wrong-head: a recorded HEAD that is no commit of the repository
shadow_head="$T/wrong_head.md"
sed "1s/@ $recorded/@ 0000000/" "$base" > "$shadow_head"
if python3 "$TOOL" "$shadow_head" > "$T/c1.out" 2>&1; then
    echo "CONTROL DEAD: wrong-head — a shadow census at HEAD 0000000 was recounted as if that commit existed"; fail=1
elif grep -q 'HEAD unknown' "$T/c1.out"; then
    echo "CONTROL FIRED: wrong-head — $(grep -E '^census=' "$T/c1.out")"; fired=$((fired + 1))
else
    echo "CONTROL DEAD: wrong-head — failed, but not with 'HEAD unknown': $(tail -1 "$T/c1.out")"; fail=1
fi

# 2. moved-count: row A1's count changed by one
shadow_count="$T/moved_count.md"
python3 - "$base" "$shadow_count" <<'PY'
import sys
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
PY
if [ $? -ne 0 ]; then
    echo "CONTROL DEAD: moved-count — could not build the shadow (no row A1 in $base)"; fail=1
elif python3 "$TOOL" "$shadow_count" > "$T/c2.out" 2>&1; then
    echo "CONTROL DEAD: moved-count — a count moved by one was recounted as a match"; fail=1
elif grep -q '^row=A1 verdict=MISMATCH' "$T/c2.out"; then
    echo "CONTROL FIRED: moved-count — $(grep '^row=A1 ' "$T/c2.out")"; fired=$((fired + 1))
else
    echo "CONTROL DEAD: moved-count — failed, but not on row A1: $(grep -E 'MISMATCH|census=' "$T/c2.out" | head -2 | tr '\n' ' ')"; fail=1
fi

# 3. names-the-tree: row A1's command reaches for the repository's absolute path
shadow_path="$T/names_tree.md"
python3 - "$base" "$shadow_path" "$base_root" <<'PY'
import sys
src, dst, root = sys.argv[1], sys.argv[2], sys.argv[3]
done = False
out = []
for line in open(src, encoding="utf-8"):
    if not done and line.startswith("| A1 |"):
        head, sep, rest = line.partition("| A1 |")
        dim, sep2, tail = rest.partition("|")
        cnt, sep3, cmd = tail.partition("|")
        cmd = cmd.replace("`", "`cd " + root + " && ", 1)   # the command cell opens with a backtick
        line = f"| A1 |{dim}|{cnt}|{cmd}"
        done = True
    out.append(line)
open(dst, "w", encoding="utf-8").write("".join(out))
sys.exit(0 if done else 1)
PY
if [ $? -ne 0 ]; then
    echo "CONTROL DEAD: names-the-tree — could not build the shadow (no row A1 in $base)"; fail=1
elif python3 "$TOOL" "$shadow_path" > "$T/c3.out" 2>&1; then
    echo "CONTROL DEAD: names-the-tree — a command naming $base_root was run instead of refused"; fail=1
elif grep -q '^row=A1 verdict=REFUSED reason=names-the-tree' "$T/c3.out"; then
    echo "CONTROL FIRED: names-the-tree — $(grep '^row=A1 ' "$T/c3.out")"; fired=$((fired + 1))
else
    echo "CONTROL DEAD: names-the-tree — failed, but not by refusing A1: $(grep -E 'REFUSED|MISMATCH|census=' "$T/c3.out" | head -2 | tr '\n' ' ')"; fail=1
fi

# 4. drift-detected: the census recorded at the parent of the repository's HEAD
parent=$(git -C "$base_root" rev-parse --short "HEAD~1" 2>/dev/null)
shadow_drift="$T/drift.md"
if [ -z "$parent" ]; then
    echo "CONTROL DEAD: drift-detected — $base_root has no parent commit to record"; fail=1
else
    sed "1s/@ $recorded/@ $parent/" "$base" > "$shadow_drift"
    python3 "$TOOL" "$shadow_drift" > "$T/c4.out" 2>&1   # its exit is not the point: rows may differ at the parent
    if grep -qE '^NOTE: drift census=drift.md recorded='"$parent"' tip=[0-9a-f]+ ahead=1 ' "$T/c4.out"; then
        echo "CONTROL FIRED: drift-detected — $(grep '^NOTE: drift' "$T/c4.out")"; fired=$((fired + 1))
    else
        echo "CONTROL DEAD: drift-detected — a census recorded at $parent (one behind) produced no drift NOTE with ahead=1: $(grep -E '^(NOTE|census=)' "$T/c4.out" | head -2 | tr '\n' ' ')"; fail=1
    fi
fi

# --- the verdict --------------------------------------------------------------
summary="$files census files, $rows rows: $match match, $mismatch mismatch, $refused refused, $notrec not recountable, $nonzero matched with a non-zero exit"
if [ "$fail" -eq 0 ]; then
    echo "PASS: $summary; $fired controls fired"
    exit 0
fi
echo "FAIL: $summary; see the rows and controls above"
exit 1

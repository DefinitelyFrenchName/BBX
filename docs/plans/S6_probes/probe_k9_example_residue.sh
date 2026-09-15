#!/bin/sh
# bbx-31, S6 step 4 probe (K9, R65, R69): what does bbh's example battery, the population of F13b and F13c, leave on the
# host, and where? On a plain clone of bbh at a commit (R18, R20), bbh's own runner runs example/ over both tiers
# (FAKE_ROOT=., as F13c) and the portable tier alone (as F13b), each under a fresh TMPDIR. Each case counts, against a
# marker touched before it ran, the new entries in that TMPDIR and the new `tmp.*` directories in the per-user temp
# dir (`getconf DARWIN_USER_TEMP_DIR`, empty on a host that has none), those holding `fake_replay.log` apart, and the
# output lines naming the TMPDIR. The positive control makes a bare `mktemp -d` under a set TMPDIR, the fake driver's
# own form, and requires it counted in one of the two places; another process on the host can add to the per-user
# count, which is why the fake driver's file is counted apart.
# Usage: sh probe_k9_example_residue.sh <bbh-repo> <commit> <workdir>
set -u
SRC="$1"; C="$2"; W="$3"
rm -rf "$W"; mkdir -p "$W"
{ git clone -q --no-checkout "$SRC" "$W/bbh" && git -C "$W/bbh" checkout -q "$C"; } || { echo "clone failed"; exit 2; }
B="$W/bbh"
U="$(getconf DARWIN_USER_TEMP_DIR 2>/dev/null || true)"; U="${U%/}"
unset BBH_CONFIG PYTHONPATH
echo "clone head=$(git -C "$B" rev-parse --short HEAD) per-user temp dir=${U:-none}"
count() {  # count <tmpdir> <marker> — new entries in the TMPDIR; new tmp.* in the per-user dir; those holding fake_replay.log
    _in=$(find "$1" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')
    if [ -n "$U" ]; then
        _u=$(find "$U" -mindepth 1 -maxdepth 1 -type d -name 'tmp.*' -newer "$2" 2>/dev/null | wc -l | tr -d ' ')
        _uf=$(find "$U" -mindepth 2 -maxdepth 2 -name fake_replay.log -newer "$2" 2>/dev/null | wc -l | tr -d ' ')
    else
        _u=-; _uf=-
    fi
    echo "in_tmpdir=$_in per_user_new=$_u per_user_fake_replay=$_uf"
}
case_run() {  # case_run <label> <env assignment or -> <runner args...>
    _l="$1"; _e="$2"; shift 2
    _t="$W/tmp_$_l"; mkdir -p "$_t"; _m="$W/marker_$_l"; touch "$_m"; sleep 1
    if [ "$_e" = - ]; then
        (cd "$B/example" && TMPDIR="$_t" "$B/bin/bbh-run-static" "$@" > "$W/$_l.out" 2>&1); _x=$?
    else
        (cd "$B/example" && env "$_e" TMPDIR="$_t" "$B/bin/bbh-run-static" "$@" > "$W/$_l.out" 2>&1); _x=$?
    fi
    echo "case=$_l exit=$_x $(count "$_t" "$_m") path_lines=$(grep -c -F "$_t" "$W/$_l.out") tally=$(grep -E '^PASS ' "$W/$_l.out" | tr -s ' ')"
    # attribution by name and contents (G82's method): each new per-user tmp.* directory, what it holds
    [ -n "$U" ] && find "$U" -mindepth 1 -maxdepth 1 -type d -name 'tmp.*' -newer "$_m" 2>/dev/null | while IFS= read -r _d; do
        echo "  new $(basename "$_d"): $(find "$_d" -mindepth 1 -maxdepth 2 2>/dev/null | sed "s|$_d/||" | head -4 | tr '\n' ' ')($(find "$_d" -mindepth 1 2>/dev/null | wc -l | tr -d ' ') entries)"
    done
}
case_run both-tiers FAKE_ROOT=.
case_run portable - --tier portable
_c="$W/tmp_control"; mkdir -p "$_c"; _m="$W/marker_control"; touch "$_m"; sleep 1
_made="$(TMPDIR="$_c" mktemp -d)"
echo "positive control: a bare mktemp -d under TMPDIR=$_c made $_made; $(count "$_c" "$_m")"
[ -n "$U" ] && case "$_made" in "$U"/*) rmdir "$_made" && echo "  (the control's own directory removed: $_made)";; esac
echo "clone porcelain after the runs: $(git -C "$B" status --porcelain | wc -l | tr -d ' ')"

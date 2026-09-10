# compare.sh — THE ONE dispatcher of the comparison vocabulary (abstraction C2). Source from a
# runner or a gate; requires $BBX_HOME (PYTHONPATH is set from it below if the caller has not).
#
# Lifted from bbh lib/sh/masked_compare.sh at f675710 (BBX slice S2 step 2, bbx-3, 2026-09-10):
# `compare_temporal` is bbh's `masked_check` line for line — the classes exact / flicker /
# diverge / window / composite over a spec line `<class> <baseset> <args>`, plus the
# baseset-vs-mask invariant guard — and every printed verdict line is frozen text (C4; fidelity
# F16 diffs them). Lineage: VampireSaved's tests/lib/masked_compare.sh, lifted VERBATIM out of
# its suite runner's dispatch when a second caller appeared (14z-97, GitHub #96 there).
#
# WHY ONE COPY. A second copy of a comparison vocabulary does not stay a copy: it stays at
# the vocabulary of the day it was written, which is how a gate ended up asserting
# `flicker 1 3507` about a tree that had expressed that replay as a `composite` in every
# generation since.
#
# WHAT BBX ADDS (ruled R23): `compare_check` dispatches on the expectation KIND — the kind
# names the family and the view (lib/py/bbx/expectations.py, the profile's table), never the
# spec line — so `masked` reaches `compare_temporal` unchanged and a later family (set,
# schema, tolerant-numeric: S3-S4) is a new kind with its own function here. The mask default
# is the kind profile's [suite].mask_default (frame-driven: bbh's literal; kind-blind: none),
# never a literal in this file (BBX-24).
#
# Ground truth: gates/compare_dispatch.sh.

[ -n "${BBX_HOME:-}" ] && case ":${PYTHONPATH:-}:" in
    *":$BBX_HOME/lib/py:"*) ;;
    *) PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"; export PYTHONPATH ;;
esac

# compare_mask_for <expdir> — the MASK_RANGES string an expectation set runs under. PER-SET
# OVERRIDE: a set frozen under a different basis ships <set>/mask; sets without one use the
# consumer's default ([suite].mask_default, exported as BBX_MASK_DEFAULT by the runners, else
# read from the profile in force).
COMPARE_DEFAULT_MASK="${BBX_MASK_DEFAULT:-$(python3 -m bbx.expectations mask-default 2>/dev/null || echo '')}"
compare_mask_for() {
    if [ -f "$1/mask" ]; then cat "$1/mask"; else echo "$COMPARE_DEFAULT_MASK"; fi
}

# compare_check <expdir> <name> <kind> <spec> <runmask> <log>
#   The kind's family decides; prints the verdict line(s); returns 0 on PASS, 1 on FAIL.
compare_check() {
    _ck_kind="$3"
    _ck_family="$(python3 -m bbx.expectations family "$_ck_kind" 2>/dev/null || echo '-')"
    case "$_ck_family" in
    temporal) compare_temporal "$1" "$2" "$4" "$5" "$6" ;;
    *)        echo "FAIL kind '$_ck_kind' has no comparator family in the kind profile in force (R23: a kind is registered in the profile's table or not at all)"; return 1 ;;
    esac
}

# compare_temporal <expdir> <name> <spec> <runmask> <log>   (bbh: masked_check)
#   Prints the verdict line(s); returns 0 on PASS, 1 on FAIL. <spec> is the
#   contents of <expdir>/<name>.masked: `<class> <baseset> <args>`.
compare_temporal() {
    _mc_expdir="$1"; _mc_name="$2"; _mc_spec="$3"; _mc_runmask="$4"; _mc_log="$5"
    _mc_root="$(dirname "$_mc_expdir")"
    _mc_class=${_mc_spec%% *}
    _mc_rest=${_mc_spec#* }
    _mc_base=${_mc_rest%% *}
    _mc_args=${_mc_rest#* }
    _mc_baselog="$_mc_root/$_mc_base/logs/$_mc_name.log"

    # ENFORCE THE BASESET/MASK INVARIANT (lineage 14z-94, GitHub #62). The
    # RUN mask comes from the expectation set, the BASE comes from the spec,
    # and nothing compared them. Masked bytes are SKIPPED from the checksum,
    # so a basis frozen under a different mask is not comparable — the
    # numbers would simply be over different byte sets. The write side
    # (freeze_masked_basis) refuses to overwrite a basis under a different
    # mask; this is the read side.
    _mc_basemask="$_mc_root/$_mc_base/MASK"
    if [ -f "$_mc_basemask" ]; then
        if [ "$_mc_runmask" != "$(cat "$_mc_basemask")" ]; then
            echo "FAIL mask mismatch: this set runs"
            echo "        $_mc_runmask"
            echo "      but $_mc_base was frozen under"
            echo "        $(cat "$_mc_basemask")"
            echo "      Masked bytes are skipped from the checksum, so the two"
            echo "      are not comparable. Fix the spec's baseset or the set's"
            echo "      mask file — do NOT re-freeze to make this green."
            return 1
        fi
    elif [ -f "$_mc_expdir/mask" ]; then
        # A record-less basis predates the MASK record. It is only safe for
        # sets on the BUILT-IN default; a set carrying its own mask file
        # citing it is exactly the untracked pairing.
        echo "FAIL mask mismatch: $_mc_base has no MASK record (it predates them)"
        echo "      but this set overrides the default with its own mask:"
        echo "        $_mc_runmask"
        echo "      Cite a basis with a recorded mask, or regenerate one"
        echo "      with tools/freeze_masked_basis.sh."
        return 1
    fi

    case "$_mc_class" in
    exact)
        if cmp -s "$_mc_baselog" "$_mc_log"; then
            echo "PASS masked-exact"
        else
            echo "FAIL masked live-state diverged from $_mc_base"; return 1
        fi ;;
    flicker)
        _mc_v=$(python3 -m bbx.compare_flicker "$_mc_baselog" "$_mc_log") || true
        if [ "$_mc_v" = "FLICKER $_mc_args" ]; then
            echo "PASS masked-flicker ($_mc_v — frozen inventory)"
        else
            echo "FAIL masked-flicker: got '$_mc_v' expected 'FLICKER $_mc_args' (frozen; drift either way is loud — CLAUDE.md §4 standing watch)"; return 1
        fi ;;
    diverge)
        # THE SPEC FILE'S NAME IS LOAD-BEARING: check_diverge derives the
        # base log from the spec's STEM (<root>/<baseset>/logs/<stem>.log), so
        # the temp spec is named for the replay.
        _mc_tmp="$(mktemp -d)"
        printf '%s %s' "$_mc_base" "$_mc_args" > "$_mc_tmp/$_mc_name.mdiverge"
        _mc_out=$(python3 -m bbx.check_diverge "$_mc_log" \
                    "$_mc_tmp/$_mc_name.mdiverge" "$_mc_root") && _mc_rc=0 || _mc_rc=1
        rm -rf "$_mc_tmp"
        echo "$_mc_out"
        return "$_mc_rc" ;;
    window)
        # v3 "bounded re-convergent window". args: "<onset> <end>". STRICTER
        # than flicker and than the frozen first-divergence constant: one
        # contiguous run, a fixed onset, full re-convergence, end state
        # untouched. The checker also fails on a bit-IDENTICAL pair, because
        # this expectation asserts the divergence exists.
        _mc_onset=${_mc_args%% *}; _mc_end=${_mc_args##* }
        if _mc_out=$(python3 -m bbx.compare_window "$_mc_baselog" \
                    "$_mc_log" --onset "$_mc_onset" --end "$_mc_end" 2>&1); then
            echo "PASS masked-window ($(echo "$_mc_out" | head -1))"
        else
            echo "FAIL masked-window: $(echo "$_mc_out" | tr '\n' ' ')"; return 1
        fi ;;
    composite)
        # v4 class, strict conjunction of `flicker` and `window`:
        # args "<flicker-csv> <window-list>".
        _mc_fl=${_mc_args%% *}; _mc_win=${_mc_args##* }
        if _mc_out=$(python3 -m bbx.compare_composite "$_mc_baselog" \
                    "$_mc_log" --flicker "$_mc_fl" --windows "$_mc_win" 2>&1); then
            echo "PASS masked-composite ($(echo "$_mc_out" | head -1))"
        else
            echo "FAIL masked-composite: $(echo "$_mc_out" | tr '\n' ' ')"; return 1
        fi ;;
    *)
        echo "FAIL unknown .masked class '$_mc_class'"; return 1 ;;
    esac
    return 0
}

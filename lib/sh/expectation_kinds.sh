# expectation_kinds.sh — the expectation-KIND enumeration, one reader of the kinds table. Source it.
#
# Lifted from bbh lib/sh/enumerate_expectations.sh at f675710 (BBX slice S2 step 2, bbx-3,
# 2026-09-10), the output lines verbatim (fidelity F16c). WHY IT EXISTS (lineage 14z-90,
# GitHub #17 there): an audit evaluated `"$EXPECT"/*.masked` and said nothing about anything
# else in the directory. `.pending` marks a replay with NO ratified class in any expectation
# set — exactly the state the audit existed to detect — so two dropped replays put its blind
# spot precisely over the one open regression.
#
# It REPORTS, it does not INCLUDE. A `.pending` file is prose, not a `<class> <baseset>
# <args>` line, so there is nothing to compare against.
#
# WHAT BBX CHANGES (ruled R23): the kinds are not a shell `case` here but the kind profile's
# `[expectations].kinds` table (lib/py/bbx/config.py, read through lib/py/bbx/expectations.py
# under $BBX_CONFIG), so a kind is registered in one place for every kind profile, and a kind
# whose family the profile in force does not carry is UNKNOWN-KIND under it.
#
# enumerate_expectations <expect-dir> <consumer-root> [<replays-dir>]
#   prints one `<name>|<kind>|<disposition>` line per expectation whose stem is a real
#   scenario (<consumer-root>/<replays-dir>/<stem>.<ext>, the profile's [suite].scenario_ext — R32, rpl for bbh; the dir defaults to
#   $BBX_REPLAYS_DIR, then tests/replays), and returns non-zero if any is pending
#   (NOT-EVALUATED) or of an unknown kind.

[ -n "${BBX_HOME:-}" ] && case ":${PYTHONPATH:-}:" in
    *":$BBX_HOME/lib/py:"*) ;;
    *) PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"; export PYTHONPATH ;;
esac

enumerate_expectations() {
    _ee_dir="$1"; _ee_repo="$2"; _ee_rpl="${3:-${BBX_REPLAYS_DIR:-tests/replays}}"; _ee_bad=0
    _ee_table="$(python3 -m bbx.expectations kinds)" || { echo "FAIL: the kinds table could not be read (bbx.expectations kinds)"; return 3; }
    _ee_sext="$(python3 -m bbx.expectations scenario-ext)" || { echo "FAIL: the scenario extension could not be read (bbx.expectations scenario-ext)"; return 3; }
    for _ee_f in "$_ee_dir"/*; do
        [ -f "$_ee_f" ] || continue
        _ee_b="$(basename "$_ee_f")"
        _ee_stem="${_ee_b%.*}"; _ee_ext="${_ee_b##*.}"
        [ -f "$_ee_repo/$_ee_rpl/$_ee_stem.$_ee_sext" ] || continue
        _ee_disp="$(printf '%s\n' "$_ee_table" | awk -F'\t' -v e="$_ee_ext" '$1 == e { print $3; exit }')"
        case "$_ee_disp" in
            "")            echo "$_ee_stem|$_ee_ext|UNKNOWN-KIND"; _ee_bad=1 ;;
            NOT-EVALUATED) echo "$_ee_stem|$_ee_ext|NOT-EVALUATED"; _ee_bad=1 ;;
            *)             echo "$_ee_stem|$_ee_ext|$_ee_disp" ;;
        esac
    done
    return "$_ee_bad"
}

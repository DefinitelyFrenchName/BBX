# classify.sh — THE verdict classifier. One copy, sourced by every runner.
#
#   bbx_classify <exit-status> <logfile> [detail-width]
#     sets BBX_VERDICT  (PASS | SKIP | FAIL | TIMEOUT)
#     and  BBX_DETAIL   (the one line a human reads beside the verdict)
#
# Lifted from bbh lib/sh/classify.sh (S1, 2026-09-09): the same four verdicts,
# the same order of decision, the same three exceptions, the same detail
# lines — fidelity F13/F15 diff a runner built on this against bbh's. SETUP-
# FAIL (ruled R13) is NOT a fifth verdict: a gate that prints `SETUP-FAIL:`
# and exits non-zero is FAIL here, and the readout reports the sub-outcome.
#
# EXIT STATUS DECIDES FIRST. A gate that prints `SKIP:` AND exits non-zero is
# a FAILURE, not a skip: it ran, could not complete, and said so. The case is
# not hypothetical — VampireSaved's first sweep had a gate print "SKIPPED: set
# FBNEO_REF" and exit 2 with "PARTIAL: the invariant was NOT run", and an
# exit-status-second classifier called it a skip: the ONE gate that justified
# modifying an emulator at all read as benign. SKIP is only ever exit 0 plus
# the marker.
#
# THE THREE EXCEPTIONS, each written for a false green that was paid for:
#   1. exit 124 / 137 (the timeout wrapper's) -> TIMEOUT, not FAIL, so a killed
#      gate is never read as a defect in the artifact.
#   2. exit 0 with the shell's OWN `<script>.sh: line N: NAME: message` in the
#      log -> FAIL. macOS bash 3.2 returns 0 for a `${VAR:?}` abort once an
#      EXIT trap is armed; a 65-minute gate was recorded `PASS 0s` on four
#      lines of log. The benign look-alike — an emulator segfaulting at
#      teardown AFTER the summary line, `line N:  <pid> Segmentation fault` —
#      has digits where the NAME would be and does not match.
#   3. exit 0 with `^ *SKIP` -> SKIP; the word SKIP in PROSE is not a marker.
#
# Every regex and the exit list come from the consumer's [classify] section
# through the BBX_CLASSIFY_* variables the runner exports; the defaults here
# are the literals the lineage carried (docs/defaults.md D11).

bbx_classify() {
    _st="$1"; _log="$2"; _w="${3:-90}"
    _skip_re="${BBX_CLASSIFY_SKIP_RE:-^ *SKIP}"
    _err_re="${BBX_CLASSIFY_SHELL_ERROR_RE:-\\.sh: line [0-9]+: [A-Za-z_][A-Za-z0-9_]*: }"
    for _x in ${BBX_CLASSIFY_TIMEOUT_EXITS:-124 137}; do
        if [ "$_st" = "$_x" ]; then
            BBX_VERDICT=TIMEOUT; BBX_DETAIL="killed (exit $_st)"; return 0
        fi
    done
    if [ "$_st" != 0 ]; then
        BBX_VERDICT=FAIL
        BBX_DETAIL="exit $_st: $(grep -aE '^ *(SKIP|PARTIAL)|FAIL|ERROR|Traceback|not found' "$_log" | tail -1 | cut -c1-"$_w")"
        return 0
    fi
    if grep -qaE "$_err_re" "$_log"; then
        BBX_VERDICT=FAIL
        BBX_DETAIL="exit 0 after a shell error: $(grep -aE "$_err_re" "$_log" | head -1 | cut -c1-"$_w")"
        return 0
    fi
    if grep -qaE "$_skip_re" "$_log"; then
        BBX_VERDICT=SKIP
        BBX_DETAIL="$(grep -aE "$_skip_re" "$_log" | head -1 | cut -c1-"$_w")"
        return 0
    fi
    BBX_VERDICT=PASS; BBX_DETAIL=""
    return 0
}

# bbx_classify_env <config> — export the [classify] section for bbx_classify.
# Needs config.sh sourced (bbx_cfg).
bbx_classify_env() {
    BBX_CLASSIFY_SKIP_RE="$(bbx_cfg classify.skip_regex)"
    BBX_CLASSIFY_SHELL_ERROR_RE="$(bbx_cfg classify.shell_error_regex)"
    BBX_CLASSIFY_TIMEOUT_EXITS="$(bbx_cfg classify.timeout_exits | tr '\n' ' ')"
    BBX_CLASSIFY_FAIL_TAIL="$(bbx_cfg classify.fail_tail)"
    export BBX_CLASSIFY_SKIP_RE BBX_CLASSIFY_SHELL_ERROR_RE BBX_CLASSIFY_TIMEOUT_EXITS BBX_CLASSIFY_FAIL_TAIL
}

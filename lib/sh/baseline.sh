# baseline.sh — THE ONE DEFINITION of the bbh commit BBX measures itself against.
#
#   bbx_baseline            echoes the baseline commit: $BBX_BBH_BASELINE when set,
#                           the value below otherwise
#
# Ruled R43 (2026-09-12) after gotcha G32: three gates read `BBX_BBH_BASELINE`
# and the R28 re-baseline of 2026-09-10 moved TWO of them and the register row.
# `gates/suite.sh` kept cloning `f675710` for six sittings while its own header
# said it cloned the baseline — found by reading the rulings queue, not by a
# gate. One value, one place, every reader named in `docs/defaults.md` D20.
#
# WHY A SOURCED SHELL FILE AND NOT A CONFIG KEY. The alternative R43 offered was
# a `[fidelity]` key in the kind-blind config layer, declined at bbx-20. The
# baseline is a fact about BBX's relationship to the lineage, not a consumer
# value, and `lib/sh/` is where BBX's own shared shell already lives. (The other
# reason recorded then — that fidelity pair F13e, which diffs the two `config
# dump`s of bbh's example, would stop being empty once a kind-blind section
# existed — was never measured, and is false: a dump prints the consumer's file,
# never the defaults, and F13e stayed identical when S5 added `[skills]` at
# bbx-26, G68.)
#
# Changing the value is the R28 PROCEDURE, not a ruling (ruled at bbx-5): a
# dated line in `docs/rebaselines.md`, this file, D20 by its own definition, and
# the census `docs/census/bbh.md` re-measured on the new tip.
BBX_BBH_BASELINE_DEFAULT=10a82d2

bbx_baseline() {
    printf '%s\n' "${BBX_BBH_BASELINE:-$BBX_BBH_BASELINE_DEFAULT}"
}

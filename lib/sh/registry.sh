# registry.sh — reading the gate registries. Lifted from bbh lib/sh/registry.sh.
#
#   bbx_read_reg <file>     the non-comment, non-blank entries of a plain
#                           registry (one gate name per line, `#` comments);
#                           a missing file reads as empty
#   bbx_count <text>        the number of non-blank lines in <text>
#
# The plain registries (portable / static) are one name per line. The sweep
# registry is a TSV and is read by the sweep runner's own reader.

bbx_read_reg() {
    [ -f "$1" ] || return 0
    sed 's/#.*//' "$1" | awk 'NF'
}

bbx_count() {
    printf '%s\n' "$1" | awk 'NF' | wc -l | tr -d ' '
}

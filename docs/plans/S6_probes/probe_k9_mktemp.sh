#!/bin/sh
# bbx-31, S6 step 4 probe (K9, R69): where does `mktemp` put a directory when TMPDIR names another place, and does a
# shim first on PATH that adds `-p "$TMPDIR"` move it there? Four call forms, each in /bin/sh with TMPDIR exported to a
# fresh directory under <workdir>: `mktemp -d` (bbh's fake driver's form), `mktemp -d -t foo`, a bare `mktemp`, and an
# explicit template path; then the same four with the shim first on PATH. Prints each path made, the count left in the
# TMPDIR, and the host's mktemp and OS. Every directory or file the unshimmed forms make outside <workdir> is removed by
# its exact path after it is printed.
# Usage: sh probe_k9_mktemp.sh <workdir>
set -u
W="$1"
rm -rf "$W"; mkdir -p "$W/plain" "$W/shimmed" "$W/shim"
echo "mktemp=$(command -v mktemp) os=$(uname -sr)$(command -v sw_vers >/dev/null 2>&1 && printf ' macOS %s' "$(sw_vers -productVersion)")"
printf '#!/bin/sh\n# probe shim: add -p "$TMPDIR" unless -p or a template path is given\nfor a in "$@"; do case "$a" in -p|--tmpdir*|*/*) exec /usr/bin/mktemp "$@";; esac; done\n[ -n "${TMPDIR:-}" ] && exec /usr/bin/mktemp -p "$TMPDIR" "$@"\nexec /usr/bin/mktemp "$@"\n' > "$W/shim/mktemp"
chmod +x "$W/shim/mktemp"
forms() {  # forms <tmpdir> [shim dir]
    /bin/sh -c 'TMPDIR="$1"; export TMPDIR; [ -n "$2" ] && PATH="$2:$PATH" && export PATH
        printf "  -d          %s\n" "$(mktemp -d)"; printf "  -d -t foo   %s\n" "$(mktemp -d -t foo)"
        printf "  bare        %s\n" "$(mktemp)";    printf "  template    %s\n" "$(mktemp "$1/explicit.XXXXXX")"' _ "$1" "${2:-}"
}
echo "without the shim, TMPDIR=$W/plain:"
forms "$W/plain" > "$W/plain.txt"; cat "$W/plain.txt"
echo "  left in TMPDIR: $(find "$W/plain" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ') of 4"
echo "with the shim first on PATH, TMPDIR=$W/shimmed:"
forms "$W/shimmed" "$W/shim" > "$W/shimmed.txt"; cat "$W/shimmed.txt"
echo "  left in TMPDIR: $(find "$W/shimmed" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ') of 4"
awk '{print $NF}' "$W/plain.txt" | while IFS= read -r p; do
    case "$p" in "$W"/*) ;; *) { [ -d "$p" ] && rmdir "$p"; } || { [ -f "$p" ] && rm -f "$p"; }; echo "  removed the probe's own $p";; esac
done

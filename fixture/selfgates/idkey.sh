#!/bin/sh
# idkey.sh — THE SELF SUBJECT'S IDENTITY (ruling R38; docs/plans/S4.md §3 "S2"): the tree hash of the
# harness's own directories at HEAD, hashed into one key. `program` covers bin, lib and drivers — what the
# scenarios drive; `wholeset` adds gates, so the key moves whenever any part of the harness moves and the
# expectation set must be re-reviewed before it is re-frozen (never automatically, R38, §3.4).
#
# Since R46 this file is a SHIM: the ONE definition of the key is `python3 -m bbx.fingerprint
# --harness-identity` (lib/py/bbx/fingerprint.py harness_identity), which bbx.file_census keys the census by
# too. gates/file_census_tool.sh §9 still proves the two readers agree on BBX's own tree.
#
# It reads the HARNESS's git tree through $BBX_HOME, never the current directory: a consumer copied under
# TMPDIR by a gate's control is not a git repository, and the identity of BBX must not depend on where a
# copy of the fixture happens to sit (measured at bbx-18: `fatal: not a git repository` from the copy, one
# key from anywhere through BBX_HOME).
#
# The key is of the COMMIT, so an UNCOMMITTED edit to bin, lib or drivers does not move it — the kept run's
# `porcelain` line is what sees that, and gates/adapters.sh declares it.
set -eu
case "${1:-}" in
    program|wholeset) ;;
    *) echo "usage: idkey.sh program|wholeset" >&2; exit 2 ;;
esac
[ -n "${BBX_HOME:-}" ] || { echo "idkey.sh: BBX_HOME is unset — the identity is the HARNESS's tree, not the caller's directory (R38)" >&2; exit 2; }
PYTHONPATH="$BBX_HOME/lib/py" exec python3 -m bbx.fingerprint --harness-identity "$1" --root "$BBX_HOME"

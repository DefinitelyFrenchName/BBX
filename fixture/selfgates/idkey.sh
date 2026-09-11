#!/bin/sh
# idkey.sh — THE SELF SUBJECT'S IDENTITY (ruling R38; docs/plans/S4.md §3 "S2"): the tree hash of the
# harness's own directories at HEAD, hashed into one key. `program` covers bin, lib and drivers — what the
# scenarios drive; `wholeset` adds gates, so the key moves whenever any part of the harness moves and the
# expectation set must be re-reviewed before it is re-frozen (never automatically, R38, §3.4).
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
    program)  trees="HEAD:bin HEAD:lib HEAD:drivers" ;;
    wholeset) trees="HEAD:bin HEAD:lib HEAD:drivers HEAD:gates" ;;
    *) echo "usage: idkey.sh program|wholeset" >&2; exit 2 ;;
esac
[ -n "${BBX_HOME:-}" ] || { echo "idkey.sh: BBX_HOME is unset — the identity is the HARNESS's tree, not the caller's directory (R38)" >&2; exit 2; }
# shellcheck disable=SC2086  # $trees is a deliberate word list
git -C "$BBX_HOME" rev-parse $trees | python3 -c 'import hashlib,sys;print(hashlib.sha1(sys.stdin.read().encode()).hexdigest())'

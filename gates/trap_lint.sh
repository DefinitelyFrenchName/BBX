#!/bin/sh
# trap_lint.sh — no BBX shell file carries a ${VAR:?} demand after its EXIT trap, and the lint lifted from bbh fails where it must: a demand after the trap, a missing directory, a shell file with no .sh name
# Ruled R63 (S6 step 3, K8). `bbx demand-after-trap` (lib/py/bbx/demand_after_trap.py, lifted from bbh at 10a82d2,
# D83) removes the cause of G18: a parameter abort under an armed EXIT trap exits 0 on this host's /bin/sh. The
# positive is BBX's own shell — gates/, drivers/, lib/sh/ and bin/, whose runners carry no .sh name (the second
# delta). The controls are bbh's own selftest cases (selftest/test_demand_after_trap.sh at 10a82d2) written under
# TMPDIR, and one per delta. Every planted $ and < is written as an octal escape, so this gate's own text, which the
# lint reads in gates/, carries no demand and no heredoc (G89). F19b diffs the lint's text against bbh's.
# Usage: gates/trap_lint.sh        Portable, ~1 s (1 s on its first run, bbx-30).
# MUST-FIRE: known-bad: demand-reported — a synthetic script with a demand after its EXIT trap must be reported as its file:line, exit 1, and nothing else, or the lint cannot fail (bbh's case a)
# MUST-FIRE: known-bad: missing-dir-refused — a gates dir that does not exist, and a --lib subdir named and absent, must each exit 2 naming the directory, where bbh's lint exits 0 with no output (R63's first delta, BBX-8)
# MUST-FIRE: known-bad: shebang-read — a demand after the trap in a file with no .sh name whose first line is #!/bin/sh must be reported, and the same text under a first line that is no shebang must not be read (R63's second delta)
# NOT-ASSERTED: a trap armed on an indented line or by the signal 0, and a demand or a trap reached through a sourced file: each file is read on its own and the first unindented `trap … EXIT` line arms it; the indented ones are counted on the NOTE line
# NOT-ASSERTED: that a demand before the trap exits non-zero on every shell: this host's sh is measured on the NOTE line, and other hosts are the platform rows' (R21)
# NOT-ASSERTED: the lint's text against bbh's over the same inputs: gates/fidelity_bbh_s6.sh diffs it (F19b)
# NOT-ASSERTED: that the lint is generic: its consumers are BBX's own shell files and, through F19b, bbh's example — one tree and its lineage (R50)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
lint() { python3 -m bbx.demand_after_trap "$@" > "$T/out" 2> "$T/err" && s=0 || s=$?; }
lines() { wc -l < "$T/out" | tr -d ' '; }
after_trap() {  # after_trap <file> — bbh's case a, byte for byte
    printf '#!/bin/sh\nset -eu\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\n: "\044{FOO:?set FOO}"\n' > "$1"
}
before_trap() {  # before_trap <file> — bbh's case b: a demand before the trap, and one inside a heredoc
    printf '#!/bin/sh\nset -eu\n: "\044{FOO:?set FOO}"\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\ncat \074\074EOS\nstub \044{BAR:?} in a heredoc is fine\nEOS\n' > "$1"
}

echo "== 1. BBX's own shell: gates/, drivers/, lib/sh/ and bin/ =="
for d in gates drivers lib/sh bin; do
    lint "$BBX_HOME/$d"
    if [ "$s" = 0 ] && [ ! -s "$T/out" ]; then ok "$d: exit 0, no demand after a trap"
    else fail "$d: exit $s; $(tr '\n' '|' < "$T/out")$(tr '\n' '|' < "$T/err")"; fi
done
if _n="$(python3 - "$BBX_HOME" gates drivers lib/sh bin 2>&1 <<'EOF'
import pathlib
import re
import sys
from bbx.demand_after_trap import shell_files
root = pathlib.Path(sys.argv[1])
counts, indented = [], 0
for d in sys.argv[2:]:
    files = shell_files(root / d)
    counts.append("%s=%d" % (d.replace("/", "_"), len(files)))
    for f in files:
        indented += sum(1 for line in f.read_text(encoding="utf-8", errors="replace").splitlines()
                        if re.match(r"^\s+trap\b.*\bEXIT\b", line))
print("files " + " ".join(counts) + " indented_exit_traps=%d" % indented)
EOF
)"; then echo "NOTE: trap-lint $_n"
else fail "the file count could not be read: $_n"; fi

echo "== 2. bbh's cases, on synthetic scripts under TMPDIR =="
mkdir -p "$T/a/lib" "$T/b/lib" "$T/c/lib" "$T/d" "$T/e"
after_trap "$T/a/g.sh"; before_trap "$T/b/g.sh"; before_trap "$T/c/g.sh"; after_trap "$T/c/lib/l.sh"; before_trap "$T/e/g.sh"
# CONTROL demand-reported
lint "$T/a"
if [ "$s" = 1 ] && [ "$(lines)" = 1 ] && grep -q '^g\.sh:4: : "\$.FOO:?set FOO}"$' "$T/out"; then echo "CONTROL FIRED: demand-reported — exit 1, $(cat "$T/out")"
else echo "CONTROL DEAD: demand-reported — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a demand after the trap was not reported"; fi
lint "$T/b"
if [ "$s" = 0 ] && [ ! -s "$T/out" ]; then ok "a demand BEFORE the trap, and one inside a heredoc, are allowed: exit 0, no output"
else fail "the allowed shapes were reported: exit $s; $(tr '\n' '|' < "$T/out")"; fi
lint "$T/c"
if [ "$s" = 1 ] && [ "$(lines)" = 1 ] && grep -q '^lib/l\.sh:4: ' "$T/out"; then ok "the lib subdir is scanned: lib/l.sh:4 reported, and nothing else"
else fail "the lib subdir: exit $s; $(tr '\n' '|' < "$T/out")"; fi
lint "$T/c" --skip l.sh
if [ "$s" = 0 ] && [ ! -s "$T/out" ]; then ok "--skip exempts a named file: exit 0"
else fail "--skip was ignored: exit $s; $(tr '\n' '|' < "$T/out")"; fi

echo "== 3. R63's two deltas =="
# CONTROL missing-dir-refused
lint "$T/nope"; s1=$s; o1="$(cat "$T/out")"; e1="$(cat "$T/err")"
lint "$T/b" --lib nolib; s2=$s; e2="$(cat "$T/err")"
if [ "$s1" = 2 ] && [ -z "$o1" ] && printf '%s\n' "$e1" | grep -q -F "$T/nope is not a directory" \
   && [ "$s2" = 2 ] && printf '%s\n' "$e2" | grep -q -F "$T/b/nolib is not a directory"; then
    echo "CONTROL FIRED: missing-dir-refused — exit 2 for a missing gates dir and for a named --lib that is absent, each named"
else echo "CONTROL DEAD: missing-dir-refused — exits $s1 and $s2; $e1 | $e2"; fail "a missing directory was not refused"; fi
lint "$T/e"
if [ "$s" = 0 ] && [ ! -s "$T/out" ] && [ ! -s "$T/err" ]; then ok "the default lib subdir may be absent: a gates dir with no lib/ exits 0, as bbh's does"
else fail "a gates dir with no lib/: exit $s; $(tr '\n' '|' < "$T/err")"; fi
# CONTROL shebang-read
after_trap "$T/d/runner"
printf 'not a shebang\nset -eu\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\n: "\044{FOO:?set FOO}"\n' > "$T/d/notes.txt"
lint "$T/d"
if [ "$s" = 1 ] && [ "$(lines)" = 1 ] && grep -q '^runner:4: ' "$T/out"; then echo "CONTROL FIRED: shebang-read — exit 1, runner:4 reported from a file with no .sh name, and notes.txt, the same text under a first line that is no shebang, not read"
else echo "CONTROL DEAD: shebang-read — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a shell file with no .sh name was not read, or a file with no shebang was"; fi

echo "== 4. the measurement the rule rests on (this host's sh) =="
printf '#!/bin/sh\nset -eu\nW=\044(mktemp -d); trap '"'"'rm -rf "\044W"'"'"' EXIT\n: "\044{BBX_TRAP_LINT_UNSET:?set it}"\necho unreachable\n' > "$T/m.sh"
unset BBX_TRAP_LINT_UNSET 2>/dev/null || true
sh "$T/m.sh" > "$T/m.out" 2>&1 && st=0 || st=$?
echo "NOTE: trap-lint sh-exit-demand-after-trap=$st"
if grep -q unreachable "$T/m.out"; then fail "the demand did not stop the script: $(tr '\n' '|' < "$T/m.out")"
else ok "the demand stopped the script before its next line (exit $st on this host's sh)"; fi

echo
[ "$rc" = 0 ] && echo "PASS: BBX's shell carries no demand after an EXIT trap, and the lifted lint reports one, refuses a missing directory and reads a shell file with no .sh name" || { echo "FAIL: see above"; exit 1; }

#!/bin/sh
# census_register.sh — every tracked harness file has a frozen census row and every row names a file that exists, checked on EVERY battery
# Ruled R47 (2026-09-12). The file census itself is release-scoped (D63) because it runs BBX's
# whole battery inside a shadow, about twenty minutes — so between releases nothing watched it.
# Measured at bbx-20: `expected/file_census.toml` and `docs/census/bbx_files.md` are read by
# `gates/file_census.sh` and `lib/py/bbx/file_census.py` and by NOTHING else in the battery, so a
# harness file added and brought under no gate read green until the next release run. This gate
# closes that window for about a second, with no shadow, no gate run and no trace.
# WHAT IT CANNOT DO, and says so below: prove a file is REACHED. Only a run with traces can, and
# that is `gates/file_census.sh`'s job. What this holds is the REGISTER's completeness both ways
# (BBX-9), which is what catches the likeliest rot — a file nobody brought under a gate.
# The staleness of the census is a NOTE and never a failure, the split ruled by the maintainer on
# R18's own precedent: the register ROTTING and the harness MOVING are different findings, and
# making the second fatal would red the battery on every kernel commit until a twenty-minute run.
# Usage: gates/census_register.sh        Portable, ~1 s.
# PORTABILITY: the read-only proof hashes with `python3 -m bbx.sha1` (D27's portable hash
# command), never with `shasum`. Its first draft called `shasum` directly and UNGUARDED, so on a
# host without perl's Digest::SHA the assignment would have failed under `set -e` and this gate
# would have CRASHED rather than skipped — found at bbx-20 while writing R21's procedure, before
# the platform run rather than by it (gates/cli_driver.sh, which needs a SECOND SHA-1
# implementation on purpose, guards its own `shasum` use with a SKIP).
# SKIP: BBX_FILE_CENSUS_SHADOW is set — this gate's question is UNANSWERABLE inside an
#       instrumented census shadow, not merely stale. The instrument writes
#       lib/py/sitecustomize.py and commits it, so the shadow's universe permanently holds a
#       harness file the TREE's register can never contain; and the register in a shadow is a
#       copy of the one the running census is about to rewrite. Asserting completeness there
#       made the census refuse its own run and left the register completable only by a run
#       that could not complete (G46). The tree's own battery is where this is asserted.
# MUST-FIRE: perturbed-copy: file-without-row — a COPY of the register with one row removed must FAIL naming that file, or the new-file case this gate exists for is not actually checked
# MUST-FIRE: perturbed-copy: row-without-file — a COPY carrying a row for a file the universe does not hold must FAIL naming it as a dead row, or BBX-9's second direction is unenforced here too
# MUST-FIRE: perturbed-copy: stale-is-a-note — a COPY whose recorded identity is not the tree's must PRINT the drift NOTE and still exit 0: the note must not be silent, and it must not be fatal
# NOT-ASSERTED: that any file is REACHED by any gate. This gate reads two file lists and one identity; `gates/file_census.sh` is the measurement and runs at the release scope (D63, R47)
# NOT-ASSERTED: the KINDS in the register. A row's `kinds` value is not read here at all — a row claiming the wrong kinds passes this gate and fails the release run (shrink-only, D62)
# NOT-ASSERTED: the census DOCUMENT. Only the register is read; `docs/census/bbx_files.md` is checked by the release gate against a run's own text
# NOT-ASSERTED: that the universe and the identity answer the same question. The universe is `git ls-files` and so includes a STAGED file, while the identity is of the COMMIT — a file staged and not committed is in one and not the other, which is the honest reading of both
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
cd "$BBX_HOME"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
[ -z "${BBX_FILE_CENSUS_SHADOW:-}" ] || {
    echo "SKIP: BBX_FILE_CENSUS_SHADOW is set — inside an instrumented census shadow the"
    echo "      universe holds lib/py/sitecustomize.py, which the tree's register can never"
    echo "      contain, and the register itself is the copy this run is about to rewrite."
    echo "      The question is unanswerable here; the tree's battery is where it is asked (G46)."
    exit 0
}
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
REG="expected/file_census.toml"
BEFORE="$(python3 -m bbx.sha1 "$REG" | cut -d" " -f1)"   # section 5 compares against this, never against git
CR() { python3 -m bbx.file_census --self --frozen "$1" --check-register; }

echo "== 1. the tracked register is complete both ways against the universe =="
if CR "$REG" > "$T/1.log" 2>&1; then
    ok "$(grep '^  register' "$T/1.log" | sed 's/^  *//')"
else
    fail "the register is not complete — see the lines below"
    grep '^FAIL' "$T/1.log" | head -6 | sed 's/^/        /'
fi
grep '^NOTE: census-drift' "$T/1.log" && echo "  note  the census is STALE — a note, never a failure (R47)" || true

echo "== 2. MUST-FIRE: a COPY of the register with one row removed =="
victim="$(awk -F'"' '/^file = /{print $2; exit}' "$REG")"
[ -n "$victim" ] || fail "could not read a file row out of the register"
awk -v v="$victim" '
    /^\[f[0-9]+\]$/ { buf=$0"\n"; inrow=1; drop=0; next }
    inrow && /^file = / { buf=buf$0"\n"; if ($0 ~ "\"" v "\"") drop=1; next }
    inrow && /^kinds = / { buf=buf$0"\n"; next }
    inrow && /^$/ { if (!drop) printf "%s\n", buf; inrow=0; buf=""; next }
    !inrow { print }
    END { if (inrow && !drop) printf "%s", buf }
' "$REG" > "$T/no_row.toml"
before=$(grep -c '^\[f' "$REG"); after=$(grep -c '^\[f' "$T/no_row.toml")
[ "$after" = "$((before - 1))" ] || fail "CONTROL DEAD: file-without-row — the perturbation removed $((before - after)) rows, expected 1"
if CR "$T/no_row.toml" > "$T/2.log" 2>&1; then
    echo "CONTROL DEAD: file-without-row — a register missing a row for \`$victim\` passed"
    fail "the new-file case is not checked"
else
    if grep -q "^FAIL register: \`$victim\` is a tracked harness file with NO frozen census row" "$T/2.log"; then
        echo "CONTROL FIRED: file-without-row — \`$victim\` named, $(grep '^  register' "$T/2.log" | sed 's/^  *//')"
        ok "a tracked harness file with no frozen row FAILs, naming the file"
    else
        echo "CONTROL DEAD: file-without-row — non-zero, but not the named line"
        fail "$(grep '^FAIL' "$T/2.log" | head -1)"
    fi
fi

echo "== 3. MUST-FIRE: a COPY carrying a row for a file the universe does not hold =="
ghost="lib/sh/zz_does_not_exist.sh"
cp "$REG" "$T/dead_row.toml"
printf '\n[fghost]\nfile = "%s"\nkinds = "K"\n' "$ghost" >> "$T/dead_row.toml"
grep -q "$ghost" "$T/dead_row.toml" || fail "CONTROL DEAD: row-without-file — the perturbation did not apply"
if CR "$T/dead_row.toml" > "$T/3.log" 2>&1; then
    echo "CONTROL DEAD: row-without-file — a row naming a nonexistent file passed"
    fail "BBX-9's dead-row direction is unenforced here"
else
    if grep -q "^FAIL register: \`$ghost\` has a frozen census row and is not in the universe (a dead row, BBX-9)" "$T/3.log"; then
        echo "CONTROL FIRED: row-without-file — \`$ghost\` named as a dead row"
        ok "a frozen row naming a file the universe does not hold FAILs"
    else
        echo "CONTROL DEAD: row-without-file — non-zero, but not the named line"
        fail "$(grep '^FAIL' "$T/3.log" | head -1)"
    fi
fi

echo "== 4. MUST-FIRE: a COPY whose recorded identity is not the tree's =="
# The copy is made COMPLETE first, then staled. A control must fire for its OWN stated
# reason: on its first run this one read DEAD because the copy inherited the tracked
# register's missing row, so the exit was the completeness failure and not the staleness
# (the G20 family — a control that runs through the real path inherits the real refusals).
python3 - "$REG" "$T/stale.toml" <<'PYEOF'
import os, subprocess, sys
reg, dst = sys.argv[1], sys.argv[2]
rows = {l.split('"')[1] for l in open(reg) if l.startswith("file = ")}
univ = [p for p in subprocess.run(["git", "ls-files", "lib", "bin", "drivers"],
        capture_output=True, text=True).stdout.split() if not p.endswith(".md")]
text = open(reg).read().replace(
    [l for l in open(reg) if l.startswith("measured_at = ")][0],
    'measured_at = "0000000000000000000000000000000000000000"\n')
missing = [f for f in univ if f not in rows]
for i, f in enumerate(missing, start=9000):
    text += f'\n[f{i}]\nfile = "{f}"\nkinds = "K"\n'
open(dst, "w").write(text)
print(f"  built a COMPLETE copy ({len(rows)} rows + {len(missing)} added) and staled its identity")
PYEOF
grep -q '^measured_at = "0000' "$T/stale.toml" || fail "CONTROL DEAD: stale-is-a-note — the perturbation did not apply"
if CR "$T/stale.toml" > "$T/4.log" 2>&1; then
    if grep -q '^NOTE: census-drift register=000000000000 tree=' "$T/4.log"; then
        echo "CONTROL FIRED: stale-is-a-note — $(grep '^NOTE: census-drift' "$T/4.log" | cut -c7-60)… printed, and the run still exited 0"
        ok "a stale census is LOUD and not fatal (R47, R18's split)"
    else
        echo "CONTROL DEAD: stale-is-a-note — exit 0 and no drift NOTE: the staleness is SILENT"
        fail "the note does not fire"
    fi
else
    echo "CONTROL DEAD: stale-is-a-note — a stale identity was FATAL, which R47 ruled it must not be"
    fail "the staleness halts the battery"
fi

echo "== 5. the register is untouched BY THIS GATE ([BBH-59]) =="
# Against ITS OWN hash, taken before section 1 — not against git. The first draft read
# `git status --porcelain`, which also fires when the register is legitimately uncommitted
# (the normal state straight after a census run, which is exactly when this gate runs), so
# it reported "the tracked register was written" about a change the census had made and
# this gate had not. A control must fire for its own reason (the G20 family).
after="$(python3 -m bbx.sha1 "$REG" | cut -d" " -f1)"
[ "$after" = "$BEFORE" ] && ok "the tracked register is byte-identical to before this gate ran (sha1 $BEFORE); every perturbation was a copy under TMPDIR" \
  || fail "THIS GATE wrote the tracked register: sha1 $BEFORE -> $after"

printf '\nNOTE: census-register-files %s\n' "$(git ls-files lib bin drivers | grep -vc '\.md$')"
printf 'NOTE: census-register-rows %s\n' "$(grep -c '^\[f' "$REG")"
echo
[ "$rc" = 0 ] && echo "PASS: the census register is complete both ways against the universe, and a stale census says so without halting the run" \
  || { echo "FAIL: see above"; exit 1; }

#!/bin/sh
# file_census_tool.sh — the file-census INSTRUMENT measures what a gate executes, refuses a contaminated run, and fails on every frozen row that moved
# Ground truth for lib/py/bbx/file_census.py (R39, S4 step 6). The subject is a SYNTHETIC
# harness tree built here: four stub gates, one executed program, one driver, one sourced lib,
# two python modules. The heavy gate (gates/file_census.sh, the gates/sweep.tsv row) points the
# same instrument at BBX's own tree and takes minutes; this one takes seconds, so the instrument
# is under test on every battery while the census itself is release-scoped (D63).
# Why a synthetic subject: the instrument's claim is "a file's category is the set of kinds of
# the gates that EXECUTED it", and a tree whose traces are known by construction is the only
# place that claim can be checked both ways ([BBH-21]'s known-bad shape).
# Usage: gates/file_census_tool.sh        Portable, ~13 s measured on this host (12 instrument runs).
# MUST-FIRE: known-bad: header-insertion — the trace line inserted right after the SHEBANG (gotcha G25) must END the driver's header under R30, so the stub that reads the driver's NOT-ASSERTED line FAILs and the instrument REFUSES the whole run; with the insertion after the header the same stub PASSes
# MUST-FIRE: perturbed-copy: edited-census-row — one count edited in the generated block of the census document must make `--check` non-zero and NAME the line, the document's text and the run's
# MUST-FIRE: perturbed-copy: shrunk-kind-set — a frozen kind-set claiming a kind the run did not measure must FAIL naming the file and the direction, or shrink-only asserts nothing
# MUST-FIRE: known-bad: orphan-file — a harness file no gate executes must FAIL, and a FRESH freeze must not be able to hide it (rot class 1)
# MUST-FIRE: known-bad: static-need-is-what-decides — the static-registry gate that names the lineage variable must read F, and the SAME gate moved to the portable registry must read K, or the frame-driven rule is not what decides
# NOT-ASSERTED: that the census of BBX's OWN tree is correct: every trace here is the synthetic tree's (fixture class). gates/file_census.sh is the measurement; this gate is the instrument's ground truth
# NOT-ASSERTED: the SEED derivation on a real kinds table: this tree has no lib/sh/compare.sh and no kind-bearing consumer config, so F/D/C seeds are EMPTY here and only the static-need rule is exercised. The seeds are measured by gates/file_census.sh
# NOT-ASSERTED: that a gate PASSing in the shadow executed everything it executes in the tree: an uninstrumented path (a python module imported but never loaded, a file read and not sourced) is invisible by construction
# NOT-ASSERTED: any platform but this host's (R21)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
FC="python3 -m bbx.file_census"
P="$T/p"

# ---------------------------------------------------------------- the synthetic tree
mkdir -p "$P/bin" "$P/lib/sh" "$P/lib/py/bbx" "$P/drivers" "$P/gates"
cat > "$P/bbx.toml" <<'EOF'
[project]
root = "."
kind = "self"
gates_dir = "gates"
gate_glob = "*.sh"
lib_dir = "lib/sh"
[registries]
portable = "gates/portable.txt"
static = "gates/static.txt"
static_needs_env = "SYNTH_LINEAGE"
[tier]
patterns = []
source_regex = '^\s*\.\s+"?\$(?:BBX_HOME|\{BBX_HOME\})"?/(lib/sh/[a-z0-9_]+\.sh)'
source_depth = 2
EOF
printf '#!/bin/sh\n# helper.sh — a SOURCED lib: its probe goes at the end\nhelp_me() { echo helped; }\n' > "$P/lib/sh/helper.sh"
printf '#!/bin/sh\n# synthbin — an EXECUTED program\n#\necho synthbin ran\n' > "$P/bin/synthbin"
cat > "$P/drivers/adrv.sh" <<'EOF'
#!/bin/sh
# adrv.sh — a driver whose HEADER is what g3 reads (G25's shape)
# NOT-ASSERTED: anything at all; this is a stub driver
#
echo adrv ran
EOF
: > "$P/lib/py/bbx/__init__.py"
printf 'print("amod ran")\n' > "$P/lib/py/bbx/amod.py"
cat > "$P/gates/g1.sh" <<'EOF'
#!/bin/sh
# g1.sh — executes the program and the python module
# NOT-ASSERTED: anything at all; this is a stub
#
set -eu
"$(cd "$(dirname "$0")/.." && pwd)/bin/synthbin"
python3 -m bbx.amod
echo "PASS: g1"
EOF
cat > "$P/gates/g2.sh" <<'EOF'
#!/bin/sh
# g2.sh — sources the lib and runs the driver
# NOT-ASSERTED: anything at all; this is a stub
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"
. "$BBX_HOME/lib/sh/helper.sh"
help_me
sh "$BBX_HOME/drivers/adrv.sh"
echo "PASS: g2"
EOF
cat > "$P/gates/g3.sh" <<'EOF'
#!/bin/sh
# g3.sh — the DRIVER's header still carries its NOT-ASSERTED line (R30; G25's detector)
# NOT-ASSERTED: anything at all; this is a stub whose point is the driver's header
#
set -eu
drv="$(cd "$(dirname "$0")/.." && pwd)/drivers/adrv.sh"
n=$(awk 'NR==1{next} /^#/{print; next} {exit}' "$drv" | grep -c '^# NOT-ASSERTED:' || true)
[ "$n" -ge 1 ] || { echo "FAIL: g3 found no NOT-ASSERTED line in the driver's leading comment block"; exit 1; }
echo "PASS: g3 read $n NOT-ASSERTED line(s) from the driver's header"
EOF
cat > "$P/gates/g4.sh" <<'EOF'
#!/bin/sh
# g4.sh — a gate that names the lineage variable SYNTH_LINEAGE
# NOT-ASSERTED: anything at all; this is a stub
#
set -eu
echo "SYNTH_LINEAGE is ${SYNTH_LINEAGE:-unset}"
echo "PASS: g4"
EOF
chmod +x "$P/bin/synthbin" "$P/drivers/adrv.sh" "$P"/gates/*.sh
printf 'g1\ng2\ng3\n' > "$P/gates/portable.txt"
printf 'g4\n' > "$P/gates/static.txt"
printf '# Synthetic census\n\nprose above the generated block\n\n' > "$P/census.md"
printf '%s\n(nothing measured yet)\n%s\n\nprose below\n' \
  '<!-- GENERATED by `bbx file-census`: BEGIN. Never hand-edited (BBX-21). -->' \
  '<!-- GENERATED by `bbx file-census`: END. -->' >> "$P/census.md"
( cd "$P" && git init -q && git add -A && git -c user.name=fc -c user.email=fc@fc commit -qm synth >/dev/null )
# `|| true`: restoring a perturbation can leave the tree EQUAL to the last commit, and
# `git commit` exits 1 on nothing to commit — which under `set -e` killed this gate after
# section 4 on its first run. The point of the helper is only that `git archive HEAD` in the
# instrument sees the tree as it stands.
commit() { ( cd "$P" && git add -A && git -c user.name=fc -c user.email=fc@fc commit -qm "$1" >/dev/null 2>&1 || true ); }

echo "== 1. the instrument runs every registered gate and traces what each EXECUTED =="
$FC --root "$P" --out "$T/o1" > "$T/1.log" 2>&1 || fail "the clean run exited non-zero"
for g in g1 g2 g3 g4; do
    grep -q "^    $g  *PASS" "$T/1.log" || fail "$g is not PASS in the shadow"
done
grep -q '^  universe   5 files   gates 4 ' "$T/1.log" && ok "universe 5 files, 4 gates (the tree as built)" \
  || fail "the header line: $(grep '^  universe' "$T/1.log" || echo missing)"
grep -q 'instrumented 4 files' "$T/1.log" && ok "4 files instrumented (1 bin, 1 driver, 1 sourced lib, sitecustomize)" \
  || fail "instrumented count: $(grep -o 'instrumented [0-9]* files' "$T/1.log" || echo missing)"
t() { tr '\n' ' ' < "$T/o1/files/$1.txt"; }
[ "$(t g1)" = "bin/synthbin lib/py/bbx/__init__.py lib/py/bbx/amod.py " ] \
  && ok "g1's trace is the program and the two modules, and nothing else" || fail "g1 traced: $(t g1)"
[ "$(t g2)" = "drivers/adrv.sh lib/sh/helper.sh " ] \
  && ok "g2's trace is the driver and the SOURCED lib" || fail "g2 traced: $(t g2)"
[ -z "$(t g3)" ] && ok "g3 executed no harness file (it only read a header)" || fail "g3 traced: $(t g3)"

echo "== 2. MUST-FIRE: the static-registry gate that names the lineage variable reads F =="
k1="$(grep '^  gate kinds' "$T/1.log")"
printf '%s\n' "$k1" | grep -q 'g4=F' && ok "g4 is F: it is in gates/static.txt and names SYNTH_LINEAGE" || fail "kinds: $k1"
printf '%s\n' "$k1" | grep -q 'g1=K g2=K g3=K' && ok "the other three are K (no seed, no need)" || fail "kinds: $k1"
printf 'g1\ng2\ng3\ng4\n' > "$P/gates/portable.txt"; : > "$P/gates/static.txt"; commit moved
$FC --root "$P" --out "$T/o2" > "$T/2.log" 2>&1 || fail "the moved-registry run exited non-zero"
k2="$(grep '^  gate kinds' "$T/2.log")"
if printf '%s\n' "$k2" | grep -q 'g4=K'; then
    echo "CONTROL FIRED: static-need-is-what-decides — g4 reads F from gates/static.txt and K from gates/portable.txt, the body unchanged"
    ok "the STATIC REGISTRY plus the lineage variable is what decides F, not the gate's text"
else
    echo "CONTROL DEAD: static-need-is-what-decides — g4 read $(printf '%s\n' "$k2" | grep -o 'g4=[A-Z]*') after the move"
    fail "the frame-driven rule is not what decides"
fi
printf 'g1\ng2\ng3\n' > "$P/gates/portable.txt"; printf 'g4\n' > "$P/gates/static.txt"; commit restored

echo "== 3. the census document is GENERATED, and --check reads it back =="
$FC --root "$P" --out "$T/o3" --document "$P/census.md" > "$T/3.log" 2>&1 || fail "regenerating exited non-zero"
grep -q '^  document   census.md regenerated' "$T/3.log" && ok "the generated block was written" \
  || fail "no regenerated line: $(tail -1 "$T/3.log")"
grep -q '^prose above the generated block$' "$P/census.md" && grep -q '^prose below$' "$P/census.md" \
  && ok "the prose OUTSIDE the markers is untouched" || fail "the prose outside the block was rewritten"
grep -q '(nothing measured yet)' "$P/census.md" && fail "the old block survived" || ok "the old block was replaced"
commit generated
$FC --root "$P" --out "$T/o3" --document "$P/census.md" --check > "$T/4.log" 2>&1 \
  && ok "--check on the generated document is clean (the run's own text)" || fail "--check failed on its own output"

echo "== 4. MUST-FIRE: one count edited in the generated block =="
sed 's/| `bin\/synthbin` | 1 |/| `bin\/synthbin` | 9 |/' "$P/census.md" > "$T/edited.md"
cmp -s "$P/census.md" "$T/edited.md" && fail "CONTROL DEAD: edited-census-row — the perturbation did not apply"
cp "$T/edited.md" "$P/census.md"
if $FC --root "$P" --out "$T/o3" --document "$P/census.md" --check > "$T/5.log" 2>&1; then
    echo "CONTROL DEAD: edited-census-row — --check passed a document with an edited count"
    fail "the document check cannot fail"
else
    if grep -q '^FAIL file-census: census.md:[0-9]* differs from the run$' "$T/5.log" \
       && grep -q '^       document: | `bin/synthbin` | 9 | g1 |$' "$T/5.log" \
       && grep -q '^       the run : | `bin/synthbin` | 1 | g1 |$' "$T/5.log"; then
        echo "CONTROL FIRED: edited-census-row — $(grep -o 'census.md:[0-9]* differs from the run' "$T/5.log"), both texts printed"
        ok "an edited census row is named with the document's text and the run's"
    else
        echo "CONTROL DEAD: edited-census-row — non-zero, but not the named line"
        fail "the failure text: $(grep FAIL "$T/5.log" | head -1)"
    fi
fi
$FC --root "$P" --out "$T/o3" --document "$P/census.md" > /dev/null 2>&1; commit restored-doc

echo "== 5. the frozen kind-sets: the freeze, then the clean compare =="
$FC --root "$P" --out "$T/o4" --frozen "$P/frozen.toml" --freeze > "$T/6.log" 2>&1 || fail "the freeze exited non-zero"
grep -q '^  froze      5 kind-set rows' "$T/6.log" && ok "5 rows frozen, one per universe file" \
  || fail "froze: $(grep -o 'froze .*' "$T/6.log" || echo missing)"
grep -q '^mode = "shrink-only"$' "$P/frozen.toml" && grep -q '^class = "self"$' "$P/frozen.toml" \
  && ok "the frozen file declares class self and mode shrink-only (R39, R11: currency not correctness)" \
  || fail "the frozen file's [spec]"
$FC --root "$P" --out "$T/o4" --frozen "$P/frozen.toml" > "$T/7.log" 2>&1 || fail "the clean compare exited non-zero"
grep -q '^  kind-sets  frozen 5 measured 5 failures 0 notes 0$' "$T/7.log" \
  && ok "frozen 5 measured 5 failures 0 notes 0" || fail "$(grep 'kind-sets' "$T/7.log" || echo missing)"

echo "== 6. MUST-FIRE: a frozen kind-set that claims a kind the run did not measure =="
sed 's|^kinds = "K"$|kinds = "KF"|' "$P/frozen.toml" > "$T/shrunk.toml"
[ "$(grep -c 'kinds = "KF"' "$T/shrunk.toml")" = 5 ] || fail "CONTROL DEAD: shrunk-kind-set — the perturbation did not apply"
if $FC --root "$P" --out "$T/o4" --frozen "$T/shrunk.toml" > "$T/8.log" 2>&1; then
    echo "CONTROL DEAD: shrunk-kind-set — five rows claiming an F nobody measured passed"
    fail "shrink-only asserts nothing"
else
    n="$(grep -c '^FAIL file-census: .* lost kind(s) F — frozen KF, measured K$' "$T/8.log")"
    if [ "$n" = 5 ]; then
        echo "CONTROL FIRED: shrunk-kind-set — 5 rows named, each with the kind lost and both sides"
        ok "a kind-set that shrank FAILs naming the file and the direction"
    else
        echo "CONTROL DEAD: shrunk-kind-set — $n named rows, expected 5"
        fail "$(grep FAIL "$T/8.log" | head -2)"
    fi
fi
echo "   and a row the universe no longer holds is a DEAD ROW (BBX-9, the other way)"
printf '\n[fgone]\nfile = "lib/sh/gone.sh"\nkinds = "K"\n' >> "$T/shrunk.toml"
$FC --root "$P" --out "$T/o4" --frozen "$T/shrunk.toml" > "$T/9.log" 2>&1 \
  && fail "a dead frozen row passed" \
  || { grep -q 'is frozen and is not in the universe (a dead row, BBX-9)' "$T/9.log" \
       && ok "a frozen row naming a file the universe does not hold FAILs as a dead row" \
       || fail "dead row: $(grep FAIL "$T/9.log" | head -1)"; }
echo "   and a file frozen TWICE is hand-editing (BBX-17)"
cp "$P/frozen.toml" "$T/dup.toml"; printf '\n[fdup]\nfile = "lib/sh/helper.sh"\nkinds = "K"\n' >> "$T/dup.toml"
$FC --root "$P" --out "$T/o4" --frozen "$T/dup.toml" > "$T/10.log" 2>&1 \
  && fail "a duplicate frozen row passed" \
  || { grep -q 'frozen twice — hand-editing (BBX-17)' "$T/10.log" \
       && ok "a file frozen twice is named as hand-editing" \
       || fail "duplicate: $(grep FAIL "$T/10.log" | head -1)"; }

echo "== 7. MUST-FIRE: a harness file no gate executes (rot class 1) =="
printf 'print("nobody runs me")\n' > "$P/lib/py/bbx/orphan.py"; commit orphan
if $FC --root "$P" --out "$T/o5" --frozen "$P/frozen.toml" > "$T/11.log" 2>&1; then
    echo "CONTROL DEAD: orphan-file — a module no gate executes passed"
    fail "the orphan direction asserts nothing"
else
    grep -q '^FAIL file-census: `lib/py/bbx/orphan.py` is executed by NO gate (rot class 1, orphan)$' "$T/11.log" \
      || { echo "CONTROL DEAD: orphan-file — non-zero, but not the named line"; fail "$(grep FAIL "$T/11.log" | head -1)"; }
    $FC --root "$P" --out "$T/o5" --frozen "$T/fresh.toml" --freeze > /dev/null 2>&1
    if $FC --root "$P" --out "$T/o5" --frozen "$T/fresh.toml" > "$T/12.log" 2>&1; then
        echo "CONTROL DEAD: orphan-file — a FRESH freeze silenced the orphan"
        fail "a freeze can hide an unreached file"
    else
        grep -q 'is executed by NO gate (rot class 1, orphan)' "$T/12.log" \
          && { echo "CONTROL FIRED: orphan-file — named against the old freeze AND against a freeze taken with it on disk"
               ok "an unreached harness file FAILs always; a re-freeze cannot hide it"; } \
          || fail "the fresh-freeze run failed for another reason"
    fi
fi
rm "$P/lib/py/bbx/orphan.py"; commit no-orphan

echo "== 8. MUST-FIRE: G25 — the trace line inserted after the SHEBANG ends the header =="
$FC --root "$P" --out "$T/o6" > "$T/13.log" 2>&1 || fail "the control's positive half did not pass"
grep -q "^    g3  *PASS" "$T/13.log" || fail "CONTROL DEAD: header-insertion — g3 is not PASS with the correct insertion"
if $FC --root "$P" --out "$T/o7" --insert-after-shebang > "$T/14.log" 2>&1; then
    echo "CONTROL DEAD: header-insertion — the run survived the G25 insertion"
    fail "the insertion point is not under test"
else
    if grep -q "^    g3  *FAIL" "$T/14.log" \
       && grep -q '^REFUSED: file-census: `g3` is FAIL in the shadow — its trace is CONTAMINATED' "$T/14.log" \
       && grep -q 'INSERT-AFTER-SHEBANG (G25 reproduced)' "$T/14.log"; then
        echo "CONTROL FIRED: header-insertion — g3 PASS after the header, FAIL after the shebang, and the run REFUSED as contaminated"
        ok "the insertion point decides whether a driver's header survives (R30, G25)"
    else
        echo "CONTROL DEAD: header-insertion — non-zero, but not the refusal"
        fail "$(grep -E 'REFUSED|g3' "$T/14.log" | head -2)"
    fi
fi

echo "== 9. the census's KEY is R38's identity, and the two writers of it AGREE =="
idf="$(python3 -c "import sys; sys.path.insert(0, '$BBX_HOME/lib/py'); from bbx.file_census import identity; print(identity('$BBX_HOME'))")"
idk="$(sh "$BBX_HOME/fixture/selfgates/idkey.sh" wholeset)"
[ "$idf" = "$idk" ] && ok "bbx.file_census.identity and idkey.sh wholeset compute ONE key over BBX's own tree" \
  || fail "two identity writers disagree: file_census $idf, idkey.sh $idk"
h0="$( cd "$P" && git rev-parse HEAD )"
printf '\n<!-- a docs-only commit -->\n' >> "$P/census.md"; commit docs-only
h1="$( cd "$P" && git rev-parse HEAD )"
[ "$h0" != "$h1" ] || fail "the docs-only commit did not move HEAD (the control's premise)"
$FC --root "$P" --out "$T/o8" --document "$P/census.md" --check > "$T/15.log" 2>&1 \
  && ok "a commit that only rewrites the document leaves --check clean: the key is the harness, not HEAD" \
  || fail "--check went red on a docs-only commit: $(grep FAIL "$T/15.log" | head -1)"
printf '#!/bin/sh\n# g5.sh — a new gate, which MOVES the harness identity\n# NOT-ASSERTED: anything at all\n#\necho "PASS: g5"\n' > "$P/gates/g5.sh"
chmod +x "$P/gates/g5.sh"; printf 'g1\ng2\ng3\ng5\n' > "$P/gates/portable.txt"; commit new-gate
$FC --root "$P" --out "$T/o9" --document "$P/census.md" --check > "$T/16.log" 2>&1 \
  && fail "a new GATE left the census checkable — the identity did not move" \
  || ok "a commit that adds a gate moves the identity and --check goes red, which is when the census IS stale"
rm "$P/gates/g5.sh"; printf 'g1\ng2\ng3\n' > "$P/gates/portable.txt"; commit drop-g5

echo "== 10. the instrument writes nothing under the subject tree it measures =="
( cd "$P" && git status --porcelain --ignored ) > "$T/porc.txt"
[ ! -s "$T/porc.txt" ] && ok "the subject tree is clean and unignored-clean after every run (each shadow lives under the out dir)" \
  || fail "the subject tree was written: $(head -3 "$T/porc.txt" | tr '\n' ' ')"

printf '\nNOTE: file-census-tool-runs 12\n'
echo
[ "$rc" = 0 ] && echo "PASS: the file-census instrument measures execution, refuses a contaminated run, and fails on every frozen row that moved" \
  || { echo "FAIL: see above"; exit 1; }

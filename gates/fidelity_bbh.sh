#!/bin/sh
# fidelity_bbh.sh — the generic runners, classifiers and the fingerprint reproduce bbh's verdict text byte for byte over bbh's own fixtures (F13, F14, F15)
# THE FIDELITY OBLIGATION (CLAUDE.md §2, §7.2; docs/fidelity.md): bbh is not modified and is
# the proof that nothing was lost. Both tools are run over the SAME input and their output is
# diffed with only durations normalised — never expected values re-derived by hand (bbh
# [BBH-81]). Rows here: F13a both static runners over a synthetic repo of stub gates (bbh's
# F1 shape); F13b example/ portable tier; F13c example/ static tier (FAKE_ROOT); F13d --list;
# F13e the tier classifier --list and --unregistered; F14 the sweep runner over example/ (--list,
# --list --scope all --lane all, --dry-run, a real --scope all --strict run, log dirs normalised);
# F14f the fingerprint over example/roms (every flag, the registered and the refused image);
# F15 (BBX_FIDELITY_F15=1, ~2-6 min) every bbh selftest's (exit, log) classified by both
# classifiers.
# Usage: BBX_BBH_HOME=~/Developer/blackbox-harness gates/fidelity_bbh.sh     (~10 s; F15 opt-in)
# SKIP: BBX_BBH_HOME unset or not a bbh tree (exit 0; asserts nothing).
# Usage note: F14's real run executes bbh's example gates (they call bbh's own tools) under
# each runner; only the runners' printed lines are compared. ~25 s.
# MUST-FIRE: perturbed-copy: verdict-text — a shadow copy of bbx-run-static with one verdict format string changed must make F13a's diff non-empty, or the diff cannot fail
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
B="${BBX_BBH_HOME:-}"
[ -n "$B" ] && [ -x "$B/bin/bbh-run-static" ] || { echo "SKIP: BBX_BBH_HOME is not a bbh tree (${B:-unset}); fidelity needs it"; exit 0; }
B="$(cd "$B" && pwd)"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
norm() { sed -E 's/ +[0-9]+s( |$)/ Ns\1/g'; }
_rb="$(grep -m1 '^- ' "$BBX_HOME/docs/rebaselines.md" 2>/dev/null || echo '- (none recorded)')"
echo "LAST RE-BASELINE: ${_rb#- }"
echo "bbh: $B @ $(git -C "$B" rev-parse --short HEAD) porcelain=$(git -C "$B" status --porcelain | wc -l | tr -d ' ') (baseline f675710, ruling R8)"

pair() {  # pair <label> <cmd-a> <cmd-b>  — both captured with their exit, normalised, diffed
    _l="$1"; _a="$2"; _b="$3"
    (eval "$_a" 2>&1; echo "exit=$?") | norm > "$T/a.txt"
    (eval "$_b" 2>&1; echo "exit=$?") | norm > "$T/b.txt"
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$_l: identical ($(wc -l < "$T/a.txt" | tr -d ' ') lines)"
    else fail "$_l: the outputs differ:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}

echo "== F13a. both static runners over one synthetic repo of stub gates =="
FR="$T/fake"; mkdir -p "$FR/tests/lib"
printf '[project]\nroot = "."\n' > "$FR/bbh.toml"
mk() { n="$1"; st="$2"; shift 2; { echo "#!/bin/sh"; for l in "$@"; do echo "echo '$l'"; done; echo "exit $st"; } > "$FR/tests/$n.sh"; chmod +x "$FR/tests/$n.sh"; }
mk g_pass 0 "all good" "PASS: fine"; mk g_fail 1 "something broke" "FAIL: nope"; mk g_skip 0 "SKIP: no build at build/nope"
mk g_skip_indent 0 "  SKIP: indented skip marker"; mk g_prose 0 "checked 3 things, none had to be skipped" "PASS: prose only"
mk g_skip_fail 2 "  SKIPPED: no reference binary" "PARTIAL: the invariant was NOT run"
mk g_segv 0 "PASS: summary" "tests/g_segv.sh: line 64:  2444 Segmentation fault: 11  REPLAY=x"
mk g_exit3 3 "boom"; mk g_orphan 0 "PASS: nobody registered me"
mk g_shellcrash 0 "tests/g_shellcrash.sh: line 3: FOO: set FOO to a dir OUTSIDE the repo"
mk g_note 0 "NOTE: widgets 42" "PASS: with a note"
printf '#!/bin/sh\nMAME_BIN=x tools/run_mame.sh vsavj\n' > "$FR/tests/g_emu.sh"; chmod +x "$FR/tests/g_emu.sh"
printf 'g_pass\ng_fail\ng_skip\ng_skip_indent\ng_prose\ng_skip_fail\ng_segv\ng_exit3\ng_shellcrash\ng_note\nno_such\n' > "$FR/tests/ci_portable.txt"; : > "$FR/tests/ci_static.txt"
pair "F13a (portable, 10 stub gates + MISSING + orphan + an emulator gate + a NOTE)" \
     "cd '$FR' && '$B/bin/bbh-run-static' --config bbh.toml --tier portable" \
     "cd '$FR' && '$BBX_HOME/bin/bbx-run-static' --config bbh.toml --tier portable"
pair "F13a --strict" \
     "cd '$FR' && '$B/bin/bbh-run-static' --config bbh.toml --tier portable --strict" \
     "cd '$FR' && '$BBX_HOME/bin/bbx-run-static' --config bbh.toml --tier portable --strict"

echo "== F13b/c/d. bbh's example consumer through both runners =="
pair "F13b example/ portable tier" \
     "cd '$B/example' && '$B/bin/bbh-run-static' --tier portable" \
     "cd '$B/example' && '$BBX_HOME/bin/bbx-run-static' --config bbh.toml --tier portable"
pair "F13c example/ both tiers (FAKE_ROOT=.)" \
     "cd '$B/example' && FAKE_ROOT=. '$B/bin/bbh-run-static'" \
     "cd '$B/example' && FAKE_ROOT=. '$BBX_HOME/bin/bbx-run-static' --config bbh.toml"
pair "F13c' example/ static tier NOT RUN (FAKE_ROOT unset)" \
     "cd '$B/example' && env -u FAKE_ROOT '$B/bin/bbh-run-static'" \
     "cd '$B/example' && env -u FAKE_ROOT '$BBX_HOME/bin/bbx-run-static' --config bbh.toml"
pair "F13d example/ --list" \
     "cd '$B/example' && '$B/bin/bbh-run-static' --list" \
     "cd '$B/example' && '$BBX_HOME/bin/bbx-run-static' --config bbh.toml --list"

echo "== F13e. the tier classifier over example/ =="
pair "F13e tier --list" \
     "cd '$B' && PYTHONPATH='$B/lib/py' python3 -m bbh.tier example/bbh.toml --list" \
     "cd '$B' && PYTHONPATH='$BBX_HOME/lib/py' python3 -m bbx.tier example/bbh.toml --list"
pair "F13e tier --unregistered" \
     "cd '$B' && PYTHONPATH='$B/lib/py' python3 -m bbh.tier example/bbh.toml --unregistered" \
     "cd '$B' && PYTHONPATH='$BBX_HOME/lib/py' python3 -m bbx.tier example/bbh.toml --unregistered"
pair "F13e config dump of example/bbh.toml" \
     "cd '$B' && PYTHONPATH='$B/lib/py' python3 -m bbh.config example/bbh.toml dump" \
     "cd '$B' && PYTHONPATH='$BBX_HOME/lib/py' python3 -m bbx.config example/bbh.toml dump"

echo "== F14. the sweep runner over example/ =="
pairlog() {  # pairlog <label> <cmd-a> <cmd-b>  — like pair, with the two log dirs normalised to LOG
    _l="$1"; _a="$2"; _b="$3"
    (eval "$_a" 2>&1; echo "exit=$?") | norm | sed "s|$T/sw_a|LOG|g" > "$T/a.txt"
    (eval "$_b" 2>&1; echo "exit=$?") | norm | sed "s|$T/sw_b|LOG|g" > "$T/b.txt"
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$_l: identical ($(wc -l < "$T/a.txt" | tr -d ' ') lines)"
    else fail "$_l: the outputs differ:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
pair "F14 --list" \
     "cd '$B/example' && FAKE_ROOT=. '$B/bin/bbh-run-sweep' --list" \
     "cd '$B/example' && FAKE_ROOT=. '$BBX_HOME/bin/bbx-run-sweep' --config bbh.toml --list"
pair "F14 --list --scope all --lane all" \
     "cd '$B/example' && FAKE_ROOT=. '$B/bin/bbh-run-sweep' --list --scope all --lane all" \
     "cd '$B/example' && FAKE_ROOT=. '$BBX_HOME/bin/bbx-run-sweep' --config bbh.toml --list --scope all --lane all"
pairlog "F14 --dry-run --scope all (the precondition, the fingerprinted builds, the instruments, every lane's command, the coverage report)" \
     "cd '$B/example' && FAKE_ROOT=. '$B/bin/bbh-run-sweep' --dry-run --scope all --log '$T/sw_a'" \
     "cd '$B/example' && FAKE_ROOT=. '$BBX_HOME/bin/bbx-run-sweep' --config bbh.toml --dry-run --scope all --log '$T/sw_b'"
# THE ONE KNOWN DELTA, RECORDED (bbh [BBH-82]: a finding about the consumer, never a fidelity
# failure, never fixed by weakening): example/tests/lib/needs_fake.sh computes bbh's location
# from the GATE's path as `$(dirname "$0")/../../..` — one level too many when sourced — and
# works under bbh only because bbh-run-sweep exports BBH_HOME into every gate. BBX exports
# BBX_HOME, so the latent defect surfaces (g_needs_fake FAIL). The consumer's harness location
# is the consumer's input: both sides run with BBH_HOME exported (as bbh's F4 runs both with
# MAME_BIN unset). docs/gotchas.md G11.
pairlog "F14 a real run: --scope all --strict (bbh's example gates under each runner; BBH_HOME exported on both sides, G11)" \
     "cd '$B/example' && BBH_HOME='$B' FAKE_ROOT=. '$B/bin/bbh-run-sweep' --scope all --strict --log '$T/sw_a'" \
     "cd '$B/example' && BBH_HOME='$B' FAKE_ROOT=. '$BBX_HOME/bin/bbx-run-sweep' --config bbh.toml --scope all --strict --log '$T/sw_b'"
rm -rf "$T/sw_a" "$T/sw_b"
echo "== F14f. the fingerprint over example/roms =="
for _r in build-a base attract build-b hook; do
    pair "F14f fingerprint roms/$_r (registry lookup)" \
         "cd '$B/example' && PYTHONPATH='$B/lib/py' python3 -m bbh.fingerprint roms/$_r --config bbh.toml" \
         "cd '$B/example' && PYTHONPATH='$BBX_HOME/lib/py' python3 -m bbx.fingerprint roms/$_r --config bbh.toml"
done
for _f in --sha-only --set-key --full; do
    pair "F14f fingerprint roms/build-a $_f" \
         "cd '$B/example' && PYTHONPATH='$B/lib/py' python3 -m bbh.fingerprint roms/build-a --config bbh.toml $_f" \
         "cd '$B/example' && PYTHONPATH='$BBX_HOME/lib/py' python3 -m bbx.fingerprint roms/build-a --config bbh.toml $_f"
done

echo "== MUST-FIRE: a verdict-text change is visible to F13a =="
S="$T/shadow"; mkdir -p "$S/bin" "$S/lib"
ln -s "$BBX_HOME/lib/py" "$S/lib/py"; ln -s "$BBX_HOME/lib/sh" "$S/lib/sh"
cp "$BBX_HOME/bin/bbx-run-static" "$S/bin/bbx-run-static"; chmod +x "$S/bin/bbx-run-static"
sed -i.bak "s/printf '  %-34s PASS  %3ss\\\\n'/printf '  %-34s PASSED %3ss\\\\n'/" "$S/bin/bbx-run-static"
if cmp -s "$S/bin/bbx-run-static" "$BBX_HOME/bin/bbx-run-static"; then
    echo "CONTROL DEAD: verdict-text — the shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    (cd "$FR" && "$B/bin/bbh-run-static" --config bbh.toml --tier portable 2>&1; echo "exit=$?") | norm > "$T/pa.txt"
    (cd "$FR" && "$S/bin/bbx-run-static" --config bbh.toml --tier portable 2>&1; echo "exit=$?") | norm > "$T/pb.txt"
    if diff "$T/pa.txt" "$T/pb.txt" > "$T/pd.txt"; then
        echo "CONTROL DEAD: verdict-text — a changed PASS format string produced an empty diff"; fail "the diff cannot fail"
    else
        echo "CONTROL FIRED: verdict-text — one changed format string, $(grep -c '^[<>]' "$T/pd.txt") differing lines"
        ok "the fidelity diff can fail"
    fi
fi

if [ "${BBX_FIDELITY_F15:-}" = 1 ]; then
    echo "== F15. every bbh selftest's (exit, log) through both classifiers =="
    n=0; bad=0
    for t in "$B"/selftest/test_*.sh; do
        g="$(basename "$t" .sh)"
        (cd "$B" && sh "$t" </dev/null > "$T/$g.out" 2>&1) && st=0 || st=$?
        a="$("$B/bin/bbh-classify" "$st" "$T/$g.out")"; b="$("$BBX_HOME/bin/bbx-classify" "$st" "$T/$g.out")"
        n=$((n + 1))
        [ "$a" = "$b" ] || { bad=$((bad + 1)); fail "F15 $g: bbh '$a' vs bbx '$b'"; }
    done
    [ "$bad" = 0 ] && ok "F15: $n selftests, both classifiers agree on every (exit, log)" || true
else
    echo "== F15. not run (set BBX_FIDELITY_F15=1; runs bbh's whole selftest, ~2-6 min) =="
fi

echo
[ "$rc" = 0 ] && echo "PASS: BBX reproduces bbh's verdict text over bbh's own fixtures (F13a-e, F14, F14f); F15 $([ "${BBX_FIDELITY_F15:-}" = 1 ] && echo run || echo 'not run')" || { echo "FAIL: see above"; exit 1; }

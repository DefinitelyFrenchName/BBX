#!/bin/sh
# bbx-30, S6 step 3 probe (K8, R63): bbh's demand_after_trap at a bbh commit, extracted through `git show` (bbh's
# working tree is never read), over BBX's gates/, drivers/ and lib/sh/, and over a copy of every bin/ file whose first
# line is a shell shebang under a .sh name (K8's second delta, simulated); bbh's selftest case a through the same
# module must be reported (the positive control); and bbh's example tests/ listed for extensionless files (F19b's
# inputs, where the shebang delta could read something bbh does not). Read-only for both trees.
# Usage: sh probe_k8_bbx.sh <bbh-repo> <commit> <bbx-root> <workdir>
set -u
BBH="$1"; C="$2"; BBX="$3"; W="$4"
rm -rf "$W"; mkdir -p "$W/pkg/bbh" "$W/bin_as_sh" "$W/pos"
git -C "$BBH" show "$C:lib/py/bbh/demand_after_trap.py" > "$W/pkg/bbh/demand_after_trap.py" || { echo "git show failed"; exit 2; }
: > "$W/pkg/bbh/__init__.py"
lint() {  # lint <dir> <label>
    PYTHONPATH="$W/pkg" python3 -m bbh.demand_after_trap "$1" --lib __none__ > "$W/lint.out" 2>&1; e=$?
    echo "dir=$2 exit=$e hits=$(wc -l < "$W/lint.out" | tr -d ' ')"
    sed 's/^/    /' "$W/lint.out"
}
echo "bbh commit=$C bbx head=$(git -C "$BBX" rev-parse --short HEAD)"
for d in gates drivers lib/sh; do lint "$BBX/$d" "$d"; done
n=0
for f in "$BBX"/bin/*; do
    [ -f "$f" ] || continue
    head -1 "$f" | grep -q -E '^#!.*(/(ba|da|z)?sh|env (ba|da)?sh)( |$)' || continue
    cp "$f" "$W/bin_as_sh/$(basename "$f").sh"; n=$((n + 1))
done
echo "bin files with a shell shebang: $n ($(ls "$W/bin_as_sh" | tr '\n' ' '))"
lint "$W/bin_as_sh" "bin(as .sh)"
printf '#!/bin/sh\nset -eu\nW=$(mktemp -d); trap '"'"'rm -rf "$W"'"'"' EXIT\n: "${FOO:?set FOO}"\n' > "$W/pos/g.sh"
lint "$W/pos" "positive-control(bbh selftest case a)"
echo "bbh example tests/ files with no extension at $C:"
git -C "$BBH" ls-tree -r --name-only "$C" example/tests/ | grep -v -E '\.[A-Za-z0-9]+$' || echo "    (none)"

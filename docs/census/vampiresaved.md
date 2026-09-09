# Census — VampireSaved @ 5df1d8be — measured 2026-09-09
Path `/Users/koneko/Developer/Vampire_Saved/VampireSaved` · remote `https://github.com/DefinitelyFrenchName/VampireSaved.git` · 7497 tracked files · 1502 commits · working tree: 1 ` M` (submodule pointer `emu/fbneo`) + 370 `??` untracked (all under `build/`), nothing staged.

Read-only survey. Every number below carries the command that printed it, run from the VampireSaved repo root. No file in that tree was modified.

## A. Counts

| id | dimension | count | command (run from repo root) |
|---|---|---|---|
| A1 | rules total, across the 8 skills | 555 | `python3 tools/checkskills.py -v \| tail -1` |
| A2 | rules, VSP (vampire-saved-port) | 180 | `grep -cE '^- \[VSP-[0-9]+\]' .claude/skills/vampire-saved-port/SKILL.md` |
| A3 | rules, VSE (vampire-savior-engine) | 85 | `grep -cE '^- \[VSE-[0-9]+\]' .claude/skills/vampire-savior-engine/SKILL.md` |
| A4 | rules, MSC (mister-cps2-wide-core) | 73 | `grep -cE '^- \[MSC-[0-9]+\]' .claude/skills/mister-cps2-wide-core/SKILL.md` |
| A5 | rules, MJC (mister-jtframe-core) | 63 | `grep -cE '^- \[MJC-[0-9]+\]' .claude/skills/mister-jtframe-core/SKILL.md` |
| A6 | rules, MFI (mame-fbneo-instruments) | 46 | `grep -cE '^- \[MFI-[0-9]+\]' .claude/skills/mame-fbneo-instruments/SKILL.md` |
| A7 | rules, CPE (cps2-emulation; all 42 are REDIRECTS to MFI) | 42 | `grep -cE '^- \[CPE-[0-9]+\]' .claude/skills/cps2-emulation/SKILL.md` |
| A8 | rules, MSV (mister-vampire-saved) | 36 | `grep -cE '^- \[MSV-[0-9]+\]' .claude/skills/mister-vampire-saved/SKILL.md` |
| A9 | rules, CPH (cps2-hardware) | 30 | `grep -cE '^- \[CPH-[0-9]+\]' .claude/skills/cps2-hardware/SKILL.md` |
| A10 | files holding an anchored `**[VSP-N]**` definition | 15 | `git grep -lE '\*\*\[VSP-[0-9]+\]\*\*' \| wc -l` |
| A11 | files holding an anchored `**[VSE-N]**` definition | 11 | `git grep -lE '\*\*\[VSE-[0-9]+\]\*\*' \| wc -l` |
| A12 | files holding an anchored `**[MSC-N]**` definition | 9 | `git grep -lE '\*\*\[MSC-[0-9]+\]\*\*' \| wc -l` |
| A13 | files holding an anchored `**[MJC-N]**` definition | 9 | `git grep -lE '\*\*\[MJC-[0-9]+\]\*\*' \| wc -l` |
| A14 | files holding an anchored `**[MSV-N]**` definition | 8 | `git grep -lE '\*\*\[MSV-[0-9]+\]\*\*' \| wc -l` |
| A15 | files holding an anchored `**[MFI-N]**` definition | 5 | `git grep -lE '\*\*\[MFI-[0-9]+\]\*\*' \| wc -l` |
| A16 | files holding an anchored `**[CPE-N]**` definition | 5 | `git grep -lE '\*\*\[CPE-[0-9]+\]\*\*' \| wc -l` |
| A17 | files holding an anchored `**[CPH-N]**` definition | 3 | `git grep -lE '\*\*\[CPH-[0-9]+\]\*\*' \| wc -l` |
| A18 | rules whose anchor is UNIQUE (checker's guarantee, re-measured) | 555 of 555 | `python3 <G1 in §C>` — reports `rules=555 no-anchor=0`, and `grep -c ' +[0-9]* \|' rules_rows.md` → 0 multi-anchor |
| A19 | rule-ID prefixes in use — 8 REAL schemes, 4 checker fixtures, 1 regex false positive, 1 live CROSS-REPO scheme | 8 + 4 + 1 + 1 | `git grep -ohE '\[[A-Z][A-Z0-9]{1,6}-[0-9]+\]' -- '*.md' '*.tsv' '*.toml' '*.py' '*.sh' '*.lua' \| sed -E 's/\[([A-Z][A-Z0-9]*)-[0-9]+\]/\1/' \| sort \| uniq -c \| sort -rn` → VSP 877, MJC 334, MSC 276, VSE 243, MFI 241, CPE 168, CPH 135, MSV 85 (real); XX 22, YY 6, ZZ 2, QQ 1 (checker fixtures); AW 7 (false positive, A123); RH 1 (real, A124) |
| A20 | `BBH-N` rule IDs defined in this tree | 0 | `git grep -ohE 'BBH-[0-9]+' \| sort -uV` → only the literal `BBH-1` inside the string `[BBH-1..87]` naming the OTHER repo |
| A21 | tracked `tests/**/*.sh` — the glob RECURSES, so this includes the 8 shared scripts under `tests/lib/` and is NOT the gate count | 319 | `git ls-files 'tests/*.sh' \| wc -l` ; the 8: `git ls-files 'tests/*.sh' \| grep '^tests/.*/'` → classify, decrypt_cache, enumerate_expectations, m2a_common, masked_compare, pairing, shadow_tools, tenant_build |
| A22 | gate scripts present in the working tree | 311 | `ls tests/*.sh \| wc -l` |
| A23 | gate scripts named `test_*` | 239 | `ls tests/test_*.sh \| wc -l` |
| A24 | rows in the GENERATED gate index | 311 | ``grep -c '^| `tests/' docs/project/gate_index.md`` |
| A25 | registry rows, `tests/gate_index.tsv` (family, hand-maintained) | 311 | `grep -vE '^\s*(#\|$)' tests/gate_index.tsv \| wc -l` |
| A26 | registry rows, `tests/ci_static.txt` | 74 | `grep -vE '^\s*(#\|$)' tests/ci_static.txt \| wc -l` |
| A27 | registry rows, `tests/ci_portable.txt` | 68 | `grep -vE '^\s*(#\|$)' tests/ci_portable.txt \| wc -l` |
| A28 | registry rows, `tests/ci_emulator.tsv` (THE SWEEP REGISTRY) | 165 | `grep -vE '^\s*(#\|$)' tests/ci_emulator.tsv \| wc -l` |
| A29 | registry rows, `tests/expected/registry.tsv` (fingerprint → set) | 70 | `grep -vE '^\s*(#\|$)' tests/expected/registry.tsv \| wc -l` |
| A30 | registry rows, `docs/doc_shape.tsv` (declared doc shapes) | 74 | `grep -vE '^\s*(#\|$)' docs/doc_shape.tsv \| wc -l` |
| A31 | registry rows, `docs/doc_locks.tsv` (cross-document number locks) | 19 | `grep -vE '^\s*(#\|$)' docs/doc_locks.tsv \| wc -l` |
| A32 | gate scripts carrying a MUST-FIRE control marker | 74 | `git grep -lie 'must.fire' -- 'tests/*.sh' \| wc -l` |
| A33 | MUST-FIRE marker occurrences under `tests/` | 194 | `git grep -ohiE 'must.{0,2}fire' tests \| wc -l` |
| A34 | distinct SPELLINGS of the MUST-FIRE marker | 8 | `git grep -ohiE 'must.{0,2}fire' tests \| sort -u \| wc -l` — `must-fire` 91, `MUST-FIRE` 65, `must fire` 13, `must_fire` 11, `Must-fire` 5, `must FIRE` 4, `MUST fire` 4, `must- fire` 1 |
| A35 | docs/memory files mentioning MUST-FIRE | 35 | `git grep -lie 'must.fire' -- 'docs/**/*.md' '*.md' \| wc -l` |
| A36 | machine-readable MUST-FIRE registry | 0 | `git ls-files \| grep -i mustfire` → empty; the marker is prose only |
| A37 | tracked files under `tests/expected/` | 4808 | `git ls-files tests/expected \| wc -l` |
| A38 | expectation files, `.masked` | 2311 | `git ls-files 'tests/expected/*.masked' \| wc -l` |
| A39 | expectation files, `.log` (frozen reference logs) | 807 | `git ls-files 'tests/expected/*.log' \| wc -l` |
| A40 | expectation files, `.skip` | 778 | `git ls-files 'tests/expected/*.skip' \| wc -l` |
| A41 | expectation files, `.sha1` | 719 | `git ls-files 'tests/expected/*.sha1' \| wc -l` |
| A42 | expectation files, `.legacy-exempt` | 56 | `git ls-files 'tests/expected/*.legacy-exempt' \| wc -l` |
| A43 | expectation files, `.txt` | 46 | `git ls-files 'tests/expected/*.txt' \| wc -l` |
| A44 | expectation files, `.md` | 18 | `git ls-files 'tests/expected/*.md' \| wc -l` |
| A45 | expectation files, `.tsv` | 7 | `git ls-files 'tests/expected/*.tsv' \| wc -l` |
| A46 | expectation files, `.pending` | 6 | `git ls-files 'tests/expected/*.pending' \| wc -l` |
| A47 | expectation files, `.png` | 3 | `git ls-files 'tests/expected/*.png' \| wc -l` |
| A48 | expectation files, `.sha256` | 2 | `git ls-files 'tests/expected/*.sha256' \| wc -l` |
| A49 | expectation files, `.diverge` (class exists in the runner; none frozen) | 0 | `git ls-files 'tests/expected/*.diverge' \| wc -l` |
| A50 | verdict-bearing expectations (.masked+.skip+.sha1+.pending) | 3814 | sum of A38, A40, A41, A46 |
| A51 | expectation SETS (subdirectories of `tests/expected/`) | 86 | `git ls-files tests/expected \| awk -F/ 'NF>2{print $3}' \| sort -u \| wc -l` |
| A52 | sets carrying frozen `logs/` | 42 | `git ls-files tests/expected \| grep '/logs/' \| awk -F/ '{print $3}' \| sort -u \| wc -l` |
| A53 | `.masked` spec class census — `window` | 1322 | `git ls-files 'tests/expected/*.masked' \| while read f; do head -1 "$f"; done \| awk '{print $1}' \| sort \| uniq -c \| sort -rn` |
| A54 | `.masked` spec class census — `composite` | 596 | (same command as A53) |
| A55 | `.masked` spec class census — `exact` | 192 | (same command as A53) |
| A56 | `.masked` spec class census — `diverge` | 43 | (same command as A53) |
| A57 | `.masked` spec class census — `flicker` | 42 | (same command as A53) |
| A58 | `.masked` first lines carrying a class keyword (of 2311 files) | 2195 | `git ls-files 'tests/expected/*.masked' \| while read f; do head -1 "$f"; done \| awk '{print $1}' \| grep -cE '^(window\|composite\|exact\|diverge\|flicker)$'` |
| A59 | rows in `tests/expected/PROVENANCE.md` (incl. header + separator) | 29 | `grep -c '^\| ' tests/expected/PROVENANCE.md` — 27 data rows |
| A60 | distinct `rests on` (evidence-class) strings in PROVENANCE | 12 | `grep '^\| ' tests/expected/PROVENANCE.md \| awk -F'\|' 'NR>2{gsub(/^ +\| +$/,"",$5); print $5}' \| sort -u \| wc -l` — 6 base classes with parenthetical riders |
| A61 | ratified numeric thresholds declared in one place | 2 | `grep -cE '^[A-Z_]+ = [0-9]+' tools/s4_thresholds.py` — `FLICKER_MAX = 2` (:36), `RECONVERGE = 60` (:37) |
| A62 | gotcha entries, `docs/project/gotchas.md` | 242 | `grep -c '^## ' docs/project/gotchas.md` |
| A63 | gotcha entries, `docs/platform/gotchas.md` | 111 | `grep -c '^## ' docs/platform/gotchas.md` |
| A64 | gotcha entries, `docs/game/gotchas.md` | 57 | `grep -c '^## ' docs/game/gotchas.md` |
| A65 | gotcha entries, all three buckets | 410 | sum of A62..A64 |
| A66 | `paid:` markers, `docs/GOTCHAS.md` (the generated index) | 93 | `grep -oc 'paid:' docs/GOTCHAS.md` |
| A67 | `paid:` markers, `docs/project/gotchas.md` | 77 | `grep -oc 'paid:' docs/project/gotchas.md` |
| A68 | `paid:` markers, `docs/platform/gotchas.md` | 25 | `grep -oc 'paid:' docs/platform/gotchas.md` |
| A69 | `paid:` markers, `docs/game/gotchas.md` | 6 | `grep -oc 'paid:' docs/game/gotchas.md` |
| A70 | `cost:` markers in the gotcha buckets | 2, and NEITHER is a marker | `grep -c 'cost:' docs/*/gotchas.md docs/GOTCHAS.md` → `docs/game/gotchas.md:0`, `docs/platform/gotchas.md:0`, `docs/GOTCHAS.md:0`, `docs/project/gotchas.md:2`. Both hits are PROSE inside an entry body, not a price key: `**What it cost:**` (docs/project/gotchas.md:1935) and `Measured cost:` (:2698). The price key is `paid:` (A66-A69) |
| A71 | STALE COUNTER — gotcha index says vs measured | says 319 (40/91/188), is 410 (57/111/242) | `grep -oE '^[0-9]+ entries \([^)]*\)' docs/GOTCHAS.md` (→ `319 entries (40 game / 91 platform / 188 project)`) vs A62..A65 |
| A72 | STALE COUNTER — `harness_scope.md` says vs measured, skill rules | says 553, is 555 | `grep -on '553 rules' docs/project/harness_scope.md` (→ `313:`, `608:`) vs A1 |
| A73 | STALE COUNTER — `harness_scope.md` / fidelity gate say vs measured, masked specs | says 1,891, is 2311 | `grep -on '1,891' docs/project/harness_scope.md tests/test_bbh_fidelity.sh` (→ 4 sites) vs A38 |
| A74 | rot classes in the harness-rot taxonomy | 7 | `grep -cE '^[0-9]\. \*\*THE ' docs/project/harness_hardening_history.md` |
| A75 | fidelity rows in `harness_scope.md` §5 (F1..F11 + the F8-measured row) | 12 | `sed -n '/## 5\./,/## 6\./p' docs/project/harness_scope.md \| grep -cE '^\| \*?\*?F[0-9]'` |
| A76 | memory file lines — `CLAUDE.md` | 395 | `wc -l CLAUDE.md` |
| A77 | memory file lines — `STATE.md` | 1509 | `wc -l STATE.md` |
| A78 | memory file lines — `HANDOFF.md` | 1515 | `wc -l HANDOFF.md` |
| A79 | memory file lines — `DECISIONS_HISTORY.md` | 2783 | `wc -l DECISIONS_HISTORY.md` |
| A80 | memory file lines — `STATE_HISTORY.md` | 28918 | `wc -l STATE_HISTORY.md` |
| A81 | memory file lines — `HANDOFF_HISTORY.md` | 2437 | `wc -l HANDOFF_HISTORY.md` |
| A82 | memory file lines — `README.md` | 35 | `wc -l README.md` |
| A83 | memory file lines — `SPEC.md` | 175 | `wc -l SPEC.md` |
| A84 | memory file lines — `docs/NEXT_SESSION.md` | 92 | `wc -l docs/NEXT_SESSION.md` |
| A85 | memory file lines — `docs/NEXT_SESSION_HISTORY.md` | 5947 | `wc -l docs/NEXT_SESSION_HISTORY.md` |
| A86 | memory file lines — `docs/annotations.md` (GENERATED) | 3023 | `wc -l docs/annotations.md` |
| A87 | domain-token files — `vsav` | 4718 | `git grep -il vsav \| wc -l` |
| A88 | domain-token files — `mame` | 527 | `git grep -il mame \| wc -l` |
| A89 | domain-token files — `vampire` | 489 | `git grep -il vampire \| wc -l` |
| A90 | domain-token files — `cps2` | 487 | `git grep -il cps2 \| wc -l` |
| A91 | domain-token files — `lua` | 251 | `git grep -il lua \| wc -l` |
| A92 | domain-token files — `fbneo` | 210 | `git grep -il fbneo \| wc -l` |
| A93 | domain-token files — `mister` | 170 | `git grep -il mister \| wc -l` |
| A94 | domain-token files — `68k` | 136 | `git grep -il 68k \| wc -l` |
| A95 | tracked files — `tests/` | 5422 | `git ls-files \| awk -F/ '{if (NF==1) print "(root)"; else print $1}' \| sort \| uniq -c \| sort -rn` |
| A96 | tracked files — `build/` | 1043 | (same command as A95) |
| A97 | tracked files — `release/` | 719 | (same command as A95) |
| A98 | tracked files — `tools/` | 161 | (same command as A95) |
| A99 | tracked files — `docs/` | 85 | (same command as A95) |
| A100 | tracked files — `emu/` | 41 | (same command as A95) |
| A101 | tracked files — root | 11 | (same command as A95) |
| A102 | tracked files — `.claude/` | 10 | (same command as A95) |
| A103 | tracked files — `re/` | 2 | (same command as A95) |
| A104 | tracked files — `ci/` | 2 | (same command as A95) |
| A105 | tracked files — `.github/` | 1 | (same command as A95) |
| A106 | `GAME_TOKENS` — game names a level-1 skill may not use | 14 | `python3 -c "import re;s=open('tools/checkskills.py').read();print(len(re.findall(r'\"[^\"]+\"',re.search(r'GAME_TOKENS = \[(.*?)\]',s,re.S).group(1))))"` |
| A107 | `BUILD_TOKENS` — build literals a level-1 skill may not use | 8 | (same command, `BUILD_TOKENS`) |
| A108 | `BOARD_TOKENS` — board names a level-0 skill may not use | 5 | (same command, `BOARD_TOKENS`) |
| A109 | skills carried (`SKILL.md`) | 8 | `git ls-files '.claude/skills/*/SKILL.md' \| wc -l` |
| A110 | generated skill guides (`GUIDE.md`) | 2 | `git ls-files '.claude/skills/*/GUIDE.md' \| wc -l` |
| A111 | replay scripts | 181 | `git ls-files 'tests/replays/*.rpl' \| wc -l` |
| A112 | tracked MAME `.inp` recording artifacts | 21 | `git ls-files tests/inp \| wc -l` |
| A113 | Lua instruments | 32 | `git ls-files tests/lua \| wc -l` |
| A114 | shared harness libraries | 10 | `git ls-files tests/lib \| wc -l` |
| A115 | suite runners | 4 | `ls tests/run_*.sh \| wc -l` |
| A116 | tools | 161 (135 `.py`, 26 `.sh`) | `git ls-files tools \| wc -l` ; `git ls-files tools \| sed -E 's/.*\.//' \| sort \| uniq -c` |
| A117 | build manifests (the source of every ROM byte) | 33 | `git ls-files build/manifest \| wc -l` |
| A118 | frozen doc-anchor census rows | 561 | `wc -l tests/expected/doc_anchor_census.tsv` |
| A119 | files this tree gains from the bbh extraction | 1 | `git ls-files \| grep -i bbh` → `tests/test_bbh_fidelity.sh` only |
| A120 | tracked files mentioning `bbh` | 23 | `git grep -il bbh \| wc -l` |
| A121 | tracked files mentioning `fidelity` | 19 | `git grep -il fidelity \| wc -l` |
| A122 | tracked `.md` files | 234 | `git ls-files '*.md' \| wc -l` |
| A123 | `AW-N` — a REGEX FALSE POSITIVE, not a rule scheme: Verilog bit-slices `addr[AW-1]` / `prog_addr[AW-1]` where AW is an address-width parameter | 7 occurrences in 3 files | `git grep -ohE '\[AW-[0-9]+\]' -- '*.md' '*.tsv' '*.toml' '*.py' '*.sh' '*.lua' \| wc -l` → 7 ; `git grep -lE '\[AW-[0-9]+\]' -- '*.md' …` → `STATE_HISTORY.md`, `docs/platform/gotchas.md`, `docs/platform/mister.md` |
| A124 | `RH-N` — a LIVE CROSS-REPO scheme: the external `romhacking-methodology` skill, cited but never defined here | 43 files, 72 occurrences, 24 distinct IDs | `git grep -lE 'RH-[0-9]+' \| wc -l` → 43 ; `git grep -ohE 'RH-[0-9]+' \| wc -l` → 72 ; `git grep -ohE 'RH-[0-9]+' \| sort -u \| wc -l` → 24 |
| A125 | distinct `RH-N` IDs cited OUTSIDE the history archives (the live citation set) | 18 | `git grep -ohE 'RH-[0-9]+' -- ':!*_HISTORY.md' ':!*_history.md' \| sort -uV` → RH-2 8 9 11 14 15 17 18 19 23 25 26 27 43 44 48 49 58 |
| A126 | bracketed `[RH-N]` occurrences in the A19 scope (why A19 counted only 1) | 1 | `git grep -nE '\[RH-[0-9]+\]' -- '*.md' '*.tsv' '*.toml' '*.py' '*.sh' '*.lua'` → `tests/test_skill_guides.sh:16` `[RH-9]`; the 4 SKILL.md headers use the PLACEHOLDER form `[RH-NN]`, which no `[0-9]+` regex matches |
| A127 | gate scripts tracked, TOP LEVEL ONLY — the real gate count, equal to A22 (in-tree) and A24 (index rows) | 311 | `git ls-files 'tests/*.sh' \| grep -vc '^tests/.*/'` |

## B. Items

| id | kind | item | source | row-provenance |
|---|---|---|---|---|
| V-R1 | R | [CPE-1] → lifted to level 0 as [MFI-1] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:52 | gen:G1 |
| V-R2 | R | [CPE-2] → lifted to level 0 as [MFI-2] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:84 | gen:G1 |
| V-R3 | R | [CPE-3] → lifted to level 0 as [MFI-3] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2180 | gen:G1 |
| V-R4 | R | [CPE-4] → lifted to level 0 as [MFI-4] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:167 | gen:G1 |
| V-R5 | R | [CPE-5] → lifted to level 0 as [MFI-5] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:180 | gen:G1 |
| V-R6 | R | [CPE-6] → lifted to level 0 as [MFI-6] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:608 | gen:G1 |
| V-R7 | R | [CPE-7] → lifted to level 0 as [MFI-7] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1864 | gen:G1 |
| V-R8 | R | [CPE-8] → lifted to level 0 as [MFI-8] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:646 | gen:G1 |
| V-R9 | R | [CPE-9] → lifted to level 0 as [MFI-9] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:671 | gen:G1 |
| V-R10 | R | [CPE-10] → lifted to level 0 as [MFI-10] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:695 | gen:G1 |
| V-R11 | R | [CPE-11] → lifted to level 0 as [MFI-11] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:717 | gen:G1 |
| V-R12 | R | [CPE-12] → lifted to level 0 as [MFI-12] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:206 | gen:G1 |
| V-R13 | R | [CPE-13] → lifted to level 0 as [MFI-13] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:458 | gen:G1 |
| V-R14 | R | [CPE-14] → lifted to level 0 as [MFI-14] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1937 | gen:G1 |
| V-R15 | R | [CPE-15] → lifted to level 0 as [MFI-15] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:388 | gen:G1 |
| V-R16 | R | [CPE-16] → lifted to level 0 as [MFI-16] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:962 | gen:G1 |
| V-R17 | R | [CPE-17] → lifted to level 0 as [MFI-17] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:573 | gen:G1 |
| V-R18 | R | [CPE-18] → lifted to level 0 as [MFI-18] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:590 | gen:G1 |
| V-R19 | R | [CPE-19] → lifted to level 0 as [MFI-19] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2168 | gen:G1 |
| V-R20 | R | [CPE-20] → lifted to level 0 as [MFI-20] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1956 | gen:G1 |
| V-R21 | R | [CPE-21] → lifted to level 0 as [MFI-21] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2086 | gen:G1 |
| V-R22 | R | [CPE-22] → lifted to level 0 as [MFI-22] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:331 | gen:G1 |
| V-R23 | R | [CPE-23] → lifted to level 0 as [MFI-23] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:359 | gen:G1 |
| V-R24 | R | [CPE-24] → lifted to level 0 as [MFI-24] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | HANDOFF.md:187 | gen:G1 |
| V-R25 | R | [CPE-25] → lifted to level 0 as [MFI-25] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2055 | gen:G1 |
| V-R26 | R | [CPE-26] → lifted to level 0 as [MFI-26] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:59 | gen:G1 |
| V-R27 | R | [CPE-27] → lifted to level 0 as [MFI-27] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:69 | gen:G1 |
| V-R28 | R | [CPE-28] → lifted to level 0 as [MFI-28] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:295 | gen:G1 |
| V-R29 | R | [CPE-29] → lifted to level 0 as [MFI-29] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:466 | gen:G1 |
| V-R30 | R | [CPE-30] → lifted to level 0 as [MFI-30] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:283 | gen:G1 |
| V-R31 | R | [CPE-31] → lifted to level 0 as [MFI-31] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2129 | gen:G1 |
| V-R32 | R | [CPE-32] → lifted to level 0 as [MFI-32] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | HANDOFF.md:49 | gen:G1 |
| V-R33 | R | [CPE-33] → lifted to level 0 as [MFI-33] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1974 | gen:G1 |
| V-R34 | R | [CPE-34] → lifted to level 0 as [MFI-34] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:748 | gen:G1 |
| V-R35 | R | [CPE-35] → lifted to level 0 as [MFI-35] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2004 | gen:G1 |
| V-R36 | R | [CPE-36] → lifted to level 0 as [MFI-36] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/project/gotchas.md:749 | gen:G1 |
| V-R37 | R | [CPE-37] → lifted to level 0 as [MFI-37] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:853 | gen:G1 |
| V-R38 | R | [CPE-38] → lifted to level 0 as [MFI-38] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2017 | gen:G1 |
| V-R39 | R | [CPE-39] → lifted to level 0 as [MFI-39] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:2033 | gen:G1 |
| V-R40 | R | [CPE-40] → lifted to level 0 as [MFI-40] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | HANDOFF.md:948 | gen:G1 |
| V-R41 | R | [CPE-41] → lifted to level 0 as [MFI-41] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | HANDOFF.md:1080 | gen:G1 |
| V-R42 | R | [CPE-42] → lifted to level 0 as [MFI-42] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:987 | gen:G1 |
| V-R43 | R | [CPH-1] → lifted to level 0 as [MFI-43] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:32 | gen:G1 |
| V-R44 | R | [CPH-2] **The program zips store CODE encrypted; only DATA reads bypass the crypt.** Any static analysis of code — diffing against stock, d… | docs/platform/gotchas.md:194 | gen:G1 |
| V-R45 | R | [CPH-3] **PC-relative operand reads are PROGRAM-space and DECRYPTED; `(An)`-based reads are DATA-space and raw.** Pick the view by the READ… | docs/platform/gotchas.md:226 | gen:G1 |
| V-R46 | R | [CPH-4] **Anything fetched through the opcode space must be written as CODE wherever it lands — instructions AND every pc-relatively-read t… | docs/platform/gotchas.md:941 | gen:G1 |
| V-R47 | R | [CPH-5] **When a table's view is in doubt, DECODE BOTH VIEWS and keep the one whose targets land on real code/data** — a pc-rel WORD JUMP T… | docs/platform/gotchas.md:632 | gen:G1 |
| V-R48 | R | [CPH-6] **Relocating a pc-relative DISPATCHER: carry a copy of its table INSIDE the thunk body** (emitted as code, so it re-encrypts with i… | docs/platform/gotchas.md:129 | gen:G1 |
| V-R49 | R | [CPH-7] **The encrypted range is INCLUSIVE of its upper word** — the limit test is `<=` on the word address in both this project's cipher a… | docs/platform/gotchas.md:429 | gen:G1 |
| V-R50 | R | [CPH-8] **Code above the encryption window is stored RAW, automatically and by the cipher's range-awareness** — which is what makes an exte… | docs/platform/gotchas.md:444 | gen:G1 |
| V-R51 | R | [CPH-9] **Gfx simms are NOT tile-contiguous**: a tile's 32 bytes are sixteen two-byte pairs at stride 4, the even/odd word streams of each… | docs/platform/gotchas.md:151 | gen:G1 |
| V-R52 | R | [CPH-10] **Compose a tile address the way the hardware does — `code \| ((y & 0x6000) << 3)` — BEFORE dumping it, and print the composition.… | docs/platform/gotchas.md:546 | gen:G1 |
| V-R53 | R | [CPH-11] **Within each 8-pixel half of an OBJ tile row, plane bit `i` is pixel `7-i`; the transparent pen is 15, not 0; an OBJ entry at `(x… | docs/platform/gotchas.md:1033 | gen:G1 |
| V-R54 | R | [CPH-12] → lifted to level 0 as [MFI-44] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:524 | gen:G1 |
| V-R55 | R | [CPH-13] → lifted to level 0 as [MFI-45] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/project/cps2_wide.md:28 | gen:G1 |
| V-R56 | R | [CPH-14] **OBJ y-word bit 15 is the sprite-list TERMINATOR, not a spare bit** — set it on a sprite and every later sprite is dropped. Befor… | docs/platform/gotchas.md:251 | gen:G1 |
| V-R57 | R | [CPH-15] **The CPS-2 Turbo rule is the precedent for a 19th tile-address bit: promote y bit 12 into bit 15 AFTER the terminator check, then… | docs/project/cps2_wide.md:86 | gen:G1 |
| V-R58 | R | [CPH-16] **OBJ RAM is double-buffered and a dump spans BOTH pages plus several drawers' output.** Filtering entries to an expected code ban… | docs/platform/gotchas.md:216 | gen:G1 |
| V-R59 | R | [CPH-17] **Walk a structure the way the hardware walks it — terminators, bounds, buffer selection — and separate sentinels from values.** A… | docs/project/gotchas.md:761 | gen:G1 |
| V-R60 | R | [CPH-18] → lifted to level 0 as [MFI-46] (`mame-fbneo-instruments`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:779 | gen:G1 |
| V-R61 | R | [CPH-19] **A sample window must live in ONE HALF of its 64K bank** — the DSP compares the playback pointer against `end` SIGNED, so a windo… | docs/platform/gotchas.md:806 | gen:G1 |
| V-R62 | R | [CPH-20] **A copied sample window must keep the SOURCE offset's BYTE PARITY** — the members are stored pre-swapped and both emulators bytes… | docs/platform/gotchas.md:828 | gen:G1 |
| V-R63 | R | [CPH-21] **A sample record's `end` offset PLAYS — copy the INCLUSIVE window**, provably (native windows end at `0xFFFF`, which an exclusive… | docs/platform/gotchas.md:900 | gen:G1 |
| V-R64 | R | [CPH-22] **A "pure synthetic beep" IS a tight-loop sample** (a few dozen saturated bytes looping); the hardware plays samples only. Renderi… | docs/platform/gotchas.md:884 | gen:G1 |
| V-R65 | R | [CPH-23] **The loaders' shape rules bind the ROMSET, and each belongs to one implementation**: gfx members come in groups of four of equal… | docs/project/cps2_wide.md:46 | gen:G1 |
| V-R66 | R | [CPH-24] **The WIDE profile is a NAMED, VERSIONED hardware shape** — program 6 MB (the first 1 MB encrypted, the rest raw), gfx 48 MB in th… | docs/project/cps2_wide.md:5 | gen:G1 |
| V-R67 | R | [CPH-25] **`$400000-$40000F` is reserved and never allocated**: the three implementations treat READS there differently (ROM-shadowed, read… | docs/project/cps2_wide.md:442 | gen:G1 |
| V-R68 | R | [CPH-26] **Content authored into the extension is written RAW but laid out in FILE byte order** (`words_to_file_bytes(words_from_logical_by… | docs/project/cps2_wide.md:315 | gen:G1 |
| V-R69 | R | [CPH-27] **Before widening anything, MEASURE that the stock game never touches the candidate space** — zero reads of the extension windows,… | docs/project/cps2_wide.md:65 | gen:G1 |
| V-R70 | R | [CPH-28] **Inertness is not functionality.** Proving a widened path HARMLESS on stock content (bit-identical RAM and framebuffer) says noth… | docs/project/cps2_wide.md:126 | gen:G1 |
| V-R71 | R | [CPH-29] **Every emulator change under the profile is governed**: bounded and declarative, profile-gated by a separate driver entry so the… | docs/project/cps2_wide.md:189 | gen:G1 |
| V-R72 | R | [CPH-30] **The change budget is MEASURED, and an undercount is a retraction-class error.** The profile costs TWO gated blocks in the sprite… | docs/project/cps2_wide.md:177 | gen:G1 |
| V-R73 | R | [MFI-1] **Driver `logerror` lines need `-log`, not `-verbose`** — they land in `error.log` in the working directory. Where a driver logs it… | docs/platform/gotchas.md:52 | gen:G1 |
| V-R74 | R | [MFI-2] **`-debug` perturbs multi-CPU timing**: a debug run diverges from the identical non-debug run within frames (a latch phase-shifted… | docs/platform/gotchas.md:84 | gen:G1 |
| V-R75 | R | [MFI-3] **Every `-debug` watch configuration is its own TIMELINE** — two debug trace runs are not comparable to each other either. A run ca… | docs/platform/gotchas.md:2180 | gen:G1 |
| V-R76 | R | [MFI-4] **Breakpoint logging is a SAMPLER, never an inventory**: the Lua pump drops hits (four draws logged where a write-watch proved five… | docs/platform/gotchas.md:167 | gen:G1 |
| V-R77 | R | [MFI-5] **A stopped CPU keeps emitting frames**: `frame_done` fires while the debugger holds, the script's frame counter inflates past emul… | docs/platform/gotchas.md:180 | gen:G1 |
| V-R78 | R | [MFI-6] **Condition a breakpoint that drives replay input so it fires a HANDFUL of times per run**, or drive state via write taps (no stops… | docs/platform/gotchas.md:608 | gen:G1 |
| V-R79 | R | [MFI-7] **An ARMED breakpoint delays input application by a beat** whenever it stops inside the frame the replay layer was about to write —… | docs/platform/gotchas.md:1864 | gen:G1 |
| V-R80 | R | [MFI-8] **A `wpset` watchpoint is SILENTLY BLIND to every pc-relative read** (served through the OPCODES space) — which is how most dispatc… | docs/platform/gotchas.md:646 | gen:G1 |
| V-R81 | R | [MFI-9] **Watchpoint LENGTH is parsed as HEX** (`10` = sixteen). A length a harness regex rejects kills the run before the replay starts an… | docs/platform/gotchas.md:671 | gen:G1 |
| V-R82 | R | [MFI-10] **A boot-time RAM test writes EVERY byte of work RAM**, so a bare write count on any address reports phantom hits. Never assert on… | docs/platform/gotchas.md:695 | gen:G1 |
| V-R83 | R | [MFI-11] **A MAME watchpoint logs REGISTERS, not the value written**; reading "the value" off a register snapshot attributed a write to the… | docs/platform/gotchas.md:717 | gen:G1 |
| V-R84 | R | [MFI-12] **MAME Lua write taps are silently DROPPED when the driver re-installs its memory handlers** (some drivers do it right after boot)… | docs/platform/gotchas.md:206 | gen:G1 |
| V-R85 | R | [MFI-13] **Write taps must be WORD-aligned** on a 16-bit bus (tap the containing word, filter on mask/offset; byte writes arrive replicated… | docs/platform/gotchas.md:458 | gen:G1 |
| V-R86 | R | [MFI-14] **Lua READ taps observe nothing where memory is direct-mapped or served through cached pointers** — device ROM spaces, and on some… | docs/platform/gotchas.md:1937 | gen:G1 |
| V-R87 | R | [MFI-15] **`-video none` STILL creates a window that can take focus, and host keystrokes are injected into the EMULATED controls.** Prevent… | docs/platform/gotchas.md:388 | gen:G1 |
| V-R88 | R | [MFI-16] **`-aviwrite` is headless-capable but uncompressed** (gigabytes in minutes, and it slows the run past frame caps you believed in);… | docs/platform/gotchas.md:962 | gen:G1 |
| V-R89 | R | [MFI-17] **Cross-driver framebuffer CHECKSUMS are NOT comparable** — thousands of "divergent" frames between two machine configs whose bitm… | docs/platform/gotchas.md:573 | gen:G1 |
| V-R90 | R | [MFI-18] **A chained rompath makes MAME a LIAR about member identity**: a stale member resolves by hash to the PRISTINE twin in the referen… | docs/platform/gotchas.md:590 | gen:G1 |
| V-R91 | R | [MFI-19] **Palette RAM takes Lua pokes for READBACK but not for RENDERING** — a poked palette reads back changed and draws unchanged, becau… | docs/platform/gotchas.md:2168 | gen:G1 |
| V-R92 | R | [MFI-20] **MAME audits the whole board**: per-set key files and any SHARED device romset are required, and the audit lists the shared devic… | docs/platform/gotchas.md:1956 | gen:G1 |
| V-R93 | R | [MFI-21] **`git submodule add` stages the DEFAULT BRANCH, not the tag you check out afterwards**; the next `submodule update` silently rest… | docs/platform/gotchas.md:2086 | gen:G1 |
| V-R94 | R | [MFI-22] **GENie cannot handle a SPACE anywhere in the source path, and a symlink does not help** (`getcwd()` resolves through it). Build f… | docs/platform/gotchas.md:331 | gen:G1 |
| V-R95 | R | [MFI-23] **The OSD is found ONLY through pkg-config** (`REGENIE=1` after installing it — detection is baked into generated project files, a… | docs/platform/gotchas.md:359 | gen:G1 |
| V-R96 | R | [MFI-24] **Parity BEFORE the patch.** Swapping a binary changes the INSTRUMENT, not the subject: prove the UNPATCHED source build reproduce… | HANDOFF.md:187 | gen:G1 |
| V-R97 | R | [MFI-25] **`git apply` inside another repository's working tree SILENTLY SKIPS the patch and exits 0** (`$HOME` was itself a repo; `--check… | docs/platform/gotchas.md:2055 | gen:G1 |
| V-R98 | R | [MFI-26] **`make sdl2 SKIPDEPEND=1` is mandatory on a fresh clone — and it hides header AND driver edits**: after editing a driver, `touch`… | docs/platform/gotchas.md:59 | gen:G1 |
| V-R99 | R | [MFI-27] **The shared EEPROM breaks run-to-run determinism** — `$HOME` overrides do not sandbox the user config, every run shares one `.nv`… | docs/platform/gotchas.md:69 | gen:G1 |
| V-R100 | R | [MFI-28] **FBNeo matches a member by CRC FIRST, then by name; when NEITHER matches it loads 0xFF FILL and still prints `(OK)`.** A region r… | docs/platform/gotchas.md:295 | gen:G1 |
| V-R101 | R | [MFI-29] **The SDL frontend has NO `-rompath`; the flag is silently ignored** and the set reports as missing — reads as "my romset is wrong… | docs/platform/gotchas.md:466 | gen:G1 |
| V-R102 | R | [MFI-30] **Without the framebuffer knob the sprite path never runs** (`pBurnDraw` null → the object drawer is never called), so a probe in… | docs/platform/gotchas.md:283 | gen:G1 |
| V-R103 | R | [MFI-31] **A reference binary must differ from the build under test by EXACTLY ONE thing**, built from the same tree state with only the pa… | docs/platform/gotchas.md:2129 | gen:G1 |
| V-R104 | R | [MFI-32] **Instrument extensions to a frontend are frontend-only and opt-in**: scripted input/output/frame count/dumps, a per-frame framebu… | HANDOFF.md:49 | gen:G1 |
| V-R105 | R | [MFI-33] **Same inputs are NOT the same content across emulators**: a boot-phase offset of a few frames changes WHICH content runs near any… | docs/platform/gotchas.md:1974 | gen:G1 |
| V-R106 | R | [MFI-34] **Frame indices and object SLOTS do not transfer between emulators** — the allocator hands the same object a different slot on a d… | docs/platform/gotchas.md:748 | gen:G1 |
| V-R107 | R | [MFI-35] **A RAM-checksum gate is structurally BLIND to the video path** — a rendering change produces byte-identical RAM whether it draws… | docs/platform/gotchas.md:2004 | gen:G1 |
| V-R108 | R | [MFI-36] **Sound is invisible to every RAM and pixel gate** — it lives in a ring the gates mask as noise and in a second processor's pipeli… | docs/project/gotchas.md:749 | gen:G1 |
| V-R109 | R | [MFI-37] **A value fed by allocation, RNG or sound state cannot be correlated ACROSS runs** — a write tap from run A compared with a read f… | docs/platform/gotchas.md:853 | gen:G1 |
| V-R110 | R | [MFI-38] **A canary changes exactly ONE thing or it answers nothing.** When a ROM edit would also change game logic, change the EMULATOR un… | docs/platform/gotchas.md:2017 | gen:G1 |
| V-R111 | R | [MFI-39] **A relocation test with no negative control proves nothing** — "I moved X and nothing changed" was also true with X pointed at ze… | docs/platform/gotchas.md:2033 | gen:G1 |
| V-R112 | R | [MFI-40] **"Unknown system" is an EMULATOR problem, not a ROM problem** — renaming the zip to force a load is actively harmful (the wrong d… | HANDOFF.md:948 | gen:G1 |
| V-R113 | R | [MFI-41] **What a machine migration puts at risk is only the frozen MAME expectations** (absolute values; every FBNeo gate written as a liv… | HANDOFF.md:1080 | gen:G1 |
| V-R114 | R | [MFI-42] **Two builds can share a PROGRAM fingerprint and differ in every graphics and sound member** (a shippable build and its legacy-onl… | docs/platform/gotchas.md:987 | gen:G1 |
| V-R115 | R | [MFI-43] **ROM FILES in a word-swapped region are little-endian word pairs; IMAGES (opcode view, data view, emulator dumps) are the CPU's l… | docs/platform/gotchas.md:32 | gen:G1 |
| V-R116 | R | [MFI-44] **Both emulators resolve a ROM member by HASH before NAME, so a member carrying another member's pristine bytes SHADOWS it — silen… | docs/platform/gotchas.md:524 | gen:G1 |
| V-R117 | R | [MFI-45] **Descriptor CRCs: FIXED-content members carry their real CRC; VARIABLE-content members carry SENTINELS and resolve by name** — an… | docs/project/cps2_wide.md:28 | gen:G1 |
| V-R118 | R | [MFI-46] **A member's REGION layout is not its FILE layout, and a sound CPU's own address space is a THIRD thing** (split `ROM_LOAD`/`ROM_C… | docs/platform/gotchas.md:779 | gen:G1 |
| V-R119 | R | [MSC-1] → lifted to level 0 as [MJC-1] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:98 | gen:G1 |
| V-R120 | R | [MSC-2] → lifted to level 0 as [MJC-2] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1520 | gen:G1 |
| V-R121 | R | [MSC-3] → lifted to level 0 as [MJC-3] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1538 | gen:G1 |
| V-R122 | R | [MSC-4] → lifted to level 0 as [MJC-4] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:41 | gen:G1 |
| V-R123 | R | [MSC-5] → lifted to level 0 as [MJC-5] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:107 | gen:G1 |
| V-R124 | R | [MSC-6] → lifted to level 0 as [MJC-6] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1418 | gen:G1 |
| V-R125 | R | [MSC-7] → lifted to level 0 as [MJC-7] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:256 | gen:G1 |
| V-R126 | R | [MSC-8] → lifted to level 0 as [MJC-8] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:113 | gen:G1 |
| V-R127 | R | [MSC-9] → lifted to level 0 as [MJC-9] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:119 | gen:G1 |
| V-R128 | R | [MSC-10] → lifted to level 0 as [MJC-10] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:126 | gen:G1 |
| V-R129 | R | [MSC-11] → lifted to level 0 as [MJC-11] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:133 | gen:G1 |
| V-R130 | R | [MSC-12] → lifted to level 0 as [MJC-12] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:150 | gen:G1 |
| V-R131 | R | [MSC-13] → lifted to level 0 as [MJC-13] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:632 | gen:G1 |
| V-R132 | R | [MSC-14] → lifted to level 0 as [MJC-14] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:613 | gen:G1 |
| V-R133 | R | [MSC-15] → lifted to level 0 as [MJC-15] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:621 | gen:G1 |
| V-R134 | R | [MSC-16] → lifted to level 0 as [MJC-16] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:376 | gen:G1 |
| V-R135 | R | [MSC-17] → lifted to level 0 as [MJC-17] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1144 | gen:G1 |
| V-R136 | R | [MSC-18] → lifted to level 0 as [MJC-18] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:412 | gen:G1 |
| V-R137 | R | [MSC-19] → lifted to level 0 as [MJC-19] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1393 | gen:G1 |
| V-R138 | R | [MSC-20] → lifted to level 0 as [MJC-20] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_map.md:474 | gen:G1 |
| V-R139 | R | [MSC-21] **A CPS-2 tile code IS its SDRAM address**: the download scramble undoes the `.rom`'s 4-way interleave, so tile `c` lives at `c *… | docs/platform/gotchas.md:1295 | gen:G1 |
| V-R140 | R | [MSC-22] → lifted to level 0 as [MJC-22] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1314 | gen:G1 |
| V-R141 | R | [MSC-23] → lifted to level 0 as [MJC-23] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1312 | gen:G1 |
| V-R142 | R | [MSC-24] → lifted to level 0 as [MJC-24] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:438 | gen:G1 |
| V-R143 | R | [MSC-25] **GFX ROM CONTENT changes object TIMING** — the object pipeline skips its draw loop on an all-ones fetched word — so anchors are f… | docs/platform/gotchas.md:1222 | gen:G1 |
| V-R144 | R | [MSC-26] → lifted to level 0 as [MJC-26] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1550 | gen:G1 |
| V-R145 | R | [MSC-27] **Widening SDRAM does not widen the core.** The caps are FORMAT: a 16-bit tile code + a 2-bit bank from the object table's y-word… | docs/project/mister_core.md:483 | gen:G1 |
| V-R146 | R | [MSC-28] **Promote AFTER the terminator test.** y-word bit 15 is the sprite-list TERMINATOR; the CPS-2 Turbo rule promotes bit 12 into it i… | docs/project/mister_map.md:667 | gen:G1 |
| V-R147 | R | [MSC-29] → lifted to level 0 as [MJC-29] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1602 | gen:G1 |
| V-R148 | R | [MSC-30] → lifted to level 0 as [MJC-30] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:344 | gen:G1 |
| V-R149 | R | [MSC-31] → lifted to level 0 as [MJC-31] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_map.md:820 | gen:G1 |
| V-R150 | R | [MSC-32] **The CPS-2 key's encrypted-opcode RANGE word is stored COMPLEMENTED; MAME and FBNeo read it that way and the reference core reads… | docs/platform/gotchas.md:1644 | gen:G1 |
| V-R151 | R | [MSC-33] → lifted to level 0 as [MJC-33] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:598 | gen:G1 |
| V-R152 | R | [MSC-34] **"Data read from above the window" is not "code executed from above the window."** A relocation test that moves only data tables… | docs/project/mister_core.md:503 | gen:G1 |
| V-R153 | R | [MSC-35] **Rule 1 v2 has a MiSTer form for every clause**: bounded = the enumerated, frozen override set; profile-gated = the runtime bit;… | docs/project/cps2_wide.md:199 | gen:G1 |
| V-R154 | R | [MSC-36] → lifted to level 0 as [MJC-36] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:808 | gen:G1 |
| V-R155 | R | [MSC-37] → lifted to level 0 as [MJC-37] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:666 | gen:G1 |
| V-R156 | R | [MSC-38] **On CPS-2 pass `-load` on EVERY run and drop `-setname`.** The transfer latches the decryption key into core REGISTERS, so a prel… | docs/platform/gotchas.md:1072 | gen:G1 |
| V-R157 | R | [MSC-39] → lifted to level 0 as [MJC-39] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1614 | gen:G1 |
| V-R158 | R | [MSC-40] → lifted to level 0 as [MJC-40] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1114 | gen:G1 |
| V-R159 | R | [MSC-41] → lifted to level 0 as [MJC-41] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1561 | gen:G1 |
| V-R160 | R | [MSC-42] → lifted to level 0 as [MJC-42] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1090 | gen:G1 |
| V-R161 | R | [MSC-43] → lifted to level 0 as [MJC-43] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:944 | gen:G1 |
| V-R162 | R | [MSC-44] → lifted to level 0 as [MJC-44] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1498 | gen:G1 |
| V-R163 | R | [MSC-45] → lifted to level 0 as [MJC-45] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1693 | gen:G1 |
| V-R164 | R | [MSC-46] → lifted to level 0 as [MJC-46] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1433 | gen:G1 |
| V-R165 | R | [MSC-47] → lifted to level 0 as [MJC-47] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1478 | gen:G1 |
| V-R166 | R | [MSC-48] → lifted to level 0 as [MJC-48] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1201 | gen:G1 |
| V-R167 | R | [MSC-49] → lifted to level 0 as [MJC-49] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1227 | gen:G1 |
| V-R168 | R | [MSC-50] → lifted to level 0 as [MJC-50] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1250 | gen:G1 |
| V-R169 | R | [MSC-51] → lifted to level 0 as [MJC-51] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1189 | gen:G1 |
| V-R170 | R | [MSC-52] → lifted to level 0 as [MJC-52] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/gotchas.md:2899 | gen:G1 |
| V-R171 | R | [MSC-53] → lifted to level 0 as [MJC-53] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:864 | gen:G1 |
| V-R172 | R | [MSC-54] → lifted to level 0 as [MJC-54] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1122 | gen:G1 |
| V-R173 | R | [MSC-55] → lifted to level 0 as [MJC-55] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/gotchas.md:2985 | gen:G1 |
| V-R174 | R | [MSC-56] → lifted to level 0 as [MJC-56] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/gotchas.md:2968 | gen:G1 |
| V-R175 | R | [MSC-57] → lifted to level 0 as [MJC-57] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1645 | gen:G1 |
| V-R176 | R | [MSC-58] → lifted to level 0 as [MJC-58] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1822 | gen:G1 |
| V-R177 | R | [MSC-59] → lifted to level 0 as [MJC-59] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1787 | gen:G1 |
| V-R178 | R | [MSC-60] → lifted to level 0 as [MJC-60] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1829 | gen:G1 |
| V-R179 | R | [MSC-61] → lifted to level 0 as [MJC-61] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/gotchas.md:1850 | gen:G1 |
| V-R180 | R | [MSC-62] → lifted to level 0 as [MJC-62] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/release_format.md:55 | gen:G1 |
| V-R181 | R | [MSC-63] → lifted to level 0 as [MJC-63] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1529 | gen:G1 |
| V-R182 | R | [MSC-64] → lifted to level 0 as [MJC-64] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1546 | gen:G1 |
| V-R183 | R | [MSC-65] → lifted to level 0 as [MJC-65] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1554 | gen:G1 |
| V-R184 | R | [MSC-66] → lifted to level 0 as [MJC-66] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1565 | gen:G1 |
| V-R185 | R | [MSC-67] → lifted to level 0 as [MJC-67] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1576 | gen:G1 |
| V-R186 | R | [MSC-68] → lifted to level 0 as [MJC-68] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/platform/mister.md:1562 | gen:G1 |
| V-R187 | R | [MSC-69] → lifted to level 0 as [MJC-69] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_field.md:99 | gen:G1 |
| V-R188 | R | [MSC-70] **Pixels have never been compared by an instrument between the core and an emulator, and audio has never been measured** — the OBJ… | docs/project/mister_core.md:857 | gen:G1 |
| V-R189 | R | [MSC-71] **Real silicon's decryption window is INFERRED, never measured** — both emulators share the same research heritage and are not ind… | docs/project/mister_core.md:870 | gen:G1 |
| V-R190 | R | [MSC-72] → lifted to level 0 as [MJC-72] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:871 | gen:G1 |
| V-R191 | R | [MSC-73] → lifted to level 0 as [MJC-73] (`mister-jtframe-core`); the anchored paragraph is unchanged. | docs/project/mister_core.md:866 | gen:G1 |
| V-R192 | R | [MJC-1] **An extended core is a SEPARATE core directory**, `cores/<x>`, pulling shared RTL through `cfg/game.yaml`; the reference cores it… | docs/project/mister_core.md:98 | gen:G1 |
| V-R193 | R | [MJC-2] **`jtframe files` deduplicates by FULL PATH.** Overriding a shared file means REMOVING it from the list that pulled it, and a file… | docs/platform/gotchas.md:1520 | gen:G1 |
| V-R194 | R | [MJC-3] **A new jtframe module is pulled from the CORE's `game.yaml`** (`- from: sdram / get: - <file>.v`), never added to jtframe's shared… | docs/platform/gotchas.md:1538 | gen:G1 |
| V-R195 | R | [MJC-4] **The fork's delta is mirrored in-tree as a PATCH SERIES**, one file per fork commit, regenerated by the setup script and byte-comp… | docs/platform/mister.md:41 | gen:G1 |
| V-R196 | R | [MJC-5] **An extended profile is NOT a macro.** The new core's `macros.def` differs from the reference core's by `CORENAME` only — the prof… | docs/platform/mister.md:107 | gen:G1 |
| V-R197 | R | [MJC-6] **A new core missing a `$readmemh` file the reference core carries (a palette LUT, a PROM image) renders BLACK and nothing warns**… | docs/platform/gotchas.md:1418 | gen:G1 |
| V-R198 | R | [MJC-7] **A pin is a tree; a grep proves a fact about the tree you grepped.** "Feature X does not exist" from a grep over the pinned checko… | docs/project/mister_core.md:256 | gen:G1 |
| V-R199 | R | [MJC-8] **Profile selection is a RUNTIME bit in the MRA header**, decoded by one profile module into one wire that every gated site takes —… | docs/platform/mister.md:113 | gen:G1 |
| V-R200 | R | [MJC-9] **Find the free header byte by reading the CONSUMER's decoder** — the bytes that fall through every branch of the core's header-wri… | docs/platform/mister.md:119 | gen:G1 |
| V-R201 | R | [MJC-10] **`[header] fill=0xff` FORCES active-low polarity.** The fill must mean "profile off", or every stock MRA the core emits changes a… | docs/platform/mister.md:126 | gen:G1 |
| V-R202 | R | [MJC-11] **Scope the header row with `setname=`** (`RawData` embeds `Selectable`) so no other MRA gains a byte, and MEASURE the byte end to… | docs/platform/mister.md:133 | gen:G1 |
| V-R203 | R | [MJC-12] **It is a STATIC configuration bit**: written only while the ROM streams with the core in reset, constant for the whole of play, o… | docs/platform/mister.md:150 | gen:G1 |
| V-R204 | R | [MJC-13] **`[parse] sourcefile` is a SECOND profile gate, in the mapping tool.** A machine entry tagged with a sourcefile the reference cor… | docs/project/mister_core.md:632 | gen:G1 |
| V-R205 | R | [MJC-14] **Gate at BOTH ends — source and destination.** When the destination select already ANDs the profile wire, an ungated source would… | docs/project/mister_core.md:613 | gen:G1 |
| V-R206 | R | [MJC-15] **An elaboration-time parameter cannot be gated** (`SLOTn_OFFSET`, port widths). Each ungated relocation or widening is DECLARED,… | docs/project/mister_core.md:621 | gen:G1 |
| V-R207 | R | [MJC-16] **At jtcores v1.7.3, 64 MB is PHYSICAL, not a setting**: the bank-core table stops at `AW 23`; the ROW/COW ternary has no `AW=24`… | docs/platform/mister.md:376 | gen:G1 |
| V-R208 | R | [MJC-17] **`JTFRAME_SDRAM_XL` (128 MB) is upstream-only, two chips on one module selected by nCS POLARITY, and lives ONLY in the `JTFRAME_S… | docs/platform/gotchas.md:1144 | gen:G1 |
| V-R209 | R | [MJC-18] **On a DE10-Nano the dual-SDRAM pin set and the ANALOG I/O board are mutually exclusive** (`sys_analog.tcl` and `sys_dual_sdram.tc… | docs/platform/mister.md:412 | gen:G1 |
| V-R210 | R | [MJC-19] **A jtframe 8-bit SDRAM slot caps at `SDRAMW`, and past it the BUILD FAILS**: `{ {SDRAMW-AW{1'b0}}, … }` is a replication count th… | docs/platform/gotchas.md:1393 | gen:G1 |
| V-R211 | R | [MJC-20] **Offsets are ADDs** (`sdram_addr = offset + …`), elaboration-time, word-granular, with no power-of-two alignment requirement — pl… | docs/project/mister_map.md:474 | gen:G1 |
| V-R212 | R | [MJC-22] **THE SAME ART HAS THREE SIZES — live bytes < address footprint < declared region — and only the DECLARED REGION consumes an SDRAM… | docs/platform/gotchas.md:1314 | gen:G1 |
| V-R213 | R | [MJC-23] **Bank arbitration is strict `ba0 > ba1 > ba2 > ba3`** (`BAPRIO=1`), so moving a stream between banks is a SCHEDULING change as we… | docs/platform/mister.md:1312 | gen:G1 |
| V-R214 | R | [MJC-24] **Measure bank headroom BEFORE choosing a placement** — accesses/frame, row-miss rate, data-bus %, `SDRAM reads clashed` — on the… | docs/project/mister_core.md:438 | gen:G1 |
| V-R215 | R | [MJC-26] **A download-side `?:` chain has a fall-through arm more regions reach than you think**, with WRAPPED region-relative addresses. Q… | docs/platform/gotchas.md:1550 | gen:G1 |
| V-R216 | R | [MJC-29] **A widened bus is only as wide as its NARROWEST port, and Verilog says a width warning at most.** A widened bank field crossing s… | docs/platform/gotchas.md:1602 | gen:G1 |
| V-R217 | R | [MJC-30] **Validate a bit's MEANING against a second implementation, never against a commented-out guess in the reference RTL** — read the… | docs/platform/mister.md:344 | gen:G1 |
| V-R218 | R | [MJC-31] **A read-only decode extension must be checked against EVERY other decode in its window** (a write-only port qualified `!RnW` coll… | docs/project/mister_map.md:820 | gen:G1 |
| V-R219 | R | [MJC-33] **Keep a LEDGER of every gated site** (expression, file, slice) and a gate that re-reads each one VERBATIM, with exhaustive benche… | docs/project/mister_core.md:598 | gen:G1 |
| V-R220 | R | [MJC-36] **What breaks a finished core, in order of likelihood**: growth of a declared region (nowhere to go); a re-freeze of the romset (C… | docs/project/mister_core.md:808 | gen:G1 |
| V-R221 | R | [MJC-37] **Simulate in a SCRATCH CLONE outside the repo, never inside the pinned submodule** — jtsim writes `obj_dir/`, bank dumps, frames… | docs/platform/mister.md:666 | gen:G1 |
| V-R222 | R | [MJC-39] **The download CONSUMES input lines** (`sim_inputs.next()` fires from t=0 with the core in reset): shift the script by the transfe… | docs/platform/gotchas.md:1614 | gen:G1 |
| V-R223 | R | [MJC-40] **A macro named for what you want is not evidence that it does it — read the module that consumes it.** `JTFRAME_SIM_IODUMP` dumps… | docs/platform/gotchas.md:1114 | gen:G1 |
| V-R224 | R | [MJC-41] **A dump hook addresses SDRAM, not the CPU bus — a memory-map change INVALIDATES it, and a placement slice IS a memory-map change.… | docs/platform/gotchas.md:1561 | gen:G1 |
| V-R225 | R | [MJC-42] **Check NON-CONSTANCY before anything else on a new dump path**: an all-zero buffer agreed with real work RAM on 99.2% of sampled… | docs/platform/gotchas.md:1090 | gen:G1 |
| V-R226 | R | [MJC-43] **Assert the DUMP SET is complete** — every frame of the window, exact length, the address in the name — before any comparison. A… | docs/platform/mister.md:944 | gen:G1 |
| V-R227 | R | [MJC-44] **A harness that DRIVES a port asserts every bit of it, modelled or not, and an active-low port defaults to PRESSED.** Verify an i… | docs/platform/gotchas.md:1498 | gen:G1 |
| V-R228 | R | [MJC-45] **Derive an input bit map from the port's bit ORDER, then confirm it against the mirror; two data points cannot distinguish a swap… | docs/platform/gotchas.md:1693 | gen:G1 |
| V-R229 | R | [MJC-46] **Frame output OFF for any state oracle.** The harness forks a child per changed frame; a child that `exit()`s rewinds the parent'… | docs/platform/gotchas.md:1433 | gen:G1 |
| V-R230 | R | [MJC-47] **Anything that parses a jtsim log de-duplicates by the reporter's own timestamp, requires cumulative counters MONOTONIC, drops to… | docs/platform/gotchas.md:1478 | gen:G1 |
| V-R231 | R | [MJC-48] **An SDRAM read probe has slots in PAIRS on purpose**: some arm the windows under test, the others arm windows that MUST see traff… | docs/platform/mister.md:1201 | gen:G1 |
| V-R232 | R | [MJC-49] **The control shape is two legs differing by ONE BYTE — the profile byte.** Build it even when the verdict is a counter: the first… | docs/platform/mister.md:1227 | gen:G1 |
| V-R233 | R | [MJC-50] **The census asks what is IN memory; the probe asks what was READ.** `test.cpp` dumps all four banks once, the instant a FULL down… | docs/platform/mister.md:1250 | gen:G1 |
| V-R234 | R | [MJC-51] **A simulation model can be a DIFFERENT PART from the one the design targets, and it will not tell you** (the SDRAM model dropped… | docs/platform/gotchas.md:1189 | gen:G1 |
| V-R235 | R | [MJC-52] **THE INSTRUMENT PROTOCOL**: (1) separate the AUTHOR from the VERDICT — measure in one scope, judge in another; (2) prove an instr… | docs/project/gotchas.md:2899 | gen:G1 |
| V-R236 | R | [MJC-53] **VRAM is NOT a cross-implementation video oracle** — two unrelated implementations legitimately hold different palette and tilema… | docs/project/mister_core.md:864 | gen:G1 |
| V-R237 | R | [MJC-54] **Never edit a running shell script** — `sh` reads by byte offset and a comment-only edit derails a 55-minute gate at its last ste… | docs/platform/gotchas.md:1122 | gen:G1 |
| V-R238 | R | [MJC-55] **`pgrep -f` waiters match their own command line and never exit.** Wait on a recorded PID (`kill -0`) or a marker file the job wr… | docs/project/gotchas.md:2985 | gen:G1 |
| V-R239 | R | [MJC-56] **A fixture whose meaning depends on the build is a CLAIM about the build** (a replay named for what it picked three freezes ago).… | docs/project/gotchas.md:2968 | gen:G1 |
| V-R240 | R | [MJC-57] **Quartus in Docker: keep `--network host`** (without it `quartus_map` segfaults in the licence host-id code and LIES that it ran… | docs/platform/mister.md:1645 | gen:G1 |
| V-R241 | R | [MJC-58] **Fit and timing are SEPARATE verdicts.** Never report "closes timing" from one run: sweep seeds and state the SPREAD and MEDIAN a… | docs/platform/gotchas.md:1822 | gen:G1 |
| V-R242 | R | [MJC-59] **`xjtcore.sh` calls `jtseed`, which retries `--seed $RANDOM` and BREAKS ON FIRST SUCCESS.** A green build certifies "one placemen… | docs/platform/gotchas.md:1787 | gen:G1 |
| V-R243 | R | [MJC-60] **Failing paths that RESHUFFLE between seeds mean a marginal CONE, not a slow path.** Attribute against the fitted netlist (`repor… | docs/platform/gotchas.md:1829 | gen:G1 |
| V-R244 | R | [MJC-61] **A jtcores bitstream carries a `%y%m%d` build datestamp**: the same seed reproduces the PLACEMENT and TIMING exactly and a DIFFER… | docs/platform/gotchas.md:1850 | gen:G1 |
| V-R245 | R | [MJC-62] **Release policy: a shipped bitstream is built from a NAMED seed (`jtcore <core> -mister --nodbg --seed <S>`), never an `xjtcore.s… | docs/project/release_format.md:55 | gen:G1 |
| V-R246 | R | [MJC-63] **A set must exist in `$JTROOT/doc/mame.xml`** — jtframe's own REDUCED, committed, GENERATED catalogue, not a MAME `-listxml` dump… | docs/platform/mister.md:1529 | gen:G1 |
| V-R247 | R | [MJC-64] **`mra2rom` locates every zip member by CRC32 and by NOTHING ELSE** (`name` appears only in the warning text). FBNeo and MAME reso… | docs/platform/mister.md:1546 | gen:G1 |
| V-R248 | R | [MJC-65] **The zip search path is a HARD-CODED `$HOME/.mame/roms/<name>.zip`** with no flag. Stage a PRIVATE `$HOME` per run; never write i… | docs/platform/mister.md:1554 | gen:G1 |
| V-R249 | R | [MJC-66] **`parts=` puts every part of a `width>8` region inside ONE `<interleave>`, resolved to the FIRST finger claiming each lane and tr… | docs/platform/mister.md:1565 | gen:G1 |
| V-R250 | R | [MJC-67] **Region-start arithmetic has three silent traps**: the generator's `pos` counts the key region while the RTL's `bulk_addr` does n… | docs/platform/mister.md:1576 | gen:G1 |
| V-R251 | R | [MJC-68] **`jtframe mra -n` is the ROM-free mode**: no zips opened, `md5="None"`, the XML a pure function of the catalogue plus the core's… | docs/platform/mister.md:1562 | gen:G1 |
| V-R252 | R | [MJC-69] **An MRA part that does not resolve is `0xFF`-FILLED, never refused**, so a half-resolved set "runs" and shows nonsense. Check eve… | docs/project/mister_field.md:99 | gen:G1 |
| V-R253 | R | [MJC-72] **The 128 MB module's chip-select polarity is inferred from jtframe's RTL, never seen on a schematic.** If XL is ever taken, confi… | docs/project/mister_core.md:871 | gen:G1 |
| V-R254 | R | [MJC-73] **Timing closure is a SEED LOTTERY**: a shipped `.rbf` is a passing DRAW from a distribution some of whose seeds fail, not a privi… | docs/project/mister_core.md:866 | gen:G1 |
| V-R255 | R | [MSV-1] **The demand figures are merged-m6's — quote them WITH their freeze.** PRG live to `PRG:0x4D10F3` plus the 30-byte facing-alias pin… | docs/project/mister_fit.md:7 | gen:G1 |
| V-R256 | R | [MSV-2] **The roster's art is 13x every blank tile in vanilla's 32 MB put together** (6.39 MB of live group-C tiles vs 0.49 MB blank, and b… | docs/project/mister_fit.md:88 | gen:G1 |
| V-R257 | R | [MSV-3] **Two counts of "group-C live codes" circulate and are different quantities**: 52,347 codes / 6.39 MB from the as-built WRITE SET (… | docs/project/mister_core.md:165 | gen:G1 |
| V-R258 | R | [MSV-4] **The frozen extents are what a moved extent has to be re-frozen AGAINST, deliberately.** Tenant art may grow freely inside the exi… | docs/project/mister_map.md:1007 | gen:G1 |
| V-R259 | R | [MSV-5] **The map, in bytes**: bank 0 — PRG 6 MB at 0, VRAM `0x600000`, ORAM `0x640000`, work RAM `0x648000`, Z80 `0x658000`, QSound PCM-hi… | docs/project/mister_map.md:494 | gen:G1 |
| V-R260 | R | [MSV-6] **QSound is SPLIT across two banks on `pcm_addr[23]`** — stock DSP banks `0x00-0x7F` stay at bank 1 offset 0 byte-identical to stoc… | docs/project/mister_map.md:558 | gen:G1 |
| V-R261 | R | [MSV-7] **Group C is one obj bank per SDRAM bank, and the assignment is deliberate**: obj bank **4** (the three fighter bands — in-match tr… | docs/project/mister_map.md:578 | gen:G1 |
| V-R262 | R | [MSV-8] **The QSound trim is MANDATORY, not an optimisation**: mapped verbatim the WIDE `.rom` is 73,670,720 B, past the 26-bit `ioctl_addr… | docs/project/mister_map.md:303 | gen:G1 |
| V-R263 | R | [MSV-9] **Bank 0 needs SEVEN streams, and upstream's `ram1_Nslots` family stops at five**: `jtframe_ram1_7slots.v` (ruled option A, 2026-08… | docs/project/mister_map.md:604 | gen:G1 |
| V-R264 | R | [MSV-10] **The load is MEASURED on the WIDE image and it is GO — with the caveat stated**: bank 0 runs 40,717 accesses/frame through the se… | docs/platform/mister.md:1723 | gen:G1 |
| V-R265 | R | [MSV-11] **What cannot grow: the group-C ROMSET REGION.** A fifth group-C member or anything past 16 MB overflows immediately — bank 1 has… | docs/project/mister_map.md:1004 | gen:G1 |
| V-R266 | R | [MSV-12] **On `cps2w` work RAM is SDRAM bank 0 byte `0x648000`; `0x600000` — the reference core's work RAM — is VRAM there.** `tools/run_si… | docs/platform/mister.md:813 | gen:G1 |
| V-R267 | R | [MSV-13] **The `$400000-$40000F` reservation is load-bearing THREE ways**: ROM on `jtcps2w`, ROM-shadowed on FBNeo, readable registers on M… | docs/project/mister_map.md:872 | gen:G1 |
| V-R268 | R | [MSV-14] **The synthesis cannot go stale silently**: `tools/mk_mister_page.py --check` re-derives every figure `mister_core.md` states (17… | docs/project/mister_core.md:883 | gen:G1 |
| V-R269 | R | [MSV-15] **The `vsavjw` catalogue entry is `vsavj`'s VERBATIM except `sourcefile="capcom/cps2w.cpp"` (the profile gate, [MSC-13]), the desc… | docs/project/mister_map.md:413 | gen:G1 |
| V-R270 | R | [MSV-16] **EVERY romset re-freeze has a MiSTer TAIL, and it is triggered from OUTSIDE MiSTer**: a rebuild that moves one CRC needs a new fo… | docs/project/mister_core.md:816 | gen:G1 |
| V-R271 | R | [MSV-17] **The QSound extension is its OWN region `qsoundw`**, `{ name="qsoundw", skip=true }` for every other set and a single-part `parts… | docs/project/mister_map.md:361 | gen:G1 |
| V-R272 | R | [MSV-18] **ONE-ZIP PACKAGING since 14z-112**: the four patched group-A members `vm3.13m/15m/17m/19m` live INSIDE `vsavjw.zip`, no `vsav.zip… | docs/project/mister_map.md:402 | gen:G1 |
| V-R273 | R | [MSV-19] **`tools/mister_mra.sh` is the only way to make MRAs and `.rom`s**: a scratch clone, a PRIVATE `$HOME` per run ([MSC-65]), `--wide… | docs/platform/mister.md:680 | gen:G1 |
| V-R274 | R | [MSV-20] **The MiSTer release layer is `release/<name>/mister/`** (`release_format.md`, since merged-m10): the WIDE and `[STOCK CONTROL]` M… | docs/project/release_format.md:26 | gen:G1 |
| V-R275 | R | [MSV-21] **Every MRA part must resolve against the exact zips the card carries**: WIDE 31 of 31, STOCK CONTROL 22 of 22 against the pristin… | docs/project/mister_field.md:98 | gen:G1 |
| V-R276 | R | [MSV-22] **The `[STOCK CONTROL]` MRA is the superset invariant ON SILICON** — stock `vsavj` on OUR `.rbf` with byte 41 at the `0xFF` fill.… | docs/project/mister_field.md:112 | gen:G1 |
| V-R277 | R | [MSV-23] **The frozen anchors**: stock `05_timeout_idle` MAME **2146** / sim **2609** / skew **+463** ± 30 (re-measured twice after harness… | docs/platform/mister.md:901 | gen:G1 |
| V-R278 | R | [MSV-24] **The CPU opponent is the SOUND-STATE-FED LOTTERY** (`atlas/ram.md:99`) and differs between legs by construction: every P2-identit… | docs/platform/mister.md:923 | gen:G1 |
| V-R279 | R | [MSV-25] **The fetch demonstration** (`test_mister_gfxc_fetch`, one-byte control): obj bank 5 (wheel) 105 distinct codes `0x74D6-0xFE41` at… | docs/platform/mister.md:1715 | gen:G1 |
| V-R280 | R | [MSV-26] **The QSound extension is FETCHED** (`test_mister_qsound_ext`): 210,180 reads over 76 blocks in the PCM-high window, first at fram… | docs/platform/mister.md:1728 | gen:G1 |
| V-R281 | R | [MSV-27] **`test_mister_wide_inert` is THE inertness instrument**: `cps2` and `cps2w` on the same stock download, bit-identical work RAM ev… | HANDOFF.md:579 | gen:G1 |
| V-R282 | R | [MSV-28] **To reach a tenant use `36_pick_tenant_cell` (Donovan `0x13`), `37_pick_huitzil_cell` (`0x10`), `40_pick_pyron_cell` (`0x11`)** —… | docs/project/gotchas.md:2979 | gen:G1 |
| V-R283 | R | [MSV-29] **The OBJ-list oracle** (`test_mister_obj_oracle`): the promoted subset is 31 entries on both legs at the tenant anchor, ordered a… | docs/platform/mister.md:1734 | gen:G1 |
| V-R284 | R | [MSV-30] **Know the gate inventory and its cost before promising a re-run**: ci_portable `test_jtcores_twin`, `test_mister_wide_gate`, `tes… | docs/project/mister_core.md:645 | gen:G1 |
| V-R285 | R | [MSV-31] **Hardware answers what simulation cannot — pixels seen, voices heard, real SDRAM/timing/analog — and every hardware verdict so fa… | docs/project/mister_field.md:24 | gen:G1 |
| V-R286 | R | [MSV-32] **Never field-test without the control**: `[STOCK CONTROL]` on the same `.rbf`. STOCK boots + WIDE fails = OURS (highest-value rep… | docs/project/mister_field.md:106 | gen:G1 |
| V-R287 | R | [MSV-33] **Report the failure MODE, and time it**: no sync vs black vs RAM-test loop — a ~26.5 s loop (~1,580 frames at 59.6374 Hz; a phone… | docs/project/mister_field.md:134 | gen:G1 |
| V-R288 | R | [MSV-34] **FIELD REPORTS ARE RECORDINGS** (CLAUDE.md §4, ruled 14z-111): a board crash is captured FIRST as a hand-played MAME `.inp` on th… | docs/project/mister_field.md:142 | gen:G1 |
| V-R289 | R | [MSV-35] **The board is a WITNESS, not the instrument, and a board crash is not evidence about the core.** #99 — 100% on the board AND by h… | docs/project/mister_field.md:149 | gen:G1 |
| V-R290 | R | [MSV-36] **The field bundles live OUTSIDE the repo (rule 7) and their READMEs go stale**: a claim corrected in the tree does not reach `../… | docs/project/mister_field.md:162 | gen:G1 |
| V-R291 | R | [VSP-1] **THE SUPERSET INVARIANT (CLAUDE.md §1)** — every path not involving the three new characters produces frame-identical RAM to vanil… | CLAUDE.md:26 | gen:G1 |
| V-R292 | R | [VSP-2] **Rule 1 v2 (§2.1)** — emulator cores are never modified outside the ratified CPS-2 WIDE profile ([CPH-29]); the profile's two gate… | CLAUDE.md:43 | gen:G1 |
| V-R293 | R | [VSP-3] **Rule 2 (§2.2)** — no untested change survives a session; "it should be equivalent" is not a test result. Every patch, however tri… | CLAUDE.md:58 | gen:G1 |
| V-R294 | R | [VSP-4] **Rule 3 (§2.3)** — no hand-edited binaries. Output bytes come from `build/manifest/*.toml` + sources + extracted tables, and the t… | CLAUDE.md:63 | gen:G1 |
| V-R295 | R | [VSP-5] **Rule 4 (§2.4)** — every byte range is tagged VSAV / VS2 / VH2 / GEN / NEW and the atlas is updated in the SAME commit as the chan… | CLAUDE.md:67 | gen:G1 |
| V-R296 | R | [VSP-6] **Rule 5 (§2.5)** — anything that defines how a ported character plays lives in the documented tables of `docs/project/tables/`, ne… | CLAUDE.md:71 | gen:G1 |
| V-R297 | R | [VSP-7] **Rule 6 (§2.6)** — a diverging regression suite halts forward work; fixing it is the only task until green. | CLAUDE.md:75 | gen:G1 |
| V-R298 | R | [VSP-8] **Rule 7 (§2.7)** — no ROM bytes in the repo or any artifact, in any form, including excerpts pasted into docs. Rendered frames (th… | CLAUDE.md:77 | gen:G1 |
| V-R299 | R | [VSP-9] **The reference sets (§3)** — `vsavj` (Japan 970519, DECIDED, do not reopen), `vsav2`, `vhunt2` live outside the tree in `$ROMDIR`;… | CLAUDE.md:91 | gen:G1 |
| V-R300 | R | [VSP-10] **Gameplay decisions are not yours (§5)** — anything a player could feel goes to STATE "Decisions pending" with options and a reco… | CLAUDE.md:382 | gen:G1 |
| V-R301 | R | [VSP-11] **Address notation (§5)** — `PRG:0x0F1234`, `CPU:$0F1234`, `GFX:tile 0x1A2B3`, `RAM:$FF8000`; never bare hex without a namespace. | CLAUDE.md:288 | gen:G1 |
| V-R302 | R | [VSP-12] **File by the FACT (§5)** — `docs/game/` (true if the hack were abandoned), `docs/platform/` (the board and emulators), `docs/proj… | CLAUDE.md:291 | gen:G1 |
| V-R303 | R | [VSP-13] **RETRACTION DISCIPLINE (§5, standing order 14z-71)** — when a claim changes, `grep -rn` its WORDING and paraphrases across `docs… | CLAUDE.md:318 | gen:G1 |
| V-R304 | R | [VSP-14] **BUG ARCHAEOLOGY FIRST (§5, standing order 14z-75)** — before theorising about a reported defect: `git log --grep`, `git log -S`… | CLAUDE.md:348 | gen:G1 |
| V-R305 | R | [VSP-15] **Anti-hyperfocus checkpoint (§5)** — at a confirmed finding, a green suite or ~20 tool iterations on one problem, stop unprompted… | CLAUDE.md:368 | gen:G1 |
| V-R306 | R | [VSP-16] **Build conventions (§5)** — builders are Python taking `(src, out)` so they chain onto any input; every tunable is a builder flag… | CLAUDE.md:375 | gen:G1 |
| V-R307 | R | [VSP-162] **The `14z-N` session tag is the archive's LOOKUP KEY (§5)** — one SESSION (a context window, ~several a day), not a day, a miles… | CLAUDE.md:244 | gen:G1 |
| V-R308 | R | [VSP-17] **The session ritual (§5)** — begin by reading STATE (after CLAUDE.md, then HANDOFF, then NEXT_SESSION); end by updating STATE, re… | CLAUDE.md:233 | gen:G1 |
| V-R309 | R | [VSP-18] **THE PERSISTENT SUITE DOCTRINE (§4)** — every in-emulator measurement, probe or verification run during development is captured a… | CLAUDE.md:210 | gen:G1 |
| V-R310 | R | [VSP-19] **Verdict logic is itself tested (§4)** — a classifier's verdicts are validated against ground-truth scenarios before they are tru… | CLAUDE.md:223 | gen:G1 |
| V-R311 | R | [VSP-166] **Where the classifier LOOKS is validated too, and never from our own generator** — before re-targeting an instrument onto a new… | docs/project/gotchas.md:3619 | gen:G1 |
| V-R312 | R | [VSP-20] **FIELD REPORTS ARE RECORDINGS (§4, maintainer-ruled 14z-111)** — every reproducible crash a human can produce is captured FIRST a… | CLAUDE.md:189 | gen:G1 |
| V-R313 | R | [VSP-21] **STANDING PRINCIPLE: vanilla wins ties (maintainer, 2026-08-05)** — when a console port and arcade vsav differ and both would wor… | STATE.md:297 | gen:G1 |
| V-R314 | R | [VSP-22] **THE DEADNESS REGISTER's rule for a row** — a claim of the form "legacy never reaches this, so we may reuse it" is measured by AB… | STATE.md:1242 | gen:G1 |
| V-R315 | R | [VSP-23] **The register is the FIRST place to look** for any unexplained regression in vanilla assets, engine behaviour or rendering — befo… | STATE.md:1230 | gen:G1 |
| V-R316 | R | [VSP-24] **Which emulator runs which oracle (§4, corrected GitHub #78)** — MAME is the per-frame whole-corpus legacy oracle (the frozen `.m… | CLAUDE.md:113 | gen:G1 |
| V-R317 | R | [VSP-25] **Dual-track inertness means bit-identical UP TO SELECT ENTRY (ratified 14z-94, #95)** — the stock and WIDE builds carry different… | CLAUDE.md:126 | gen:G1 |
| V-R318 | R | [VSP-26] **The two FBNeo-only phase classes are FROZEN INVENTORIES, not windows (ratified 2026-08-16, #78)** — the sound work area `$FF0500… | CLAUDE.md:140 | gen:G1 |
| V-R319 | R | [VSP-27] **Hooked-build legacy comparison is live RAM under exactly the named masks (`docs/project/oracle_classes.md` v1/v2, CLAUDE.md §4's… | docs/project/oracle_classes.md:23 | gen:G1 |
| V-R320 | R | [VSP-28] **The bounded re-convergent window (`oracle_classes.md` v3) needs all four, frozen per replay** — one CONTIGUOUS divergent run, a… | docs/project/oracle_classes.md:40 | gen:G1 |
| V-R321 | R | [VSP-29] **Composite (`oracle_classes.md` v4) is the strict CONJUNCTION of flicker and window and adds NO tolerance** — every divergent run… | docs/project/oracle_classes.md:55 | gen:G1 |
| V-R322 | R | [VSP-30] **The ≥60-frame rule is INTRA-MECHANISM (`oracle_classes.md` v5, maintainer-ruled)** — it governs the tail after the last divergen… | docs/project/oracle_classes.md:70 | gen:G1 |
| V-R323 | R | [VSP-31] **THE STANDING WATCH (maintainer, 2026-07-27)** — flickers growing beyond the frozen inventory or divergences turning systematic m… | CLAUDE.md:160 | gen:G1 |
| V-R324 | R | [VSP-32] **Dual-emulator agreement for tenant content (§4)** — patched FBNeo and patched MAME must agree on the MAPPED fields of `ram.md` a… | CLAUDE.md:168 | gen:G1 |
| V-R325 | R | [VSP-33] **Test-matrix growth and the edge-case bias (§4)** — every new capability adds replays (per ported character: vs each of the 18 bo… | CLAUDE.md:185 | gen:G1 |
| V-R326 | R | [VSP-34] **A masked window is a BASIS, not a flag** — `replay.lua` skips masked bytes from the checksummed stream, so adding a window chang… | docs/project/gotchas.md:356 | gen:G1 |
| V-R327 | R | [VSP-35] **Palette CONTENT in a fade's row set is CYCLE-relevant** — data-only is not cycle-neutral; the select→VS fade runs at the VBL edg… | docs/project/gotchas.md:369 | gen:G1 |
| V-R328 | R | [VSP-36] **A self-frozen `.sha1` cannot see a legacy regression** — it answers "did this build change since I froze it", and re-freezing ma… | docs/project/gotchas.md:2174 | gen:G1 |
| V-R329 | R | [VSP-37] **A comparator's own ground-truth test can RATIFY a deviation from the ratified text** — three artifacts agreeing with each other… | docs/project/gotchas.md:46 | gen:G1 |
| V-R330 | R | [VSP-38] **Moving a frozen ONSET frame can silently cross a verification-class boundary** — an onset shift of one frame re-dated ~30 compos… | docs/project/gotchas.md:3264 | gen:G1 |
| V-R331 | R | [VSP-39] **A hook on a hot shared path can flip a frame-boundary parity PERMANENTLY** — flicker's evil twin: a marginal same-frame multi-wr… | docs/project/gotchas.md:1180 | gen:G1 |
| V-R332 | R | [VSP-40] **Build in one step, measure in another — never in one command** — a chained rebuild+check gave two contradictory verdicts on one… | docs/project/gotchas.md:1788 | gen:G1 |
| V-R333 | R | [VSP-41] **Engine hooks break whole-RAM comparison BY CONSTRUCTION** — a hook on a path vanilla executes costs cycles, interrupts land at s… | docs/project/gotchas.md:324 | gen:G1 |
| V-R334 | R | [VSP-42] **GFX and coordinate data are INVISIBLE to every RAM-basis gate** — tile ROM content, scroll/OBJ byte sharing, and ROM→OBJ coordin… | docs/project/gotchas.md:452 | gen:G1 |
| V-R335 | R | [VSP-43] **The RAM gate cannot see NEW-CHARACTER visual wrongness** — masked gates cover legacy content, the oracle compares mapped fields,… | docs/project/gotchas.md:542 | gen:G1 |
| V-R336 | R | [VSP-44] **Sound and anything leaving the 68k address space needs its own detector** ([CPE-36]) — `tests/test_don_sound.sh` exists because… | docs/project/gotchas.md:917 | gen:G1 |
| V-R337 | R | [VSP-45] **Sibling-coincident engine refs are INVISIBLE to the diff oracle, and the coincident vsavj address is usually a WRONG routine** —… | docs/project/gotchas.md:249 | gen:G1 |
| V-R338 | R | [VSP-46] **Bare-long "pointers" in 68k code are usually OPERAND PAIRS** — sibling-veto every candidate (a real pointer differs by the host… | docs/project/gotchas.md:294 | gen:G1 |
| V-R339 | R | [VSP-47] **PC-relative word tables are DATA** — record every discovered table's full extent, exclude it from the relocation heuristic, boun… | docs/project/gotchas.md:387 | gen:G1 |
| V-R340 | R | [VSP-48] **Blind long relocation over data blobs corrupts streams** — for a MIXED zone the rewrite set comes from a STRUCTURAL CLOSURE walk… | docs/project/gotchas.md:437 | gen:G1 |
| V-R341 | R | [VSP-49] **Never write an unverified gap** — a gap between known tables is not a table row; no write without a decoded consumer. Restore-bi… | docs/project/gotchas.md:502 | gen:G1 |
| V-R342 | R | [VSP-50] **Disabling a heuristic CLASS wholesale reverts load-bearing writes** — enumerate what the class actually wrote and re-port its lo… | docs/project/gotchas.md:526 | gen:G1 |
| V-R343 | R | [VSP-51] **Early generic rows can masquerade over later-understood structures** — when a structure class becomes understood (farm, dispatch… | docs/project/gotchas.md:408 | gen:G1 |
| V-R344 | R | [VSP-52] **Sibling twins can differ by ONE hoisted instruction** — when a source ref lands a few bytes past a routine head, check what the… | docs/project/gotchas.md:556 | gen:G1 |
| V-R345 | R | [VSP-53] **Fuzzy code-similarity reconciliation collapses near-identical helpers** — for helper families the identity that matters is the P… | docs/project/gotchas.md:723 | gen:G1 |
| V-R346 | R | [VSP-54] **Twin sites are paired through the DISPATCH TABLE, never by byte pattern** — decode both engines' per-seq jump tables and pair by… | docs/project/gotchas.md:1422 | gen:G1 |
| V-R347 | R | [VSP-55] **A single-shift sibling scan dies at the newcomer window's PIECEWISE structure** — group dispatch targets by their own pair delta… | docs/project/gotchas.md:1231 | gen:G1 |
| V-R348 | R | [VSP-56] **A window constant is a census, not a fact** — the newcomer-code window was Donovan-era triage and mis-classified thirteen of Hui… | docs/project/gotchas.md:1254 | gen:G1 |
| V-R349 | R | [VSP-57] **CODE-region ref fields are word-aligned by ISA; an idempotence latch on a pool-head is false mid-match** — the classifier enforc… | docs/project/gotchas.md:1275 | gen:G1 |
| V-R350 | R | [VSP-58] **A SET-NAME MISMATCH IS A FALSE GREEN** — when a build's pack flips to `vsavjw`, any probe still run with `SET=vsavj` boots the P… | docs/project/gotchas.md:1297 | gen:G1 |
| V-R351 | R | [VSP-59] **PC-relative escapes in engine-style regions are INVISIBLE to the sibling oracle and unrewritable in place** — `[[pcrel_escape_fi… | docs/project/gotchas.md:1321 | gen:G1 |
| V-R352 | R | [VSP-60] **A tenant porting SHARED regions inherits every region-scoped mechanism row those regions carry** — diff the other tenants' manif… | docs/project/gotchas.md:1386 | gen:G1 |
| V-R353 | R | [VSP-61] **A `port_patch` on a shared engine-family region fixes ONE tenant's copy** — when a new tenant imports a region, `grep 'region =… | docs/project/gotchas.md:2128 | gen:G1 |
| V-R354 | R | [VSP-62] **The four checks before rooting a code region** — bound by the sibling oracle then check what it cut (`:f` forces plain-value tab… | docs/project/porting_code_regions.md:44 | gen:G1 |
| V-R355 | R | [VSP-63] **Crypt placement: the opcode view executes, the data view is garbage** — a region below `PRG:0x100000` is stored re-encrypted; a… | docs/project/porting_code_regions.md:101 | gen:G1 |
| V-R356 | R | [VSP-64] **Put an execution breakpoint on code before attributing a symptom to it** — co-location is not causation; a region with genuinely… | docs/project/porting_code_regions.md:137 | gen:G1 |
| V-R357 | R | [VSP-65] **A ported region must CONTAIN its constants and its tables** — pc-relative data pointers are copied verbatim and resolve to `targ… | docs/project/gotchas.md:1518 | gen:G1 |
| V-R358 | R | [VSP-66] **A dead-filler classifier comparing the OPCODE view is blind to DATA** — if the siblings' DATA views of a candidate filler run ar… | docs/project/gotchas.md:1807 | gen:G1 |
| V-R359 | R | [VSP-67] **`placements.json` is a LINEAR map but the extractor auto-discovers sub-region shifts** — CORRELATE (slide the candidate source,… | docs/project/gotchas.md:1828 | gen:G1 |
| V-R360 | R | [VSP-68] **A built-image walk VERIFIES the source's structure; it never re-derives it** — a pointer-shaped heuristic is placement-dependent… | docs/project/gotchas.md:2283 | gen:G1 |
| V-R361 | R | [VSP-69] **Every TYPE/CLASS byte in a ported record indexes some engine dispatch, and the engines RENUMBERED families** — enumerate EVERY d… | docs/project/gotchas.md:3045 | gen:G1 |
| V-R362 | R | [VSP-70] **"Entry N" past the end of a word-displacement jump table is the NEXT routine's OPERAND** — compute the entry count `(first_code_… | docs/project/gotchas.md:1856 | gen:G1 |
| V-R363 | R | [VSP-71] **"16 + the same 16 repeated" is a silent tenant trap** — an aliasing guard never faults, it plays another character's data ([VSE-… | docs/project/gotchas.md:3126 | gen:G1 |
| V-R364 | R | [VSP-72] **Hole "a" is inside the crypt range; thunks with EMBEDDED DATA go to hole "b"** — placed bytes plaintext in-zip means outside the… | docs/project/gotchas.md:648 | gen:G1 |
| V-R365 | R | [VSP-73] **A slot id or a PLACED ADDRESS baked into hand-authored `thunk_hex` tracks NOTHING** — use `TT` for the tenant id and `region_sub… | docs/project/gotchas.md:1024 | gen:G1 |
| V-R366 | R | [VSP-74] **The manifest subset: no dotted table names, no arrays** — `_minitoml` and `tomllib` parse them differently per host, which made… | docs/project/gotchas.md:1114 | gen:G1 |
| V-R367 | R | [VSP-75] **Descriptor CRCs for variable-content members are SENTINELS** — a real member's CRC or the fill member's CRC resolves BY HASH ont… | docs/project/gotchas.md:1150 | gen:G1 |
| V-R368 | R | [VSP-76] **An output dir that different modes populate differently is cleaned per build** — stale members were re-packed by a glob for a ge… | docs/project/gotchas.md:1167 | gen:G1 |
| V-R369 | R | [VSP-77] **Exactly one writer per WORD** — `patch_prg.py` hard-fails on overlap naming both ops (`tests/test_patch_overlap.sh`); a section… | docs/project/gotchas.md:1203 | gen:G1 |
| V-R370 | R | [VSP-78] **The tile-placement pool is block-aware first-fit — carving cells out CASCADES the allocation** — fixed-position tile needs alloc… | docs/project/gotchas.md:670 | gen:G1 |
| V-R371 | R | [VSP-79] **"Inside the placed band window" is NOT "overwritten"** — the placement inside the bound is SPARSE; decide survival by intersecti… | docs/project/gotchas.md:1098 | gen:G1 |
| V-R372 | R | [VSP-80] **In-place substitution has invisible slot dependencies** — every per-slot value the host already had RIGHT becomes a defect when… | docs/project/gotchas.md:1132 | gen:G1 |
| V-R373 | R | [VSP-81] **A record's BANK is a property of the DRAWING OBJECT, not of the record** — attribute by breakpointing the OBJ format handlers an… | docs/project/gotchas.md:421 | gen:G1 |
| V-R374 | R | [VSP-82] **The A5-relative work-var displacements differ between engines** — a ported damage applier staging into vs2's offsets ticks, comb… | docs/game/gotchas.md:73 | gen:G1 |
| V-R375 | R | [VSP-83] **A ported region whose consumers index NEGATIVELY needs headroom below its base** — never allocate it at the bottom of `wide_ext`… | docs/project/gotchas.md:1602 | gen:G1 |
| V-R376 | R | [VSP-84] **Route objects to a ported machine on facts baked at BUILD time** — dispatch-time owner reads are transient at spawn instants (re… | docs/project/gotchas.md:1987 | gen:G1 |
| V-R377 | R | [VSP-85] **The discriminator for a ported machine is PER-EFFECT, not per-hit or per-character** — a stamp at a victim-spawn site serving ev… | docs/project/gotchas.md:1500 | gen:G1 |
| V-R378 | R | [VSP-86] **An "owner-gated" thunk on a shared routine is not scoped by owner alone** — sibling effect families share subtypes, so enumerate… | docs/project/gotchas.md:1445 | gen:G1 |
| V-R379 | R | [VSP-87] **Per-char dispatch on a COMMON seq state needs the target flow's FULL closure first, and a "cold" site can be legacy-hot** — an o… | docs/project/gotchas.md:1403 | gen:G1 |
| V-R380 | R | [VSP-88] **A stamp census must enumerate WRITE FORMS** — the `move.b #imm,(d16,An)` form hid ~26 stamp sites behind a one-form scan; `tools… | docs/project/gotchas.md:2021 | gen:G1 |
| V-R381 | R | [VSP-89] **Sampled uniformity is not uniformity** — disassemble ALL N sibling cases and diff them before synthesising N parallel engine cas… | docs/project/gotchas.md:707 | gen:G1 |
| V-R382 | R | [VSP-90] **"Run once at match start" is a TIMING TRAP** — char-init, the first per-frame tick and `$FF8004` all fire during the VS screen;… | docs/project/gotchas.md:574 | gen:G1 |
| V-R383 | R | [VSP-91] **A 0x7xx sfx id's faithfulness is a property of its CONTENT, not its number** — before a `stubbed_sound` row or a sample-port pla… | docs/project/gotchas.md:2150 | gen:G1 |
| V-R384 | R | [VSP-92] **The tenant manifest's slot-row vocabulary is how a row states its tenant behaviour** — `[[tenant]]` normalises into the legacy `… | docs/project/tenant_manifest.md:130 | gen:G1 |
| V-R385 | R | [VSP-93] **The hardening register is maintained in the SAME commit as any change to its classes** — the rule-4 partition (VANILLA / PATCHED… | docs/project/hardening_register.md:278 | gen:G1 |
| V-R386 | R | [VSP-94] **Every frozen build is git-tagged `freeze/<name>`** (annotated, fingerprint + reproduction in the message) and gets a registry ro… | HANDOFF.md:1374 | gen:G1 |
| V-R387 | R | [VSP-95] **A profile bump invalidates every frozen build as a REFERENCE (not as a record), and a re-freeze re-points every gate that names… | docs/project/gotchas.md:2341 | gen:G1 |
| V-R388 | R | [VSP-96] **Build-dir policy: keep CURRENT + ONE BACK per track, and before deleting grep FOUR places** — `tests/` and `tools/` excluding co… | docs/project/build_dir_triage.md:36 | gen:G1 |
| V-R389 | R | [VSP-97] **"Tracked" build dirs are only PARTLY tracked** — a gate whose fixture is an old build dir depends on UNTRACKED generator outputs… | docs/project/build_dir_triage.md:62 | gen:G1 |
| V-R390 | R | [VSP-98] **Recordings: tracked the moment they have a consumer, deleted the moment they have none** — `grep -rn <name> tests tools docs HAN… | docs/project/build_dir_triage.md:23 | gen:G1 |
| V-R391 | R | [VSP-99] **`patch_index.md` is the REGISTRY, updated in the same commit as any patch change** — status, dependencies, exclusivity, deprecat… | docs/project/patch_index.md:3 | gen:G1 |
| V-R392 | R | [VSP-100] **A release is ONE DIRECTORY PER PLATFORM, each self-sufficient, with no ROM bytes** — `release/<name>/{fbneo,mame,mister}/` from… | HANDOFF.md:248 | gen:G1 |
| V-R393 | R | [VSP-101] **THE PRE-COMMIT COMMAND is `tests/run_all_static.sh`, not a filename** — the portable tier is ROM-free (~1 min), `ROMDIR=...` ad… | HANDOFF.md:1133 | gen:G1 |
| V-R394 | R | [VSP-164] **THE EMULATOR-TIER COMMAND is `tests/run_all_emulator.sh`, and `tests/ci_emulator.tsv` is where a release's emulator scope is DE… | HANDOFF.md:1174 | gen:G1 |
| V-R395 | R | [VSP-165] **A FROZEN EXPECTATION MUST SAY WHERE ITS NUMBERS CAME FROM, and a gate's HEADER must state the default its CODE uses** — `tests/… | HANDOFF.md:1253 | gen:G1 |
| V-R396 | R | [VSP-176] **A `${VAR:?}` demand after an armed EXIT trap EXITS 0 on macOS bash 3.2 — a gate that never ran reads as PASS to an exit-status… | docs/project/gotchas.md:3690 | gen:G1 |
| V-R397 | R | [VSP-177] **A comment never follows a line-continuation backslash** — `cmd \|\| \   # note` makes the escaped space an EMPTY command and th… | docs/project/gotchas.md:3721 | gen:G1 |
| V-R398 | R | [VSP-178] **A frozen expectation FOLLOWS whatever moves it, whatever the gate's cadence says** — a `bitstream`-cadence gate may freeze noth… | docs/project/gotchas.md:3749 | gen:G1 |
| V-R399 | R | [VSP-102] **Close stdin when looping a gate list** (`</dev/null`) — a gate that reads stdin swallows the rest of the list, and a 32-entry r… | HANDOFF.md:1292 | gen:G1 |
| V-R400 | R | [VSP-103] **A gate that is not in the battery can sit FAILING for sessions** — when a freeze changes design semantics, grep `tests/` for ev… | docs/project/gotchas.md:1366 | gen:G1 |
| V-R401 | R | [VSP-104] **A self-test's deliberate FAIL must never write into the shared evidence path** — stubbed failures preserved to `build/gate_fail… | docs/project/gotchas.md:2825 | gen:G1 |
| V-R402 | R | [VSP-105] **Propagate a builder's status: redirect, never pipe through `tail`; and assert the rompath exists before measuring it** — a reje… | docs/project/gotchas.md:608 | gen:G1 |
| V-R403 | R | [VSP-106] **A rompath is a SEARCH PATH — name the set you actually built** — `build_fingerprint.py` without `--set` fell through to `$ROMDI… | docs/project/gotchas.md:781 | gen:G1 |
| V-R404 | R | [VSP-107] **`BUILD=... tests/<gate>.sh` is SILENTLY IGNORED by positional-arg gates** — half the suite reads `${BUILD:-}` and half `${1:-}`… | docs/project/gotchas.md:3107 | gen:G1 |
| V-R405 | R | [VSP-108] **Canonicalise every path argument at the top and print the resolved fingerprint of what was actually opened** — a repo-relative… | docs/project/gotchas.md:2611 | gen:G1 |
| V-R406 | R | [VSP-109] **A gate must not depend on the caller's environment** — a relative `ROMDIR` failed two gates that resolve from another cwd; pyth… | docs/project/gotchas.md:2643 | gen:G1 |
| V-R407 | R | [VSP-110] **The shell traps that fail silently and leave a plausible result** — backticks inside double quotes are command substitution (wr… | docs/project/gotchas.md:2485 | gen:G1 |
| V-R408 | R | [VSP-111] **awk compares hex fields as NUMBERS when they look numeric, and macOS awk has no `and()`/`strtonum()`** — normalise widths in th… | docs/project/gotchas.md:2251 | gen:G1 |
| V-R409 | R | [VSP-112] **`grep -c ... \|\| echo 0` double-prints on zero, and a `\|\| fallback` after a pipeline reads the LAST command's status** — `n=… | docs/project/gotchas.md:2448 | gen:G1 |
| V-R410 | R | [VSP-113] **A worktree branches from a STALE `origin/main`** — `git reset --hard main` immediately after creating one, `git worktree prune`… | docs/project/gotchas.md:956 | gen:G1 |
| V-R411 | R | [VSP-114] **A verdict line may state only what its OWN branch measured** — a PASS message restating a control's conclusion kept printing un… | docs/project/gotchas.md:2395 | gen:G1 |
| V-R412 | R | [VSP-115] **A two-leg A/B that bails on leg 1 leaves leg 2's health an ASSUMPTION** — run the reference leg anyway and print MERGE-SPECIFIC… | docs/project/gotchas.md:2039 | gen:G1 |
| V-R413 | R | [VSP-116] **A pre-armed attribution is a hypothesis** — comments and headers may carry predictions; the printed verdict carries only what w… | docs/project/gotchas.md:1974 | gen:G1 |
| V-R414 | R | [VSP-117] **The masked-basis canary corrupted the basis it verified** — an explicit `MAME_SANDBOX` is deliberate reuse, so clear a sandbox… | docs/project/gotchas.md:2219 | gen:G1 |
| V-R415 | R | [VSP-118] **`_PRG_RE` must match the WIDE extension members** — two builds differing only in extension content hashed identically until the… | docs/project/gotchas.md:805 | gen:G1 |
| V-R416 | R | [VSP-119] **RECORD YOUR SESSION** — `WIDE_RECORD=<name> tools/run_wide.sh <build> mame` records a MAME `.inp` with a fresh named nvram star… | HANDOFF.md:586 | gen:G1 |
| V-R417 | R | [VSP-120] **Forced-pick pokes on `$FF8782`/`$FF8B82` end by ~frame 1500** — the early window 1400-1500 only; pokes held later leak into the… | docs/project/gotchas.md:1335 | gen:G1 |
| V-R418 | R | [VSP-121] **The forced pick does not populate the HUD index field** — in-match HUD stagers index a SEPARATE field only the real pick flow w… | docs/project/gotchas.md:1352 | gen:G1 |
| V-R419 | R | [VSP-122] **The forced pick holds through SELECT only** — on a vs-CPU rig P2's loaded struct is rebuilt from the CPU's REAL pick, so `(0x38… | docs/project/gotchas.md:2001 | gen:G1 |
| V-R420 | R | [VSP-123] **The native leg is reachable for ANY tenant screen with the same poke** — force the tenant on `vsav2` (`POKES="1400:ff8782:10;..… | HANDOFF.md:955 | gen:G1 |
| V-R421 | R | [VSP-124] **Rig grammar from the #103 hunt** — an opponent-class poke overlapping a LIVE match kills the match (window it BETWEEN matches f… | docs/project/gotchas.md:2567 | gen:G1 |
| V-R422 | R | [VSP-125] **Kill/heal pokes write BOTH HP words** — the 2-byte shape leaves white HP positive and manufactures the unjudgeable round on any… | docs/project/gotchas.md:2676 | gen:G1 |
| V-R423 | R | [VSP-126] **Probe ENTRY addresses, never the crash-line PC** — a group-0 exception pushes a mid-instruction PC no breakpoint can match, and… | docs/project/gotchas.md:1956 | gen:G1 |
| V-R424 | R | [VSP-127] **One dump directory per rig iteration, one LOG directory per leg** — `DUMPS` land beside `CHECKSUM_OUT` as `dump_<frame>_<addr>.… | docs/project/gotchas.md:2755 | gen:G1 |
| V-R425 | R | [VSP-128] **`DUMPS` windows are `;`-separated** — a comma-joined spec exits rc=3 after a full boot with no artifacts and no error text. | docs/project/gotchas.md:739 | gen:G1 |
| V-R426 | R | [VSP-129] **Cross-build A/B dumps run PROBE-FREE** — debugger overhead lands at different instruction boundaries on two builds and phase-sh… | docs/project/gotchas.md:2093 | gen:G1 |
| V-R427 | R | [VSP-130] **`-debug` fire counts do not transfer to checksum timelines** — on collision-sensitive content the debug timeline plays a differ… | docs/project/gotchas.md:2075 | gen:G1 |
| V-R428 | R | [VSP-131] **A scripted motion input is NOT the move you named** — the buffer folds leading directions, scripted strengths are not authorita… | docs/project/gotchas.md:2794 | gen:G1 |
| V-R429 | R | [VSP-132] **A 1P-arcade rig is silently pinned to the ARCADE DRAW** — any timing change re-rolls its opponent and stage, so a frozen fight-… | docs/project/gotchas.md:2845 | gen:G1 |
| V-R430 | R | [VSP-133] **A fixed-frame rig verified on ONE character whiffs on another** — reach, knockdown arcs, down windows and wake timing are per-c… | docs/project/gotchas.md:2865 | gen:G1 |
| V-R431 | R | [VSP-134] **An entry-set A/B needs a QUIET-FRAME presence profile** — an entry present far from the event is scenery (the stock-meter pips… | docs/project/gotchas.md:2810 | gen:G1 |
| V-R432 | R | [VSP-135] **Cross-emulator POSITION A/B compares RELATIVE offset, never absolute x** — the two builds sit at a fixed ~21px global shift; `p… | docs/project/gotchas.md:1758 | gen:G1 |
| V-R433 | R | [VSP-136] **Cross-game pixel A/B aligns by DISPLAYED RECORD, not frame** — the engines skew 1-2 frames, so same-frame snapshots compare dif… | docs/project/gotchas.md:597 | gen:G1 |
| V-R434 | R | [VSP-137] **A soak must assert the mechanism it exists to exercise fired** — scripted ES pairs silently fell back to LP while the DP-spam g… | docs/project/gotchas.md:693 | gen:G1 |
| V-R435 | R | [VSP-138] **Validate a fix against the reporter's EXACT input and A/B fix-on/fix-off on the reproducing replay** — snapshot every phase of… | docs/project/gotchas.md:586 | gen:G1 |
| V-R436 | R | [VSP-139] **Verify at the RENDER layer before believing the RAM layer** — `tests/lua/obj_records_dump.lua` + `snapshot_frames.lua` (both `P… | docs/project/gotchas.md:1462 | gen:G1 |
| V-R437 | R | [VSP-140] **The masked checksum samples EARLIER in the frame than dumps do, and unmasked per-frame checksums PERTURB the run** — inspect a… | docs/project/gotchas.md:483 | gen:G1 |
| V-R438 | R | [VSP-141] **A RENDER verdict from a gfx-free build is VOID** — the program-over-zero-overlay pack answers RAM questions only; palette/work-… | docs/project/gotchas.md:2724 | gen:G1 |
| V-R439 | R | [VSP-142] **Resolve `placements.json` regions PER TENANT** — a lookup hardcoding `anim` mapped two tenants through the wrong dst/src and pu… | docs/project/gotchas.md:2691 | gen:G1 |
| V-R440 | R | [VSP-143] **A cited address in a session log is a CLAIM** — grep the manifest row AND `xxd` the built image at the call site before buildin… | docs/project/gotchas.md:681 | gen:G1 |
| V-R441 | R | [VSP-144] **A pool measurement is a claim about ONE pool** — decode the dispatch walker's own base+stride from the opcode view before trust… | docs/project/gotchas.md:2111 | gen:G1 |
| V-R442 | R | [VSP-145] **A0-at-write is post-increment** — subtract the movem batch size from EVERY logged value before taking min/max of a read window;… | docs/project/gotchas.md:638 | gen:G1 |
| V-R443 | R | [VSP-146] **A same-slot "vanilla control" controls nothing** — to test "is X per-char?", the control varies the CHARACTER, not just the bui… | docs/project/gotchas.md:661 | gen:G1 |
| V-R444 | R | [VSP-147] **The `-debug` write-trace never disagreed with the non-debug dumps** — a MAME watchpoint logs REGISTERS, so a "value written" qu… | docs/project/gotchas.md:2766 | gen:G1 |
| V-R445 | R | [VSP-148] **A measurement returning a clean null is a bug report about the measurement** — capstone mnemonics carry a size suffix (compare… | docs/project/gotchas.md:980 | gen:G1 |
| V-R446 | R | [VSP-149] **Half the Lua instruments stage inputs one frame off `replay.lua`** — every divergence-attribution instrument is canonical, the… | docs/project/gotchas.md:180 | gen:G1 |
| V-R447 | R | [VSP-150] **THE OUT-OF-RANGE INDEX TOOLKIT: read the CONSEQUENCE before valuing any evidence** — `audit_index_space.py` names the danger wi… | HANDOFF.md:1318 | gen:G1 |
| V-R448 | R | [VSP-151] **The DF palette-seq block census is MEASURED, never derived from the request table** — the routine is conditional; the resolver… | HANDOFF.md:984 | gen:G1 |
| V-R449 | R | [VSP-152] **The M2a debug environment on `run_replay_guarded.sh`** — `GUARD_PROBE=<pc>` [+`GUARD_PROBE_COND`] is a conditional LOGGING brea… | HANDOFF.md:1493 | gen:G1 |
| V-R450 | R | [VSP-167] **A ported character's reference is the SOURCE GAME, and a second leg is an INSTRUMENT CHECK, never a baseline** — every throw/mo… | docs/project/gate_scoping_method.md:28 | gen:G1 |
| V-R451 | R | [VSP-168] **Check the mechanism can PRODUCE the observable, and exclude the ones it cannot** — the capture positioner writes only `+0x10/+0… | docs/project/gate_scoping_method.md:47 | gen:G1 |
| V-R452 | R | [VSP-169] **Compare the ORDERED sequence of states, not sets; assert structure and REPORT timing** — a set comparison is blind to order and… | docs/project/gate_scoping_method.md:63 | gen:G1 |
| V-R453 | R | [VSP-170] **Refuse to judge a leg that did not produce the event, and assert any RESOURCE it consumes** — an ES move with an empty meter de… | docs/project/gate_scoping_method.md:79 | gen:G1 |
| V-R454 | R | [VSP-171] **Measure the cost of widening before arguing about the sample, and re-check every constant the narrow version froze** — one vict… | docs/project/gate_scoping_method.md:97 | gen:G1 |
| V-R455 | R | [VSP-172] **Diff a strengthened gate against what it REPLACED** — widening silently dropped the arc comparison, the one assertion that had… | docs/project/gate_scoping_method.md:121 | gen:G1 |
| V-R456 | R | [VSP-173] **Capture the picture BEFORE writing the sentence about it** — a correct measurement plus an invented direction word is a false c… | docs/project/gate_scoping_method.md:130 | gen:G1 |
| V-R457 | R | [VSP-174] **A "divergence" appearing exactly on the rows with a special resolution rule is the RESOLVER** — all three tenant victims "diver… | docs/project/gate_scoping_method.md:144 | gen:G1 |
| V-R458 | R | [VSP-175] **A gate is SOLO-SPECIFIC only if a single-tenant build is the SUBJECT of its assertion — everything else runs on the MERGED buil… | docs/project/gate_scoping_method.md:156 | gen:G1 |
| V-R459 | R | [VSP-179] **When the defect class is an OMISSION, ENUMERATE — targeted testing structurally cannot reach it** — a missing or mis-scoped tab… | docs/project/gate_scoping_method.md:246 | gen:G1 |
| V-R460 | R | [VSP-180] **ANCHOR, THEN ENUMERATE** — pay the expensive measurement once to prove the cheap one predicts it, then run the cheap one over t… | docs/project/gate_scoping_method.md:262 | gen:G1 |
| V-R461 | R | [VSP-153] **A symptom grouping is a HYPOTHESIS — test it member by member, cheapest first** — write "possibly one root", ask what measureme… | docs/project/gotchas.md:1645 | gen:G1 |
| V-R462 | R | [VSP-154] **Cross-build A/B is the cheapest attribution and is routinely skipped for analysis** — every kept build plays via `tools/run_hui… | docs/project/gotchas.md:1714 | gen:G1 |
| V-R463 | R | [VSP-155] **PRIOR ART FIRST** — before porting a per-character subsystem for tenant B, read that subsystem's `engine_internals.md` section… | HANDOFF.md:1033 | gen:G1 |
| V-R464 | R | [VSP-156] **A REPLAY'S NAME IS A CLAIM ABOUT THE BUILD** — an artifact whose meaning depends on the build needs asserting like any instrume… | docs/project/gotchas.md:2945 | gen:G1 |
| V-R465 | R | [VSP-157] **Root-causing a stochastic crash: determinism first, vector+address second, history third, conditional register probe last** — k… | docs/project/gotchas.md:3087 | gen:G1 |
| V-R466 | R | [VSP-158] **Never chain "the fix" from a poke-contaminated mechanism when a field recording exists** — win-fast rigs never give a CPU oppon… | docs/project/gotchas.md:3139 | gen:G1 |
| V-R467 | R | [VSP-163] **A tenant replay is a claim about the build it was authored for, and a POSITION confound-check does not establish IDENTITY** — r… | docs/project/gotchas.md:3586 | gen:G1 |
| V-R468 | R | [VSP-159] **The four questions of any ported effect, in order** — does the host have the CLASS row (vsav ships some effect-class rows as st… | docs/project/porting_sprite_lists.md:17 | gen:G1 |
| V-R469 | R | [VSP-160] **Strip placement: inventories are SPANS, not samples** — the `--strip-tiles` shift must be 16-aligned, equal to the bias baked i… | docs/project/porting_sprite_lists.md:120 | gen:G1 |
| V-R470 | R | [VSP-161] **The order of work and the check at each step, ending with LOOKING** — class row (`test_hui_boot.sh` legacy EXACT), list-type ta… | docs/project/porting_sprite_lists.md:135 | gen:G1 |
| V-R471 | R | [VSE-1] **vsav, vsav2 and vhunt2 are three official builds of ONE engine, and their per-character / per-state tables are INDEX-ALIGNED.** B… | docs/game/atlas/character_tables.md:70 | gen:G1 |
| V-R472 | R | [VSE-2] **THE DEAD-ROW CLASS is the most common defect shape**: vsav ships table rows the newcomers need as a STUB (an `rts`, or a displace… | docs/game/engine_internals.md:39 | gen:G1 |
| V-R473 | R | [VSE-3] **Sibling-COINCIDENT values are invisible to the diff, and the coincident vsavj address is usually a WRONG routine**: engine subrou… | docs/game/gotchas.md:62 | gen:G1 |
| V-R474 | R | [VSE-4] **The A5 work-variable layouts differ between generations by a uniform shift** (the damage staging vars are one family): ported cod… | docs/game/gotchas.md:75 | gen:G1 |
| V-R475 | R | [VSE-5] **vsavj keeps byte-identical COPIES of engine code inside per-character families** (a character's private copy of the generic jump-… | docs/game/gotchas.md:368 | gen:G1 |
| V-R476 | R | [VSE-6] **Engine-generation TUNING drifts inside structurally identical twins**: hit-freeze constants, the multi-hit re-hit gate byte vs2 a… | docs/game/gotchas.md:239 | gen:G1 |
| V-R477 | R | [VSE-7] **vs2 WIDENED index consumers vsav left narrow, and every such widening is a crash waiting for a ported index**: the effect byte ma… | docs/game/engine_internals.md:2445 | gen:G1 |
| V-R478 | R | [VSE-8] **A PC on one leg does not name the same routine on the other — and SOME coincide anyway**, which is what makes it dangerous. Corre… | docs/game/engine_internals.md:3794 | gen:G1 |
| V-R479 | R | [VSE-9] **The per-character bank is a contiguous run of 32-entry tables, stride `0x80`, index-aligned across all three sets** — any table f… | docs/game/atlas/character_tables.md:82 | gen:G1 |
| V-R480 | R | [VSE-10] **The character id is 5-bit everywhere it is stored; the variant half `0x10-0x1F` has REAL storage in every layout-verified table… | docs/game/atlas/id_space.md:18 | gen:G1 |
| V-R481 | R | [VSE-11] **A register-dataflow walk cannot see a mask applied straight to a memory field** (`andi.b #$0f,$382(a4)` — the id-cycling selecto… | docs/game/atlas/id_space.md:117 | gen:G1 |
| V-R482 | R | [VSE-12] **Count a table's rows from the DATA view and the indexer's arithmetic, never from where the bytes stop looking familiar** — an al… | docs/game/gotchas.md:476 | gen:G1 |
| V-R483 | R | [VSE-13] **Reserved variant ids: `0x12` (the Gallon-variant path writes it as an immediate on the select screen) and `0x18` (Oboro Bishamon… | docs/game/atlas/id_space.md:349 | gen:G1 |
| V-R484 | R | [VSE-14] **No legacy gameplay path in the corpus writes a variant-half id** (union of all writers: `00 01 02 03 05 06 08 0A 0C 0E 0F`), whi… | docs/game/atlas/id_space.md:215 | gen:G1 |
| V-R485 | R | [VSE-15] **"Selectable" is not "fightable"**: the CPU opponent, the attract assignment and the challenger path write only P2's id, from an… | docs/game/atlas/id_space.md:262 | gen:G1 |
| V-R486 | R | [VSE-16] **Per-character table entries are PAIRS more often than they look**: a 16-character table of 8-byte (forward, back) pairs and a 32… | docs/game/gotchas.md:133 | gen:G1 |
| V-R487 | R | [VSE-17] **Match-init id normalisation folds `0x0B`/`0x1B` (the Shadow/Marionette slots) and, in vs2, maps both Oboro-class ids onto slot-8… | docs/game/atlas/character_tables.md:341 | gen:G1 |
| V-R488 | R | [VSE-18] **Every secondary object is ticked by a per-frame POOL WALKER that dispatches on the TYPE byte at slot `+0x02` through a per-pool… | docs/game/engine_internals.md:2213 | gen:G1 |
| V-R489 | R | [VSE-19] **"Never dispatched in the corpus" is not "free"**: the corpus-observed free lists are 50 and 83 indices; a pool-attributed STATIC… | docs/game/engine_internals.md:2296 | gen:G1 |
| V-R490 | R | [VSE-20] **Row 8 of the big type table is the SHARED companion machine, and vs2 rewrote its own row 8** — a newcomer's companion carries ty… | docs/game/engine_internals.md:2308 | gen:G1 |
| V-R491 | R | [VSE-21] **Type stamps have TWO forms** — a header long `move.l #$01xxTTss,(A4)` and a byte stamp `move.b #type,(2,A4)` — and a census that… | docs/game/engine_internals.md:2349 | gen:G1 |
| V-R492 | R | [VSE-22] **vanilla never seeds the secondary-object pools during a normal match; vs2 always does.** An unseeded pool makes the allocator sp… | docs/game/engine_internals.md:2521 | gen:G1 |
| V-R493 | R | [VSE-23] **The two generations' allocators differ in semantics**: a RECYCLED slot keeps stale bytes under the new object's init unless clea… | docs/game/engine_internals.md:2508 | gen:G1 |
| V-R494 | R | [VSE-24] **A shared engine routine may be reached by a ported character through a CLONE, not the vanilla copy** (the capture positioner's c… | docs/game/engine_internals.md:1862 | gen:G1 |
| V-R495 | R | [VSE-25] **Anim nodes are `0x18` bytes**: duration, flags (bit 7 = follow the LINK instead of advancing), the sprite-record pointer at +4,… | docs/game/engine_internals.md:453 | gen:G1 |
| V-R496 | R | [VSE-26] **Anim NUMBERS: facing adds `0x300`; set-anim QUEUES a (number, params) into the command ring and the DISPLAY processor resolves n… | docs/game/gotchas.md:153 | gen:G1 |
| V-R497 | R | [VSE-27] **The drawer**: object `+0x1C` → node → node+4 → the SPRITE LIST; the list's TYPE word (even, a byte-granular index) selects a han… | docs/game/atlas/sprite_lists.md:50 | gen:G1 |
| V-R498 | R | [VSE-28] **Types 4, 6 and 8 bias every emitted tile code by a GAME-SPECIFIC constant (vsav `+0x3800`, vs2 `+0x4200`) — one byte in an other… | docs/game/atlas/sprite_lists.md:157 | gen:G1 |
| V-R499 | R | [VSE-29] **Bank attribution is per-RECORD and per-LIST-TYPE, never per-character**: types 0/2/8 take the bank from the object's `+0x18`; ty… | docs/game/engine_internals.md:1663 | gen:G1 |
| V-R500 | R | [VSE-30] **Every list handler debits its declared budget from the frame's shared sprite budget and skips the WHOLE list when short** — effe… | docs/game/atlas/sprite_lists.md:100 | gen:G1 |
| V-R501 | R | [VSE-31] **OBJ record formats differ in ENTRY STRIDE** (format 2: 4-byte `(tile, attr)` entries, count at +4; format 0: 2-byte tile-only en… | docs/game/gotchas.md:15 | gen:G1 |
| V-R502 | R | [VSE-32] **Record walks that follow POINTERS miss OFFSET-COMPUTED records** (aux table + index×4): they ship with unremapped tile words and… | docs/game/gotchas.md:206 | gen:G1 |
| V-R503 | R | [VSE-33] **A multi-tile sprite walks `tile = base + row*0x10 + ((base + col) & 0x0F)` — the column wraps within the base's row of 16**: exp… | docs/game/atlas/sprite_lists.md:183 | gen:G1 |
| V-R504 | R | [VSE-34] **The per-character OBJ bank word is NOT display-only** — changing a row perturbs GAME STATE (work RAM diverges at frame 890 on an… | docs/game/gotchas.md:267 | gen:G1 |
| V-R505 | R | [VSE-35] **A character's band is NOT free once the character is replaced** — system content references tiles inside per-character bands (th… | docs/game/gotchas.md:193 | gen:G1 |
| V-R506 | R | [VSE-36] **OBJ RAM diffing traps**: entries relocate between frames ("who writes offset X" is per-frame only), stale entries past the termi… | docs/game/gotchas.md:165 | gen:G1 |
| V-R507 | R | [VSE-37] **To identify what an effect draws, diff the OBJ list before vs during, then join the two legs by TILE CONTENT — never by tile ind… | docs/game/engine_internals.md:3706 | gen:G1 |
| V-R508 | R | [VSE-38] **THE ANCHOR METHOD for "this effect does not draw"**: start from the data the effect is FORCED to read (its sprite list), read-wa… | docs/game/engine_internals.md:3666 | gen:G1 |
| V-R509 | R | [VSE-39] **Grouping by SYMPTOM sends the search after a single root that may not exist**: the four "effect does not draw" members shared th… | docs/game/engine_internals.md:3720 | gen:G1 |
| V-R510 | R | [VSE-40] **Two parallel damage APPLIERS (fighter-hit stager, object-hit applier called by 54/78 per-hit reaction handlers) feed one scaler… | docs/game/engine_internals.md:2809 | gen:G1 |
| V-R511 | R | [VSE-41] **THE ROUND JUDGE KILLS ON THE SIGN OF WHITE HP (`+0x52`), never `+0x50`** — both appliers subtract from both words and white sits… | docs/game/engine_internals.md:3040 | gen:G1 |
| V-R512 | R | [VSE-42] **The victim's reaction class byte (`+0x54`, from the hit record) indexes a pc-relative word jump table that vsav ends EARLIER tha… | docs/game/engine_internals.md:2866 | gen:G1 |
| V-R513 | R | [VSE-43] **In the hit-spark spawner `a1` is the VICTIM and `a6` the attacker**; a thunk gating on `$382(a1)` gates on the victim and never… | docs/game/gotchas.md:144 | gen:G1 |
| V-R514 | R | [VSE-44] **Capture: ONE anim node of the ATTACKER supplies both the victim's position keyframe and its pose index; the index is per VICTIM… | docs/game/engine_internals.md:2707 | gen:G1 |
| V-R515 | R | [VSE-45] **Throw arcs: the launch row comes from `table2[map1[2*subidx + d0] * 16]` writing xv/yv/xacc/gravity (16.16); vs2's `map1` carrie… | docs/game/engine_internals.md:2782 | gen:G1 |
| V-R516 | R | [VSE-46] **The command-input system**: per-character eval handlers call MOTION HELPERS (`lea <steps>(pc); bra <tracker>`), tracker dispatch… | docs/game/engine_internals.md:1004 | gen:G1 |
| V-R517 | R | [VSE-47] **A scripted motion input is NOT the move you named** — the input buffer FOLDS leading directions, a special's button must OVERLAP… | docs/game/gotchas.md:576 | gen:G1 |
| V-R518 | R | [VSE-48] **Cell index IS character id**: the navigation routine commits the TABLE-B destination byte to BOTH the cursor cell and the id fie… | docs/game/gotchas.md:294 | gen:G1 |
| V-R519 | R | [VSE-49] **TABLE B is 32 rows and the index is unmasked, so variant-half cells are addressable by construction** — vs2's table IS the roste… | docs/game/atlas/select_screen.md:183 | gen:G1 |
| V-R520 | R | [VSE-50] **The hovered cell's UI pieces come from per-piece RECORD-POINTER arrays, 32 rows per player, P2 at `+0x80` — NOT `+0x40`, which i… | docs/game/atlas/select_screen.md:795 | gen:G1 |
| V-R521 | R | [VSE-51] **Venue-asset numerology lies**: palette index ≠ character id (the 3×3 pal-07 cell is Gallon's, not Jedah's); identify cells by ME… | docs/game/gotchas.md:251 | gen:G1 |
| V-R522 | R | [VSE-52] **There is no such thing as a free palette row on a venue screen**: venue PHASES rewrite rows on a ~15 s timer (grey over grey — i… | docs/game/gotchas.md:323 | gen:G1 |
| V-R523 | R | [VSE-53] **Palette rows `0x10+` belong to the P2 CHARACTER**: attribute a row with a ROSTER-VARIED control (a different P2), not a same-ros… | docs/game/gotchas.md:222 | gen:G1 |
| V-R524 | R | [VSE-54] **"Slot-indexed cell" does not mean "slot-exclusive data"**: cell pokes are RAM-visible (menu objects store chain anchors in work… | docs/game/gotchas.md:42 | gen:G1 |
| V-R525 | R | [VSE-55] **The per-character strip zone INTERLEAVES the shared music-sequence pool**, read by the sound streamer through computed addressin… | docs/game/gotchas.md:118 | gen:G1 |
| V-R526 | R | [VSE-56] **The attract INTRO CUTSCENE is Jedah**: his per-character display sites execute on every legacy replay ~frame 888, and the same s… | docs/game/gotchas.md:101 | gen:G1 |
| V-R527 | R | [VSE-57] **Per-slot presentation assets split three ways** (`venue_assets.md`): sprite palettes are a 32-row pointer table with an unmasked… | docs/game/atlas/venue_assets.md:13 | gen:G1 |
| V-R528 | R | [VSE-58] **The win screen draws from THREE independent per-winner tables — position (CODE words, pc-relative), palette (a pool + a per-char… | docs/game/engine_internals.md:2051 | gen:G1 |
| V-R529 | R | [VSE-59] **The arcade ladder is a PAIR per rung — "fight this class, at this stage" — from two parallel 36-row tables copied into work RAM… | docs/game/engine_internals.md:260 | gen:G1 |
| V-R530 | R | [VSE-60] **The stage-banner family is addressed from an ANCHOR that is the family's first row, not the pointer table's base** — both games… | docs/game/engine_internals.md:291 | gen:G1 |
| V-R531 | R | [VSE-61] **The 68k side is id-only**: game code queues 16-byte entries into a ring, a per-frame pump sends ids to the sound board, and NO s… | docs/game/engine_internals.md:1212 | gen:G1 |
| V-R532 | R | [VSE-62] **`+0x382` is the character id ONLY at select/commit — in match it is the VOICE-FLAVOR CLASS, and the engine REASSIGNS it**: at a… | docs/game/gotchas.md:557 | gen:G1 |
| V-R533 | R | [VSE-63] **A SECOND voice family lives in the sound KERNEL**: four per-class word tables (one per voice event, a 16-entry base + a 16-entry… | docs/game/engine_internals.md:1546 | gen:G1 |
| V-R534 | R | [VSE-64] **The `+0x300` id alias is the FACING bit and natively selects a per-facing TWIN SONG that differs only in CHANNEL ALLOCATION** —… | docs/game/engine_internals.md:1451 | gen:G1 |
| V-R535 | R | [VSE-65] **The Z80 driver is NOT encrypted, and its 24-bit logical addresses are FLAT member-concat file offsets** (fixed region below `$80… | docs/game/engine_internals.md:1332 | gen:G1 |
| V-R536 | R | [VSE-66] **Stream grammar**: bytes `< 0x20` dispatch through a 32-entry pointer table (`08 n` = SAMPLE SELECT through the note table; `16`… | docs/game/engine_internals.md:1416 | gen:G1 |
| V-R537 | R | [VSE-67] **For the shared sfx library the two games use IDENTICAL ids keying the SAME sample content** (relocated in the image); a 0x7xx id… | docs/game/engine_internals.md:1239 | gen:G1 |
| V-R538 | R | [VSE-68] **DARK FORCE COSTS ONE BANKED STOCK (`+0x109`)**; with an empty meter the P+K pair is DOWNGRADED to a single button (`+0x107` = `0… | docs/game/gotchas.md:395 | gen:G1 |
| V-R539 | R | [VSE-69] **The two engines run DIFFERENT Dark Force systems**: both write `seq 0x16` and read a byte-identical per-character table; native… | docs/game/engine_internals.md:3355 | gen:G1 |
| V-R540 | R | [VSE-70] **Which DF palette-seq ids belong to whom cannot be derived from the per-character routine table** (rows sharing one routine reque… | docs/game/engine_internals.md:3181 | gen:G1 |
| V-R541 | R | [VSE-71] **Shadow/reflection SERVANTS (a class-`0x0C` trio per player) mirror the owner's animation by reading each node's +0xC word (low 1… | docs/game/engine_internals.md:3070 | gen:G1 |
| V-R542 | R | [VSE-72] **THE LEAPING PURSUIT is vsav's own** (U + any button on a knocked-down opponent): the command registers during the FALL and the f… | docs/game/engine_internals.md:3879 | gen:G1 |
| V-R543 | R | [VSE-73] **The game installs REAL handlers on every 68k exception vector**: each writes its identity to `$FF0000.w` (vector − 2), saves D0-… | docs/game/engine_internals.md:3917 | gen:G1 |
| V-R544 | R | [VSE-74] **The object-script state dispatchers (three siblings, 80-entry tables, ~0x17 distinct handlers in ONE pool, guard-chain fall-thro… | docs/game/engine_internals.md:3957 | gen:G1 |
| V-R545 | R | [VSE-75] **CPU AI: four per-class tables of script starts, 32 longs each — 16 classes THEN THE SAME 16 REPEATED (Capcom's aliasing guard)**… | docs/game/engine_internals.md:1765 | gen:G1 |
| V-R546 | R | [VSE-76] **A MODE-gated symptom needs the MODE PROVEN ENTERED** — assert the state (the flag, the resource consumed), never the input; take… | docs/game/gotchas.md:421 | gen:G1 |
| V-R547 | R | [VSE-77] **Sample a state-gated effect at the moment it gates on** — DF afterimages appear only while MOVING; the maintainer's repro steps… | docs/game/gotchas.md:380 | gen:G1 |
| V-R548 | R | [VSE-78] **A WATCHDOG REBOOT masquerades as a clean "nothing happened"**: guard clean, no tripwire, structs zeroed — and the snapshot shows… | docs/game/gotchas.md:350 | gen:G1 |
| V-R549 | R | [VSE-79] **A 1P-arcade rig is silently pinned to the ARCADE DRAW**: any timing change re-rolls its opponent and stage ([VSE-59]); a 1P-vs-C… | docs/game/engine_internals.md:3630 | gen:G1 |
| V-R550 | R | [VSE-80] **Post-match surfaces**: coarse sampling after a round end lands on the MAP/tally screens that come AFTER the win screen; buttons… | docs/game/gotchas.md:585 | gen:G1 |
| V-R551 | R | [VSE-81] **Per-character timing is per-character**: reach, knockdown arcs, down windows and wake timing all differ, so a fixed-frame rig ve… | docs/game/engine_internals.md:3895 | gen:G1 |
| V-R552 | R | [VSE-82] **Player-struct bytes `$42-$45` are SHARED SCRATCH across phases** (select override state at select; unrelated ramps in match): qu… | docs/game/atlas/select_screen.md:491 | gen:G1 |
| V-R553 | R | [VSE-83] **The attract demo runs REAL characters** (a Jedah vs Victor demo from ~frame 4278 of the long attract), so a change to a demo-fea… | docs/game/atlas/ram.md:9 | gen:G1 |
| V-R554 | R | [VSE-84] **A duration in VIDEO FRAMES is not comparable between the sibling games** — the engine periodically runs two ticks in one video f… | docs/game/gotchas.md:689 | gen:G1 |
| V-R555 | R | [VSE-85] **Demonstrate saturation, never assume it** — a mash that presses one frame and releases one frame leaves a DEAD frame and is HALF… | docs/game/gotchas.md:758 | gen:G1 |
| V-R556 | R | VSP — `vampire-saved-port`, "level 2, this project only", 180 rules; anchors in CLAUDE.md, HANDOFF, project docs, 2 standing STATE sections | .claude/skills/vampire-saved-port/SKILL.md:6 | read |
| V-R557 | R | VSE — `vampire-savior-engine`, "level 1 for the GAME: true with no port in mind", 85 rules; anchors in `docs/game/` only | .claude/skills/vampire-savior-engine/SKILL.md:6 | read |
| V-R558 | R | MSC — `mister-cps2-wide-core`, "level 1, game-independent", 73 rules; forbids GAME_TOKENS + BUILD_TOKENS | .claude/skills/mister-cps2-wide-core/SKILL.md:6 | read |
| V-R559 | R | MJC — `mister-jtframe-core`, "level 0, board-agnostic", 63 rules; lifts MSC-N keeping the NUMBER; forbids + BOARD_TOKENS | .claude/skills/mister-jtframe-core/SKILL.md:6 | read |
| V-R560 | R | MFI — `mame-fbneo-instruments`, "level 0, board-agnostic", 46 rules; lifts CPE-N keeping the NUMBER (+ CPH-1/12/13/18) | .claude/skills/mame-fbneo-instruments/SKILL.md:6 | read |
| V-R561 | R | CPE — `cps2-emulation`, "level 1, game-independent", 42 rules, ALL of them REDIRECTS to MFI since 14z-134 | .claude/skills/cps2-emulation/SKILL.md:6 | read |
| V-R562 | R | MSV — `mister-vampire-saved`, "level 2, dies with the project", 36 rules | .claude/skills/mister-vampire-saved/SKILL.md:6 | read |
| V-R563 | R | CPH — `cps2-hardware`, "level 1, game-independent", 30 rules | .claude/skills/cps2-hardware/SKILL.md:6 | read |
| V-C1 | C | "**THE SUPERSET INVARIANT (never violate, never weaken):** Any match, menu path, or attract sequence that does not involve the three new…" | CLAUDE.md:26 | read |
| V-C2 | C | "**THE ONE BOUNDED EXCEPTION**" — emulator cores never modified outside the ratified CPS-2 WIDE profile; bounded, declarative, profile-gated | CLAUDE.md:43 | read |
| V-C3 | C | "**No hand-edited binaries.** All ROM modifications are produced by the build pipeline from source manifests" — reproducible at any commit | CLAUDE.md:63 | read |
| V-C4 | C | "**Provenance is tracked per region.**" — every byte range tagged VSAV/VS2/VH2/GEN/NEW; the atlas updated in the SAME commit | CLAUDE.md:67 | read |
| V-C5 | C | "**Behavioral values live in documented tables, not in code.**" — rule 5, the obligation `audit_rule5.py` measures | CLAUDE.md:71 | read |
| V-C6 | C | "**No copyrighted ROM content in the repo or in any distributed artifact.**" — rule 7; rendered frames are the one ruled exception | CLAUDE.md:77 | read |
| V-C7 | C | Gate registry completeness BOTH WAYS: "a new tests/*.sh without a row here fails; a row whose script is gone fails" | tests/gate_index.tsv:2 | read |
| V-C8 | C | Sweep registry completeness both ways — `ci_emulator.tsv` enumerates the set, unregistered gates and dead rows both fail | tests/run_all_emulator.sh:24 | read |
| V-C9 | C | Expectation provenance completeness both ways: "a file with no row fails, a row naming a file that is gone fails" | tests/expected/PROVENANCE.md:4 | read |
| V-C10 | C | ONE verdict classifier, sourced by all three runners; `vs_classify <exit> <log>` → `PASS\|SKIP\|FAIL\|TIMEOUT` | tests/lib/classify.sh:1 | read |
| V-C11 | C | "**EXIT STATUS DECIDES FIRST.** A gate that prints `SKIP:` AND exits non-zero is a FAILURE, not a skip" | tests/lib/classify.sh:19 | read |
| V-C12 | C | "**THE THREE EXCEPTIONS, each written for a false green that was paid for**" — exit 124/137→TIMEOUT; shell error at exit 0→FAIL; MAME segv line | tests/lib/classify.sh:27 | read |
| V-C13 | C | Suite dispatch order: `.skip` → `.pending` (FAIL) → `.masked` → `.diverge` → `.sha1` → `NO-EXPECTATION` | tests/run_suite.sh:120 | read |
| V-C14 | C | "`.pending`: the shape has been MEASURED but its comparison class is not ratified yet… **This is a FAILURE, not a skip**" | tests/run_suite.sh:124 | read |
| V-C15 | C | `NO-EXPECTATION (freeze after review, as a STATE.md decision)` — an unfrozen replay never reads green | tests/run_suite.sh:191 | read |
| V-C16 | C | A gate's HEADER must state the default its CODE actually uses; `--fix` rewrites the mechanical ones | tests/test_header_defaults.sh:18 | read |
| V-C17 | C | The gate index is GENERATED from each script's own header sentence + `gate_index.tsv` + the two CI registries | docs/project/gate_index.md:5 | read |
| V-C18 | C | Skill lock: every rule defined once, anchored exactly once in a declared doc, every anchor defined — enforced both ways | tools/checkskills.py:183 | read |
| V-C19 | C | "a skill quotes a number only from a LOG" — every numeric token in a SKILL must appear in a declared log file | tools/checkskills.py:273 | read |
| V-C20 | C | Liftability enforcement: a forbidden token in a level-1/level-0 skill fails, named with its line | tools/checkskills.py:243 | read |
| V-C21 | C | A `**[VSP-N]**` anchor may sit in `STATE.md` ONLY in `## STANDING PRINCIPLE` / `## THE DEADNESS REGISTER` — the rest rolls over | tools/checkskills.py:94 | read |
| V-C22 | C | No anchor may live in a `_history` twin — a history file is a LOG, not an anchor home | tools/checkskills.py:269 | read |
| V-C23 | C | Every hand-written document declares its SHAPE (class, history twin, requires) and is checked against it | docs/doc_shape.tsv:1 | read |
| V-C24 | C | Load-bearing numbers shared across documents are locked by label + canonical + key regex + file list | docs/doc_locks.tsv:1 | read |
| V-C25 | C | L1 routing: README COMPLETENESS (every declared doc listed) and TWO-WAY TWINS (twin names live doc AND live doc names twin) | docs/project/living_docs_scope.md:162 | read |
| V-C26 | C | Every registry row also has an annotated git tag `freeze/<expectation-set>` at the commit that froze it | tests/expected/registry.tsv:3 | read |
| V-C27 | C | "**THE JOB MUST FAIL ON SKIP.** A gate that SKIPs for want of a fixture is not a passing gate" | .github/workflows/ci.yml:17 | read |
| V-C28 | C | The fidelity gate SKIPs when the harness is absent — "a clean checkout has no harness, which is why this is ci_static and never ci_portable" | tests/test_bbh_fidelity.sh:24 | read |
| V-C29 | C | L3 check contract: QUOTE the claim from the document (`says()`, whitespace-collapsed), DERIVE the same fact from the image, compare | HANDOFF.md:53 | read |
| V-C30 | C | "a reworded document is a STALE verdict, never a silent pass" — the L3 anti-drift clause | HANDOFF.md:53 | read |
| V-C31 | C | Frozen covered-set compared as a MULTISET so a hand-added duplicate fails | HANDOFF.md:53 | read |
| V-C32 | C | The persistent suite doctrine: every in-emulator test becomes a scripted rerunnable case before the session ends; "the suite only grows" | CLAUDE.md:210 | read |
| V-C33 | C | Auto-detecting runner: the suite FINGERPRINTS the build under test and selects expectations accordingly | CLAUDE.md:216 | read |
| V-C34 | C | Recording capture law: every reproducible crash captured FIRST as a hand-played MAME recording, BEFORE any mechanism theory | CLAUDE.md:189 | read |
| V-K1 | K | Oracle v1/v2 — "the masked basis, and the classes exact / flicker-tolerated / frozen first-divergence constant (approved 2026-07-25 and 2026-07-27)" | docs/project/oracle_classes.md:21 | read |
| V-K2 | K | Oracle v3 — "the bounded re-convergent window (approved 2026-08-05)" | docs/project/oracle_classes.md:38 | read |
| V-K3 | K | Oracle v4 — "composite (ratified 2026-08-06)" | docs/project/oracle_classes.md:53 | read |
| V-K4 | K | Oracle v5 — "the ≥60 rule is INTRA-MECHANISM (ruled 2026-08-16)" | docs/project/oracle_classes.md:68 | read |
| V-K5 | K | Oracle v6 — "the dual-track FROZEN OFFSETS (ruled 2026-09-05)" | docs/project/oracle_classes.md:89 | read |
| V-K6 | K | "Checkers and their ground truth" — the table binding each class to its checker and the evidence that ratified it | docs/project/oracle_classes.md:123 | read |
| V-K7 | K | Spec keyword `window` — 1322 of 2311 `.masked` specs | tests/expected/*.masked (A53) | read |
| V-K8 | K | Spec keyword `composite` — 596 specs | tests/expected/*.masked (A54) | read |
| V-K9 | K | Spec keyword `exact` — 192 specs | tests/expected/*.masked (A55) | read |
| V-K10 | K | Spec keyword `diverge` — 43 specs (no `.diverge` FILES are frozen; the class lives in the spec vocabulary) | tests/expected/*.masked (A56) | read |
| V-K11 | K | Spec keyword `flicker` — 42 specs | tests/expected/*.masked (A57) | read |
| V-K12 | K | `masked_check` — the shared masked comparison entry point sourced by the suite and the gates | tests/lib/masked_compare.sh:1 | read |
| V-K13 | K | `compare_flicker.py` — the flicker-tolerated class checker | tools/compare_flicker.py:1 | read |
| V-K14 | K | `compare_window.py` — the bounded re-convergent window checker | tools/compare_window.py:1 | read |
| V-K15 | K | `compare_composite.py` — the composite class checker | tools/compare_composite.py:1 | read |
| V-K16 | K | `describe_masked_shape.py` — proposes a spec line meant to drop into a `.masked` file verbatim | tools/describe_masked_shape.py:1 | read |
| V-K17 | K | `compare_fields.py` / `check_wram_dumps.py` — the field comparator and dump checker (F10's subjects) | tools/compare_fields.py:1 | read |
| V-K18 | K | The MASK basis file, one per expectation set (55 sets carry one) — the masked comparison's ground | tests/expected/*/MASK | read |
| V-T1 | T | The MUST-FIRE control convention: 74 of 311 gate scripts assert their own controls fire; PROSE ONLY, no registry, 8 spellings | tests/*.sh (A32/A34/A36) | read |
| V-T2 | T | "the claim must be measured with a POSITIVE CONTROL on the same instrument and leg (a blind instrument and a real zero look identical)" | STATE.md:1242 | read |
| V-T3 | T | `CPS2_WIDE_CANARY` — the positive control gated into the ratified WIDE profile alongside the 19-bit tile promote | CLAUDE.md:46 | read |
| V-T4 | T | The emulator superset invariant — the patched binary running stock `vsavj` reproduces the frozen vanilla expectations bit-for-bit | CLAUDE.md:49 | read |
| V-T5 | T | The deadness register's guard column — every "legacy never reaches this" claim names the gate that would catch it being wrong | STATE.md:1236 | read |
| V-T6 | T | `runs_per_replay` double-run → `NONDETERMINISTIC (first divergent frame below)` on any difference between runs | tests/run_suite.sh:143 | read |
| V-T7 | T | The fidelity gate's own control: a config copy rooted here must resolve to this tree — "the control that the input reaches the resolver" | tests/test_bbh_fidelity.sh:50 | read |
| V-T8 | T | The rule-7 entropy tripwire on untracked files, threshold 6.0 bits/byte | .github/workflows/ci.yml:125 | read |
| V-T9 | T | The CI gate-count FLOOR — "Raise it when the list grows; never lower it to make a shrunken list green" | .github/workflows/ci.yml:183 | read |
| V-T10 | T | `test_checkskills.sh` fixture prefixes `XX`/`YY`/`ZZ` + nine perturbed-copy must-fires (`MSC-999`, `CPH-999`, `VSP-999`, `MFI-999`…) | tests/test_checkskills.sh:90 | read |
| V-T11 | T | `checkdocs_rom` — 15 checks, 12 table controls, five must-fire controls, four in the gate | HANDOFF.md:53 | read |
| V-T12 | T | The saturation control — "RAISE IT and show the result does not move, and keep that as a live control so the assertions cannot go vacuous" | docs/game/gotchas.md:758 | read |
| V-T13 | T | Rot class 3's cure: "gates check their own controls and refuse a verdict when one is dead — and the fix is never to relax the control" | docs/project/harness_hardening_history.md:29 | read |
| V-D1 | D | `FLICKER_MAX = 2` — a divergent run this short or shorter is a FLICKER frame (§4 v2), RATIFIED, not a tuning knob | tools/s4_thresholds.py:36 | read |
| V-D2 | D | `RECONVERGE = 60` — identical frames required after the last divergence; v5 rules it INTRA-MECHANISM | tools/s4_thresholds.py:37 | read |
| V-D3 | D | "These are RATIFIED values. Changing one is a §4 amendment and a maintainer decision, not a tuning knob" | tools/s4_thresholds.py:31 | read |
| V-D4 | D | Entropy threshold 6.0 — "MEASURED, not the 3.0 the issue suggested"; measured spread 4.72…5.60 vs a decrypted ROM at 6.56 | .github/workflows/ci.yml:125 | read |
| V-D5 | D | CI gate floor 60 (61 registered at 14z-124, 15 at 14z-93) | .github/workflows/ci.yml:186 | read |
| V-D6 | D | `$BBH_HOME` default: beside this tree, else beside its PARENT; SKIP when absent — no submodule (decision 3) | tests/test_bbh_fidelity.sh:32 | read |
| V-D7 | D | L3 coverage denominator 346 (473 atlas addresses minus the 127 carried only by `ram.md`), ruled at the plan stage | HANDOFF.md:53 | read |
| V-D8 | D | The NOTE class — a measured number reported by the static runner's advisory block, "never fatal"; never a fifth verdict in `classify.sh` | docs/project/living_docs_scope.md:164 | read |
| V-D9 | D | `test_build_ref_rot` reports CURRENCY and never fails on it — "a superseded reference is often correct, and only the gate's author knows which" | HANDOFF_HISTORY.md:2378 | read |
| V-D10 | D | The eight harness defaults, each RULED/DECIDED with the maintainer's verbatim words, a date and a stated veto path | docs/project/harness_scope.md:418 | read |
| V-D11 | D | Per-gate default BUILD dirs — re-pointed at every freeze by the sweep; the class rot gate 4 watches | tests/test_build_ref_rot.sh:1 | read |
| V-G1 | G | `tests/ci_portable.txt` — the ROM-free tier registry (68 rows); also records which gates are EXCLUDED and why | tests/ci_portable.txt | read |
| V-G2 | G | `tests/ci_static.txt` — the static tier registry (74 rows); needs ROMDIR / build dirs, no emulator | tests/ci_static.txt | read |
| V-G3 | G | `tests/ci_emulator.tsv` — THE SWEEP REGISTRY (165 rows), read at `run_all_emulator.sh:93`, completeness both ways | tests/ci_emulator.tsv | read |
| V-G4 | G | `tests/gate_index.tsv` — family assignment, "the one hand-maintained input" (311 rows) | tests/gate_index.tsv | read |
| V-G5 | G | `docs/project/gate_index.md` — GENERATED gate index, 311 rows, currency gated by `test_gate_index_current.sh` | docs/project/gate_index.md:1 | read |
| V-G6 | G | `tests/expected/registry.tsv` — build fingerprint (program-image SHA-1) → expectation set, 70 rows, rows added only at freeze time | tests/expected/registry.tsv:1 | read |
| V-G7 | G | `tests/expected/PROVENANCE.md` — "Frozen expectations — WHERE EACH NUMBER CAME FROM", 27 data rows, opened 14z-128 | tests/expected/PROVENANCE.md:1 | read |
| V-G8 | G | `tests/expected/doc_anchor_census.tsv` — every skill anchor's FILE and SECTION, 561 lines; "A changed row is a MOVED anchor" | tests/expected/doc_anchor_census.tsv:1 | read |
| V-G9 | G | `docs/doc_shape.tsv` — 74 declared document shapes + `doc_shape_allow.tsv` exemptions | docs/doc_shape.tsv:1 | read |
| V-G10 | G | `docs/doc_locks.tsv` — 19 cross-document number locks | docs/doc_locks.tsv:1 | read |
| V-G11 | G | `docs/GOTCHAS.md` — GENERATED index, one line per bucket entry; "do not edit; regenerate" | docs/GOTCHAS.md:3 | read |
| V-G12 | G | `docs/annotations.md` — GENERATED address → carrier stream, 3023 lines; "An index, not a source" | docs/README.md:50 | read |
| V-G13 | G | `docs/project/hardening_register.md` — the crash-candidate inventory of the merged build, with a measured provenance partition | docs/project/hardening_register.md:1 | read |
| V-G14 | G | `docs/project/tables/rule5_ledger.md` — one row per session of BAKED→IN-TABLE migration; "numbers come from the tool's own NOTE lines, never from memory" | docs/project/tables/rule5_ledger.md:5 | read |
| V-G15 | G | `tests/expected/checkdocs_rom_covered.tsv` — 31 rows, the frozen L3 covered set | HANDOFF.md:53 | read |
| V-G16 | G | `docs/checksums.txt` — reference romset SHA-1s; "If checksums mismatch, stop." | CLAUDE.md:91 | read |
| V-G17 | G | `tools/checkskills.py` `SKILLS = {...}` — THE SKILL LOCK (8 rows: path, docs, logs, forbid, sections); no TOML in this tree | tools/checkskills.py:90 | read |
| V-G18 | G | `docs/project/patch_index.md` — the registry of romsets and patch ops | docs/project/patch_index.md:1 | read |
| V-F1 | F | F1 classifier — a synthetic ~25-stub fake repo, every case of both runner tests; project `run_all_static.sh --tier portable` vs `bbh-run-static` | docs/project/harness_scope.md:331 | read |
| V-F2 | F | F2 static tier, live — `ci_portable.txt` then `ci_static.txt`, verdict column per gate, tally, anti-orphan output, exit status (durations stripped) | docs/project/harness_scope.md:332 | read |
| V-F3 | F | F3 tier classifier — `tests/*.sh` (304 at the time); instrument set == sweep registry rows exactly, both unregistered lists empty | docs/project/harness_scope.md:333 | read |
| V-F4 | F | F4 sweep registry — `run_all_emulator.sh --list/--dry-run` vs `bbh-run-sweep`, placeholders expanded | docs/project/harness_scope.md:334 | read |
| V-F5 | F | F5 comparators corpus-wide — every `.masked` spec paired with a DIFFERENT set's frozen log; verdict strings diffed byte for byte | docs/project/harness_scope.md:335 | read |
| V-F6 | F | F6 fingerprint — `$ROMDIR` and every present `build/*/rompath`, all flags, plus the registry lookup's stderr NOTE | docs/project/harness_scope.md:336 | read |
| V-F7 | F | F7 suite dispatch — real expectation trees, a stub driver copying a sibling set's log, no MAME; per-replay verdict lines diffed | docs/project/harness_scope.md:337 | read |
| V-F8 | F | F8 the replay engine — real emulators, `cmp`-identical logs, every artifact incl. PNGs, the injection, both guards; "MEASURED 14z-138: EXACT" | docs/project/harness_scope.md:338 (+ the MEASURED row :339) | read |
| V-F9 | F | F9 hygiene tools — provenance, header defaults, ref rot, demand-after-trap, `gen_gate_index --check`; gate index byte-identical | docs/project/harness_scope.md:340 | read |
| V-F10 | F | F10 fields + dumps — SYNTHETIC dump directories shaped like this tree's (a hole, a window that starts true, a transient edge) | docs/project/harness_scope.md:341 | read |
| V-F11 | F | F11 the skills lock and the guide generator — 18 lines identical over the eight skills, both guides CURRENT byte for byte | docs/project/harness_scope.md:342 | read |
| V-F12 | F | The three fidelity rules: no verdict-string edit before H9; the generic classifier is the STRONGER copy; comparison is of TEXT | docs/project/harness_scope.md:321 | read |
| V-I1 | I | Rot class 1 — "**THE ORPHAN.** A gate no runner calls." Cure: a registry with completeness enforced BOTH ways, re-derived on every run | docs/project/harness_hardening_history.md:18 | read |
| V-I2 | I | Rot class 2 — "**THE SILENT DOWNGRADE.** A verdict that is quietly softened: a SKIP counted as a PASS (#29)…" Cure: the strongest signal wins | docs/project/harness_hardening_history.md:23 | read |
| V-I3 | I | Rot class 3 — "**THE DEAD CONTROL.** A must-fire control that no longer fires. This is the worst class, because it is the only one that is SILENT" | docs/project/harness_hardening_history.md:29 | read |
| V-I4 | I | Rot class 4 — "**THE STALE REFERENCE.** A default build dir, a reference binary, or a frozen constant that the tree moved past." | docs/project/harness_hardening_history.md:34 | read |
| V-I5 | I | Rot class 5 — "**THE OUTGROWN PARSER.** A consumer that reads an instrument's output by position, after the instrument gained a field." | docs/project/harness_hardening_history.md:39 | read |
| V-I6 | I | Rot class 6 — "**THE DELETED MECHANISM.** A gate that probes something a later design removed." Re-target or drop is a COVERAGE decision | docs/project/harness_hardening_history.md:43 | read |
| V-I7 | I | Rot class 7 — "**THE MISSING OPERAND.** An instrument that needs operands describing a change under investigation, invoked bare by a sweep." | docs/project/harness_hardening_history.md:46 | read |
| V-I8 | I | "**The diagnostic that beats all of them:** compare a red gate's RUNTIME against the runtime its own header quotes." | docs/project/harness_hardening_history.md:51 | read |
| V-I9 | I | The `#94` reference-rot class (issue numbering, distinct from the 1-7 taxonomy) — gate `test_build_ref_rot.sh`, extended four times | HANDOFF_HISTORY.md:2378 | read |
| V-I10 | I | "The runner found three defects in ITSELF before it found any in the suite — all class 2" (`--lane` assign vs accumulate; `^ *SKIP` before exit; subshell `wait`) | docs/project/harness_hardening_history.md:72 | read |
| V-I11 | I | "a lineage freeze rots the harness" — bbh's `config.py` carried this project's build literals as defaults; the FIDELITY gate caught it | STATE.md:62 | read |
| V-I12 | I | "`gfx_tiles.decode` had every 8-pixel half MIRRORED, and nothing noticed for 14 sessions" — verify synthesized data at the RENDER layer | docs/GOTCHAS.md:122 | read |
| V-I13 | I | "two traps from the #104 re-measurement — both produced a CONFIDENT WRONG ANSWER from a working instrument (paid: 14z-99)" | docs/GOTCHAS.md:279 | read |
| V-I14 | I | "`BUILD=... tests/<gate>.sh` is SILENTLY IGNORED by positional-arg gates — and you measure the DEFAULT build with full confidence" | docs/GOTCHAS.md:296 | read |
| V-I15 | I | "the deadness measurement was sound but its COVERAGE was four replays" — the type-6 tripwire armed on legacy content, undetected for 18 sessions | STATE.md:1240 | read |
| V-P1 | P | "**A RED GATE IS A QUESTION, NOT AN ANSWER**, and the first thing the question needs is which side rests on a measurement." | tests/expected/PROVENANCE.md:16 | read |
| V-P2 | P | "**THE PRECEDENCE OF REFERENCES** … ruling > vsavj > vs2. **A build of OURS — solo or merged — is nowhere in that order.**" | tests/expected/PROVENANCE.md:38 | read |
| V-P3 | P | "*better no test than a bad one. Let's drop*" — the maintainer's rule for a gate that can be re-pointed but whose VERDICT CONTROL cannot | DECISIONS_HISTORY.md:1656 | read |
| V-P4 | P | The extraction question — "*would this still be true if the thing under test were not this ROM, not CPS-2, not even a game?*" | HANDOFF.md:50 | read |
| V-P5 | P | The documentation taxonomy question — "**would this still be true if we abandoned the roster hack tomorrow?**" | CLAUDE.md:293 | read |
| V-P6 | P | "STANDING PRINCIPLE (maintainer, 2026-08-05): **vanilla wins ties**" — a port's choice is evidence of its designers' preference, not of vanilla being wrong | STATE.md:295 | read |
| V-P7 | P | "*to know if we should fix the gate or what it caught, we must use data we can trust, and that means measuring or relying on data … vetted by measurements*" | STATE.md:328 | read |
| V-P8 | P | "An undocumented discovery is a discovery we will pay for twice." | CLAUDE.md:317 | read |
| V-P9 | P | "a stale claim in a header is worse than no documentation: it is confidently wrong, and it is what a future session will act on." | CLAUDE.md:345 | read |
| V-P10 | P | "The spec is NOT copied here on purpose — two copies drift, and that document is the one kept current." (verbatim; the source has no bold) | CLAUDE.md:52-53 | read |
| V-P11 | P | "a gate's WHY lives in the gate" (14z-123 ruling) — which is why the gate index is generated FROM the headers | docs/project/gate_index.md:7 | read |
| V-P12 | P | "Where the synthesis and a log disagree, **THE LOG WINS**" | docs/README.md:29 | read |
| V-P13 | P | "Prefer designs where being wrong is *safe and loud* over designs that are merely well-measured." | STATE.md:1246 | read |
| V-P14 | P | "Each is measured by ABSENCE, which is the weakest kind of evidence we accept" — hence the register, the guard and the fallback column | STATE.md:1230 | read |
| V-P15 | P | "**The file is what a triage opens.**" — provenance is kept beside the frozen file, not in a gate header or a STATE entry | tests/expected/PROVENANCE.md:20 | read |
| V-P16 | P | "The harness is this project's most valuable artifact (CLAUDE.md §4), and it rots in ways the port does not" | docs/project/harness_hardening_history.md:8 | read |
| V-P17 | P | "'It should be equivalent' is not a test result." | CLAUDE.md:58 | read |
| V-P18 | P | "the fix is never to relax the control" | docs/project/harness_hardening_history.md:32 | read |
| V-P19 | P | "archived entries are never rewritten (corrections are marked in place, as always)" | CLAUDE.md:243 | read |
| V-P20 | P | "A claim that cannot be found cannot be corrected" — the reason the retraction sweep greps the ARCHIVES too | CLAUDE.md:344 | read |
| V-P21 | P | "**So a tag is never renamed, renumbered or tidied**: renaming one silently breaks every citation" — `14z-N` is the archive's INDEX | CLAUDE.md:258 | read |
| V-P22 | P | "**Everything else here is a way the pipeline, a gate or a rig produced a confident wrong answer, and the check that stops it from happening again.**" | .claude/skills/vampire-saved-port/SKILL.md:13 | read |
| V-P23 | P | "the eliminations usually stay valid even when the conclusion does not" — keep the superseded analysis, marked RETRACTED | CLAUDE.md:341 | read |
| V-P24 | P | "a test's classification code must be validated against known ground-truth scenarios before its verdicts are trusted … Never again." | CLAUDE.md:223 | read |
| V-P25 | P | "the numbers are about an artifact nobody maintains" — the tell that separates rot class 4 from a real defect | docs/project/harness_hardening_history.md:36 | read |
| V-X1 | X | L1 routing enforcement (markdown) — README completeness + two-way twins + routing tables at the two entry points. LANDED 14z-140 | docs/project/living_docs_scope.md:162 | read |
| V-X2 | X | L4 the rendered site — `mk_docs_site.py`, generated + never committed; landing page IS the routing table; search over the 555 anchor IDs. LANDED 14z-140 | docs/project/living_docs_scope.md:163 | read |
| V-X3 | X | L2 fact tables with provenance — `audit_rule5.py`, the BAKED inventory frozen so it can only SHRINK; option B keeps the value in the manifest. LANDED 14z-141 | docs/project/living_docs_scope.md:164 | read |
| V-X4 | X | L3 ROM re-derivation — documents as SUBJECTS: quote the claim, derive the fact from the decrypted image, compare. LANDED 14z-142, coverage 30/346 | docs/project/living_docs_scope.md:165 | read |
| V-X5 | X | Ruled slice order "**L1 → L4 → L2 → L3**" — enforcement first, then the site that makes every document REFERENCED | docs/project/living_docs_scope.md:167 | read |
| V-X6 | X | Provenance vocabulary #1 (rule-5 rows): "`measured 14z-N (rig)` · `derived (tool)` · `testimony (who, date)` · `ruled (date)`" | docs/project/tables/rule5_ledger.md:17 | read |
| V-X7 | X | Provenance vocabulary #2 (frozen expectations): `in-emulator (reference)` / `in-emulator (ours)` / `derived` / `hash-lock` / `static` / `registry` | tests/expected/PROVENANCE.md:31 | read |
| V-X8 | X | Provenance vocabulary #3 (rule-5 census classification): `IN-TABLE` / `DERIVED` / `BAKED` | tools/audit_rule5.py:8 | read |
| V-X9 | X | The memory-file convention: STATE holds ~3 session groups + THE LEDGER + the standing sections; `STATE_HISTORY.md` holds every older record VERBATIM | CLAUDE.md:233 | read |
| V-X10 | X | The `_history.md` TWIN convention — docs stay lean, the complete LOG lives in the twin; twins join the LOG lists as they are created | tools/checkskills.py:74 | read |
| V-X11 | X | The eight harness_scope decisions (§7), each RULED/DECIDED with the maintainer's words, a date and a veto path; the license is explicitly NOT a default | docs/project/harness_scope.md:418 | read |
| V-X12 | X | The 19-red sweep — "155 gates, 136 PASS, 19 FAIL, ZERO SKIP … and NOT ONE red was a defect in the shipped artifact"; 8 closed in-session | docs/project/harness_hardening_history.md:80 | read |
| V-X13 | X | The 19 reds mapped ONTO the rot classes: 1 orphan ×1, 3 dead control ×2, 4 stale reference ×7, 5 parser ×1, 6 deleted ×1, 7 operand ×3, unclassed ×4 | docs/project/harness_hardening_history.md:84 | read |
| V-X14 | X | THE DEADNESS REGISTER — every "legacy never reaches this, so we may reuse it" claim, with guard and fallback; "the FIRST PLACES TO CHECK" | STATE.md:1228 | read |
| V-X15 | X | `GAME_TOKENS` (14) — `vsav vampire donovan huitzil phobos pyron tenant roster demitri jedah victor bishamon anita oboro` | tools/checkskills.py:45 | read |
| V-X16 | X | `BUILD_TOKENS` (8) — `0xEE73 0xFFDB 0x8E57F0 0x5FFF1E 32007911 build/ merged m3b_` | tools/checkskills.py:47 | read |
| V-X17 | X | `BOARD_TOKENS` (5) — `cps qsound jtcps vsavjw wide_en`; forbidden at level 0 only | tools/checkskills.py:52 | read |
| V-X18 | X | The lifting precedent: a lifted rule KEEPS ITS NUMBER, anchors in the SAME paragraph, and the old ID stays as a redirect so citations resolve | tools/checkskills.py:111 | read |
| V-X19 | X | The harness slices H1..H10 with landing commits (`803f372` … `e643219`); H8 (the doc tools) is OUT by decision | docs/project/harness_scope.md:300 | read |
| V-X20 | X | The four extraction BINS — code / config / machine profile / stays — every piece classified with its parameterisation | docs/project/harness_scope.md:86 | read |
| V-X21 | X | "This tree never consumes it" — the extraction is proved by FIDELITY, not by dependency; one file gained (`test_bbh_fidelity.sh`) | HANDOFF.md:50 | read |
| V-X22 | X | The three gotcha buckets, split by the outlives-the-project question; append to the bucket the FACT belongs to, then regenerate the index | docs/GOTCHAS.md:5 | read |
| V-X23 | X | The `14z-N` session key: three namespaces never conflated (sessions / milestones `M0..M12` / freeze marks); a LOOKUP KEY into the archives | CLAUDE.md:247 | read |
| V-X24 | X | The gate-scoping method — 13 sections incl. "Widening is a measurement, not a judgement call" and "suspect the instrument" | docs/project/gate_scoping_method.md:1 | read |
| V-X25 | X | The skill levels 0/1/2 as a liftability ladder, declared in each SKILL.md's H1 and enforced by the `forbid` token lists | .claude/skills/*/SKILL.md (A106-A108) | read |
| V-X26 | X | The 6 `.pending` expectations still open — `donovan-m5` ×2, `huitzil-m13` ×3, `pyron-m7` ×1 — the type-6 counter awaiting a ruling | STATE.md:1240 | read |
| V-X27 | X | `docs/project/hardening_register.md`'s measured partition — rule-4 provenance makes "the immense majority is safe" mechanical (~166,000 addresses) | docs/project/hardening_register.md:11 | read |
| V-X28 | X | CI is DRAFTED-then-ENABLED as a policy decision, and `ci/README.md` names what the maintainer is DECIDING, not just reviewing | ci/README.md:1 | read |
| V-X29 | X | The LIVE CROSS-REPO citation `[RH-N]` — the external `romhacking-methodology` skill; 43 files, 72 citations, 24 IDs, DEFINED NOWHERE HERE | tests/test_skill_guides.sh:16 (A124-A126) | read |
| V-X30 | X | "`[RH-N]` is not checked (the RH skill lives outside the repo)" — a citation scheme deliberately left unenforceable by `checkskills.py` | docs/project/skills_scope.md:119 | read |
| V-X31 | X | The 4 SKILL.md headers that route to it by PLACEHOLDER (`[RH-NN]`), so no `[0-9]+` census sees them: cps2-hardware, mame-fbneo-instruments, mister-cps2-wide-core, mister-jtframe-core | .claude/skills/cps2-hardware/SKILL.md:14 +3 | read |

## C. Generators

### G1 — the 555 rule rows (V-R1..V-R555)

Run from anywhere; it `chdir`s to the VampireSaved root, reads only, and writes to stdout.
It emitted `rules=555  no-anchor=0` on stderr, and `grep -c " +[0-9]* |"` over its output returned `0`,
i.e. every one of the 555 rules resolved to exactly ONE anchor — the property `tools/checkskills.py` enforces,
here re-derived independently.

```python
#!/usr/bin/env python3
# G1 — emit one B-table row per rule defined in this tree's eight SKILL.md files.
import re, subprocess, glob, os, sys
ROOT = "/Users/koneko/Developer/Vampire_Saved/VampireSaved"
os.chdir(ROOT)

# 1. anchors: **[PFX-N]** in *.md, excluding the two generated GUIDE.md and every history twin
out = subprocess.run(["git", "grep", "-nE", r"\*\*\[[A-Z]+-[0-9]+\]\*\*", "--", "*.md"],
                     capture_output=True, text=True).stdout
anchors = {}
for line in out.splitlines():
    path, lineno, rest = line.split(":", 2)
    base = os.path.basename(path)
    if base == "GUIDE.md":
        continue
    if base.endswith("_history.md") or base.endswith("_HISTORY.md"):
        continue
    for m in re.finditer(r"\*\*\[([A-Z]+-[0-9]+)\]\*\*", rest):
        anchors.setdefault(m.group(1), []).append("%s:%s" % (path, lineno))

# 2. definitions: `- [PFX-N] ...` in the eight SKILL.md, in skill-name order
DEF = re.compile(r"^- \[([A-Z]+-[0-9]+)\] ?(.*)$")
n = 0
rows = []
for sk in sorted(glob.glob(".claude/skills/*/SKILL.md")):
    for raw in open(sk, encoding="utf-8"):
        m = DEF.match(raw.rstrip("\n"))
        if not m:
            continue
        n += 1
        rid, body = m.group(1), m.group(2)
        item = "[%s] %s" % (rid, body)
        item = item.replace("|", r"\|")
        if len(item) > 140:
            item = item[:139].rstrip() + "…"
        a = anchors.get(rid, [])
        if not a:
            src = "NO ANCHOR"
        elif len(a) == 1:
            src = a[0]
        else:
            src = "%s +%d" % (a[0], len(a) - 1)
        rows.append("| V-R%d | R | %s | %s | gen:G1 |" % (n, item, src))
sys.stderr.write("rules=%d  no-anchor=%d\n" % (n, sum(1 for r in rows if "NO ANCHOR" in r)))
print("\n".join(rows))
```

Invocation:

```sh
python3 gen_rules.py > rules_rows.md      # 555 lines on stdout, "rules=555  no-anchor=0" on stderr
grep -c " +[0-9]* |" rules_rows.md        # 0 — no rule has a second anchor
```

## D. Not looked at

Named so a later pass knows the survey's edge. None of the following was opened, read for content, or counted beyond the file-level tallies in §A.

- **`STATE_HISTORY.md` (28918 lines) and `HANDOFF_HISTORY.md` (2437), `DECISIONS_HISTORY.md` (2783), `docs/NEXT_SESSION_HISTORY.md` (5947), `docs/GOTCHAS_history.md` (601), and every `*_history.md` twin.** Grepped for specific strings only. Deliberately excluded from the G1 anchor lookup, because the checker forbids anchors there. These hold the incident record behind most rules; a "what did this rule cost" pass has to read them.
- **`build/` (1043 tracked files).** Only `build/manifest/` (33 files) was listed; the ~1000 committed `.log` measurement records and the ~50 per-freeze build directories were not opened. The 370 untracked files are all here.
- **`release/` (719 files)** — per-freeze shipped artifacts and `bitstreams/`. Not opened.
- **ROMs, decrypted images, any binary.** `$ROMDIR` was never read; no gate was executed except `python3 tools/checkskills.py -v` (read-only, prints a tally).
- **The emulator submodules** `emu/fbneo`, `emu/mame`, `emu/jtcores` — not initialised, not read. Only `.gitmodules` and the tracked patch series filenames.
- **`tests/expected/` file CONTENTS**, except: the first line of every `.masked` (A53–A58), `PROVENANCE.md`, `registry.tsv`, `doc_anchor_census.tsv` head. The 807 `.log`, 719 `.sha1`, 778 `.skip` and 56 `.legacy-exempt` files were counted, never read.
- **`tests/replays/*.rpl` (181)** and `tests/lua/*.lua` (32) — counted, not read.
- **Most of the 161 tools.** Read in whole or part: `checkskills.py`, `s4_thresholds.py`, `audit_rule5.py` (head). Named only: the other ~157.
- **Most of the 311 gate scripts.** Read: `test_header_defaults.sh`, `test_bbh_fidelity.sh`, `test_checkskills.sh` (fixtures), `run_suite.sh` (dispatch), `run_all_emulator.sh` / `run_all_static.sh` (registry wiring), `lib/classify.sh`. The other ~304 were counted and grepped, not read.
- **`docs/game/atlas/*`, `docs/project/tables/chars/*`, `docs/project/patch_notes.md`, `docs/project/mister_*.md`** — the domain corpus. Anchors were counted; the facts were not evaluated.
- **The `blackbox-harness` repository itself.** `[BBH-1..87]`, `skill/skills.toml`, `example/consumers/bbh.vampire.toml`, `docs/conventions.md`, `docs/doctrine.md`, `docs/rebaselines.md` and the eight ruled defaults live THERE. Everything said about them here comes from this tree's descriptions of them (`HANDOFF.md:50`, `docs/project/harness_scope.md`), which are themselves a candidate for staleness — two of this tree's three quoted harness figures (553 rules, 1,891 masked specs) are already stale (A72, A73).
- **`git log` bodies.** Only `git log --oneline | wc -l` and the HEAD subject line.
- **`SPEC.md` (175), `LICENSE`, `.gitignore`** — counted, not read.

Corrected 2026-09-09 after verification: A19, A21, A70 rewritten; A123, A124, A125, A126, A127 added; V-R556, V-R557 (`:7`→`:6`), V-P10 (bold removed, `:53`→`:52-53`), V-T1 (`319`→`311` gate scripts) corrected; V-X29, V-X30, V-X31 added; §D's "319 gate scripts" → 311.

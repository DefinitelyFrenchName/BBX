# Census — SMS-FrenchName-edition @ ecc5481 — measured 2026-09-09
Local directory is `/Users/koneko/Developer/SailorMoonS` (the local dir is named `SailorMoonS`; the remote is **SMS-FrenchName-edition**, <https://github.com/DefinitelyFrenchName/SMS-FrenchName-edition.git>) — 633 tracked files, 574 commits, working tree clean (0 dirty).

Every number below was printed by the command in its row, run from the repo root on 2026-09-09 at `ecc5481`. Numbers this repo *files about itself* (running totals written into `HANDOFF.md`) are labelled **filed** and are not re-derivable without the ROM — they are quoted with their `path:line`, per the project's own rule that a number someone else reports is a filed count, not a measurement (`CLAUDE.md:41`).

## A. Counts

| id | dimension | count | command (run from repo root) |
|---|---|---|---|
| A1 | HEAD | `ecc5481` | `git rev-parse --short HEAD` |
| A2 | tracked files | 633 | `git ls-files \| wc -l` |
| A3 | commits | 574 | `git log --oneline \| wc -l` |
| A4 | dirty paths — a HOST fact (rule 7); on a clone this row could never fail (gotcha G13), so it is not a count | host: 0 on 2026-09-09 | not recountable (rule 7); was `git status --porcelain \| wc -l` run in place |
| A5 | tracked files in `tools/` | 501 | `git ls-files \| awk -F/ '{if (NF==1) print "(root)"; else print $1}' \| sort \| uniq -c \| sort -rn \| awk '$2=="tools"{print $1}'` |
| A6 | tracked files in `docs/` | 53 | (same command as above) |
| A7 | tracked files in `build/` | 37 | (same command as above) |
| A8 | tracked files in `traces/` | 30 | (same command as above) |
| A9 | tracked files at repo root | 4 | (same command as above) |
| A10 | tracked files in `release/` | 3 | (same command as above) |
| A11 | tracked files in `.github/` | 3 | (same command as above) |
| A12 | tracked files in `.claude/` | 2 | (same command as above) |
| A13 | `traces/` files TRACKED at the commit (host: 5332 on disk on 2026-09-09, gitignored — a fact about the host, not the commit; rule 7) | 30 | `git ls-files traces \| wc -l` |
| A14 | `build/` files TRACKED at the commit — the `.bps`/`.ips` (host: 324 on disk on 2026-09-09; rule 7) | 37 | `git ls-files build \| wc -l` |
| A15 | memory file `CLAUDE.md` | 134 lines | `wc -l CLAUDE.md HANDOFF.md README.md` |
| A16 | memory file `HANDOFF.md` | 1620 lines | (same command as above) |
| A17 | memory file `README.md` | 115 lines | (same command as above) |
| A18 | memory file `docs/project/NEXT_SESSION.md` | 707 lines | `wc -l docs/project/NEXT_SESSION.md` |
| A19 | tracked `.md` | 55 | `git ls-files '*.md' \| wc -l` |
| A20 | total lines in `docs/**/*.md` | 17893 | `git ls-files 'docs/**/*.md' 'docs/*.md' \| xargs wc -l \| tail -1 \| awk '{print $1}'` |
| A21 | tracked `.py` | 80 | `git ls-files '*.py' \| wc -l` |
| A22 | tracked `.lua` | 407 | `git ls-files '*.lua' \| wc -l` |
| A23 | tracked `.sh` | 13 | `git ls-files '*.sh' \| wc -l` |
| A24 | tracked `.json` | 5 | `git ls-files '*.json' \| wc -l` |
| A25 | `[SMS-N]` rule definitions, agent rendition | 38 | `grep -cE '^- \[SMS-[0-9]+\]' .claude/skills/sms-romhacking/SKILL.md` |
| A26 | `[SMS-N]` rule definitions, human rendition | 38 | `grep -cE '^\*\*\[SMS-[0-9]+\]\*\*' docs/game/sms_hacking_playbook.md` |
| A27 | `[SSP-N]` rule definitions, agent rendition | 28 | `grep -cE '^- \[SSP-[0-9]+\]' .claude/skills/supers-porting/SKILL.md` |
| A28 | `[SSP-N]` rule definitions, human rendition | 28 | `grep -cE '^\*\*\[SSP-[0-9]+\]\*\*' docs/project/saturn/porting_lessons.md` |
| A29 | rule pairs verified ID-equal both ways | 66 rules / 2 pairs | `python3 tools/checkskills.py` → `ALL PASS (66 rules across 2 pairs; both renditions define the same IDs, both ways)` |
| A30 | `[RH-N]` references (defined **outside** this repo) | 29 | `git grep -hoE '\[RH-[0-9]+\]' -- '*.md' \| wc -l` |
| A31 | `[SNES-N]` references (defined **outside** this repo) | 28 | `git grep -hoE '\[SNES-[0-9]+\]' -- '*.md' \| wc -l` |
| A32 | traps 1–23 (collected in one ledger) | 23 | `grep -cE '^[0-9]+\. \*\*' HANDOFF.md` |
| A33 | traps 24–28 (filed beside the work that paid for them) | 5 | `grep -cE 'Trap 2[4-8] — ' HANDOFF.md` |
| A34 | Measurement-Rule corollaries | 7 | `sed -n '34,59p' CLAUDE.md \| grep -c '^\* \*\*'` |
| A35 | checkdocs family: hand-written checks | 37 | `grep -c '^@check(' tools/checkdocs.py` |
| A36 | checkdocs family: table-structure validators | 17 | `grep -c '^@table(' tools/checkdocs.py` |
| A37 | checkdocs family: file-offset claims extracted from prose | 16 | `python3 -c "import sys;sys.path.insert(0,'tools');import docaddrs as d;print(len(d.file_offset_claims()))"` |
| A38 | checkdocs family: quoted byte-run claims | 6 | `python3 -c "import sys;sys.path.insert(0,'tools');import docaddrs as d;g=[p for p in d.docs_files() if p.parent.name=='game'];print(len(d.byte_run_claims(g)))"` |
| A39 | checkdocs family: quoted-instruction claims | 30 | `python3 -c "import sys;sys.path.insert(0,'tools');import docaddrs as d;g=[p for p in d.docs_files() if p.parent.name=='game'];print(len(d.instruction_claims(g)))"` |
| A40 | checkdocs family: table-row claims | 17 | `python3 -c "import sys;sys.path.insert(0,'tools');import docaddrs as d;g=[p for p in d.docs_files() if p.parent.name=='game'];print(len(d.table_row_claims(g)))"` |
| A41 | checkdocs family: disassembly-listing-row claims | 28 | `python3 -c "import sys;sys.path.insert(0,'tools');import docaddrs as d;g=[p for p in d.docs_files() if p.parent.name=='game'];print(len(d.listing_claims(g)))"` |
| A42 | **filed** checkdocs total at first landing (31) | 31 — `HANDOFF.md:338` | `grep -n '31 checks' HANDOFF.md` |
| A43 | **filed** checkdocs total 207 (37 hand · 17 tables · 69 prose · 84 structural) | 207 — `HANDOFF.md:224` | `grep -n 'checkdocs..\? 207' HANDOFF.md` |
| A44 | **filed** checkdocs total 228 | 228 — `HANDOFF.md:125` | `grep -n '87 → 228' HANDOFF.md` |
| A45 | **filed** checkdocs total 248 (current) | 248 — `HANDOFF.md:59` | `grep -n 'checkdocs. \*\*248\*\*' HANDOFF.md` |
| A46 | distinct ROM addresses in hand-written `docs/game/` pages (measured now) | 428 | `python3 tools/docaddrs.py \| grep -oE '[0-9]+ distinct ROM addresses' \| cut -d' ' -f1` |
| A47 | addresses in ROM-generated pages (`mkcharmap --check`) | 123 | `python3 tools/docaddrs.py \| grep -oE '[0-9]+ in ROM-generated' \| cut -d' ' -f1` |
| A48 | addresses that are RAM (not decidable from the cartridge) | 44 | `python3 tools/docaddrs.py \| grep -oE '[0-9]+ RAM,' \| cut -d' ' -f1` |
| A49 | addresses in appended banks (this project's own patches) | 2 | `python3 tools/docaddrs.py \| grep -oE '[0-9]+ in appended' \| cut -d' ' -f1` |
| A50 | addresses named by `docs/project/` (not gated) | 508 | `python3 tools/docaddrs.py \| grep -oE 'names [0-9]+ more' \| grep -oE '[0-9]+'` |
| A51 | **filed** coverage 190/325 re-derived | 190/325 — `HANDOFF.md:153` | `grep -n '190/325' HANDOFF.md` |
| A52 | **filed** coverage 105/254 re-derived | 105/254 — `HANDOFF.md:242` | `grep -n '105/254' HANDOFF.md` |
| A53 | **filed** addresses that stay uncovered, each saying why | 135 — `HANDOFF.md:165` | `grep -n '135 stay uncovered' HANDOFF.md` |
| A54 | “negative control” lines, repo-wide | 42 | `git grep -n -i 'negative control' \| wc -l` |
| A55 | files mentioning “negative control”, repo-wide (incl. docs) | 25 | `git grep -li 'negative control' \| wc -l` |
| A56 | “negative control” lines in **code** | 30 | `git grep -ni 'negative control' -- '*.py' '*.lua' '*.sh' \| wc -l` |
| A57 | **code files** carrying a negative control (→ the `S-T*` rows) | 18 | `git grep -li 'negative control' -- '*.py' '*.lua' '*.sh' \| wc -l` |
| A58 | `SETUP-FAIL` sites (the third verdict class) | 39 | `git grep -n 'SETUP-FAIL' \| wc -l` |
| A59 | “must fail” hits | 14 | `git grep -ni 'must fail' \| wc -l` |
| A60 | “wrong base” hits | 7 | `git grep -ni 'wrong base' \| wc -l` |
| A61 | “wrong address” hits | 8 | `git grep -ni 'wrong address' \| wc -l` |
| A62 | “wrong seed” hits | 2 | `git grep -ni 'wrong seed' \| wc -l` |
| A63 | “wrong game” hits (the cross-game control) | 3 | `git grep -ni 'wrong game' \| wc -l` |
| A64 | `DETERMINISM` stage declarations in shell harnesses | 4 | `git grep -ni 'DETERMINISM' -- '*.sh' \| wc -l` |
| A65 | generators owning a `--check` mode | 6 | `grep -ln '\-\-check' tools/mk*.py \| wc -l` |
| A66 | living-page + `*_history.md` twin pairs | **0** | `git ls-files \| grep -ciE '_history\.md$'` |
| A67 | docs maps / index READMEs | 4 | `git ls-files 'docs/**/README.md' 'docs/README.md' \| wc -l` |
| A68 | tool family `probe_*` (root / saturn) | 150 / 167 | `git ls-files 'tools/probe_*' \| wc -l` ; `git ls-files 'tools/saturn/probe_*' \| wc -l` |
| A69 | tool family `mk*` (root / saturn) | 26 / 5 | `git ls-files 'tools/mk*' \| wc -l` ; `git ls-files 'tools/saturn/mk*' \| wc -l` |
| A70 | tool family `test_*` | 13 | `git ls-files 'tools/test_*' \| wc -l` |
| A71 | tool family `check*` (root / saturn) | 5 / 1 | `git ls-files 'tools/check*' \| wc -l` ; `git ls-files 'tools/saturn/check*' \| wc -l` |
| A72 | tool family `census*` | 4 | `git ls-files 'tools/census*' \| wc -l` |
| A73 | tool family `exp_*` | 8 | `git ls-files 'tools/exp_*' \| wc -l` |
| A74 | tool family `demo_*` | 9 | `git ls-files 'tools/demo_*' \| wc -l` |
| A75 | tool family `verify_*` (saturn only) | 3 | `git ls-files 'tools/saturn/verify_*' \| wc -l` |
| A76 | tool family `build_*` (root / saturn) | 4 / 2 | `git ls-files 'tools/build_*' \| wc -l` ; `git ls-files 'tools/saturn/build_*' \| wc -l` |
| A77 | tool family `extract_*` (root / saturn) | 2 / 3 | `git ls-files 'tools/extract_*' \| wc -l` ; `git ls-files 'tools/saturn/extract_*' \| wc -l` |
| A78 | tool family `trace_*` (root / saturn) | 1 / 2 | `git ls-files 'tools/trace_*' \| wc -l` ; `git ls-files 'tools/saturn/trace_*' \| wc -l` |
| A79 | `tools/README.md` groups | 11 | `grep -c '^## ' tools/README.md` |
| A80 | `tools/README.md` group sizes | Saturn 195 · Probes 165 · Other 37 · Demos 32 · Builders 18 · Training pkg 18 · Suites 15 · Build scripts 10 · Libs 6 · Training entry 2 · Extractors 2 | ``awk '/^## /{h=$0;c[h]=0;order[++n]=h} /^- `/{if(h!="")c[h]++} END{for(i=1;i<=n;i++)printf "%s\t%d\n",order[i],c[order[i]]}' tools/README.md`` |
| A81 | `tools/README.md` self-verified as in sync | 500 scripts, 11 groups | `python3 tools/mkindex.py --check` |
| A82 | regression suite cases | 68 | `grep -c '^add{' tools/test_regression.lua` |
| A83 | documented knobs verified both ways | 15 | `python3 tools/checkknobs.py \| grep -oE '[0-9]+ documented knobs' \| cut -d' ' -f1` |
| A84 | training-doc checks verified both directions | 13 | `python3 tools/checktrainingdocs.py \| grep -oE '[0-9]+ checks' \| cut -d' ' -f1` |
| A85 | cliguard self-test cases | 12 | `python3 tools/cliguard.py \| grep -oE '[0-9]+ cases' \| cut -d' ' -f1` |
| A86 | commits carrying a `Gates:` evidence line | 9 | `git log --format='%b' \| grep -c '^Gates:'` |
| A87 | commit bodies containing `ALL PASS` | 84 | `git log --format='%b' \| grep -c 'ALL PASS'` |
| A88 | `⚠` incident markers, lines repo-wide | 287 | `git grep -c '⚠' \| awk -F: '{s+=$2} END{print s}'` |
| A89 | `⚠` markers, files | 51 | `git grep -l '⚠' \| wc -l` |
| A90 | `⚠` markers in `HANDOFF.md` | 37 | `grep -c '⚠' HANDOFF.md` |
| A91 | distinct issue IDs `#NN` cited in code/docs | 96 | `git grep -h '#[0-9]' -- '*.md' '*.py' '*.lua' '*.sh' \| grep -oE '#[0-9]{1,3}\b' \| sort -u \| wc -l` |
| A92 | forward references to **VampireSaved** | **0** | `git grep -il 'vampire' \| wc -l` |
| A93 | forward references to **blackbox-harness / bbh** | **0** | `git grep -ilwE 'blackbox-harness\|blackbox_harness\|bbh' \| wc -l` |
| A94 | uses of the term “black box” at all | **0** | `git grep -n -i 'black.box' \| wc -l` |

> Correction to an earlier pass: the code-side negative-control **line** count is 30 and the **file** count is 18 (A54–A57 above). An earlier summary said “27 sites”; that was a miscount and is superseded by the commands shown.

## B. Items

| id | kind | item | source | row-provenance |
|---|---|---|---|---|
| S-P1 | P | **THE MEASUREMENT RULE** — “Any data should come from measurements, NEVER guesses … when you're sure you don't have to measure is precisely when you absolutely must measure.” | CLAUDE.md:19-24 | read |
| S-P2 | P | “the third clause is the one that bites: **certainty is the failure signal, not the safety signal**, because confidence is exactly when the check gets skipped” | CLAUDE.md:28-30 | read |
| S-P3 | P | Corollary 1 — “No number reaches a doc, a commit message, a patch or a plan without a run that produced it in that session.” Inherited numbers are re-derived. | CLAUDE.md:37-40 | read |
| S-P4 | P | Corollary 2 — “A number someone else reports is a **filed count, not a measurement**” — incl. a subagent, an issue, a wiki, and this repo's own older notes. | CLAUDE.md:41-45 | read |
| S-P5 | P | Corollary 3 — “A number produced with tooling later found defective is contaminated — discard and re-measure. **Never adjust it.**” | CLAUDE.md:46-47 | read |
| S-P6 | P | Corollary 4 — “**Measure the negative too.** … re-run it at a wrong address, a wrong base, a wrong seed. And a negative control is code, so it is wrong until it has failed on purpose.” | CLAUDE.md:48-51 | read |
| S-P7 | P | Corollary 5 — “**Reject on measurements, not on intuition.** … say what was measured and what the number was, so the rejection is auditable.” | CLAUDE.md:52-53 | read |
| S-P8 | P | Corollary 6 — “**Thresholds live where the run that produced them lives.** A tool recomputes its own floors and ceilings; it never hardcodes a figure typed out of a plan.” | CLAUDE.md:54-55 | read |
| S-P9 | P | Corollary 7 — “**Check the framing before trusting a verdict about a byte.** … starting somewhere convenient invents one.” | CLAUDE.md:56-58 | read |
| S-P10 | P | House rule — “**Measure, don't infer — and measure hardest when you are sure.**” (the Measurement Rule restated for a corpus meant to be lifted by other projects) | docs/game/README.md:56 | read |
| S-P11 | P | House rule — “**Find the interpreter before trusting the data.**” A run of zeros that looked like a terminator was centring padding; the build made on that reading hung the game. | docs/game/README.md:67 | read |
| S-P12 | P | House rule — “**A probe that reports nothing is usually broken, not evidence of nothing.**” Verify the instrument against a known-present signal first. | docs/game/README.md:71 | read |
| S-P13 | P | House rule — “**DMA is invisible to CPU write callbacks.**” Any claim that a region is free needs snapshots as well as a write watch. | docs/game/README.md:74 | read |
| S-P14 | P | House rule — “**The holes are documented too** … A map that hides its gaps is worse than no map.” | docs/game/README.md:76 | read |
| S-P15 | P | Convention — “**Never patch a ROM in place**; builders take `(src, out)` and every stacked step needs `--stacked`.” | docs/project/README.md:29 | read |
| S-P16 | P | Convention — “**Never chain standalone `.bps` files** — every bank-appending patch targets the same first free bank.” | docs/project/README.md:31 | read |
| S-P17 | P | Convention — “**Byte-identity is the refactor gate.** A change that should not alter output must be proven not to, across every knob that alters emitted bytes.” | docs/project/README.md:33 | read |
| S-P18 | P | Convention — “**Published artifacts are never redefined.** A superseded build gets a new name (REF v.1 → v.2, Rev. 01 → 02), never a redefinition.” | docs/project/README.md:35 | read |
| S-P19 | P | Convention — “**Generated files are generated**” — `tools/README.md`, the suite's signature block and the release notes all have `--check` modes. | docs/project/README.md:37 | read |
| S-P20 | P | Implemented, never stated — **three verdict classes, not two**: FAIL / SKIP / NOTE. “A check that cannot run must SKIP, never fail.” | tools/health.sh:13-21 | read |
| S-P21 | P | Implemented, never stated — **fixtures are shared, judgement is not**: “This module owns the fixture and nothing else … The caller decides what is true.” | tools/clashfixture.lua:5-7 | read |
| S-P22 | P | Implemented, never stated — **the sweep that set a default lives in the header of the file that uses it**, not in a changelog. | tools/clashfixture.lua:20-24 | read |
| S-P23 | P | Implemented, never stated — **the honest weakness is printed**: coverage, UNENCODABLE, ROUTINE_LEVEL. “a number that is never shown never moves.” | tools/checkdocs.py:40-43 | read |
| S-P24 | P | Implemented, never stated — **generated artifacts are never committed as build output** (“a hand-copied artifact goes stale silently”). | .github/workflows/pages.yml:3-6 | read |
| S-P25 | P | Implemented, never stated — **the gate names what it is not**: “WHAT IT IS NOT: the gate … anything claiming to verify a build without them is lying.” | tools/health.sh:4-10 | read |
| S-P26 | P | Implemented, never stated — **a census is not a gate**, and says so in its own output. | tools/docaddrs.py:553 | read |
| S-P27 | P | Implemented, never stated — **wiring is checked separately from the function**: “A passing selftest says nothing about wiring, and wiring is what rots.” | tools/health.sh:99-106 | read |
| S-P28 | P | Implemented, never stated — **validate against a different author's implementation where one is free** (our 65816 tables vs vendored DisPel). | tools/dis65816_oracle.py:13, tools/health.sh:75-87 | read |
| S-P29 | P | Implemented, never stated — **logs truncate, never append**: in append mode “a run that died before writing a verdict left the previous run's ‘ALL PASS’ as that line”. | tools/test_regression.lua:39-42 | read |
| S-P30 | P | Implemented, never stated — **a claim nobody checked must never be mistaken for one that held** (unencodable quotes are reported, never dropped). | tools/checkdocs.py:503-505 | read |
| S-P31 | P | Implemented, never stated — **provenance is a first-class field in generated data** (`"provenance"` key emitted into the glyph JSON). | tools/mkhalfwidth.py:280 → docs/project/halfwidth_caps.json:472 | read |
| S-I1 | I | **Five documented facts died** on first re-derivation of the doc tables — re-measured by hand, then locked by `checkdocs`. | HANDOFF.md:315 | read |
| S-I2 | I | Dead fact 1/5 — a special-move record is **7 bytes, not 8**; the “+7 strength-ish” field is the next record's attackID, masked off by a 16-bit `lda $0006,Y`. | HANDOFF.md:315-317; docs/project/NEXT_SESSION.md:340 | read |
| S-I3 | I | Dead fact 2/5 — the 16-bit `stz $47,X` is at **`$C1:0E4F`**, not `$C1:0E51` — wrong in four places across three documents, carried forward for weeks. | HANDOFF.md:317-318; docs/project/NEXT_SESSION.md:341 | read |
| S-I4 | I | Dead fact 3/5 — the config dispatcher's tail is **`jsr ($BB6D,X)`**, not `jmp`. | HANDOFF.md:319; docs/project/NEXT_SESSION.md:342 | read |
| S-I5 | I | Dead fact 4/5 — the bank-`$DF` engine has **eight** screens, not nine (the wrong number lived in a builder comment). | HANDOFF.md:319-320; docs/project/NEXT_SESSION.md:343 | read |
| S-I6 | I | Dead fact 5/5 — Uranus's toss Y velocity is **−$0580**, written `-$FA80` in one doc (`$FA80` is the word, not the value). | HANDOFF.md:320-321; docs/project/NEXT_SESSION.md:344 | read |
| S-I7 | I | **Four claims in the identity paragraph the port rests on did not survive** — the one corpus the project built on, and the last one gated. | HANDOFF.md:260 | read |
| S-I8 | I | Dead claim 1/4 — “Universal-act scripts byte-identical” is true only after stripping Super S's `0xC0` CMD steps (raw ~26/43; stripped **43/43 for five characters**). | HANDOFF.md:260-263 | read |
| S-I9 | I | Dead claim 2/4 — “Cel records same sizes” is **97 of 98** (record 29: `0x0500` vs `0x04E0`). | HANDOFF.md:263-264 | read |
| S-I10 | I | Dead claim 3/4 — the cel banks span **`$D4-$D6` / `$D6-$D7`**, not one each. | HANDOFF.md:264-265 | read |
| S-I11 | I | Dead claim 4/4 — the box-index writer row contradicted itself: `0x9FF1` with shift `+0x32C`, when `0x9CCD + 0x32C = 0x9FF9`, which is where the identical bytes are. | HANDOFF.md:265-267 | read |
| S-I12 | I | Trap 1 — Per-character fixes must be tested with at least TWO shells. | HANDOFF.md:879 | gen:G2 |
| S-I13 | I | Trap 2 — Unreferenced, unchanging memory is not free memory. | HANDOFF.md:886 | gen:G2 |
| S-I14 | I | Trap 3 — Data handed to a vanilla routine must respect the WRAM-mirror rule. | HANDOFF.md:890 | gen:G2 |
| S-I15 | I | Trap 4 — An engine convention verified in one context is not verified in another. | HANDOFF.md:893 | gen:G2 |
| S-I16 | I | Trap 5 — Patch a bank and you must patch its COPIES. | HANDOFF.md:898 | gen:G2 |
| S-I17 | I | Trap 6 — A per-player OVERRIDE is only as complete as the transfer that carries it. | HANDOFF.md:904 | gen:G2 |
| S-I18 | I | Trap 7 — Address a tile through the OBJ name base, never as `tile * 32`. | HANDOFF.md:909 | gen:G2 |
| S-I19 | I | Trap 8 — Sprite lists are emitted on ALTERNATE frames. | HANDOFF.md:912 | gen:G2 |
| S-I20 | I | Trap 9 — A probe that reports nothing is usually broken, not evidence of nothing. | HANDOFF.md:917 | gen:G2 |
| S-I21 | I | Trap 10 — Matching the measurement is not the same as matching the request. | HANDOFF.md:936 | gen:G2 |
| S-I22 | I | Trap 11 — A verified issue report can still be false, and the evidence can be accurate. | HANDOFF.md:929 | gen:G2 |
| S-I23 | I | Trap 12 — Anything thrown inside a Mesen memory callback dies WITHOUT A MESSAGE — assert included. | HANDOFF.md:944 | gen:G2 |
| S-I24 | I | Trap 13 — Before fixing a probe's reported defect, prove the probe does ANYTHING. | HANDOFF.md:951 | gen:G2 |
| S-I25 | I | Trap 14 — Before narrowing a "wasteful" trigger, find out what the waste protects — then move the COST, not the trigger. | HANDOFF.md:957 | gen:G2 |
| S-I26 | I | Trap 15 — A builder change invalidates every recorded RECIPE that contains it — check what a builder feeds before touching it. | HANDOFF.md:963 | gen:G2 |
| S-I27 | I | Trap 16 — Byte-identity is the refactor gate — and it must cover EVERY variant path, not the default. | HANDOFF.md:971 | gen:G2 |
| S-I28 | I | Trap 17 — Counts in filed issues are stale in BOTH directions — re-measure at HEAD before working one. | HANDOFF.md:978 | gen:G2 |
| S-I29 | I | Trap 18 — A documented knob either works or does not exist — and "works" is a measurement. | HANDOFF.md:986 | gen:G2 |
| S-I30 | I | Trap 19 — A patch that widens another patch's scope must RE-CENSUS the paths for the new scope. | HANDOFF.md:995 | gen:G2 |
| S-I31 | I | Trap 20 — A check that cannot fail at the WRONG address is not checking the address. | HANDOFF.md:1008 | gen:G2 |
| S-I32 | I | Trap 21 — A recorded hash is a claim about a build, and a build includes its DEFAULTS. | HANDOFF.md:1020 | gen:G2 |
| S-I33 | I | Trap 22 — A negative control is CODE, and it is wrong until it has failed on purpose. | HANDOFF.md:1030 | gen:G2 |
| S-I34 | I | Trap 23 — Relaxing a binding rule invents claims, and an invented claim fails RED for a reason nobody wrote. | HANDOFF.md:1044 | gen:G2 |
| S-I35 | I | Trap 24 — “an undocumented knob is as bad as a documented one that does not exist, and only one direction was checked.” | HANDOFF.md:147 | read |
| S-I36 | I | Trap 25 — “on this cartridge, ‘is this ROM?’ depends on the bank you are executing in.” | HANDOFF.md:739 | read |
| S-I37 | I | Trap 26 — “a counter that looks like a frame index may be a free-running timer, and the difference only shows when you vary the input.” | HANDOFF.md:725 | read |
| S-I38 | I | Trap 27 — “a write callback's PC is the NEXT instruction.” A watch's PC FINDS a writer; the ROM NAMES it. | HANDOFF.md:61 | read |
| S-I39 | I | Trap 28 — “a probe default that was never run is not a default, it is a guess.” `SMS_DIST` defaulted to 56; the fixture only clashes at gap ≥ 64. | HANDOFF.md:66 | read |
| S-I40 | I | **A recorded hash was stale in four documents while the builder had never changed** — its default *subtitle* had. “A build includes its defaults.” (→ trap 21) | HANDOFF.md:308-313; tools/checkpatchmap.py:27-33 | read |
| S-I41 | I | **Six documented ROM facts were wrong and are corrected**, all re-verified by hand then locked (74-record asset job table, ten on-hit variant tables, 16-byte manifest, …). | HANDOFF.md:352-366 | read |
| S-I42 | I | **checkdocs found one error on its first run — “mine, in the check, not in the docs”.** | HANDOFF.md:342-343 | read |
| S-I43 | I | **The one live defect was the OPPOSITE of what was reported**: the doc was right and the extractor was binding the quote to the preceding token. | HANDOFF.md:177-181 | read |
| S-I44 | I | **Three negative controls looked right and tested nothing** — a flag seed reset by `rep #$30`, an opcode never reached, an anchor at an address with zero call sites. (→ trap 22) | HANDOFF.md:181-186 | read |
| S-I45 | I | **A shipped decode table was wrong**: `00` (BRK) as 1 byte, and `02 08 0B 2B 42 C4 E4` in no table — a descent meeting a `php` would have died. | HANDOFF.md:171-176; tools/dis65816.py:15 | read |
| S-I46 | I | **Nine screenshots had been force-added past the `traces/` rule and pushed** — `git add -f` is explicitly not the escape hatch; `mockups/` was purged from history for the same reason. | .gitignore:35-44 | read |
| S-I47 | I | **The suite went green while skipping all 11 patch-13 tests** after a stub shifted — fingerprints were a hand-maintained duplicate of builder knowledge. | tools/mksigs.py:8-12 | read |
| S-I48 | I | **`mkarchpage.py --check` (a mode it does not have) wrote a file named `--check` and looked like a pass**; `mkindex.py --chekc` would have regenerated the file it was asked to verify. | tools/health.sh:119-121 | read |
| S-I49 | I | **The first run of the sitting reported the shipped clash as dead on a byte-identical build** — the probe default had never been run. (→ trap 28) | HANDOFF.md:66-70 | read |
| S-C1 | C | **The three-step check shape**: 1. the claim is quoted FROM THE DOC and asserted still present; 2. the fact is DERIVED FROM THE ROM; 3. the two are compared. | tools/checkdocs.py:15-21 | read |
| S-C2 | C | “A check that only did step 2 would test my memory of the docs, not the docs.” | tools/checkdocs.py:22 | read |
| S-C3 | C | The Saturn variant adds step 4: “every check is re-run against a WRONG address or the WRONG GAME and required to fail — a cross-game check that passes when handed one image twice is comparing nothing.” | tools/saturn/checksaturndocs.py:24-26 | read |
| S-C4 | C | **Bindable form 1/6** — quoted instruction, attached: `` the box writer `$C0:9CCD` (`sta $41,X`) `` | docs/game/README.md:92-102 | read |
| S-C5 | C | **Bindable form 2/6** — quoted instruction after the address: `` `stz $47,X` at `$C1:0E4F` `` | docs/game/README.md:92-102 | read |
| S-C6 | C | **Bindable form 3/6** — quoted byte run: `` `$C1:0AF5` = `00 01 02 02` `` | docs/game/README.md:92-102 | read |
| S-C7 | C | **Bindable form 4/6** — file offset: `` $C0:D56F (file 0x00D56F) `` | docs/game/README.md:92-102 | read |
| S-C8 | C | **Bindable form 5/6** — disassembly listing row: `` C0/D055  rep #$30 `` | docs/game/README.md:92-102 | read |
| S-C9 | C | **Bindable form 6/6** — table row, subject in cell 1, quote later: `` \| $C3:BADE \| menu bound \| `sta $1F59` \| `` | docs/game/README.md:92-102 | read |
| S-C10 | C | Writing contract — “**Quote something.** … an unquoted address is a claim nobody can falsify.” An address alone can catch a later edit but never an address wrong the day it was written. | docs/game/README.md:84-91 | read |
| S-C11 | C | Writing contract — “**Describing an absence is fine and stays unchecked** … asserting it would invert the claim.” | docs/game/README.md:106-108 | read |
| S-C12 | C | Writing contract — “**In a table row, name the subject first.**” Otherwise the quote binds to the wrong address and nothing binds — which is usually what you meant. | docs/game/README.md:109-111 | read |
| S-C13 | C | **health.sh verdict classes**: `FAIL` definitely wrong → exit 1; `SKIP` needs a ROM/emulator/donor that is not here → not a failure; `NOTE` a convention count, reported and never fatal. | tools/health.sh:12-21 | read |
| S-C14 | C | **SETUP-FAIL is a third verdict class** — “A test that reports ‘the rule is broken’ when it merely failed to stage is the exact false verdict this project keeps paying for (trap 28).” | tools/test_clash_air.lua:39-42 | read |
| S-C15 | C | **Probe vs test** — “A test, not a probe: every claim below is asserted … exits non-zero if any of them fails. The exploratory instrument is `tools/probe_exp_clash.lua`; this one is the gate.” | tools/test_clash_ground.lua:3-5 | read |
| S-C16 | C | **Fixture / judgement split** — “This module owns the fixture and nothing else … The caller decides what is true.” Three private copies of subtle staging is how the next false verdict gets written. | tools/clashfixture.lua:1-7 | read |
| S-C17 | C | **Instrument honesty clause** — “Any instrument using `gate` is testing THE GATE, not a real air clash, and must say so in its own output.” | tools/clashfixture.lua:25-33 | read |
| S-C18 | C | **Assert a measured string, never an exit code** — “Every check asserts a MEASURED string, never just ‘the probe exited 0’.” | tools/saturn/verify_saturn.sh:14 | read |
| S-C19 | C | **Three distinct failure modes reported distinctly**: the run died / the run produced no trace / the trace holds the wrong verdict — they used to collapse into one empty “got: <nothing>”. | tools/saturn/verify_saturn.sh:48-52 | read |
| S-C20 | C | **Stated non-coverage** — checkdocs “does NOT check prose, reasoning, runtime behaviour, or anything about ARAM”, printed on every run so the green line is not over-read. | tools/checkdocs.py:45-49, :1496-1497 | read |
| S-C21 | C | **Validator purity** — “Every validator therefore takes `shift` and must derive EVERYTHING from the documented address plus that shift. Reading a second address from a literal would make the negative control lie.” | tools/checkdocs.py:472-474 | read |
| S-C22 | C | **CI names what it did not check** — the health workflow prints a “Not checked by CI” job summary listing the two gates that need a ROM and an emulator. | .github/workflows/health.yml:1-12, :30-44 | read |
| S-T1 | T | `tools/census_airroutes.py` — carries 1 negative-control site | tools/census_airroutes.py:90 | gen:G3 |
| S-T2 | T | `tools/census_motionbudget.py` — carries 2 negative-control sites | tools/census_motionbudget.py:75 | gen:G3 |
| S-T3 | T | `tools/census_onhit_flags.py` — carries 3 negative-control sites | tools/census_onhit_flags.py:15 | gen:G3 |
| S-T4 | T | `tools/checkdocs.py` — carries 4 negative-control sites | tools/checkdocs.py:468 | gen:G3 |
| S-T5 | T | `tools/checkknobs.py` — carries 1 negative-control site | tools/checkknobs.py:188 | gen:G3 |
| S-T6 | T | `tools/checkpatchmap.py` — carries 1 negative-control site | tools/checkpatchmap.py:247 | gen:G3 |
| S-T7 | T | `tools/checkskills.py` — carries 1 negative-control site | tools/checkskills.py:101 | gen:G3 |
| S-T8 | T | `tools/checktrainingdocs.py` — carries 1 negative-control site | tools/checktrainingdocs.py:342 | gen:G3 |
| S-T9 | T | `tools/cliguard.py` — carries 1 negative-control site | tools/cliguard.py:37 | gen:G3 |
| S-T10 | T | `tools/dis65816_oracle.py` — carries 4 negative-control sites | tools/dis65816_oracle.py:124 | gen:G3 |
| S-T11 | T | `tools/exp_airbackdash.py` — carries 1 negative-control site | tools/exp_airbackdash.py:90 | gen:G3 |
| S-T12 | T | `tools/probe_exp_airdash.lua` — carries 1 negative-control site | tools/probe_exp_airdash.lua:7 | gen:G3 |
| S-T13 | T | `tools/probe_exp_airspecial.lua` — carries 2 negative-control sites | tools/probe_exp_airspecial.lua:14 | gen:G3 |
| S-T14 | T | `tools/probe_exp_roster.lua` — carries 1 negative-control site | tools/probe_exp_roster.lua:5 | gen:G3 |
| S-T15 | T | `tools/probe_juggle.lua` — carries 3 negative-control sites | tools/probe_juggle.lua:16 | gen:G3 |
| S-T16 | T | `tools/saturn/checksaturndocs.py` — carries 1 negative-control site | tools/saturn/checksaturndocs.py:72 | gen:G3 |
| S-T17 | T | `tools/saturn/verify_dspdiff.sh` — carries 1 negative-control site | tools/saturn/verify_dspdiff.sh:76 | gen:G3 |
| S-T18 | T | `tools/saturn/verify_wramdiff.sh` — carries 1 negative-control site | tools/saturn/verify_wramdiff.sh:65 | gen:G3 |
| S-K1 | K | `tools/checkdocs.py` — quotes `docs/game/` claims, re-derives them from the cartridge, compares; prints COVERAGE | tools/checkdocs.py (1500 L) | read |
| S-K2 | K | `tools/saturn/checksaturndocs.py` — the Saturn corpus against **both** cartridges; wrong-address and wrong-game controls | tools/saturn/checksaturndocs.py (441 L) | read |
| S-K3 | K | `tools/checkpatchmap.py` — the patch documents against the `.bps` artifacts; regions pairwise disjoint; hash claims re-derived | tools/checkpatchmap.py (302 L) | read |
| S-K4 | K | `tools/checkknobs.py` — the knobs table against the builders, both directions (flags, defaults, env gates) | tools/checkknobs.py (221 L) | read |
| S-K5 | K | `tools/checktrainingdocs.py` — the training docs against the Lua package they describe | tools/checktrainingdocs.py (428 L) | read |
| S-K6 | K | `tools/checkskills.py` — the skill/human rule-ID sets, set-equal both ways, per pair | tools/checkskills.py (168 L) | read |
| S-K7 | K | `tools/dis65816_oracle.py` — our decode table against an INDEPENDENT one (vendored DisPel); corrupts its own table as the control | tools/dis65816_oracle.py (198 L) | read |
| S-K8 | K | `tools/cliguard.py` — tools must refuse options they do not define; 12-case sabotage-tested selftest | tools/cliguard.py (108 L) | read |
| S-K9 | K | `tools/docaddrs.py` — the address census the checks are built on; explicitly “a census, not a gate” | tools/docaddrs.py (557 L) | read |
| S-K10 | K | `tools/health.sh` — the one command for “is this tree consistent?”; FAIL/SKIP/NOTE; states it is not the gate | tools/health.sh (228 L) | read |
| S-K11 | K | `tools/test_regression.lua` — 68-case unified regression compendium; auto-detects which patches are present from generated fingerprints | tools/test_regression.lua (1265 L) | read |
| S-K12 | K | `tools/saturn/verify_dspdiff.sh` — 4-stage harness self-check: DETERMINISM / INERTNESS / SENSITIVITY / NEGATIVE | tools/saturn/verify_dspdiff.sh (83 L) | read |
| S-K13 | K | `tools/saturn/verify_wramdiff.sh` — 3-stage harness self-check: DETERMINISM / SENSITIVITY / NEGATIVE | tools/saturn/verify_wramdiff.sh (72 L) | read |
| S-K14 | K | `tools/saturn/verify_saturn.sh` — the full headless Saturn gate; asserts measured strings, exits 1 on any failure | tools/saturn/verify_saturn.sh (265 L) | read |
| S-K15 | K | `tools/test_clash_ground.lua` — 7–9 asserted checks per case (win/tie/hold) on the shared fixture | tools/test_clash_ground.lua (138 L) | read |
| S-K16 | K | `tools/test_clash_air.lua` — asserts both halves of the airborne ruling, including the negative | tools/test_clash_air.lua (162 L) | read |
| S-G1 | G | `docs/project/patch_index.md` — the one-page patch registry: every patch, status, lifecycle, recorded hashes | docs/project/patch_index.md (111 L) | read |
| S-G2 | G | `tools/README.md` — the tool index, **generated** from each script's first header line; `--check` verifies sync | tools/README.md:3-4 (540 L); `python3 tools/mkindex.py --check` → 500 scripts, 11 groups | read |
| S-G3 | G | `tools/checkskills.py` REPO_PAIRS / USER_PAIRS — the registry of rule-set renditions and their prefixes | tools/checkskills.py:41-53 | read |
| S-G4 | G | `EXPECTED_CHECKS = 65` — “issue #7: a check that never runs must fail the suite” (a registry of how many assertions must have executed) | tools/test_p11_tier1.lua:15, :361-363 | read |
| S-G5 | G | `TABLES` registry — 17 documented tables, each declared with a shape validator, its docs, and the shifts its negative control uses | tools/checkdocs.py:488-493 | read |
| S-G6 | G | `SIGS` block — per-patch detection fingerprints, generated into the suite from each builder's own `SIG` export (builders OWN their fingerprint) | tools/test_regression.lua:49 (SIGS-BEGIN); tools/mksigs.py:4-12 | read |
| S-G7 | G | `docs/README.md` / `docs/game/README.md` / `docs/project/README.md` / `docs/game/characters/README.md` — the four docs maps | docs/README.md:1; docs/game/README.md:1; docs/project/README.md:1; docs/game/characters/README.md:1 | read |
| S-D1 | D | `SMS_DIST = 64` — the clash fixture's gap. “64 is where the two hitboxes actually overlap for this fixture, established by sweeping (62 one-sided, 64/66/68/72 clash).” | tools/clashfixture.lua:20-24, :46 | read |
| S-D2 | D | `SMS_DIST` old default 56 — the value that “clashes on NOTHING” and produced a false dead verdict; recorded as trap 28 rather than silently changed | HANDOFF.md:66-70; tools/clashfixture.lua:20-22 | read |
| S-D3 | D | `SMS_CFRAMES = 180` — contest length; the header states it “must match `--clash-frames`”, i.e. the default is a claim about the build under test | tools/test_clash_ground.lua:10-11, :24 | read |
| S-D4 | D | `SMS_NEAR = 90` — “90 is measured: swept 30-110, and only a lead of >= 75 puts his active frames under the ball (below that … the run is VOID, not a pass).” | tools/probe_exp_projclash.lua:34-37 | read |
| S-D5 | D | HP boundary 153 — “MEASURED 2026-09-05 by sweeping SMS_HPSET: act $21 fires at hp 153, 155 and 157 and does NOT at 149 or 151 — exactly the predicted boundary.” | tools/exp_animeroster.py:1233-1234 | read |
| S-D6 | D | `SMS_AIRPRESS` {6,10,14} × `SMS_P1PRESS` {4,8,12} — the nine-combination sweep that produced ZERO clashes and demoted the `jump` case to SETUP-FAIL | tools/test_clash_air.lua:33-37 | read |
| S-D7 | D | `shifts=(1, 2)` — the default wrong-base offsets every table validator is re-run at and required to fail | tools/checkdocs.py:477 | read |
| S-D8 | D | Structural enrolment floor — an address is enrolled only if its predicate fails at base+1 **and** base+2, and the tier prints the % of random nearby addresses it also holds for | tools/checkdocs.py:1325, :1477-1481; HANDOFF.md:128-130 | read |
| S-D9 | D | `REV_S` / `REV_SS` — release revisions resolved from `smspaths`, never hardcoded: a hardcoded default “silently verified an obsolete build … three times in one day” | tools/saturn/verify_saturn.sh:19-24 | read |
| S-R1 | R | [SMS-1] Clean ROM: SHA-1 `bc0e29ee383574443226695215496eb0d09aaa1c`, HiROM+FastROM, headerless, 2.5 MB. Roster charID 1-9 (1 Moon … 6 Uranu… | docs/game/sms_hacking_playbook.md:21 | gen:G1 |
| S-R2 | R | [SMS-2] The engine is data-driven: a character can ship with wrong data and the engine will faithfully do the wrong thing. Most features ar… | docs/game/sms_hacking_playbook.md:30 | gen:G1 |
| S-R3 | R | [SMS-3] **THE NINE-WIDE-TABLE LAW**: every per-character table is sized to exactly nine and immediately followed by live data. Adding a row… | docs/game/sms_hacking_playbook.md:35 | gen:G1 |
| S-R4 | R | [SMS-4] On-hit tables are GLOBAL, strength-class indexed — a hitstun/damage edit there changes every character's move of that class. Never… | docs/game/sms_hacking_playbook.md:46 | gen:G1 |
| S-R5 | R | [SMS-5] Hit resolution is not a stage of the frame loop: the ATTACKER's own proc resolves the hit, and the victim's reaction lands at the t… | docs/game/sms_hacking_playbook.md:50 | gen:G1 |
| S-R6 | R | [SMS-6] The step-0 init is a per-handler CONTRACT enforced by nothing (~87 hand-written handlers per character) — an omitted init survives… | docs/game/sms_hacking_playbook.md:56 | gen:G1 |
| S-R7 | R | [SMS-7] Act tables are 107-122 entries per character, NOT 128 — 128 is the Super S figure. | docs/game/sms_hacking_playbook.md:61 | gen:G1 |
| S-R8 | R | [SMS-8] The engine processes attacks starting the frame AFTER action start, and inputs latch at 30 Hz — mind both when counting frames ([SN… | docs/game/sms_hacking_playbook.md:65 | gen:G1 |
| S-R9 | R | [SMS-9] Death is HP UNDERFLOW, not zero: HP 0 is survivable and chip damage never kills. Damage has no RNG (apparent jitter is the defender… | docs/game/sms_hacking_playbook.md:69 | gen:G1 |
| S-R10 | R | [SMS-10] There are MULTIPLE proc dispatchers (players, projectile pool, effect pool, plus indirect dispatch sites in other banks) — hooking… | docs/game/sms_hacking_playbook.md:76 | gen:G1 |
| S-R11 | R | [SMS-11] Projectiles live in their own slots and pick box tables by their OWN object id, not the owner's charID; only the HIT pointer table… | docs/game/sms_hacking_playbook.md:82 | gen:G1 |
| S-R12 | R | [SMS-12] `$7E:008D` mode byte: 0 = story, 1 = 2P VS, 2 = 1P-vs-COM, 4/5 = training. The vendor Lua's comment (0=VS, 1=story) is WRONG and s… | docs/game/sms_hacking_playbook.md:90 | gen:G1 |
| S-R13 | R | [SMS-13] Practice mode draws NO HUD and no nameplates, and the HUD producer never runs there — a hook on it is dead in the mode people trai… | docs/game/sms_hacking_playbook.md:96 | gen:G1 |
| S-R14 | R | [SMS-14] In 1P-vs-COM, P1's pad confirms BOTH characters — a harness mashing P2 stalls at character select forever. | docs/game/sms_hacking_playbook.md:101 | gen:G1 |
| S-R15 | R | [SMS-15] A live round flag does not mean the players can act: fighters sit in the entrance act while "GO!" is up and pads do nothing. Menu… | docs/game/sms_hacking_playbook.md:105 | gen:G1 |
| S-R16 | R | [SMS-16] Round transitions re-init both player structs on the same frame — per-round mechanics must re-apply or track state outside the str… | docs/game/sms_hacking_playbook.md:112 | gen:G1 |
| S-R17 | R | [SMS-17] OBJ palette rows are DYNAMIC (reloaded per effect): a palette census needs a REAL match that lands hits — a practice-mode sample m… | docs/game/sms_hacking_playbook.md:118 | gen:G1 |
| S-R18 | R | [SMS-18] Win-screen reachability (headless): vs-COM has no round clock, the COM guards jabs indefinitely, and throw damage is chip-class (c… | docs/game/sms_hacking_playbook.md:124 | gen:G1 |
| S-R19 | R | [SMS-19] `$7E:1B1E` names the CHARACTER, not the player — identify the player from the per-player writers of it, or a ported/renamed charac… | docs/game/sms_hacking_playbook.md:129 | gen:G1 |
| S-R20 | R | [SMS-20] The win-nameplate font is MATCHUP-LOADED, not a resident A-Z — which glyphs exist depends on the two names on screen. | docs/game/sms_hacking_playbook.md:134 | gen:G1 |
| S-R21 | R | [SMS-21] **LAW 1**: a screen transition can clear ALL 64 KB of VRAM and the destination reloads only its OWN asset list — an asset must be… | docs/game/sms_hacking_playbook.md:144 | gen:G1 |
| S-R22 | R | [SMS-22] **LAW 2**: blank ≠ unreferenced — three separate screens reference blank-looking tiles through another BG's CHR base ([SNES-18]). | docs/game/sms_hacking_playbook.md:150 | gen:G1 |
| S-R23 | R | [SMS-23] **LAW 3**: DMA is invisible to CPU write callbacks ([SNES-14]) — every menu freedom/arrival claim needs snapshots and a watch toge… | docs/game/sms_hacking_playbook.md:155 | gen:G1 |
| S-R24 | R | [SMS-24] Runtime records OVERDRAW baked map text: option VALUES (and anything highlight-dependent) cannot be translated in the tilemap — fi… | docs/game/sms_hacking_playbook.md:159 | gen:G1 |
| S-R25 | R | [SMS-25] Asset records are `[vram16][len16][src24][dest24]` — the upload LENGTH sits 2 bytes BEFORE the source pointer. Reach records by wa… | docs/game/sms_hacking_playbook.md:164 | gen:G1 |
| S-R26 | R | [SMS-26] Menu glyphs are 2x2 tiles in a 16-tile-wide sheet, and the kana block loads at a DIFFERENT base per screen — read the generated co… | docs/game/sms_hacking_playbook.md:173 | gen:G1 |
| S-R27 | R | [SMS-27] The stock codec-1 encoder is WEAKER than the original's: an edited compressed block must be relocated and repointed, never written… | docs/game/sms_hacking_playbook.md:182 | gen:G1 |
| S-R28 | R | [SMS-28] The bank-`$DF` screen engine (Win/Tournament/bracket) executes from the `$9F` mirror — stubs at `$8000+` only, DB = bank − `$40` (… | docs/game/sms_hacking_playbook.md:189 | gen:G1 |
| S-R29 | R | [SMS-29] Stage-name records: NO terminator, centred by zero padding ([RH-28]), 12-glyph ceiling regardless of apparent free space. The menu… | docs/game/sms_hacking_playbook.md:196 | gen:G1 |
| S-R30 | R | [SMS-30] Verify glyph delivery by dumping ON the font transfer with the POKE positive control (0/256 bytes arrive clean, 256/256 patched) —… | docs/game/sms_hacking_playbook.md:204 | gen:G1 |
| S-R31 | R | [SMS-31] Text may be on BG3 (2bpp, own CHR base, needs the priority bit in the attribute) — check WHICH LAYER a surface is on before aiming… | docs/game/sms_hacking_playbook.md:210 | gen:G1 |
| S-R32 | R | [SMS-32] Boot copy loops spray junk through `$7F` — any flag parked there must be MAGIC-VALUED (e.g. `$A5`), so corruption can only ever ca… | docs/game/sms_hacking_playbook.md:218 | gen:G1 |
| S-R33 | R | [SMS-33] `$7E:1F60+` is menu-engine state, and menu code runs BETWEEN character select and round load — WRAM freedom claims need a watch ac… | docs/game/sms_hacking_playbook.md:222 | gen:G1 |
| S-R34 | R | [SMS-34] Every Lua tool bootstraps `sms_env.lua`: flat `tools/` scripts with `/sms_env.lua`, `tools/saturn/` scripts with `/../sms_env.lua`… | docs/game/sms_hacking_playbook.md:231 | gen:G1 |
| S-R35 | R | [SMS-35] NEVER hand-edit the regression suite's SIGS block — regenerate with `mksigs.py --write` ([RH-53]); a hand-pinned byte silently ski… | docs/game/sms_hacking_playbook.md:236 | gen:G1 |
| S-R36 | R | [SMS-36] Every chained builder step requires `--stacked`; ROMs resolve via `smspaths.py` (`$SMS_ROM_DIR` → `roms/` → `../roms/`) and are ne… | docs/game/sms_hacking_playbook.md:241 | gen:G1 |
| S-R37 | R | [SMS-37] Savestates are tracked (force-added, deliberately); screenshots and any game imagery NEVER are — `git add -f` is not an escape hat… | docs/game/sms_hacking_playbook.md:246 | gen:G1 |
| S-R38 | R | [SMS-38] Button map, empirically: Y=LP, X=HP, B=LK, A=HK — the vendor Lua's comment is wrong. | docs/game/sms_hacking_playbook.md:253 | gen:G1 |
| S-R39 | R | [SSP-1] SMS and Super S are the SAME ENGINE with small per-routine shifts: byte inequality ≠ code inequality (find twins by signature/skele… | docs/project/saturn/porting_lessons.md:16 | gen:G1 |
| S-R40 | R | [SSP-2] Engine object ids are SHIFTED: Super S id N == SMS id N−1 (for N ≥ 0x31). Re-base every spawn record in ported code, or the wrong o… | docs/project/saturn/porting_lessons.md:23 | gen:G1 |
| S-R41 | R | [SSP-3] Inherited tooling is donor-derived: treat its Saturn references as inapplicable to the SMS image ([SMS-1]), and validate any inheri… | docs/project/saturn/porting_lessons.md:28 | gen:G1 |
| S-R42 | R | [SSP-4] Donor fixtures can silently be the WRONG game's dumps — hash-check which cartridge a trace/ARAM dump came from before using it as a… | docs/project/saturn/porting_lessons.md:35 | gen:G1 |
| S-R43 | R | [SSP-5] Cross-game identity claims are measured per subsystem and stated WITH their caveats inline: "scripts byte-identical" held only afte… | docs/project/saturn/porting_lessons.md:39 | gen:G1 |
| S-R44 | R | [SSP-6] **THE SHELL RULE**: Saturn wears a host character as a shell, so any fix keyed to CHARACTER data works for one shell only and looks… | docs/project/saturn/porting_lessons.md:48 | gen:G1 |
| S-R45 | R | [SSP-7] Guard the thing that ARMS, not the things that act: every consumer keys off the summon FLAG, so a restriction placed at the transfo… | docs/project/saturn/porting_lessons.md:56 | gen:G1 |
| S-R46 | R | [SSP-8] Structural locks beat mode interrogation: restrict WHICH SHELLS can arm her (the ones story mode cannot reach) rather than asking w… | docs/project/saturn/porting_lessons.md:63 | gen:G1 |
| S-R47 | R | [SSP-9] A summoned character's reachable palette slots are 4-7 only (the L+R summon chord doubles as the palette modifiers): MASK the slot,… | docs/project/saturn/porting_lessons.md:68 | gen:G1 |
| S-R48 | R | [SSP-10] Transfers sized from the SHELL truncate ported data: one shell's smaller effect sheet cut 15 tiles from hers and only that shell s… | docs/project/saturn/porting_lessons.md:74 | gen:G1 |
| S-R49 | R | [SSP-11] A visible char-select slot is the exact surface the story lock exists to avoid — the hidden summon is the only select variant, by… | docs/project/saturn/porting_lessons.md:82 | gen:G1 |
| S-R50 | R | [SSP-12] The build grafts a full COPY of the proc bank: hooks applied to the original after the copy protect only half the paths ([RH-37/38… | docs/project/saturn/porting_lessons.md:89 | gen:G1 |
| S-R51 | R | [SSP-13] When stacking, take bank copies AFTER other patches' edits to that bank — box-data patches edit the real bank, and a copy taken fi… | docs/project/saturn/porting_lessons.md:97 | gen:G1 |
| S-R52 | R | [SSP-14] A donor sentinel record ("no cel", size 0) is LIVE data in the host: SMS does not skip it, and a 0-length DMA wipes all of VRAM ([… | docs/project/saturn/porting_lessons.md:101 | gen:G1 |
| S-R53 | R | [SSP-15] Truncated grafts fail LATE and silently: a code graft cut short executes stale copy bytes mid-handler; a data graft one pair short… | docs/project/saturn/porting_lessons.md:106 | gen:G1 |
| S-R54 | R | [SSP-16] LIFT donor tables rather than authoring where possible — byte-identical shared rows are the proof the semantics match. Before fixi… | docs/project/saturn/porting_lessons.md:113 | gen:G1 |
| S-R55 | R | [SSP-17] Scene scripts have four parts; only the sprite-attribute byte may be carried across from the donor — the other parts are host-side… | docs/project/saturn/porting_lessons.md:121 | gen:G1 |
| S-R56 | R | [SSP-18] Stages are SWAPPED, not added: the scene pointer table is exactly ten entries with the scripts immediately after — [SMS-3]'s shape… | docs/project/saturn/porting_lessons.md:126 | gen:G1 |
| S-R57 | R | [SSP-19] The per-character BRR directory is resident from BOOT and never refreshed per match: loading her bank under borrowed ids plays aud… | docs/project/saturn/porting_lessons.md:133 | gen:G1 |
| S-R58 | R | [SSP-20] The relocating uploader adds a DP offset to every destination — never append to that stream directly, or the block lands 16 bytes… | docs/project/saturn/porting_lessons.md:140 | gen:G1 |
| S-R59 | R | [SSP-21] Her samples have TWO native rates — a measurement of one set is NOT confirmation of the other ([RH-33]). | docs/project/saturn/porting_lessons.md:144 | gen:G1 |
| S-R60 | R | [SSP-22] The driver plays samples as NOTES ON A SCALE: pitch is one signed transpose byte per sound, character-specific. The DSP's SRCN reg… | docs/project/saturn/porting_lessons.md:148 | gen:G1 |
| S-R61 | R | [SSP-23] Borrowing an existing character's PER-PLAYER sound ids covers all nine shells with no per-shell code — it dodges [SSP-6] by constr… | docs/project/saturn/porting_lessons.md:156 | gen:G1 |
| S-R62 | R | [SSP-24] Super S ships exactly TWO palettes per character (the other manifest pointers are the icon and effects palettes); extra costume pa… | docs/project/saturn/porting_lessons.md:161 | gen:G1 |
| S-R63 | R | [SSP-25] Cross-game doc checks run against BOTH cartridges, SKIP loudly when the donor is absent ([RH-55]), and carry their own negative co… | docs/project/saturn/porting_lessons.md:174 | gen:G1 |
| S-R64 | R | [SSP-26] Ported code blocks are gated byte-identical (`port_saturn_proc.py --check`) and the decode table behind the porter is oracle-valid… | docs/project/saturn/porting_lessons.md:178 | gen:G1 |
| S-R65 | R | [SSP-27] Port bundles are UNTRACKED (they embed donor cels/palettes/samples): rebuild from source behind the named gate script. The verify… | docs/project/saturn/porting_lessons.md:183 | gen:G1 |
| S-R66 | R | [SSP-28] The constraint model: ROM is NOT scarce (hundreds of KB spare), ARAM is the only hard wall ([SNES-25]), and the real cost of a ten… | docs/project/saturn/porting_lessons.md:190 | gen:G1 |
| S-X1 | X | Latest commit `ecc5481` — “exp: ties go to P2, and two clash tests on a shared fixture”; body carries the maintainer ruling, the framing correction, artifact hashes and a `Gates:` line | `git log -1` | read |
| S-X2 | X | Commit-subject prefixes: `docs:` 64 · `p16:` 33 · `exp:` 25 · `tools:` 11 — documentation work is the single largest commit class | `git log --format='%s' \| grep -oE '^[a-z0-9]+:' \| sort \| uniq -c \| sort -rn` | read |
| S-X3 | X | `traces/` is gitignored; the only tracked traces are 30 `.mss` savestates — the fixtures suites load. Logs, dumps and screenshots stay local. | .gitignore:6, :35-44; `git ls-files 'traces/*.mss' 'traces/**/*.mss' \| wc -l` → 30 | read |
| S-X4 | X | `build/` tracks only `.bps`/`.ips`; no `.sfc` is ever tracked, so a build is reproduced from its patch | .gitignore:44-51; `git ls-files build \| wc -l` → 37 | read |
| S-X5 | X | Two docs are published as CI-rendered HTML pages, never committed as build output (`mkarchpage.py`, `mkenginepage.py` → `/frame.html`) | docs/game/README.md:12-22; .github/workflows/pages.yml:1-14 | read |
| S-X6 | X | The nine `docs/game/characters/*.md` pages are generated: “every address on this page is read out of the cartridge, not transcribed. Do not hand-edit.” | docs/game/characters/uranus.md:5-8 | read |
| S-X7 | X | `docs/` is split by lifetime, not topic: “would this still be true … to someone who had never heard of this project?” decides `game/` vs `project/` | docs/README.md:11-13 | read |
| S-X8 | X | The playbook deliberately quotes **no ROM addresses** so the checked reference docs stay the only address authority | docs/game/sms_hacking_playbook.md:10-14 | read |
| S-X9 | X | “`history/` holds the original brief, superseded and kept as a record of how the ROM map was derived” — the folder holds one file, `claude_code_spec.md` (62 L) | docs/project/README.md:22-23 | read |
| S-X10 | X | No forward reference to VampireSaved, blackbox-harness, `bbh`, or the term “black box” exists anywhere in the repo (A92–A94) | — | read |

## C. Generators

Each script below is run from the repo root of `SailorMoonS` and prints the rows marked with the matching `gen:` tag. They read only.

### G1 — the 66 `S-R*` rule rows

```python
# python3 - <<'PY'
import re
PAIRS = [("SMS", ".claude/skills/sms-romhacking/SKILL.md", "docs/game/sms_hacking_playbook.md"),
         ("SSP", ".claude/skills/supers-porting/SKILL.md", "docs/project/saturn/porting_lessons.md")]
n = 0
for pfx, skill, human in PAIRS:
    sl = open(skill, encoding="utf-8").read().split("\n")
    hl = open(human, encoding="utf-8").read().split("\n")
    anchor = {}
    for i, l in enumerate(hl, 1):
        m = re.match(r"^\*\*\[(%s-\d+)\]\*\*" % pfx, l)
        if m: anchor[m.group(1)] = i
    for i, l in enumerate(sl):
        m = re.match(r"^- \[(%s-\d+)\] " % pfx, l)
        if not m: continue
        rid = m.group(1); buf = [l[2:]]; j = i + 1
        while j < len(sl) and sl[j].strip() and not re.match(r"^- \[", sl[j]) and not sl[j].startswith("#"):
            buf.append(sl[j].strip()); j += 1
        t = re.sub(r"\s+", " ", " ".join(buf)).strip()
        if len(t) > 140: t = t[:139].rstrip() + "\u2026"
        n += 1
        print("| S-R%d | R | %s | %s:%d | gen:G1 |" % (n, t.replace("|", "\\|"), human, anchor[rid]))
# PY
```

Emits **66** rows: 38 `[SMS-N]` + 28 `[SSP-N]`. `item` is the agent-rendition text (continuation lines joined, whitespace collapsed, truncated at 140 chars); `source` is the anchor line of the same rule's definition in the human rendition. The two sets are proven equal by `python3 tools/checkskills.py`.

### G2 — the 23 collected-trap `S-I*` rows

```python
# python3 - <<'PY'
import re
src = "HANDOFF.md"; L = open(src, encoding="utf-8").read().split("\n")
out = []; i = 0
while i < len(L):
    m = re.match(r"^(\d+)\. ", L[i])
    if m:
        buf = [L[i]]; j = i + 1
        while j < len(L) and L[j].strip() and not re.match(r"^\d+\. ", L[j]):
            buf.append(L[j].strip()); j += 1
        t = re.sub(r"\s+", " ", " ".join(buf))
        b = re.search(r"\*\*(.+?)\*\*", t)
        out.append((int(m.group(1)), i + 1, b.group(1) if b else t[:100])); i = j
    else: i += 1
out.sort()
for k, (num, ln, title) in enumerate(out, 1):
    t = "Trap %d \u2014 %s" % (num, title)
    if len(t) > 140: t = t[:139].rstrip() + "\u2026"
    print("| S-I%d | I | %s | %s:%d | gen:G2 |" % (k + 11, t.replace("|", "\\|"), src, ln))
# PY
```

Emits **23** rows. The paragraph is joined before the bold title is extracted, because several trap titles wrap across two lines. Traps 24–28 are not in this ledger — they are filed inline beside the work that paid for them, so they are `read` rows.

### G3 — the 18 `S-T*` negative-control rows

```bash
grep -rli 'negative control' --exclude-dir=.git --include='*.py' --include='*.lua' --include='*.sh' . \
  | sed 's|^\./||' | sort \
  | while read f; do
      ln=$(grep -ni 'negative control' "$f" | head -1 | cut -d: -f1)
      n=$(grep -ci 'negative control' "$f")
      echo "$f|$ln|$n"
    done
```

Emits **18** rows (30 sites total). Docs that only *describe* a negative control (`CLAUDE.md`, `HANDOFF.md`, the two `SKILL.md` files, three `docs/project/` pages — 7 more files, 25 in total) are deliberately excluded: a `T` row is a file that **carries** a control, not one that mentions the idea.

## D. Not looked at

- **The ROM, the Super S donor, and any `.sfc`/`.smc`/`.bps`/`.ips`/`.mss` binary.** None are in the repo (ROMs are gitignored by policy) and none were opened. Every ROM-dependent number in this census is therefore either re-derived from source text or quoted as a **filed** number with its `path:line`.
- **Every ROM-dependent tool was left unrun**: `checkdocs.py`, `checksaturndocs.py`, `checkpatchmap.py`, `mkcharmap.py --check`, `mkenginepage.py --check`, `dis65816_oracle.py`, `port_saturn_proc.py --check`, and all `mkpatch*.py`. Only the six ROM-free tools were executed: `docaddrs.py`, `checkskills.py`, `checkknobs.py`, `checktrainingdocs.py`, `cliguard.py`, `mkindex.py --check`.
- **`tools/health.sh` was not run** — it shells out to ROM-dependent tools and (in its cliguard section) deletes a stray file, so it is not read-only.
- **No emulator suite was run**: `test_regression.lua`, `test_p11/p12/p13`, `test_clash_ground/air.lua`, `training_test.lua`, `verify_saturn.sh`, `verify_dspdiff.sh`, `verify_wramdiff.sh`. Their headers were read; their verdicts were not produced.
- **Probe bodies**: 317 `probe_*` scripts (150 root + 167 saturn) were counted and indexed but not read past their headers, except `probe_exp_projclash.lua`, `probe_juggle.lua`, `probe_exp_airdash.lua`, `probe_exp_airspecial.lua`, `probe_exp_roster.lua` (opened only at their negative-control lines).
- **Builder bodies**: the 18 `mkpatch*.py` (up to 1800 L each) and `exp_animeroster.py` were counted and spot-read for thresholds only.
- **`traces/`**: 5332 files on disk, 30 tracked; none opened (all binary savestates or gitignored logs).
- **`mockups/` and `vendor/`**: untracked, gitignored, not inspected.
- **Long reference docs read only in part**: `patch_notes.md` (2224 L), `menu_text.md` (1696 L), `saturn/sound_scope.md` (1049 L), `sms_specials.md` (1046 L), `sms_data_architecture.md` (1039 L, headers + §13), `annotations.md` (977 L, headers + 3 rows).
- **Git history bodies**: 574 commits were counted and the last 12 subjects read; only `ecc5481`'s body was read in full. No `git log -p`, no diffs.
- **The user-level skills** `romhacking-methodology` and `snes-romhacking`, where `[RH-N]` (29 refs) and `[SNES-N]` (28 refs) are actually defined — they live outside this repo and were not opened.

Corrected 2026-09-09 after verification: A45, S-I2, S-I3, S-I4, S-I5, S-I6, S-I43, S-I48, S-X9, S-X10, and generator G2 (id offset `k + 10` → `k + 11`).

---

Measured read-only on 2026-09-09 at `ecc5481`; the `SailorMoonS` working tree was not modified (`git status --porcelain \| wc -l` → 0, before and after).

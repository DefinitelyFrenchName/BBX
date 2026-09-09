# The census — what was counted, by whom, and who re-counted it

Shape: reference page (the protocol and the verification record). The census
itself is three files, one per lineage repository, each measured at a
recorded HEAD:

| file | repository | local path | HEAD | tracked |
|---|---|---|---|---|
| `bbh.md` | blackbox-harness | `~/Developer/blackbox-harness` | `f675710` | 190 |
| `vampiresaved.md` | VampireSaved | `~/Developer/Vampire_Saved/VampireSaved` | `0cdd9726` (re-measured bbx-2; born at `5df1d8be`) | 7497 |
| `sms.md` | SMS-FrenchName-edition | `~/Developer/SailorMoonS` | `ecc5481` | 633 |

## The protocol (DECISIONS.md M2, M3)

1. A **producer** agent, confined to one repository, writes the census file.
   Every count carries the command that produced it; every item row carries
   `gen:<generator>` (a script emitted it — the script is in the file's §C)
   or `read` (hand-read, path:line given).
2. A **verifier** agent, different from the producer, re-runs every command in
   §A and every generator in §C at the recorded HEAD and reports match or
   mismatch per row. Its table is appended below, verbatim.
3. The **orchestrator** re-derives the headline numbers independently and
   records the run below.
4. Any number a producer *reported* rather than *ran* is labelled `filed:`
   with its source, never promoted.
5. A mismatch is reported; nothing is averaged or adjusted (CLAUDE.md §1).

The recount script is `lib/py/bbx/recount.py` (`bin/bbx recount`, slice S1
step 1, ruled R9); the commands stay in the files so a recount by hand stays
possible. (This paragraph said "no recount script exists yet" until bbx-2: a
sentence that was true at birth and rotted the day the tool landed.)

## The census grammar (read by `lib/py/bbx/recount.py`; ruled into existence by R9/R14)

A census file is a document the harness reads, so its shape is a contract:

1. Line 1 ends `@ <HEAD> — measured <date>`; the HEAD is what `git rev-parse
   HEAD` at the repository started with (7 or more hex digits).
2. Line 2 names the repository's local path as the first backtick-quoted
   absolute path.
3. `## A. Counts` is a table `| id | dimension | count | command |`, ids
   `A<n>`. Every `|` inside a cell is written `\|` — code spans included, as
   GitHub-flavoured markdown requires. A regex that needs a literal pipe writes
   a bracket expression `[\|]`. A command that contains a backtick is wrapped
   in a double-backtick span.
4. A row is RECOUNTABLE when its count is a plain integer (bold and commas
   allowed) or one backtick-quoted string, and its command cell opens with a
   backtick span whose pipeline, run with `sh -c` from the repository root,
   prints exactly that value on stdout (leading and trailing whitespace
   ignored). A command that prints a filename after the number, a histogram,
   or a sentence is not recountable as written and is rewritten to print the
   number alone (`wc -l < file`, `… \| awk '$2=="window"{print $1}'`), then
   re-run before the count is kept.
5. Every other row is NOT-RECOUNTABLE; the recount names it and counts it.
   The number of such rows is the census's uncovered claims (BBX-18), printed
   in every readout and allowed to move only downward.
6. Commands run under `sh` in a HERMETIC environment: `PATH` pinned to the
   system directories, `LANG`/`LC_ALL` fixed to `C.UTF-8`, nothing else from
   the caller's shell (`docs/defaults.md` D6). A command that searches the
   working tree recursively (`grep -r …`) is not admitted: ignored files make
   its count a fact about the host, and the first recount found this shell's
   `grep` (ugrep, skips ignored files and archives) and `sh`'s `grep` (BSD,
   reads everything) disagreeing on six counts. Searches use `git grep`, whose
   universe is the tracked tree at the recorded HEAD.

The first recount (2026-09-09, slice S1) found the three files written in two
pipe conventions and 10 rows malformed; the files were normalized to this
grammar (65 bbh rows by script, 11 rows by hand, listed in
`DECISIONS_HISTORY.md`) before any count was compared.

## Orchestrator re-derivation — 2026-09-09

Run from the BBX session, one shell, after the producers' maps and before
their files (so it is independent of the files' contents). Output verbatim:

```
== HEADs ==
/Users/koneko/Developer/blackbox-harness f675710
/Users/koneko/Developer/Vampire_Saved/VampireSaved 5df1d8be
/Users/koneko/Developer/SailorMoonS ecc5481
== bbh ==
BBH rules: 87
anchor pages: 9 sum=87
selftests: 32 must-fire: 23
config keys doc: 121 code: 116 16
thresholds: _DEFAULTS = {"flicker_max": 2, "reconverge": 60, "flicker_max_total": 8}
comparators: 7
F rows: 11 + mame 8
kinds: diverge) masked) pending) sha1) skip)
dirty: 4  4 files changed, 6 insertions(+), 6 deletions(-)
== VS ==
ALL PASS (555 rules across 8 skills: every rule anchored once, every anchor defined, level 1 game-free, every number in a log)
cps2-emulation=42 cps2-hardware=30 mame-fbneo-instruments=46 mister-cps2-wide-core=73 mister-jtframe-core=63 mister-vampire-saved=36 vampire-saved-port=180 vampire-savior-engine=85
gates tracked: 319 in-tree: 311
must-fire gates: 74
expected files: 4808
.masked=2311 .skip=778 .sha1=719 .pending=6 .diverge=0
gotchas: 242+111+57+ paid: 77+25+6+
rot classes: 7
MFI ids: 46 999
== SMS ==
ALL PASS (66 rules across 2 pairs; both renditions define the same IDs, both ways)
traps: 23 + 5
corollaries: 7
memory-of-docs: 22
checks: @check=37 @table=17
```

The commands (one block, run from any directory):

```sh
B=~/Developer/blackbox-harness; V=~/Developer/Vampire_Saved/VampireSaved; S=~/Developer/SailorMoonS
for r in $B $V $S; do printf "%s " "$r"; git -C $r rev-parse --short HEAD; done
cd $B
git grep -ohE '\[BBH-[0-9]+\]' | sed 's/[][]//g' | sort -u -t- -k2 -n | wc -l
git grep -c -E '\*\*\[BBH-[0-9]+\]\*\*' -- '*' | grep -v GUIDE | wc -l
git grep -c -E '\*\*\[BBH-[0-9]+\]\*\*' -- '*' | grep -v GUIDE | awk -F: '{s+=$2} END{print s}'
ls selftest/test_*.sh | wc -l; git grep -il must-fire -- selftest | wc -l
grep -cE '^\| `' docs/config.md
PYTHONPATH=lib/py python3 -c 'from bbh import config as C; print(sum(len(d) for d in C.DEFAULTS.values()), len(C.DEFAULTS))'
sed -n 28p lib/py/bbh/thresholds.py
ls lib/py/bbh/compare_*.py lib/py/bbh/check_*.py lib/py/bbh/describe_masked_shape.py | wc -l
grep -c '^#   F' selftest/test_fidelity_vampire.sh; grep -c '^#   F' selftest/test_fidelity_mame.sh
grep -oE "(masked|skip|sha1|diverge|pending)\)" lib/sh/enumerate_expectations.sh | sort -u
git status --porcelain | wc -l; git diff --stat | tail -1
cd $V
python3 tools/checkskills.py -v 2>&1 | tail -1
for f in .claude/skills/*/SKILL.md; do printf "%s=%s " "$(basename $(dirname $f))" "$(grep -cE '^- \[[A-Z]+-[0-9]+\]' $f)"; done; echo
git ls-files 'tests/*.sh' | wc -l; ls tests/*.sh | wc -l
git grep -lie 'must.fire' -- 'tests/*.sh' | wc -l
git ls-files tests/expected | wc -l
for e in masked skip sha1 pending diverge; do printf ".%s=%s " $e "$(git ls-files "tests/expected/*.$e" | wc -l | tr -d ' ')"; done; echo
for f in docs/project/gotchas.md docs/platform/gotchas.md docs/game/gotchas.md; do grep -c '^## ' $f; grep -oc 'paid:' $f; done
grep -cE '^[0-9]\. \*\*THE ' docs/project/harness_hardening_history.md
git grep -ohE 'MFI-[0-9]+' | sed 's/MFI-//' | sort -n | uniq | tail -2
cd $S
python3 tools/checkskills.py 2>&1 | tail -1
grep -cE '^[0-9]+\. \*\*' HANDOFF.md; grep -cE 'Trap 2[4-8]' HANDOFF.md
sed -n '34,59p' CLAUDE.md | grep -c '^\* \*\*'
grep -n 'memory of the docs' tools/checkdocs.py | cut -d: -f1
grep -c '^@check(' tools/checkdocs.py; grep -c '^@table(' tools/checkdocs.py
```

Every headline number the mapping agents filed matched this run. The one
citation that did not resolve (`MFI-52`) was re-derived to `MJC-52` in the
same session — `docs/rulings.md` R12, `docs/gotchas.md` G2.

## Verifier records

(appended below by the orchestrator, verbatim from each verifier's report)

### Verifier — `bbh.md` (fresh agent, 2026-09-09; producer: the bbh mapping agent)

Summary line, verbatim: `bbh census: 79 A rows MATCH, 0 MISMATCH, 0 CANNOT-RUN; generators 7/7 reproduce; spot-check 15/15 OK`

HEAD `f675710` confirmed; the 4 dirty files and the diffstat `4 files changed, 6 insertions(+), 6 deletions(-)` confirmed.

§A: every one of the 79 rows re-run verbatim from the repo root, all MATCH (A1 190, A2 19, A3 4, A4 83, A5 33, A6 32, A7 13, A8 9, A9 8, A10 5, A11 3, A12 4, A13 8, A14 23, A15 9, A16 13, A17 3, A18 4, A19 26, A20–A24 87/87/9/87/87, A25 17, A26 6, A27 33, A28 9, A29 5, A30 5, A31 7, A32 3, A33 9, A34 9, A35 4, A36 8, A37 6, A38 4, A39 16, A40 16, A41 32, A42 23, A43 24, A44 54, A45 121, A46 17, A47 116, A48 16, A49 93, A50 13, A51 8, A52 1, A53 1, A54 12, A55 9, A56 1, A57 11, A58 8, A59 12, A60 6, A61 5, A62 11, A63 10, A64 2, A65 1, A66 17, A67 3, A68 4, A69 1, A70 5, A71 12, A72 7, A73 7, A74 18, A75 43, A76 65, A77 0, A78 20, A79 40).

§C: the seven generators were `exec`'d from the census text and every emitted row diffed positionally against §B — G1 87/87, G2 32/32, G3 16/16, G4 12/12, G5 8/8, G6 19/19, G7 12/12 byte-identical (186/186).

§B `read` rows: 15 sampled with `random.seed(20260909)` from the 94 hand-read rows (B-C1, C2, C9, C12, C16, C21, G6, P3, P15, X18, X21, X30, X36, X47, X51) — 15/15 paths and lines exist and support the item text; 5 cite `:1` where line 1 is a shebang and the substantiating text is on line 2.

Findings the census does not state (recorded, not corrected — the census file is the producer's measurement):
1. §A commands and §B line numbers measure the **working tree**, not HEAD `f675710`, although the header says "at this HEAD". The verifier diffed the 4 dirty files with `--unified=0`: all 6 changes are in-place value substitutions with no line inserted or deleted, so no count and no line number differs between the tree and the commit. True today; a future dirty edit could break it — the recount gate (R9) must run against a named commit or record the porcelain state beside every count.
2. §D says "Nothing was executed"; A47/A48 import `lib/py/bbh/config.py` under python3 and the generators shell out. The claim is about harness entry points (no `bbh` sub-command, no gate, no fidelity row was run) and should say so.
3. B-C14 cites `docs/hygiene.md:25` (the `[BBH-53]` anchor) for a sentence that is `[BBH-52]` at `docs/hygiene.md:14`, already cited by B-R52.
4. A77 is a grep with no match: it prints `0` and exits 1; the census records the count without the exit status.

### Verifier — `sms.md` (fresh agent, 2026-09-09; producer: the SMS mapping agent)

Summary line, verbatim: `SMS census: 94 A rows MATCH, 0 MISMATCH, 0 CANNOT-RUN; generators 2/3 reproduce; spot-check 11/15 OK`

HEAD `ecc5481` confirmed. §A: all 94 rows re-run verbatim, all MATCH, including the `filed:` rows checked at their cited HANDOFF lines (A42 31 @ :338, A43 207 @ :224, A44 228 @ :125, A45 248 @ :59, A51 190/325 @ :153, A52 105/254 @ :242, A53 135 @ :165) and the tool self-reports (A29 `ALL PASS (66 rules across 2 pairs…)`, A81 `tools/README.md in sync (500 scripts, 11 groups)`, A83 15 knobs, A84 13 checks, A85 12 cliguard cases).

§C: G1 (66 rules) 66/66 byte-identical; G3 (18 negative-control files) 18/18; **G2 (traps 1–23) does not reproduce verbatim**: the script emits ids `S-I11…S-I33` (offset `k + 10`) while the census lists `S-I12…S-I34` — every other field (title, `HANDOFF.md` line) identical on all 23. The correct offset is `k + 11`; as written the script collides with the hand-read row S-I11.

§B `read` rows: 15 sampled from 121 — 11/15 OK. MISMATCHES (all line-number citations, none a wrong claim): S-I48 cites `tools/health.sh:92-97`, the story is at `:119-121`; S-I4 cites `docs/project/NEXT_SESSION.md:343`, the row is at `:342`; S-X9 cites `docs/project/README.md:24-26`, the sentence is at `:22-23` and the file never names `claude_code_spec`; S-I43 cites `HANDOFF.md:187-190`, the quoted sentence is at `:177-181`.

Also found: the NEXT_SESSION citations in S-I2…S-I6 are systematically +1 (rows are at `:340-344`, cited `:341-345`); A45's command pattern demands two spaces and matches nothing (the filed line 59 is right); census line 338 cross-references "(A87–A89)" for rows that are A92–A94; §D says "five ROM-free tools were executed" and lists six. Bonus re-derivations by the verifier (every K-row line count; the commit-subject prefix counts; the 30 `.mss`; the 37 `build/` files) all reproduce.

Disposition: the mismatches were sent back to the producer for correction in `sms.md` (the corrected lines are listed in the producer's reply, recorded below); the counts stand.

Producer's correction of `sms.md` (2026-09-09, after the verifier): G2 offset `k + 10` → `k + 11` (re-run 23/23 identical, diff empty); A45 pattern fixed (prints `59:`); S-I2…S-I6 NEXT_SESSION citations 341-345 → 340-344; S-I43 `HANDOFF.md:187-190` → `:177-181`; S-I48 `tools/health.sh:92-97` → `:119-121`; S-X9 reworded to what `docs/project/README.md:22-23` says; S-X10 cross-reference → A92–A94; §D "five" → "six" tools executed. File 433 lines; A 94 and B 228 unchanged; source repository still clean at `ecc5481`.

### Verifier — `vampiresaved.md` (fresh agent, 2026-09-09; producer: the VampireSaved mapping agent)

Summary line, verbatim: `VS census: 121 A rows MATCH, 1 MISMATCH, 0 CANNOT-RUN; generators 1/1 reproduce; rule-ID set diff 0; spot-check 14/15 OK`

HEAD `5df1d8be` confirmed; line 2 (7497 tracked, 1502 commits, 1 ` M` + 370 `??`) confirmed. §A: 121 of 122 rows MATCH on re-run, including the three stale-counter rows checked on both halves (A71 doc 319 vs measured 410; A72 doc 553 at `harness_scope.md:313,608` vs 555; A73 doc 1,891 at 4 sites vs 2311) and the must-fire spelling census (A34: `must-fire` 91, `MUST-FIRE` 65, `must fire` 13, `must_fire` 11, `Must-fire` 5, `must FIRE` 4, `MUST fire` 4, `must- fire` 1). **A70 MISMATCH**: the row claims "all 0" for a `cost:` marker grep, but its command returns 2 hits in `docs/project/gotchas.md` (`:1935 **What it cost:**`, `:2698 Measured cost:`), prose rather than markers — the claim does not survive its own command.

§C: G1 (the 555 rules) — stdout diffed against all 555 `gen:G1` rows: empty diff; rule-ID set symmetric difference 0.

§B `read` rows: 15 sampled from 182 — 14/15 OK. MISMATCH: V-R556 cites `vampire-saved-port/SKILL.md:7`, a blank line (header at :6). Noted: V-P10 quotes `CLAUDE.md:53` with emphasis the source lacks.

Also found: `AW` (A19) is not a rule prefix but a regex false positive on Verilog `addr[AW-1]`; `[RH-9]` at `tests/test_skill_guides.sh:16` is a live cross-repository reference to the external `romhacking-methodology` skill, unmentioned; A21 (319) vs A22 (311) was unexplained.

Orchestrator re-measurement of the A21/A22 gap (2026-09-09): `git ls-files 'tests/*.sh'` recurses (git pathspec glob) and matches 8 scripts under `tests/lib/` (`classify decrypt_cache enumerate_expectations m2a_common masked_compare pairing shadow_tools tenant_build`); top-level only → **311**; tracked-but-absent → 0. So VampireSaved has **311 gate scripts**, tracked = in tree = index rows, and "319" is gates plus sourced libraries. This session's own STATE, gotchas G3 and ruling R12 had carried "319 gate scripts" from the filed map and are corrected in the same commit.

Disposition: A70, A19, A21, V-R556, V-P10 sent back to the producer; its correction line is recorded below.

Producer's correction of `vampiresaved.md` (2026-09-09, after the verifier): A70 → "2, and NEITHER is a marker" (`docs/project/gotchas.md:1935` `**What it cost:**`, `:2698` `Measured cost:`; the price key remains `paid:`); A19 gloss split into 8 real prefixes + 4 checker fixtures (XX 22 / YY 6 / ZZ 2 / QQ 1) + 1 regex false positive + 1 live cross-repo reference, with new rows A123 (`[AW-N]` = 7 occurrences in 3 files, Verilog `addr[AW-1]`), A124 (`RH-N` in 43 files / 72 occurrences / 24 distinct IDs), A125 (18 distinct RH IDs outside the history archives), A126 (bracketed `[RH-N]` = 1, `tests/test_skill_guides.sh:16`; the 4 SKILL.md headers carry the placeholder `[RH-NN]`); A21 re-labelled "tracked `tests/**/*.sh`, the glob recurses, NOT the gate count" with the 8 `tests/lib/` scripts named, and new A127 "gate scripts, top level only" = **311**; V-T1 "74 of 319" → "74 of 311"; V-R556 and V-R557 header citations `:7` → `:6` (all 8 SKILL.md H1 lines are at :6); V-P10 quoted verbatim without added emphasis, source `CLAUDE.md:52-53`; three new rows V-X29–V-X31 for the live `[RH-N]` cross-repository reference (cited 72× in 43 files, defined nowhere in the tree, unchecked by design per `docs/project/skills_scope.md:119`). File 965 lines; §A 127 rows; §B **740** rows (R 563, C 34, X 31, P 25, K 18, G 18, I 15, T 13, F 12, D 11). VampireSaved unchanged.

Note for the bins: the VampireSaved binner was started from the 737-row census; it re-derived the count at the end of its run, found 740, and binned V-X29–V-X31 itself (the 563 rule rows diffed byte-identical across the change).

### The recount — the third party (slice S1, 2026-09-09)

The verifiers re-ran the producers' commands in the same interactive shell
the producers used, so a count that depended on that shell's `grep` (ugrep)
was reproduced three times and was wrong for any other host (gotcha G9). The
recount gate runs under `sh` in a hermetic environment and disagreed on six
SMS rows; the rows were rewritten to `git grep` and every count reproduced.
Lesson recorded in the protocol: a verifier that shares the producer's
instrument verifies the instrument's consistency, not the count (BBX-15); the
recount under a pinned environment is the lineage-independent check, and a
verifier must from now on run the commands through `bin/bbx recount <census>
--only <ids>`, never through its own shell.

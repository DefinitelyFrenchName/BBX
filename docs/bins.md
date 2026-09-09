# The four bins — every census item, sorted

Shape: index and totals. The rows are in three files, one per lineage
repository, ids identical to the census rows they bin (`docs/census/*.md`):
`docs/bins/bbh.md`, `docs/bins/vampiresaved.md`, `docs/bins/sms.md`. Bins per
CLAUDE.md §5; the burden is on `drop`, and a `drop` row without a reason is
an error whose count is printed below. Measured 2026-09-09 by the commands
shown; every row was decided individually (DECISIONS.md M1), by a different
agent than the one that wrote the census row.

## Totals

| bin | bbh | VampireSaved | SMS | all |
|---|---|---|---|---|
| keep | 140 | 190 | 72 | **402** |
| generalize | 103 | 192 | 44 | **339** |
| consumer | 37 | 358 | 111 | **506** |
| drop | 0 | 0 | 1 | **1** |
| total | 280 | 740 | 228 | **1248** |

```sh
cat docs/bins/*.md | grep -E '^\| [BVS]-' | awk -F'|' '{gsub(/ /,"",$4); print $4}' | sort | uniq -c
#  506 consumer  /  1 drop  /  339 generalize  /  402 keep
cat docs/bins/*.md | grep -cE '^\| [BVS]-'                                            # 1248
for f in bbh:B vampiresaved:V sms:S; do p=${f##*:}; f=${f%%:*}; \
  diff <(grep -oE "^\| $p-[A-Z][0-9]+ " docs/census/$f.md | sort) \
       <(grep -oE "^\| $p-[A-Z][0-9]+ " docs/bins/$f.md | sort) && echo "$f ids identical"; done
cat docs/bins/*.md | grep -E '^\| [BVS]-[^|]*\|[^|]*\| drop \| *\|' | wc -l             # 0 — drop rows with no reason
cat docs/bins/*.md | grep -E '^\| [BVS]-' | awk -F'|' '{gsub(/ /,"",$4); print $4}' \
  | grep -vcE '^(keep|generalize|consumer|drop)$'                                      # 0 — bin words outside the four
```

Output of the last three checks, verbatim: `0`, `0`, and `bbh ids identical / vampiresaved ids identical / sms ids identical`.

## VampireSaved rules by prefix (563 rule rows; the 8 blank-prefix rows are the per-skill summaries)

```
 CPE 42 consumer                 (the redirect table: content binned at its MFI row)
 CPH 22 consumer  7 generalize  1 keep
 MFI 25 consumer 15 generalize  6 keep
 MJC 31 consumer 21 generalize 11 keep
 MSC 70 consumer  3 generalize
 MSV 26 consumer  5 generalize  5 keep
 VSE 67 consumer 15 generalize  3 keep
 VSP 62 consumer 57 generalize 61 keep
```
Command: `grep -E '^\| V-R' docs/bins/vampiresaved.md | awk -F'|' '{match($3,/\[[A-Z]+-/); p=substr($3,RSTART+1,RLENGTH-2); gsub(/ /,"",$4); print p, $4}' | sort | uniq -c`

## The one drop

`S-X2` — the histogram of commit-subject prefixes in SMS at one commit (docs 64,
p16 33, exp 25, tools 11): a snapshot of one repository's habits at one
moment, stale at the next commit, with nothing depending on it; the point it
made (documentation dominates the commit stream) is carried by census rows
A19/A20. Reason recorded in `docs/bins/sms.md`.

## Where the binners disagreed with the plan, and what was done

- **The fake machine.** CLAUDE.md §5 bins it `generalize` (a fixture subject per
  subject kind); the first draft of `docs/abstraction.md` §9 said "keep as the
  lineage fixture". The constitution rules: `docs/abstraction.md` §9 was
  aligned to `generalize` in this session, bbh's own fake machine staying in
  bbh as the frame-driven kind's fixture.
- **The thresholds 2 / 60 / 8.** `docs/abstraction.md` §9 maps them "keep,
  provenance-classed"; the VampireSaved binner binned the *values* `generalize`
  (into a kind profile's ratified thresholds — they are calibrated on CPS-2
  frame timing, the biased default of BBX-24) and the *rule* that changing one
  is a ruling `keep`. That split is the more precise reading and is adopted:
  the abstraction's C1 already says thresholds live in the kind profile.
- **bbh's "documentation tools are OUT" ruling** (`docs/conventions.md`) is
  binned `consumer`: it stays true as bbh's scope ruling, and BBX reverses it
  by design (ruling R2, a document set is a subject kind).
- **A truncated census row nearly produced a wrong bin**: MJC-47's payload
  ("name the implausible value BEFORE the run") lies past the 140-character
  cut; the binner read the SKILL.md line and binned `keep`. Recorded here so
  the recount gate (R9) can carry full rule text for rows whose bin depends on
  the tail.

## What the bins do NOT decide

Which `generalize` rows land in which slice (`docs/slices.md`); whether the
`consumer` rows of VampireSaved are ever read again by BBX (they are not, except
through fidelity F20); the fate of the 92 CPE→MFI redirect rows, binned
`consumer` as bookkeeping whose content is binned at the MFI row.

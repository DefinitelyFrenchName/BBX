# DECISIONS — rulings in force

Shape: living page; states what is ruled now. Its history twin is
`DECISIONS_HISTORY.md` (how each ruling came to be; append-only). The open
queue with recommendations is `docs/rulings.md`.

| id | ruling | ruled by | date |
|---|---|---|---|
| R6 | The BBX repository root is `BBX/` (the directory holding `CLAUDE.md`). | maintainer | 2026-09-09 |
| R7 | Session 1 ends in one commit (memory files, census, plan, rulings); no remote, no push. | maintainer | 2026-09-09 |
| R8 | The bbh fidelity baseline is HEAD `f675710`; its 4 uncommitted modifications are a recorded finding and are never touched by BBX. | maintainer | 2026-09-09 |
| M1 | Every rule in the lineage is binned individually in `docs/bins.md` — all 87 BBH, all 555 VampireSaved, all 66 SMS — no prefix-level binning; a `drop` row with no reason counts as an error. | contributor (method) | 2026-09-09 |
| M2 | A census row's provenance is `gen:<generator>` when a script emitted it and `read` when a person or agent read it; every count has its command; a filed count is labelled `filed:` with its source. | contributor (method) | 2026-09-09 |
| M3 | Every load-bearing census number is produced by one agent and re-derived by a different one; unresolved mismatches are reported, never averaged. | contributor (method), from FIRST_PROMPT.md | 2026-09-09 |

Everything else is open: `docs/rulings.md`.

#!/usr/bin/env python3
"""G80 per-gate attribution (bbx-28). Read-only.

Reads a kept run's results.tsv BY COLUMN NAME (gate, seconds) in row order,
assumes the gates ran sequentially from run.txt's `started=` (checked: the
summed seconds against the wall clock are printed), and assigns every top-level
tmp.* directory whose ONLY child is `fake_replay.log` and whose birth time lies
in the run to the gate whose cumulative window holds it.

Usage: tmp_per_gate.py <kept-run-dir> <tmpdir> <run-end-epoch>
Controls printed: the assigned total must equal the in-window total; the
'unassigned' count is printed, never dropped.
"""
import calendar
import collections
import csv
import os
import sys
import time

run, tmpdir, end = sys.argv[1], sys.argv[2], float(sys.argv[3])
fields = dict(l.rstrip("\n").split("=", 1) for l in open(os.path.join(run, "run.txt")) if "=" in l)
t0 = calendar.timegm(time.strptime(fields["started"], "%Y-%m-%dT%H:%M:%SZ"))
rows = list(csv.DictReader(open(os.path.join(run, "results.tsv")), delimiter="\t"))
windows, cum = [], 0.0
for r in rows:
    s = float(r["seconds"])
    windows.append((r["gate"], r["tier"], t0 + cum, t0 + cum + s))
    cum += s
print("started=%s summed_seconds=%.0f wall_seconds=%.0f" % (fields["started"], cum, end - t0))

births = []
for e in os.scandir(tmpdir):
    if not e.name.startswith("tmp.") or not e.is_dir(follow_symlinks=False):
        continue
    b = e.stat(follow_symlinks=False).st_birthtime
    if t0 <= b <= end:
        try:
            if os.listdir(e.path) == ["fake_replay.log"]:
                births.append(b)
        except OSError:
            pass
counts = collections.Counter()
unassigned = 0
for b in births:
    hit = None
    for g, tier, a, z in windows:
        if a <= b <= z + 1.0:  # 1 s slack for the runner's own overhead between gates
            hit = g
            break
    if hit:
        counts[hit] += 1
    else:
        unassigned += 1
print("in_window=%d assigned=%d unassigned=%d" % (len(births), sum(counts.values()), unassigned))
for g, tier, a, z in windows:
    if counts[g]:
        print("  %-18s %-8s %4d dirs over %4.0f s" % (g, tier, counts[g], z - a))

#!/usr/bin/env python3
"""G80 backlog by birth day (bbx-28). Read-only over $TMPDIR.

For the three largest content signatures (only fake_replay.log; empty; cfg+nvram)
and everything else, counts top-level tmp.* entries per local birth date.
Control: the per-day counts summed must equal the total printed first.
"""
import collections
import datetime
import os
import sys

root = sys.argv[1]
sig_names = {("fake_replay.log",): "fake_replay", (): "empty", ("cfg", "nvram"): "cfg+nvram"}
table = collections.defaultdict(collections.Counter)
total = 0
for e in os.scandir(root):
    if not e.name.startswith("tmp."):
        continue
    total += 1
    day = datetime.date.fromtimestamp(e.stat(follow_symlinks=False).st_birthtime).isoformat()
    if e.is_dir(follow_symlinks=False):
        try:
            kids = tuple(sorted(os.listdir(e.path)))
        except OSError:
            kids = ("<unreadable>",)
    else:
        kids = ("<file>",)
    table[day][sig_names.get(kids, "other")] += 1
cols = ["fake_replay", "empty", "cfg+nvram", "other"]
print("total=%d" % total)
print("%-10s %11s %7s %9s %6s" % tuple(["day"] + cols))
s = 0
for day in sorted(table):
    row = [table[day][c] for c in cols]
    s += sum(row)
    print("%-10s %11d %7d %9d %6d" % tuple([day] + row))
print("summed=%d" % s)

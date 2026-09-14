#!/usr/bin/env python3
"""G80 (bbx-28): for empty tmp.* directories, did the contents go later, or were
they born empty? A directory's mtime moves when an entry inside it is removed.

Usage: tmp_mtime.py <tmpdir>
Control: the same measure over directories whose only child is fake_replay.log,
whose contents were never removed (expect every lag under 60 s).
"""
import collections
import datetime
import os
import sys

root = sys.argv[1]
agg = collections.defaultdict(collections.Counter)
for e in os.scandir(root):
    if not e.name.startswith("tmp.") or not e.is_dir(follow_symlinks=False):
        continue
    try:
        kids = os.listdir(e.path)
    except OSError:
        continue
    kind = "empty" if not kids else ("fake_replay" if kids == ["fake_replay.log"] else None)
    if kind is None:
        continue
    st = e.stat(follow_symlinks=False)
    bday = datetime.date.fromtimestamp(st.st_birthtime).isoformat()
    lag = st.st_mtime - st.st_birthtime
    bucket = "lag<60s" if lag < 60 else ("lag<1d" if lag < 86400 else "lag>=1d")
    agg[(kind, bday)][bucket] += 1
    agg[(kind, bday)]["mtime " + datetime.datetime.fromtimestamp(st.st_mtime).strftime("%Y-%m-%d %H")] += 1
for kind, bday in sorted(agg):
    c = agg[(kind, bday)]
    lags = " ".join("%s=%d" % (k, c[k]) for k in ("lag<60s", "lag<1d", "lag>=1d") if c[k])
    top = sorted(((v, k) for k, v in c.items() if k.startswith("mtime ")), reverse=True)[:3]
    n = sum(c[k] for k in ("lag<60s", "lag<1d", "lag>=1d"))
    print("%-12s born %s  n=%-6d %s | top mtime hours: %s" % (kind, bday, n, lags, ", ".join("%s (%d)" % (k[6:], v) for v, k in top)))

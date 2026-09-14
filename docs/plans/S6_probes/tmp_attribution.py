#!/usr/bin/env python3
"""G80 attribution probe (bbx-28, S6 census). Read-only over $TMPDIR.

Buckets every top-level tmp.* entry by BIRTH time (st_birthtime, macOS) into
before / inside / after a window, and groups the entries born inside the window
by a content signature (the sorted names of their first-level children).

Usage: tmp_attribution.py <tmpdir> <window-start-epoch> <window-end-epoch>
Positive control: the total printed must equal a plain count of tmp.* entries.
"""
import collections
import os
import sys

root, start, end = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
total = before = inside = after = 0
empty_inside = 0
files_inside = 0
sigs = collections.Counter()
examples = {}
for e in os.scandir(root):
    if not e.name.startswith("tmp."):
        continue
    total += 1
    st = e.stat(follow_symlinks=False)
    b = st.st_birthtime
    if b < start:
        before += 1
        continue
    if b > end:
        after += 1
        continue
    inside += 1
    if not e.is_dir(follow_symlinks=False):
        files_inside += 1
        sigs["<file>"] += 1
        examples.setdefault("<file>", e.name)
        continue
    try:
        kids = sorted(os.listdir(e.path))
    except OSError as err:
        kids = ["<unreadable:%s>" % err.errno]
    if not kids:
        empty_inside += 1
    sig = " ".join(kids[:8]) + (" …+%d" % (len(kids) - 8) if len(kids) > 8 else "")
    sigs[sig or "<empty>"] += 1
    examples.setdefault(sig or "<empty>", e.name)

print("total=%d before=%d inside=%d after=%d" % (total, before, inside, after))
print("inside: dirs_empty=%d files=%d signatures=%d" % (empty_inside, files_inside, len(sigs)))
for sig, n in sigs.most_common(25):
    print("%6d  %-70s  e.g. %s" % (n, sig[:70], examples[sig]))

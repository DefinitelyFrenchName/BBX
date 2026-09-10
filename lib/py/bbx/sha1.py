"""sha1.py — `shasum`'s first two columns, portably: `<hex>  <path>` per file. The kind-blind
[suite].hash_cmd (docs/defaults.md D27); the frame-driven profile keeps bbh's `shasum`."""
import hashlib
import sys

for p in sys.argv[1:]:
    h = hashlib.sha1()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    print(f"{h.hexdigest()}  {p}")

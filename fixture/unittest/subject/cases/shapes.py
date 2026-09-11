"""shapes.py — the module under test, written by mkunittest.py from the design. Deterministic and
ASYMMETRIC by construction (BBX-15): the turn is a quarter, never a mirror, and the span is ordered."""
TURN = {"n": "e", "e": "s", "s": "w", "w": "n"}


def tilt(course):
    """One quarter turn per step: tilt(tilt(x)) is never x, so a mirrored implementation cannot pass."""
    return "".join(TURN[c] for c in course)


def span(a, b):
    """b - a: ordered, so swapping the arguments changes the sign rather than nothing."""
    return b - a

"""test_verdicts.py — 4 cases covering the rest of the closed verdict vocabulary (D58), written by
mkunittest.py from the design: xfail, ERROR, xpass, skip. Every one of them is deliberate."""
import unittest

from shapes import span


class V(unittest.TestCase):
    @unittest.expectedFailure
    def test_e_expected_red(self):
        self.assertEqual(span(1, 2), 99)          # fails, and is expected to: `xfail`

    def test_f_error_raises(self):
        span("a", 1)                              # TypeError, never an assertion: `ERROR`

    @unittest.expectedFailure
    def test_g_unexpected_green(self):
        self.assertEqual(span(1, 2), 1)           # passes although expected to fail: `xpass`

    @unittest.skip("the designed skip")
    def test_h_skipped(self):
        self.fail("never reached")                # `skip` — and SKIP IS NOT PASS (BBX-1)

"""test_shapes.py — 4 cases over shapes.py, written by mkunittest.py from the design.
ONE OF THEM FAILS BY DESIGN (test_b_designed_red): the adapter's business is to REPORT what the framework
said, so a red case is an OBSERVATION the frozen truth expects, never a defect of this fixture (R37)."""
import unittest

from shapes import span, tilt


class T(unittest.TestCase):
    def test_a_tilt_turns_once(self):
        self.assertEqual(tilt("nesw"), "eswn")

    def test_b_designed_red(self):
        # FAILS BY DESIGN: a quarter turn of "n" is "e". The truth log carries `case:FAIL:<sha1>` here.
        self.assertEqual(tilt("n"), "n")

    def test_c_tilt_is_no_mirror(self):
        self.assertNotEqual(tilt("ne"), "en")

    def test_d_span_is_ordered(self):
        self.assertEqual(span(3, 11), 8)
        self.assertEqual(span(11, 3), -8)

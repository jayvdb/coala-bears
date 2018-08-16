import os
import shutil
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

from generate_bear_requirements import main


class RunTest(unittest.TestCase):

    def test_run(self):
        rv = main(['--update', '--check'])
        self.assertEqual(rv, 0)

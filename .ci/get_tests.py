import glob
import os
import sys
import types

import yaml

THIS_DIR = os.path.dirname(os.path.abspath(__file__))

PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

def get_metadata():
    with open('bear-metadata.yaml') as f:
        metadata = yaml.load(f, Loader=yaml.BaseLoader)

    return metadata

def jque_contains(x, y):
    return y in x


def _check_record(qr, record):
    include = True
    for key, qual in qr.items():
        if isinstance(qual, dict):
            for op, val in qual.items():
                if isinstance(op, types.FunctionType):
                    if not op(record[key], val):
                        return False
                elif op not in jque_orig._OPERATORS:
                    raise ValueError(
                        "'{}' is not a valid operator.".format(op)
                    )
                elif not jque_orig._OPERATORS[op](record[key], val):
                    return False
        elif isinstance(qual, types.FunctionType):
            if not qual(record[key]):
                return False
        else:
            if record[key] != qual:
                return False
    return include

import jque as jque_orig
jque_orig._check_record = _check_record

from jque import jque


def get_bears(metadata, args):
    bears = []
    metadata = [item for item in metadata.values()]
    obj = jque(metadata)
    for arg in args:
        matches = obj.query({'tags': {jque_contains: arg}})
        for bear in matches:
            bears.append(bear)

    return bears


def get_tests(bears):
    # Add 1 for the path separator after bears
    project_dir_prefix_len = len(PROJECT_DIR) + 1

    tests = []
    for bear in bears:
        name = bear['name']
        if name.startswith('_'):
            continue
        subdir = bear['subdir']
        # A few test modules are FoobearSomethingTest.py, like
        # PySafetyBearWithoutMockTest.py
        testpath = os.path.join('tests', subdir, '{}*Test.py'.format(name))
        files = glob.glob(testpath)
        for filename in files:
            relative = filename[project_dir_prefix_len:]

            tests.append(filename)

    return tests

def main():
    args = sys.argv[1:]
    metadata = get_metadata()

    # TODO: pass through any args which are literal test filenames

    bears = get_bears(metadata, args)
    tests = get_tests(bears)
    print(' '.join(tests))


if __name__ == '__main__':
    main()

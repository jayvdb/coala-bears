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


def get_bears(metadata, args):
    bears = []
    for arg in args:
        matches = []
        for bear in metadata.values():
            if arg in bear['tags']:
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
    print(' '.join(sorted(tests)))


if __name__ == '__main__':
    main()

import glob
import os
import os.path
import sys
import types

import yaml

THIS_DIR = os.path.dirname(os.path.abspath(__file__))

PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

IS_WIN = os.name == 'nt'

# This could be moved to appveyor.yml, but can it be less ugly there?
WINDOWS_BROKEN = set((
    # perl
    'bakalint',  # not installed
    'tailor',  # installer fails
    # pip
    'apertium_lint',  # not installed
    'bandit',
    'clang',  # lots of errors, and hangs
    'cppclean',  # cppclean is not installed
    'scspell',  # doesnt work on Windows
    'vint',
    # gem
    #'csvlint',
    'sqlint',  # libpg_query doesnt build
    # npm ; try different version
    #'alex',
    #'coffeelint',
    #'csscomb',
    #'dockerfile_lint',
    #'elm',
    #'eslint',
    #'gherkin',
    #'jshint',
    #'remark',
    #'postcss',
    #'sass-lint',
    #'textlint',
    #'tslint',
))


DISABLE_BEARS = set(os.environ.get('DISABLE_BEARS', '').split(' '))


def get_metadata():
    with open('bear-metadata.yaml') as f:
        metadata = yaml.load(f, Loader=yaml.BaseLoader)

    return metadata


def get_bears(metadata, args, include_disabled=False):
    bears = []

    for arg in args:
        matches = []
        for bear in metadata.values():
            tags = set(bear['tags'])

            if tags.intersection(DISABLE_BEARS):
                tags.add('disabled')

            if IS_WIN and tags.intersection(WINDOWS_BROKEN):
                tags.add('disabled')

            if arg in tags and (include_disabled or 'disabled' not in tags):
                bears.append(bear)

    return bears


def get_tests(bears):
    # Add 1 for the path separator after bears
    project_dir_prefix_len = len(PROJECT_DIR) + 1

    tests = set()
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
            filename = filename.replace(os.path.sep, '/')
            if filename.startswith('/'):
                 filename = filename[project_dir_prefix_len:]
            tests.add(filename)

        if subdir == 'c_languages/codeclone_detection':
            tests.update([
                'tests/c_languages/codeclone_detection/ClangCountingConditionsTest.py',
                'tests/c_languages/codeclone_detection/ClangCountVectorCreatorTest.py',
                'tests/c_languages/codeclone_detection/CountVectorTest.py',
                'tests/c_languages/codeclone_detection/CloneDetectionRoutinesTest.py',
            ])

        elif subdir.startswith('vcs'):
            tests.add('tests/vcs/CommitBearTest.py')

    return tests


def main():
    args = sys.argv[1:]
    metadata = get_metadata()

    include_disabled = False
    if args[0] == '--disabled':
        include_disabled = True
        args = args[1:]

    # TODO: pass through any args which are literal test filenames

    bears = get_bears(metadata, args, include_disabled)
    tests = get_tests(bears)
    print(' '.join(sorted(tests)))


if __name__ == '__main__':
    main()

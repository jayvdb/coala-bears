#!/usr/bin/env python
import json
import os
import sys

IS_WIN = os.name == 'nt'


def main():
    args = sys.argv[1:]
    thresholds = {}
    for test in args:
        bear = test.replace('tests/', 'bears/')
        bear = bear.replace('Test.py', '.py').replace('*', '.*')

        if IS_WIN:
            bear = bear.replace('/', '\\\\')

        thresholds[bear] = 100

    with open('.threshold.json', 'w') as f:
        json.dump(thresholds, f)


if __name__ == '__main__':
    main()

#!/usr/bin/env python
import json
import sys


def main():
    args = sys.argv[1:]
    thresholds = {}
    for test in args:
        bear = test.replace('tests/', 'bears/')
        bear = bear.replace('Test.py', '.py').replace('*', '.*')
        thresholds[bear] = 100

    with open('.threshold.json', 'w') as f:
        json.dump(thresholds, f)


if __name__ == '__main__':
    main()
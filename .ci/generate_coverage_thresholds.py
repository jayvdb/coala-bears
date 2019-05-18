#!/usr/bin/env python
import json
import sys

def main():
    args = sys.argv
    thresholds = {}
    for test in args:
        bear = test.replace('tests/', 'bears/').replace('Test.py', '.py')
        thresholds[bear] = 100

    with open('.threshold.json', 'w') as f:
        json.dump(thresholds, f)


if __name__ == '__main__':
    main()

#!/usr/bin/env python3

import json
import os
import sys

IS_WIN = os.name == 'nt'


def main():
    args = sys.argv[1:]
    thresholds = {}
    if args == ['none']:
        if os.path.exists(".threshold.json"):
            os.remove(".threshold.json")
            return

    for test in args:
        bear = test.replace('tests/', 'bears/')
        bear = bear.replace('Test.py', '.py').replace('*', '.*')

        threshold = 100
        if IS_WIN:
            bear = bear.replace('/', '\\\\')
            if 'CheckstyleBear' in bear or 'CMakeLintBear' in bear:
                threshold = 90
            elif 'CPDBear' in bear:
                threshold = 98
        elif sys.version_info[:3] >= (3, 7, 0):
            for name in ['HTTPSBear', 'InvalidLinkBear', 'MementoBear']:
                if name in bear:
                    threshold = 95
                    break

        thresholds[bear] = threshold

    with open('.threshold.json', 'w') as f:
        json.dump(thresholds, f)


if __name__ == '__main__':
    main()

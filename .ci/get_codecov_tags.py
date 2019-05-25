#!/usr/bin/env python
import sys

REJECT_TAGS = set(['codecov', 'skip', 'noskip', 'list'])

env_factors = set(sys.argv[1].split('-'))

print(','.join(env_factors - REJECT_TAGS))

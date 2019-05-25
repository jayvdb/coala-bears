#!/bin/sh

set -e
set -x

.ci/deps.pmd.sh
.ci/deps.tailor.sh

#bash -e -x .ci/deps.coala-bears.sh

#!/bin/bash

set -e
set -x

if [ -n "$TRAVIS_JDK_VERSION" ]; then
  jdk_version=${TRAVIS_JDK_VERSION#openjdk}
  jdk_version=${jdk_version#oraclejdk}
fi

if [ -z "$jdk_version" ] || [ $jdk_version -eq 8 ]; then
  .ci/deps.tailor.sh
fi

which pmd || true
which cpd || true
which run.sh || true

if [ -z "$(which run.sh || true)" ]; then
  .ci/deps.pmd.sh
fi

which pmd || true
which cpd || true
which run.sh || true

/home/travis/.local/bin/run.sh pmd -R check_best_practices,check_braces,check_clone_implementation,check_code_size,check_imports -d ./tests/java/test_files/good_file.java -f text

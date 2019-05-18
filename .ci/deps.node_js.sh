#!/bin/bash

set -e -x

# NPM commands
source .ci/deps.alex.sh

if [ -z "$TRAVIS_LANGUAGE" ]; then
  npm install
  npm list --depth=0
fi

source .ci/deps.elm.sh

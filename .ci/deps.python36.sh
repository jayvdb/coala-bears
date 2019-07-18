#!/bin/bash

set -e -x

source .ci/deps.pyenv.sh

PYTHON36_VERSION=$(pyenv versions --bare | fgrep '3.6' --max-count 1 || true)

if [ -z "$PYTHON36_VERSION" ]; then
  PYTHON36_VERSION=3.6.3

  pyenv install "$PYTHON36_VERSION";
fi

pyenv global "$PYTHON36_VERSION"

hash -r

pyenv versions --bare

python --version

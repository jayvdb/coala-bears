#!/bin/bash

set -e -x

PYTHON36_VERSION=$(pyenv versions --bare | fgrep '3.6' --max-count 1)

if [ -z "$PYTHON36_VERSION" ]; then
  git clone https://github.com/s1341/pyenv-alias.git \
    $(pyenv root)/plugins/pyenv-alias;

  export PYTHON36_VERSION=3.6.3

  VERSION_ALIAS=3.6 pyenv install "$PYTHON36_VERSION";
fi

pyenv global "$PYTHON36_VERSION"

hash -r

pyenv versions --bare

python --version

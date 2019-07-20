#!/bin/bash

set -e -x

PYTHON27_BIN="$(which python2.7 || true)"
if [ -n "$PYTHON27_BIN" ]; then
  if [ ! -d "$PYENV_ROOT/plugins/pyenv-register" ]; then
    # https://github.com/doloopwhile/pyenv-register/pull/3
    git clone https://github.com/garyp/pyenv-register.git \
      "$PYENV_ROOT/plugins/pyenv-register"
  fi

  pyenv register -f "$PYTHON27_BIN" || true
fi

pyenv global 2.7 $(pyenv versions --bare | fgrep '3.6' --max-count 1)
hash -r

#!/bin/bash

set -e -x

if [ -z "$(which pyenv)" ]; then
  # This is only useful if sources
  export PYENV_ROOT="$HOME/.pyenv";
  export PATH="$PYENV_ROOT/bin:$PATH";
  if [ ! -d "$PYENV_ROOT" ]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv;
    if [ -d ~/local ]; then
      (cd ~/local/bin && ln -s $PYENV_ROOT/bin/pyenv .)
    fi
  fi
fi

if [ ! -d "$PYENV_ROOT/plugins/pyenv-register" ]; then
  # https://github.com/doloopwhile/pyenv-register/pull/3
  git clone https://github.com/garyp/pyenv-register.git \
    "$PYENV_ROOT/plugins/pyenv-register"

fi

ls /home/travis/.pyenv/plugins/ || true
ls /home/travis/.pyenv/plugins/pyenv-register || true

ls /opt/pyenv/plugins/ || true
ls /opt/pyenv/plugins/pyenv-register || true

#SYSTEM_PYTHONS=$(ls /usr/bin/python[3] \
#                    /usr/bin/python[3].[0-9] \
#                    /usr/bin/python[3].[0-9].[0-9] 2>/dev/null || true)
#for pybin in $SYSTEM_PYTHONS $(which python3.6); do

pyenv register -f $(which python3.6) || true

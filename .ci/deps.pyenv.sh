#!/bin/bash

set -e -x

if [ -z "$(which pyenv)" ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv;
  export PYENV_ROOT="$HOME/.pyenv";
  export PATH="$PYENV_ROOT/bin:$PATH";
fi

# https://github.com/doloopwhile/pyenv-register/pull/3
git clone https://github.com/garyp/pyenv-register.git \
  "$PYENV_ROOT/plugins/pyenv-register"

ls /home/travis/.pyenv/plugins/
ls /home/travis/.pyenv/plugins/pyenv-register

#SYSTEM_PYTHONS=$(ls /usr/bin/python[3] \
#                    /usr/bin/python[3].[0-9] \
#                    /usr/bin/python[3].[0-9].[0-9] 2>/dev/null || true)
#for pybin in $SYSTEM_PYTHONS $(which python3.6); do

pyenv register -f $(which python3.6) || true
set +x

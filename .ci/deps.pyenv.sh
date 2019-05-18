#!/bin/bash

set -e -x

if [ -z "$(which pyenv)" ]; then
  # This is only useful if sources
  export PYENV_ROOT="$HOME/.pyenv";
  export PATH="$PYENV_ROOT/bin:$PATH";
  if [ ! -f "$PYENV_ROOT/bin/pyenv" ]; then
    if [ -d "$PYENV_ROOT" ]; then
      rm -rf "$PYENV_ROOT"
    fi
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT;
    if [ -d ~/local/bin ]; then
      rm ~/local/bin/pyenv
      (cd ~/local/bin && ln -s $PYENV_ROOT/bin/pyenv .)
    fi
  fi
fi

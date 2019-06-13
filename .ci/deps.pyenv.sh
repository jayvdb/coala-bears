set -e -x
if [ -z "$(which pyenv)" ]; then
  if [ $TRAVIS_OS_NAME = windows ]; then
    git clone https://github.com/pyenv-win/pyenv-win.git ~/.pyenv
    export PYENV_ROOT="$HOME/.pyenv/pyenv-win"
  else
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    export PYENV_ROOT="$HOME/.pyenv"
  fi
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
fi
# https://github.com/doloopwhile/pyenv-register/pull/3
git clone https://github.com/garyp/pyenv-register.git \
  $(pyenv root)/plugins/pyenv-register

SYSTEM_PYTHONS=$(ls /usr/bin/python[23] \
                    /usr/bin/python[23].[0-9] \
                    /usr/bin/python[23].[0-9].[0-9] 2>/dev/null || true)
for pybin in $SYSTEM_PYTHONS $(which python2.7) $(which python3.6); do
  pyenv register -f $pybin || true
done
set +x

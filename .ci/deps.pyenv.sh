if [ -z "$(which pyenv)" ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv;
  export PYENV_ROOT="$HOME/.pyenv";
  export PATH="$PYENV_ROOT/bin:$PATH";
fi

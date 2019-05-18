if [ -z "$(pyenv versions | fgrep '3.6' --max-count 1)" ]; then
  git clone https://github.com/s1341/pyenv-alias.git \
    $(pyenv root)/plugins/pyenv-alias;

  VERSION_ALIAS=3.6 pyenv install 3.6.3;
fi

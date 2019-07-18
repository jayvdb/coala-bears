#!/bin/bash

set -e -x

pyenv global 2.7 $(pyenv versions --bare | fgrep '3.6' --max-count 1)
rehash -r

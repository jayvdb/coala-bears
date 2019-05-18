#!/bin/bash

set -e -x

# NPM commands
ALEX=$(which alex || true)
# Delete 'alex' if it is not in a node_modules directory,
# which means it is ghc-alex.
if [[ -n "$ALEX" && "${ALEX/node_modules/}" == "${ALEX}" ]]; then
  echo "Removing $ALEX"
  sudo rm -rf $ALEX
fi

if [ -z "$TRAVIS_LANGUAGE" ]; then
  npm install
  npm list --depth=0
fi

# elm-format Installation
if [ ! -e ~/.local/bin/elm-format ]; then
  curl -fsSL -o elm-format.tgz https://github.com/avh4/elm-format/releases/download/0.5.2-alpha/elm-format-0.17-0.5.2-alpha-linux-x64.tgz
  tar -xvzf elm-format.tgz -C ~/.local/bin/
fi

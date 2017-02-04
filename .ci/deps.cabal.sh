set -e
set -x


if [[ -n "$(which ghc-mod)" ]]; then
  rm $(which ghc-mod)
fi

# cabal update to 1.22.9.0 and install ghc-mod 5.6.0
if [[ -z "$(which ghc-mod)" ]]; then
  cabal update && cabal install cabal-install-1.22.9.0
  cabal install ghc-mod
fi

VERSION=0.4.1
BIN_PATH=~/.cabal/bin/shellcheck

function install_shellcheck {
  cabal update --verbose=0
  cabal install --verbose=0 --force-reinstalls shellcheck-$VERSION
}

function currently_installed_shellcheck_version {
  $BIN_PATH -V | grep version: | cut -d: -f2 | awk '{print $1}'
}

if [ ! -f $BIN_PATH ]; then
  install_shellcheck
else
  EXISTING_VERSION=$(currently_installed_shellcheck_version)
  if [ "$VERSION" != "$EXISTING_VERSION" ]; then
    rm -rf $BIN_PATH
    install_shellcheck
  else
    echo "Using cached ShellCheck $EXISTING_VERSION"
  fi
fi

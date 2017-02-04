set -e
set -x


if [[ -n "$(which shellcheck)" ]]; then
  rm $(which shellcheck)
fi

# cabal update to 1.22.9.0 and install ghc-mod 5.6.0
if [[ -z "$(which ghc-mod)" ]]; then
  cabal update && cabal install cabal-install-1.22.9.0
  cabal install ghc-mod-5.6.0.0
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

# Update hlint to latest version (not available in apt)
if [[ -z "$(which hlint)" ]]; then
  hlint_deb=$(ls -vr ~/.apt-cache/hlint_1.9.* 2>/dev/null | head -1)
  if [[ -z "$hlint_deb" ]]; then
    hlint_deb_filename=hlint_1.9.26-1_amd64.deb
    # This is the same build as xenial hlint
    hlint_deb_url="https://launchpad.net/ubuntu/+source/hlint/1.9.26-1/+build/8831318/+files/${hlint_deb_filename}"
    hlint_deb=~/.apt-cache/$hlint_deb_filename
    wget -O $hlint_deb $hlint_deb_url
  fi
  sudo dpkg -i $hlint_deb
fi

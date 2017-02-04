set -e

pkgs=$(ghc-pkg list --user)

function pkg_version_chk {
  versions=versions=$(echo $pkgs | xargs -n 1 | grep hashable | xargs)
  if [[ -z "$versions" ]]; then
    echo "$1: missing" 1>&2
    return 1
  fi
  if [[ "${versions/ /}" != "$versions" ]]; then
    echo "$1-$2: multiple: $versions" 1>&2
    return 1
  fi
  if [[ "${versions/$1-$2/}" != "$versions" ]]; then
    echo "$1-$2: found" 1>&2
    return 0
  else
    echo "$1-$2: found $versions" 1>&2
    return 1
  fi
}

#if [[ -n "$TRAVIS" ]]; then
#  # https://github.com/coala/coala-bears/issues/1380
#  if pkg_version_chk hlint 1.9.27 && pkg_version_chk ShellCheck 0.4.1 && pkg_version_chk ghc-mod 5.6.0.0 ; then
#    exit 0
#  fi
#
#  rm -rf $HOME/.cabal $HOME/.ghc $HOME/.ghc-mod
#fi

cabal update

# TODO use pkg_version_chk
cabal install cabal-install==1.22.9.0

rm $HOME/.cabal/config

cabal install --only-dependencies --avoid-reinstalls

# Force ghc-mod to resolve its Cabal version
~/.cabal/bin/ghc-mod modules

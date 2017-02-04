set -e
set -x

cabal update
cabal install cabal-install-1.22.9.0
cabal install --only-dependencies

$HOME/.ghc-mod/cabal-helper

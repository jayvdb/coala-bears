set -e
set -x

cabal update
cabal install --only-dependencies

$HOME/.ghc-mod/cabal-helper

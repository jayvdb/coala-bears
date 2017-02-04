set -e
set -x

cabal update
cabal install --force-reinstalls --only-dependencies

$HOME/.ghc-mod/cabal-helper

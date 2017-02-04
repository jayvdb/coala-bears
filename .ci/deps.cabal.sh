set -e
set -x

cabal update
#cabal install cabal-install==1.22.9.0
cabal install --only-dependencies --force-reinstalls

# Force ghc-mod to resolve its Cabal version
~/.cabal/bin/ghc-mod modules

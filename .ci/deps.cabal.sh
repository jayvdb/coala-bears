set -e
set -x

cabal update

cat $HOME/.cabal/config
find $HOME/.cabal

#cabal install cabal-install==1.22.9.0
cabal install --only-dependencies

# Force ghc-mod to resolve its Cabal version
~/.cabal/bin/ghc-mod modules

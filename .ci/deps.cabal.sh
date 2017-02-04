set -e
set -x

cabal update

cat $HOME/.cabal/config
find $HOME/.cabal


echo "shadow-installed-packages: False" >> $HOME/.cabal/config
echo "shared: " >> $HOME/.cabal/config

ghc-pkg list

cabal install cabal-install==1.22.9.0
cabal install --only-dependencies --avoid-reinstalls

# Force ghc-mod to resolve its Cabal version
~/.cabal/bin/ghc-mod modules

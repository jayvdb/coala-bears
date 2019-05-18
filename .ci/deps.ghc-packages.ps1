function Install-Cabal-Deps {
    cabal install --only-dependencies --avoid-reinstalls
}

function Do-Install-Packages {
    Install-Cabal-Deps
}

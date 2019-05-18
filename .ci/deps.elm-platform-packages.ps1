function Install-Elm-Format {
    elm-compiler --version
    wget https://github.com/avh4/elm-format/releases/download/0.8.1/elm-format-0.8.1-win-i386.zip
    7z e elm-format-0.8.1-win-i386.zip
    mv elm-format.exe ./node_modules/.bin
    touch elm-package.json
    # For elm 0.19, touch elm.json instead.
}

function Invoke-ExtraInstallation {
    Install-Elm-Format
}

function Run-Composer-Install {
    $phar = "C:\ProgramData\ComposerSetup\bin\composer.phar"

    php.exe $phar install
}

function Do-Install-Packages {
    Run-Composer-Install
}

function Run-Composer-Install {
    $composer_phar = "C:\ProgramData\ComposerSetup\bin\composer.phar"

    php.exe $composer_phar install
}

function Invoke-ExtraInstallation {
    Run-Composer-Install
}

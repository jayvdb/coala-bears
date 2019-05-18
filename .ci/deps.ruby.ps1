Set-StrictMode -Version latest

function Install-Bundler {
    gem install bundler
}

function Do-PostInstall {
    Install-Bundler
}

Export-ModuleMember -Function Config-NPM, Do-PostInstall

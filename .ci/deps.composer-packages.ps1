function Run-Composer-Install
{
  $PHP = ($env:PHP_ROOT + '\php.exe')

  $phar = "C:\ProgramData\ComposerSetup\bin\composer.phar"

  Invoke-Expression "$PHP $phar install"
}

function Do-Install-Packages
{
  Run-Composer-Install
}

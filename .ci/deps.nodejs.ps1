Set-StrictMode -Version latest

function Configure-NPM
{
  if ($env:APPVEYOR_BUILD_WORKER_IMAGE -eq "Visual Studio 2017")
  {
    npm config set msvs_version 2017
  }
  else {
    npm config set msvs_version 2015
  }

  npm config set python C:\python27\python.exe
}

function Do-PostInstall
{
  Configure-NPM
}

Export-ModuleMember -Function Config-NPM, Do-PostInstall

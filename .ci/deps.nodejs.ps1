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

  # TODO: Split 'python' in Fudgefile into python27 and python3
  if (Test-Path C:\python27\python.exe)
  {
    npm config set python C:\python27\python.exe
  }
  else
  {
    npm config set python $env:ChocolateyInstall\bin\python.exe
  }
}

function Do-PostInstall
{
  Configure-NPM
}

Export-ModuleMember -Function Config-NPM, Do-PostInstall

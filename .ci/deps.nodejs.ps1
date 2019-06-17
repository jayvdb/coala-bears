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

  # TODO: Use a python27 which is specified in the Fudgefile,
  # either split 'python' in Fudgefile into python27 and python3,
  # or use msys or cygwin python2.
  $python27 = ''
  if (Test-Path C:\python27\python.exe)
  {
    $python27 = "C:\python27\python.exe"
  }
  elseif (Test-Path "$env:ChocolateyInstall\bin\python.exe")
  {
    $python = "$env:ChocolateyInstall\bin\python.exe"
  }
  elseif (Test-Path C:\msys64\usr\bin/python2.7.exe)
  {
    $python27 = "C:\msys64\usr\bin\python2.7.exe"
  }
  npm config set python $python27
}

function Install-PNPM
{
  npm install --global pnpm
}

function Do-PostInstall
{
  Configure-NPM

  Install-PNPM
}

Export-ModuleMember -Function Config-NPM, Do-PostInstall

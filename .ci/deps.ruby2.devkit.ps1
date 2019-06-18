function Add-DevKit-Path
{
  Install-ChocolateyPath -PathToInstall ($env:ChocolateyToolsLocation + '\DevKit2\bin')
}

function Do-PostInstall
{
  Add-DevKit-Path
}

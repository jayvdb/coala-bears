. $env:ChocolateyInstall\helpers\functions\Write-FunctionCallLogMessage.ps1
. $env:ChocolateyInstall\helpers\functions\Get-EnvironmentVariable.ps1
. $env:ChocolateyInstall\helpers\functions\Get-EnvironmentVariableNames.ps1
. $env:ChocolateyInstall\helpers\functions\Start-ChocolateyProcessAsAdmin.ps1
. $env:ChocolateyInstall\helpers\functions\Set-EnvironmentVariable.ps1
. $env:ChocolateyInstall\helpers\functions\Set-PowerShellExitCode.ps1
. $env:ChocolateyInstall\helpers\functions\Update-SessionEnvironment.ps1
. $env:ChocolateyInstall\helpers\functions\Write-FunctionCallLogMessage.ps1
. $env:ChocolateyInstall\helpers\functions\Install-ChocolateyPath.ps1

Set-StrictMode -Version latest

$deps_base = $env:FudgeCI

function Run-PostInstalls
{
  choco list --local-only

  Update-SessionEnvironment

  $config = Get-FudgefileContent Fudgefile

  foreach ($pkg in $config.Packages)
  {
    $name = $pkg.Name

    $glob = "$deps_base/deps.$name.ps1"

    if (Test-Path $glob)
    {
      Write-Host "Running post-install for $name"

      . $glob
      Do-PostInstall
    }
  }

  Update-SessionEnvironment

  foreach ($pkg in $config.Packages)
  {
    $name = $pkg.Name

    $glob = ".ci/deps.$name-packages.ps1"
    if (Test-Path $glob)
    {
      Write-Host "Running $name package installation"

      . $glob
      Do-Install-Packages
    }
  }
}

Export-ModuleMember -Function Run-PostInstalls

. $env:FudgeCI/FudgeGenerateFake.ps1
. $env:FudgeCI/PrepareAVVM.ps1

Set-StrictMode -Version latest

function Choose-Preinstalled-Products
{
  param(
    [array]
    $Packages
  )

  foreach ($pkg in $Packages)
  {
    try {
      $product = $pkg.AppVeyor
    } catch {
      continue
    }

    $version = $pkg.Version

    $version_parts = ($version.Split('.'))

    if ($product -eq 'jdk')
    {
      # 8 -> 1.8.0
      $version = "1." + $version_parts[0] + ".0"
    }
    elseif ($product -eq 'miniconda')
    {
      # TODO improve translation of real miniconda versions
      # into AppVeyor versions which are the python version
      if ($version -eq '4.5.12')
      {
        $version = '3.7'
      }

      if ($version[0] -eq '2')
      {
        Fix-Miniconda27
      }
    }

    # Allow the installed version of python to be over
    if ($product -eq 'python')
    {
      if ($env:PYTHON_VERSION)
      {
        $version = $env:PYTHON_VERSION
      }
    }

    Add-Product $product $version $env:PLATFORM
    if (Test-Path "C:\avvm\$product\$version\$env:PLATFORM")
    {
      Install-Product $product $version $env:PLATFORM
    }
    elseif (Test-Path "C:\avvm\$product\$version")
    {
      Install-Product $product $version
    }
  }
}

function Fix-AppVeyor
{
  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Set-Default-Versions

  Choose-Preinstalled-Products $config.packages
}

Export-ModuleMember -Function Fix-AppVeyor

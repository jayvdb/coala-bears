. .ci/FudgeGenerateFake.ps1
. .ci/PrepareAVVM.ps1

function Setup-Products
{
  param(
    [array]
    $Packages
  )

  foreach ($pkg in $Packages)
  {
    try {
      $name = $pkg.AppVeyor
    } catch {
      continue
    }

    $version = $pkg.Version

    if ($name -eq 'miniconda')
    {
      # TODO improve translation of real miniconda versions
      # into AppVeyor versions which are the python version
      if ($version -eq '4.5.12') {
        $version = '3.7'
      }

      if ($version[0] -eq '2') {
        Fix-Miniconda27
      }
    }

    # Allow the installed version of python to be over
    if ($name -eq 'python') {
      if ($env:PYTHON_VERSION) {
        $version = $env:PYTHON_VERSION
      }
    }

    Add-Product $name $version $env:PLATFORM
    Install-Product $name $version $env:PLATFORM
  }
}

function Fix-AppVeyor
{
  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Setup-Preinstalled

  Setup-Products $config.packages
}

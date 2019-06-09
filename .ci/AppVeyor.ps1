. .ci/FudgeGenerateFake.ps1
. .ci/PrepareAVVM.ps1

function Set-Python-Arch
{
  # run_with_env.cmd needs PYTHON_ARCH set to 64 for x64
  if ($env:Platform -eq 'x64')
  {
    Set-ItemProperty -path 'HKCU:\Environment' -name 'PYTHON_ARCH' -value '64'
  }
}

function Fix-AppVeyor
{
  Set-Python-Arch

  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Setup-Products $config.packages
}

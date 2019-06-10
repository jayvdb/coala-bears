. .ci/FudgeGenerateFake.ps1
. .ci/PrepareAVVM.ps1

function Fix-AppVeyor
{
  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Setup-Products $config.packages

  npm config set msvs_version 2017
  npm config set color false
  npm config set python C:\python27\python.exe
}

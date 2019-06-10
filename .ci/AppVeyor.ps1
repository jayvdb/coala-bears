. .ci/FudgeGenerateFake.ps1
. .ci/PrepareAVVM.ps1

function Fix-AppVeyor
{
  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Setup-Products $config.packages
}

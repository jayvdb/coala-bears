. .ci/FudgeGenerateFake.ps1
. .ci/PrepareAVVM.ps1

function Rebuild-Gpy
{
  $env:PATH = ('C:\Python27;' + $env:PATH)
  node --version
  $NODE_GPY_ROOT = "$env:NODE_ROOT\node_modules\npm\node_modules\node-gyp"
  node "$NODE_GPY_ROOT\bin\node-gyp.js" "rebuild"
}

function Fix-AppVeyor
{
  $config = Get-FudgefileContent .ci/Fudgefile.appveyor

  PackFakeNupkgs $config.packages

  Setup-Products $config.packages

  Rebuild-Gpy
}

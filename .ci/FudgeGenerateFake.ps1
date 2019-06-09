Set-StrictMode -Version latest

function GenerateFakeNuspec
{
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $name,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $version
  )

  $template = Get-Content .ci\nuspecs\template.nuspec.in

  $content = $template -replace '{name}', $name
  $content = $content -replace '{version}', $version

  $nuspec = ('.ci\nuspecs\' + $name + '.nuspec')

  Set-Content $nuspec $content

  Write-Output "Created $nuspec"
}

function GenerateFakeNuspecs
{
  param (
    [array]
    $Packages
  )

  foreach ($pkg in $Packages)
  {
    GenerateFakeNuspec $pkg.name $pkg.version
  }
}

function PackFakeNupkgs
{
  param (
    [array]
    $Packages
  )

  GenerateFakeNuspecs $Packages

  foreach ($pkg in $Packages)
  {
    $filename = ($pkg.name + '.nuspec')
    choco pack ".ci\nuspecs\$filename" > $null
  }
  mv *.nupkg .ci\nuspecs\

  # fudge pack -FudgefilePath .ci/Fudgefile.appveyor

  Write-Output 'Packed!'
}

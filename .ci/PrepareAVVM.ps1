Set-StrictMode -Version latest

$PACKAGES_ROOT = "$env:SYSTEMDRIVE\avvm"
$REGISTRY_ROOT = 'HKLM:\Software\AppVeyor\VersionManager'

function Get-Version([string]$str) {
    $versionDigits = $str.Split('.')
    $version = @{
        major = -1
        minor = -1
        build = -1
        revision = -1
        number = 0
        value = $null
    }

    $version.value = $str

    if($versionDigits -and $versionDigits.Length -gt 0) {
        $version.major = [int]$versionDigits[0]
    }
    if($versionDigits.Length -gt 1) {
        $version.minor = [int]$versionDigits[1]
    }
    if($versionDigits.Length -gt 2) {
        $version.build = [int]$versionDigits[2]
    }
    if($versionDigits.Length -gt 3) {
        $version.revision = [int]$versionDigits[3]
    }

    for($i = 0; $i -lt $versionDigits.Length; $i++) {
        $version.number += [long]$versionDigits[$i] -shl 16 * (3 - $i)
    }

    return $version
}

function SetInstalledProductVersion {
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $product,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $version,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $platform
  )

  $productRegPath = "$REGISTRY_ROOT\$product"
  New-Item $productRegPath -Force | Out-Null
  New-ItemProperty -Path $productRegPath -Name Version -PropertyType String -Value $version -Force | Out-Null
  New-ItemProperty -Path $productRegPath -Name Platform -PropertyType String -Value $platform -Force | Out-Null

  Write-Output "Creating C:\avvm\$product\$version\$platform"

  if (!(Test-Path "C:\avvm\$product\$version\$platform")) {
    mkdir "C:\avvm\$product\$version\$platform" -Force > $null
  }

  if (!(Test-Path "C:\avvm\$product\$version\$platform")) {
    throw "Something went wrong"
  }

}

function GetInstalledProductVersion($product) {
    $productRegPath = "$REGISTRY_ROOT\$product"
    if(Test-Path $productRegPath) {
        $ver = Get-ItemProperty -Path $productRegPath
        @{
            Product = $product
            Version = $ver.Version
            Platform = $ver.Platform
        }
    }
}

function Add-Product
{
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $product,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $version,

    [string]
    $platform
  )

  $name = $product

  if (! $platform) {
    $platform = $env:platform
  }

  $installed = GetInstalledProductVersion $Product
  if ($installed) {
    if ($installed.Version -eq $version) {
      if ($installed.Platform -eq $env:platform) {
        Write-Output "$product $version $env:platform already set up"
        return;
      }
    }
  }

  $shortver = ($version.split('.'))[0..1]
  $shortver = "{0}{1}" -f ($shortver[0], $shortver[1])

  $dir_name = $name;

  if (Test-Path "C:\avvm\$name\$version\") {
    Write-Output "C:\avvm\$name\$version exists; skipping"

    $base = 'https://appveyordownloads.blob.core.windows.net/avvm'
    $versions_content = (New-Object Net.WebClient).DownloadString("$base/$name-versions.txt")
    Set-Content "C:\avvm\$name-versions.txt" $versions_content
    return
  }

  if ($installed) {
    $current_version = $installed.Version
    if ((Get-Version $current_version).number > (Get-Version $version).number) {
      $versions_content = "$current_version
$version
lts:$version
stable:$version
current:$current_version
"
    } else {
      $versions_content = "$version
$current_version
lts:$version
stable:$version
current:$current_version
"
    }
  }
  else {
    $versions_content = "$version
lts:$version
stable:$version
"
  }
  Set-Content "C:\avvm\$name-versions.txt" $versions_content

  Write-Output "Wrote C:\avvm\$name-versions.txt"

  mkdir "C:\avvm\$name" -Force > $null

  mkdir "C:\avvm\$name\$version" -Force > $null

  Write-Verbose "Looking for $shortver C:\$dir_name$shortver .."

  if (!( Test-Path "C:\$dir_name$shortver")) {
    throw "Cant find $dir_name$shortver"
  }

  mkdir "C:\avvm\$name\$version\$platform" -Force > $null

  Write-Output "Looking for C:\$name$shortver-x64 .."

  $dir = ''
  if (Test-Path "C:\$dir_name$shortver-x64") {
    if ($platform -eq "x64") {
      $dir = "C:\$dir_name$shortver-x64"
    }
    else {
      $dir = "C:\$dir_name$shortver"
    }
  }

  # TODO: Re-arrange to look only for the needed platform
  if (! $dir) {
    Write-Output "Looking for C:\$dir_name$shortver-x86 .."
  }

  if ((!($dir)) -and (Test-Path "C:\$dir_name$shortver-x86")) {
    if ($platform -eq "x86") {
      $dir = "C:\$dir_name$shortver-x86"
    }
    else {
      $dir = "C:\$dir_name$shortver"
    }
  }

  if (!($dir)) {
    throw 'couldnt find x86/x64 directories for $name'
  }

  if (!( Test-Path $dir)) {
    throw "Cant find $dir"
  }

  Write-Output "Coping $dir to C:\avvm\$name\$version\$platform\$name ..."

  # Copy-Item -Path $dir -destination "C:\avvm\$name\$version\$platform\$name" -Recurse -Container
  move $dir "C:\avvm\$name\$version\$platform\$name"

  $files_content = ('$files = @{ "' + $name + '" = "C:\' + $name + '" }')
  $files_path = "C:\avvm\$name\$version\$platform\files.ps1"

  Write-Output "Creating $files_path"

  Set-Content $files_path $files_content
}

function Setup-Preinstalled
{
  $env:AVVM_DOWNLOAD_URL = '../../avvm/'
  Set-ItemProperty -path 'HKCU:\Environment' -name 'AVVM_DOWNLOAD_URL' -value $env:AVVM_DOWNLOAD_URL

  # node already set to 8.x
  SetInstalledProductVersion go 1.12.3 x64

  SetInstalledProductVersion miniconda 2.7.15 x86
  SetInstalledProductVersion miniconda3 3.7.0 x86
  SetInstalledProductVersion perl 5.20.1.2000 x86
}

function Setup-Products
{
  param (
    [array]
    $Packages
  )
  Setup-Preinstalled

  foreach ($pkg in $Packages)
  {
    $name = $pkg.name
    $version = $pkg.version

    if (($name -eq 'StrawberryPerl') -or ($name -eq 'mingw')) {
      # Could be mapped to 'perl', but they are slightly different
      # TODO: Mingw on AppVeyor is in complex directory names
      continue
    }

    if ($name -eq 'nodejs') {
      $name = 'node'
    }
    elseif ($name -eq 'golang') {
      $name = 'go'
    }
    elseif ($name -eq 'miniconda3') {
      $name = 'miniconda'
    }

    if ($name -eq 'python') {
      if ($env:PYTHON_VERSION) {
        $version = $env:PYTHON_VERSION
      }
    }

    if ($name -eq 'miniconda')
    {
      # TODO improve translation of real miniconda versions
      # into AppVeyor versions which are the python version
      if ($version -eq '4.5.12') {
        $version = '3.7'
      }

      if ($version[0] -eq '2') {
        Write-Output "Moving C:\Miniconda(-x64) to C:\Miniconda27(-x64)"
        move C:\Miniconda C:\Miniconda27
        move C:\Miniconda-x64 C:\Miniconda27-x64
      }
    }

    Add-Product $name $version $env:PLATFORM
    Install-Product $name $version $env:PLATFORM
  }
}

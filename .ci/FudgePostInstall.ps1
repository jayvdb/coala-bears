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


function Get-PHP-Root
{
  $list = Get-ChildItem -Directory 'C:\tools\' | Out-String
  Write-Verbose $list

  Get-ChildItem -Directory 'C:\tools\' -filter 'php*' | % {
    $PHP_ROOT = $_.FullName

    Write-Host 'Setting PHP_ROOT='$PHP_ROOT

    Set-ItemProperty -path 'HKCU:\Environment' -name 'PHP_ROOT' -value $PHP_ROOT
  }
  if ($PHP_ROOT) {
    return $PHP_ROOT
  }
  throw ('php not found in ' + $list)
}

function Create-PHP-Ini
{
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PHP_ROOT
  )

  $PHP_INI = ($PHP_ROOT + '\php.ini')

  Write-Host 'Creating '$PHP_INI

  cp ($PHP_INI + '-production') $PHP_INI
  sed -i 's/;date.timezone =.*/date.timezone=UTC/' $PHP_INI

  $list = Get-ChildItem -Recurse $PHP_ROOT | Out-String
  Write-Verbose ('php dir ' + $list)

  Write-Host 'Enabling PHP openssl ...'

  $openssl_dll = ''

  Get-ChildItem $PHP_ROOT -Recurse -filter '*openssl*.dll' | % {
    $openssl_dll = $_.FullName
    Write-Host ' found '$openssl_dll
  }
  if (! $openssl_dll) {
    Write-Host ' not found'
    throw ('openssl not found in ' + $list)
  }

  sed -i 's/;extension=openssl/extension=openssl/' $PHP_INI

  $dir = Split-Path -Path $openssl_dll
  Write-Host 'Setting extension directory: '$dir

  (Get-Content $PHP_INI) | % {
    $_ -replace ';extension_dir *=.*', ('extension_dir="' + $dir + '"')
  } | Set-Content $PHP_INI

  grep '^extension' $PHP_INI
}

function Install-PEAR
{
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PHP_ROOT
  )

  $PHP = ($PHP_ROOT + '\php.exe')

  Write-Host 'Installing PEAR'

  $pear_install_url = 'http://pear.php.net/install-pear-nozlib.phar'
  $phar = $env:TMP + '\install-pear.phar'

  curl -o $phar $pear_install_url

  $opts = ('-b ' + $PHP_ROOT + ' -d ' + $PHP_ROOT + ' -p ' + $PHP)

  Invoke-Expression ($PHP + ' ' + $phar + ' ' + $opts)
}

function Update-PEAR
{
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PHP_ROOT
  )

  $PHP = ($PHP_ROOT + '\php.exe')

  Write-Host 'Updating PEAR channel pear.php.net'

  $pearcmd = ($PHP_ROOT + '\pearcmd.php')

  $pear_update_cmd = ($PHP + ' ' + $pearcmd + ' channel-update pear.php.net')

  Invoke-Expression $pear_update_cmd
}

function Add-R-to-PATH
{
  $list = Get-ChildItem -Directory 'C:\Program Files\R' | Out-String
  Write-Verbose $list

  Get-ChildItem -Directory 'C:\Program Files\R' | % {
    $R_ROOT = $_.FullName

    # $R_ROOT = $R_ROOT -replace 'C:\\Program Files', '%ProgramFiles%'

    Write-Host 'Setting R_ROOT='$R_ROOT

    Set-ItemProperty -path 'HKCU:\Environment' -name 'R_ROOT' -value $R_ROOT

    $R_BIN = ($R_ROOT + '\bin')

    Install-ChocolateyPath -PathToInstall $R_BIN
  }
  if ($R_ROOT) {
    return $R_ROOT
  }
  throw ('R not found in ' + $list)
}

function Update-Cabal
{
  cabal update
}

function PPM-Install-cpanm
{
  ppm install App-cpanminus
}

function Install-GoMetaLinter
{
  go.exe get -u gopkg.in/alecthomas/gometalinter.v2

  $list = Get-ChildItem -Recurse $env:GOPATH | Out-String
  Write-Output ('go dir ' + $list)

  $gometalinter_install_cmd = ($env:GOPATH + '\bin\gometalinter.v2.exe --install')

  Invoke-Expression $gometalinter_install_cmd
}

function Install-GoPM
{
  go.exe get -u github.com/gpmgo/gopm
  go.exe install github.com/gpmgo/gopm
}

function Fixes
{
  $PHP_ROOT = Get-PHP-Root

  # Create-PHP-Ini $PHP_ROOT
  Install-PEAR $PHP_ROOT
  Update-PEAR $PHP_ROOT

  Add-R-to-PATH

  Install-GoMetaLinter
  Install-GoPM

  go get -u github.com/BurntSushi/toml/cmd/tomlv
  go get -u sourcegraph.com/sqs/goreturns

  sed -i '/sqlint/d' Gemfile
  bundle install

  Update-Cabal

  PPM-Install-cpanm

  npm config set loglevel warn
  npm install

  cpanm --quiet --installdeps --with-develop --notest .

  composer install

  return $LastExitCode
}

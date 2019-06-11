function Get-PHP-Root
{
  $PHP_ROOT = ''
  Get-ChildItem -Directory 'C:\tools\' -Filter 'php*' | ForEach-Object {
    $PHP_ROOT = $_.FullName.ToString()

    Write-Host "Setting PHP_ROOT='$PHP_ROOT'"

    $env:PHP_ROOT = $PHP_ROOT
    Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PHP_ROOT' -Value $PHP_ROOT
  }
  if ($PHP_ROOT) {
    return $PHP_ROOT
  }
  throw ('php not found in ' + $list)
}

# This is not needed with the recent choco php packages
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
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PHP_ROOT
  )

  $PHP_INI = "$PHP_ROOT\php.ini"

  grep '^extension' $PHP_INI

  $PHP = "$PHP_ROOT\php.exe"

  Write-Output 'Installing PEAR'

  $pear_install_url = 'http://pear.php.net/install-pear-nozlib.phar'
  $phar = $env:TMP + '\install-pear.phar'

  curl -o $phar $pear_install_url

  $opts = "-b $PHP_ROOT -d $PHP_ROOT -p $PHP"

  Invoke-Expression ($PHP + ' ' + $phar + ' ' + $opts)
}

function Update-PEAR
{
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PHP_ROOT
  )

  $PHP = "$PHP_ROOT\php.exe"

  Write-Output 'Updating PEAR channel pear.php.net'

  $pearcmd = "$PHP_ROOT\pearcmd.php"

  $pear_update_cmd = ($PHP + ' ' + $pearcmd + ' channel-update pear.php.net')

  Invoke-Expression $pear_update_cmd
}

function Do-PostInstall
{
  $PHP_ROOT = Get-PHP-Root

  Write-Host "PHP_ROOT = $PHP_ROOT"

  Install-PEAR $PHP_ROOT
  Update-PEAR $PHP_ROOT
}

Export-ModuleMember -Function Get-PHP-Root, Get-PHP-Root, Update-PEAR, Update-PEAR

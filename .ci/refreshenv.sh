function refreshenv
{
  powershell -NonInteractive - <<\EOF
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

Update-SessionEnvironment

# Round brackets in variable names cause problems with bash
Get-ChildItem env:* | %{
  if (!($_.Name.Contains('('))) {
    $value = $_.Value
    if ($_.Name -eq 'PATH') {
      $value = $value -replace ';',':'
    }
    Write-Output ("export " + $_.Name + "='" + $value + "'")
  }
} | Out-File -Encoding ascii C:\TEMP\refreshenv.sh

EOF

  cat "/c/TEMP/refreshenv.sh"
  source "/c/TEMP/refreshenv.sh"
}

alias RefreshEnv=refreshenv

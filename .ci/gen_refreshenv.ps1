Import-Module C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1

Update-SessionEnvironment

# Round brackets in variable names cause problems with bash
Get-ChildItem env:* | Where-Object Name -cNotContains '(' | %{
  Write-Output ($_.Name + "='" + $_.Value + "'")
} | Out-File -Encoding utf8 C:\TEMP\refreshenv.sh
Import-Module C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1

Update-SessionEnvironment

# Round brackets in variable names cause problems with bash
Get-ChildItem env:* | %{
  if (!($_.Name.Contains('('))) {
    Write-Output ("export " + $_.Name + "='" + $_.Value + "'")
  }
} | Out-File -Encoding ascii C:\TEMP\refreshenv.sh

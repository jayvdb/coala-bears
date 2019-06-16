Import-Module C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1

Update-SessionEnvironment

Get-ChildItem env:* | where name -cNotContains '(' | %{
  Write-Output "$_.Name='$_.Value'"
} | Out-File C:\TEMP\refreshenv.sh

Import-Module C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1

Update-SessionEnvironment

gci env:* | where name -cNotContains '(' | %{write-Output $_.Name ' = ''' $_.Value ''''} | Out-File C:\TEMP\refreshenv.sh

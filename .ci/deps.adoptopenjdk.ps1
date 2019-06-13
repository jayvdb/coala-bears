Set-StrictMode -Version latest

function unix2dos
{
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $filename
  )

  Get-Content $filename |% {$_.replace("`n", "`r`n")} | Out-File -Filepath $filename
}

function Do-PostInstall
{
  # Force DOS format, as Checkstyle configs enable NewlineAtEndOfFile,
  # which defaults to CRLF on Windows, and Appveyor CI ignores .gitattributes
  # http://help.appveyor.com/discussions/problems/5687-gitattributes-changes-dont-have-any-effect
  unix2dos tests/java/test_files/CheckstyleGood.java
}

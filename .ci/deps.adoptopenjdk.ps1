Set-StrictMode -Version latest

function unix2dos {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $filename
    )

    $result = Get-Content $filename |
        ForEach-Object { $_.replace("`n", "`r`n") }

    $result = ($result + "`r`n")

    Set-Content -Path $filename $result
}

function Do-PostInstall {
    # Force DOS format, as Checkstyle configs enable NewlineAtEndOfFile,
    # which defaults to CRLF on Windows, and Appveyor CI ignores .gitattributes
    # http://help.appveyor.com/discussions/problems/5687-gitattributes-changes-dont-have-any-effect
    unix2dos tests/java/test_files/CheckstyleGood.java
}

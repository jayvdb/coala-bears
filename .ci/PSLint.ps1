Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

Import-Module -Name 'PsScriptAnalyzer' -Force
$base = $global:PSScriptRoot

# Using a local copy of a tiny subset of dbatools
# and because of https://github.com/sqlcollaborative/dbatools/issues/5800
# and to track changes which might mean WriteFileUsingEOL is not neeeded
. "$base\Stop-Function.ps1"
. "$base\Test-FunctionInterrupt.ps1"
. "$base\Invoke-DbatoolsFormatter.ps1"


$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

function Test-Skip-File {
    param (
        [Parameter(Mandatory)]
        [string]
        $filename
    )

    # Ignore imported files
    # https://github.com/pypa/virtualenv/issues/1371
    # https://github.com/ogrisel/python-appveyor-demo/issues/55
    # https://github.com/MathieuBuisson/PowerShell-DevOps/issues/6
    return (
        $filename -eq 'Export-NUnitXml.psm1' -or
        $filename -eq 'Invoke-DbatoolsFormatter.ps1' -or
        $filename -eq 'Stop-Function.ps1' -or
        $filename -eq 'Test-FunctionInterrupt.ps1' -or
        $filename -eq 'Fudge.ps1' -or
        $filename -eq 'FudgeTools.psm1' -or
        $filename -eq 'install.ps1' -or
        $filename -eq 'activate.ps1' -or
        $filename.EndsWith('.jj2'))
}

$UNIXEOL = "`n"

function WriteFileUsingEOL {
    param (
        [Parameter(Mandatory)]
        [string]
        $filename,

        [Parameter(Mandatory)]
        [string]
        $eol
    )
    $content = Get-Content -Raw $filename
    if ($content) {
        $content = $content -split "`r?`n"
        if (!($content[-1])) {
            $content = $content[0..($content.length - 2)]
        }
        $content = (($content -join $eol) + $eol)
        [System.IO.File]::WriteAllText($filename, $content, $Utf8NoBomEncoding)
    }
}

function ReformatFile {
    param (
        [Parameter(Mandatory)]
        [string]
        $filename
    )

    # https://github.com/sqlcollaborative/dbatools/issues/5804
    Set-StrictMode -Off

    Invoke-DbatoolsFormatter $filename

    Set-StrictMode -Version Latest

    WriteFileUsingEOL $filename $UNIXEOL
}

[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]$ScriptAnalyzerResult = $null

Get-ChildItem -Recurse -Force '*.ps*' | ForEach-Object {
    $path = $_.FullName

    if ( $path.Contains('.git') -or (Test-Skip-File($_.Name)) ) {
        Write-Output "Skipping $path"
    } else {
        $NewResult = Invoke-ScriptAnalyzer -Setting $base\PSScriptAnalyzerSettings.psd1 -Path $path
        if ($ScriptAnalyzerResult) {
            $ScriptAnalyzerResult += $NewResult
        } else {
            $ScriptAnalyzerResult = $NewResult
        }

        ReformatFile $path
    }
}

if ($env:APPVEYOR) {
    Import-Module "$base\Export-NUnitXml.psm1"
    Export-NUnitXml -ScriptAnalyzerResult $ScriptAnalyzerResult -Path ".\ScriptAnalyzerResult.xml"
    (New-Object 'System.Net.WebClient').UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
        (Resolve-Path .\ScriptAnalyzerResult.xml)
    )
}

if ($ScriptAnalyzerResult) {
    Write-Output $ScriptAnalyzerResult

    # Failing the build
    Throw 'Build failed because there was one or more PSScriptAnalyzer violation. See test results for more information.'
}

git diff --exit-code

Import-Module -Name 'PsScriptAnalyzer' -Force
$base = $global:PSScriptRoot

. "$base\Stop-Function.ps1"
. "$base\Test-FunctionInterrupt.ps1"
. "$base\Invoke-DbatoolsFormatter.ps1"

$ScriptAnalyzerResult = Invoke-ScriptAnalyzer -Setting $base\PSScriptAnalyzerSettings.psd1 -Path $pwd -Recurse

if ($ScriptAnalyzerResult) {
    $ScriptAnalyzerResultString = $ScriptAnalyzerResult |
        Out-String

    Write-Warning $ScriptAnalyzerResultString
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
    # Failing the build
    Throw 'Build failed because there was one or more PSScriptAnalyzer violation. See test results for more information.'
}

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

Get-ChildItem -Recurse -Force '*.ps*' | ForEach-Object {
    # Ignore .git, virtualenv activate.ps1, copies, and templates
    if (!($_.Name -eq 'Export-NUnitXml.psm1' -or
            $_.FullName.Contains('.git') -or
            $_.Name -eq 'activate.ps1' -or
            $_.Name -eq 'install.ps1' -or
            $_.Name -eq 'Invoke-DbatoolsFormatter.ps1' -or
            $_.Name -eq 'Stop-Function.ps1' -or
            $_.Name -eq 'Test-FunctionInterrupt.ps1' -or
            $_.Name -eq 'constants.ps1.jj2')) {
        Invoke-DbatoolsFormatter $_
        $content = Get-Content -Raw $_
        if (!($content.EndsWith("`n"))) {
            $content = ($content + "`n")
            [System.IO.File]::WriteAllText($_, $content, $Utf8NoBomEncoding)
        }
    }
}

git diff --exit-code

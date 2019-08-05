Set-StrictMode -Version latest

# PMD choco package needs jre8
function Add-FakeJRE8 {
    GenerateFakeNuspec jre8 '8.0.221'

    $filename = "$env:FudgeCI/nuspecs/$jre8.nuspec"

    Invoke-Chocolatey -Action pack -Package jre8 -Version '8.0.221'
}

function Complete-Install {
    Add-FakeJRE8
}

Export-ModuleMember -Function Complete-Install

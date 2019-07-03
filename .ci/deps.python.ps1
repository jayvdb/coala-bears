Set-StrictMode -Version latest

function Add-EnvPythonVersion {
    if ($env:TRAVIS -and $env:TRAVIS_PYTHON_VERSION) {
        $env:PYTHON_VERSION = $env:TRAVIS_PYTHON_VERSION.Substring(0, 3)
    }
}

function Add-EnvPythonMinorNodots {
    if (!($env:PYTHON_MINOR_NODOTS)) {
        $env:PYTHON_MINOR_NODOTS = $env:PYTHON_VERSION -replace '.', ''
    }
}

function Add-PATHPythonRoaming {
    $roaming_home = (
        $env:APPDATA + '/Python/Python' + $env:PYTHON_MINOR_NODOTS)

    Install-ChocolateyPath -PathToInstall $roaming_home
    Install-ChocolateyPath -PathToInstall ($roaming_home + '/Scripts')
}

function Complete-Install {
    Add-EnvPythonVersion

    Add-EnvPythonMinorNodots

    Add-PATHPythonRoaming
}

Export-ModuleMember -Function Complete-Install

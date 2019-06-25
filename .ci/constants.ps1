$name = 'coala-bears'
$pip_version = '9.0.1'
$setuptools_version = '21.2.2'

$old_EAP = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Export-ModuleMember -Variable name, pip_version, setuptools_version
$ErrorActionPreference = $old_EAP

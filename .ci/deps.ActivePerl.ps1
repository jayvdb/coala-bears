Set-StrictMode -Version latest

function Install-PPM-cpanm {
    ppm install App-cpanminus
}

function Complete-Install {
    Install-PPM-cpanm
    Remove-Item -Force MYMETA.yml
}

Export-ModuleMember -Function Install-PPM-cpanm, Complete-Install

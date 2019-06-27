Set-StrictMode -Version latest

function PPM-Install-cpanm {
    ppm install App-cpanminus
}

function Complete-Install {
    PPM-Install-cpanm
}

Export-ModuleMember -Function PPM-Install-cpanm, Complete-Install

Set-StrictMode -Version latest

function Install-PPM-cpanm {
    ppm install http://www.bribes.org/perl/ppm/App-cpanminus.ppd
}

function Complete-Install {
    Install-PPM-cpanm
}

Export-ModuleMember -Function Install-PPM-cpanm, Complete-Install

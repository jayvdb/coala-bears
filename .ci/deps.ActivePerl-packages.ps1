function Install-Perl-Modules {
    cpanm --quiet --installdeps --with-develop --notest .
    Remove-Item -Force MYMETA.yml
}

function Invoke-ExtraInstallation {
    Install-Perl-Modules
}

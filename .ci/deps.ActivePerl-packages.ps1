function Install-Perl-Modules {
    cpanm --quiet --installdeps --with-develop --notest .
}

function Invoke-ExtraInstallation {
    Install-Perl-Modules
}

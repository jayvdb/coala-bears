function Install-Perl-Modules {
    cpanm --quiet --installdeps --with-develop --notest .
}

function Do-Install-Packages {
    Install-Perl-Modules
}

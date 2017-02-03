#use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Coala::Bears',
    VERSION           => '1.00', # finds $VERSION
    PREREQ_PM         => {Perl::Critic => 1.126},
);


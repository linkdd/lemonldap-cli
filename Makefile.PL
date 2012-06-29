use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Lemonldap::NG::Cli',
    VERSION_FROM => 'lib/Lemonldap/NG/Cli.pm',    # finds $VERSION
    PREREQ_PM    => { 'Lemonldap::NG::Common::Conf' => 1.0 },                           # e.g., Module::Name => 1.1
    (
        $] >= 5.005
        ?    ## Add these new keywords supported since 5.005
          (
            ABSTRACT_FROM =>
              'lib/Lemonldap/NG/Cli.pm',    # retrieve abstract from module
            AUTHOR => 'David Delassus <david.jose.delassus@gmail.com>'
          )
        : ()
    ),
    EXE_FILES => ['bin/lemonldap-ng-cli']
);

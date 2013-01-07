use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::Whitespaces',
    AUTHOR              => q{Ivan Bessarabov <ivan@bessarabov.ru>},
    VERSION_FROM        => 'lib/Test/Whitespaces.pm',
    ABSTRACT_FROM       => 'lib/Test/Whitespaces.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES    => [ grep { /\w$/ } glob("bin/*") ],
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-Whitespaces-*' },
);

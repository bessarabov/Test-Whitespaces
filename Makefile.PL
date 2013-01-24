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
        'Carp' => 0,
        'Cwd' => 0,
        'Exporter' => 0,
        'File::Find' => 0,
        'FindBin' => 0,
        'List::Util' => 0,
        'Pod::Usage' => 0,
        'Term::ANSIColor' => 0,
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-Whitespaces-*' },
);

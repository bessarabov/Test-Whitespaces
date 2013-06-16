#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;
use Test::Differences;
use File::Slurp;
use Test::More tests => 1;

use lib::abs qw(
    .
);
use Utils;

sub main {
    my $data = Utils::convert_data_section(<DATA>);

    my $output = `prove -Ilib -v t_failing/unicode.t`;

    # removing chaning line:
    # Files=1, Tests=5,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.04 cusr  0.02 csys =  0.09 CPU)
    $output =~ s/Files(.*)CPU\)//ms;

    eq_or_diff(
        $output,
        $data,
        "settings for tabs",
    );
}

main();
__DATA__
t_failing/unicode.t ..\s
not ok 1 - whitespaces in samples_with_whitespaces_errors/unicode
# ...
# line 5: ...в оттепель, часов в девять утра, поезд Петербургско-Варшавской_\n
# line 6: ... на всех парах подходил к Петербургу. Было так сыро и туманно,_\n
# line 7: ...ассвело; в десяти шагах, вправо и влево от дороги, трудно было_\n
# line 8: ...что-нибудь из окон вагона. Из пассажиров были и возвращавшиеся_\n
# line 9: ...; но более были наполнены отделения для третьего класса, и всё_\n
# line 10: ...деловым, не из очень далека. Все, как водится, устали, у всех_\n
# line 11: ...ь глаза, все назяблись, все лица были бледно-желтые, под цвет_\n
# line 12: тумана._\n
1..1
Failed 1/1 subtests\s

Test Summary Report
-------------------
t_failing/unicode.t (Wstat: 0 Tests: 1 Failed: 1)
  Failed test:  1

Result: FAIL

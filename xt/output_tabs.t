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

    my $output = `prove -Ilib -v t_failing/tabs.t`;

    # removing chaning line:
    # Files=1, Tests=5,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.04 cusr  0.02 csys =  0.09 CPU)
    $output =~ s/Files(.*)CPU\)//ms;

    TODO: {
        local $TODO = "Need to write code that will allow customization";
    eq_or_diff(
        $output,
        $data,
        "settings for tabs",
    );
    }
}

main();
__DATA__
t_failing/tabs.t ..\s
ok 1 - whitespaces in samples_with_whitespaces_errors/file_with_tabs
1..1
ok
All tests successful.

Result: PASS

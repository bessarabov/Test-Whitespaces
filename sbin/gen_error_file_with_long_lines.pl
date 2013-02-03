#!/usr/bin/perl

=encoding UTF-8
=cut

=head1 Описание

=cut

# common modules
use strict;
use warnings FATAL => 'all';
use 5.010;
use DDP;
use Carp;
use lib::abs qw(./lib);
use File::Slurp;

# global vars

# subs

# main
sub main {
    my $content;

    foreach my $n (65..80) {
        my $string = "x"x($n - 4);
        $content .= "$n $string \n";
    }

    write_file('samples_with_whitespaces_errors/lines.pm', $content);

    say '#END';
}

main();
__END__

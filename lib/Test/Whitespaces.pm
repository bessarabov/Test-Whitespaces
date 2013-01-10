package Test::Whitespaces;

use warnings;
use strict;

use Carp;
use Cwd 'realpath';
use File::Find;
use FindBin qw($Bin);
use List::Util qw(max);

use Test::Whitespaces::Common;

=head1 NAME

Test::Whitespaces - Test source code for errors in whitespaces

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my $true = 1;
my $false = '';

my $params = {
    dirs => [
        "$Bin/../bin",
        "$Bin/../lib",
        "$Bin/../t",
        "$Bin/../xt",
    ],
};

my $current_test = 0;

=head1 SYNOPSIS

=head1 SUBROUTINES/METHODS

=cut

sub import {
    my ($class, $args) = @_;

    if (defined $args and ref $args ne "HASH") {
        croak "Test::Whitespaces expected to recieve hashref with params. Stopped";
    }

    if (defined $args->{dirs}) {
        $params->{dirs} = $args->{dirs};
    }

    main();
}

# writing custom is() because Test::More::is() output ugly additional info
sub is {
    my ($got, $expected, $text) = @_;

    $current_test++;

    if ($got eq $expected) {
        print "ok $current_test - $text\n";
    } else {
        print "not ok $current_test - $text\n";
        output_diag($got, $expected);
    }
}

sub diag {
    my ($text) = @_;

    my @lines = split /\n/, $text;

    print "# $_\n" foreach @lines;
}

sub done_testing {
    print "1..$current_test\n";
};

sub output_diag {
    my ($got, $expected) = @_;

    croak "Expected 'got'" if not defined $got;
    croak "Expected 'expected'" if not defined $expected;

    my @got_lines = split /\n/, $got, -1;
    my @expected_lines = split /\n/, $expected, -1;

    my $lines_in_file = max(scalar @got_lines, scalar @expected_lines);
    foreach my $line_number (1 .. $lines_in_file) {
        my $i = $line_number - 1;

        if (not defined $got_lines[$i]) {
            # no \n on the last line
            diag_error_line($line_number-1, $got_lines[$i-1]);
            next;
        }

        if (not defined $expected_lines[$i] or ($got_lines[$i] ne $expected_lines[$i])) {
            # empty lines in the end of file or some problems with whitespaces
            diag_error_line($line_number, $got_lines[$i] . "\n");
        }
    }

}

sub diag_error_line {
    my ($line_number, $error_line) = @_;

    $error_line =~ s{\t}{\\t}g;
    $error_line =~ s{\r}{\\r}g;
    $error_line =~ s{( +)(\n?)$}{"•" x length($1) . $2}eg;
    $error_line =~ s{\n}{\\n}g;

    diag("L$line_number $error_line");

}

sub check_file {
    my $filename = $File::Find::fullname;

    return if not defined $filename;

    $filename = realpath($filename);

    my @vcs_dirs = (
        qr{\.git/},
        qr{\.hg/},
        qr{\.svn/},
    );

    foreach (@vcs_dirs) {
        return if $filename =~ $_;
    }

    if (-T $filename) {
        my $content = read_file($filename);
        my $fixed_content = get_fixed_text($content);

        my $module_path = realpath("$Bin/..") . "/";
        my $relative_filename = $filename;
        $relative_filename =~ s{^$module_path}{};

        is($content, $fixed_content, "whitespaces in $relative_filename");
    }

}

sub main {

    find({ wanted => \&check_file, follow => 1 }, @{$params->{dirs}});

    done_testing();

}

=head1 AUTHOR

Ivan Bessarabov, C<< <ivan at bessarabov.ru> >>

=head1 SOURCE CODE

The source code for this module is hosted on GitHub
L<https://github.com/bessarabov/Test-Whitespaces>

=head1 BUGS

Please report any bugs or feature requests in GitHub Issues
L<https://github.com/bessarabov/Test-Whitespaces/issues>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Ivan Bessarabov.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;

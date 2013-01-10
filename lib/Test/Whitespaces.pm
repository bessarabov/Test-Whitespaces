package Test::Whitespaces;

use warnings;
use strict;

use Carp;
use Test::More;
use File::Find;
use FindBin qw($Bin);

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

sub check_file {

    my $filename = $File::Find::fullname;

    return if not defined $filename;

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

        ok($content eq $fixed_content, "Checking whitespaces in file: '$filename'");
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

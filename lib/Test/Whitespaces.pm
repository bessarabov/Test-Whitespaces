package Test::Whitespaces;

use warnings;
use strict;

use Carp;
use Cwd 'realpath';
use File::Find;
use FindBin qw($Bin);
use List::Util qw(max);

=head1 NAME

Test::Whitespaces - Test source code for errors in whitespaces

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my $true = 1;
my $false = '';

my $current_test = 0;

=head1 SYNOPSIS

=head1 SUBROUTINES

=cut

sub import {
    my ($class, $args) = @_;

    if (defined $args and ref $args ne "HASH") {
        croak "Test::Whitespaces expected to recieve hashref with params. Stopped";
    }

    if (not defined $args->{dirs}) {
        $args->{dirs} = [
            "$Bin/../bin",
            "$Bin/../lib",
            "$Bin/../t",
            "$Bin/../xt",
        ],
    }

    if (not defined $args->{files}) {
        $args->{files} = [];
    }

    if (not $args->{_only_load}) {
        _check_dir($_) foreach @{$args->{dirs}};
        _check_file($_) foreach @{$args->{files}};
        _done_testing();
    }
}

# writing custom _is() because Test::More::is() output ugly additional info
sub _is {
    my ($got, $expected, $text) = @_;

    $current_test++;

    if ($got eq $expected) {
        print "ok $current_test - $text\n";
    } else {
        print "not ok $current_test - $text\n";
        print _get_diff($got, $expected);
    }
}

sub _done_testing {
    print "1..$current_test\n";
};

sub _read_file {
    my ($filename) = @_;

    open FILE, "<", $filename or croak "Can't open file '$filename': $!";
    my @lines = <FILE>;
    close FILE;

    my $content = join '', @lines;

    return $content;
}

sub _write_file {
    my ($filename, $content) = @_;

    open FILE, ">", $filename or croak "Can't open file '$filename': $!";
    print FILE $content;
    close FILE;

    return $false;
}

sub _get_fixed_text {
    my ($original_text) = @_;

    my $fixed_text;

    my @lines = split(/\n/, $original_text);

    foreach my $line (@lines) {
        $line =~ s{\t}{    }g;
        $line =~ s{\s*$}{\n};
        $fixed_text .= $line;
    }

    $fixed_text .= "\n";
    $fixed_text =~ s{\s*$}{\n};

    return $fixed_text;
}

sub _get_diff {
    my ($got, $expected) = @_;

    croak "Expected 'got'" if not defined $got;
    croak "Expected 'expected'" if not defined $expected;

    if ($got eq "") {
        return "# L1\n";
    }

    my $diff = '';

    my @got_lines = split /\n/, $got, -1;
    my @expected_lines = split /\n/, $expected, -1;

    my %error_lines;    # key - line number, value - line content

    my $lines_in_file = max(scalar @got_lines, scalar @expected_lines);
    foreach my $line_number (1 .. $lines_in_file) {
        my $i = $line_number - 1;

        if (not defined $got_lines[$i]) {
            # no \n on the last line
            $error_lines{$line_number-1} = $got_lines[$i-1];
            next;
        }

        if (not defined $expected_lines[$i] or ($got_lines[$i] ne $expected_lines[$i])) {
            # empty lines in the end of file or some problems with whitespaces
            $error_lines{$line_number} = $got_lines[$i] . "\n";
        }
    }

    my $previous_line_number = 0;
    foreach my $line_number (sort {$a <=> $b} keys %error_lines) {

        if ($previous_line_number + 1 != $line_number) {
            $diff .= "# ...\n";
        }

        $diff .= _get_diff_line($line_number, $error_lines{$line_number});

        $previous_line_number = $line_number;
    }

    return $diff;
}

sub _get_diff_line {
    my ($line_number, $error_line) = @_;

    return "# L$line_number\n" if not defined $error_line;

    $error_line =~ s{\t}{\\t}g;
    $error_line =~ s{\r}{\\r}g;
    $error_line =~ s{( +)(\n?)$}{"•" x length($1) . $2}eg;
    $error_line =~ s{\n}{\\n}g;

    return "# L$line_number $error_line\n";
}

sub _file_is_in_vcs_index {
    my ($filename) = @_;

    my @vcs_dirs = (
        qr{\.git/},
        qr{\.hg/},
        qr{\.svn/},
    );

    foreach (@vcs_dirs) {
        return $true if $filename =~ $_;
    }

    return $false;
}

sub _check_file {
    my ($filename) = @_;

    return if not defined $filename;
    return if _file_is_in_vcs_index($filename);

    $filename = realpath($filename);

    if (-T $filename) {
        my $content = _read_file($filename);
        my $fixed_content = _get_fixed_text($content);

        my $module_path = realpath("$Bin/..") . "/";
        my $relative_filename = $filename;
        $relative_filename =~ s{^$module_path}{};

        _is($content, $fixed_content, "whitespaces in $relative_filename");
    }

}

sub _check_dir {
    my ($dir) = @_;

    find(
        {
            wanted => sub { _check_file($File::Find::fullname) },
            follow => 1,
        },
        $dir,
    );
}

sub _fix_file {
    my ($filename) = @_;

    return if not defined $filename;
    return if _file_is_in_vcs_index($filename);

    if (-T $filename) {
        my $content = _read_file($filename);
        my $fixed_content = _get_fixed_text($content);

        if ($content ne $fixed_content) {
            _write_file($filename, $fixed_content);
        }
    }
}

sub _fix_dir {
    my ($dir) = @_;

    find(
        {
            wanted => sub { _fix_file($File::Find::fullname) },
            follow => 1,
        },
        $dir,
    );
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

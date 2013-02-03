package Test::Whitespaces;

use warnings;
use strict;

use Carp;
use Cwd qw(realpath);
use File::Find;
use FindBin qw($Bin);
use List::Util qw(max);
use Term::ANSIColor qw(:constants);
use Pod::Usage;

=encoding UTF-8

=head1 NAME

Test::Whitespaces - test source code for errors in whitespaces

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

In xt/whitespaces.t:

    use Test::Whitespaces;

Running this test will check all files with the source code in the directories
bin, lib, t and xt for errors in whitespaces. It will pretty print all the
errors, so it is easy to fix them (by the way, this module ships with a script
`L<whiter>` that can automaticly fix all the errors).

You can also customize the test. All parameters are optional.

    use Test::Whitespaces {
        dirs => [ 'script', 'lib' ], # Directories to check all the files from
        files => [ 'README' ],       # Additional files to check
        ignore => [ qr{\.bak$} ],    # Array with regexpex. Files that matches
                                     # that regexp are not checked
    };

=head2 DESCRIPTION

This module is intend to solve one simple task: to make sure that your source
code don't have problems with whitespaces.

This module checks that all the rules are followed.

=over

=item * Each line ends with "\n" (including the last line)

=item * For new lines "\n" is used (not "\r\n")

=item * There are no ending spaces on the lines

=item * 4 spaces are used instead of tabs

=item * No empty lines in the end of file

=back

This module don't export any subroutines, you only need to write a test file
and write there:

    use Test::Whitespaces;

More complex usage can be found in SYNOPSIS section.

This module does not check the files that are stored in the version control
system directories (you remember, that .git, .svn and friends).

This module is shiped with 2 scripts. `L<test_whitespaces>` to easy check
files and directories and `L<whiter>` to fix all that errors.

And by the way, this module don't have any dependencies, but Perl. It does not
matter much, but it is nice =)

=head2 FAQ

Q: Why not to use perltidy instead of this module?

A: Perltidy is a great thing. It fixes some whitespaces problems in the Perl
source code. But sometimes you don't need the whole perltidy possibilities,
but only want to make your whitespaces accurate. Adding Test::Whitespaces
to the project affects less than adding perltidy. And with Test::Whitespaces
you can test and fix not only the Perl source code, but any texts. For
example, you can make sure that you javasript code has no problems with
whitespaces or you can fix your texts files.

=head1 SEE ALSO

If this module is not what you need, you may try to look to these modules (but
I hope you will prefer to use Test::Whitespaces):

=over

=item * L<Test::EOL>

=item * L<Test::NoTabs>

=item * L<Test::TrailingSpace>

=back

=head1 AUTHOR

Ivan Bessarabov, C<< <ivan@bessarabov.ru> >>

=head1 SOURCE CODE

The source code for this module and scripts is hosted on GitHub
L<https://github.com/bessarabov/Test-Whitespaces>

=cut

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

our $VERSION = '0.02';

my $true = 1;
my $false = '';

my $current_test = 0;
my $verbose = $false;
my @ignore;

sub import {
    my ($class, $args) = @_;

    if (defined $args and ref $args ne "HASH") {
        croak "Test::Whitespaces expected to recieve hashref with params. Stopped";
    }

    if (defined $args->{ignore}) {
        croak "Parameter 'ignore' shoud contain ARRAY. Stopped" if ref $args->{ignore} ne "ARRAY";

        foreach (@{$args->{ignore}}) {
            croak "Parameter 'ignore' shoud contain ARRAY with Regexp-es. Stopped" if ref $_ ne "Regexp";
            push @ignore, $_;
        }
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

sub _run_script {
    my (%args) = @_;

    if (not defined $args{dir}) {
        croak "_run_script expected to recieve param 'dir'. Stopped";
    }

    if (not defined $args{file}) {
        croak "_run_script expected to recieve param 'file'. Stopped";
    }

    if (not defined $args{script}) {
        croak "_run_script expected to recieve param 'script'. Stopped";
    }

    my @to_check;
    my $seen_two_minuses = $false;

    foreach my $argv (@{$args{argv}}) {

        if ($argv eq '--') {
            $seen_two_minuses = $true;
            next;
        }

        if (not $seen_two_minuses) {
            if ($argv eq '--help') {
                pod2usage({
                    -exitval => 0,
                });
            }

            if ($argv eq '--version') {
                print "$args{script} $VERSION\n";
                exit 0;
            }

            if ($args{script} eq 'whiter' and $argv eq '--verbose') {
                $verbose = $true;
                next;
            }
        }

        push @to_check, $argv;
    }

    unless (@to_check) {
        print "No. Run me with some parameters, please.\n";
        exit 1;
    }

    foreach my $argv (@to_check) {
        if (-d $argv) {
            $args{dir}->($argv);
        } elsif (-T $argv) {
            $args{file}->($argv);
        } else {
            print
                RED
                . "Fatal error. '$argv' is not a directory and it is not a text file.\n"
                . RESET
                ;
            exit 1;
        }
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

    open FILE, "<", $filename or croak "Can't open file '$filename': $!. Stopped";
    my @lines = <FILE>;
    close FILE;

    my $content = join '', @lines;

    return $content;
}

sub _write_file {
    my ($filename, $content) = @_;

    open FILE, ">", $filename or croak "Can't open file '$filename': $!. Stopped";
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

    croak "Expected 'got'. Stopped" if not defined $got;
    croak "Expected 'expected'. Stopped" if not defined $expected;

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
    $error_line =~ s{( +)(\n?)$}{"_" x length($1) . $2}eg;
    $error_line =~ s{\n}{\\n}g;

    my $prefix = "# L$line_number ";
    my $spacer = "...";

    my $max_length = 78;
    my $system_length = length($prefix . $spacer);
    my $max_text_length = $max_length - $system_length;

    my $line = $prefix . $error_line;

    if (length($line) > $max_length) {
        $error_line =~ /(.{$max_text_length})$/ms;
        $error_line = $1;

        $line = $prefix . $spacer . $error_line;
    }

    return $line . "\n";
}

sub _file_is_in_vcs_index {
    my ($filename) = @_;

    if (-d $filename) {
        croak "Internal error. $filename is dir. It can't happen. Stopped";
    }

    if (not -T $filename) {
        croak "Internal error. $filename is not a text file. It can't happen. Stopped";
    }

    my @vcs_dirs = qw(
        .git
        .hg
        .svn
    );

    my @parts = split "/", $filename;
    pop @parts; # last element is filename, but we need only directories

    foreach my $part (@parts) {
        foreach my $vcs (@vcs_dirs) {
            return $true if $part eq $vcs;
        }
    }

    return $false;
}

sub _check_file {
    my ($filename) = @_;

    return if not defined $filename;

    $filename = realpath($filename);

    if (-T $filename) {
        return if _file_is_in_vcs_index($filename);

        foreach my $regexp (@ignore) {
            return if $filename =~ $regexp;
        }

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

    if (-T $filename) {
        return if _file_is_in_vcs_index($filename);

        my $content = _read_file($filename);
        my $fixed_content = _get_fixed_text($content);

        if ($content ne $fixed_content) {
            _write_file($filename, $fixed_content);
            print "Repairing $filename\n" if $verbose;
        } else {
            print "File is correct $filename\n" if $verbose;
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

1;

package Test::Whitespaces::Common;

use strict;
use warnings;

use Carp;

our @ISA = qw(Exporter);
our @EXPORT = qw(
    read_file
    write_file
    get_fixed_text
);

my $true = 1;
my $false = 0;

sub read_file {
    my ($filename) = @_;

    open FILE, "<", $filename or croak "Can't open file '$filename': $!";
    my @lines = <FILE>;
    close FILE;

    my $content = join '', @lines;

    return $content;
}

sub write_file {
    my ($filename, $content) = @_;

    open FILE, ">", $filename or croak "Can't open file '$filename': $!";
    print FILE $content;
    close FILE;

    return $false;
}

sub get_fixed_text {
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

1;

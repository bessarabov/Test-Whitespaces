package Utils;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

sub convert_data_section {
    my (@lines) = @_;

    my $data;

    foreach my $line (@lines) {
        $line =~ s{\\s}{ };
        $data .= $line;
    }

    return $data;
}

1;

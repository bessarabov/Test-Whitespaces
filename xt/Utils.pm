package Utils;

use strict;
use warnings FATAL => 'all';

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

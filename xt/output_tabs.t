use strict;
use warnings;

use Test::Differences;
use File::Slurp;

use Test::More tests => 1;

sub main {
    my $data = read_file('xt/data/prove_output_tabs');

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

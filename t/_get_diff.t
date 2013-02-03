#!perl

use strict;
use warnings;

use Test::More;

use Test::Whitespaces { _only_load => 1 };

my @test_cases = (
    {
        got => "",
        expected => "\n",
        diff => "# L1\n",
    },
    {
        got => " \n",
        expected => "\n",
        diff => "# L1 _\\n\n",
    },
    {
        got => "a\tb",
        expected => "a    b\n",
        diff => "# L1 a\\tb\n",
    },
    {
        got => "a\nb \n",
        expected => "a\nb\n",
        diff => "# ...\n# L2 b_\\n\n",
    },
    {
        got => "a\nb \nc\nd",
        expected => "a\nb\nc\nd\n",
        diff => "# ...\n# L2 b_\\n\n# ...\n# L4 d\n",
    },
);

foreach (@test_cases) {
    is(
        Test::Whitespaces::_get_fixed_text($_->{got}),
        $_->{expected},
        "_get_fixed_text()",
    );
    is(
        Test::Whitespaces::_get_diff($_->{got}, $_->{expected}),
        $_->{diff},
        "_get_diff()",
    );
}

done_testing();

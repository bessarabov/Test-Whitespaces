#!perl

use strict;
use warnings;

use Test::More;
use Test::Whitespaces::Common;

my @test_cases = (
    {
        got => "",
        expected => "\n",
    },
    {
        got => "a   \n",
        expected => "a\n",
    },
    {
        got => "a   ",
        expected => "a\n",
    },
    {
        got => "a \nb ",
        expected => "a\nb\n",
    },
    {
        got => "a \nb \n",
        expected => "a\nb\n",
    },
    {
        got => "a\nb\n",
        expected => "a\nb\n",
    },
    {
        got => "a\nb\n\n",
        expected => "a\nb\n",
    },
    {
        got => "a\nb\n\n\n",
        expected => "a\nb\n",
    },
    {
        got => "a\nb\n  \n \n ",
        expected => "a\nb\n",
    },
    {
        got => "a   \r\n",
        expected => "a\n",
    },
    {
        got => "a   \r\nb   \r\n",
        expected => "a\nb\n",
    },
    {
        got => "a\t\r\n",
        expected => "a\n",
    },
    {
        got => "a\ta\r\n",
        expected => "a    a\n",
    },
);

foreach (@test_cases) {
    is(
        Test::Whitespaces::Common::get_fixed_text($_->{got}),
        $_->{expected},
        "get_fixed_text()",
    );
}

done_testing();

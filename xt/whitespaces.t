#!perl

use Test::Whitespaces {
    dirs => [ '.' ],
    ignore => [
        qr{samples_with_whitespaces_errors},
        qr{xt/data/prove_output},
    ],
};

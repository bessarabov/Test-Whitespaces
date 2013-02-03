#!perl -T

use strict;
use warnings;

use Test::CheckManifest 0.9;
ok_manifest(
    {
        filter => [
            qr{\.git/},
            qr{samples_with_whitespaces_errors/},
            qr{t_failing/},
            qr{xt/},
            qr{\.travis\.yml},
        ],
    }
);

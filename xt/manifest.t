#!perl -T

use strict;
use warnings;

use Test::CheckManifest 0.9;
ok_manifest(
    {
        filter => [
            qr{\.git/},
            qr{\.travis\.yml},
            qr{samples_with_whitespaces_errors/},
            qr{sbin\/},
            qr{t_failing/},
            qr{xt/},
        ],
    }
);

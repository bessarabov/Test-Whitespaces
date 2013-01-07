#!perl -T

use strict;
use warnings;

use Test::CheckManifest 0.9;
ok_manifest(
    {
        filter => [
            qr{\.git/},
            qr{xt/},
        ],
    }
);

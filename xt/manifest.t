#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

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

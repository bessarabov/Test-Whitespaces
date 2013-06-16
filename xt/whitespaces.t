#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Test::Whitespaces {
    dirs => [ '.' ],
    ignore => [
        qr{samples_with_whitespaces_errors},
    ],
};

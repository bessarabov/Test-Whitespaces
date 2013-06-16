#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Test::Whitespaces {
    files => [qw(
        samples_with_whitespaces_errors/tabs
    )],
};

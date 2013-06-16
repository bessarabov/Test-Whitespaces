#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

use Test::More tests => 1;

use Test::Whitespaces { _only_load => 1 };

ok(1, "Testing Test::Whitespaces $Test::Whitespaces::VERSION, Perl $], $^X" );

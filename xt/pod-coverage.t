#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Test::More;

use Test::Pod::Coverage 1.08;

all_pod_coverage_ok();

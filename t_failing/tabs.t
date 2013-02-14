#!/usr/bin/perl

use Test::Whitespaces {
    files => [qw(
        samples_with_whitespaces_errors/file_with_tabs
    )],
};

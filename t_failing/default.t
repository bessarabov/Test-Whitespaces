#!/usr/bin/perl

use Test::Whitespaces {
    dirs => [qw(
        samples_with_whitespaces_errors
    )],
    ignore => [
        qr/Bar2/,
        qr/Correct\.pm/,
        qr/file_with_tabs/,
        qr/unicode/,
    ],
};

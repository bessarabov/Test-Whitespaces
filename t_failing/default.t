use Test::Whitespaces {
    files => [qw(
        samples_with_whitespaces_errors/Bar.pm
        samples_with_whitespaces_errors/Dos.pm
        samples_with_whitespaces_errors/empty.pm
        samples_with_whitespaces_errors/Bar2.pm
        samples_with_whitespaces_errors/lines.pm
        samples_with_whitespaces_errors/Foo.pm
    )],
    ignore => [
        qr/Bar2/,
    ],
};

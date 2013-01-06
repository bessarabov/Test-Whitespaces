#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::Whitespaces' ) || print "Bail out!
";
}

diag( "Testing Test::Whitespaces $Test::Whitespaces::VERSION, Perl $], $^X" );

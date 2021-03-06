#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;
use Test::Differences;
use File::Slurp;
use Test::More tests => 1;
use Capture::Tiny qw(capture_merged);

use lib::abs qw(
    .
);
use Utils;

sub main {
    my $data = Utils::convert_data_section(<DATA>);

    my $output = capture_merged {
        system("prove -Ilib -v t_failing/default.t");
    };

    # removing chaning line:
    # Files=1, Tests=5,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.04 cusr  0.02 csys =  0.09 CPU)
    $output =~ s/Files(.*)CPU\)//ms;

    eq_or_diff(
        $output,
        $data,
        "Output is expected",
    );
}

main();
__DATA__

#\s
# ## Failed check on file 'samples_with_whitespaces_errors/Bar.pm':
#\s
# line 1: package Bar;_\n
# ...
# line 5: \tmy ($number) = @_;\n
# line 6: \t\n
# line 7: \treturn 2*$number;\n
# ...
# line 12:     my ($number) = @_;____\n
# line 13: ____\n
# line 14:     return 2*$number;_\n
# ...
# line 18: 1;_
#\s
#\s

#\s
# ## Failed check on file 'samples_with_whitespaces_errors/Dos.pm':
#\s
# line 1: package Dos;\r\n
# line 2: \r\n
# line 3: # In the sub tabs are used instead of spaces\r\n
# line 4: sub double {\r\n
# line 5: \tmy ($number) = @_;\r\n
# line 6: }\r\n
# line 7: 1;\r\n
#\s
#\s

#\s
# ## Failed check on file 'samples_with_whitespaces_errors/empty.pm':
#\s
# line 1 No \n on line
#\s
#\s

#\s
# ## Failed check on file 'samples_with_whitespaces_errors/lines.pm':
#\s
# line 1: 61 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
# line 2: 62 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
# line 3: 63 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
# line 4: ...4 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
# line 5: ... xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
# line 6: ...xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_\n
#\s
#\s

#\s
# ## Failed check on file 'samples_with_whitespaces_errors/Foo.pm':
#\s
# ...
# line 7 \n Empty line in the end of file
# line 8 \n Empty line in the end of file
#\s
#\s
t_failing/default.t ..\s
not ok 1 - samples_with_whitespaces_errors/Bar.pm
not ok 2 - samples_with_whitespaces_errors/Dos.pm
not ok 3 - samples_with_whitespaces_errors/empty.pm
not ok 4 - samples_with_whitespaces_errors/lines.pm
not ok 5 - samples_with_whitespaces_errors/Foo.pm
1..5
Failed 5/5 subtests\s

Test Summary Report
-------------------
t_failing/default.t (Wstat: 0 Tests: 5 Failed: 5)
  Failed tests:  1-5

Result: FAIL

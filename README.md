NAME
    Test::Whitespaces - test source code for errors in whitespaces

VERSION
    Version 0.03

SYNOPSIS
    In xt/whitespaces.t:

        use Test::Whitespaces {

            # Directories to check all the files from
            dirs => [ 'lib', 'bin', 't' ],

            # Files to be checekd (if you don't need to check the whole dir)
            files => [ 'README' ],

            # Files that matches any of this regexp will not be checked
            ignore => [ qr{\.bak$} ],

        };

    This test will check all the files specified. It will pretty print all
    the errors, so it is easy to undestand where is the problem.

    This modules ships with the script `whiter` that can fix all errors.

    This module is also shipeed with the script `test_whitespaces` that you
    can use to check source code without writing your custom test file.

    All parameters are optional, but you need to specify at least one file
    to check.

  DESCRIPTION
    This module is intend to solve one simple task: to make sure that your
    source code don't have problems with whitespaces.

    This module checks that all the rules are followed.

    * Each line ends with "\n" (including the last line)
    * For new lines "\n" is used (not "\r\n")
    * There are no ending spaces on the lines
    * 4 spaces are used instead of tabs
    * No empty lines in the end of file

    This module don't export any subroutines, you only need to write a test
    file and write there:

        use Test::Whitespaces { dirs => ['lib'] };

    Full description of the parameters is written in the SYNOPSIS section.

    This module does not check the files that are stored in the version
    control system directories (you remember, that .git, .svn and friends).

    This module is shiped with 2 scripts. `test_whitespaces` to easy check
    files and directories and `whiter` to fix all that errors.

    And by the way, this module don't have any dependencies, but Perl. It
    does not matter much, but it is nice =)

  FAQ
    Q: Why not to use perltidy instead of this module?

    A: Perltidy is a great thing. It fixes some whitespaces problems in the
    Perl source code. But sometimes you don't need the whole perltidy
    possibilities, but only want to make your whitespaces accurate. Adding
    Test::Whitespaces to the project affects less than adding perltidy. And
    with Test::Whitespaces you can test and fix not only the Perl source
    code, but any texts. For example, you can make sure that you javasript
    code has no problems with whitespaces or you can fix your texts files.

    Q: Why there is no default values?

    A: The idea behind this test is to make delelopers work simplier. There
    are a lot of things a developer should remember. I don't want to ask
    developers to remember the default values of this module. The person
    writing test should write the exact list of thing to check, but such
    precise writing simplifies the work of person who reads the code.

SEE ALSO
    If this module is not what you need, you may try to look to these
    modules (but I hope you will prefer to use Test::Whitespaces):

    * Test::EOL
    * Test::NoTabs
    * Test::Tabs
    * Test::TrailingSpace

AUTHOR
    Ivan Bessarabov, `<ivan@bessarabov.ru>'

SOURCE CODE
    The source code for this module and scripts is hosted on GitHub
    https://github.com/bessarabov/Test-Whitespaces

BUGS
    Please report any bugs or feature requests in GitHub Issues
    https://github.com/bessarabov/Test-Whitespaces/issues

LICENSE AND COPYRIGHT
    Copyright 2013 Ivan Bessarabov.

    This program is free software; you can redistribute it and/or modify it
    under the terms of either: the GNU General Public License as published
    by the Free Software Foundation; or the Artistic License.

    See http://dev.perl.org/licenses/ for more information.
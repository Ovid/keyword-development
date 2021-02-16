#!/usr/bin/env perl

BEGIN {
    $ENV{PERL_KEYWORD_DEVELOPMENT_MATCH} = 'TryMe\d';
}
use lib 'lib';
use Test::More;
use Keyword::DEVELOPMENT;

my $IgnoreMe = 0;
my $TryMe    = 0;
my $TryMe2   = 0;

package Ignore::Me {
    use Keyword::DEVELOPMENT;
    DEVELOPMENT {
        $IgnoreMe = 1;
        Test::More::fail("IgnoreMe DEVELOPMENT code should not be called");
    }
}

package TryMe {
    use Keyword::DEVELOPMENT;
    DEVELOPMENT {
        $TryMe = 1;
        Test::More::fail(
"TryMe package name doesn't match $ENV{PERL_KEYWORD_DEVELOPMENT_MATCH} regex"
        );
    }
}

package TryMe2 {
    use Keyword::DEVELOPMENT;
    DEVELOPMENT {
        $TryMe2 = 1;
        Test::More::pass(
"TryMe2 package name matches the $ENV{PERL_KEYWORD_DEVELOPMENT_MATCH} regex"
        );
    }
}

ok !$IgnoreMe, 'IgnoreMe me package was skipped';
ok !$TryMe,    'TryMe package was skipped';
ok $TryMe2, 'TryMe2 was not skipped';

done_testing;


#!/usr/bin/env perl

use lib 'lib';
use Test::More;

BEGIN {
    # just in case someone turned this one
    $ENV{PERL_KEYWORD_DEVELOPMENT} = 1;
    my $minimum_version = 5.020000;
    if ( $] >= $minimum_version ) {
        plan tests => 2;
    }
    else {
        plan skip_all =>
"Post-dereferencing tests only value for Perl $minimum_version and above";
    }
}
use Keyword::DEVELOPMENT;
use v5.20;
use feature qw(postderef);
no warnings qw(experimental::postderef);

my $value = 0;
my $aref = [ 1, 2, 3 ];
DEVELOPMENT {
    $value = scalar $aref->@*;
    ok 1, 'This code should be called';
}

is $value, 3, 'Our DEVELOPMENT function should be called';

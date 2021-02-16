#!/usr/bin/env perl

BEGIN {
    $ENV{PERL_KEYWORD_DEVELOPMENT} = 1;
}
use lib 'lib';
use Test::More;
use Keyword::DEVELOPMENT ();

my $success = eval {
    $ENV{PERL_KEYWORD_DEVELOPMENT_MATCH} = '[Bad)Regex';
    Keyword::DEVELOPMENT->import;
    1;
};

my $error = $@;
ok !$success, 'Trying to use Keyword::DEVELOPMENT with a bad regex should fail';
like $error,
qr/\QPERL_KEYWORD_DEVELOPMENT_MATCH environment variable '[Bad)Regex' is not a valid regex:/,
  '... and it should fail with an appropriate error message';

my $success = eval {
    $ENV{PERL_KEYWORD_DEVELOPMENT_MATCH} = '[Good]Regex';
    Keyword::DEVELOPMENT->import;
    1;
};

my $error = $@;
ok $success,
  'Trying to use Keyword::DEVELOPMENT with a good regex should succeed';
ok !$error, '... without an error message';

done_testing;

package Keyword::DEVELOPMENT;

use 5.012;    # required for pluggable keywords
use warnings;
use Keyword::Declare;

=head1 NAME

Keyword::DEVELOPMENT - Have code blocks which don't exist unless you ask for them.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Keyword::DEVELOPMENT;

    sub foo {
        my $self = shift;
        DEVELOPMENT {
            $self->expensive_debugging_code;
        }
        ...
    }

=head1 EXPORT

=head2 DEVELOPMENT

This module exports one keyword, C<DEVELOPMENT>. This keyword takes a code
block.

If the environment variable C<PERL_KEYWORD_DEVELOPMENT> is set to a true
value, the code block is executed. Otherwise, the entire block is removed at
compile-time, thus ensuring that there is no runtime overhead for the block.

This is primarily a development tool for performance-critical code.

=cut

sub import {
    keyword DEVELOPMENT( Block $block) {
        if ( $ENV{PERL_KEYWORD_DEVELOPMENT} ) {
            return $block;
        }
        else {
            return
"# PERL_KEYWORD_DEVELOPMENT was false, so the development code was removed.";
        }
    }
}

=head1 EXAMPLE

Consider the following code:

    #!/usr/bin/env perl

    BEGIN {
        # just in case someone turned this one
        $ENV{PERL_KEYWORD_DEVELOPMENT} = 1;
    }
    use lib 'lib';
    use Keyword::DEVELOPMENT;

    my $value = 0;
    DEVELOPMENT {
        sleep 10;
        $value = 1;
    }

    print "Our value is $value";

Running this code should print the following after about 10 seconds:

    Our value is 1

However, if you set C<PERL_KEYWORD_DEVELOPMENT> to C<0> in the C<BEGIN> block, it prints:

    Our value is 0

To know that we really have B<no> overhead during production, run the code under the debugger
with C<PERL_KEYWORD_DEVELOPMENT> set to C<0>.

    $ perl -d development.pl

    Loading DB routines from perl5db.pl version 1.49_04
    Editor support available.

    Enter h or 'h h' for help, or 'man perldebug' for more help.

    main::(development.pl:10):    my $value = 0;
    auto(-1)  DB<1> {{v
    DB<2> n
    main::(development.pl:10):    my $value = 0;
    auto(-1)  DB<2> v
    7:    use lib 'lib';
    8:    use Keyword::DEVELOPMENT;
    9
    10==>    my $value = 0;

    11     # PERL_KEYWORD_DEVELOPMENT was false, so the development code was removed.
    12     #KDCT:_:_:1 DEVELOPMENT
    13     #line 14 development.pl
    14
    15
    16:    print "Our value is $value";
    DB<2>

As you can see, there are only comments there, no code.

Note the handy line directive on line 13 to ensure your line numbers remain
correct. If you're not familiar with line directives, see
L<https://perldoc.perl.org/perlsyn.html#Plain-Old-Comments-(Not!)>

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid at allaroundtheworld.fr> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-keyword-assert at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Keyword-DEVELOPMENT>.  I will
be notified, and then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Keyword::DEVELOPMENT

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Keyword-DEVELOPMENT>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Keyword-DEVELOPMENT>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Keyword-DEVELOPMENT>

=item * Search CPAN

L<http://search.cpan.org/dist/Keyword-DEVELOPMENT/>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Damian Conway for the excellent C<Keyword::Declare> module.


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Curtis "Ovid" Poe.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of Keyword::DEVELOPMENT

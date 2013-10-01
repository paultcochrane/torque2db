#!/usr/bin/env perl

use warnings FATAL => 'all';
use strict;

use Test::More;
use IO::Capture::Stderr;

BEGIN {
    use_ok( 'Options' );
}

{
    my $options = Options->new();
    isa_ok( $options, 'Options' );
}

done_testing( 2 );

# vim: expandtab shiftwidth=4

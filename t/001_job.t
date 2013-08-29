#!/usr/bin/env perl

use warnings;
use strict;

use Test::More tests => 2;

BEGIN {
    use_ok( 'Job' );
}

{
    my $job = Job->new();
    isa_ok( $job, 'Job' );
}

# vim: expandtab shiftwidth=4

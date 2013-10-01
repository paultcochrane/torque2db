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

{
    my $options = Options->new();
    my $month_date_string = "08/2013";
    $options->month_date( $month_date_string );
    my $month_date = $options->month_date();
    is( $month_date, $month_date_string,
        "month_date() returns expected month/year string" );
}

done_testing( 3 );

# vim: expandtab shiftwidth=4

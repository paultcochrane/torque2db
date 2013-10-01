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

{
    my $options = Options->new();
    $options->month_date( "08/2013" );
    my $month = $options->month();
    my $expected_month = 8;
    is( $month, $expected_month,
        "month() returns expected value" );
}

{
    my $options = Options->new();
    $options->month_date( "12/2014" );
    my $month = $options->month();
    my $expected_month = 12;
    is( $month, $expected_month,
        "month() returns another expected value" );
}

done_testing( 5 );

# vim: expandtab shiftwidth=4

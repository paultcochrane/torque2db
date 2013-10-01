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
    my $month_year_string = "08/2013";
    $options->month_year( $month_year_string );
    my $month_year = $options->month_year();
    is( $month_year, $month_year_string,
        "month_year() returns expected month/year string" );
}

{
    my $options = Options->new();
    $options->month_year( "08/2013" );
    my $month = $options->month();
    my $expected_month = 8;
    is( $month, $expected_month,
        "month() returns expected value" );
}

{
    my $options = Options->new();
    $options->month_year( "12/2014" );
    my $month = $options->month();
    my $expected_month = 12;
    is( $month, $expected_month,
        "month() returns another expected value" );
}

{
    my $options = Options->new();
    $options->month_year( "01/2011" );
    my $year = $options->year();
    my $expected_year = 2011;
    is( $year, $expected_year,
        "year() returns expected value" );
}

done_testing( 6 );

# vim: expandtab shiftwidth=4

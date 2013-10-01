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
    $options->month( "08" );
    my $month = $options->month();
    my $expected_month = 8;
    ok( $month == $expected_month,
        "month() returns expected value" );
    # TODO: why does is() return 08 and 8 here?
}

{
    my $options = Options->new();
    $options->month( "12" );
    my $month = $options->month();
    my $expected_month = 12;
    is( $month, $expected_month,
        "month() returns another expected value" );
}

{
    my $options = Options->new();
    $options->year( "2011" );
    my $year = $options->year();
    my $expected_year = 2011;
    is( $year, $expected_year,
        "year() returns expected value" );
}

done_testing( 5 );

# vim: expandtab shiftwidth=4

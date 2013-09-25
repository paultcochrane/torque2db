#!/usr/bin/env perl

use warnings;
use strict;

use Test::More;
use IO::Capture::Stderr;

{
    require_ok("torque_statistics.pl");
}

{
    my $expected = 1;
    is( torque_statistics::main(), $expected,
	"main routine returns true" );
}

{
    my $expected = 1;
    is( torque_statistics::read_options(), $expected,
        "options are read without error" );
}

done_testing( 3 );

# vim: expandtab shiftwidth=4

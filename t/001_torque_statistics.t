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

done_testing( 2 );

# vim: expandtab shiftwidth=4

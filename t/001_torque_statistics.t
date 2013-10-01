#!/usr/bin/env perl

use warnings;
use strict;

use Test::More;
use IO::Capture::Stderr;

{
    require_ok("torque_statistics.pl");
}

done_testing( 1 );

# vim: expandtab shiftwidth=4

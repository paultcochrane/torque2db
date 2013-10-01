#!/usr/bin/env perl

use warnings;
use strict;

use Test::More;
use IO::Capture::Stderr;

{
    require_ok("torque_statistics.pl");
}

{
    my $output_tex_file = "torque_statistics.tex";
    unlink $output_tex_file;
    my $error = system "perl torque_statistics.pl";
    ok( $error == 0,
        "Program returns zero without options" );
    ok( -f $output_tex_file,
        "TeX file created from program run" );
}

done_testing( 3 );

# vim: expandtab shiftwidth=4

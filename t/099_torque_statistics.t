#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use autodie;

use Test::More;

{
    require_ok("torque_statistics.pl");
}

{
    my $error = system "perl torque_statistics.pl > /dev/null";
    ok( $error != 0,
        "Program returns failure without options" );
}

{
    # print usage if no options are given
    my $error_text = qx{ perl torque_statistics.pl };
    my $usage_text = "Usage:";
    like( $error_text, qr/$usage_text/,
        "Usage text printed when program run without options" );
}

{
    my $error = system "perl torque_statistics.pl --month=08";
    ok( $error == 0,
        "Program accepts --month option" );
}

{
    my $output_tex_file = "torque_statistics.tex";
    unlink $output_tex_file if -f $output_tex_file;
    my $error = system "perl torque_statistics.pl --month=08";
    ok( -f "torque_statistics.tex",
        "Program generates a TeX file" );
    unlink $output_tex_file if -f $output_tex_file;
}

{
    # does the month info come through to the report?
    my $output_tex_file = "torque_statistics.tex";
    unlink $output_tex_file if -f $output_tex_file;
    my $error = system "perl torque_statistics.pl --month=08";
    open my $fh, "<", $output_tex_file;
    my @tex_file_text = <$fh>;
    close $fh;
    my $expected_period_text = "For the period 08";
    my $got_text = join '', @tex_file_text;
    like( $got_text, qr/$expected_period_text/,
        "Expected reporting period text in TeX file" );
    unlink $output_tex_file;
}

{
    my $error = system "perl torque_statistics.pl --year=2013";
    ok( $error == 0,
        "Program accepts --year option" );
}

{
    my $error = system "perl torque_statistics.pl --month=08 --year=2013";
    ok( $error == 0,
        "Program accepts --month and --year option" );
}

done_testing( 8 );

# vim: expandtab shiftwidth=4

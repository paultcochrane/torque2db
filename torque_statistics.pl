#!/usr/bin/env perl

=head1 NAME

torque_statistics - generate cluster statistics from Torque accounting data

=head1 SYNOPSIS

torque_statistics

=head1 DESCRIPTION

Processes the data in C</var/spool/torque/server_priv/accounting> to
generate cluster usage statistics.

=head1 AUTHOR

Paul Cochrane

=head1 COPYRIGHT AND LICENSE

Copyright 2013 Paul Cochrane

This library is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package torque_statistics;

use strict;
use warnings FATAL => 'all';
use autodie;
use Getopt::Long;
use Pod::Usage;

use Options;

=over 4

=item main()

Runs the main code loop.

=cut

sub main {
    my $options = read_cmd_line_options();

    my $time_period_text;
    if ( $options->month() ) {
        $time_period_text = sprintf "period %02d/%04d", $options->month(), $options->year();
    }
    else {
        $time_period_text = sprintf "year %04d", $options->year();
    }
    my $stub_latex_text = <<"EOF";
\\documentclass{scrartcl}

\\begin{document}

\\title{Title text}
\\subtitle{For the $time_period_text}
\\author{}
\\date{Date text}

\\maketitle

\\tableofcontents

\\section{Introduction}

\\end{document}
EOF

    my $latex_fname = "torque_statistics.tex";
    open my $latex_fh, ">", $latex_fname;
    print $latex_fh $stub_latex_text;
    close $latex_fh;
}

sub read_cmd_line_options {
    my $month;
    my $year;
    my $result = GetOptions(
                            "month=s" => \$month,
                            "year=s"  => \$year,
                    );
    pod2usage(2) if not $result;
    pod2usage(1) if ( $month and not $year );
    pod2usage(1) unless ( $year );

    my $options = Options->new();
    $options->month( $month ) if $month;
    $options->year( $year );

    return $options;
}

main() unless caller();

=back

=cut

# vim: expandtab shiftwidth=4

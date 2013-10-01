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

=over 4

=item main()

Runs the main code loop.

=cut

sub main {
    my $month_date;
    my $year_date;
    my $result = GetOptions(
                            "month=s" => \$month_date,
                            "year=s"  => \$year_date,
                    );
    die "Options error" if not $result;

    my $stub_latex_text = <<'EOF';
\documentclass{scrartcl}

\begin{document}

\title{Title text}
\author{}
\date{Date text}

\maketitle

\tableofcontents

\section{Introduction}

\end{document}
EOF

    my $latex_fname = "torque_statistics.tex";
    open my $latex_fh, ">", $latex_fname;
    print $latex_fh $stub_latex_text;
    close $latex_fh;
}

main() unless caller();

=back

=cut

# vim: expandtab shiftwidth=4

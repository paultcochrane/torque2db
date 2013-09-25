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

use warnings;
use strict;
use autodie;

sub main {
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

# vim: expandtab shiftwidth=4

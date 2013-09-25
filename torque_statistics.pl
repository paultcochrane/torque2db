#!/usr/bin/env perl

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

package Options;
use strict;
use warnings FATAL => 'all';

use Moose;

=head1 NAME

Options.pm - process and contain options to torque_statistics.pl

=cut

has 'month' => (
    is => 'rw',
    isa => 'Int',
);

has 'year' => (
    is => 'rw',
    isa => 'Int',
);

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4

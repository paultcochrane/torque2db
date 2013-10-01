package Options;
use strict;
use warnings FATAL => 'all';

use Moose;

=head1 NAME

Options.pm - process and contain options to torque_statistics.pl

=cut

has 'month_date' => (
    is => 'rw',
    isa => 'Str',
);

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4

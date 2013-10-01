package Options;
use strict;
use warnings FATAL => 'all';

use Moose;

=head1 NAME

Options.pm - process and contain options to torque_statistics.pl

=cut

has 'month_year' => (
    is => 'rw',
    isa => 'Str',
);

sub month {
    my $self = shift;

    my $month_year = $self->month_year();
    my ( $month, $year ) = split '/', $month_year;
    return int $month;
}

sub year {
    my $self = shift;

    my $month_year = $self->month_year();
    my ( $month, $year ) = split '/', $month_year;
    return $year;
}

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4

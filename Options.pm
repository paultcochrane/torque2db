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

sub month {
    my $self = shift;

    my $month_date = $self->month_date();
    my ( $month, $year ) = split '/', $month_date;
    return int $month;
}

sub year {
    my $self = shift;

    my $month_date = $self->month_date();
    my ( $month, $year ) = split '/', $month_date;
    return $year;
}

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4

package User;
use strict;

# the object constructor
sub new {
    my $class = shift;
    my $self = {};
    $self->{'username'}                = undef;
    $self->{'groupname'}               = undef;
    $self->{'institute'}               = undef;
    $self->{'memory'}                  = 0;
    $self->{'virtual_memory'}          = 0;
    $self->{'allocated_tasks'}         = 0;
    $self->{'cputime'}                 = 0;
    $self->{'walltime'}                = 0;
    $self->{'npl'}                     = 0;
    $self->{'jobs'}                    = 0;
    $self->{'waittime_list'}           = ();
    bless($self, $class);
    return $self;
}

# methods to access data
# with arguments they set the value, without them they retrieve the value
sub username {
    my $self = shift;
    if (@_) { $self->{'username'} = shift }
    return $self->{'username'};
}

sub groupname {
    my $self = shift;
    if (@_) { $self->{'groupname'} = shift }
    return $self->{'groupname'};
}

sub institute {
    my $self = shift;
    if (@_) { $self->{'institute'} = shift }
    return $self->{'institute'};
}

sub add_walltime {
    my $self = shift;
    $self->{'walltime'} += shift;
}

sub walltime {
    my $self = shift;
    return $self->{'walltime'};
}

sub avg_walltime {
    my $self = shift;
    return $self->walltime/$self->jobs;
}

sub add_cputime {
    my $self = shift;
    $self->{'cputime'} += shift;
}

sub cputime {
    my $self = shift;
    return $self->{'cputime'};
}

sub avg_cputime {
    my $self = shift;
    return $self->cputime/$self->jobs;
}

sub add_memory {
    my $self = shift;
    $self->{'memory'} += shift;
}

sub memory {
    my $self = shift;
    return $self->{'memory'};
}

sub avg_memory {
    my $self = shift;
    return $self->memory/$self->jobs;
}

sub add_npl {
    my $self = shift;
    $self->{'npl'} += shift;
}

sub npl {
    my $self = shift;
    return $self->{'npl'};
}

sub add_slots {
    my $self = shift;
    $self->{'allocated_tasks'} += shift;
}

sub slots {
    my $self = shift;
    return $self->{'allocated_tasks'};
}

sub avg_slots {
    my $self = shift;
    return $self->slots/$self->jobs;
}

sub jobs {
    my $self = shift;
    return $self->{'jobs'};
}

sub add_jobs {
    my $self = shift;
    return $self->{'jobs'} += shift;
}

sub add_to_waittime_list {
    my $self = shift;
    push @{$self->{'waittime_list'}}, shift;
}

sub avg_waittime {
    my $self = shift;
    my $total_waittime = 0;
    my @waittime_list = @{$self->{'waittime_list'}};
    foreach my $time ( @waittime_list ) {
        $total_waittime += $time;
    }
    my $avg_waittime = $total_waittime/(scalar @waittime_list);
    return $avg_waittime;
}

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4:

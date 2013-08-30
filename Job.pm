package Job;
use strict;
use warnings;

use Moose;

=head1 NAME

Job.pm - handle Torque C<Job> objects

=cut

# the object constructor
sub new {
    my $class = shift;
    my $self = {};
    $self->{'jobid'}                   = undef;
    $self->{'username'}                = undef;
    $self->{'groupname'}               = undef;
    $self->{'queue'}                   = undef;
    $self->{'queue_time'}              = undef;
    $self->{'start_time'}              = undef;
    $self->{'completion_time'}         = undef;
    $self->{'required_memory'}         = undef;
    $self->{'used_memory'}             = undef;
    $self->{'used_virtual_memory'}     = undef;
    $self->{'allocated_tasks'}         = 1;
    $self->{'required_ncpus'}          = undef;
    $self->{'used_cputime'}            = undef;
    $self->{'required_walltime'}       = undef;
    $self->{'used_walltime'}           = undef;
    $self->{'allocated_hostlist'}      = undef;
    $self->{'exit_status'}             = undef;
    bless($self, $class);
    return $self;
}

=head1 DESCRIPTION

=head2 Methods

=cut

=over 4

=item jobid()

Get/set the Torque job id (only the numerical part).

=cut

has jobid => ( is => 'rw', isa => 'Int' );

=item username()

Get/set the username of the user who ran the job.

=cut

has username => ( is => 'rw' );

=item groupname()

Get/set the unix group of the user who ran the job.

=cut

sub groupname {
    my $self = shift;
    if (@_) { $self->{'groupname'} = shift }
    return $self->{'groupname'};
}

=item queue()

Get/set the queue name where the job ran.

=cut

sub queue {
    my $self = shift;
    if (@_) { $self->{'queue'} = shift }
    return $self->{'queue'};
}

=item queue_time()

Get/set when the job was queued (in seconds since the epoch).

=cut

has queue_time => ( is => 'rw', isa => 'Int' );

=item start_time()

Get/set when the job started (in seconds since the epoch).

=cut

has start_time => ( is => 'rw', isa => 'Int' );

=item completion_time()

Get/set when the job completed (in seconds since the epoch).

=cut

has completion_time => ( is => 'rw', isa => 'Int' );

=item required_memory()

Get/set how much RAM was requested for the job.

=cut

sub required_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $required_memory = $self->mem_string_to_kb($memory_string);
	$self->{'required_memory'} = $required_memory;
    }
    return $self->{'required_memory'};
}

=item used_memory()

Get/set how much RAM was actually used by the job.

=cut

sub used_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $used_memory = $self->mem_string_to_kb($memory_string);
	$self->{'used_memory'} = $used_memory;
    }
    return $self->{'used_memory'};
}

=item used_virtual_memory()

Get/set how much virtual memory was used by the job.

=cut

sub used_virtual_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $used_virtual_memory = $self->mem_string_to_kb($memory_string);
	$self->{'used_virtual_memory'} = $used_virtual_memory;
    }
    return $self->{'used_virtual_memory'};
}

=item allocated_tasks()

Get/set how many processors were allocated for the job.

=cut

sub allocated_tasks {
    my $self = shift;
    if (@_) {
	my $nodes_string = shift;

        return 1 if $nodes_string eq "";

        my ($num_nodes, $ppn) = split(/:/, $nodes_string);
        $num_nodes = (split(/=/, $num_nodes))[1];

        my $num_processes_per_node = (split(/=/, $ppn))[1] if $ppn;

	# if we have a name, then we only have one node (hopefully...)
	unless ( $num_nodes =~ m/\d+/ ) {
	    $num_nodes = 1;
	}
	$self->{'allocated_tasks'} = $num_nodes*$num_processes_per_node;
	return $self->{'allocated_tasks'};
    }
    else {
	if ( $self->{'allocated_tasks'} ) {
	    return $self->{'allocated_tasks'};
	}
	elsif ( $self->{'required_ncpus'} ) {
	    return $self->{'required_ncpus'};
	}
	else {
	    return 1;
	}
    }
}

=item slots()

Return how many processors were allocated for the job.

This is just a bit of syntax sugar.

=cut

sub slots {
    my $self = shift;
    return $self->allocated_tasks;
}

=item required_ncpus()

Get/set the requested number of CPUs if this value had been set in the job.

=cut

sub required_ncpus {
    my $self = shift;
    if (@_) { $self->{'required_ncpus'} = shift }
    return $self->{'required_ncpus'};
}

=item used_cputime()

Get/set the amount of cputime used by the job.

=cut

sub used_cputime {
    my $self = shift;
    if (@_) { $self->{'used_cputime'} = $self->time_string_to_seconds(shift) }
    return $self->{'used_cputime'};
}

=item required_walltime()

Get/set the amount of walltime requested by the job.

=cut

sub required_walltime {
    my $self = shift;
    if (@_) { $self->{'required_walltime'} = $self->time_string_to_seconds(shift) }
    return $self->{'required_walltime'};
}

=item used_walltime()

Get/set the amount of walltime used by the job.

This is the value as reported by Torque, which isn't necessarily correct.
See L<walltime()>.

=cut

sub used_walltime {
    my $self = shift;
    if (@_) { $self->{'used_walltime'} = $self->time_string_to_seconds(shift) }
    return $self->{'used_walltime'};
}

=item allocated_hostlist()

Get/set the list of hosts allocated to execute the job.

=cut

sub allocated_hostlist {
    my $self = shift;
    if (@_) { $self->{'allocated_hostlist'} = shift }
    return $self->{'allocated_hostlist'};
}

=item exit_status()

Get/set the exit status of the job as reported by Torque.

=cut

sub exit_status {
    my $self = shift;
    if (@_) { $self->{'exit_status'} = shift }
    return $self->{'exit_status'};
}

=item waittime()

Return the time the job had to wait before starting.

=cut

sub waittime {
    my $self = shift;
    my $waittime = $self->start_time - $self->queue_time;
    return $waittime;
}

=item set_data()

Process the input data and save it in the C<Job> object.

=cut

sub set_data {
    my $self = shift;
    my $job_data_line = shift;

    # first we need to split the data on semicolons
    my @job_full_info = split(/;/, $job_data_line);

    # the length of the info array has to be 4 long
    if ( scalar @job_full_info != 4 ) {
	die "Job full information array not of the correct length";
    }

    # the job id is in the third element and is the first part of the '.'
    # delimited string: "<jobid>.tclog.rrzn.uni-hannover.de"
    my $full_job_id = $job_full_info[2];
    my $job_id = (split(/\./, $full_job_id))[0];

    # set the job id
    $self->jobid($job_id);

    # the rest of the information is in the fourth element of the full job
    # information array

    # let the object know what its job data is
    $self->set_job_data($job_full_info[3]);

    # I can write this much more generally!!!
    my $username = $self->get_job_info_from_key("user");
    $self->username($username);

    my $groupname = $self->get_job_info_from_key("group");
    $self->groupname($groupname);

    my $queue = $self->get_job_info_from_key("queue");
    $self->queue($queue);

    my $queue_time = $self->get_job_info_from_key("qtime");
    $self->queue_time($queue_time);

    my $start_time = $self->get_job_info_from_key("start");
    $self->start_time($start_time);

    my $completion_time = $self->get_job_info_from_key("end");
    $self->completion_time($completion_time);

    my $allocated_hostlist = $self->get_job_info_from_key("exec_host");
    $self->allocated_hostlist($allocated_hostlist);

    # should I call this used_cputime?
    my $used_cputime = $self->get_job_info_from_key("resources_used.cput");
    $self->used_cputime($used_cputime);

    my $required_memory = $self->get_job_info_from_key("Resource_List.mem");
    $self->required_memory($required_memory) if defined $required_memory;

    my $allocated_tasks = $self->get_job_info_from_key("Resource_List.nodes");
    $self->allocated_tasks($allocated_tasks) if defined $allocated_tasks;

    my $required_ncpus = $self->get_job_info_from_key("Resource_List.ncpus");
    $self->required_ncpus($required_ncpus) if defined $required_ncpus;

    my $required_walltime = $self->get_job_info_from_key("Resource_List.walltime");
    $self->required_walltime($required_walltime) if defined $required_walltime;

    my $used_walltime = $self->get_job_info_from_key("resources_used.walltime");
    $self->used_walltime($used_walltime) if defined $used_walltime;

    my $used_memory = $self->get_job_info_from_key("resources_used.mem");
    $self->used_memory($used_memory) if defined $used_memory;

    my $used_virtual_memory = $self->get_job_info_from_key("resources_used.vmem");
    $self->used_virtual_memory($used_virtual_memory) if defined $used_virtual_memory;

    my $exit_status = $self->get_job_info_from_key("Exit_status");
    $self->exit_status($exit_status) if defined $exit_status;
}

=item walltime()

Return the walltime used by the job.

This is the number of seconds between the start time and the completion
time.

=cut

sub walltime {
    my $self = shift;
    my $walltime = $self->completion_time - $self->start_time;
    return $walltime;
}

=item print_job()

Print the keys and values of the C<Job> object to the terminal.

=cut

sub print_job {
    my $self = shift;
    for my $key ( keys %$self ) {
	print "$key: $self->{$key}\n";
    }
}

=item set_job_data()

Process the job data list and save the information into the C<Job> object.

=cut

sub set_job_data {
    my $self = shift;
    my $job_data_string = shift;
    my @job_data_array = split(/\s+/, $job_data_string);

    my %job_data;
    foreach my $element ( @job_data_array ) {
	# split on the first '='
	my @fields = split(/=/, $element);
	my ( $key, $value );
	if ( scalar @fields == 1 ) {
	    $key = $fields[0];
	    $value = $fields[1];
	}
	else {
	    $key = shift @fields;
	    $value = join('=', @fields);
	}

	$job_data{$key} = $value;
    }
    $self->{'job_data'} = \%job_data;
}

=item get_job_info_from_key()

Return the job data information from the given key.

=cut

sub get_job_info_from_key {
    my $self = shift;
    my $key = shift;

    my $data = ${$self->{'job_data'}}{$key};
    return defined $data ? $data : undef;
}

=item mem_string_to_kb()

Convert the given memory string into a value in kB.

=cut

sub mem_string_to_kb {
    my $self = shift;
    my $memory_string = shift;

    $memory_string =~ m/(\d+)(\w+)/;
    my $memory_value = $1;
    my $magnitude_string = $2;
    my $magnitude_value;
    if ( $magnitude_string eq 'kb' ) {
	$magnitude_value = 1;
    }
    elsif ( $magnitude_string eq 'mb' ) {
	$magnitude_value = 1024;
    }
    elsif ( $magnitude_string eq 'gb' ) {
	$magnitude_value = 1024*1024;
    }
    elsif ( $magnitude_string eq 'b' ) {
        $magnitude_value = 1;
    }
    else {
	warn "Job id: ", $self->jobid,
             " Unknown magnitude string: $magnitude_string.",
             " Using MB as the magnitude";
        $magnitude_value = 1024;
    }
    return $magnitude_value*$memory_value;
}

=item time_string_to_seconds()

Convert a time string (HH:MM:SS) into raw seconds.

=cut

sub time_string_to_seconds {
    my $self = shift;
    my $time_string = shift;
    # split the string on semicolons
    my ($hours, $minutes, $seconds) = split(/:/, $time_string);
    return $hours*3600 + $minutes*60 + $seconds;
}

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4:

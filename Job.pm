package Job;
use strict;

# the object constructor
sub new {
    my $class = shift;
    my $self = {};
    $self->{'jobid'}                   = undef;
    $self->{'required_nodes'}          = undef;
    $self->{'required_tasks'}          = undef;
    $self->{'username'}                = undef;
    $self->{'groupname'}               = undef;
    $self->{'queue'}                   = undef;
    $self->{'queue_time'}              = undef;
    $self->{'start_time'}              = undef;
    $self->{'completion_time'}         = undef;
    $self->{'required_memory'}         = undef;
    $self->{'used_memory'}             = undef;
    $self->{'used_virtual_memory'}     = undef;
    $self->{'allocated_tasks'}         = undef;
    $self->{'required_ncpus'}          = undef;
    $self->{'used_cputime'}            = undef;
    $self->{'required_walltime'}       = undef;
    $self->{'used_walltime'}           = undef;
    $self->{'allocated_hostlist'}      = undef;
    $self->{'exit_status'}             = undef;
    bless($self, $class);
    return $self;
}

# methods to access data
# with arguments they set the value, without them they retrieve the value
sub jobid {
    my $self = shift;
    if (@_) { $self->{'jobid'} = shift }
    return $self->{'jobid'};
}

sub required_nodes {
    my $self = shift;
    if (@_) { $self->{'required_nodes'} = shift }
    return $self->{'required_nodes'};
}

sub required_tasks {
    my $self = shift;
    if (@_) { $self->{'required_tasks'} = shift }
    return $self->{'required_tasks'};
}

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

sub queue {
    my $self = shift;
    if (@_) { $self->{'queue'} = shift }
    return $self->{'queue'};
}

sub queue_time {
    my $self = shift;
    if (@_) { $self->{'queue_time'} = shift }
    return $self->{'queue_time'};
}

sub start_time {
    my $self = shift;
    if (@_) { $self->{'start_time'} = shift }
    return $self->{'start_time'};
}

sub completion_time {
    my $self = shift;
    if (@_) { $self->{'completion_time'} = shift }
    return $self->{'completion_time'};
}

sub required_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $required_memory = $self->mem_string_to_kb($memory_string);
	$self->{'required_memory'} = $required_memory;
    }
    return $self->{'required_memory'};
}

sub used_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $used_memory = $self->mem_string_to_kb($memory_string);
	$self->{'used_memory'} = $used_memory;
    }
    return $self->{'used_memory'};
}

sub used_virtual_memory {
    my $self = shift;
    if (@_) {
	my $memory_string = shift;
	my $used_virtual_memory = $self->mem_string_to_kb($memory_string);
	$self->{'used_virtual_memory'} = $used_virtual_memory;
    }
    return $self->{'used_virtual_memory'};
}

sub allocated_tasks {
    my $self = shift;
    if (@_) {
	my $nodes_string = shift;
        my ($num_nodes, $ppn) = split(/:/, $nodes_string);

        my $num_processes_per_node = (split(/=/, $ppn))[1] if $ppn;

	# if we have a name, then we only have one node (hopefully...)
	if ( $num_nodes =~ m/\w+/ ) {
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

sub slots {
    my $self = shift;
    return $self->allocated_tasks;
}

sub npl {
    my $self = shift;
    return $self->walltime * $self->slots;
}

sub required_ncpus {
    my $self = shift;
    if (@_) { $self->{'required_ncpus'} = shift }
    return $self->{'required_ncpus'};
}

sub used_cputime {
    my $self = shift;
    if (@_) { $self->{'used_cputime'} = $self->time_string_to_seconds(shift) }
    return $self->{'used_cputime'};
}

sub required_walltime {
    my $self = shift;
    if (@_) { $self->{'required_walltime'} = $self->time_string_to_seconds(shift) }
    return $self->{'required_walltime'};
}

sub used_walltime {
    my $self = shift;
    if (@_) { $self->{'used_walltime'} = $self->time_string_to_seconds(shift) }
    return $self->{'used_walltime'};
}

sub allocated_hostlist {
    my $self = shift;
    if (@_) { $self->{'allocated_hostlist'} = shift }
    return $self->{'allocated_hostlist'};
}

sub exit_status {
    my $self = shift;
    if (@_) { $self->{'exit_status'} = shift }
    return $self->{'exit_status'};
}

sub waittime {
    my $self = shift;
    my $waittime = $self->start_time - $self->queue_time;
    return $waittime;
}

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

sub walltime {
    my $self = shift;
    my $walltime = $self->completion_time - $self->start_time;
    return $walltime;
}

sub print_job {
    my $self = shift;
    for my $key ( keys %$self ) {
	print "$key: $self->{$key}\n";
    }
}

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

sub get_job_info_from_key {
    my $self = shift;
    my $key = shift;

    my $data = ${$self->{'job_data'}}{$key};
    return defined $data ? $data : undef;
}

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

sub time_string_to_seconds {
    my $self = shift;
    my $time_string = shift;
    # split the string on semicolons
    my ($hours, $minutes, $seconds) = split(/:/, $time_string);
    return $hours*3600 + $minutes*60 + $seconds;
}

1;   # so the require or use succeeds

# vim: expandtab shiftwidth=4:

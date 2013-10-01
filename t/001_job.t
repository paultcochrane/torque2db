#!/usr/bin/env perl

use warnings FATAL => 'all';
use strict;

use Test::More;
use IO::Capture::Stderr;

BEGIN {
    use_ok( 'Job' );
}

{
    my $job = Job->new();
    isa_ok( $job, 'Job' );
}

{
    my $job = Job->new();
    is( $job->jobid, undef, "Job ID is undef after new" );
    $job->jobid(01234);
    is( $job->jobid, 01234, "Job ID set correctly" );

    eval { $job->jobid("moo") };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to a job ID should fail" );

    eval { $job->jobid( 37.2452 ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a float to a job ID should fail" );
}

{
    my $job = Job->new();
    is( $job->username, undef, "Username is undef after new" );
    $job->username( "barry" );
    is( $job->username, "barry", "Username set correctly" );
}

{
    my $job = Job->new();
    is( $job->groupname, undef, "Groupname is undef after new" );
    $job->groupname( "zzzz" );
    is( $job->groupname, "zzzz", "Groupname set correctly" );
}

{
    my $job = Job->new();
    is( $job->queue, undef, "Queue name is undef after new" );
    $job->queue( "all" );
    is( $job->queue, "all", "Queue name set correctly" );
}

{
    my $job = Job->new();
    is( $job->queue_time, undef, "Queue time is undef after new" );
    $job->queue_time( 8768768 );
    is( $job->queue_time, 8768768, "Queue time set correctly" );

    eval { $job->queue_time("moo") };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to a queue time should fail" );

    eval { $job->queue_time( 1.466 ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a float to a queue time should fail" );
}

{
    my $job = Job->new();
    is( $job->start_time, undef, "Start time is undef after new" );
    $job->start_time( 976876 );
    is( $job->start_time, 976876, "Start time set correctly" );

    eval { $job->start_time("blah") };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to a start time should fail" );

    eval { $job->start_time( 0.145 ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a float to a start time should fail" );
}

{
    my $job = Job->new();
    is( $job->completion_time, undef, "Completion time is undef after new" );
    $job->completion_time( 976876 );
    is( $job->completion_time, 976876, "Completion time set correctly" );

    eval { $job->completion_time( "blah" ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to a completion time should fail" );

    eval { $job->completion_time( 0.145 ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a float to a completion time should fail" );
}

{
    my $job = Job->new();
    is( $job->required_memory, undef, "Required memory is undef after new" );

    $job->required_memory( "1245kb" );
    is( $job->required_memory, 1245,
        "Megabyte required memory correctly set" );

    $job->required_memory( "105mb" );
    is( $job->required_memory, 105*1024,
        "Megabyte required memory correctly set" );

    $job->required_memory( "3gb" );
    is( $job->required_memory, 3*1024*1024,
        "Gigabyte required memory correctly set" );
}

{
    my $job = Job->new();
    is( $job->used_memory, undef, "Used memory is undef after new" );

    $job->used_memory( "1245kb" );
    is( $job->used_memory, 1245,
        "Megabyte used memory correctly set" );

    $job->used_memory( "105mb" );
    is( $job->used_memory, 105*1024,
        "Megabyte used memory correctly set" );

    $job->used_memory( "3gb" );
    is( $job->used_memory, 3*1024*1024,
        "Gigabyte used memory correctly set" );
}

{
    my $job = Job->new();
    is( $job->used_virtual_memory, undef, "Used virtual memory is undef after new" );

    $job->used_virtual_memory( "1245kb" );
    is( $job->used_virtual_memory, 1245,
        "Megabyte used virtual memory correctly set" );

    $job->used_virtual_memory( "105mb" );
    is( $job->used_virtual_memory, 105*1024,
        "Megabyte used virtual memory correctly set" );

    $job->used_virtual_memory( "3gb" );
    is( $job->used_virtual_memory, 3*1024*1024,
        "Gigabyte used virtual memory correctly set" );
}

{
    my $job = Job->new();
    is( $job->allocated_tasks, 1, "Allocated tasks value returns 1 after new" );

    $job->allocated_tasks( "" );
    is( $job->allocated_tasks, 1,
        "Allocated tasks returns 1 with empty string" );

    $job->allocated_tasks( "1:ppn=1" );
    is( $job->allocated_tasks, 1,
        "Allocated tasks correct when nodes=1:ppn=1" );

    $job->allocated_tasks( "1:ppn=4" );
    is( $job->allocated_tasks, 4,
        "Allocated tasks correct when nodes=1:ppn=4" );

    $job->allocated_tasks( "2:ppn=6" );
    is( $job->allocated_tasks, 12,
        "Allocated tasks correct when nodes=2:ppn=6" );

    $job->allocated_tasks( "tane-n001:ppn=6" );
    is( $job->allocated_tasks, 6,
        "Allocated tasks correct when nodes=tane-n001:ppn=6" );
}

{
    my $job = Job->new();
    is( $job->slots, 1, "Slots value returns 1 after new" );

    $job->allocated_tasks( "1:ppn=1" );
    is( $job->slots, 1, "Slots value correct for nodes=1:ppn=1" );

    $job->allocated_tasks( "2:ppn=6" );
    is( $job->slots, 12, "Slots value correct when nodes=2:ppn=6" );

    $job->allocated_tasks( "tane-n001:ppn=6" );
    is( $job->slots, 6, "Slots value correct when nodes=tane-n001:ppn=6" );
}

{
    my $job = Job->new();
    is( $job->required_ncpus, undef, "Required ncpus undef after new" );

    $job->required_ncpus( 20 );
    is( $job->required_ncpus, 20,
        "Returned corrected required ncpus value");

    eval { $job->required_ncpus( "blah" ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to required_ncpus should fail" );
}

{
    my $job = Job->new();
    is( $job->used_cputime, undef, "Used cputime undef after new" );

    $job->used_cputime( "10:20:30" );
    is( $job->used_cputime, 10*3600 + 20*60 + 30,
        "Correct used cputime" );
}

{
    my $job = Job->new();
    is( $job->required_walltime, undef,
        "Required walltime undef after new" );

    $job->required_walltime( "15:27:39" );
    is( $job->required_walltime, 15*3600 + 27*60 + 39,
        "Correct required walltime" );
}

{
    my $job = Job->new();
    is( $job->used_walltime, undef,
        "Used walltime undef after new" );

    $job->used_walltime( "00:22:13" );
    is( $job->used_walltime, 0*3600 + 22*60 + 13,
        "Correct used walltime" );
}

{
    my $job = Job->new();
    is( $job->allocated_hostlist, undef,
        "Allocated hostlist undef after new" );

    my $hostlist = "tane-n001/2";
    $job->allocated_hostlist( $hostlist );
    is( $job->allocated_hostlist, $hostlist,
        "Correct hostlist returned for allocated_hostlist" );
}

{
    my $job = Job->new();
    is( $job->exit_status, undef,
        "Exit status undef after new" );

    $job->exit_status( 25 );
    is( $job->exit_status, 25,
        "Correct value returned for exit_status" );

    eval { $job->exit_status( "baa" ) };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to an exit status should fail" );
}

{
    my $job = Job->new();
    $job->start_time( 20 );
    $job->queue_time( 17 );
    is( $job->waittime, 3, "Got correct wait time" );
}

{
    my $job = Job->new();
    $job->start_time( 253 );
    $job->completion_time( 8673 );
    is( $job->walltime, 8673-253, "Got correct walltime" );
}

{
    my $job = Job->new();
    $job->jobid( 1234 );
    is( $job->mem_string_to_kb( "153kb" ), 153,
        "Kilobyte mem string correctly converted" );
    is( $job->mem_string_to_kb( "459mb" ), 459*1024,
        "Megabyte mem string correctly converted" );
    is( $job->mem_string_to_kb( "16gb" ), 16*1024*1024,
        "Gigabyte mem string correctly converted" );
    is( $job->mem_string_to_kb( "516b" ), 516,
        "B mem string correctly converted" );
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    is( $job->mem_string_to_kb( "324m" ), 324*1024,
        "Correct memory value when magnitude string unknown");
    $capture->stop();
}

{
    my $job = Job->new();
    is( $job->time_string_to_seconds( "12:34:56" ),
        12*3600 + 34*60 + 56,
        "Time string to seconds conversion" );
}

{
    my $job = Job->new();
    my $job_data_string = 'user=bazza group=users jobname=cf queue=all ctime=1376909191 qtime=1376909192 etime=1376909192 start=1376909192 owner=bazza@moo.baa.de exec_host=smp-n010/27 Resource_List.mem=20gb Resource_List.neednodes=1:ppn=1 Resource_List.nodect=1 Resource_List.nodes=1:ppn=1 Resource_List.walltime=12:00:00 session=32266 end=1376909829 Exit_status=0 resources_used.cput=00:10:03 resources_used.mem=750268kb resources_used.vmem=955460kb resources_used.walltime=00:10:37';
    $job->set_job_data( $job_data_string );
    ok( exists $job->{job_data}, "Job data saved in object" );
    is( $job->{job_data}{Exit_status}, 0,
        "Exit status in job data" );
    is( $job->{job_data}{'Resource_List.mem'}, '20gb',
        "Requested mem in job data" );
    is( $job->{job_data}{'Resource_List.nodes'}, '1:ppn=1',
        "Requested nodes in job data" );
    is( $job->{job_data}{'Resource_List.walltime'}, "12:00:00",
        "Requested walltime in job data" );
    is( $job->{job_data}{end}, 1376909829,
        "End time in job data" );
    is( $job->{job_data}{exec_host}, "smp-n010/27",
        "Exec host list in job data" );
    is( $job->{job_data}{group}, 'users',
        "Group name in job data" );
    is( $job->{job_data}{jobname}, 'cf',
        "Job name in job data" );
    is( $job->{job_data}{owner}, 'bazza@moo.baa.de',
        "User email address in job data" );
    is( $job->{job_data}{qtime}, 1376909192,
        "Queue time in job data" );
    is( $job->{job_data}{queue}, 'all',
        "Queue name in job data" );
    is( $job->{job_data}{'resources_used.cput'}, '00:10:03',
        "Used cpu time in job data" );
    is( $job->{job_data}{'resources_used.mem'}, '750268kb',
        "Used memory in job data" );
    is( $job->{job_data}{'resources_used.vmem'}, '955460kb',
        "Used virtual memory in job data" );
    is( $job->{job_data}{'resources_used.walltime'}, "00:10:37",
        "Used walltime in job data" );
    is( $job->{job_data}{start}, 1376909192,
        "Start time in job data" );
    is( $job->{job_data}{user}, "bazza",
        "User name in job data" );

    
    is( $job->get_job_info_from_key( 'username' ), undef,
        "Undef from unknown key in job info" );
    is( $job->get_job_info_from_key( 'user' ), "bazza",
        "Username from key in job info" );
    is( $job->get_job_info_from_key( 'start' ), 1376909192,
        "Start time from key in job info" );
}

{
    my $job = Job->new();
    my $job_data_line = '08/19/2013 12:57:09;E;967627.batch.server.de;user=bazza group=users jobname=cf queue=all ctime=1376909191 qtime=1376909192 etime=1376909192 start=1376909192 owner=bazza@moo.baa.de exec_host=smp-n010/27 Resource_List.mem=20gb Resource_List.neednodes=1:ppn=1 Resource_List.nodect=1 Resource_List.nodes=1:ppn=1 Resource_List.walltime=12:00:00 session=32266 end=1376909829 Exit_status=0 resources_used.cput=00:10:03 resources_used.mem=750268kb resources_used.vmem=955460kb resources_used.walltime=00:10:37';
    $job->set_data( $job_data_line );

    is( $job->jobid, 967627, "Job id from job data line" );
    is( $job->username, "bazza", "Username from job data line" );
    is( $job->groupname, "users", "Group name from job data line" );
    is( $job->queue, "all", "Queue name from job data line" );
    is( $job->queue_time, 1376909192, "Queue time from job data line" );
    is( $job->start_time, 1376909192, "Start time from job data line" );
    is( $job->completion_time, 1376909829, "End time from job data line" );
    is( $job->required_memory, 20*1024*1024, "Required memory from job data line" );
    is( $job->used_memory, 750268, "Used memory from job data line" );
    is( $job->used_virtual_memory, 955460, "Used virtual memory from job data line" );
    is( $job->allocated_tasks, 1, "Allocated tasks from job data line" );
    is( $job->required_walltime, 12*60*60, "Required walltime from job data line" );
    is( $job->used_walltime, 637, "Required walltime from job data line" );
    is( $job->allocated_hostlist, "smp-n010/27", "Allocated hostlist from job data line" );
    is( $job->exit_status, 0, "Exit status from job data line" );
}

done_testing( 104 );

# vim: expandtab shiftwidth=4

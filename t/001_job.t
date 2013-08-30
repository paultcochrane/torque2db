#!/usr/bin/env perl

use warnings;
use strict;

use Test::More;

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

done_testing( 36 );

# vim: expandtab shiftwidth=4

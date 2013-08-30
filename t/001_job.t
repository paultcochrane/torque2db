#!/usr/bin/env perl

use warnings;
use strict;

use Test::More tests => 17;

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
}

{
    my $job = Job->new();
    is( $job->start_time, undef, "Start time is undef after new" );
    $job->start_time( 976876 );
    is( $job->start_time, 976876, "Start time set correctly" );
    eval { $job->start_time("blah") };
    like( $@, qr/Validation failed for 'Int'/,
        "Setting a string to a start time should fail" );
}

# vim: expandtab shiftwidth=4

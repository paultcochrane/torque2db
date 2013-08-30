#!/usr/bin/env perl

use warnings;
use strict;

use Test::More tests => 11;

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
    like( $@, qr/Validation failed for 'Int'/, "Setting a string to a job ID should fail" );
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

# vim: expandtab shiftwidth=4

#!/usr/bin/env perl

=head1 NAME

torque2db - save Torque (PBS) accounting data into a database

=cut

use warnings;
use strict;
use autodie;

use Job;
use User;

my $accounting_file = "20130819";

# read in the accounting data for the given file
open my $fh, "<", $accounting_file;
my @raw_accounting_data = <$fh>;
close $fh;

# strip out lines which don't contain ';E;'
# i.e. lines which don't record an executed job
my @executed_job_data = grep(m/;E;/, @raw_accounting_data);

# for each job, extract the relevant information
my %jobs;
for my $line ( @executed_job_data ) {
    my $job = Job->new();
    $job->set_data($line);

    # add job information to main jobs hash
    $jobs{$job->jobid} = $job;
}

print scalar keys ( %jobs ), "\n";

# vim: expandtab shiftwidth=4

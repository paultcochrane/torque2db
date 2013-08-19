#!/usr/bin/env perl

=head1 NAME

torque2db - save Torque (PBS) accounting data into a database

=head1 SYNOPSIS

torque2db

=head1 DESCRIPTION

Processes the data in C</var/spool/torque/server_priv/accounting> and saves
this information into an SQLite database for further processing with other
tools.

=head2 Data Description

Here is the meaning of the fields in the database

=over 4

=item jobid                Job ID

=item username             Username

=item groupname            User group

=item queue                Queue name

=item queue_time           Job queue time (in seconds since epoch)

=item start_time           Job start time (in seconds since epoch)

=item completion_time      Job end time   (in seconds since epoch)

=item allocated_hostlist   Where the job executed (as a string)

=item used_cputime         CPU time used by job

=item allocated_tasks      How many processors were allocated to the job

=item required_walltime    How much walltime was requested (seconds)

=item used_walltime        Walltime actually used (seconds)

=item required_memory      RAM requested by job (kB)

=item used_memory          RAM used by the job (kB)

=item used_virtual_memory  Virtual memory used by the job (kB)

=item exit_status          Torque exit status

=back

=head1 AUTHOR

Paul Cochrane

=head1 COPYRIGHT AND LICENSE

Copyright 2013 Paul Cochrane

This library is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use warnings;
use strict;
use autodie;

use DBI;
use Job;

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

my $dbfile = 'torque.db';      # your database file
my $dbh = DBI->connect(        # connect to your database, create if needed
        "dbi:SQLite:dbname=$dbfile", # DSN: dbi, driver, database file
        "",                          # no user
        "",                          # no password
        { RaiseError => 1,           # complain if something goes wrong
          AutoCommit => 1,           # commit changes to db automatically
        },
                ) or die $DBI::errstr;

# create the table if it doesn't already exist
my $table = 'jobs';
my $create_table_string = <<"EOD";
create table if not exists $table ( id INT PRIMARY KEY,
                      username TEXT,
                      groupname TEXT,
                      queue TEXT,
                      queue_time INT,
                      start_time INT,
                      completion_time INT,
                      allocated_hostlist TEXT,
                      used_cputime INT,
                      allocated_tasks INT,
                      required_walltime INT,
                      used_walltime INT,
                      required_memory INT,
                      used_memory INT,
                      used_virtual_memory INT,
                      exit_status INT
                    )
EOD

$dbh->do($create_table_string) or die $DBI::errstr;

$dbh->disconnect();

# vim: expandtab shiftwidth=4

#!/usr/bin/env perl

=head1 NAME

torque2db - save Torque (PBS) accounting data into a database

=cut

use warnings;
use strict;
use autodie;

use DBI;

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

my $dbfile = 'torque.db';      # your database file
my $dbh = DBI->connect(        # connect to your database, create if needed
        "dbi:SQLite:dbname=$dbfile", # DSN: dbi, driver, database file
        "",                          # no user
        "",                          # no password
        { RaiseError => 1,           # complain if something goes wrong
          AutoCommit => 1,           # commit changes to db automatically
        },
                ) or die $DBI::errstr;

my $table = 'jobs';
my @rows  = qw(jobid user ugroup queue queue_time start_time completion_time
                exec_host used_cputime required_memory allocated_tasks
                required_ncpus required_walltime used_memory
                used_virtual_memory exit_status);

# here is the meaning of the fields in the db
# jobid               Job ID
# user                Username
# ugroup              User group
# queue               Queue name
# queue_time          Job queue time (in seconds since epoch)
# start_time          Job start time (in seconds since epoch)
# completion_time     Job end time   (in seconds since epoch)
# exec_host           Where the job executed (as a string)
# used_cputime        CPU time used by job
# allocated_tasks     How many processors were allocated to the job
# required_walltime   How much walltime was requested (seconds)
# used_walltime       Walltime actually used (seconds)
# required_memory     RAM requested by job (kB)
# used_memory         RAM used by the job (kB)
# used_virtual_memory Virtual memory used by the job (kB)
# exit_status         Torque exit status

# create the table if it doesn't already exist
my $create_table_string = <<"EOD";
create table if not exists $table ( id INT PRIMARY KEY,
                      user TEXT,
                      ugroup TEXT,
                      queue TEXT,
                      queue_time INT,
                      start_time INT,
                      completion_time INT,
                      exec_host TEXT,
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

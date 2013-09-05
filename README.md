`torque2db` is a simple program to process Torque (PBS -- Portable Batch
System) accounting files and save the job data for executed jobs into an
SQLite database.  It might not be fast, but it does the job.

Required packages
-----------------

Debian:
    sudo aptitude install \
	libdbi-perl\
	libclass-dbi-sqlite-perl\
	libmoose-perl\
	libio-capture-perl\
	sqlite3

Red Hat:
    sudo yum install\
	perl-DBI\
	perl-Class-DBI-SQLite\
	perl-Moose\
	perl-IO-Capture\
	sqlite

Usage
-----

Process all relevant files in `/var/spool/torque/server_priv/accounting`:

    perl torque2db.pl

Process from a given start date:

    perl torque2db.pl --start YYYYMMDD

Process in a given date range:

    perl torque2db.pl --start YYYYMMDD --end YYYYMMDD

Show a bit more information while processing

    perl torque2db.pl --verbose

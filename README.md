`torque_statistics` is a simple program to process Torque (PBS -- Portable Batch
System) accounting files and generate cluster usage statistics.

Required packages
-----------------

Debian:

    sudo aptitude install \
	libmoose-perl\
	libio-capture-perl

Red Hat:

    sudo yum install\
	perl-Moose\
	perl-IO-Capture

Usage
-----

Process all relevant files in `/var/spool/torque/server_priv/accounting`:

    perl torque_statistics.pl

Process from a given start date:

    perl torque_statistics.pl --start YYYYMMDD

Process in a given date range:

    perl torque_statistics.pl --start YYYYMMDD --end YYYYMMDD

Show a bit more information while processing

    perl torque_statistics.pl --verbose

`torque2db` is a simple program to process Torque (PBS -- Portable Batch
System) accounting files and save the job data for executed jobs into an
SQLite database.  It might not be fast, but it does the job.

Required packages
-----------------

    sudo aptitude install libdbi-perl libclass-dbi-sqlite-perl sqlite3

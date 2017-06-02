#!/bin/bash
runuser -l postgres -c '/usr/pgsql-9.6/bin/pg_dump -U postgres -f /var/lib/pgsql/9.6/pgbackup/pgdb-$(/bin/date +%y-%m-%d.%H%M).sql mani'

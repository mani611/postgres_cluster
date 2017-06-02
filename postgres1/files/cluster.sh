#!/bin/bash
pcs cluster cib pgsql_cfg
pcs -f pgsql_cfg property set no-quorum-policy="ignore"
pcs -f pgsql_cfg property set stonith-enabled="false"
pcs -f pgsql_cfg resource defaults resource-stickiness="INFINITY"
pcs -f pgsql_cfg resource defaults migration-threshold="1"
pcs -f pgsql_cfg resource create vip-master IPaddr2 ip="192.168.122.100" nic="eth1" cidr_netmask="24" op start   timeout="60s" interval="0s"  on-fail="restart" op monitor timeout="60s" interval="10s" on-fail="restart" op stop    timeout="60s" interval="0s"  on-fail="block"
pcs -f pgsql_cfg resource create pgsql pgsql pgctl="/usr/pgsql-9.6/bin/pg_ctl" psql="/usr/bin/psql" pgdata="/var/lib/pgsql/9.6/data/" rep_mode="sync" node_list="post1 post2" restore_command="cp /var/lib/pgsql/9.6/pg_archive/%f %p" primary_conninfo_opt="keepalives_idle=60 keepalives_interval=5 keepalives_count=5" master_ip="192.168.122.100" restart_on_promote='true' op start   timeout="60s" interval="0s"  on-fail="restart" op monitor timeout="60s" interval="4s" on-fail="restart" op monitor timeout="60s" interval="3s"  on-fail="restart" role="Master" op promote timeout="60s" interval="0s"  on-fail="restart" op demote  timeout="60s" interval="0s"  on-fail="stop" op stop    timeout="60s" interval="0s"  on-fail="block" op notify  timeout="60s" interval="0s"
pcs -f pgsql_cfg resource master msPostgresql pgsql master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
pcs -f pgsql_cfg resource group add master-group vip-master
pcs -f pgsql_cfg constraint colocation add master-group with Master msPostgresql INFINITY
pcs -f pgsql_cfg constraint order promote msPostgresql then start master-group symmetrical=false score=INFINITY
pcs -f pgsql_cfg constraint order demote  msPostgresql then stop  master-group symmetrical=false score=0
pcs cluster cib-push pgsql_cfg
sleep 60
pcs resource cleanup pgsql

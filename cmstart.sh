#!/bin/bash
rm /var/run/cloudera-scm-server.pid
/etc/init.d/cloudera-scm-server-db start
/etc/init.d/cloudera-scm-server start
while true; do sleep 100; done

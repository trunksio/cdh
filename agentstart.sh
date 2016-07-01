#!/bin/bash
rm /var/run/cloudera-scm-agent.pid
/etc/init.d/cloudera-scm-agent start
while true; do sleep 100; done

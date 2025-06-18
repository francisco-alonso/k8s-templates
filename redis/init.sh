#!/bin/bash
#It looks at the hostname for the Pod and determines whether this is the master or a slave, and launches Redis with the appropriate configuration.
if [[ ${HOSTNAME} == 'redis-0' ]]; then
    redis-server /redis-config/master.conf
else
    redis-server /redis-config/slave.conf
fi
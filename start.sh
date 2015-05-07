#!/bin/bash -x
sleep 1
service nginx start
sleep 1
/usr/sbin/in.tftpd -l --permissive /nbi
#cd /bsdpy
#./bsdpserver.py -i ${DOCKER_BSDPY_IFACE} -r ${DOCKER_BSDPY_PROTO} -p ${DOCKER_BSDPY_PATH} &
#sleep 2
#tail -f /var/log/nginx-error.log
/usr/bin/env python /bsdpy/bsdpserver.py &

tail -f /var/log/bsdpserver.log
#!/bin/bash
sleep 2
service nginx start
sleep 2
/usr/sbin/in.tftpd -l --permissive /nbi
#cd /bsdpy
#./bsdpserver.py -i ${DOCKER_BSDPY_IFACE} -r ${DOCKER_BSDPY_PROTO} -p ${DOCKER_BSDPY_PATH} &
#sleep 2
tail -f /var/log/nginx-error.log
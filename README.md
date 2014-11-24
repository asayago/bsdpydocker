# This is my tweaked Docker file for BSDPy from Pepijn Bruienne

The idea here is to simplify and reduce the size and amount of layers of the Docker image.
Using Debian Wheezy provides the smallest base image possible whilst still maintaining the required
tools to provide NetBoot services.
NetBoot is served over HTTP using NginX, the nginx.conf file has been tweaked to suit a 2 core CPU system (worker_processes = 2)
other tweaks have been included that are designed to increase performance of nginx when it is serving large files. 
output buffers increased and sendfile off, keepalive times increased ect
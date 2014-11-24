# Dockerfile for BSDPy
# Hopefully a much smaller image
# Taken from Pepijn Bruienne's work


# Start from Ubuntu 14.04
FROM ubuntu:14.04

MAINTAINER Calum Hunter (calum.h@gmail.com)

# Add the packages we need from apt then remove the cached list saving some disk space
RUN apt-get -y update && \
	apt-get install -y git-core \
		libxml2-dev \
		curl \
		python \
		python-dev \
		python-pip \
		nginx \
		tftpd-hpa && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/*

# Download the bsdpserver and pydhcp code from the githubs, and install
RUN git clone https://bitbucket.org/bruienne/bsdpy.git -b dev && \
	git clone https://github.com/bruienne/pydhcplib.git && \
	cd /pydhcplib; python setup.py install && \
	pip install docopt && \
	mkdir /nbi

# Add the configuration file for NginX and the start script for bsdpyserver
ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /start.sh

# Ensure permissions are setup correctly
RUN chown -R root:root /etc/nginx/nginx.conf && \
	chown -R root:root /start.sh && \
	chmod +x /start.sh

# Expose our ports to the world
EXPOSE 67/udp
EXPOSE 68/udp
EXPOSE 80

# Set the default variables as environmentals
ENV DOCKER_BSDPY_IFACE eth0
ENV DOCKER_BSDPY_PROTO http
ENV DOCKER_BSDPY_PATH /nbi

ENTRYPOINT ["/start.sh"]

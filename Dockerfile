# Dockerfile for BSDPy
# Hopefully a much smaller image

FROM ubuntu:14.04

MAINTAINER Calum Hunter (calum.h@gmail.com)

RUN apt-get -y update
RUN apt-get install -y curl
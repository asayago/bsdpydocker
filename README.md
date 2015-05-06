# BSDPy NetBoot Server in a container


## Background

This Docker container runs [BSDPy] (https://bitbucket.org/bruienne/bsdpy)

Originally developed by Pepijn Bruienne, who also has a dockerised version of [BSDPy available](https://registry.hub.docker.com/u/macadmins/bsdpy/)

My version of this Dockerised BSDPy makes a few changes. Most notably I am using Debian Wheezy as a base instead of a full Ubuntu image.
This makes the docker image much smaller, approx 300Mb
I have also tweaked the NginX (the process that serves the NetBoot image) configuration to suit a 2 core CPU System (worker_processes = 2 )
I have made a few other tweaks that are designed to increase performance of NginX when it is serving large static files.
ie. output buffers increased and sendfile off, keepalive times increased ect ect.
Have a look at the [build source](https://bitbucket.org/hunty1er/bsdpydocker/src) for more information

## Getting it on to your machine

I will assume that you already have a linux host with docker installed. If not, then please follow the [installation guides](http://docs.docker.com/installation/#installation)

Once you have Docker installed you can simply pull down the BSDPy Docker image buy running the following command:

    docker pull hunty1/bsdpydocker

## Setup

The first thing we need to do is create a location on the filesystem of your linux host that will store your NetBoot Images.

I generally just create a folder at /nbi and give it 755 permissions.

I then upload my NetBootImage.nbi file to this folder, you could do this via SMB or simply scp. Thats up to you.

Once your have your NetBoot image on your machine, you now just need to run the container

    docker run --restart=always -d -v /nbi:/nbi -p 0.0.0.0:69:69/udp -p 0.0.0.0:67:67/udp -p 0.0.0.0:80:80 -e DOCKER_BSDPY_IP=YourLinuxServerIP --name netboot_server hunty1/bsdpydocker

## Breakdown of options and settings

So there is a lot of options and arguments in the above command. Let me break them down for you.

** docker run **

    docker run --restart=always -d

Basically the above is saying go ahead and run a docker image, if the container exits, like if the linux host was powered off.
Then the next time that docker loads, it will try to restart this container. The -d flag means run in daemonized mode rather than interactive.

** Volumes **

    -v /nbi:/nbi

The -v flag means volumes, what we are doing here is that we are telling docker to map the directory /nbi into /nbi of the container. This allows our container
to have access to /nbi and thus our NetBoot image. Think of it like a shared folder between the host and the container.

** Ports **

    -p 0.0.0.0:69:69/udp -p 0.0.0.0:67:67/udp -p 0.0.0.0:80:80

The -p flag here just maps the ports from the linux host to the bsdpy container. What we are doing here is taking basically forwarding all the UDP traffic
on ports 69 and 67 from the linux host to our container. We are also forwarding UDP and TCP traffic on port 80 from the linux host to the container.

** Environmental Variables **

    -e DOCKER_BSDPY_IP=YourLinuxServerIP
 
The -e flag here is passing an environmental variable to our container. The variable is `DOCKER_BSDPY_IP`
Essentially we need to tell our container what the IP address is of our linux host, so make sure this is set correctly.
ie. 

`-e DOCKER_BSDPY_IP=192.168.0.1`

** Name of container **

    --name netboot_server hunty1/bsdpydocker

The --name flag here allows us to give a name to this running container, you can call it what ever you like. I like to use the function or service the container 
is providing as the name as it makes it easy to see at a glance what my linux host is providing.

After the name we have `hunty1/bsdpydocker` this is a reference to the docker image, basically it is telling docker to go to the public docker registry
look for the user `hunty1` and then look for a image called `bsdpydocker`. If the image does not exist on your linux server already then it will download it.
We already downloaded or pulled the image in the very first steps with `docker pull hunty1/bsdpydocker` So thats a step you could potentially avoid.

You could just run just the one line

    docker run --restart=on-failure:10 -d -v /nbi:/nbi -p 0.0.0.0:69:69/udp -p 0.0.0.0:67:67/udp -p 0.0.0.0:80:80 -e DOCKER_BSDPY_IP=YourLinuxServerIP --name netboot_server hunty1/bsdpydocker

And it will download the image, and start the netboot service, all in one go.

## Summary

I can take a linux host with nothing installed on it just a core os, install docker and then run that one command above and in less than 5 minutes I have a 
fully operational NetBoot server. No mess, no fuss. No dealing with DHCP confs or having to input subnets or any other configuration headaches.


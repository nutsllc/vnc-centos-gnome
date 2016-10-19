# VNC Server(CentOS 6 + Gnome) with Japanese FEP on Docker

A Dockerfile for deploying the VNC server using Docker container.

This image is registered to the [Docker Hub](https://hub.docker.com/r/nutsllc/toybox-gitbucket/) which is the official docker image registory.

## Run container

```bash
docker run -p 5900:5900 -p 5901:5901 -itd nutsllc/vnc-centos-gnome
```

For Japanese environment:

add ``-e JAPANESE_SUPPORT=yes`` to docker run command.

```bash
docker run -p 5900:5900 -p 5901:5901 -e JAPANESE_SUPPORT=yes -itd nutsllc/vnc-centos-gnome
```

## Connect to container via VNC

You need to have the VNC client application to connect to the container with VNC such as the RealVNC if you are windows user.

On MacOS, you can be able to connect to it from Finder. You need no more additional VNC client application. 

Only you have to do is that it select "Go" > "Connect to Server..." from a menubar of Finder.

Connection as a root user:

``vnc://<Hostname(IP Address)>:5900`` and password: ``centos`` 

Connection as a general user(username:toybox):

``vnc://<Hostname(IP Address)>:5901`` and password: ``password``

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/nutsllc/vnc-centos-gnome/issues), or submit a [pull request](https://github.com/nutsllc/vnc-centos-gnome/pulls) with your contribution.
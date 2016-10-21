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

## Connect to container with VNC

### from Windows

You need to have the VNC client application to connect to the container with VNC such as the RealVNC.

#### Connection as the root user

Address: ``vnc://<Hostname(IP Address)>:5900``  
password: ``centos``

#### connection as the general user

Address: ``vnc://<Hostname(IP Address)>:5901``  
password: ``password``

### from MacOSX

On MacOS, you can be able to connect to it from the terminal command. You need no more additional VNC client application. 

In the terminal: 

Run ``open vnc://localhost:5900`` to connect as a root user  
Run ``open vnc://localhost:5901`` to connect as a general user.

Each passwords are the same as a case of Windows.

## Application installers

There are some application installers in ``/installer`` directory. So you can easy install typical applications in the list below.

* LibreOffice
* Dropbox
* Eclipse
* Evolution
* Firefox
* general_purpose_desktop
* Gimp
* Git
* gthumb
* nano
* nautilus-open-terminal
* Netbeans-IDE-8.2
* Network_utilities
* Rhythmbox
* Samba_client
* Sublime_text_3
* System_utilities
* totem
* Utilities
* vim

### How to use them

For example, if you want to install the Firefox, run ``/installer/firefox.sh`` in the Terminal or double-click on the ``/installer/firefox.sh`` file on the desktop and click "Run in Terminal" button in the dialog box appeared.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/nutsllc/vnc-centos-gnome/issues), or submit a [pull request](https://github.com/nutsllc/vnc-centos-gnome/pulls) with your contribution.

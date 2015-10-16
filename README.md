alexagency/centos6-xrdp
==========================

Docker Centos 6 XRDP & VNC server

Create dev workstation

```
docker-machine create -d virtualbox dev
```

Get IP address

```
docker-machine ip dev
```

Connect Docker

```
eval "$(docker-machine env dev)"
```

Copy the sources to following path:
MacOS: /Users/<USERNAME>/Docker/centos6-xrdp 
Windows: /c/Users/<USERNAME>/docker/centos6-xrdp

Build image

```
docker-machine ssh dev
cd /Users/<USERNAME>/Docker/centos6-xrdp
cd /c/Users/<USERNAME>/docker/centos6-xrdp
docker build --force-rm=true -t alexagency/centos6-xrdp .
```

Run container in the background

```
docker run -d -p 5900:5900 -p 3389:3389 alexagency/centos6-xrdp
```

Run container in the background with docker inside

```
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker -d -p 5900:5900 -p 3389:3389 alexagency/centos6-xrdp
```

Run container interactive with remove container after exit (--rm)

```
docker run -it --rm -p 5900:5900 -p 3389:3389 alexagency/centos6-xrdp
```

VNC & RDP:

```
5900 user:password
```

Show list of all containers:

```
docker ps -a
```

To remove all stopeed containers:

```
docker rm $(docker ps -a -q)
```

Show list of all images:

```
docker images
```

To remove image by id:

```
docker rmi -f <IMAGE ID>
```

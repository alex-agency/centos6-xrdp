alexagency/centos6-xrdp
==========================

**Dockerfile for Centos 6 XRDP & VNC server**

### Installation

Install [Docker Machine](https://docs.docker.com/machine/install-machine/).

Create virtual machine:
```
docker-machine create -d virtualbox dev
```

Get IP address:
```
docker-machine ip dev
```

Connect to virtual machine:
```
docker-machine ssh dev
```

Go to shared (between host and virtualbox) home directory:
```
cd /Users/<MAC USER>
cd /c/Users/<WINDOWS USER>
```

Run **alexagency/centos6-xrdp** container from [Docker Hub](https://hub.docker.com/r/alexagency/centos6-xrdp/):
```
docker run -it --rm -p 5900:5900 -p 3389:3389 alexagency/centos6-xrdp
```

Open via VNC or RDP client using virtual maschine's ip-address:

```
VNC port: 5900
RDP port: 3389
```

Credentials:

```
user: password
root: password
```

### Build

Copy sources to shared (between host and virtualbox) home directory:
```
cd /Users/<MAC USER>/Docker/centos6-xrdp
cd /c/Users/<WINDOWS USER>/Docker/centos6-xrdp
```

Build Docker Image:

```
docker build --force-rm=true -t alexagency/centos6-xrdp .
```

### Useful Docker Commands 

Show list of all containers:

```
docker ps -a
```

Attach to a running container:

```
docker exec -it <CONTAINER ID> bash
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

Delete all existing images:

```
docker rmi $(docker images -q -a)
```

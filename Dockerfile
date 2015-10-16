FROM alexagency/centos6-supervisor
MAINTAINER Alex

# Variables
ENV USER_PASSWD  password
ENV ROOT_PASSWD  password

# VNC & XRDP Servers
RUN yum -y install epel-release
RUN yum -y update && \
	yum -y install tigervnc-server tigervnc-server-module xrdp xinetd && \
	yum clean all && rm -rf /tmp/* && \
	chkconfig vncserver on 3456 && \
	echo -e  "\
VNCSERVERS=\"0:user\"\n\
VNCSERVERARGS[0]=\"-geometry 1280x960\""\
>> /etc/sysconfig/vncservers && \
	chkconfig xrdp on 3456 && \
	chmod -v +x /etc/init.d/xrdp && \
	chmod -v +x /etc/xrdp/startwm.sh && \
	echo "gnome-session --session=gnome" > ~/.xsession

# Create User and change passwords
RUN useradd user && \
	su user sh -c "yes $USER_PASSWD | vncpasswd" && echo "user:$USER_PASSWD" | chpasswd && \
	su root sh -c "yes $ROOT_PASSWD | vncpasswd" && echo "root:$ROOT_PASSWD" | chpasswd

# Supervisor services
RUN echo -e  "\
[program:xrdp]\n\
command=/etc/init.d/xrdp restart\n\
stderr_logfile=/var/log/supervisor/xrdp-error.log\n\
stdout_logfile=/var/log/supervisor/xrdp.log"\
> /etc/supervisord.d/xrdp.conf && \
	echo -e  "\
[program:vncserver]\n\
command=/etc/init.d/vncserver restart\n\
stderr_logfile=/var/log/supervisor/vncserver-error.log\n\
stdout_logfile=/var/log/supervisor/vncserver.log"\
> /etc/supervisord.d/vnc.conf

# Inform which port could be opened
EXPOSE 5900 3389

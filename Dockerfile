FROM alexagency/centos6-supervisor
MAINTAINER Alex

# Variables
ENV USER_PASSWD  password
ENV ROOT_PASSWD  password

# Add user
RUN yum -y update && \
    yum -y install sudo && \
    yum clean all && rm -rf /tmp/* && \
    useradd user -m && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "root:$ROOT_PASSWD" | chpasswd && \
    su user echo "user:$USER_PASSWD" | chpasswd

# VNC server
RUN yum -y update && \
    yum -y install tigervnc-server tigervnc-server-module && \
    yum clean all && rm -rf /tmp/* && \
    echo -e  "\
VNCSERVERS=\"0:user\"\n\
VNCSERVERARGS[0]=\"-geometry 1280x960\""\
>> /etc/sysconfig/vncservers && \
    su user sh -c "yes $USER_PASSWD | vncpasswd" && \
    service vncserver start && \
    service vncserver stop

# XRDP server
RUN yum -y install epel-release
RUN yum -y update && \
    yum -y install xrdp xinetd && \
    yum clean all && rm -rf /tmp/* && \
    chmod -v +x /etc/init.d/xrdp && \
    chmod -v +x /etc/xrdp/startwm.sh && \
    sed -i 's/crypt_level=high/crypt_level=low/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/username=ask/username=/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/password=ask/password='"$USER_PASSWD"'/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/port=-1/port=5900/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/X11DisplayOffset=10/X11DisplayOffset=1/g' /etc/xrdp/sesman.ini

# Supervisor services
RUN echo -e  "\
[program:xrdp]\n\
command=sudo /etc/init.d/xrdp restart\n\
stderr_logfile=/var/log/supervisor/xrdp-error.log\n\
stdout_logfile=/var/log/supervisor/xrdp.log"\
> /etc/supervisord.d/xrdp.conf && \
    echo -e  "\
[program:vncserver]\n\
command=sudo /etc/init.d/vncserver restart\n\
stderr_logfile=/var/log/supervisor/vncserver-error.log\n\
stdout_logfile=/var/log/supervisor/vncserver.log"\
> /etc/supervisord.d/vnc.conf

# It allows run supervisor from user
RUN chown user:user /var/log/supervisor

# Default user
USER user
ENV HOME /home/user
WORKDIR /home/user

# Inform which port could be opened
EXPOSE 5900 3389

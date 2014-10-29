# This for mono-opt under ubuntu 14.04.1
FROM ubuntu:14.04.1

MAINTAINER azraelrabbit <azraelrabbit@gmail.com>

#Install required system packages

#change sources to china local mirrors
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list

#add mono-opt source
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/tpokorra:/mono/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/mono-opt.list"

RUN apt-get update
RUN apt-get install -y --force-yes curl openssh-server mono-opt

RUN mkdir -p /var/run/sshd
RUN echo root:monupx |chpasswd

#Install mono-opt
#RUN apt-get update
#RUN apt-get install -y --force-yes  mono-opt

#set the PATH for mono-opt
ENV PATH $PATH:/opt/mono/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/mono/lib
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/opt/mono/lib/pkgconfig

# install mono web server Jexus
RUN curl jexus.org/5.6.3/install|sh


# open port for ssh 
EXPOSE 22

# open port for jexus web server
EXPOSE 8081

#ENTRYPOINT /usr/sbin/sshd -D && /usr/jexus/jws start
CMD /usr/jexus/jws start & /usr/sbin/sshd


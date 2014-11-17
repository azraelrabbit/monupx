# This for mono-opt under ubuntu 14.04.1
FROM ubuntu:14.04.1

MAINTAINER azraelrabbit <azraelrabbit@gmail.com>

#add mono-opt source
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/tpokorra:/mono/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/mono-opt.list"

#Install mono-opt
#RUN apt-get update
#RUN apt-get install -y --force-yes mono-opt
RUN apt-get update
RUN apt-get install -y --force-yes curl openssh-server mono-opt

RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN echo "root:monups" |chpasswd
RUN useradd admin  &&  echo "admin:monupx" | chpasswd  &&  echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers 

# Fix PAM login issue with sshd
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

#set the PATH for mono-opt
ENV PATH $PATH:/opt/mono/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/mono/lib
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/opt/mono/lib/pkgconfig

# install mono web server Jexus
RUN curl jexus.org/5.6.3/install|sh


# open port for ssh 
EXPOSE 22

# mount Volumn on host dir
VOLUME ["/monup"] ["/monupdata"]

# open port for jexus web server
EXPOSE 8081
#&& /usr/jexus/jws start
#ENTRYPOINT /usr/sbin/sshd -D 
#CMD    ["/usr/sbin/sshd", "-D"]
CMD  /usr/jexus/jws start && /usr/sbin/sshd &

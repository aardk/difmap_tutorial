FROM ubuntu:20.04
CMD ["/usr/sbin/sshd", "-D"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils debconf-utils && apt-get -y upgrade && apt-get clean

# Setup enviroment
RUN export LC_ALL=C && \
    apt-get install -y apt-utils debconf-utils software-properties-common && \
    apt-get install -y build-essential wget gfortran pgplot5 libncurses-dev libx11-dev \
                       ssh sudo vim less
RUN useradd --create-home -s /bin/bash vagrant
RUN echo -n 'vagrant:vagrant' | chpasswd
RUN echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant
RUN chmod 440 /etc/sudoers.d/vagrant
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700 /home/vagrant/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers
RUN sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config
RUN sed -i -e 's/\#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd

RUN apt-get -y install openssh-client

EXPOSE 22
RUN cd /usr/local/src && \
    wget ftp://ftp.astro.caltech.edu/pub/difmap/difmap2.5o.tar.gz && \
    tar xvf difmap2.5o.tar.gz && \
    cd uvf_difmap_2.5o && \
    sed -i '1s;^;#!/bin/sh\nbuild_alias=x86_64-linux-gnu\n;' libtecla_src/configure && \
    ./configure linux-ia64-gcc && \
    ./makeall && \
    cp difmap /usr/local/bin && \
    ./clean

USER vagrant
RUN mkdir /home/vagrant/data
ARG SRC1="J1026_2542-EVN.UVF"
ARG SRC2="J1026_2542-VLBA.UVF"
COPY --chown=vagrant:vagrant ${SRC1} /home/vagrant/data/
COPY --chown=vagrant:vagrant ${SRC2} /home/vagrant/data/
USER root

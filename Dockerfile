FROM ubuntu:15.04

MAINTAINER Marcelo Emmerich <m.emmerich@pulsar-solutions.com>

RUN apt-get update \
   && apt-get install -y \
	wget \
	libtool \
	build-essential \
	pkg-config \
	autoconf \
   && apt-get build-dep -y vlc \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget http://download.videolan.org/pub/videolan/vlc/2.2.1/vlc-2.2.1.tar.xz
RUN tar vfx vlc-2.2.1.tar.xz

WORKDIR /tmp/vlc-2.2.1

COPY bank.c src/modules/

RUN ./bootstrap
RUN ./configure --disable-qt --disable-skins2 --enable-xcb --prefix=/usr
RUN make
RUN make install

WORKDIR /tmp
RUN rm -r /tmp/vlc-2.2.1 && rm -r /tmp/vlc-2.2.1.tar.xz

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

FROM ubuntu:17.10
MAINTAINER Naomi Peori <naomi@peori.ca>

ENV PS2DEV /usr/local/ps2dev
ENV PS2SDK ${PS2DEV}/ps2sdk
ENV PATH ${PATH}:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

RUN \
  apt-get -y update && \
  apt-get -y install build-essential git wget && \
  apt-get -y clean autoclean autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN \
  git clone https://github.com/ps2dev/ps2toolchain && \
  cd ps2toolchain && \
    ./toolchain.sh && \
  cd .. && \
  rm -Rf ps2toolchain

RUN \
  git clone https://github.com/ps2dev/gsKit && \
  cd gsKit && \
    make install && \
  cd .. && \
  rm -Rf gsKit

RUN \
  git clone https://github.com/ps2dev/ps2sdk-ports && \
  cd ps2sdk-ports && \
    make && \
  cd .. && \
  rm -Rf ps2sdk-ports

WORKDIR /build

FROM alpine:latest
MAINTAINER Naomi Peori <naomi@peori.ca>

WORKDIR /build

ENV PS2DEV /usr/local/ps2dev
ENV PS2SDK ${PS2DEV}/ps2sdk
ENV PATH $PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

RUN \
  apk update && \
  apk upgrade && \
  apk add bash gcc git make musl-dev patch wget && \

  git clone https://github.com/ps2dev/ps2toolchain && \
  cd ps2toolchain && \
    ./toolchain.sh && \
    cd .. && \
  rm -Rf ps2toolchain && \

  git clone https://github.com/ps2dev/gsKit && \
  cd gsKit && \
    make install && \
    cd .. && \
  rm -Rf gsKit && \

  git clone https://github.com/ps2dev/ps2sdk-ports && \
  cd ps2sdk-ports && \
    make && \
    cd .. && \
  rm -Rf ps2sdk-ports && \

  apk del gcc musl-dev

FROM alpine:latest
MAINTAINER Naomi Peori <naomi@peori.ca>

WORKDIR /build
COPY patches /patches

ENV PS2DEV="/usr/local/ps2dev"
ENV PS2SDK="${PS2DEV}/ps2sdk"
ENV GSKIT="${PS2DEV}/gsKit"
ENV PATH="${PATH}:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin"

RUN \
  apk update && \
  apk upgrade && \
  apk add --no-cache bash gcc git make musl-dev patch ucl-dev wget zlib-dev

SHELL ["/bin/bash", "-c"]

##
## binutils
##

RUN \
  wget http://ftp.gnu.org/pub/gnu/binutils/binutils-2.14.tar.bz2 && \
  tar xfv binutils-*.tar.* && \
  rm binutils-*.tar.* && \
  pushd binutils-* && \
    cat /patches/binutils-*-PS2.patch | patch -p1 && \
    for TARGET in "ee" "iop" "dvp"; do \
      mkdir build-${TARGET} && \
      pushd build-${TARGET} && \
        ../configure --prefix="${PS2DEV}/${TARGET}" --target="${TARGET}" && \
        CFLAGS="${CFLAGS} -D_FORTIFY_SOURCE=0" make -j $(nproc) && \
        make -j $(nproc) install && \
        popd; \
      done && \
    popd && \
  rm -Rf binutils-*

##
## gcc (stage 1)
##

RUN \
  wget http://ftp.gnu.org/pub/gnu/gcc/gcc-3.2.3/gcc-3.2.3.tar.bz2 && \
  tar xfv gcc-*.tar.* && \
  rm gcc-*.tar.* && \
  pushd gcc-* && \
    cat /patches/gcc-*-PS2.patch | patch -p1 && \
    for TARGET in "ee" "iop"; do \
      mkdir build-${TARGET} && \
      pushd build-${TARGET} && \
        ../configure --prefix="${PS2DEV}/${TARGET}" --target="${TARGET}" --enable-languages="c" --with-newlib --without-headers && \
        make -j $(nproc) && \
        make -j $(nproc) install && \
        popd; \
      done && \
    popd && \
  rm -Rf gcc-*

##
## newlib
##

RUN \
  wget http://mirrors.kernel.org/sourceware/newlib/newlib-1.10.0.tar.gz && \
  tar xfv newlib-*.tar.* && \
  rm newlib-*.tar.* && \
  pushd newlib-* && \
    cat /patches/newlib-*-PS2.patch | patch -p1 && \
    for TARGET in "ee"; do \
      mkdir build-${TARGET} && \
      pushd build-${TARGET} && \
        ../configure --prefix="${PS2DEV}/${TARGET}" --target="${TARGET}" && \
        CPPFLAGS="-G0" make -j $(nproc) && \
        make -j $(nproc) install && \
        popd; \
      done && \
    popd && \
  rm -Rf newlib-*

##
## gcc (stage 2)
##

RUN \
  wget http://ftp.gnu.org/pub/gnu/gcc/gcc-3.2.3/gcc-3.2.3.tar.bz2 && \
  tar xfv gcc-*.tar.* && \
  rm gcc-*.tar.* && \
  pushd gcc-* && \
    cat /patches/gcc-*-PS2.patch | patch -p1 && \
    for TARGET in "ee"; do \
      mkdir build-${TARGET} && \
      pushd build-${TARGET} && \
        ../configure --prefix="${PS2DEV}/${TARGET}" --target="${TARGET}" --enable-languages="c,c++" --with-newlib --with-headers="${PS2DEV}/${TARGET}/${TARGET}/include" --enable-cxx-flags="-G0" && \
        make -j $(nproc) && \
        make -j $(nproc) install && \
        popd; \
      done && \
    popd && \
  rm -Rf gcc-*

##
## ps2sdk
##

RUN \
  git clone https://github.com/ps2dev/ps2sdk && \
  pushd ps2sdk && \
    make -j $(nproc) && \
    make install && \
    ln -sf "${PS2SDK}/ee/startup/crt0.o"  "${PS2DEV}/ee/lib/gcc-lib/ee/3.2.3/crt0.o" && \
    ln -sf "${PS2SDK}/ee/startup/crt0.o"  "${PS2DEV}/ee/ee/lib/crt0.o" && \
    ln -sf "${PS2SDK}/ee/lib/libc.a"      "${PS2DEV}/ee/ee/lib/libps2sdkc.a" && \
    ln -sf "${PS2SDK}/ee/lib/libkernel.a" "${PS2DEV}/ee/ee/lib/libkernel.a" && \
    popd && \
  rm -Rf ps2sdk

##
## gsKit
##

RUN \
  git clone https://github.com/ps2dev/gsKit && \
  pushd gsKit && \
    make install && \
    popd && \
  rm -Rf gsKit

##
## ps2sdk-ports
##

RUN \
  git clone https://github.com/ps2dev/ps2sdk-ports && \
  pushd ps2sdk-ports && \
    make && \
    popd && \
  rm -Rf ps2sdk-ports

##
## ps2eth
##

RUN \
  git clone https://github.com/ps2dev/ps2eth && \
  pushd ps2eth && \
    make && \
    make install && \
    popd && \
  rm -Rf ps2eth

##
## ps2client
##

RUN \
  git clone https://github.com/ps2dev/ps2client && \
  pushd ps2client && \
    make && \
    make install && \
    popd && \
  rm -Rf ps2client

##
## ps2-packer
##

RUN \
  git clone https://github.com/ps2dev/ps2-packer && \
  pushd ps2-packer && \
    make && \
    make install && \
    popd && \
  rm -Rf ps2-packer

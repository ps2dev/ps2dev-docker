#!/bin/sh

if [ ! -z "$*" ]; then
  docker run -v `pwd`:/build ps2dev-docker $*
fi

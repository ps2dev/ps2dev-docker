#!/bin/sh

if [ ! -z "$*" ]; then
  docker run -v --rm `pwd`:/build ps2dev-docker $*
fi

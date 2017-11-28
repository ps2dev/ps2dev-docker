#!/bin/sh

if [ ! -z "$1" ]; then
  docker run -v `pwd`:/build ps2dev-docker $1
fi

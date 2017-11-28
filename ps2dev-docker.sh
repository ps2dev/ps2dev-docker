#!/bin/sh

if [ ! -z "$1" ]; then
  docker run -v `pwd`:/build ps2dev-docker /bin/bash -c "cd /build && $1"
fi

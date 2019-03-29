#!/bin/sh

if [ ! -z "$*" ]; then
  sudo docker run -v --rm `pwd`:/build ps2dev-docker $*
else
  sudo docker run -v `pwd`:/build --rm -it ps2dev-docker bash
fi

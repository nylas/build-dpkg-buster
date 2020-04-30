#!/bin/sh
if [ ! -z "$1" ]; then
  apt-get install -y $1
fi;
dpkg-buildpackage $@

#!/bin/sh
mk-build-deps --install debian/control
dpkg-buildpackage $@

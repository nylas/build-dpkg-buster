#!/bin/sh
set -e
# Set the install command to be used by mk-build-deps (use --yes for non-interactive)
install_tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes"
# Install build dependencies automatically
mk-build-deps --install --tool="${install_tool}" debian/control
# Build the package
dpkg-buildpackage $@
# Output the filename
cd ..
packages=`ls *.deb`
echo ::set-output name=filename::`echo \$packages | grep -v dbgsym`
echo ::set-output name=filename-dbgsym::`echo \$packages | grep dbgsym`
# Move the built package into the Docker mounted workspace
mv $packages workspace/

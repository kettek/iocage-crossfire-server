#!/bin/sh

pw add user -n crossfire -c Crossfire -s /bin/csh -m

echo "Downloading and extracting server and arch"
curl -L https://master.dl.sourceforge.net/project/crossfire/crossfire-server/1.75.0/crossfire-1.75.0.tar.gz | tar zx
cd crossfire-1.75.0/lib
curl -L https://master.dl.sourceforge.net/project/crossfire/crossfire-arch/1.71.0/crossfire-1.71.0.arch.tar.bz2 | tar jx
cd ..

echo "Building and installing"
./configure
make
make install

echo "Downloading and extracting maps"
cd /usr/games/crossfire/share/crossfire
curl -L https://master.dl.sourceforge.net/project/crossfire/crossfire-maps/1.75.0/crossfire-maps-1.75.0.tar.gz | tar zx

echo "Setting permissions"
chown -R crossfire:crossfire /usr/games/crossfire/*

echo "Installing Crossfire service"
fetch -o /usr/local/etc/rc.d/crossfire https://raw.githubusercontent.com/kettek/iocage-plugin-crossfire-server/main/iocage-plugin-crossfire/crossfire.rc

echo "Starting Crossfire service"
chmud u+x /usr/local/etc/rc.d/crossfire
sysrc "crossfire_enable=YES"
service crossfire start

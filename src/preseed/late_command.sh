#!/bin/sh -ex 
#

# late_command.sh

# Copy Packages to target
mkdir -p /target/var/packages
cp -r /hd-media/repo /target/var/packages/

# Setup first run script
cp /target/etc/rc.local /target/etc/rc.local.orig
cp /hd-media/preseed/rc.local.first /target/etc/rc.local

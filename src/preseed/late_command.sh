#!/bin/sh -ex 
# late_command.sh

# Fix grub's root device definition for 4.17
# Reinstalling pulls in more dependencies and probably fixes it
in-target apt-get purge -y linux-image-4.17.0-1-amd64
in-target apt-get install -y linux-image-amd64

# Setup first run script
cp /hd-media/preseed/rc.local.first /target/etc/rc.local

# Install configurator
cp -a /hd-media/ansible /target/root/ansible

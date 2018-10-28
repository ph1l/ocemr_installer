#!/bin/sh -ex 
# late_command.sh

# Fix grub's root device definition for 4.17
# Reinstalling pulls in more dependencies and probably fixes it
in-target apt-get purge -y `chroot /target dpkg -l | grep linux-image-4.18 | cut -d" " -f3`
in-target apt-get install -y linux-image-amd64

# Setup first run script
cp /hd-media/preseed/rc.local.first /target/etc/rc.local

# Install configurator
cp -a /hd-media/ansible /target/root/ansible

#!/bin/sh -ex 
#

# late_command.sh

mkdir -p /target/var/packages
cp -r /hd-media/repo /target/var/packages/

echo "deb file:///var/packages/ repo/" >> /target/etc/apt/sources.list

in-target aptitude --quiet --assume-yes update
in-target aptitude --quiet --assume-yes install cfengine3


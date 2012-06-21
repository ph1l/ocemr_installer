#!/bin/sh -ex 
#

# late_command.sh

mkdir -p /target/var/packages
cp -r /hd-media/repo /target/var/packages/

echo "deb file:///var/packages/ repo/" >> /target/etc/apt/sources.list

in-target aptitude update
in-target aptitude install ocemr
in-target aptitude install cfengine3


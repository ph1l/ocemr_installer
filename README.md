# ocemr_installer

ocemr_installer installs and configures Debian Squeeze, an appliance app for
configuring the server, and the OCEMR application from a created USB installer
memory stick.

WARNING: this usb stick will automatically wipe the OS on the machine it
runs on. You just have to press enter once! Be careful.

## Create your USB Installer disk.

    ~/code/ocemr_installer$ sudo ./setup_installer.sh <USB_DEVICE>

## Install the server

#### Introduction to Installation

###### Important Notes

###### Process

  * boot off your USB Installer disk
  * the debain installer will run unattended and shut the system down when it's complete.
  * Remove the Installer Disk, and boot the system, it will shut itself down again.
  * Boot the system a third time and watch the console for completion status.

#### Troubleshooting the automatic setup.

TODO

## Setting up the appliance

#### Configure the printer

  * Connect your printer

  * Configure your printer

Use the CUPS web site @ https://192.168.7.2:631/ to setup your printer

  * Set the printer up in the appliance

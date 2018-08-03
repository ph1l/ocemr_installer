# ocemr_installer

ocemr_installer is a bootable USB disk image that can setup an OCEMR server
appliance system. It installs and configures Debian Squeeze, an appliance app
for configuring the server, and the OCEMR application from a created USB
installer memory stick.

WARNING: this usb stick will automatically wipe the OS on the machine it
runs on. You just have to press enter once! Be careful.

#### Obtain a USB Image

###### Configure your server

    $ vi ocemr.yml

Note: This is the ansible configuration file. See [ocemr_ansible](https://github.com/patfreeman/ocemr_ansible) for more information.

###### Build your own

    $ ./setup_installer.sh <IMAGE_FILE>

Note: this will require sudo installed and authenticated to run. It runs many
commands as root.

###### Find a pre-built image

Check the Wiki for USB Images: https://github.com/ph1l/ocemr_installer/wiki#images

#### Write the image to a device

    # dd if=ocemr_installer-1.4.1b0.img of=/dev/USB_DEVICE

where USB_DEVICE is whatever device name your system has assigned the
USB stick. WARNING: be careful during this step, you risk harming your
if you pass the wrong argument to dd.

#### Install the server

During the entine installation process the server will require an Internet
connection to complete successfully.

##### Phase One

  * Boot a suitable server device from your newly creates USB stick.
  * Select the automated installer option from the grub menu.
  * the debian installer will run unattended and shut the system down when it's complete with the first phase

##### Phase Two

  * Remove the USB stick and boot the system again
  * The system will come online and configure itself

##### Troubleshooting the automatic setup.

TODO

#### Setting up the appliance

After the installation is complete, you can login to the server as *user*: _ocemr_,
with *password*: _admin_.

There is a server control panel at http://_ServerAddress_:5000/ that allows you
to configure server and ocemr settings.

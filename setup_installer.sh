#!/bin/sh -xe
#
#

#### CONFIG SECTION #####

DEB_REL="6.0.9"		# Debian Release. Currently must be a release of squeeze (6.x).

CODENAME="squeeze"	# Debian Release codename. (for downloading INSTALLER media from: http://ftp.debian.org/debian/dists/${CODENAME}/main/installer-${ARCH}/ )

ISO_TYPE="CD-1"	# Which type of ISO to include on installer device.

ARCH=i386		# Arch. Currently only tested for i386.

## END CONFIG SECTION ###



ISO_URL_BASE=http://cdimage.debian.org/cdimage/archive/${DEB_REL}/${ARCH}/iso-cd
ISO_FILENAME=debian-${DEB_REL}-${ARCH}-${ISO_TYPE}.iso
INSTALLER_BASE_URL=http://ftp.debian.org/debian/dists/${CODENAME}/main/installer-${ARCH}/current/images/hd-media/

if [ -z "${1}" ]; then
	echo "Usage: ${0} <DEVICE>"
	exit 2
fi

USB_DEV=${1}

if [ ! -e debian-${DEB_REL}-${ARCH}-${ISO_TYPE}.iso ]; then
	wget ${ISO_URL_BASE}/${ISO_FILENAME}
fi

parted -s ${USB_DEV} mklabel msdos
USB_SIZE=`sudo parted -sm ${USB_DEV} unit b print | grep ^${USB_DEV} | cut -d: -f2 | cut -dB -f1`
parted -s ${USB_DEV} mkpart primary ext2 1048576B $(( ${USB_SIZE} - 1 ))B
parted -s ${USB_DEV} set 1 boot on

kpartx ${USB_DEV}

mke2fs ${USB_DEV}1

mkdir -p /tmp/$$.usb

mount ${USB_DEV}1 /tmp/$$.usb

grub-install --root-directory=/tmp/$$.usb ${USB_DEV}
cat src/grub.cfg | sed -e "s/@@ARCH@@/${ARCH}/g" -e "s/@@DEB_REL@@/${DEB_REL}/g"> /tmp/$$.usb/boot/grub/grub.cfg

mkdir -p /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}
wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/vmlinuz ${INSTALLER_BASE_URL}/vmlinuz
wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/initrd.gz ${INSTALLER_BASE_URL}/initrd.gz

cp -r src/preseed /tmp/$$.usb/

mkdir -p /tmp/$$.usb/repo
cp -v repo/*_all.deb repo/*_${ARCH}.deb /tmp/$$.usb/repo/
( cd /tmp/$$.usb; dpkg-scanpackages repo/ /dev/null | gzip > repo/Packages.gz )

cp -v debian-${DEB_REL}-${ARCH}-${ISO_TYPE}.iso /tmp/$$.usb

umount /tmp/$$.usb

rmdir /tmp/$$.usb

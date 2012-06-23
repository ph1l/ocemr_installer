#!/bin/sh -xe
#
#

DEB_REL="6.0.5"
CODENAME="squeeze"

if [ -z "${2}" ]; then
	echo "Usage: ${0} <DEVICE> <ARCH>"
fi

USB_DEV=${1}

ARCH=${2}

ISO_URL_BASE=http://cdimage.debian.org/debian-cd/${DEB_REL}/${ARCH}/iso-cd
ISO_FILENAME=debian-${DEB_REL}-${ARCH}-CD-1.iso
if [ ! -e debian-${DEB_REL}-${ARCH}-CD-1.iso ]; then
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

INSTALLER_BASE_URL=http://ftp.debian.org/debian/dists/${CODENAME}/main/installer-${ARCH}/current/images/hd-media/
mkdir -p /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}
wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/vmlinuz ${INSTALLER_BASE_URL}/vmlinuz
wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/initrd.gz ${INSTALLER_BASE_URL}/initrd.gz

cp -r src/preseed /tmp/$$.usb/

mkdir -p /tmp/$$.usb/repo
cp -v repo/*_all.deb repo/*_${ARCH}.deb /tmp/$$.usb/repo/
( cd /tmp/$$.usb; dpkg-scanpackages repo/ /dev/null | gzip > repo/Packages.gz )

cp -rv masterfiles /tmp/$$.usb/

cp -v debian-${DEB_REL}-${ARCH}-CD-1.iso /tmp/$$.usb

umount /tmp/$$.usb

rmdir /tmp/$$.usb

#!/bin/sh -xe
#
#

#### CONFIG SECTION #####

ISO_TYPE="netinst"			# type of debian installer ISO (netinst, CD-1, etc..)
IMG_SIZE=$(( 384 * 1024 * 1024 ))	# for netinst set to 512M for CD-1 set to 1024M

# following options untested if changed:

CODENAME="jessie"			# release codename
DEB_REL="testing"				# release version
ARCH="i386"				# architecture

ISO_URL_BASE=http://cdimage.debian.org/cdimage/jessie_di_alpha_1/${ARCH}/iso-cd
ISO_FILENAME=debian-jessie-DI-a1-${ARCH}-${ISO_TYPE}.iso
INSTALLER_BASE_URL=http://ftp.debian.org/debian/dists/${CODENAME}/main/installer-${ARCH}/current/images/hd-media/

## END CONFIG SECTION ###




if [ -z "${1}" ]; then
	echo "Usage: ${0} <FILE>"
	exit 2
fi

IMAGE_FILE=${1}

if [ ! -e ${ISO_FILENAME} ]; then
	wget ${ISO_URL_BASE}/${ISO_FILENAME}
fi

dd if=/dev/zero of=${IMAGE_FILE} seek=${IMG_SIZE} count=1k bs=1

LOOP_DEV=`sudo losetup -f --show ${IMAGE_FILE}`

sudo parted -s ${LOOP_DEV} mklabel msdos
sudo parted -s ${LOOP_DEV} mkpart primary ext2 1048576B $(( ${IMG_SIZE} - 1024 ))B
sudo parted -s ${LOOP_DEV} set 1 boot on
sudo partx -a ${LOOP_DEV} || true
sudo mke2fs ${LOOP_DEV}p1

mkdir -p /tmp/$$.usb

sudo mount ${LOOP_DEV}p1 /tmp/$$.usb

sudo grub-install --root-directory=/tmp/$$.usb --modules="ext2 part_msdos" ${LOOP_DEV}
cat src/grub.cfg | sed -e "s/@@ARCH@@/${ARCH}/g" -e "s/@@DEB_REL@@/${DEB_REL}/g"| sudo tee /tmp/$$.usb/boot/grub/grub.cfg

sudo mkdir -p /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}
sudo wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/vmlinuz ${INSTALLER_BASE_URL}/vmlinuz
sudo wget -O /tmp/$$.usb/debian-installer-${DEB_REL}-${ARCH}/initrd.gz ${INSTALLER_BASE_URL}/initrd.gz

sudo cp -r src/preseed /tmp/$$.usb/

sudo mkdir -p /tmp/$$.usb/repo
sudo cp -v repo/*_all.deb repo/*_${ARCH}.deb /tmp/$$.usb/repo/ || true #ignore this error
( cd /tmp/$$.usb; dpkg-scanpackages repo/ /dev/null | sudo tee repo/Packages && sudo gzip repo/Packages )

sudo cp -v ${ISO_FILENAME} /tmp/$$.usb

# cleanup
sudo umount /tmp/$$.usb
sudo partx -d ${LOOP_DEV}p1
sudo losetup -d ${LOOP_DEV}
rmdir /tmp/$$.usb

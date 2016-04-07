#!/bin/bash

if [ $# != "1" ] ; then
    echo "Usage: $0 <target_device>"
    exit 1
fi

TARGET=$1

SCRIPT_NAME="write_to_emmc.sh"

## for RPi 3
#IMAGE_URL="http://people.canonical.com/~ogra/snappy/all-snaps/rpi3/rpi3-all-snap.img.xz"
#IMAGE_NAME="rpi3-all-snap.img.xz"

## for BBB
IMAGE_URL="http://people.canonical.com/~mvo/all-snaps/bbb-all-snap.img.xz"
IMAGE_NAME="bbb-all-snap.img.xz"

if [ ! -f ${IMAGE_NAME} ] ; then
  wget ${IMAGE_URL}
fi

unxz -c ${IMAGE_NAME} | sudo dd of=${TARGET} bs=32M
sync

echo "Flash done"

umount ${TARGET}2
mount ${TARGET}2 /mnt

cp ${IMAGE_NAME} /mnt/${IMAGE_NAME}
cp ${SCRIPT_NAME} /mnt/${SCRIPT_NAME}
chmod u+x /mnt/${SCRIPT_NAME}
sync
umount ${TARGET}2

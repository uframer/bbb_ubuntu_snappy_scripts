#!/bin/bash

# build uboot
UBOOT_SRC=u-boot
UBOOT_TAG=v2016.03
UBOOT_PATCHES=uboot_patches

if [ ! -f ${UBOOT_SRC} ] ; then
  git clone git://git.denx.de/u-boot.git ${UBOOT_SRC}
fi

cd ${UBOOT_SRC}
git checkout ${UBOOT_TAG} -b ${UBOOT_TAG}

# apply patch
git apply ../${UBOOT_PATCHES}/${UBOOT_TAG}.patch

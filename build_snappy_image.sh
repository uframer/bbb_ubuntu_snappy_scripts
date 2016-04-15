#!/bin/bash

if [ "$#" != "1" ] ; then
    printf "Usage:\n\t$0 <workspace>\n"
    exit 1
fi

ROOT=`pwd`
WS=$1
cd ${WS}
WS=`pwd`

GCC_DIR="${HOME}/local/linaro/"
mkdir -p ${GCC_DIR}
#GCC_TAR="gcc-linaro-5.2-2015.11-x86_64_arm-eabi.tar.xz"
GCC_TAR="gcc-linaro-5.3-2016.02-x86_64_arm-eabi.tar.xz"
#GCC_TARGET="${GCC_DIR}/gcc-linaro-5.2-2015.11-x86_64_arm-eabi"
GCC_TARGET="${GCC_DIR}/gcc-linaro-5.3-2016.02-x86_64_arm-eabi"
#GCC_URL="https://releases.linaro.org/components/toolchain/binaries/5.2-2015.11/arm-eabi/gcc-linaro-5.2-2015.11-x86_64_arm-eabi.tar.xz"
GCC_URL="https://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-eabi/gcc-linaro-5.3-2016.02-x86_64_arm-eabi.tar.xz"
if [ ! -f ${GCC_DIR}/${GCC_TAR} ] ; then
    wget -c --directory-prefix=${GCC_DIR}/ ${GCC_URL}
fi

if [ ! -d ${GCC_TARGET} ] ; then
    tar xvf ${GCC_DIR}/${GCC_TAR}  -C ${GCC_DIR}
fi

CROSS_COMPILE=${GCC_TARGET}/bin/arm-eabi-

# build uboot
UBOOT_SRC=u-boot
UBOOT_TAG=v2016.03
UBOOT_PATCHES=uboot_patches
UBOOT_CONFIGS=uboot_configs

if [ ! -d ${WS}/${UBOOT_SRC}/.git ] ; then
  git clone git://git.denx.de/u-boot.git ${WS}/${UBOOT_SRC}
fi

cd ${WS}/${UBOOT_SRC}
(git branch | grep ${UBOOT_TAG}) || \
    (echo "no branch named ${UBOOT_TAG}" && \
        git checkout ${UBOOT_TAG} -b ${UBOOT_TAG} && \
        rm ${WS}/${UBOOT_SRC}/already_patched)

# apply patch
if [ -f ${ROOT}/${UBOOT_PATCHES}/${UBOOT_TAG}.patch ] ; then
    if [ ! -f ${WS}/${UBOOT_SRC}/already_patched ] ; then
        git apply ${ROOT}/${UBOOT_PATCHES}/${UBOOT_TAG}.patch || (echo "patch failed" && exit 1)
    fi
    touch ${WS}/${UBOOT_SRC}/already_patched
fi

#cp -v ${WS}/${UBOOT_CONFIGS}/${UBOOT_TAG}.config ${WS}/${UBOOT_SRC}/.config

# cross compile

make am335x_boneblack_defconfig || (echo "config failed" && exit 1)
make ARCH=arm CROSS_COMPILE="${CROSS_COMPILE}" || (echo "u-boot build failed" && exit 1)

# MLO
# u-boot.img


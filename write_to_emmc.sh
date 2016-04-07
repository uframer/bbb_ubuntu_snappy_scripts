#!/bin/bash

if [ $# != "2" ] ; then
    echo "Usage: $0 <image_file> <target_device>"
    exit 1
fi

IMAGE_NAME=$1
TARGET=$2

if [ ! -f ${IMAGE_NAME} ] ; then
  echo "No image file found at ${IMAGE_NAME}"
  exit 1
fi

unxz -c ${IMAGE_NAME} | sudo dd of=${TARGET} bs=32M
sync

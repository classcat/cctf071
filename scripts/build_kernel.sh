#!/bin/bash

. ../conf/build_kernel.conf

apt-get install build-essential libncurses5-dev

apt-get install linux-source

/usr/src/linux-source-3.13.0

tar xfj linux-source-3.13.0.tar.bz2

cd /usr/src/linux-source-3.13.0/linux-source-3.13.0

cp -p /boot/config-3.13.0-${KERNEL_REVISION}-generic ./.config

time make -j ${NUMBER_OF_CORES}

s3cmd put drivers/gpu/drm/drm.ko s3://classcat-com/ubuntu-kernel/drm.ko.3.13.0-${KERNEL_REVISION}-generic


### End of Script ###

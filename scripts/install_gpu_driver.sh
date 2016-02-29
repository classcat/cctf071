#!/bin/bash


# working dir should be /mnt
cd /mnt

# drm driver

s3cmd get s3://classcat-com/ubuntu-kernel/drm.ko.3.13.0-${KERNEL_REVISION}-generic drm.ko

mkdir -p /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

install -u root -g root -m 0644 drm.ko /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

insmod /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm/drm.ko


# nvidia driver

apt-get install -y gcc make

mkdir nvidia

cd nvida

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/352.63/NVIDIA-Linux-x86_64-352.63.run

chmod +x NVIDIA-Linux-x86_64-352.63.run 

./NVIDIA-Linux-x86_64-352.63.run

exit 0

### End of Script ###

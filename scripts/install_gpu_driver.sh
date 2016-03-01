#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf/gpu_common.conf


# working dir should be /mnt
cd /mnt

mkdir -p nvidia

cd nvidia


###
### DRM Driver
###

s3cmd get s3://classcat-com/ubuntu-kernel/drm.ko.3.13.0-${KERNEL_REVISION}-generic drm.ko

mkdir -p /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

install -o root -g root -m 0644 drm.ko /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

insmod /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm/drm.ko


###
### NVIDIA Driver
###

apt-get install -y gcc make

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/352.63/NVIDIA-Linux-x86_64-352.63.run

chmod +x NVIDIA-Linux-x86_64-352.63.run 

./NVIDIA-Linux-x86_64-352.63.run


# Clean up

cd /mnt
rm -rf nvidia

# Finish

echo ""
echo "DRM/NVIDIA driver installed, please reboot the instance."
echo "Then, run install_cuda_and_cudnn.sh"
echo ""


exit 0


### End of Script ###

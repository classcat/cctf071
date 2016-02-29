#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------

cd /mnt

mkdir -p nvidia


###
### CUDA 7.5
###

cd /mnt/nvidia

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.0-28_amd64.deb

dpkg -i cuda-repo-ubuntu1404_7.0-28_amd64.deb

apt-get update

apt-get install -y cuda-7-5


###
### cuDNN v4
###

cd /mnt/nvidia

s3cmd get s3://classcat-com/nvidia/cudnn-7.0-linux-x64-v4.0-prod.tgz

tar xfz ./cudnn-7.0-linux-x64-v4.0-prod.tgz 

mkdir /usr/local/cudnn-r4

cp -r cuda /usr/local/cudnn-r4


###

echo "export CUDA_HOME=/usr/local/cuda" >> /root/.bashrc
echo "export PATH=$PATH:$CUDA_HOME/bin" >> /root/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64:/usr/local/cudnn-2.0/lib64" >> /root/.bashrc

#export CPATH=$CPATH:$CUDA_HOME/include:/usr/local/cudnn-2.0/include
#export CUDA_INC_DIR=$CUDA_HOME/bin


##

echo ""
echo "CUDA 7.5 & cnDNN v4 installed, please reboot the instance."
echo ""



exit 0

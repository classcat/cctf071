#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 02-mar-16 : fixed.
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to install CUDA & cuDNN for ClassCat(R) Deep Learning service. Continue ? (y/n) : " >&2

  read var_continue
  if [ -z "$var_continue" ] || [ "$var_continue" != 'y' ]; then
    echo -e "Exit the install program."
    echo -e ""
    exit 1
  fi
}


function show_banner () {
  clear

  echo -e  ""
  echo -en "\x1b[22;36m"
  echo -e  "\tClassCat(R) Deep Learning Service"
  echo -e  "\tCopyright (C) 2015 ClassCat Co.,Ltd. All rights reserved."
  echo -en "\x1b[m"
  echo -e  "\t\t\x1b[22;34m@Install CUDA & cuDNN\x1b[m: release: rc 0xff (2015/03/02)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Press return to continue (or ^C to exit) : " >&2

  read var_continue
}


###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm
}


###
### CUDA 7.5
###

function install_cuda () {
  wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.0-28_amd64.deb

  dpkg -i cuda-repo-ubuntu1404_7.0-28_amd64.deb

  apt-get update

  apt-get install -y cuda-7-5
}


###
### cuDNN v4
###

function install_cudnn () {
  s3cmd get s3://classcat-com/nvidia/cudnn-7.0-linux-x64-v4.0-prod.tgz

  tar xfz ./cudnn-7.0-linux-x64-v4.0-prod.tgz 

  mkdir /usr/local/cudnn-r4

  cp -r cuda /usr/local/cudnn-r4
}


###
### Configure BashRC
###

function config_bashrc_for_cuda () {
  echo "" >> /root/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /root/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /root/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /root/.bashrc

  echo "" >> /home/tensorflow/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /home/tensorflow/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/tensorflow/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/tensorflow/.bashrc

  echo "" >> /home/tensorflow2/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /home/tensorflow2/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/tensorflow2/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/tensorflow2/.bashrc
}



###################
### ENTRY POINT ###
###################

init


#### Working Dir should be set to /mnt.
mkdir -p /mnt/nvidia2
cd /mnt/nvidia2


### Install CDUA & cuDNN

install_cuda

install_cudnn

config_bashrc_for_cuda


### Clean up

cd /mnt

rm -rf nvidia2


### Finally ###

echo ""
echo "#####################################################################"
echo "# CUDA 7.5 & cnDNN v4 has been installed, please reboot the instance. "
echo "# After reboot, you should check installation as root."
echo "#####################################################################"
echo ""


exit 0

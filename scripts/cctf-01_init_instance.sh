#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 07-mar-16 : beta2 fixed.
# 07-mar-16 : tensorflow2, 3 account added.
# 06-mar-16 : pip pkgs for scipy, jupyter, matplotlib.
# 06-mar-16 : change delimiter to space.
# 06-mar-16 : esc sequence fixed.
# 03-mar-16 : beta.
# 02-mar-16 : pkgs for bro.
# 02-mar-16 : pkgs for nvidia driver build.
# 02-mar-16 : /etc/hosts
# 02-mar-16 : fixed.
# 02-mar-16 : remake the structure.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf/init_instance.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to init an instance for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\tCopyright (C) 2016 ClassCat Co.,Ltd. All rights reserved."
  echo -en "\x1b[m"
  echo -e  "\t\t\x1b[22;34m@Init Insance\x1b[m: release: beta 2 (03/07/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Make sure to set ../conf/init_instance.conf. Press return to continue (or ^C to exit) : " >&2

  read var_continue
}


function init_instance () {

  ### Basic ###
  apt-get update
  apt-get -y upgrade
  apt-get -y dist-upgrade

  apt-get install -y ntp

  ### /etc/hosts to disable ipv6 ###
  cp -p /etc/hosts /etc/hosts.orig
  echo "127.0.0.1\tlocalhost\n" > /etc/hosts

  ### BACKUP ###
  cp -a /etc /etc.ec2.orig

  ### SWAP ###

  cp -p /etc/rc.local /etc/rc.local.orig

  cat <<_EOB_ > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

SWAPFILENAME=/swap.img
SIZE=${SWAP_SIZE}

fallocate -l \$SIZE \$SWAPFILENAME && mkswap \$SWAPFILENAME && swapon \$SWAPFILENAME

exit 0
_EOB_

} # init_instance #



###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm

  init_instance
}



###
### SSH
###

function reconfig_ssh () {
  sed -i.bak -e "s/^PasswordAuthentication\s*no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

  service ssh reload
}



###
### S3CMD
###

function install_and_config_s3cmd () {
  apt-get install -y s3cmd

  install -o root -g root ../assets/s3cfg.north-east-1 /root/.s3cfg

  # change delimiter to space.
  sed -i.tmpl -e "s ^access_key\s*=.* access_key=${S3_ACCESS_KEY_FOR_CCTF} g" /root/.s3cfg
  sed -i      -e "s ^secret_key\s*=.* secret_key=${S3_SECRET_KEY_FOR_CCTF} g" /root/.s3cfg
  #sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3_ACCESS_KEY_TO_CCTF}/g" /root/.s3cfg
  #sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3_SECRET_KEY_TO_CCTF}/g" /root/.s3cfg
}


###
### NVIDIA Driver
###

function install_pkgs_for_nvidia_driver () {
  apt-get install -y gcc make
}


###
### VirtualEnv
###

function install_pkgs_for_venv () {
  apt-get install -y python-pip python-dev python-virtualenv

  # for scipy
  apt-get install -y gfortran
  apt-get install -y liblapack-dev libblas-dev

  # for jupyter
  apt-get install -y libzmq3 libzmq3-dev

  # for matplotlib
  apt-get install -y libfreetype6 libfreetype6-dev
}



###
### Bazel
###

function install_pkgs_for_bazel () {
  apt-get install -y zip unzip zlib1g-dev swig

  ### JDK 8 ###
  apt-add-repository ppa:openjdk-r/ppa

  apt-get update

  apt-get install -y openjdk-8-jdk

  update-alternatives --config java
  update-alternatives --config javac
}


###
### Bro
###

function install_pkgs_for_bro () {
  apt-get install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev
}



###
### Add Guest Account
###

# As a global var to display it later.
PASSWD=`cat /dev/urandom | tr -dc "0-9" | fold -w 5 | head -n 1`

function add_guest_accounts () {
  #apt-get install -y pwgen

  useradd tensorflow2 -c 'TensorFlow for Python 2' -m -s /bin/bash
  useradd tensorflow3 -c 'TensorFlow for Python 3' -m -s /bin/bash

  echo "tensorflow2:ClassCat-${PASSWD}" | chpasswd
  echo "tensorflow3:ClassCat-${PASSWD}" | chpasswd
}



###################
### ENTRY POINT ###
###################

init

reconfig_ssh

install_and_config_s3cmd

install_pkgs_for_nvidia_driver

install_pkgs_for_venv

install_pkgs_for_bazel

install_pkgs_for_bro

add_guest_accounts



################
#### Finally ###
################

echo ""
echo "################################################################################"
echo "# Script execution has been completed successfully."
echo "#"
echo -e "# 1) Make sure to keep the following password by making a note :"
echo -e "#        \$PASSWD is \x1b[22;34m${PASSWD}\x1b[m"
echo "#"
echo "# 2) To enable the latest kernel & a swap file, reboot the instance as follows."
echo "#        # sync && reboot "
echo "#"
echo "# 3) Then, run cctf-02_install_gpu_driver.sh."
echo "################################################################################"
echo ""


exit 0


### End of Script ###

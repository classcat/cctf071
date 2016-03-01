#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 02-mar-16 : /etc/hosts
# 02-mar-16 : fixed.
# 02-mar-16 : remake the structure.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf/init_instance.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to init an instance for ClassCat(R) Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Init Insance\x1b[m: release: rc 0xff (2015/03/02)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Make sure setting ../conf/init_instance.conf properly. Press return to continue (or ^C to exit) : " >&2

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

  sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY}/g" /root/.s3cfg
  sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY}/g" /root/.s3cfg
}



###
### VirtualEnv
###

function install_pkgs_for_venv () {
  apt-get install -y python-pip python-dev python-virtualenv
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
### Add Guest Account
###

# As a global var to display it later.
PASSWD=`cat /dev/urandom | tr -dc "0-9" | fold -w 5 | head -n 1`

function add_guest_accounts () {
  #apt-get install -y pwgen

  useradd tensorflow  -c 'TensorFlow'              -m -s /bin/bash
  useradd tensorflow2 -c 'TensorFlow 2 (Reserved)' -m -s /bin/bash

  echo "tensorflow:ClassCat-${PASSWD}"  | chpasswd
  echo "tensorflow2:ClassCat-${PASSWD}" | chpasswd
}



###################
### ENTRY POINT ###
###################

init

reconfig_ssh

install_and_config_s3cmd

install_pkgs_for_venv

install_pkgs_for_bazel

add_guest_accounts



################
#### Finally ###
################

echo ""
echo "#########################################################################"
echo "# Jobs on the script has been completed successfully."
echo "#"
echo -e "# >>> \$PASSWD is \x1b[22;34m${PASSWD}\x1b[m <<<"
echo -e "# >>> BE SURE to MAKE a NOTE to KEEP IT.     <<<"
echo "#"
echo "# To enable the latest kernel & a swap file, please REBOOT the instance."
echo "#########################################################################"
echo ""

exit 0

\x1b[22;34m@Init Insance\x1b[m:

### End of Script ###

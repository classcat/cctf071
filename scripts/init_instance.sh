#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 01-mar-16 : msg out.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf/init_instance.conf


### Basic ###

apt-get update

apt-get -y upgrade

apt-get -y dist-upgrade

apt-get install -y ntp


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


###
### SSH
###

sed -i.bak -e "s/^PasswordAuthentication\s*no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

service ssh reload


###
### Add User Account
###

#apt-get install -y pwgen

useradd tensorflow -c TensorFlow -m -s /bin/bash

useradd tensorflow070 -c 'TensorFlow v0.7.0' -m -s /bin/bash

PASSWD=`cat /dev/urandom | tr -dc "0-9" | fold -w 5 | head -n 1`

echo "tensorflow:ClassCat-${PASSWD}" | chpasswd

echo "tensorflow070:ClassCat-${PASSWD}" | chpasswd


### S3CMD ###

apt-get install s3cmd

install -o root -g root ../assets/s3cfg.north-east-1 /root/.s3cfg

sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY}/g" /root/.s3cfg
sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY}/g" /root/.s3cfg


#### Final ###

echo ""
echo ">>> \$PASSWD is ${PASSWD}, BE SURE TO KEEP IT ONTO THE NOTE."
echo ""
echo "To enable the latest kernel and a swap file, please reboot the instance."
echo ""

exit 0


### End of Script ###

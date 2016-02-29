#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------

. ../conf/init_instance.conf


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
_EOB_


### S3CMD ###

apt-get install s3cmd

install -o root -g root ../assets/s3cfg.north-east-1 /root/.s3cfg

sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY}/g" /root/.s3cfg
sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY}/g" /root/.s3cfg


exit 0


### End of Script ###

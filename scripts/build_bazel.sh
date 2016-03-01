#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 02-mar-16 : "apt-get steps" moved into init_instance.sh
# -----------------------------------------------------------------


# working directory on /mnt

cd /mnt


#apt-get install -y zip unzip zlib1g-dev swig


### JDK 8 ###

#apt-add-repository ppa:openjdk-r/ppa
#
#apt-get update
#
#apt-get install -y openjdk-8-jdk
#
#update-alternatives --config java
#
#update-alternatives --config javac


### BAZEL ###

git clone https://github.com/bazelbuild/bazel.git

cd bazel

git checkout tags/0.1.5

time ./compile.sh

install -o root -g root -m 0755 output/bazel /usr/local/bin/bazel.015

ln -s /usr/local/bin/bazel.015 /usr/local/bin/bazel

### CLEAN UP ###

cd /mnt
rm -rf bazel

bazel version


echo ""
echo "############################################################"
echo " Bazel has been installed onto /usr/local/bin successfully."
echo "############################################################"
echo ""

exit 0


#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 02-mar-16 : fixed.
# 02-mar-16 : "apt-get steps" moved into init_instance.sh
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to build Bazel for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Build Bazel\x1b[m: release: rc 0xff (2015/03/02)"
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
### BAZEL
###

function build_bazel () {
  git clone https://github.com/bazelbuild/bazel.git

  cd bazel

  git checkout tags/0.1.5

  time ./compile.sh

  install -o root -g root -m 0755 output/bazel /usr/local/bin/bazel.015

  ln -s /usr/local/bin/bazel.015 /usr/local/bin/bazel
}



###################
### ENTRY POINT ###
###################

init


### Working directory should be on /mnt.

cd /mnt


### Bazel ###
build_bazel

bazel version


### CLEAN UP ###

cd /mnt
rm -rf bazel


echo ""
echo "###################################################################"
echo "# Bazel 0.1.5 has been installed onto /usr/local/bin successfully."
echo "###################################################################"
echo ""


exit 0

### End of Script ###

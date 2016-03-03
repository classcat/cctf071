#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------


../conf_for_guest/s3_for_guest.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install tensorflow for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Insall TensorFlow\x1b[m: release: rc 0xff (2015/03/02)"
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
### S3CMD
###

function install_and_config_s3cmd () {
  install -o tensorflow -g tensorflow ../assets/s3cfg.north-east-1 ~/.s3cfg

  sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY_FOR_GUEST}/g" /root/.s3cfg
  sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY_FOR_GUEST}/g" /root/.s3cfg
}




###################
### ENTRY POINT ###
###################

init

install_and_config_s3cmd


exit 0

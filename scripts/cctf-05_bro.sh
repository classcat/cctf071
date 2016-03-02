#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 02-mar-16 : created.
# -----------------------------------------------------------------


. ../conf/postfix.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install Bro with Postfix for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Install Bro\x1b[m: release: rc 0xff (2015/03/02)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Press return to continue (or ^C to exit) : " >&2
  echo -ne "Make sure setting ../conf/\x1b[22;34mpostfix.conf\x1b[m properly. Press return to continue (or ^C to exit) : " >&2

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


function install_postfix () {
  apt-get install -y postfix

  sed -i.bak -e "s/^mydestination\s*=.*/mydestination = ${HOSTNAME_PUBLIC}, ${HOSTNAME_PRIVATE}, localhost.localdomain, localhost/g" /etc/postfix/main.cf

  echo "${HOSTNAME_PUBLIC}" > /etc/mailname

  service postfix restart
}


function install_bro () {


}


###################
### ENTRY POINT ###
###################

init

instsall_postfix

install_bro


exit 0

### End of Script ###

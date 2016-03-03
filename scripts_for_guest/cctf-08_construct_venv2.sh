#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- TODO --------------------------------------------------------
# Jupyter

# --- Descrption --------------------------------------------------
# Run on the account - tensorflow070.
#
# --- TODO --------------------------------------------------------
# o PS1 (01-mar-16)
#
# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to construct virtualenv for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Construct VirutualEnv\x1b[m: release: rc 0xff (2015/03/02)"
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


function create_venv_container () {
  virtualenv venv2_tf071

  echo "" >> ~/.bashrc
  echo ". venv2_tf071/bin/activate" >> ~/.bashrc
}


function pip_install_pkgs () {
  . venv2_tf071/bin/activate

  pip install wheel

  pip install numpy

  pip install scipy

  pip install pandas

  pip install jupyter ipython

  pip install matplotlib
}


###################
### ENTRY POINT ###
###################

init

cd ~

create_venv_container

pip_install_pkgs

cd ~


echo ""
echo "#######################################################"
echo "# Script Execution has been completed successfully."
echo "# 1) Re-login to this account to activate a container."
echo "#" 
echo "# 2) Then, run cctf-09_install_tf_v071.sh."
echo "#######################################################"
echo ""

exit 0

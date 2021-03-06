#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# o Run as the guest account: theano.
#
# --- TODO --------------------------------------------------------
# o ~/.keras/keras.json using tensorflow (22-mar-16)
#
# o PS1 (01-mar-16)
#
# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 22-mar-16 : keras added.
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 06-mar-16 : modify pip install pkgs.
# 04-mar-16 : beta.
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to construct virtualenv2 for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Construct VirutualEnv 2\x1b[m: release: rc 0xff (03/22/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "This script must be run as 'theano' account. Press return to continue (or ^C to exit) : " >&2

  read var_continue
}



###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm

  id | grep theano > /dev/null
  if [ "$?" != 0 ]; then
    echo "Script aborted. Id isn't theano."
    exit 1
  fi
}



###
### Construct VirtualEnv
###

function create_venv_container () {
  virtualenv venv2_theano080

  echo "" >> ~/.bashrc
  echo ". venv2_theano080/bin/activate" >> ~/.bashrc
}


function pip_install_pkgs () {


#  pip install wheel
#  if [ "$?" != 0 ]; then
#    echo "Script aborted. pip install wheel failed."
#    exit 1
#  fi

  pip install numpy
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install numpy failed."
    exit 1
  fi

  pip install scipy
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install scipy failed."
    exit 1
  fi
}


function install_theano () {
  git clone git://github.com/Theano/Theano.git

  cd Theano

  git checkout "rel-0.8.0"

  python setup.py build

  python setup.py install

  cat <<_EOB_ > ~/.theanorc
[global]
device = gpu0
floatX = float32
#force_device = True
#allow_gc = False

[nvcc]
fastmath = True

[cuda]
root = /usr/local/cuda

[dnn]
include_path = /usr/local/cudnn-r4/cuda/include
library_path = /usr/local/cudnn-r4/cuda/lib64

### reference ###
#
#[gcc]
#cxxflags = -O3 -ffast-math -funroll-loops -ftracer
#
_EOB_

}


function pip_install_pkgs2 () {
#  pip install pandas
#  if [ "$?" != 0 ]; then
#    echo "Script aborted. pip install pandas failed."
#    exit 1
#  fi

  pip install jupyter
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install jupyter failed."
    exit 1
  fi

  pip install ipython
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install ipython failed."
    exit 1
  fi

  pip install matplotlib
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install matplotlib failed."
    exit 1
  fi

  pip install --no-deps keras
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install keras failed."
    exit 1
  fi

  mkdir ~/.keras

  echo '{"epsilon": 1e-07, "floatx": "float32", "backend": "theano"}' > ~/.keras/keras.json
}



###################
### ENTRY POINT ###
###################

init

cd ~

create_venv_container

. venv2_theano080/bin/activate

cd ~

pip_install_pkgs

cd ~

install_theano

cd ~

pip_install_pkgs2

echo ""
echo "#############################################################################"
echo "# Script Execution has been completed successfully."
echo "# 1) Be sure to 'Re-login' to this account to activate a container."
echo "#" 
echo "# 2) Then, run theano-03_s3.sh as 'theano' account."
echo "#############################################################################"
echo ""


exit 0


### End of Script ###

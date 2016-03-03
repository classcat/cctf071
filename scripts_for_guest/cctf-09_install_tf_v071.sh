#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# Run on the account - tensorflow070.
#
# --- TODO --------------------------------------------------------
# o PS1 (01-mar-16)
#
# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------

#
# $ TF_UNOFFICIAL_SETTING=1 ./configure
#
# Please specify the location of python. [Default is /mnt/tensorflow.xxx/venv2_tf_build/bin/python]: 
# Do you wish to build TensorFlow with GPU support? [y/N] y
# GPU support will be enabled for TensorFlow
# Please specify the Cuda SDK version you want to use, e.g. 7.0. [Leave empty to use system default]: 7.5
# Please specify the location where CUDA 7.5 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: 
# Please specify the Cudnn version you want to use. [Leave empty to use system default]: 4.0.7
# Please specify the location where cuDNN 4.0.7 library is installed. \
#     Refer to README.md for more details. [Default is /usr/local/cuda]: /usr/local/cudnn-r4/cuda
# Please specify a list of comma-separated Cuda compute capabilities you want to build with. \
#     You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus. \
#     Please note that each additional compute capability significantly increases your build time and binary size. \
# [Default is: "3.5,5.2"]: 3.0
#

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


function clone_and_config_tensorflow071 () {
  git clone --recurse-submodules https://github.com/tensorflow/tensorflow tensorflow.071

  ln -s tensorflow.071 tensorflow

  cd tensorflow

  git checkout "v0.7.1"

  TF_UNOFFICIAL_SETTING=1 ./configure

  if [ "$?" != 0 ]; then
    echo "Script aborted. ./configure failed."
    exit 1
  fi
}


function start_build () {
  local var_continue

  echo ""
  echo -ne "Start Build examples and run it. Press return to continue : " >&2

  read var_continue
}


function build_example () {
  start_build

  cd ~/tensorflow

  bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer

  bazel-bin/tensorflow/cc/tutorials_example_trainer --use_gpu
}


function start_build2 () {
  local var_continue

  echo ""
  echo -ne "Start Pip package and keep it. Press return to continue : " >&2

  read var_continue
}


function build_pip_package () {
  start_build2

  cd ~/tensorflow

  bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package

  bazel-bin/tensorflow/tools/pip_package/build_pip_package ~/.tf_pip_pkg
}


###################
### ENTRY POINT ###
###################

init

cd ~

clone_and_config_tensorflow071

cd ~

build_example

build_pip_package

# keep it
cp -p  ~/.tf_pip_pkg/tensorflow-0.7.1-py2-none-any.whl /var/tmp/tf_pip_pkg.071

pip install ~/.tf_pip_pkg/tensorflow-0.7.1-py2-none-any.whl

cd ~

echo ""
echo "####################################################"
echo "# Script execution has been completed successfully."
echo "# Then, run cctf-10_s3.sh."
echo "####################################################"
echo ""


exit 0

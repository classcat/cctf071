#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# Run on the account - tensorflow070.
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

### check device query ###

cp -a /usr/local/cuda/samples ./cuda.samples

cd cuda.samples/1_Utilities/deviceQuery

make

./deviceQuery

make clean

cd ~

### Pip v0.7.1 pacakges of TensorFlow

virtualenv venv2_tf_071

. venv2_tf_071/bin/activate

pip install wheel

pip install numpy

git clone --recurse-submodules https://github.com/tensorflow/tensorflow tensorflow.071

ln -s tensorflow.071 tensorflow

cd tensorflow

git checkout "v0.7.1"

TF_UNOFFICIAL_SETTING=1 ./configure

time bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer

time bazel-bin/tensorflow/cc/tutorials_example_trainer --use_gpu

time bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package

bazel-bin/tensorflow/tools/pip_package/build_pip_package ~/.tf_pip_pkg

pip install ~/.tf_pip_pkg/tensorflow-0.7.1-py2-none-any.whl 


echo ". venv2_tf_master/bin/activate" >> ~/.bashrc

#deactivate

exit 0

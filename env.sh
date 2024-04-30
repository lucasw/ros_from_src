#!/usr/bin/bash
# source ros_from_src/env.sh
export ROS_DEST=`pwd`/ros
export PATH=$PATH:$ROS_DEST/bin
export PATH=$PATH:$ROS_DEST/local/bin

PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
OPT_PYTHONPATH=$ROS_DEST/local/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/dist-packages/

export PYTHONPATH=$PYTHONPATH:$OPT_PYTHONPATH
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$ROS_DEST:$ROS_DEST/lib/cmake


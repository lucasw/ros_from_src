#!/usr/bin/bash
# ROS_DEST=`pwd`/ros source ros_from_src/env.sh
# export ROS_DEST=`pwd`/ros
export PATH=$PATH:$ROS_DEST/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROS_DEST/lib
# export PATH=$PATH:$ROS_DEST/local/bin

# python --version | awk  '{print $2}' | cut -d'.' -f1
PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
OPT_PYTHONPATH0=$ROS_DEST/local/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
OPT_PYTHONPATH1=$ROS_DEST/local/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/dist-packages/

export PYTHONPATH=$PYTHONPATH:$OPT_PYTHONPATH0:$OPT_PYTHONPATH1
echo "PYTHONPATH $PYTHONPATH"
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$ROS_DEST:$ROS_DEST/lib/cmake
echo "CMAKE_PREFIXPATH $CMAKE_PREFIX_PATH"

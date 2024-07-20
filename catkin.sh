#!/bin/bash
set -e
set -x

ls -l
ls -l ros/bin
ROS_DEST=`pwd`/ros source underlay_ws/env.sh

WS=`pwd`/underlay_ws/src
echo $WS

cd $WS/..
echo "#####################"
pwd
# TODO(lucasw) would need to run unminimize to restore man pages
man g++  # grep "This is the default for C++ code"
catkin init
catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -DCATKIN_ENABLE_TESTING=False
echo $PATH
echo $LD_LIBRARY_PATH
rospack list

catkin build --no-status urdf
catkin build --no-status
source install/setup.bash
rospack list
# TODO(lucasw) run tests

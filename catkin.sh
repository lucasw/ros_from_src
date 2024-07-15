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
catkin init
catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -DCATKIN_ENABLE_TESTING=False
echo $PATH
echo $LD_LIBRARY_PATH
rospack list

catkin build
source devel/setup.bash
rospack list
# TODO(lucasw) run tests

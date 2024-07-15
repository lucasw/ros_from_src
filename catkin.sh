#!/bin/bash

source env.sh

WS=`pwd`/underlay_ws/src
echo $WS

cd $WS/..
echo "#####################"
pwd
catkin init
catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -DCATKIN_ENABLE_TESTING=False
rospack list

catkin build
source devel/setup.bash
rospack list
# TODO(lucasw) run tests

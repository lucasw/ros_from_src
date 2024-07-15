#!/bin/bash
# TODO(lucasw) replace the below with submodules
# export PATH=$PATH:/usr/local/bin
SRC=`pwd`/src
echo $SRC
mkdir $SRC -p

WS=`pwd`/underlay_ws/src
echo $WS
mkdir $WS -p

# TODO(lucasw) replace these git clones with vcs
# packages that need to be cmake installed, and are ros packages in a catkin workspace
cd $WS
vcs import --input underlay_repos.yaml

# ROSCONSOLE1=${ROSCONSOLE:-https://github.com/ros-o/rosconsole}
# git clone $ROSCONSOLE1

# pure python
cd $SRC
git clone https://github.com/ros-infrastructure/catkin_pkg
git clone https://github.com/osrf/osrf_pycommon
git clone https://github.com/catkin/catkin_tools

# cmake installs
git clone https://github.com/ros-o/ros_environment

# runtime
git clone https://github.com/ros-infrastructure/rospkg
git clone https://github.com/ros-infrastructure/rosdistro
git clone https://github.com/lucasw/rosdep --branch disable_root_etc_ros

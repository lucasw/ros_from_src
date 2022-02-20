#!/bin/bash
# TODO(lucasw) replace the below with submodules
# export PATH=$PATH:/usr/local/bin
SRC=`pwd`/src
echo $SRC
mkdir $SRC -p
WS=`pwd`/catkin_ws/src
echo $WS
mkdir $WS -p

# packages that need to be cmake installed, and are ros packages in a catkin workspace
cd $WS
git clone https://github.com/ros/catkin
git clone https://github.com/ros/console_bridge
git clone https://github.com/ros/cmake_modules
git clone https://github.com/ros-o/class_loader
git clone https://github.com/ros/rospack
git clone https://github.com/ros/genmsg

# ros packages, regular catkin build only for these
git clone https://github.com/ros/ros_comm
git clone https://github.com/ros/roscpp_core
git clone https://github.com/ros/ros_comm_msgs
git clone https://github.com/ros/message_generation
git clone https://github.com/ros/gencpp
git clone https://github.com/jsk-ros-pkg/geneus
git clone https://github.com/RethinkRobotics-opensource/gennodejs
git clone https://github.com/ros/genlisp
git clone https://github.com/ros/genpy
git clone https://github.com/ros/std_msgs
git clone https://github.com/ros/message_runtime
git clone https://github.com/ros-o/pluginlib

ROSCONSOLE1=${ROSCONSOLE:-https://github.com/ros-o/rosconsole}
git clone $ROSCONSOLE1

# pure python
cd $SRC
git clone https://github.com/ros-infrastructure/catkin_pkg
git clone https://github.com/osrf/osrf_pycommon
git clone https://github.com/catkin/catkin_tools

# cmake installs
git clone https://github.com/ros-o/ros_environment
git clone https://github.com/ros/ros


# runtime
git clone https://github.com/ros-infrastructure/rospkg
git clone https://github.com/ros-infrastructure/rosdistro
git clone https://github.com/lucasw/rosdep --branch disable_root_etc_ros

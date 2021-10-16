FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y dpkg
RUN apt-get install -y apt-utils

RUN apt-get install -y curl
RUN apt-get install -y gnupg2
RUN apt-get install -y lsb-release

# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sh -c "echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\" > /etc/apt/sources.list.d/ros-latest.list"
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update -y

RUN apt-cache search osrf-pycommon
RUN apt-cache search catkin-tools
RUN apt-cache search catkin
RUN apt-cache search osrf
RUN apt-get install -y python3-osrf-pycommon
RUN apt-get install -y python3-catkin-tools

RUN apt-get install -y python3-catkin-pkg
RUN apt-get install -y python3-rosdep
RUN apt-get install -y python3-wstool
RUN apt-get install -y ros-cmake-modules
RUN apt-get install -y ros-$ROS_DISTRO-ros-base
RUN source /opt/ros/$ROS_DISTRO/setup.bash
RUN rosdep init
RUN rosdep update


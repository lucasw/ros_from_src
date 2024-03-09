# install all ros packages from debian, then install custom debian built from ros_from_src
# cd ros_from_src  # be one directory up from debian/
# docker build debian -t ros_from_src_ubuntu_2204
ARG IMAGE=ubuntu:22.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils

# apt installs
RUN apt-get update && apt-get install -y git
RUN apt-get install -y ros-*
RUN apt-get install -y catkin-lint cython3 libapriltag-dev libceres-dev libfmt-dev libfrei0r-ocaml-dev libgmock-dev libgoogle-glog-dev libgst-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libimage-view-dev liborocos-bfl-dev libpcl-ros-dev libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libqwt-qt5-dev libsdl-image1.2-dev libspnav-dev liburdfdom-dev libuvc-dev libv4l-dev libyaml-cpp-dev python-is-python3 python3-tf2-geometry-msgs python3-venv vim curl jq --fix-missing
# not depended on by anything in the rosone deb but useful to already have for building other packages from src
RUN apt-get install -y google-mock libdiagnostic-updater-dev libmuparser-dev libopenvdb-dev python3-geopy python3-open3d python3-pip python3-scipy
# RUN apt-get install -y libgeographic-dev

################################################################################
# catkin and related setup
# TODO(lucasw) there needs to be a deb made for just these packages, they aren't in the deb installed below
ENV DEST=/opt/ros/base
RUN mkdir $DEST -p
ENV SRC=/opt/src
RUN mkdir $SRC -p

WORKDIR $SRC
RUN python --version | awk  '{print $2}' | cut -d'.' -f1
RUN python --version | awk  '{print $2}' | cut -d'.' -f2
# TODO(lucasw) these aren't working
# RUN export PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
# RUN export PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
# RUN PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
ARG PYTHON_MAJOR_VERSION=3
ARG PYTHON_MINOR_VERSION=10
ENV OPT_PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
RUN echo $PYTHONPATH
ENV PYTHONPATH=$OPT_PYTHONPATH
RUN echo $PYTHONPATH
ENV PATH=$DEST/bin:$PATH
################################################################################

# this deb isn't working right, env vars aren't set properly and rosrun doesn't work
# for packages inside it
# ARG DEB=rosone_0.0.6-1_all.deb
# RUN echo ${DEB}
# COPY rosone_0.0.6-1_all.deb .
# COPY ${DEB} .
# RUN dpkg -i ${DEB}
# TODO(lucasw) this setup isn't doing much, have to set this manually
# ENV ROS_PACKAGE_PATH=/opt/ros/one/share:/usr/share

WORKDIR /opt/ros
RUN apt-get install -yqq zip

COPY install_dest_2204_full.zip .
RUN unzip install_dest_2204_full.zip
RUN tar xvf install_dest_2204.tgz
# TODO(lucasw) zip up the install in a way that exclude the full path
RUN mv home/runner/other/install/* $DEST
RUN rm -rf home
RUN rm install_dest_2204*

RUN which catkin && catkin --help

COPY install_catkin_ws_2204__full.zip .
RUN unzip install_catkin_ws_2204__full.zip
RUN tar xvf install_catkin_ws_2204.tgz
RUN mv install_base_catkin_ws/install one
RUN rmdir install_base_catkin_ws
RUN rm install_catkin_ws*

RUN du -sh /opt/ros
RUN find /opt/ros | head -n 30
RUN ls -l /usr/lib/x86_64-linux-gnu/libpython*
RUN source /opt/ros/one/setup.bash && echo $ROS_PACKAGE_PATH && echo $PATH
RUN source /opt/ros/one/setup.bash && rospack find pcl_ros

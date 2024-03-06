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
ENV DEST0=/opt/ros/base
RUN mkdir $DEST0 -p
ENV SRC=/opt/src
RUN mkdir $SRC -p

WORKDIR $SRC
RUN git clone https://github.com/dirk-thomas/vcstool.git
WORKDIR $SRC/vcstool
RUN python3 setup.py install --prefix=$DEST0 --record install_manifest.txt --single-version-externally-managed

WORKDIR $SRC
RUN git clone https://github.com/osrf/osrf_pycommon.git
WORKDIR $SRC/osrf_pycommon
RUN ls -l
RUN python3 setup.py install --prefix=$DEST0 --record install_manifest.txt --single-version-externally-managed

WORKDIR $SRC
RUN git clone https://github.com/lucasw/catkin_tools.git --branch sanitize_cmake_prefix_path
WORKDIR $SRC/catkin_tools
RUN python3 setup.py install --prefix=$DEST0 --record install_manifest.txt --single-version-externally-managed

WORKDIR $SRC
RUN python --version | awk  '{print $2}' | cut -d'.' -f1
RUN python --version | awk  '{print $2}' | cut -d'.' -f2
# TODO(lucasw) these aren't working
# RUN export PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
# RUN export PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
# RUN PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
ARG PYTHON_MAJOR_VERSION=3
ARG PYTHON_MINOR_VERSION=10
ENV OPT_PYTHONPATH=$DEST0/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
RUN echo $PYTHONPATH
ENV PYTHONPATH=$OPT_PYTHONPATH
RUN echo $PYTHONPATH
ENV PATH=$DEST0/bin:$PATH
RUN which catkin && catkin --help
################################################################################

ARG DEB=rosone_0.0.6-1_all.deb
RUN echo ${DEB}
COPY rosone_0.0.6-1_all.deb .
# COPY ${DEB} .
RUN dpkg -i ${DEB}
RUN du -sh /opt/ros
RUN find /opt/ros | head -n 30
RUN ls -l /usr/lib/x86_64-linux-gnu/libpython*
# TODO(lucasw) fix the deb install
RUN source /opt/ros/one/setup.bash
RUN source /opt/ros/one/setup.bash && rospack find pcl_ros

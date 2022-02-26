# install all ros packages from debian
ARG IMAGE=ubuntu:22.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y apt-utils

# apt installs
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y bzip2 libbz2-dev
RUN apt-get install -y cmake
RUN apt-get install -y coreutils
RUN apt-get install -y git
RUN apt-get install -y libboost-dev
RUN apt-get install -y libboost-filesystem-dev
RUN apt-get install -y libboost-program-options-dev
RUN apt-get install -y libboost-regex-dev
RUN apt-get install -y libboost-thread-dev
RUN apt-get install -y libgpgme-dev
RUN apt-get install -y libgtest-dev
RUN apt-get install -y liblog4cxx-dev
RUN apt-get install -y liblz4-dev lz4
RUN apt-get install -y libpoco-dev
RUN apt-get install -y libtinyxml2-dev
RUN apt-get install -y mawk

RUN apt-get update
RUN apt-get install -y python-is-python3
RUN apt-get install -y python3
RUN apt-get install -y python3-dateutil
RUN apt-get install -y python3-defusedxml
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-distro
RUN apt-get install -y python3-docutils
RUN apt-get install -y python3-empy
RUN apt-get install -y python3-netifaces
RUN apt-get install -y python3-pyparsing
RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-yaml

RUN apt-get update
# ros debian installs
# https://wiki.debian.org/DebianScience/Robotics/ROS/Packages
# RUN apt-get install -y ros-robot-state-publisher
RUN apt-get install -y rviz
RUN apt-get install -y ros-robot
RUN apt-get install -y ros-robot-dev
RUN apt-get install -y python3-vcstools

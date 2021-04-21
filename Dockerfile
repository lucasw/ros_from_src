FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y git
RUN git clone https://github.com/ros-infrastructure/catkin_pkg
RUN apt-get install -y python3
RUN apt-get install -y python3-setuptools
RUN cd catkin_pkg && python3 setup.py install

RUN apt-get install -y cmake

RUN git clone https://github.com/ros/catkin
RUN mkdir build/catkin -p
RUN apt-get install -y python3-empy
RUN apt-get install -y python-is-python3
RUN cd build/catkin && cmake ../../catkin -DCATKIN_BUILD_BINARY_PACKAGE=OFF -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF && make && make install

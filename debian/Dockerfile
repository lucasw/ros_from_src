# install all ros packages from debian, then install custom debian built from ros_from_src
# cd ros_from_src  # be one directory up from debian/
# docker build debian -t rosonedeb
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
# RUN apt-get install -y libgeographic-dev

ARG DEB=rosone_0.0.5-1_all.deb
RUN echo ${DEB}
COPY rosone_0.0.5-1_all.deb .
# COPY ${DEB} .
RUN dpkg -i ${DEB}
RUN du -sh /opt/ros
RUN find /opt/ros | head -n 30
RUN ls -l /usr/lib/x86_64-linux-gnu/libpython*
RUN source /opt/ros/one/install/setup.bash
RUN source /opt/ros/one/install/setup.bash && rospack find fuse_msgs

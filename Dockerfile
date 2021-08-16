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
RUN cd build/catkin && cmake ../../catkin -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF && make && make install
# RUN updatedb
# RUN locate catkin

RUN git clone https://github.com/ros/console_bridge
RUN mkdir build/console_bridge -p
# TODO(lucasw) why not /opt/ros/noetic?
RUN cd build/console_bridge && cmake ../../console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib && make && make install

ENV PYTHONPATH=/opt/ros/noetic/lib/python3.8/site-packages
RUN python -c "import catkin_pkg; print(catkin_pkg.__version__)"

RUN git clone https://github.com/ros/cmake_modules
RUN mkdir build/cmake_modules -p
RUN cd build/cmake_modules && cmake ../../cmake_modules -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF && make && make install

RUN git clone https://github.com/ros/class_loader
RUN mkdir build/class_loader -p
RUN apt-get install -y apt-utils
RUN apt-get install -y libboost-dev
RUN apt-get install -y libboost-thread-dev
RUN CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/ros/noetic
RUN ls -l /opt/ros/noetic
RUN ls -l /opt/ros/noetic/share/cmake_modules/cmake/
RUN apt-get install -y libpoco-dev
RUN apt-get install -y libgtest-dev
RUN cd build/class_loader && cmake ../../class_loader -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=/opt/ros/noetic/share/cmake_modules/cmake/
RUN cd build/class_loader && make
RUN cd build/class_loader && make install

RUN git clone https://github.com/ros/ros_environment.git
RUN mkdir build/ros_environment -p
RUN pwd
WORKDIR build/ros_environment
RUN cmake ../../ros_environment -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
RUN make
RUN make install

RUN apt-get install -y libboost-filesystem-dev
RUN apt-get install -y libboost-program-options-dev
RUN apt-get install -y python3-dev
RUN apt-get install -y libtinyxml2-dev

WORKDIR /
RUN git clone https://github.com/ros/rospack.git
RUN mkdir build/rospack -p
WORKDIR build/rospack
RUN cmake ../../rospack -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=/opt/ros/noetic/share/cmake_modules/cmake/
RUN make
RUN make install

WORKDIR /
RUN git clone https://github.com/ros/genmsg.git
RUN mkdir build/genmsg -p
WORKDIR build/genmsg
RUN cmake ../../genmsg -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
RUN make
RUN make install

WORKDIR /
RUN git clone https://github.com/ros/ros.git

WORKDIR /
RUN mkdir build/roslib -p
WORKDIR build/roslib
RUN cmake ../../ros/core/roslib -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Drospack_DIR=/opt/ros/noetic/share/rospack/cmake/
RUN make
RUN make install

WORKDIR /
RUN mkdir build/rosbuild -p
WORKDIR build/rosbuild
RUN cmake ../../ros/core/rosbuild -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF # -Drospack_DIR=/opt/ros/noetic/share/rospack/cmake/
RUN make
RUN make install

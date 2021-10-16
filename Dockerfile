ARG IMAGE=ubuntu:20.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -y apt-utils

# apt installs
RUN apt-get install -y build-essential
RUN apt-get install -y bzip2 libbz2-dev
RUN apt-get install -y cmake
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
RUN apt-get install -y mawk coreutils
RUN apt-get install -y python-is-python3
RUN apt-get install -y python3
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-empy
RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-yaml

ENV SRC=/src
RUN mkdir $SRC -p
ENV BUILD=/build
RUN mkdir $BUILD -p
ENV WS=/catkin_ws/src
RUN mkdir $WS -p

ENV DEST=/opt/ros/noetic

# catkin_pkg
WORKDIR $WS
RUN git clone https://github.com/ros-infrastructure/catkin_pkg
RUN cd catkin_pkg && python3 setup.py install
RUN python -c "import catkin_pkg; print(catkin_pkg.__version__)"

# catkin
WORKDIR $WS
RUN git clone https://github.com/ros/catkin
RUN mkdir $BUILD/catkin -p
WORKDIR $BUILD/catkin
RUN cmake $WS/catkin -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF && make && make install
RUN python -c "import catkin; print(catkin)"

RUN python --version | awk  '{print $2}' | cut -d'.' -f1
# TODO(lucasw) these aren't working
# RUN export PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
# RUN export PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
ARG PYTHON_MAJOR_VERSION=3
ARG PYTHON_MINOR_VERSION=8
RUN echo $PYTHON_MINOR_VERSION
ENV PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages
RUN echo $PYTHONPATH

# console_bridge
WORKDIR $WS
RUN git clone https://github.com/ros/console_bridge
RUN mkdir $BUILD/console_bridge -p
WORKDIR $BUILD/console_bridge
# RUN cmake ../../console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib && make && make install
RUN cmake $WS/console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DEST -DCMAKE_INSTALL_LIBDIR=lib
RUN make
RUN make install

# cmake_modules
WORKDIR $WS
RUN git clone https://github.com/ros/cmake_modules
RUN mkdir $BUILD/cmake_modules -p
RUN ls -l $DEST/lib
WORKDIR $BUILD/cmake_modules
RUN cmake $WS/cmake_modules -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
RUN make
RUN make install

# class_loader
WORKDIR $WS
RUN git clone https://github.com/ros/class_loader
RUN mkdir $BUILD/class_loader -p
RUN CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$DEST
RUN ls -l $DEST
RUN ls -l $DEST/share/cmake_modules/cmake/
WORKDIR $BUILD/class_loader
RUN cmake $WS/class_loader -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
RUN make
RUN make install

# ros_environment
WORKDIR $SRC
RUN git clone https://github.com/ros/ros_environment.git
RUN mkdir $BUILD/ros_environment -p
RUN pwd
WORKDIR $BUILD/ros_environment
RUN cmake $SRC/ros_environment -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
RUN make
RUN make install

# ros_pack
WORKDIR $WS
RUN git clone https://github.com/ros/rospack.git
RUN mkdir $BUILD/rospack -p
WORKDIR $BUILD/rospack
RUN cmake $WS/rospack -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
RUN make
RUN make install

# genmsg
WORKDIR $WS
RUN git clone https://github.com/ros/genmsg.git
RUN mkdir $BUILD/genmsg -p
WORKDIR $BUILD/genmsg
RUN cmake $WS/genmsg -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
RUN make
RUN make install

# ros
WORKDIR $SRC
RUN git clone https://github.com/ros/ros.git

# roslib
RUN mkdir $BUILD/roslib -p
WORKDIR $BUILD/roslib
RUN cmake $SRC/ros/core/roslib -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Drospack_DIR=$DEST/share/rospack/cmake/
RUN make
RUN make install

# rosbuild
RUN mkdir $BUILD/rosbuild -p
WORKDIR $BUILD/rosbuild
RUN cmake $SRC/ros/core/rosbuild -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF # -Drospack_DIR=$DEST/share/rospack/cmake/
RUN make
RUN make install

# osrf pycommon
WORKDIR $SRC
RUN git clone https://github.com/osrf/osrf_pycommon
WORKDIR $SRC/osrf_pycommon
# TODO(lucasw) install to $DEST
RUN python3 setup.py install --record install_manifest.txt

# catkin tools
WORKDIR $SRC
RUN git clone https://github.com/catkin/catkin_tools.git
WORKDIR $SRC/catkin_tools
RUN python3 setup.py install --record install_manifest.txt

RUN export PATH=$PATH:/usr/local/bin
RUN catkin --help

# ros packages
WORKDIR $WS
RUN git clone https://github.com/ros/ros_comm
RUN git clone https://github.com/ros/roscpp_core
RUN git clone https://github.com/ros/ros_comm_msgs
RUN git clone https://github.com/ros/message_generation
RUN git clone https://github.com/ros/gencpp
RUN git clone https://github.com/jsk-ros-pkg/geneus
RUN git clone https://github.com/RethinkRobotics-opensource/gennodejs
RUN git clone https://github.com/ros/genlisp
RUN git clone https://github.com/ros/genpy
RUN git clone https://github.com/ros/std_msgs
RUN git clone https://github.com/ros/message_runtime
RUN git clone https://github.com/ros/rosconsole
RUN git clone https://github.com/ros/ros
RUN git clone https://github.com/ros/pluginlib

# TODO(lucasw) already have a copy of this but needs to be in the workspace
# RUN find / | grep setup.bash
# RUN find / | grep catkin-config.cmake
WORKDIR $WS/..
RUN catkin init
RUN catkin config

# RUN rosdep install --from-paths src --ignore-src -r -s  # do a dry-run first
# RUN rosdep install --from-paths src --ignore-src -r -y
RUN catkin build
RUN source devel/setup.bash
# TODO(lucasw) run tests

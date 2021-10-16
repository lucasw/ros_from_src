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

# ros
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

# osrf pycommon
WORKDIR /
RUN git clone https://github.com/osrf/osrf_pycommon
WORKDIR osrf_pycommon
RUN python3 setup.py install --record install_manifest.txt

# catkin tools
WORKDIR /
RUN git clone https://github.com/catkin/catkin_tools.git
WORKDIR catkin_tools
RUN python3 setup.py install --record install_manifest.txt

RUN apt-get install -y python3-yaml
RUN export PATH=$PATH:/usr/local/bin
RUN catkin --help

# core ros package
WORKDIR /
RUN mkdir catkin_ws/src -p

WORKDIR /catkin_ws/src
RUN apt-get install -y liblz4-dev lz4
RUN git clone https://github.com/ros/ros_comm
RUN git clone https://github.com/ros/roscpp_core
RUN git clone https://github.com/ros/genmsg
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
RUN git clone https://github.com/ros/rospack
RUN git clone https://github.com/ros/cmake_modules
RUN apt-get install -y libboost-regex-dev
RUN apt-get install -y liblog4cxx-dev
RUN git clone https://github.com/ros/pluginlib
RUN git clone https://github.com/ros/class_loader
RUN apt-get install -y bzip2 libbz2-dev
RUN apt-get install -y libgpgme-dev
# TODO(lucasw) already have a copy of this but needs to be in the workspace
RUN ln -s /catkin catkin
# RUN ls -l /opt/ros/noetic
# RUN find / | grep setup.bash
# RUN find / | grep catkin-config.cmake
WORKDIR /catkin_ws
RUN catkin init
RUN catkin config

# RUN rosdep install --from-paths src --ignore-src -r -s  # do a dry-run first
# RUN rosdep install --from-paths src --ignore-src -r -y
RUN catkin build
RUN source devel/setup.bash
# TODO(lucasw) run tests

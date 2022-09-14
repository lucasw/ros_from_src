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
RUN apt install -y git
RUN apt install -y ros-*
RUN apt install -y catkin-lint cython3 libapriltag-dev libceres-dev libfrei0r-ocaml-dev
RUN apt install -y libgeographic-dev libgmock-dev libgoogle-glog-dev libgst-dev
RUN apt install -y libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
RUN apt install -y libimage-view-dev liborocos-bfl-dev libpcl-ros-dev libqt5svg5-dev libqt5websockets5-dev
RUN apt install -y libqt5x11extras5-dev libqwt-qt5-dev libsdl-image1.2-dev
RUN apt install -y libspnav-dev liburdfdom-dev libuvc-dev libv4l-dev libyaml-cpp-dev
RUN apt install -y python-is-python3 python3-tf2-geometry-msgs python3-venv vim curl jq

ENV DEST=/other/install
RUN mkdir $DEST -p
ENV SRC=/other/src
RUN mkdir $SRC -p

WORKDIR $SRC
# RUN git clone https://github.com/lucasw/ros_from_src.git
WORKDIR $SRC/ros_from_src/ubuntu_2204
COPY base_repos.yaml .
# make git clone work through vcs without git credentials
RUN sed -i 's/git@github.com:/https:\/\/github.com\//' base_repos.yaml

WORKDIR $SRC
RUN git clone https://github.com/dirk-thomas/vcstool.git
WORKDIR $SRC/vcstool
RUN python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

WORKDIR $SRC
RUN git clone https://github.com/osrf/osrf_pycommon.git
WORKDIR $SRC/osrf_pycommon
RUN ls -l
RUN python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

WORKDIR $SRC
RUN git clone https://github.com/lucasw/catkin_tools.git --branch sanitize_cmake_prefix_path
WORKDIR $SRC/catkin_tools
RUN python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

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

# get packages and build
ENV WS=/base_catkin_ws/src
RUN mkdir $WS -p
WORKDIR $WS
RUN vcs import --shallow < $SRC/ros_from_src/ubuntu_2204/base_repos.yaml
COPY ignore.sh $SRC/ros_from_src/ubuntu_2204/
RUN $SRC/ros_from_src/ubuntu_2204/ignore.sh
RUN touch other/catkin_virtualenv/test_catkin_virtualenv_inherited/CATKIN_IGNORE
RUN touch other/catkin_virtualenv/test_catkin_virtualenv_isolated/CATKIN_IGNORE

# ENV ROS_DISTRO="noetic"
RUN echo $CMAKE_PREFIX_PATH

WORKDIR $WS/..
RUN catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated
# split these up so can take advantage of docker layers, otherwise one failure
# means a huge rebuild
RUN catkin build --no-status -j1 fuse_core
# disabling this because it is too slow to build
# RUN catkin build --no-status -j1 rtabmap_ros
RUN catkin build --no-status -j1 jsk_rviz_plugins
RUN catkin build --no-status -j1 rviz
RUN catkin build --no-status -j1 plotjuggler
RUN catkin build --no-status -j1 rqt
RUN catkin build --no-status -j1 octomap_server
RUN catkin build --no-status -j1 libuvc_camera
RUN catkin build --no-status -j1 fuse_constraints
RUN catkin build --no-status -j1 people_tracking_filter
RUN catkin build --no-status -j1 laser_assembler
RUN catkin build --no-status -j1 catkin_virtualenv
RUN catkin build --no-status -j1 nmea_navsat_driver
RUN catkin build --no-status -j1 grid_map_visualization
RUN catkin build --no-status -j1 stereo_image_proc
RUN catkin build --no-status -j1 jsk_topic_tools
RUN catkin build --no-status -j1 jsk_interactive_marker
# RUN catkin build --no-status -j1 test_catkin_virtualenv_inherited
# RUN catkin build --no-status -j1 test_catkin_virtualenv_py3_isolated
RUN catkin build --no-status -j1

# rospack list won't work by itself
# RUN source devel/setup.bash && rospack list

# TODO(lucasw) run more tests than this
RUN catkin build joint_trajectory_controller --no-status --no-deps --catkin-make-args tests
RUN source devel/setup.bash && rostest joint_trajectory_controller joint_trajectory_controller.test

# TODO(lucasw) instead of git cloning the repo we're already in, copy in the repos.yaml and ignore file
# so someone could edit them and rerun the dockerfile

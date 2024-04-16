# docker build . -t ros_from_src_ubuntu_2404
ARG IMAGE=ubuntu:24.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -yqq
RUN apt-get upgrade -yqq
RUN apt-get install -yqq apt-utils

# apt installs
RUN apt-get update && apt-get install -yqq git
RUN apt-get update && apt-cache search ros-
RUN apt-get update && apt-cache search catkin
RUN apt-get update && apt-cache search vcs
RUN apt-get update && apt-get install -yqq catkin-tools vcstool
RUN apt-get update && apt-get install -yqq libgsl-dev wget freeglut3-dev libcgal-dev libhdf5-dev libturbojpeg0-dev libzmq3-dev
RUN apt-get -y install ocl-icd-opencl-dev opencl-headers
RUN apt-get update && apt-get install -yqq cython3 libapriltag-dev libceres-dev libfmt-dev libfrei0r-ocaml-dev libgmock-dev libgoogle-glog-dev
RUN apt-get update && apt-get install -yqq libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev liborocos-bfl-dev
RUN apt-get update && apt-get install -yqq curl jq
RUN apt-get update && apt-get install -yqq libyaml-cpp-dev
RUN apt-get update && apt-get install -yqq python-is-python3 python3-venv
RUN apt-get update && apt-get install -yqq libsdl-image1.2-dev libspnav-dev libuvc-dev libv4l-dev
RUN apt-get update && apt-get install -yqq libopenvdb-dev
RUN apt-get update && apt-get install -yqq catkin-lint
RUN apt-get update && apt-get install -yqq liburdfdom-dev
# RUN apt-get update && apt-get install -yqq libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libqwt-qt5-dev
# libgeographic-dev libgst-dev
# vim  is broken 'you have held broken packages'
RUN apt-cache search geographic
RUN apt-get update && apt-get install -yqq libimage-view-dev
RUN apt-get update && apt-get install -yqq libpcl-ros-dev
RUN apt-get update && apt-get install -yqq python3-tf2-geometry-msgs
RUN apt-get update && apt-get install -yqq libgeographiclib-dev
RUN apt-cache search gst | grep dev
RUN apt-get update && apt-get install -yqq ros-core
RUN apt-get update && apt-get install -yqq ros-core-dev
RUN apt-get update && apt-cache search ros-
RUN apt-get update && apt-get install -yqq ros-desktop-full

# install every ros package
RUN apt-get update && apt-get install -yqq `apt-cache search "Robot OS" | awk '{print $1}' | xargs | sed 's/\n/ /g'`
RUN apt-get install -yqq libtf-conversions-dev

RUN apt-get install -yqq build-essential

RUN apt-get install -yqq libboost-iostreams-dev
RUN apt-get install -yqq libjemalloc-dev

# from rosdep
RUN apt-get install -yqq binutils-dev festival festvox-kallpc16k ffmpeg flite google-mock gstreamer1.0-alsa gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools
RUN apt-get install -yqq ifstat iproute2 iputils-ping joystick libassimp-dev libbullet-dev libgstreamer-plugins-good1.0-0 libprotobuf-dev libprotoc-dev
RUN apt-get install -yqq libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libqwt-qt5-dev
RUN apt-get install -yqq libshiboken2-dev libxmu-dev lm-sensors protobuf-compiler
RUN apt-get install -yqq python3-cairo python3-cairosvg python3-click python3-colorama python3-coverage python3-imageio python3-joblib python3-matplotlib python3-mock python3-nose python3-opencv python3-progressbar python3-psutil python3-pydot python3-pygraphviz
# python-pil python3-catkin-pkg-modules
RUN apt-get install -yqq python3-pyproj python3-pyqt5.qtsvg python3-pyside2.qtsvg python3-scipy python3-serial python3-shapely python3-skimage python3-sklearn python3-tabulate python3-texttable python3-tornado python3-websocket
# python3-rosdep python3-rosdep-modules python3-rospkg-modules
RUN apt-get install -yqq qt5-image-formats-plugins shiboken2 sysstat tango-icon-theme virtualenv

RUN apt-get install -yqq libpyside2-dev
RUN apt-get install -yqq python3-sip-dev
RUN apt-get install -yqq pyqt5-dev

ENV DEST=/opt/ros/base
RUN mkdir $DEST -p
ENV SRC=/opt/src
RUN mkdir $SRC -p

WORKDIR $SRC
RUN python --version | awk  '{print $2}' | cut -d'.' -f1
RUN python --version | awk  '{print $2}' | cut -d'.' -f2
# TODO(lucasw) these aren't working
RUN export PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
RUN export PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
RUN echo $PYTHON_MAJOR_VERSION
RUN echo $PYTHON_MINOR_VERSION
RUN python --version
# RUN PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
ARG PYTHON_MAJOR_VERSION=3
ARG PYTHON_MINOR_VERSION=12
ENV OPT_PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
RUN echo $PYTHONPATH
ENV PYTHONPATH=$OPT_PYTHONPATH
RUN echo $PYTHONPATH

ENV PATH=$DEST/bin:$PATH
ENV CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$DEST/lib/cmake

# WORKDIR $SRC
# RUN git clone https://github.com/lucasw/ros_from_src.git
WORKDIR $SRC/ros_from_src/ubuntu_2404
COPY base_repos.yaml .
# make git clone work through vcs without git credentials
RUN sed -i 's/git@github.com:/https:\/\/github.com\//' base_repos.yaml

# get packages and build
ENV WS=/base_catkin_ws/src
RUN mkdir $WS -p
WORKDIR $WS
RUN vcs import --shallow < $SRC/ros_from_src/ubuntu_2404/base_repos.yaml
COPY ignore.sh $SRC/ros_from_src/ubuntu_2404/
RUN $SRC/ros_from_src/ubuntu_2404/ignore.sh
RUN touch other/catkin_virtualenv/test_catkin_virtualenv_inherited/CATKIN_IGNORE
RUN touch other/catkin_virtualenv/test_catkin_virtualenv_isolated/CATKIN_IGNORE

RUN apt-cache search openvdb
RUN dpkg -l | grep openvdb
# RUN mkdir -p $HOME/other/build/openvdb
# WORKDIR other/build/openvdb
# RUN cmake $WS/other/vdb/openvdb/ -DCMAKE_INSTALL_PREFIX=$DEST
# RUN make -j2  # it's a slow build
# RUN make install
RUN dpkg -l | grep ros
# RUN dpkg -l | grep rqt

# ENV ROS_DISTRO="noetic"
RUN echo $CMAKE_PREFIX_PATH

WORKDIR $WS/..
RUN catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev -DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=$DEST/include -DCMAKE_LIBRARY_PATH=$DEST/lib
# split these up so can take advantage of docker layers, otherwise one failure
# means a huge rebuild
# RUN catkin build --no-status -j1 fuse_core
# disabling this because it is too slow to build
# RUN catkin build --no-status -j1 rtabmap_ros
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -r -s || true
RUN catkin build --no-status -j1 libuvc_camera
RUN catkin build --no-status -j1 rqt
RUN catkin build --no-status -j1 vdb_mapping*
RUN catkin build --no-status -j1 jsk_rviz_plugins
RUN catkin build --no-status -j1 rviz
RUN catkin build --no-status -j1 plotjuggler
RUN catkin build --no-status -j1 octomap_server
# RUN catkin build --no-status -j1 fuse_constraints
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
# RUN source install/setup.bash && rospack list

# TODO(lucasw) run more tests than this
RUN catkin build joint_trajectory_controller --no-status --no-deps --catkin-make-args tests
RUN ln -s /base_catkin_ws/install /opt/ros/one
RUN ls -l /opt/ros/one
# make 'source' work
SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/one/setup.sh && rospack list
# RUN source install/setup.sh && rostest joint_trajectory_controller joint_trajectory_controller.test

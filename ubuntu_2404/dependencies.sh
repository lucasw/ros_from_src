#!/bin/bash

apt-get install -yqq git
apt-get install -yqq catkin-tools vcstool
apt-get install -yqq libgsl-dev wget freeglut3-dev libcgal-dev libhdf5-dev libturbojpeg0-dev libzmq3-dev
apt-get -y install ocl-icd-opencl-dev opencl-headers
apt-get install -yqq cython3 libapriltag-dev libceres-dev libfmt-dev libfrei0r-ocaml-dev libgmock-dev libgoogle-glog-dev
apt-get install -yqq libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev  # liborocos-bfl-dev
apt-get install -yqq curl jq
apt-get install -yqq libyaml-cpp-dev
apt-get install -yqq python-is-python3 python3-venv
apt-get install -yqq libsdl-image1.2-dev libspnav-dev libuvc-dev libv4l-dev
apt-get install -yqq libopenvdb-dev
apt-get install -yqq catkin-lint
apt-get install -yqq liburdfdom-dev
apt-get install -yqq libimage-view-dev
apt-get install -yqq libgeographiclib-dev

# install every ros package
# apt-get install -yqq ros-core
# apt-get install -yqq ros-core-dev
# apt-get install -yqq ros-desktop-full
# apt-get install -yqq `apt-cache search "Robot OS" | awk '{print $1}' | xargs | sed 's/\n/ /g'`
# apt-get install -yqq python3-tf2-geometry-msgs
# apt-get install -yqq libpcl-ros-dev

apt-get install -yqq libtf-conversions-dev

apt-get install -yqq build-essential

apt-get install -yqq libboost-iostreams-dev
apt-get install -yqq libjemalloc-dev

# from rosdep
apt-get install -yqq binutils-dev festival festvox-kallpc16k ffmpeg flite google-mock gstreamer1.0-alsa gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools
apt-get install -yqq ifstat iproute2 iputils-ping joystick libassimp-dev libbullet-dev libgstreamer-plugins-good1.0-0 libprotobuf-dev libprotoc-dev
apt-get install -yqq libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libqwt-qt5-dev
apt-get install -yqq libshiboken2-dev libxmu-dev lm-sensors protobuf-compiler
apt-get install -yqq python3-cairo python3-cairosvg python3-click python3-colorama python3-coverage python3-imageio python3-joblib python3-matplotlib python3-mock python3-nose python3-opencv python3-progressbar python3-psutil python3-pydot python3-pygraphviz
# python-pil python3-catkin-pkg-modules
apt-get install -yqq python3-pyproj python3-pyqt5.qtsvg python3-pyside2.qtsvg python3-scipy python3-serial python3-shapely python3-skimage python3-sklearn python3-tabulate python3-texttable python3-tornado python3-websocket
# python3-rosdep python3-rosdep-modules python3-rospkg-modules
apt-get install -yqq qt5-image-formats-plugins shiboken2 sysstat tango-icon-theme virtualenv

apt-get install -yqq libpyside2-dev
apt-get install -yqq python3-sip-dev
apt-get install -yqq pyqt5-dev

apt-get install -yqq libapriltag-dev
apt-get install -yqq vim

apt-get install -yq libboost-test-dev libboost-timer-dev libgdal-dev libopencv-dev liboctomap-dev libpcl-dev libvtk9-dev sip-dev

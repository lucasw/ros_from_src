#!/bin/bash
# exit on error
set -e
set -x

# export PATH=$PATH:/usr/local/bin
SRC=`pwd`/src
echo $SRC
mkdir -p $SRC

BUILD=`pwd`/build
echo $BUILD
mkdir -p $BUILD

DEST=`pwd`/ros

WS=`pwd`/underlay_ws/src
echo $WS
mkdir $WS -p

ROS_DEST=$DEST source $WS/../env.sh

# catkin_pkg
cd $WS/catkin_pkg
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
# python -c "import sys; print(sys.path)"
python -c "import catkin_pkg; print(catkin_pkg.__version__)"
python -c "from catkin_pkg.package import parse_package"

# osrf pycommon
cd $WS/osrf_pycommon
# TODO(lucasw) install to $DEST
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

# catkin tools
cd $WS/catkin_tools
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

# catkin install
mkdir -p $BUILD/catkin
cd $BUILD/catkin
cmake $WS/catkin -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -DCATKIN_INSTALL_INTO_PREFIX_ROOT=true && make && make install
ls -l $DEST/local/bin
PATH=$PATH:$DEST/bin
PATH=$PATH:$DEST/local/bin
which catkin
catkin --version
echo $PYTHONPATH
python -c "import catkin; print(catkin)"

# console_bridge
mkdir -p $BUILD/console_bridge
cd $BUILD/console_bridge
# cmake ../../console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib && make && make install
cmake $WS/console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DEST -DCMAKE_INSTALL_LIBDIR=lib
make
make install
echo "console bridge"

# cmake_modules
cd $WS
mkdir -p $BUILD/cmake_modules
ls -l $DEST/lib
cd $BUILD/cmake_modules
cmake $WS/cmake_modules -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
make
make install

# class_loader
mkdir -p $BUILD/class_loader
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$DEST:$DEST/lib/cmake
ls -l $DEST
ls -l $DEST/share/cmake_modules/cmake/
cd $BUILD/class_loader
cmake $WS/class_loader -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install

# ros_environment
mkdir -p $BUILD/ros_environment
pwd
cd $BUILD/ros_environment
cmake $WS/ros_environment -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
make
make install

# ros_pack
mkdir -p $BUILD/rospack
cd $BUILD/rospack
cmake $WS/rospack -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install
ls -l $DEST/lib
rospack help

# genmsg
mkdir -p $BUILD/genmsg
cd $BUILD/genmsg
cmake $WS/genmsg -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install

# genpy
mkdir -p $BUILD/genpy
cd $BUILD/genpy
cmake $WS/genpy -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install

# roslib
mkdir -p $BUILD/roslib
cd $BUILD/roslib
cmake $WS/ros/core/roslib -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Drospack_DIR=$DEST/share/rospack/cmake/
make
make install

# rosbuild
mkdir -p $BUILD/rosbuild
cd $BUILD/rosbuild
cmake $WS/ros/core/rosbuild -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF # -Drospack_DIR=$DEST/share/rospack/cmake/
make
make install

# rospkg
cd $WS/rospkg
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

cd $WS/rosdistro
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

cd $WS/rosdep
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
rosdep init || true
rosdep update

# TODO(lucasw) wouldn't need to ignore most of these if the non-catkin packages
# that have catkin test packages in them were cloned separately
touch $WS/rosdep/test/CATKIN_IGNORE
touch $WS/catkin_pkg/test/CATKIN_IGNORE
touch $WS/catkin_tools/docs/examples/CATKIN_IGNORE
touch $WS/catkin_tools/tests/CATKIN_IGNORE
touch $WS/rospkg/test/CATKIN_IGNORE

# TODO(lucasw) already have a copy of this but needs to be in the workspace
# find / | grep setup.bash
# find / | grep catkin-config.cmake

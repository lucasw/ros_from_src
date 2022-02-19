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

WS=`pwd`/catkin_ws/src
echo $WS
mkdir -p $WS || true

DEST=`pwd`/ros

# python installs

python --version | awk  '{print $2}' | cut -d'.' -f1
# TODO(lucasw) these aren't working
PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
OPT_PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
echo $PYTHONPATH
export PYTHONPATH=$PYTHONPATH:$OPT_PYTHONPATH
echo PYTHONPATH=\$PYTHONPATH:$OPT_PYTHONPATH

# catkin_pkg
cd $SRC/catkin_pkg
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
ls -l $OPT_PYTHONPATH
ls -l $OPT_PYTHONPATH/catkin_pkg
# python -c "import sys; print(sys.path)"
python -c "import catkin_pkg; print(catkin_pkg.__version__)"
python -c "from catkin_pkg.package import parse_package"


# osrf pycommon
cd $SRC/osrf_pycommon
# TODO(lucasw) install to $DEST
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

# catkin tools
cd $SRC/catkin_tools
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

# cmake install
mkdir -p $BUILD/catkin
cd $BUILD/catkin
cmake $WS/catkin -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -DCATKIN_INSTALL_INTO_PREFIX_ROOT=true && make && make install
python -c "import catkin; print(catkin)"
ls -l $DEST/bin
PATH=$PATH:$DEST/bin

# console_bridge
mkdir -p $BUILD/console_bridge
cd $BUILD/console_bridge
# cmake ../../console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib && make && make install
cmake $WS/console_bridge -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DEST -DCMAKE_INSTALL_LIBDIR=lib
make
make install

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
cmake $SRC/ros_environment -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF
make
make install

# ros_pack
mkdir -p $BUILD/rospack
cd $BUILD/rospack
cmake $WS/rospack -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install

# genmsg
mkdir -p $BUILD/genmsg
cd $BUILD/genmsg
cmake $WS/genmsg -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Dcmake_modules_DIR=$DEST/share/cmake_modules/cmake/
make
make install

# roslib
mkdir -p $BUILD/roslib
cd $BUILD/roslib
cmake $SRC/ros/core/roslib -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF -Drospack_DIR=$DEST/share/rospack/cmake/
make
make install

# rosbuild
mkdir -p $BUILD/rosbuild
cd $BUILD/rosbuild
cmake $SRC/ros/core/rosbuild -DCATKIN_BUILD_BINARY_PACKAGE=ON -DCMAKE_INSTALL_PREFIX=$DEST -DPYTHON_EXECUTABLE=/usr/bin/python -DSETUPTOOLS_DEB_LAYOUT=OFF # -Drospack_DIR=$DEST/share/rospack/cmake/
make
make install

# rospkg
cd $SRC/rospkg
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

cd $SRC/rosdistro
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed

cd $SRC/rosdep
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
rosdep init
rosdep update

# TODO(lucasw) already have a copy of this but needs to be in the workspace
# find / | grep setup.bash
# find / | grep catkin-config.cmake
cd $WS/..
catkin init
source $DEST/setup.bash
catkin config
rospack list

# rosdep install --from-paths src --ignore-src -r -s  # do a dry-run first
# rosdep install --from-paths src --ignore-src -r -y
CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$DEST:$DEST/lib/cmake
echo $CMAKE_PREFIX_PATH
# TODO(lucasw) put this in WS to begin with
# TODO(lucasw) was this needed?  Need a bunch of CATKIN_IGNOREs in every package/test dir to make it build
# ln -s $SRC/ros $WS/ros
catkin build
source devel/setup.bash
rospack list
# TODO(lucasw) run tests

Install many ros packages and dependencies of ros packages that will be built from source, from apt:


```
sudo apt install ros-* catkin-lint cython3 libapriltag-dev libceres-dev libfmt-dev libfrei0r-ocaml-dev libgeographic-dev libgmock-dev libgoogle-glog-dev libgst-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libimage-view-dev liborocos-bfl-dev libpcl-ros-dev libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libqwt-qt5-dev libsdl-image1.2-dev libspnav-dev liburdfdom-dev libuvc-dev libv4l-dev libyaml-cpp-dev python-is-python3 python3-setuptools python3-tf2-geometry-msgs python3-venv vim curl git jq
# 23.04 only:
# sudo apt install libgeographiclib-dev
```

Put this into ~/.bashrc so that vcs and catkin_tools can be found (TODO(lucasw) make them install to ~/.local/... instead like pip user installs?)

```
export DEST=$HOME/other/install
export PATH=$PATH:$DEST/bin

PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
export PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
```

```
mkdir -p ~/other/src
cd ~/other/src
git clone git@github.com:lucasw/ros_from_src --branch robot_state_publisher
```

```
export DEST=$HOME/other/install
export PATH=$PATH:$DEST/bin
```

vcs is very useful for managing a large set of git repos:

```
cd ~/other/src
git clone git@github.com:dirk-thomas/vcstool.git
cd vcstool
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

osrf_pycommon is a dependency of catkin_tools
```
cd ~/other/src
git clone git@github.com:osrf/osrf_pycommon
cd osrf_pycommon
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

catkin_tools is needed to catkin build (but if catkin_make is preferred then this and osrf_pycommon isn't necessary)
```
cd ~/other/src
git clone git@github.com:lucasw/catkin_tools --branch sanitize_cmake_prefix_path
cd catkin_tools
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

Download a bunch of repos that are not available in 22.04 through apt, some with modifications to build in 22.04 (mostly to avoid `boost::placeholders::_N` and bind.hpp warnings and errors, and building with C++17 to avoid log4cxx 0.12 build errors):

```
mkdir -p ~/base_catkin_ws/src
cd ~/base_catkin_ws/src
ln -s ~/other/src/ros_from_src/ubuntu_2204/base_repos.yaml
vcs import --shallow < base_repos.yaml
# ignore repos that aren't yet building in 22.04
~/other/src/ros_from_src/ubuntu_2204/ignore.sh
```

(modify base_repos.yaml as desired to get fewer packages, if more packages are needed they may need alterations to build properly)

The following will take a while, if there are packages not desired it will be much faster to CATKIN_IGNORE or remove them unless they are dependencies of packages that are needed:

```
cd ~/base_catkin_ws
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated
catkin build
source devel/setup.bash
```

TODO(lucasw) see if rosdep install works

---

Optional

Run the above in docker instead:
```
cd ros_from_src/ubuntu_2204
docker build . -t ros_debian_2204
```

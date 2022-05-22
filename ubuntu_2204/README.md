```
sudo apt install ros-* catkin-lint libyaml-cpp-dev libgeographic-dev liburdfdom-dev python3-tf2-geometry-msgs libimage-view-dev vim python-is-python3 libpcl-ros-dev libqwt-qt5-dev libsdl-image1.2-dev libgstreamer1.0-dev libgst-dev libgstreamer-plugins-base1.0-dev libqt5svg5-dev libqt5websockets5-dev libqt5x11extras5-dev libapriltag-dev python3-venv libgmock-dev libgoogle-glog-dev libspnav-dev libv4l-dev libfrei0r-ocaml-dev liborocos-bfl-dev cython3
```

Put this into ~/.bashrc

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
git clone git@github.com:lucasw/ros_from_src
```

```
cd ~/other/src
git clone git@github.com:dirk-thomas/vcstool.git
cd vcstool
export DEST=$HOME/catkin_ws/other/install
export PATH=$PATH:$DEST/bin
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

```
cd ~/other/src
git clone git@github.com:osrf/osrf_pycommon
cd osrf_pycommon
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

```
cd ~/other/src
git clone git@github.com:lucasw/catkin_tools --branch sanitize_cmake_prefix_path
cd catkin_tools
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```

```
mkdir -p ~/base_catkin_ws/src
cd ~/base_catkin_ws/src
ln -s ~/other/src/ros_from_src/ubuntu_2204/base_repos.yaml
vcs import < base_repos.yaml
```

(modify base_repos.yaml as desired to get fewer packages, if more packages are needed they may need alterations to build properly)

```
cd ~/base_catkin_ws
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated
catkin build
source devel/setup.bash
```

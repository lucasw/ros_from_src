# ros_from_src

Following these instructions is recommended for Ubuntu 22.04: [ubuntu_2204/README.md](ubuntu_2204/README.md)

Otherwise to build ros entirely from source without using a PPA (or even the debian ros packages):

    git clone git@github.com:lucasw/ros_from_src.git
    mkdir build
    cd build
    # if Ubuntu 20.04
    # ROSCONSOLE=https://github.com/ros/rosconsole ../ros_from_src/git_clone.sh
    # if Ubuntu 22.04 or later
    ../ros_from_src/git_clone.sh
    # (take look at this script before running as sudo)
    sudo ../ros_from_src/dependencies.sh
    ../ros_from_src/build.sh

The above should be similar to what is in the github action: .github/workflows/ubuntu_20_04.yaml

    export ROS_BUILD_DIR=$HOME/own/build/ros_from_src  # or whatever
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$ROS_BUILD_DIR/ros/lib/cmake
    # make this python3.8 if python --version shows that to be your version
    export PYTHONPATH=$PYTHONPATH:$ROS_BUILD_DIR/ros/lib/python3.9/site-packages/
    # source $ROS_BUILD_DIR/ros/setup.bash
    source $ROS_BUILD_DIR/catkin_ws/devel/setup.bash

To build with docker and another ubuntu version:

    docker build --build-arg IMAGE=ubuntu:22.04 --build-arg SUBDIR=ubuntu_2204 --build-arg ROSCONSOLE=https://github.com/ros/rosconsole --build-arg PYTHON_MINOR_VERSION=9 . -t ros_from_src_2204

Build with default Ubuntu 24.04 version:

    docker build . -t ros_from_src_ubuntu_2404

run it:

    docker run -it --rm --net host ros_from_src_ubuntu_2404 bash -c "source /base_ws/install/setup.bash && bash"

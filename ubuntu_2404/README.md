Additional dependencies

```
apt-get install
libb64-dev
libboost-iostreams-dev
libboost-test-dev
libboost-timer-dev
libcgal-dev
libgdal-dev
libopencv-dev
liboctomap-dev
libpcl-dev
libvtk9-dev
sip-dev
```

```
apt-get install
libassimp-dev
libogre-1.12-dev
```

Some packages (like jsk_recognition_msgs) expect ROS_DISTRO to exist, so:

```
export ROS_DISTRO=one
```


```
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -DCATKIN_ENABLE_TESTING=False
```


```
catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -DCATKIN_ENABLE_TESTING=False
```

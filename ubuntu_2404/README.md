


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

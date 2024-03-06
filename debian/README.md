# Ubuntu 22.04 setup

```
sudo apt install devscripts dh-make
```

```
cd ~/install_base_catkin_ws
catkin config -DCMAKE_BUILD_TYPE=Release -Wno-deprecated
catkin build
```

https://stackoverflow.com/questions/10999948/how-to-include-a-directory-in-the-package-debuild
-> "Edit: Example without using Makefile (if you are not going to build anything)"

Create the debian folder:

```
cd ros_from_src/debian
ln -s ~/install_base_catkin_ws/install
dh_make -p rosone_0.0.6 -i --createorig
```

Had to make a bunch of manual edits after that, like set debian/rosone-dev.install to `install/*`

touch debian/rosone.install
```
test/ /opt/ros/one
```

Build the .deb

```
cd ros_from_src/debian
dpkg-buildpackage -A -uc
```

It creates a deb one directory up:

```
dpkg-deb -c ../rosone_0.0.6-1_all.deb
drwxr-xr-x root/root         0 2023-09-03 15:30 ./
drwxr-xr-x root/root         0 2023-09-03 15:30 ./opt/
drwxr-xr-x root/root         0 2023-09-03 15:30 ./opt/ros/
drwxr-xr-x root/root         0 2023-09-03 15:30 ./opt/ros/one/
... all the install/ files
drwxr-xr-x root/root         0 2023-09-03 15:30 ./usr/
drwxr-xr-x root/root         0 2023-09-03 15:30 ./usr/share/
drwxr-xr-x root/root         0 2023-09-03 15:30 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-09-03 15:30 ./usr/share/doc/rosone/
-rw-r--r-- root/root       167 2023-09-03 15:30 ./usr/share/doc/rosone/README.Debian
-rw-r--r-- root/root       174 2023-09-03 15:30 ./usr/share/doc/rosone/changelog.Debian.gz
-rw-r--r-- root/root      1898 2023-09-03 15:30 ./usr/share/doc/rosone/copyright
drwxr-xr-x root/root         0 2023-09-03 15:30 ./usr/share/doc-base/
-rw-r--r-- root/root       504 2023-09-03 15:30 ./usr/share/doc-base/rosone.rosone
```



Is a recursive search and replace on /home/lucasw/install_base_catkin_ws/install to /opt/ros/oone needed?


# Docker

Test inside a docker container, having built the deb on the outside- but only works if using same ubuntu on the outside:

```
cd ros_from_src/debian
# docker won't use this file if not in current directory
cp ../rosone_0.0.6-1_all.deb .
docker build . -t ros_from_src_ubuntu_2204 --build-arg IMAGE=ubuntu:22.04
docker run -it --net host ros_from_src_ubuntu_2204
roslaunch nodelet_tutorial_math plus.launch  # or something else installed by the .deb
```

# Dockerhub

https://hub.docker.com/r/lucasw0/ros_from_src_ubuntu_2204

```
FROM lucasw0/ros_from_src_ubuntu_2204:latest
```

# Ubuntu 22.04 setup

```
sudo apt install ros-robot-dev rviz
```


Need to install catkin from source and have it in catkin_ws/src

Need to install catkin_tools from source (adapted from ../build.sh)

In .bashrc:
```
export DEST=$HOME/other/install
export PATH=$PATH:$DEST/bin

PYTHON_MAJOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f1`
PYTHON_MINOR_VERSION=`python --version | awk  '{print $2}' | cut -d'.' -f2`
OPT_PYTHONPATH=$DEST/lib/python$PYTHON_MAJOR_VERSION.$PYTHON_MINOR_VERSION/site-packages/
export PYTHONPATH=$PYTHONPATH:$OPT_PYTHONPATH
```


```
git clone https://github.com/catkin/catkin_tools
cd catkin_tools
python3 setup.py install --prefix=$DEST --record install_manifest.txt --single-version-externally-managed
```


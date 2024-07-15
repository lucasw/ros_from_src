#!/bin/bash
# TODO(lucasw) replace the below with submodules
# export PATH=$PATH:/usr/local/bin
set -e

SRC=`pwd`/src
echo $SRC
mkdir $SRC -p

WS=`pwd`/underlay_ws/src
echo $WS
mkdir $WS -p

# TODO(lucasw) replace these git clones with vcs
# packages that need to be cmake installed, and are ros packages in a catkin workspace
cd $WS
vcs import --input underlay_repos.yaml --retry 5

# ROSCONSOLE1=${ROSCONSOLE:-https://github.com/ros-o/rosconsole}
# git clone $ROSCONSOLE1

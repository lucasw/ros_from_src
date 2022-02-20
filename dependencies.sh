#!/bin/bash

# build apt installs
apt-get update
apt-get install -y build-essential
apt-get install -y bzip2 libbz2-dev
apt-get install -y cmake
apt-get install -y coreutils
apt-get install -y git
apt-get install -y libboost-dev
apt-get install -y libboost-filesystem-dev
apt-get install -y libboost-program-options-dev
apt-get install -y libboost-regex-dev
apt-get install -y libboost-thread-dev
apt-get install -y libgpgme-dev
apt-get install -y libgtest-dev
apt-get install -y liblog4cxx-dev
apt-get install -y liblz4-dev lz4
apt-get install -y libpoco-dev
apt-get install -y libtinyxml2-dev
apt-get install -y mawk
apt-get install -y python-is-python3
apt-get install -y python3
apt-get install -y python3-dateutil
apt-get install -y python3-dev
apt-get install -y python3-docutils
apt-get install -y python3-empy
apt-get install -y python3-pyparsing
apt-get install -y python3-setuptools
apt-get install -y python3-yaml

# runtime
apt-get install -y python3-defusedxml
apt-get install -y python3-distro
apt-get install -y python3-netifaces

apt-get install -y python3-pycryptodome
apt-get install -y python3-gnupg

# TODO(lucasw) get this from source later
apt-get install -y python3-rosunit

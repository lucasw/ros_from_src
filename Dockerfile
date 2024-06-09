ARG IMAGE=ubuntu:22.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -yqq apt-utils
RUN apt-get install -yqq git

# TODO(lucasw) this doesn't work in 20.04 because of log
# --build-args ROSCONSOLE=https://github.com/ros-o/rosconsole
ARG ROSCONSOLE=https://github.com/ros-o/rosconsole
# ENV ROSCONSOLE=$ROSCONSOLE
RUN echo $ROSCONSOLE

# packages that need to be cmake installed, and are ros packages in a catkin workspace
RUN mkdir $SRC/ros_from_src -p
WORKDIR /
COPY git_clone.sh $SRC/ros_from_src
# WORKDIR $SRC/ros_from_src
RUN ROS_CONSOLE=$ROSCONSOLE $SRC/ros_from_src/git_clone.sh

COPY dependencies.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/dependencies.sh

COPY build.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/build.sh

WORKDIR $WS/..
# TODO(lucasw) run tests

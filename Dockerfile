# docker build . -t ros_from_src_ubuntu_2404
ARG IMAGE=ubuntu:24.04
FROM ${IMAGE}
ARG IMAGE
RUN echo ${IMAGE}
ARG SUBDIR=ubuntu_2404

ENV DEBIAN_FRONTEND="noninteractive"

# be able to source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install -yqq apt-utils
RUN apt-get install -yqq git

# TODO(lucasw) this doesn't work in 20.04 because of log
# --build-args ROSCONSOLE=https://github.com/ros-o/rosconsole
# ARG ROSCONSOLE=https://github.com/ros-o/rosconsole
# ENV ROSCONSOLE=$ROSCONSOLE
# RUN echo $ROSCONSOLE

# packages that need to be cmake installed, and are ros packages in a catkin workspace
RUN mkdir $SRC/ros_from_src -p
WORKDIR /

COPY dependencies.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/dependencies.sh

COPY ${SUBDIR}/dependencies.sh $SRC/ros_from_src/base_dependencies.sh
RUN $SRC/ros_from_src/base_dependencies.sh

# WORKDIR $SRC/ros_from_src
RUN mkdir -p underlay_ws/src
COPY underlay_repos.yaml underlay_ws/src
RUN sed -i 's/git@github.com:/https:\/\/github.com\//' underlay_ws/src/underlay_repos.yaml
COPY git_clone.sh $SRC/ros_from_src
# RUN ROS_CONSOLE=$ROSCONSOLE $SRC/ros_from_src/git_clone.sh
RUN $SRC/ros_from_src/git_clone.sh

COPY env.sh underlay_ws
COPY build.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/build.sh

COPY catkin.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/catkin.sh

# WORKDIR $SRC/ros_from_src
RUN mkdir -p base_ws/src
COPY ${SUBDIR}/base_repos.yaml base_ws/src
RUN sed -i 's/git@github.com:/https:\/\/github.com\//' base_ws/src/base_repos.yaml
COPY ${SUBDIR}/base_git_clone.sh $SRC/ros_from_src
# RUN ROS_CONSOLE=$ROSCONSOLE $SRC/ros_from_src/git_clone.sh
RUN $SRC/ros_from_src/base_git_clone.sh

COPY ${SUBDIR}/base_catkin.sh $SRC/ros_from_src
RUN $SRC/ros_from_src/base_catkin.sh

RUN source base_ws/install/setup.bash
WORKDIR $WS/..
# TODO(lucasw) run tests

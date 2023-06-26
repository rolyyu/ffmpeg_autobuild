#!/bin/bash

BUILD_TARGET="all"
BUILD_VARIANT="release"
# Get the options
while getopts ":hpt:v:" option; do
   case $option in
      t)
        BUILD_TARGET=$OPTARG
        ;;
      v)
        BUILD_VARIANT=$OPTARG
        ;;
      p) # package vooptimizer product
        BUILD_TARGET="no"
        break;;
      h | *) # display help
        Help
        exit;;
   esac
done


export cpu_count=$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu)
export OS=$(uname -s)
export ENABLE_GPL="yes"
export CROSS_MINGW64="no"

export BUILD_TARGET=$BUILD_TARGET
export BUILD_VARIANT=$BUILD_VARIANT


# Forcing FFmpeg and its dependencies to look for dependencies
# in a specific directory when pkg-config is used
export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
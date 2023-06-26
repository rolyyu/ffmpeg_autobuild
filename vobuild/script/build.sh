#!/bin/bash
# set -x

Help() {
   # Display Help
   echo "Build eagle."
   echo
   echo "Syntax: $0 [-t|h]"
   echo "options:"
   echo " t    Build target project:  [x264/x265/vmaf/ffmpeg/all]"
   echo " h    Display help."
   echo
}

# Defining essential directories

# The root of the build
export WORKING_DIR=$PWD
# Directory that contains source code for FFmpeg and its dependencies
export SOURCE_DIR=$WORKING_DIR/source
# Directory that contains helper scripts
export SCRIPT_DIR=$WORKING_DIR/script
# All bins, libraries and headers are installed there
export INSTALL_DIR=$WORKING_DIR/buildout

# Exporting more necessary variabls
source $SCRIPT_DIR/export_build_variables.sh
source $SCRIPT_DIR/utils.sh

echo "OS type         : $OS"
echo "Build target    : $BUILD_TARGET"

## Check if missing any toolchain
$SCRIPT_DIR/check_host_toolchain.sh

if [[ "$BUILD_TARGET" == "x264" ]]; then
  ## Build x264
  $SCRIPT_DIR/build_x264.sh
elif [[ "$BUILD_TARGET" == "x265" ]]; then
  ## Build x265
  $SCRIPT_DIR/build_x265.sh
elif [[ "$BUILD_TARGET" == "vmaf" ]]; then
  ## Build vmaf
  $SCRIPT_DIR/build_vmaf.sh
elif [[ "$BUILD_TARGET" == "ffmpeg" ]]; then
  ## Build ffmpeg
  $SCRIPT_DIR/build_ffmpeg.sh
else
  ## Build all
  $SCRIPT_DIR/build_x264.sh
  $SCRIPT_DIR/build_x265.sh
  $SCRIPT_DIR/build_vmaf.sh
  $SCRIPT_DIR/build_ffmpeg.sh
fi

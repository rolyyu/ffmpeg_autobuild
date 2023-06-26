#!/bin/bash
# set -x

Help() {
   # Display Help
   echo "Build eagle."
   echo
   echo "Syntax: $0 [-t|v|p|h]"
   echo "options:"
   echo " t    Build target project:  [x264/x265/vmaf/eagle/all]"
   echo " v    Configure eagle (not x264/x265/vmaf) variants:  [debug/release]"
   echo " p    Package vooptimizer product."
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
export INSTALL_DIR=$WORKING_DIR/install
# All cross build definition files
export CROSS_DIR=$WORKING_DIR/cross
# Directory that contains Optimizer product
export PRODUCT_DIR=$WORKING_DIR/vooptimizer

# Exporting more necessary variabls
source $SCRIPT_DIR/export_build_variables.sh
source $SCRIPT_DIR/utils.sh

echo "OS type         : $OS"
if [[ "$BUILD_TARGET" == "no" ]]; then
  echo "Output          : $PRODUCT_DIR"
else
  echo "Build target    : $BUILD_TARGET"
  echo "Build variants  : $BUILD_VARIANT"
fi

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
elif [[ "$BUILD_TARGET" == "eagle" ]]; then
  ## Build eagle
  $SCRIPT_DIR/build_eagle.sh
else
  if [[ "$BUILD_TARGET" != "no" ]]; then
    ## Build all
    $SCRIPT_DIR/build_x264.sh
    $SCRIPT_DIR/build_x265.sh
    $SCRIPT_DIR/build_vmaf.sh
    $SCRIPT_DIR/build_eagle.sh
  else
    ## Package product
    $SCRIPT_DIR/package.sh
  fi
fi

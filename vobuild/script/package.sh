#!/bin/bash
# set -x

source $SCRIPT_DIR/utils.sh

BUILDOUT_DIR=$PRODUCT_DIR/buildout

if [ ! -d $PRODUCT_DIR ]; then
  ENSURE_DIR $PRODUCT_DIR/script
  ENSURE_DIR $PRODUCT_DIR/doc
  ENSURE_DIR $BUILDOUT_DIR/bin
  ENSURE_DIR $BUILDOUT_DIR/include
  ENSURE_DIR $BUILDOUT_DIR/lib
else 
  echo "Product already exists in : $PRODUCT_DIR"
  exit 0
fi

echo "Packaging ..."

echo "Build non-GPL vooptimizer ..."
export ENABLE_GPL="no"
INSTALL_NON_GPL_DIR="${INSTALL_DIR}_non-GPL"
INSTALL_WINDOWS_DIR="${INSTALL_DIR}_windows"

export INSTALL_DIR="${INSTALL_NON_GPL_DIR}"
$SCRIPT_DIR/build_eagle.sh

echo "Copy vooptimizer ..."
if Windows; then
  cp $INSTALL_DIR/bin/vooptimizer* $BUILDOUT_DIR/bin/
fi
cp -r $INSTALL_DIR/include/libvooptimizer $BUILDOUT_DIR/include/
cp $INSTALL_DIR/lib/libvooptimizer* $BUILDOUT_DIR/lib/

if Linux; then
  echo "Build windows vooptimizer ..."
  sudo apt-get update -qq && sudo apt-get -y install mingw-w64 mingw-w64-tools
  export CROSS_MINGW64="yes"
  export INSTALL_DIR="${INSTALL_WINDOWS_DIR}"
  $SCRIPT_DIR/build_vmaf.sh
  $SCRIPT_DIR/build_eagle.sh
  cp $INSTALL_DIR/bin/vooptimizer* $BUILDOUT_DIR/bin/
  cp $INSTALL_DIR/lib/libvooptimizer* $BUILDOUT_DIR/lib/
fi

echo "Copy script and patch ..."
cp $WORKING_DIR/script/check_host_toolchain.sh $PRODUCT_DIR/script/
cp $WORKING_DIR/script/export_build_variables.sh $PRODUCT_DIR/script/
cp $WORKING_DIR/script/utils.sh $PRODUCT_DIR/script/
cp $WORKING_DIR/script/build_ffmpeg.sh $PRODUCT_DIR/script/
cp $WORKING_DIR/script/build_x26* $PRODUCT_DIR/script/
cp $WORKING_DIR/script/build_vmaf.sh $PRODUCT_DIR/script/
cp $WORKING_DIR/script/build.sh $PRODUCT_DIR/
cp -r $WORKING_DIR/patch $PRODUCT_DIR

echo "Copy document ..."
$SCRIPT_DIR/doxy-wrapper.sh $WORKING_DIR/../libvooptimizer $PRODUCT_DIR/doc $WORKING_DIR/Doxyfile
cp -rf $WORKING_DIR/../vodoc/* $PRODUCT_DIR/doc

echo "Done, product in : $PRODUCT_DIR"
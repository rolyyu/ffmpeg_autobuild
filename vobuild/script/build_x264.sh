#!/bin/bash

x264_dir=$SOURCE_DIR/x264

echo "Prepare x264 ..."
if [ ! -d $x264_dir ]; then
  rm -rf $x264_dir.tmp.git
  git clone --branch stable https://github.com/mirror/x264.git $x264_dir.tmp.git
  mv $x264_dir.tmp.git $x264_dir
fi

echo "Build x264"
cd $x264_dir
  ./configure \
    --prefix=$INSTALL_DIR \
    --enable-static \
    --enable-shared \
    --enable-pic
  make -j$cpu_count
  make install 
cd -

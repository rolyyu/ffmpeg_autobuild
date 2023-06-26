#!/bin/bash

ffmpeg_dir=$SOURCE_DIR/ffmpeg

source $SCRIPT_DIR/utils.sh

echo "Prepare ffmpeg ..."
if [ ! -d $ffmpeg_dir ]; then
  rm -rf $ffmpeg_dir.tmp.git
  git clone --branch n4.3 --depth 1 https://github.com/FFmpeg/FFmpeg.git $ffmpeg_dir.tmp.git
  cd $ffmpeg_dir.tmp.git
  git apply $WORKING_DIR/patch/ffmpeg.diff
  cd -
  mv $ffmpeg_dir.tmp.git $ffmpeg_dir
fi

echo "Build ffmpeg"
cd $ffmpeg_dir
    
  configure_name="./configure"

  init_options="--prefix=$INSTALL_DIR
    --pkg-config-flags=--static
    --disable-autodetect
    --disable-doc
    --enable-gpl
    --enable-libx264
    --enable-libx265
    --enable-libvmaf
    --enable-version3
    --enable-pic"
  
  ext_libs_options="
    --enable-nonfree
    --enable-libfdk-aac"
  
  eagle_options="
    --extra-cflags=-I$INSTALL_DIR/include
    --extra-ldflags=-L$INSTALL_DIR/lib
    --extra-libs=-lvooptimizer"
  
  static_options="
    --enable-static
    --disable-shared"

  shared_options="
    --enable-shared
    --disable-static"

  linux_options="
    --extra-libs=-lpthread
    --extra-libs=-lm
    --ld=g++"

  windows_options="
    --extra-libs=-lpthread
    --disable-w32threads"

  if Linux; then
    configure_options="$init_options $ext_libs_options $eagle_options $shared_options $linux_options"
  fi

  if Windows; then
    configure_options="$init_options $ext_libs_options $eagle_options $shared_options $windows_options"
  fi

  echo "config options: $configure_name $configure_options"

  nice -n 5 "$configure_name" $configure_options || { echo "failed configure ..."; exit 1;}

  make -j$cpu_count
  make install

  echo "Done. Build out path: $INSTALL_DIR"
cd -
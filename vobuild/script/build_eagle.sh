#!/bin/bash

# The root of the eagle project
eagle_dir=$WORKING_DIR/..

source $SCRIPT_DIR/utils.sh

echo "Build eagle"
cd $eagle_dir
  
  configure_name="./configure"

  init_options="--prefix=$INSTALL_DIR
    --pkg-config-flags=--static
    --disable-autodetect
    --disable-doc
    --enable-pic"

  gpl_options="
    --enable-gpl
    --enable-libx264
    --enable-libx265"
  
  vmaf_options="
    --enable-libvmaf
    --enable-version3"

  ext_libs_options="
    --enable-nonfree
    --enable-libfdk-aac"
  
  static_options="
    --enable-static
    --disable-shared"

  shared_options="
    --enable-shared
    --disable-static"
  
  static_shared_options="
    --enable-static
    --enable-shared"

  debug_options="
    --enable-debug
    --disable-optimizations
    --disable-stripping"

  linux_options="
    --extra-libs=-lpthread
    --extra-libs=-lm"
  
  linux_asan_options="
    --toolchain=gcc-asan"

  windows_options="
    --extra-libs=-lnetapi32
    --extra-libs=-lpthread
    --disable-w32threads"
  
  mingw64_options="
    --extra-cflags=-I$INSTALL_DIR/include
    --extra-ldflags=-L$INSTALL_DIR/lib
    --extra-libs=-lvmaf
    --arch=x86_64
    --target-os=mingw32
    --cross-prefix=x86_64-w64-mingw32-"

  if ENABLE_GPL; then
    init_options+="$gpl_options $ext_libs_options" 
  fi

  if Linux; then
    configure_options="$init_options $vmaf_options $static_shared_options $linux_options"
    if CROSS_MINGW64; then
      configure_options="$init_options $mingw64_options $static_shared_options $linux_options"
      make clean
    fi
  fi

  if MacOS; then
    configure_options="$init_options $vmaf_options $static_shared_options"
  fi

  if Windows; then
    configure_options="$init_options $vmaf_options $shared_options $windows_options"
  fi

  if DEBUG ; then
    configure_options+="$debug_options"
    if Linux; then
      configure_options+="$linux_asan_options"
    fi
  fi

  echo "config options: $configure_name $configure_options"

  nice -n 5 "$configure_name" $configure_options || { echo "failed configure ..."; exit 1;}

  make -j$cpu_count
  make install
cd -
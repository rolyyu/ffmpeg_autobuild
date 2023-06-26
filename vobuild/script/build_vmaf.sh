#!/bin/bash

vmaf_dir=$SOURCE_DIR/vmaf

source $SCRIPT_DIR/utils.sh

echo "Prepare vmaf ..."
if [ ! -d $vmaf_dir ]; then
  rm -rf $vmaf_dir.tmp.git
  git clone --branch v2.3.0 --depth 1 https://github.com/Netflix/vmaf.git $vmaf_dir.tmp.git
  mv $vmaf_dir.tmp.git $vmaf_dir
fi

echo "Build vmaf"
cd $vmaf_dir/libvmaf
rm -R build

configure_options="
  meson build  
  --buildtype release
  --prefix=$INSTALL_DIR
  --libdir=$INSTALL_DIR/lib"

mingw64_options="
  --cross-file $CROSS_DIR/linux-mingw-w64-64bit.txt"

if CROSS_MINGW64; then
    configure_options+="$mingw64_options" 
fi
echo "config options: $configure_options"

nice -n 5 $configure_options || { echo "failed configure ..."; exit 1;}

meson configure build -Denable_tests=false
ninja -vC build 
ninja -vC build install 
cd -

# Copy model files
echo "Copy model files ..."
mkdir -p $INSTALL_DIR/share
mkdir -p $INSTALL_DIR/share/model
cp $vmaf_dir/model/vmaf_v0.6.1.json $INSTALL_DIR/share/model/vmaf_v0.6.1.json
cp $vmaf_dir/model/vmaf_4k_v0.6.1.json $INSTALL_DIR/share/model/vmaf_4k_v0.6.1.json
echo "Copy model files, Done"
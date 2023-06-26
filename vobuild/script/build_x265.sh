#!/bin/bash

x265_dir=$SOURCE_DIR/x265

source $SCRIPT_DIR/utils.sh

echo "Prepare x265 ..."
if [ ! -d $x265_dir ]; then
  rm -rf $x265_dir.tmp.git
  git clone --branch 3.4.1 --depth 1 https://bitbucket.org/multicoreware/x265_git.git $x265_dir.tmp.git
  mv $x265_dir.tmp.git $x265_dir
fi

echo "Build x265"
if Windows; then
  cd $x265_dir/build/msys
fi
if Linux || MacOS; then
  cd $x265_dir/build/linux
fi

rm -R 8bit 10bit 12bit
mkdir -p 8bit 10bit 12bit

cd 12bit
if Windows; then
  cmake -G "MSYS Makefiles" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
  make -j$cpu_count ${MAKEFLAGS}
  cp libx265.a ../8bit/libx265_main12.a
fi
if Linux || MacOS; then
  cmake ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
  make -j$cpu_count ${MAKEFLAGS}
fi

cd ../10bit
if Windows; then
  cmake -G "MSYS Makefiles" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
  make -j$cpu_count ${MAKEFLAGS}
  cp libx265.a ../8bit/libx265_main10.a
fi
if Linux || MacOS; then
  cmake ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
  make -j$cpu_count ${MAKEFLAGS}
fi

cd ../8bit
if Windows; then
  cmake -G "MSYS Makefiles" ../../../source -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
fi
if Linux || MacOS; then
  ln -sf ../10bit/libx265.a libx265_main10.a
  ln -sf ../12bit/libx265.a libx265_main12.a
  cmake ../../../source -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
fi
make -j$cpu_count ${MAKEFLAGS}

# rename the 8bit library, then combine all three into libx265.a using GNU ar
mv libx265.a libx265_main.a


if Linux || Windows; then

# On Linux, we use GNU ar to combine the static libraries together
ar -M <<EOF
CREATE libx265.a
ADDLIB libx265_main.a
ADDLIB libx265_main10.a
ADDLIB libx265_main12.a
SAVE
END
EOF

else

# Mac/BSD libtool
libtool -static -o libx265.a libx265_main.a libx265_main10.a libx265_main12.a 2>/dev/null

fi

make install

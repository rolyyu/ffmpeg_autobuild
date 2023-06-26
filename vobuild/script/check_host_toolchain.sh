#!/bin/bash

source $SCRIPT_DIR/utils.sh

function install_macos_toolchain(){
    yes y | brew install \
        doxygen \
        autoconf \
        automake \
        cmake \
        git \
        libtool \
        meson \
        vim \
        ninja \
        pkg-config \
        texinfo \
        wget \
        yasm \
        nasm \
        fdk-aac
}

function install_linux_toolchain(){
    sudo apt-get update -qq && sudo apt-get -y install \
        doxygen \
        autoconf \
        automake \
        build-essential \
        cmake \
        git \
        libtool \
        meson \
        xxd \
        ninja-build \
        pkg-config \
        texinfo \
        wget \
        yasm \
        nasm \
        libfdk-aac-dev \
        libnuma-dev
}

function install_mingw_toolchain(){
    yes y | pacman -S --needed git make pkg-config diffutils vim \
        mingw-w64-x86_64-doxygen \
        mingw-w64-x86_64-nasm \
        mingw-w64-x86_64-yasm \
        mingw-w64-x86_64-gcc \
        mingw-w64-x86_64-libtool \
        mingw-w64-x86_64-cmake \
        mingw-w64-x86_64-meson \
        mingw-w64-x86_64-fdk-aac
}

function copy_mingw_dependencies(){
    # Copy the runtime and standard libraries
    # libstdc++: C++ Standard Library (C/C++ library functions etc.)
    # libgcc_s_seh: Exception handling (SEH)
    # libwinpthread: PThreads implementation on Windows (Threading)
    # We should deliver them together. They should be placed where the ffmpeg.exe file is.
    # Static linking for libwinpthread-1.dll is not possible, until of course Mingw 
    # developers creates a fully static libwinpthread-1.a, but, unfortunately only a 
    # dynamic libwinpthread exists.
    ENSURE_DIR $INSTALL_DIR/bin

    echo "Copy the runtime and standard libraries ..."
    cp /mingw64/bin/libstdc++*.dll $INSTALL_DIR/bin/ 2>/dev/null
    cp /mingw64/bin/libgcc_s_seh*.dll $INSTALL_DIR/bin/ 2>/dev/null
    cp /mingw64/bin/libwinpthread*.dll $INSTALL_DIR/bin/ 2>/dev/null
    echo "Copy the runtime and standard libraries Done"
    
  	echo "Copy external libraries ..."
    cp /mingw64/bin/libfdk-aac*.dll $INSTALL_DIR/bin/ 2>/dev/null
    echo "Copy external libraries Done"
}

function install_toolchain(){
    if MacOS; then
        install_macos_toolchain
    fi

    if Linux; then
        install_linux_toolchain
    fi

    if Windows; then
        install_mingw_toolchain
        copy_mingw_dependencies
    fi
}

install_toolchain


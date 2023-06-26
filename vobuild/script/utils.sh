#!/bin/bash

function DEBUG()
{
    [[ "$BUILD_VARIANT" == "debug" ]] && eval $@
}

function MacOS()
{
    [[ "$OS" == "Darwin" ]] && eval $@
}

function Linux()
{
    [[ "$OS" == "Linux" ]] && eval $@
}

function Windows()
{
    [[ "$OS" =~ "MINGW64" ]] && eval $@
}

function ENABLE_GPL()
{
    [[ "$ENABLE_GPL" == "yes" ]] && eval $@
}

function CROSS_MINGW64()
{
    [[ "$CROSS_MINGW64" == "yes" ]] && eval $@
}

function ENSURE_DIR()
{
    if [ ! -d "$1" -a ! -e "$1" ]; then
        echo "$1 directory doesn't exist, safe to create it."
        mkdir -p "$1"
    fi
}
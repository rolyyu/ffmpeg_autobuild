#!/bin/bash

IN_DIR="${1}"
OUT_DIR="${2}"
DOXYFILE="${3}"

VER_FILE=$IN_DIR/libvooptimizer.version
if [ -f "$VER_FILE" ]; then
    prefix=libvooptimizer_VERSION=
    VERSION="$(grep $prefix $VER_FILE)"
    VERSION=${VERSION##*=}
else
    VERSION=`git rev-parse --short HEAD`
fi

cat <<EOF >> $OUT_DIR/Doxyfile
@INCLUDE               = ${DOXYFILE}
INPUT                  = $IN_DIR
PROJECT_NUMBER         = $VERSION
OUTPUT_DIRECTORY       = $OUT_DIR
EOF

doxygen $OUT_DIR/Doxyfile
rm $OUT_DIR/Doxyfile
#!/bin/bash

git clone https://git.savannah.gnu.org/git/gnulib.git gnulib

GIT_DESCRIBE=`git -C gnulib describe`
GIT_DATETIME=`git -C gnulib log -1 --format="%ct" | xargs -I{} date -d @{} +%Y%m%dT%H%M%S`
OUTPUT_DIR="libargp-${GIT_DESCRIBE}-${GIT_DATETIME}"
OUTPUT_DIR_LGPL="${OUTPUT_DIR}-lgpl"

# Extract module with complete autoconf/automake build environment
gnulib/gnulib-tool --dir="${OUTPUT_DIR}" --lib=libargp --libtool --create-testdir --without-tests argp

# Extract LGPL module source
mkdir "${OUTPUT_DIR_LGPL}"
touch "${OUTPUT_DIR_LGPL}"/configure.ac
gnulib/gnulib-tool --dir="${OUTPUT_DIR_LGPL}" --lib=libargp --libtool --import --lgpl argp
cp "${OUTPUT_DIR_LGPL}"/lib/*.{c,h} "${OUTPUT_DIR}"/gllib

echo "libargp output: ${OUTPUT_DIR}"

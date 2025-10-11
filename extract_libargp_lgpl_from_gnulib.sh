#!/bin/bash

set -e

git clone --branch stable-202507 https://git.savannah.gnu.org/git/gnulib.git gnulib

GIT_DESCRIBE=`git -C gnulib describe --always`
GIT_DATETIME=`git -C gnulib log -1 --format="%ct" | xargs -I{} date -d @{} +%Y%m%dT%H%M%S`
OUTPUT_DIR="libargp-${GIT_DESCRIBE}-${GIT_DATETIME}-lgpl"
mkdir -p "${OUTPUT_DIR}"

# Create minimal configure.ac
cat > "${OUTPUT_DIR}/configure.ac" <<'EOF'
AC_INIT([libargp], [1.0])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([glm4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([foreign -Wall])
AM_MAINTAINER_MODE([enable])
AC_PROG_CC
AC_PROG_RANLIB
gl_EARLY
LT_INIT([win32-dll])
gl_INIT
AC_CONFIG_FILES([Makefile gllib/Makefile])
AC_OUTPUT
EOF

# Create minimal Makefile.am
cat > "${OUTPUT_DIR}/Makefile.am" <<'EOF'
SUBDIRS = gllib
EOF

# Extract LGPL module source
gnulib/gnulib-tool --dir="${OUTPUT_DIR}" --lib=libargp --source-base=gllib --m4-base=glm4 --libtool --lgpl --import argp

# Generate build system for libargp and remove autotools cache
autoreconf --force --install --verbose "${OUTPUT_DIR}"
rm -rf "${OUTPUT_DIR}/autom4te.cache"

echo "libargp output: ${OUTPUT_DIR}"

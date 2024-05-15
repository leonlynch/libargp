libargp (Gnulib)
================

[![License: LGPL-2.1](https://img.shields.io/github/license/leonlynch/libargp)](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)<br/>
[![Ubuntu build](https://github.com/leonlynch/libargp/actions/workflows/ubuntu-build.yaml/badge.svg)](https://github.com/leonlynch/libargp/actions/workflows/ubuntu-build.yaml)<br/>
[![MacOS build](https://github.com/leonlynch/libargp/actions/workflows/macos-build.yaml/badge.svg)](https://github.com/leonlynch/libargp/actions/workflows/macos-build.yaml)<br/>
[![Windows build](https://github.com/leonlynch/libargp/actions/workflows/windows-build.yaml/badge.svg)](https://github.com/leonlynch/libargp/actions/workflows/windows-build.yaml)<br/>

This project provides various helpers for the extraction and use of libargp
from [Gnulib](https://www.gnu.org/software/gnulib/). It also contains an
extracted and patched copy of libargp such that it can easily be added as a
submodule to CMake projects.

Note that CMake will still invoke the generated autoconf/automake build
environment due to the many relevant platform tests, but won't regenerate the
autoconf/automake build environment on hosts without autoconf/automake tools.

The default branch represents the state of libargp that can be added to other
CMake projects while the `gnulib` branch represents the state of libargp after
extraction from [Gnulib](https://www.gnu.org/software/gnulib/) but before any
other patches have been applied.

Usage
-----

The `extract_libargp_lgpl_from_gnulib.sh` script can be used while in the
`gnulib` branch to clone the latest `gnulib`, extract the `libargp` build
environment, and extract the `libargp` module itself under LGPL. The output
directory can then be compared to the existing `src` directory to observe the
changes since the last extraction. The output directory can then replace the
existing `src` directory such that these changes reflect when committed to
Git. Note that the intention is for the `gnulib` branch to represent the state
of `libargp` exactly as it is extracted from `gnulib`. It can then be merged
to the default branch and the latter can be used to track changes beyond
`gnulib`.

Note that the autoconf, automake and libtool versions used during the above
extraction may influence the output and should be mentioned in the subsequent
Git message for future reference.

This CMake project can be added to CMake parent projects in various ways:
* As a submodule using the CMake `add_subdirectory()` command
* During the CMake configuration step using the CMake `FetchContent_Declare()`
  and `FetchContent_MakeAvailable()` commands
* During the CMake build step using the CMake `ExternalProject_Add()` command

License
-------

[Gnulib](https://www.gnu.org/software/gnulib/) is copyright [Free Software Foundation](https://www.fsf.org/)

Helpers in this project are copyright 2022-2024 [Leon Lynch](https://github.com/leonlynch).

This project is licensed under the terms of the LGPL v2.1 license. See LICENSE file.

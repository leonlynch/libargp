libargp (Gnulib)
================

[![License: LGPL-2.1](https://img.shields.io/github/license/leonlynch/libargp)](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)

This project provides various helpers for the extraction and use of libargp
from [Gnulib](https://www.gnu.org/software/gnulib/). It also contains an
extracted and patched copy of libargp such that it can easily be added as a
submodule to CMake projects.

Note that CMake will still invoke the generated autoconf/automake build
environment due to the many relevant platform tests, but won't regenerate the
autoconf/automake build environment on hosts without autoconf/automake tools.

The default branch represents the state of libargp that can be added to other
projects while the `gnulib` branch represents the state of libargp after
extraction from Gnulib but before any other patches have been applied.

Usage
-----

TODO: describe helpers here!

TODO: describe CMake use here!

License
-------

[Gnulib](https://www.gnu.org/software/gnulib/) is copyright (c) [Free Software Foundation](https://www.fsf.org/)

Helpers in this project are copyright (c) 2022 [Leon Lynch](https://github.com/leonlynch).

This project is licensed under the terms of the LGPL v2.1 license. See LICENSE file.

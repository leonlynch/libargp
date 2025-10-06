##############################################################################
# Copyright 2025 Leon Lynch
#
# This file is licensed under the terms of the LGPL v2.1 license.
# See LICENSE file.
##############################################################################

# This script is executed at build-time to invoke make with appropriate verbosity
# Arguments:
#   MAKE_PROGRAM - Path to make executable
#   WORKING_DIR  - Directory to run make in

# Check for verbose mode from various sources
# 1. CMAKE_VERBOSE_MAKEFILE (set at configure time)
# 2. VERBOSE environment variable (set by cmake --build --verbose for Makefile generator)
# 3. CMAKE_BUILD_VERBOSE (some generators)
if(CMAKE_VERBOSE_MAKEFILE OR "$ENV{VERBOSE}" STREQUAL "1" OR VERBOSE)
	set(MAKE_VERBOSE "V=1")
else()
	set(MAKE_VERBOSE "V=0")
endif()

# Execute make
execute_process(
	COMMAND ${MAKE_PROGRAM} ${MAKE_VERBOSE}
	WORKING_DIRECTORY ${WORKING_DIR}
	RESULT_VARIABLE result
)

if(NOT result EQUAL 0)
	message(FATAL_ERROR "make failed with exit code ${result}")
endif()

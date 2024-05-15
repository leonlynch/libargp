##############################################################################
# Copyright 2022, 2024 Leon Lynch
#
# This file is licensed under the terms of the LGPL v2.1 license.
# See LICENSE file.
##############################################################################

cmake_minimum_required(VERSION 3.16)

project(libargp
	VERSION 0.1
	DESCRIPTION "Hierarchical processing of command line arguments"
	LANGUAGES C
)

# Determine whether this project is the top-level project
if(${CMAKE_VERSION} VERSION_LESS "3.21")
	get_directory_property(LIBARGP_HAS_PARENT PARENT_DIRECTORY)
	if(NOT LIBARGP_HAS_PARENT)
		set(LIBARGP_IS_TOP_LEVEL True)
	endif()
else()
	# CMake >=3.21 provides <PROJECT-NAME>_IS_TOP_LEVEL
	set(LIBARGP_IS_TOP_LEVEL ${libargp_IS_TOP_LEVEL})
endif()

# Configure compiler
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS OFF)
if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	add_compile_options(-Wall)
	add_compile_options($<$<CONFIG:Debug>:-ggdb>)
	add_compile_options($<$<CONFIG:RelWithDebInfo>:-ggdb>)
endif()
if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
	add_compile_options(-Wall)
endif()
if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
	add_compile_options(-Wall)
endif()

message(CHECK_START "Configuring libargp...")

# Configure source and output directories
set(libargp_SOURCE_DIR ${PROJECT_SOURCE_DIR}/src)
set(libargp_BINARY_DIR ${PROJECT_BINARY_DIR}/src)
set(libargp_INCLUDE_DIR "${PROJECT_BINARY_DIR}/include")
set(libargp_LIB_DIR "${PROJECT_BINARY_DIR}/lib")
file(MAKE_DIRECTORY ${libargp_BINARY_DIR})
file(MAKE_DIRECTORY ${libargp_INCLUDE_DIR})
file(MAKE_DIRECTORY ${libargp_LIB_DIR})
file(COPY ${libargp_SOURCE_DIR}/gllib/argp.h ${PROJECT_SOURCE_DIR}/include/argp-config.h DESTINATION ${libargp_INCLUDE_DIR})

# Configure compiler for AppleClang
if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
	# The GCC flavour of AppleClang is required to build libargp
	set(libargp_CC_param "CC=/usr/bin/gcc")

	# Also set the appropriate -arch flags
	foreach(arch IN LISTS CMAKE_OSX_ARCHITECTURES)
		string(APPEND libargp_CFLAGS " -arch ${arch}")
	endforeach()
endif()

if(CMAKE_HOST_WIN32)
	# The CMake execute_process() command doesn't use a shell and therefore a
	# Bash-compatible shell must be invoked explicitly on a Windows host.
	set(libargp_SHELL "sh")

	# MSYS2 path mangling may confuse the configure script when it attempts to
	# determine the source directory, so convert and specify it explicitly
	# instead.
	find_program(cygpath_FOUND cygpath)
	if(cygpath_FOUND)
		execute_process(
			COMMAND cygpath -u ${PROJECT_SOURCE_DIR}/src
			OUTPUT_VARIABLE libargp_srcdir_param
		)
		string(PREPEND libargp_srcdir_param "--srcdir=")
	endif()
endif()

# Configure CFLAGS
string(APPEND libargp_CFLAGS " ${CMAKE_C_FLAGS}")
if(CMAKE_BUILD_TYPE STREQUAL Release OR CMAKE_BUILD_TYPE STREQUAL RelWithDebInfo)
	string(APPEND libargp_CFLAGS " ${CMAKE_C_FLAGS_RELEASE}")
endif()
if(CMAKE_BUILD_TYPE STREQUAL Debug OR CMAKE_BUILD_TYPE STREQUAL RelWithDebInfo)
	string(APPEND libargp_CFLAGS " ${CMAKE_C_FLAGS_DEBUG}")
endif()

# Configure libargp
string(STRIP ${libargp_CFLAGS} libargp_CFLAGS)
execute_process(
	COMMAND ${libargp_SHELL} ${libargp_SOURCE_DIR}/configure ${libargp_CC_param} CFLAGS=${libargp_CFLAGS} ${libargp_srcdir_param} --disable-maintainer-mode
	WORKING_DIRECTORY ${libargp_BINARY_DIR}
	COMMAND_ECHO STDOUT
)
if(NOT EXISTS ${libargp_BINARY_DIR}/Makefile)
	message(FATAL_ERROR "Error during libargp configuration")
endif()

message(CHECK_PASS "done")

set(libargp_LIBRARY "${libargp_BINARY_DIR}/gllib/.libs/libargp.a")
add_custom_command(
	OUTPUT ${libargp_LIBRARY}
	COMMAND make
	WORKING_DIRECTORY ${libargp_BINARY_DIR}
)
add_custom_target(libargp-target DEPENDS ${libargp_LIBRARY})

# Add library import and let it depend on the custom command above
add_library(libargp::argp STATIC IMPORTED GLOBAL)
add_dependencies(libargp::argp libargp-target)
set_target_properties(libargp::argp
	PROPERTIES
		IMPORTED_LOCATION "${libargp_LIBRARY}"
		INTERFACE_INCLUDE_DIRECTORIES "${libargp_INCLUDE_DIR}"
)

if(LIBARGP_IS_TOP_LEVEL)
	# Only top-level project should include CTest module
	include(CTest)

	# Simple compile test
	add_executable(test1 test/test1.c)
	target_link_libraries(test1 libargp::argp)
	add_test(NAME test1
		COMMAND test1 --help)
	set_tests_properties(test1
		PROPERTIES
			PASS_REGULAR_EXPRESSION "^Usage\:"
	)
endif()

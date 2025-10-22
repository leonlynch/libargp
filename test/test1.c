/**
 * @file test1.c
 *
 * Copyright 2022, 2025 Leon Lynch
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program. If not, see
 * <https://www.gnu.org/licenses/>.
 */

#include <string.h>
#include "argp.h"

#ifndef LIBARGP_STANDALONE_CONFIG
#error "Incorrect argp.h - this project's argp-config.h defines LIBARGP_STANDALONE_CONFIG"
#endif

// Command line options
struct cmdline_options_t {
	int foobob;
};

// Helper functions
static error_t argp_parser_helper(int key, char* arg, struct argp_state* state);

// argp option structure
static struct argp_option argp_options[] = {
	{ "foobob", 1, NULL, 0, "Do foobob" },
	{ "test-format", 2, NULL, 0, "Test argp_error() format attribute with %zu" },
	{ 0 },
};

// argp configuration
static struct argp argp_config = {
	argp_options,
	argp_parser_helper,
	NULL,
	" \v" // force the text to be after the options in the help message
	"The import (decoding/decrypting) and export (encoding/encrypting) options cannot be specified simultaneously.\n\n"
	"NOTE: All KEY values are strings of hex digits representing binary data.",
};

// argp parser helper function
static error_t argp_parser_helper(int key, char* arg, struct argp_state* state)
{
	struct cmdline_options_t* options;

	options = state->input;
	if (!options) {
		return ARGP_ERR_UNKNOWN;
	}

	switch (key) {
		case 1:
			options->foobob = 1;
			return 0;

		case 2: {
			// Test argp_error() with %zu format specifier to ensure that the
			// compiler allows C99 format specifiers. This mostly tests MinGW.
			size_t x = 12345;
			argp_error(state, "Test argp_error format specifiers: x=%zu", x);
			return 0;
		}

		case ARGP_KEY_END: {
			return 0;
		}

		default:
			return ARGP_ERR_UNKNOWN;
	}
}


int main(int argc, char** argv)
{
	int r;
	struct cmdline_options_t options;

	memset(&options, 0, sizeof(options));

	if (argc == 1) {
		// No command line options
		argp_help(&argp_config, stdout, ARGP_HELP_STD_HELP, argv[0]);
		return 1;
	}

	// Parse command line options
	r = argp_parse(&argp_config, argc, argv, ARGP_NO_EXIT, 0, &options);
	if (r) {
		fprintf(stderr, "Failed to parse command line\n");
		return 1;
	}

	return 0;
}

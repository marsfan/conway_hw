#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https: //mozilla.org/MPL/2.0/.
"""VUnit test runner script."""

from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

vu.add_vhdl_builtins()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.v")
lib.add_source_files("tests/*.v")
# Run vunit function
vu.main()

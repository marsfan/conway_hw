#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""VUnit test runner script."""

from vunit import VUnit

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

vu.add_vhdl_builtins()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.vhd")
lib.add_source_files("tests/*.vhd")
# Run vunit function
vu.main()

#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


# ghdl -a is analysis
# ghdl -e is elaboration (only needed for GCC or LLVM backends)
# ghdl -r is run simulation
# only -a expects the file extension

# TODO: Figure out best way to place testbenches in sub-directory?

# See https://ghdl.github.io/ghdl/quick_start/simulation/DLXModelSuite.html for better ideas on building large projects
# FIXME: Parallel build does not work. Seems to be a limitation of GHDL trying to write to the .cf file from multiple threads
GG=ghdl
# TODO: Update WSL system to newer ubuntu so that I can use --std=08
GFLAGS=--workdir=work --std=08
WAVEFORMDIR=waveforms


# All VHDL files
VHDL_FILES=$(wildcard *.vhd)

# All vhdl files whose stem ends with _tb (my notation for testbench)
TESTBENCHES=$(basename $(wildcard *_tb.vhd))

# All entities/configurations (excluding packages)
ALL_MODULES=$(basename $(VHDL_FILES))


.PHONY: all configure clean distclean testall runall test
.PHONY: $(addsuffix .run, $(ALL_MODULES))

# Build all modules
all: $(ALL_MODULES)

# Prepare for building with GHDL -m
configure:
	-mkdir work waveforms
	$(GG) -i $(GFLAGS) *.vhd

# FIXME: This should be clearer. Maybe in some fore of %: %.vhd
# See https://www.gnu.org/software/make/manual/make.html#Pattern-Rules
# See https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# Also the command `ghdl --gen-makefile`
# See https://stackoverflow.com/questions/6979897/how-can-one-compile-vhd-under-ghdl
# Build specified module
%: %.vhd
	$(GG) -m $(GFLAGS) $@

# Clean project
clean:
	$(GG) --clean $(GFLAGS)
	rm -f waveforms/*.ghw
	rm -rf vunit_out/test_output

# Clean and remove other artifacts
distclean: clean
	$(GG) --remove $(GFLAGS)
	rm -rf vunit_out

# Run all modules with GHDL
runall: $(addsuffix .run, $(ALL_MODULES))

# Run all testbenches with GHDL
testall: $(addsuffix .run, $(TESTBENCHES))

 # syntastic,summary

vsg:
	vsg -f $(VHDL_FILES) $(TEST) -ap -c vsg.json -of syntastic

test:
	python run.py --gtkwave-fmt=ghw

compiletest:
	python run.py --compile

# Run specified module with ghdl
$(addsuffix .run, $(ALL_MODULES)):
	$(GG) -r $(GFLAGS) $(basename $@) --wave=$(WAVEFORMDIR)/$(basename $@).ghw

# Open the specified waveform in gtkwave
$(addsuffix .waveform, $(ALL_MODULES)):
	gtkwave $(WAVEFORMDIR)/$(basename $@).ghw
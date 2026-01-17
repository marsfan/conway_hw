#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


VV=iverilog
VFLAGS=-g2012 -Wall -Wmacro-redefinition -Winfloop -Wsensitivity-entire-vector
# -Wfloating-nets


# All SystemVerilog files
VERILOG_FILES=$(wildcard *.sv)

# All SystemVerilog Testbench files
TESTBENCH_FILES=$(wildcard tests/*_tb.sv)

# All files whose stem ends with _tb (my notation for testbench)
TESTBENCHES=$(basename $(TESTBENCH_FILES))

# All entities/configurations (excluding packages)
ALL_MODULES=$(basename $(VERILOG_FILES))


.PHONY: all clean distclean test
.PHONY: $(addsuffix .run, $(ALL_MODULES))

# Build all modules
all:
	$(VV) $(VFLAGS) $(VERILOG_FILES)

# Pattern to build a single testbench from all SV files and the testbench file
tests/%_tb: tests/%_tb.sv
	mkdir -p bin
	$(VV) $(VFLAGS) $(VERILOG_FILES) $< -o bin/$(notdir $@).out

# Pattern to run a single testbench, and make it depend on building the testbench first
bin/%_tb: tests/%_tb
	mkdir -p waveforms
	$@.out

# Build all testbenches
testbench: $(TESTBENCHES)

# Clean project
clean:
	rm -rf waveforms
	rm -f *.out
	rm -rf bin

vsg:
	vsg -f $(VERILOG_FILES) $(TESTBENCH_FILES) $(TEST) -ap -c vsg.json -of syntastic

test: $(addprefix bin/,$(notdir $(TESTBENCHES)))

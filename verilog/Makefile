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

testbench:
	$(VV) $(VFLAGS) $(VERILOG_FILES) $(TESTBENCH_FILES) -o testbench.out
	mkdir -p waveforms

# Clean project
clean:
	rm -f waveforms/*.vcd
	rm -f *.out

vsg:
	vsg -f $(VERILOG_FILES) $(TESTBENCH_FILES) $(TEST) -ap -c vsg.json -of syntastic

test: testbench
	./testbench.out
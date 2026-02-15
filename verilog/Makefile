#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


VV=iverilog
VFLAGS=-g2012 -Wall -Wmacro-redefinition -Winfloop -Wsensitivity-entire-vector -Y.sv
# -Wfloating-nets

# Various directories we will use
BINDIR=bin
LIBDIR=.
TESTDIR=tests
WAVEFORMDIR=waveforms

# All SystemVerilog files
VERILOG_FILES=$(wildcard *.sv)

# All SystemVerilog Testbench files
TESTBENCH_FILES=$(wildcard $(TESTDIR)/*_tb.sv)

# All files whose stem ends with _tb (my notation for testbench)
TESTBENCHES=$(basename $(TESTBENCH_FILES))

TESTBENCH_OUT=$(basename $(subst $(TESTDIR)/,$(BINDIR)/,$(TESTBENCHES)))

# All entities/configurations (excluding packages)
ALL_MODULES=$(basename $(VERILOG_FILES))



.PHONY: all clean test testbench svlint

# Build all modules
all:
	$(VV) $(VFLAGS) $(VERILOG_FILES)

# Pattern to build a single testbench
$(BINDIR)/%_tb: $(TESTDIR)/%_tb.sv $(VERILOG_FILES)
	mkdir -p $(BINDIR)
	$(VV) $(VFLAGS) -I $(TESTDIR) -y $(LIBDIR) -o $@ $<

# Pattern to run a single testbench, and make it depend on building the testbench first
bin/%_tb.run: bin/%_tb
	mkdir -p $(WAVEFORMDIR)
	$<

# Build all testbenches
testbench: $(TESTBENCH_OUT)

# Clean project
clean:
	rm -rf $(WAVEFORMDIR)
	rm -rf $(BINDIR)

svlint:
	svlint $(LIBDIR)/*.sv $(TESTDIR)/*.sv --config .svlint.toml


test: $(addsuffix .run, $(TESTBENCH_OUT))

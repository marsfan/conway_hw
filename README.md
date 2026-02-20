# Conway's Game of Life, in Digital Logic

This is an implementation of Conway's game of life in digital logic.
It is currently still under heavy development.


## Repo Structure

- [logisim](./logisim/): This folder contains an implementation made with
  [logisim-evolution](https://github.com/logisim-evolution/logisim-evolution),
  as well as some Python scripts that help me automate making some tweaks to
  the diagrams.
- [vhdl](./vhdl): This contains the implementation in VHDL, as well as
  some helper scripts used for the VHDL implementation, and a Makefile that
  can be used to build and run tests for the VHDL implementation using GHDL
  and vunit
- [vhdl/tests](./vhdl/tests): Test benches for the VHDL implementation
- [verilog](./verilog) This contains the implementation in Verilog, as well as
  some helper scripts used for the Verilog implementation, and a Makefile that
  can be used to build and run tests for the Verilog implementation using iverilog
- [verilog/tests](./verilog/tests): Test benches for the Verilog implementation
- [conway_fpga_driver](./conway_fpga_driver/): This contains two things.
  - An Arduino program for driving an FPGA programming with the simulation
    and reading its output.
  - A desktop GUI (implemented in Python) for communicating with the Arduino.

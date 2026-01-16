/// Memory for the system

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module SYSTEM_MEMORY #(parameter data_size) (
        input [data_size-1:0] INITIAL_IN,   // Input from external word for initialization
        input [data_size-1:0] GRID_IN,      // Input from the grid calculator
        input WRITE_ENABLE,                 // Enable writing to memory
        input LOAD_RUN,                     // Whether we are in load mode or run mode. Used to select input to read from
        input CLK,                          // System clock
        input RESET,                        // Asynchronous reset.
        output reg [data_size-1:0] MEM_OUT  // Memory output
);

wire [data_size-1:0] MEM_IN;

// MUX to select input source
assign MEM_IN = LOAD_RUN ? GRID_IN : INITIAL_IN;

DFF #(data_size) memory (MEM_IN, WRITE_ENABLE, CLK, RESET, MEM_OUT);

endmodule
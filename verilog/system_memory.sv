/// Memory for the system

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module system_memory #(
    parameter int unsigned DATA_SIZE
) (
    input  wire [DATA_SIZE - 1:0] initial_in,   // Input from external word for initialization
    input  wire [DATA_SIZE - 1:0] grid_in,      // Input from the grid calculator
    input  wire                   write_enable, // Enable writing to memory
    input  wire                   load_run,     // Whether we are in load mode or run mode. Used to select input to read from
    input  wire                   clk,          // System clock
    input  wire                   reset,        // Asynchronous reset.
    output reg  [DATA_SIZE - 1:0] mem_out       // Memory output
);
/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

logic [DATA_SIZE - 1:0] mem_in;

// MUX to select input source
assign mem_in = load_run ? grid_in : initial_in;

dff #(DATA_SIZE) memory (
    .d(mem_in),
    .we(write_enable),
    .clk(clk),
    .reset(reset),
    .q(mem_out)
);

endmodule

`default_nettype wire

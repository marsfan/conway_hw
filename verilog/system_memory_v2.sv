/// Memory for the system.
/// V2 combines the memory with the serial input system, reducing the amount o
/// logic used.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module system_memory_v2 #(
    parameter int unsigned DATA_SIZE
) (
    input  wire [DATA_SIZE - 1:0] grid_in,   // Input from the grid calculator
    input  wire                   serial_in, // Serial input from external interface

    // If both are asserted, then RUN_MODE will take priority
    input  wire                   load_mode, // Indicates system is in load mode (i.e. load from serial)
    input  wire                   run_mode,  // Indcates system is in run mode (i.e. load from grid in)
    input  wire                   clk,       // System clock
    input  wire                   reset,     // Asynchronous reset.
    output reg  [DATA_SIZE - 1:0] data_out   // Memory output
);
/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

// Got this from here: https://vhdlwhiz.com/shift-register/
// Then ported to Verilog

always @(posedge clk, posedge reset) begin: shift_register_process
    if (reset) begin
        data_out <= 0;
    end else if (clk) begin
        if (run_mode) begin
            data_out <= grid_in;
        end else if (load_mode) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            data_out <= {data_out[$high(data_out) - 1:0], serial_in};
        end
    end
end

endmodule



`default_nettype wire

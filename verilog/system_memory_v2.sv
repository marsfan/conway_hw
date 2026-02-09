/// Memory for the system.
/// V2 combines the memory with the serial input system, reducing the amount o
/// logic used.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module system_memory_v2 #(parameter data_size)
(
    input wire [data_size-1:0] GRID_IN   ,// Input from the grid calculator
    input wire SERIAL_IN ,// Serial input from external interface

    // If both are asserted, then RUN_MODE will take priority
    input wire LOAD_MODE ,                     // Indicates system is in load mode (i.e. load from serial)
    input wire RUN_MODE,                       // Indcates system is in run mode (i.e. load from grid in)
    input wire CLK,                            // System clock
    input wire RESET,                          // Asynchronous reset.
    output reg [data_size-1:0]  DATA_OUT  // Memory output
);

// Got this from here: https://vhdlwhiz.com/shift-register/
// Then ported to Verilog

always @(posedge CLK, posedge RESET) begin : shift_register_process
    if (RESET) begin
        DATA_OUT <= 0;
    end else if (CLK) begin
        if (RUN_MODE) begin
            DATA_OUT <= GRID_IN;
        end else if (LOAD_MODE) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            DATA_OUT <= {DATA_OUT[$high(DATA_OUT) - 1:0], SERIAL_IN};
        end
    end
end

endmodule


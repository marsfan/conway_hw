/// Memory for the system.
/// V4 uses a single shift register for both input and outputs. To ensure
/// that data is kept event when reading out, during readout, the data is
/// shifted in a circular buffer, instead of being filled with zeros.
/// This means that reading data out MUST always be done in multiples of the
/// full data size, or the data in memory will be jumbled around between reads

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module system_memory_v4 #(
    parameter int unsigned DATA_SIZE = 64
) (
    // RUN_MODE has priority.
    // Then LOAD_MODE
    // Then OUTPUT_MODE
    input  wire [DATA_SIZE - 1:0] grid_in,         // Input from the grid calculator
    input  wire                   serial_in,       // Serial input from external interface
    input  wire                   load_mode,       // Indicates system is in load mode (i.e. load from serial)
    input  wire                   run_mode,        // Indcates system is in run mode (i.e. load from grid in)
    input  wire                   output_mode,     // Indicates system is in output mode (i.e. shift out over serial)
    input  wire                   clk,             // System clock
    input  wire                   reset,           // Asynchronous reset.
    output reg  [DATA_SIZE - 1:0] system_mem_out,  // Memory output for the system to use
    output reg                    serial_out       // Serial system output
);
/* svlint on keyword_forbidden_wire_reg */


always_ff @(posedge clk or posedge reset) begin: shift_register_process
    if (reset) begin
        system_mem_out <= 0;
        serial_out <= 0;
    end else if (clk) begin
        if (run_mode) begin
            system_mem_out <= grid_in;
        end else if (load_mode) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            system_mem_out <= {system_mem_out[$high(system_mem_out) - 1:0], serial_in};
        end else if (output_mode) begin
            // Push out the highest value
            serial_out <= system_mem_out[$high(system_mem_out)];

            // Rotate data around in a circular buffer
            system_mem_out <= {system_mem_out[$high(system_mem_out) - 1:0], system_mem_out[$high(system_mem_out)]};
        end
    end
end

endmodule

`default_nettype wire

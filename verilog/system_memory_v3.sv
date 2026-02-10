/// Memory for the system.
/// V3 has both the input and output shift registers here. This allows us to load
/// the output shift register from serial in as well, so that after load the
/// output register holds the current state, instead of having a "lag"

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module system_memory_v3 #(
    parameter int unsigned DATA_SIZE = 64
) (
    // RUN_MODE has priority.
    // Then LOAD_MODE
    // Then OUTPUT_MODE
    input  wire [DATA_SIZE - 1:0] grid_in,        // Input from the grid calculator
    input  wire                   serial_in,       // Serial input from external interface
    input  wire                   load_mode,       // Indicates system is in load mode (i.e. load from serial)
    input  wire                   run_mode,        // Indcates system is in run mode (i.e. load from grid in)
    input  wire                   output_mode,     // Indicates system is in output mode (i.e. shift out over serial)
    input  wire                   clk,             // System clock
    input  wire                   reset,           // Asynchronous reset.
    output reg  [DATA_SIZE - 1:0] system_mem_out , // Memory output for the system to use
    output reg                    serial_out       // Serial system output
);
/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

// Input shift register memory
logic [DATA_SIZE - 1:0] input_sr = 0;

// Output shift register memory
logic [DATA_SIZE - 1:0] output_sr = 0;

// Got this from here: https://vhdlwhiz.com/shift-register/
// TODO: Re-write as a single process (testing shows the same resource use when I do that)
always @(posedge clk, posedge reset) begin: input_shift_register_process
    if (reset) begin
        input_sr <= 0;
    end else if (clk) begin
        if (run_mode) begin
            input_sr <= grid_in;
        end else if (load_mode) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            input_sr <= {input_sr[$high(input_sr) - 1:0], serial_in};
        end
    end
end

always @(posedge clk, posedge reset) begin: output_shift_register_process
    if (reset) begin
        serial_out <= 0;
        output_sr <= 0;
    end else if (clk) begin
        if (run_mode) begin
            output_sr <= grid_in;
        end else if (load_mode) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            output_sr <= {output_sr[$high(output_sr) - 1:0], serial_in};
        end else if (output_mode) begin
            // Push out the highest value
            serial_out <= output_sr[$high(output_sr)];

            // Concatenate a zero with the upper 63 elements.
            // This means we have shifted everything down one bit, and shifted
            // in a zero at the top.
            output_sr <= {output_sr[$high(output_sr) - 1:0], 1'd0};
        end
    end
end

// Write input shift register to parallel output
assign system_mem_out = input_sr;

endmodule

`default_nettype wire

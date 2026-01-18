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

module SYSTEM_MEMORY_V3 #(parameter data_size = 64)
(
        // RUN_MODE has priority.
        // Then LOAD_MODE
        // Then OUTPUT_MODE
        input      [data_size-1:0] GRID_IN,         // Input from the grid calculator
        input                      SERIAL_IN,       // Serial input from external interface
        input                      LOAD_MODE,       // Indicates system is in load mode (i.e. load from serial)
        input                      RUN_MODE,        // Indcates system is in run mode (i.e. load from grid in)
        input                      OUTPUT_MODE,     // Indicates system is in output mode (i.e. shift out over serial)
        input                      CLK,             // System clock
        input                      RESET,           // Asynchronous reset.
        output reg [data_size-1:0] SYSTEM_MEM_OUT , // Memory output for the system to use
        output reg                 SERIAL_OUT // Serial system output
);

// Input shift register memory
reg [data_size-1:0] INPUT_SR = 0;

// Output shift register memory
reg [data_size-1:0] OUTPUT_SR = 0;

// Got this from here: https://vhdlwhiz.com/shift-register/
// TODO: Re-write as a single process (testing shows the same resource use when I do that)
always @(posedge CLK, posedge RESET) begin : input_shift_register_process
    if (RESET) begin
        INPUT_SR <= 0;
    end else if (CLK) begin
        if (RUN_MODE) begin
            INPUT_SR <= GRID_IN;
        end else if (LOAD_MODE) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            INPUT_SR <= {INPUT_SR[$high(INPUT_SR)-1:0], SERIAL_IN};
        end
    end
end

always @(posedge CLK, posedge RESET) begin : output_shift_register_process
    if (RESET) begin
        SERIAL_OUT <= 0;
        OUTPUT_SR <= 0;
    end else if (CLK) begin
        if (RUN_MODE) begin
            OUTPUT_SR <= GRID_IN;
        end else if (LOAD_MODE) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            OUTPUT_SR <= {OUTPUT_SR[$high(OUTPUT_SR)-1:0], SERIAL_IN};
        end else if (OUTPUT_MODE) begin
            // Push out the highest value
            SERIAL_OUT <= OUTPUT_SR[$high(OUTPUT_SR)];

            // Concatenate a zero with the upper 63 elements.
            // This means we have shifted everything down one bit, and shifted
            // in a zero at the top.
            OUTPUT_SR <= {OUTPUT_SR[$high(OUTPUT_SR)-1:0], 1'd0};
        end
    end
end

// Write input shift register to parallel output
assign SYSTEM_MEM_OUT = INPUT_SR;

endmodule
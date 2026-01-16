/// Memory for the system.
/// V4 uses a single shift register for both input and outputs. To ensure
/// that data is kept event when reading out, during readout, the data is
/// shifted in a circular buffer, instead of being filled with zeros.
/// This means that reading data out MUST always be done in multiples of the
/// full data size, or the data in memory will be jumbled around between reads

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module SYSTEM_MEMORY_V4 #(parameter data_size = 64)
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
    output reg [data_size-1:0] SYSTEM_MEM_OUT,  // Memory output for the system to use
    output reg [data_size-1:0] SERIAL_OUT       // Serial system output
);

always @(posedge CLK, posedge RESET) begin : shift_register_process
    if (RESET) begin
        SYSTEM_MEM_OUT <= 0;
        SERIAL_OUT <= 0;
    end else if (CLK) begin
        if (RUN_MODE) begin
            SYSTEM_MEM_OUT <= GRID_IN;
        end else if (LOAD_MODE) begin
            // Take a slice of the bottom 63 elements, and concatenate it with the new value
            // This means we have shifted everying up one bit, and shifted in the new value at the bottom
            SYSTEM_MEM_OUT <= {SYSTEM_MEM_OUT[$high(SYSTEM_MEM_OUT)-1:0], SERIAL_IN};
        end else if (OUTPUT_MODE) begin
            // Push out the highest value
            SERIAL_OUT <= SYSTEM_MEM_OUT[$high(SYSTEM_MEM_OUT)];

            // Rotate data around in a circular buffer
            SYSTEM_MEM_OUT <= {SYSTEM_MEM_OUT[$high(SYSTEM_MEM_OUT)-1:0], SYSTEM_MEM_OUT[$high(SYSTEM_MEM_OUT)]};
        end
    end
end

endmodule
/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
/// System memory where we can shift down row-by-row, inserting new row at top
/// time. Also has a second bank of registers for storing whatever row was just
/// shifted out from the bottom, which is needed for calculating
/// the next values for the current bottom row
/// NOTE: The mode selections follow a specific priority (larger number = higher priority)
///     1. load_mode
///     2. run_mode
///     3. output_mode

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module system_memory_by_row #(
    // FIXME: Static  assert that DATA_SIZE % ROW_SIZE = 0?
    parameter int unsigned DATA_SIZE = 64,
    parameter int unsigned ROW_SIZE = 8
) (
    input  wire                   load_mode,      ///< Set to shift all values up by 1, inserting new value at bottom
    input  wire                   run_mode,       ///< Set to shift all values down by ROW_SIZE, inserting new row at top
    input  wire                   output_mode,    ///< Set to circular shift all values up by 1, for reading data out serially
    input  wire                   serial_in,      ///< Value to insert at the bottom of memory when load_mode=1
    input  wire [ROW_SIZE - 1:0]  top_row_in,     ///< Row to insert at top of memory when run_mode=1
    input  wire                   reset,          ///< Asynchronous active low reset, setting all memory to 0
    input  wire                   clk,            ///< System clock
    output reg  [ROW_SIZE - 1:0]  prev_row,       ///< Row that was last shifted away when run_mode=1. Will be cleared if clocked when load_mode = 0
    output wire [DATA_SIZE - 1:0] parallel_out,   ///< Parallel output of all data in system memory (except prev_row)
    output wire                   serial_out      ///< Value at the very top of the system memory
);
/* svlint on keyword_forbidden_wire_reg */

logic [DATA_SIZE - 1:0] system_memory;

always_ff @(posedge clk or negedge reset) begin: shift_register_process
    if (!reset) begin
        system_memory <= 0;
        prev_row <= 0;
    end else if (clk) begin

        // localparam int high = $high(system_memory);

        if (load_mode) begin
            // Take slice of the bottom DATA_SIZE - 1 elements, concatenate new value
            /// at end, resulting in shifting values up and inserting new value at the bottom
            system_memory <= {system_memory[$high(system_memory) - 1:0], serial_in};

            // If we switched to load mode, we want to reset the prev_row for
            // new operations
            prev_row  <= 0;
        end else if (run_mode) begin
            /// Copy bottom row from memory into the prev_row registers
            prev_row <= system_memory[ROW_SIZE - 1:0];

            // Shift values down by ROW_SIZE,
            // and move new row from "top_row_in" into top of system memory
            system_memory <= {top_row_in, system_memory[$high(system_memory):ROW_SIZE]};
        end else if (output_mode) begin
            // Simply perform a upwards circular shift on the system memory
            system_memory <= {system_memory[$high(system_memory) - 1:0], system_memory[$high(system_memory)]};
        end
    end
end

// Assign serial and parallel outputs to the output signals
assign serial_out = system_memory[$high(system_memory)];
assign parallel_out = system_memory;


endmodule


`default_nettype wire

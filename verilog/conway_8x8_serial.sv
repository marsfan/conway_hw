/// 8x8 conway's game of life using serial input and output to save on IO

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module conway_8x8_serial (
    input  wire       data_in, // Serial data in
    input  wire [1:0] mode,    // System mode (00 = load, 01 = run, 10 = output, 11 = undefined) // TODO: Don't make undefined
    input  wire       reset,   // Asynchronous system reset
    input  wire       clk,     // System clock. // TODO: Separate clock for shift reg so they are faster?
    output wire       data_out // Serial data out
);

/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

localparam int unsigned GRID_WIDTH = 8;
localparam int unsigned GRID_HEIGHT = 8;
localparam int unsigned DATA_SIZE = GRID_WIDTH * GRID_HEIGHT;
// FIXME: Some sort of assert that W*H=DATA_SIZE

logic load_mode;  // High when mode = 00
logic run_mode;  // High when mode = 01
logic output_mode;  // High when mode = 10
logic stop_mode;  // High when mode = 11
logic load_or_run;  // High when mode = 00 or 01
logic [DATA_SIZE - 1:0] data_in_parallel;  // Input data in parallel form
logic [DATA_SIZE - 1:0] mem_out;  // Output from memory
logic [DATA_SIZE - 1:0] next_state;  // Output from cell calculation grid

decoder mode_decode(mode, stop_mode, load_mode, run_mode, output_mode);
assign load_or_run = load_mode || run_mode;

// Shift register for converting input from serial to parallel
serial_to_parallel #(DATA_SIZE) input_shift_reg(
    .data_in(data_in),
    .en(load_mode),
    .clk(clk),
    .rst(reset),
    .data(data_in_parallel)
);


// The system memory that we hold everything in between cycles
system_memory #(DATA_SIZE) memory(
    .initial_in(data_in_parallel),
    .grid_in(next_state),
    .write_enable(load_or_run),
    .load_run(run_mode),
    .clk(clk),
    .reset(reset),
    .mem_out(mem_out)
);

// Core calculation grid
cell_grid #(8, 8) grid (
    .input_state(mem_out),
    .next_state(next_state)
);

// Parallel to serial shift register
parallel_to_serial #(DATA_SIZE) output_shift_reg (
    .data_in(next_state),
    .load_en(load_or_run),
    .shift_en(output_mode),
    .clk(clk),
    .rst(reset),
    .data(data_out)
);

endmodule

`default_nettype wire

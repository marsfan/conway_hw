/// 8x8 conway's game of life using serial input and output to save on IO
/// This version uses two shift registers to allow for maintaining the
/// data in the system even when reading it out, and the single_row_processor
/// module to process one row per cycle.
/// As a result, it takes N+1 cycles to compute everything, where N is the
/// number of rows.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module conway_8x8_by_row(
    input  wire       data_in,   // Serial data in
    input  wire [1:0] mode,      // System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
    input  wire       reset,     // Async active low system reset
    input  wire       clk,       // System clock // TODO: Separate clocks for shift regs so they can run faster?
    output wire       data_out,  // Serial data out
    output wire       din_led,   // Data input LED for debugging
    output wire       clk_led,   // Data output LED for debugging
    output wire       dout_led,  // Data output LED for debugging
    output wire [1:0] mode_leds  // Mode LEDs for debugging
);
/* svlint on keyword_forbidden_wire_reg */

localparam int unsigned NUM_ROWS = 8;
localparam int unsigned NUM_COLS = 8;
localparam int unsigned DATA_SIZE = NUM_ROWS * NUM_COLS;

// Width needed to store (NUM_ROWS-1) in counter
// $clog2(N) is ceil(log2(N))
// See https://www.edaboard.com/threads/what-is-the-clog2-built-in-function-do-in-systemverilog.167892/
localparam int COUNTER_WIDTH = $clog2(NUM_ROWS);

// FIXME: Some sort of assert that W*H=DATA_SIZE


logic [COUNTER_WIDTH-1:0] row_count;            ///< Counter for tracking the row we are currently processing
logic [NUM_COLS-1:0]      row_new_state;        ///< New states for the currently active row
logic [NUM_COLS-1:0]      prev_row;             ///< Previous states for the row below the active row
logic [NUM_COLS-1:0]      next_row;             ///< Previous states for the row above the active row
logic [DATA_SIZE-1:0]     system_mem_parallel;  ///< Full set of states stored in system memory

system_counter #(NUM_ROWS) counter (
    .enable(mode == 2'b01),
    .reset(reset),
    .clk(clk),
    .count(row_count)
);

system_memory_by_row #(
    .DATA_SIZE(DATA_SIZE),
    .ROW_SIZE(NUM_COLS)
) memory (
    .load_mode(mode == 2'b00),
    .run_mode(mode == 2'b01),
    .output_mode(mode == 2'b10),
    .serial_in(data_in),
    .top_row_in(row_new_state),
    .reset(reset),
    .clk(clk),
    .prev_row(prev_row),
    .parallel_out(system_mem_parallel),
    .serial_out(data_out)
);

assign next_row = (row_count == COUNTER_WIDTH'(NUM_ROWS-1)) ? 0 : system_mem_parallel[(2*NUM_COLS)-1:NUM_COLS];

single_row_processor #(NUM_COLS) row_calculator (
    .prev_row(prev_row),
    .this_row(system_mem_parallel[NUM_COLS-1:0]),
    .next_row(next_row),
    .is_alive(row_new_state)
);

// LED Routing
assign din_led = data_in;
assign clk_led = clk;
assign dout_led = data_out;
assign mode_leds = mode;

endmodule


`default_nettype wire

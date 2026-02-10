/// 8x8 conway's game of life using serial input and output to save on IO
/// V2 uses system_memory_v2 instead of separate system memory and input shift register

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module conway_8x8_serial_v2 (
    input  wire       data_in,   // Serial data in
    input  wire [1:0] mode,      // System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
    input  wire       reset,     // Async system reset
    input  wire       clk,       // System clock // TODO: Separate clocks for shift regs so they can run faster?
    output wire       data_out,  // Serial data out
    output wire       din_led,   // Data input LED for debugging
    output wire       clk_led,   // Data output LED for debugging
    output wire       dout_led,  // Data output LED for debugging
    output wire [1:0] mode_leds  // Mode LEDs for debugging
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
logic [DATA_SIZE - 1:0] mem_out;  // Output from memory
logic [DATA_SIZE - 1:0] next_state;  // Output from cell calculation grid
logic serial_out;


decoder mode_decode(mode, stop_mode, load_mode, run_mode, output_mode);
assign load_or_run = load_mode || run_mode;

// The system memory that we hold everything in between cycles
system_memory_v2 #(DATA_SIZE) memory (
    .grid_in(next_state),
    .serial_in(data_in),
    .load_mode(load_mode),
    .run_mode(run_mode),
    .clk(clk),
    .reset(reset),
    .data_out(mem_out)
);

// Core calculation system
cell_grid #(GRID_WIDTH, GRID_HEIGHT) grid (
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
    .data(serial_out)
);

// Main output
assign data_out = serial_out;

// LED Routing
assign din_led = data_in;
assign clk_led = clk;
assign dout_led = serial_out;
assign mode_leds = mode;


endmodule

`default_nettype wire

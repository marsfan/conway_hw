/// 8x8 conway's game of life using serial input and output to save on IO
/// V2 uses system_memory_v2 instead of separate system memory and input shift register

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module CONWAY_8X8_SERIAL_V2 (
    input        DATA_IN,   // Serial data in
    input [1:0]  MODE,      // System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
    input        RESET,     // Async system reset
    input        CLK,       // System clock // TODO: Separate clocks for shift regs so they can run faster?
    output       DATA_OUT,  // Serial data out
    output       DIN_LED,   // Data input LED for debugging
    output       CLK_LED,   // Data output LED for debugging
    output       DOUT_LED,  // Data output LED for debugging
    output [1:0] MODE_LEDS  // Mode LEDs for debugging
);

localparam DATA_SIZE = 64;
localparam GRID_WIDTH = 8;
localparam GRID_HEIGHT = 8;
// FIXME: Some sort of assert that W*H=DATA_SIZE

wire LOAD_MODE;  // High when mode = 00
wire RUN_MODE;  // High when mode = 01
wire OUTPUT_MODE;  // High when mode = 10
wire STOP_MODE;  // High when mode = 11
wire LOAD_OR_RUN;  // High when mode = 00 or 01
wire [DATA_SIZE - 1:0] MEM_OUT;  // Output from memory
wire [DATA_SIZE - 1:0] NEXT_STATE;  // Output from cell calculation grid
wire SERIAL_OUT;


DECODER mode_decode(MODE, STOP_MODE, LOAD_MODE, RUN_MODE, OUTPUT_MODE);
assign LOAD_OR_RUN = LOAD_MODE || RUN_MODE;

// The system memory that we hold everything in between cycles
SYSTEM_MEMORY_V2 #(DATA_SIZE) memory (
    .GRID_IN(NEXT_STATE),
    .SERIAL_IN(DATA_IN),
    .LOAD_MODE(LOAD_MODE),
    .RUN_MODE(RUN_MODE),
    .CLK(CLK),
    .RESET(RESET),
    .DATA_OUT(MEM_OUT)
);

assign LOAD_OR_RUN = LOAD_MODE || RUN_MODE;

// Core calculation system
CELL_GRID #(GRID_WIDTH, GRID_HEIGHT) grid (
    .INPUT_STATE(MEM_OUT),
    .NEXT_STATE(NEXT_STATE)
);

// Parallel to serial shift register
PARALLEL_TO_SERIAL #(DATA_SIZE) output_shift_reg (
    .DATA_IN(NEXT_STATE),
    .LOAD_EN(LOAD_OR_RUN),
    .SHIFT_EN(OUTPUT_MODE),
    .CLK(CLK),
    .RST(RESET),
    .DATA(SERIAL_OUT)
);

// Main output
assign DATA_OUT = SERIAL_OUT;

// LED Routing
assign DIN_LED = DATA_IN;
assign CLK_LED = CLK;
assign DOUT_LED = SERIAL_OUT;
assign MODE_LEDS = MODE;


endmodule
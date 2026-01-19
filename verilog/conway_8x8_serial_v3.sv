/// 8x8 conway's game of life using serial input and output to save on IO
/// V3 uses system_memory_v3 instead of separate system memory, input shift register, and output shift register

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module CONWAY_8X8_SERIAL_V3 (
    input wire        DATA_IN,   // Serial data in
    input wire [1:0]  MODE,      // System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
    input wire        RESET,     // Async system reset
    input wire        CLK,       // System clock // TODO: Separate clocks for shift regs so they can run faster?
    output wire       DATA_OUT,  // Serial data out
    output wire       DIN_LED,   // Data input LED for debugging
    output wire       CLK_LED,   // Data output LED for debugging
    output wire       DOUT_LED,  // Data output LED for debugging
    output wire [1:0] MODE_LEDS  // Mode LEDs for debugging
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
SYSTEM_MEMORY_V3 #(DATA_SIZE) memory (
    .GRID_IN(NEXT_STATE),
    .SERIAL_IN(DATA_IN),
    .LOAD_MODE(LOAD_MODE),
    .RUN_MODE(RUN_MODE),
    .OUTPUT_MODE(OUTPUT_MODE),
    .CLK(CLK),
    .RESET(RESET),
    .SYSTEM_MEM_OUT(MEM_OUT),
    .SERIAL_OUT(SERIAL_OUT)
);

// Core calculation system
CELL_GRID #(GRID_WIDTH, GRID_HEIGHT) grid (
    .INPUT_STATE(MEM_OUT),
    .NEXT_STATE(NEXT_STATE)
);


// Main output
assign DATA_OUT = SERIAL_OUT;

// LED Routing
assign DIN_LED = DATA_IN;
assign CLK_LED = CLK;
assign DOUT_LED = SERIAL_OUT;
assign MODE_LEDS = MODE;


endmodule
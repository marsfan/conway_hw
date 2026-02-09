/// 8x8 conway's game of life using serial input and output to save on IO

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module conway_8x8_serial (
    input wire       DATA_IN, // Serial data in
    input wire [1:0] MODE,    // System mode (00 = load, 01 = run, 10 = output, 11 = undefined) // TODO: Don't make undefined
    input wire       RESET,   // Asynchronous system reset
    input wire       CLK,     // System clock. // TODO: Separate clock for shift reg so they are faster?
    output wire      DATA_OUT // Serial data out
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
wire [DATA_SIZE - 1:0] DATA_IN_PARALLEL;  // Input data in parallel form
wire [DATA_SIZE - 1:0] MEM_OUT;  // Output from memory
wire [DATA_SIZE - 1:0] NEXT_STATE;  // Output from cell calculation grid

decoder mode_decode(MODE, STOP_MODE, LOAD_MODE, RUN_MODE, OUTPUT_MODE);
assign LOAD_OR_RUN = LOAD_MODE || RUN_MODE;

// Shift register for converting input from serial to parallel
serial_to_parallel #(DATA_SIZE) input_shift_reg(
    .DATA_IN(DATA_IN),
    .EN(LOAD_MODE),
    .CLK(CLK),
    .RST(RESET),
    .DATA(DATA_IN_PARALLEL)
);


// The system memory that we hold everything in between cycles
system_memory #(DATA_SIZE) memory(
    .INITIAL_IN(DATA_IN_PARALLEL),
    .GRID_IN(NEXT_STATE),
    .WRITE_ENABLE(LOAD_OR_RUN),
    .LOAD_RUN(RUN_MODE),
    .CLK(CLK),
    .RESET(RESET),
    .MEM_OUT(MEM_OUT)
);

// Core calculation grid
cell_grid #(8, 8) grid (
    .INPUT_STATE(MEM_OUT),
    .NEXT_STATE(NEXT_STATE)
);

// Parallel to serial shift register
parallel_to_serial #(DATA_SIZE) output_shift_reg (
    .DATA_IN(NEXT_STATE),
    .LOAD_EN(LOAD_OR_RUN),
    .SHIFT_EN(OUTPUT_MODE),
    .CLK(CLK),
    .RST(RESET),
    .DATA(DATA_OUT)
);

endmodule
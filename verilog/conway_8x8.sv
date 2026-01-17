/// 8X8 conway's game of life implementation

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module CONWAY_8X8 (
    input [63:0]  INITIAL_STATE ,   // Input state to load system with
    input         CLK,              // System Clock
    input         CLK_EN,           // Gate for enabling clock to system
    input         LOAD_RUN,         // Whether to load memory from initial state, or start running
    input  [63:0] CURRENT_STATE,    // Output for displaying the state currently in memory
    output [63:0] NEXT_STATE        // Output for displaying the next state to put into memory
);

wire GATED_CLK;
wire [63:0] MEM_IN;
wire [63:0] MEM_OUT;
wire [63:0] GRID_IN;
wire [63:0] GRID_OUT;

assign GATED_CLK = CLK & CLK_EN;
assign MEM_IN = LOAD_RUN ? GRID_OUT : INITIAL_STATE;

DFF #(64) memory (
    .d(MEM_IN),
    .we(1'd1),
    .clk(GATED_CLK),
    .reset(1'd0),
    .q(MEM_OUT)
);

assign GRID_IN = LOAD_RUN ? MEM_OUT : INITIAL_STATE;

CELL_GRID #(8,8) grid (
    .INPUT_STATE(GRID_IN),
    .NEXT_STATE(GRID_OUT)
);

assign CURRENT_STATE = GRID_IN;
assign NEXT_STATE = GRID_OUT;


endmodule
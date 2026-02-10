/// 8X8 conway's game of life implementation

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module conway_8x8 (
    input  wire [63:0] initial_state,   // Input state to load system with
    input  wire        clk,              // System Clock
    input  wire        clk_en,           // Gate for enabling clock to system
    input  wire        load_run,         // Whether to load memory from initial state, or start running
    output wire [63:0] current_state,    // Output for displaying the state currently in memory
    output wire [63:0] next_state        // Output for displaying the next state to put into memory
);

logic gated_clk;
logic [63:0] mem_in;
logic [63:0] mem_out;
logic [63:0] grid_in;
logic [63:0] grid_out;

assign gated_clk = clk & clk_en;
assign mem_in = load_run ? grid_out : initial_state;

dff #(64) memory (
    .d(mem_in),
    .we(1'd1),
    .clk(gated_clk),
    .reset(1'd0),
    .q(mem_out)
);

assign grid_in = load_run ? mem_out : initial_state;

cell_grid #(8,8) grid (
    .input_state(grid_in),
    .next_state(grid_out)
);

assign current_state = grid_in;
assign next_state = grid_out;


endmodule

`default_nettype wire

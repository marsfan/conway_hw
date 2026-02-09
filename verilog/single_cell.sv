/// Logic for computing next value of a single cell in the system.
/// There are 4 rules for computing the next state of the cell
///  1. If currently alive and less than 2 neighbors alive, dies (underpopulation)
///  2. If currently alive and 2 or 3 neighbors, lives
///  3. If currently alive and more than 3 neighbors, dies (overpopulation)
///  4. If currently dead and exactly three neighbors alive, lives (reproduction)
///
/// Since are computing when alive, we can just check rules 2 and 4. And assume all
/// other conditions are dead

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module single_cell(
    input wire ME,
    input wire N,
    input wire NE,
    input wire E,
    input wire SE,
    input wire S,
    input wire SW,
    input wire W,
    input wire NW,
    output wire IS_ALIVE
);

wire [3:0] ALIVE_NEIGHBORS; //Number of neighbors that are alive.
wire ALIVE_NEIGHBORS_2;     // Number of alive neighbors is 2
wire ALIVE_NEIGHBORS_3;     // Number of alive neighbors is 3
wire RULE_2_ALIVE;          // Whether or not we live as per rule 2
wire RULE_4_ALIVE;          // Whether or not we live as per rule 4

// Count number of living neighbors
popcount counter(N, NE, E, SE, S, SW, W, NW, ALIVE_NEIGHBORS);

// Check if number of neighbors is 2 or 3
assign ALIVE_NEIGHBORS_2 = (ALIVE_NEIGHBORS == 2) ? 1 : 0;
assign ALIVE_NEIGHBORS_3 = (ALIVE_NEIGHBORS == 3) ? 1 : 0;

// Evaluating rules 2 and 4
assign RULE_2_ALIVE = (ALIVE_NEIGHBORS_2 | ALIVE_NEIGHBORS_3) & ME;
assign RULE_4_ALIVE = ALIVE_NEIGHBORS_3 & ~ME;

// If either rule is alive, then we are alive
assign IS_ALIVE = RULE_2_ALIVE | RULE_4_ALIVE;

endmodule
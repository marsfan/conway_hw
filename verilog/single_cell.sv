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
    input  wire me,
    input  wire n,
    input  wire ne,
    input  wire e,
    input  wire se,
    input  wire s,
    input  wire sw,
    input  wire w,
    input  wire nw,
    output wire is_alive
);

logic [3:0] alive_neighbors;   //Number of neighbors that are alive.
logic       alive_neighbors_2; // Number of alive neighbors is 2
logic       alive_neighbors_3; // Number of alive neighbors is 3
logic       rule_2_alive;      // Whether or not we live as per rule 2
logic       rule_4_alive;      // Whether or not we live as per rule 4

// Count number of living neighbors
popcount counter(
    .n(n),
    .ne(ne),
    .e(e),
    .se(se),
    .s(s),
    .sw(sw),
    .w(w),
    .nw(nw),
    .count(alive_neighbors)
);

// Check if number of neighbors is 2 or 3
assign alive_neighbors_2 = (alive_neighbors == 2) ? 1 : 0;
assign alive_neighbors_3 = (alive_neighbors == 3) ? 1 : 0;

// Evaluating rules 2 and 4
assign rule_2_alive = (alive_neighbors_2 | alive_neighbors_3) & me;
assign rule_4_alive = alive_neighbors_3 & ~me;

// If either rule is alive, then we are alive
assign is_alive = rule_2_alive | rule_4_alive;

endmodule

`default_nettype wire

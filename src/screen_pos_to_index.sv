/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */

module screen_pos_to_index #(
    parameter int unsigned SCREEN_WIDTH = 640,
    parameter int unsigned SCREEN_HEIGHT = 480,
    // parameter int unsigned CELL_WIDTH = 80,
    // parameter int unsigned CELL_HEIGHT = 60,
    parameter int unsigned NUM_ROWS = 8,
    parameter int unsigned NUM_COLS = 8
) (
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output wire  [9:0] index
);
/* svlint on keyword_forbidden_wire_reg */

// FIXME: Have these widths be calculated by the positions

logic [9:0] display_cell_x;
logic [9:0] display_cell_y;
logic [9:0] index_tmp;
// FIXME: Find math that can be done with nothing but bitshifts.
assign display_cell_x = pix_x / (SCREEN_WIDTH / NUM_COLS);
assign display_cell_y = pix_y / (SCREEN_HEIGHT / NUM_ROWS);
assign index_tmp = display_cell_x * NUM_COLS + display_cell_y;

assign index = index_tmp[9:0];

endmodule




`default_nettype wire

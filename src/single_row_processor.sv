/// Logic for a single row of conway cells

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off keyword_forbidden_wire_reg */
module single_row_processor #(
    parameter int unsigned SIZE = 8
)(
    input  wire [SIZE - 1:0] prev_row,
    input  wire [SIZE - 1:0] this_row,
    input  wire [SIZE - 1:0] next_row,
    output wire [SIZE - 1:0] is_alive
);
/* svlint on keyword_forbidden_wire_reg */

// Create a connection to the i+1 element of a row
// if doing so would go out of bounds for the row
// Otherwise, set to zero
function automatic create_above (
    input integer i,
    input logic [SIZE - 1:0] row
);
    if (i >= (SIZE - 1)) begin
        create_above = 0;
    end else begin
        create_above = row[i + 1];
    end
endfunction

// Create a connection to the i-1 element of a row
// if doing so would go out of bounds for the row
// Otherwise, set to zero
function automatic create_below (
    input integer i,
    input logic [SIZE - 1:0] row
);
    if (i <= 0) begin
        create_below = 0;
    end else begin
        create_below = row[i - 1];
    end
endfunction


for (genvar i = (SIZE - 1); i >= 0; i--) begin: row_gen
    single_cell c(
        .me(this_row[i]),
        .n(prev_row[i]),
        .ne(create_above(i, prev_row)),
        .e(create_above(i, this_row)),
        .se(create_above(i, next_row)),
        .s(next_row[i]),
        .sw(create_below(i, next_row)),
        .w(create_below(i, this_row)),
        .nw(create_below(i, prev_row)),
        .is_alive(is_alive[i])
    );
end


endmodule


`default_nettype wire
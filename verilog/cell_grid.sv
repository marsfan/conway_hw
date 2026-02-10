/// Grid of cell calculators for the entire system

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module cell_grid #(
    parameter int unsigned GRID_WIDTH = 8,
    parameter int unsigned GRID_HEIGHT = 8
) (
    input  wire [(GRID_WIDTH * GRID_HEIGHT) - 1:0] input_state,
    output wire [(GRID_WIDTH * GRID_HEIGHT) - 1:0] next_state
);
/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

function automatic create_connection(
    input [(GRID_WIDTH * GRID_HEIGHT) - 1:0] input_array,
    input integer x,
    input integer y
);
    begin

        if ((x >= 0) && (y >= 0) && (x < GRID_WIDTH) && (y < GRID_HEIGHT)) begin
            create_connection = input_array[(GRID_WIDTH * y) + x];
        end else begin
            create_connection = 0;
        end
    end
endfunction

// For some reason, starting at high and going down uses 2 less LUTS than
// going up
// TODO: Find out why
for (genvar x = (GRID_WIDTH - 1); x >= 0; x--) begin: x_axis
    for (genvar y = (GRID_HEIGHT - 1); y >= 0; y--) begin: y_axis
        single_cell c(
            .me(input_state[GRID_WIDTH * y + x]),
            .n(create_connection(input_state,  x,     y - 1)),
            .ne(create_connection(input_state, x + 1, y - 1)),
            .e(create_connection(input_state,  x + 1, y)),
            .se(create_connection(input_state, x + 1, y + 1)),
            .s(create_connection(input_state,  x,     y + 1)),
            .sw(create_connection(input_state, x - 1, y + 1)),
            .w(create_connection(input_state,  x - 1, y)),
            .nw(create_connection(input_state, x - 1, y - 1)),
            .is_alive(next_state[GRID_WIDTH * y + x])
        );
    end
end



endmodule

`default_nettype wire

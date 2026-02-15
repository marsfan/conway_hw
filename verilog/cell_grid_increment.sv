/// Grid of cell calculators for the entire system

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off keyword_forbidden_wire_reg */
module cell_grid_increment #(
    parameter int unsigned GRID_WIDTH = 8,
    parameter int unsigned GRID_HEIGHT = 8
)
(
    input  wire [(GRID_WIDTH * GRID_HEIGHT) - 1:0] input_state,
    output wire [(GRID_WIDTH * GRID_HEIGHT) - 1:0] next_state
);
/* svlint on keyword_forbidden_wire_reg */

function automatic create_connection(
    input [(GRID_WIDTH * GRID_HEIGHT) - 1:0] INPUT_ARRAY,
    input integer X,
    input integer Y
);
    begin

        if ((X >= 0) && (Y >= 0) && (X < GRID_WIDTH) && (Y < GRID_HEIGHT)) begin
            create_connection = INPUT_ARRAY[(GRID_WIDTH * Y) + X];
        end else begin
            create_connection = 0;
        end
    end
endfunction


// For some reason, starting at high and going down uses 2 less LUTS than going up
// TODO: Find out why
for (genvar x = 0; x < GRID_WIDTH; x++) begin: x_axis
    for (genvar y = 0; y < GRID_HEIGHT; y++) begin: y_axis
        single_cell c(
            input_state[GRID_WIDTH * y + x],
            create_connection(input_state, x,     y - 1),
            create_connection(input_state, x + 1, y - 1),
            create_connection(input_state, x + 1, y),
            create_connection(input_state, x + 1, y + 1),
            create_connection(input_state, x,     y + 1),
            create_connection(input_state, x - 1, y + 1),
            create_connection(input_state, x - 1, y),
            create_connection(input_state, x - 1, y - 1),
            next_state[GRID_WIDTH * y + x]
        );
    end
end


endmodule

`default_nettype wire
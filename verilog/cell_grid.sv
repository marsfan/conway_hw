/// Grid of cell calculators for the entire system

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module cell_grid #(
    parameter GRID_WIDTH = 8,
    parameter GRID_HEIGHT = 8
)
(
    input wire [(GRID_WIDTH * GRID_HEIGHT)-1:0] INPUT_STATE,
    output wire [(GRID_WIDTH * GRID_HEIGHT)-1:0] NEXT_STATE
);

function create_connection(
    input [(GRID_WIDTH * GRID_HEIGHT)-1:0] INPUT_ARRAY,
    input integer X,
    input integer Y
);
    begin

        if ((X >= 0) && (Y >=0) && (X < GRID_WIDTH) && (Y < GRID_HEIGHT)) begin
            create_connection = INPUT_ARRAY[(GRID_WIDTH * Y) + X];
        end else begin
            create_connection = 0;
        end
    end
endfunction

genvar x;
genvar y;
// For some reason, starting at high and going down uses 2 less LUTS than going up
// TODO: Find out why
generate for (x = (GRID_WIDTH-1); x >= 0; x--) begin
    for (y = (GRID_HEIGHT-1); y >= 0; y--) begin
        single_cell c(
            INPUT_STATE[GRID_WIDTH * y + x],
            create_connection(INPUT_STATE, x,     y - 1),
            create_connection(INPUT_STATE, x + 1, y - 1),
            create_connection(INPUT_STATE, x + 1, y),
            create_connection(INPUT_STATE, x + 1, y + 1),
            create_connection(INPUT_STATE, x,     y + 1),
            create_connection(INPUT_STATE, x - 1, y + 1),
            create_connection(INPUT_STATE, x - 1, y),
            create_connection(INPUT_STATE, x - 1, y - 1),
            NEXT_STATE[GRID_WIDTH * y + x]
        );
    end
end
endgenerate


endmodule
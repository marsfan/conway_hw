/// This is a counter used to control whether we are calculating rows, or
/// if it is time to push the data from the output memory back into the
/// input memory

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module system_counter #(
    parameter int NUM_ROWS = 8
) (
    input  wire enable,      ///< Enable the counter. Also, when low, will reset the counter to 0
    input  wire reset,       ///< Reset the counter (active low)
    input  wire clk,         ///< Clock
    output reg [WIDTH-1:0] count        ///< Counter current value
);
/* svlint on keyword_forbidden_wire_reg */

// Width needed to store (NUM_ROWS-1)
// $clog2(N) is ceil(log2(N))
// See https://www.edaboard.com/threads/what-is-the-clog2-built-in-function-do-in-systemverilog.167892/
localparam int WIDTH = $clog2(NUM_ROWS);


logic should_reset;
assign should_reset = !reset;

always_ff @(posedge clk or posedge should_reset) begin: counter_process
    if (should_reset) begin
        count <= 0;
    end else if (clk) begin
        if (count == WIDTH'(NUM_ROWS-1) || enable == 0) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end


endmodule


`default_nettype wire

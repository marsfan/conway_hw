/// Parallel to serial shift register

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module parallel_to_serial #(
    parameter int unsigned DATA_SIZE = 64
) (
    input  wire [DATA_SIZE - 1:0] data_in,  // Parallel input
    input  wire                   load_en,  // Enables loading data in in parallel
    input  wire                   shift_en,  // Enables shifting data out serially
    input  wire                   clk,  // Clock in
    input  wire                   rst,  // Asynchronous Reset
    output reg                    data  // Serial data out.
);
/* svlint on keyword_forbidden_wire_reg */
/* svlint on style_keyword_datatype */

logic [DATA_SIZE - 1:0] sr_tmp = 0;

always @(posedge clk, posedge rst) begin: shift_register_process
    if (rst) begin
        data <= 0;
        sr_tmp <= 0;
    end else if (clk) begin
        if (load_en) begin
            sr_tmp <= data_in;
        end else if (shift_en) begin
            // Push out the lowest value.
            data <= sr_tmp[$low(sr_tmp)];

            // Concatenate a zero with upper 63 elements
            // This means we have shifted everything down one bit, and shifted
            // in a zero at the top.
            sr_tmp <= {1'b0, sr_tmp[$high(sr_tmp):($low(sr_tmp) + 1)]};
        end
    end
end

endmodule

`default_nettype wire

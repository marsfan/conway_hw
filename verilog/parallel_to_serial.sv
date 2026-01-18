/// Parallel to serial shift register

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module PARALLEL_TO_SERIAL #(parameter data_size = 64)
(
    input [data_size-1:0] DATA_IN,  // Parallel input
    input LOAD_EN,                  // Enables loading data in in parallel
    input SHIFT_EN,                 // Enables shifting data out serially
    input CLK,                      // Clock in
    input RST,                      // Asynchronous Reset
    output reg DATA                 // Serial data out.
);

reg [data_size - 1:0] SR_TMP = 0;

always @(posedge CLK, posedge RST) begin : shift_register_process
    if (RST) begin
        DATA <= 0;
        SR_TMP <= 0;
    end else if (CLK) begin
        if (LOAD_EN) begin
            SR_TMP <= DATA_IN;
        end else if (SHIFT_EN) begin
            // Push out the lowest value.
            DATA <= SR_TMP[$high(SR_TMP)];

            // Concatenate a zero with upper 63 elements
            // This means we have shifted everything down one bit, and shifted
            // in a zero at the top.
            SR_TMP <= {1'b0, SR_TMP[$high(SR_TMP):($low(SR_TMP)+1)]};
        end
    end
end

endmodule
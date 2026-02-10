/// Simple register with reset capability
/// Inputs:
/// * D: Register value input
/// * WE: Register Write Enable
/// * CLK: Clock Input
/// * RESET: Reset Control
/// Outputs:
/// Q: Register Output
/// On rising edge, the value of Q will be set to the value of D if WE is true.
/// Any time RESET is set to true, the value of Q will be set to 0

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module dff #(
    parameter int unsigned SIZE = 1
)(
    input  wire [SIZE - 1:0] d,
    input  wire              we,
    input  wire              clk,
    input  wire              reset,
    output reg  [SIZE - 1:0] q
);


    // parameter SIZE = 1;

    // input we, clk, reset;
    // input [SIZE-1:0] d;
    // output reg [SIZE-1:0] q;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            if (we) begin
                q <= d;
            end
        end
    end

endmodule

`default_nettype wire
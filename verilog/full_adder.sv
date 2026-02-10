/// A single bit full adder

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module full_adder (
    input  wire a,
    input  wire b,
    input  wire c_in,
    output wire sum,
    output wire carry
);

assign sum = a ^ b ^ c_in;
assign carry = (a & b) | (a & c_in) | (b & c_in);

endmodule

`default_nettype wire

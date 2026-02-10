/// Full adder that takes in 2x1bit values, returns 2 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module full_adder_1_bit_to_2_bit(
    input  wire       a,
    input  wire       b,
    output wire [1:0] sum
);

full_adder adder(
    .a(a),
    .b(b),
    .c_in(1'b0),
    .sum(sum[0]),
    .carry(sum[1])
);

endmodule

`default_nettype wire

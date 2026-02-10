/// Adder that takes in 2x2bit values and returns 3 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module full_adder_2_bit_to_3_bit(
    input  wire [1:0] a,
    input  wire [1:0] b,
    output wire [2:0] sum
);

logic carry_int;

full_adder first_adder(
    .a(a[0]),
    .b(b[0]),
    .c_in(1'b0),
    .sum(sum[0]),
    .carry(carry_int)
);
full_adder second_adder(
    .a(a[1]),
    .b(b[1]),
    .c_in(carry_int),
    .sum(sum[1]),
    .carry(sum[2])
);

endmodule

`default_nettype wire

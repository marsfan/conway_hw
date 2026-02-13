/// Adder that takes in 2x3bit values and returns 4 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module full_adder_3_bit_to_4_bit(
    input  wire [2:0] a,
    input  wire [2:0] b,
    output wire [3:0] sum
);
/* svlint on keyword_forbidden_wire_reg */


logic carry_int_1;
logic carry_int_2;

full_adder first_adder(
    .a(a[0]),
    .b(b[0]),
    .c_in(1'b0),
    .sum(sum[0]),
    .carry(carry_int_1)
);
full_adder second_adder(
    .a(a[1]),
    .b(b[1]),
    .c_in(carry_int_1),
    .sum(sum[1]),
    .carry(carry_int_2)
);
full_adder third_adder(
    .a(a[2]),
    .b(b[2]),
    .c_in(carry_int_2),
    .sum(sum[2]),
    .carry(sum[3])
);

endmodule

`default_nettype wire

/// Adder that takes in 2x3bit values and returns 4 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module full_adder_3_bit_to_4_bit(
    input wire [2:0] A,
    input wire [2:0] B,
    output wire [3:0] SUM
);

wire CARRY_INT_1;
wire CARRY_INT_2;

full_adder first_adder(A[0], B[0], 1'b0, SUM[0], CARRY_INT_1);
full_adder second_adder(A[1], B[1], CARRY_INT_1, SUM[1], CARRY_INT_2);
full_adder third_adder(A[2], B[2], CARRY_INT_2, SUM[2], SUM[3]);

endmodule
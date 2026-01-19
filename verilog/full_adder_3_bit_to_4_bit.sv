/// Adder that takes in 2x3bit values and returns 4 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module FULL_ADDER_3_BIT_TO_4_BIT(
    input wire [2:0] A,
    input wire [2:0] B,
    output wire [3:0] SUM
);

wire CARRY_INT_1;
wire CARRY_INT_2;

FULL_ADDER first_adder(A[0], B[0], 1'b0, SUM[0], CARRY_INT_1);
FULL_ADDER second_adder(A[1], B[1], CARRY_INT_1, SUM[1], CARRY_INT_2);
FULL_ADDER third_adder(A[2], B[2], CARRY_INT_2, SUM[2], SUM[3]);

endmodule
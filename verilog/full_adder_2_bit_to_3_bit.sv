/// Adder that takes in 2x2bit values and returns 3 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module FULL_ADDER_2_BIT_TO_3_BIT(
    input [1:0] A,
    input [1:0] B,
    output [2:0] SUM
);

wire CARRY_INT;

FULL_ADDER first_adder(A[0], B[0], 1'b0, SUM[0], CARRY_INT);
FULL_ADDER second_adder(A[1], B[1], CARRY_INT, SUM[1], SUM[2]);

endmodule
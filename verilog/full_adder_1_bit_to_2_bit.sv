/// Full adder that takes in 2x1bit values, returns 2 bit sum

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module FULL_ADDER_1_BIT_TO_2_BIT(
    input A,
    input B,
    output [1:0] SUM
);

FULL_ADDER adder(A, B, 1'b0, SUM[0], SUM[1]);

endmodule
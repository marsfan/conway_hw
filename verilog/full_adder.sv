/// A single bit full adder

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module FULL_ADDER (
    input A,
    input B,
    input C_IN,
    output SUM,
    output CARRY
);

assign SUM = A ^ B ^ C_IN;
assign CARRY = (A & B) | (A & C_IN) | (B & C_IN);

endmodule
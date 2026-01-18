/// Simple 4 output decoder

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module DECODER(
    input [1:0] VAL_IN,
    output reg VAL_00,
    output reg VAL_01,
    output reg VAL_10,
    output reg VAL_11
);

assign VAL_00 = VAL_IN == 2'b00 ? 1 : 0;
assign VAL_01 = VAL_IN == 2'b01 ? 1 : 0;
assign VAL_10 = VAL_IN == 2'b10 ? 1 : 0;
assign VAL_11 = VAL_IN == 2'b11 ? 1 : 0;

endmodule
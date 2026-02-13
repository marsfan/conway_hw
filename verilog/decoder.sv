/// Simple 4 output decoder

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module decoder(
    input  wire [1:0] val_in,
    output wire       val_00,
    output wire       val_01,
    output wire       val_10,
    output wire       val_11
);
/* svlint on keyword_forbidden_wire_reg */


assign val_00 = val_in == 2'b00 ? 1 : 0;
assign val_01 = val_in == 2'b01 ? 1 : 0;
assign val_10 = val_in == 2'b10 ? 1 : 0;
assign val_11 = val_in == 2'b11 ? 1 : 0;

endmodule

`default_nettype wire

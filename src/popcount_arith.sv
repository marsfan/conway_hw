/// Count how many of the bits are set
/// This version uses arithmetic operators (i.e. '+') to simplify the file.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module popcount_arith(
    input  wire       n,
    input  wire       ne,
    input  wire       e,
    input  wire       se,
    input  wire       s,
    input  wire       sw,
    input  wire       w,
    input  wire       nw,
    output wire [3:0] count
);
/* svlint on keyword_forbidden_wire_reg */



// Sum all the inputs

logic [7:0] vec;
assign vec = {n, ne, e, se, s, sw, w, nw};
assign count = $countones(vec);

endmodule

`default_nettype wire

/// Count how many of the bits are set
/// This version uses arithmetic operators (i.e. '+') to simplify the file.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

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


// Extend inputs to all be 4 bits wide.
logic [3:0] n_ext;
logic [3:0] ne_ext;
logic [3:0] e_ext;
logic [3:0] se_ext;
logic [3:0] s_ext;
logic [3:0] sw_ext;
logic [3:0] w_ext;
logic [3:0] nw_ext;

assign n_ext  = {3'b000, n};
assign ne_ext = {3'b000, ne};
assign e_ext  = {3'b000, e};
assign se_ext = {3'b000, se};
assign s_ext  = {3'b000, s};
assign sw_ext = {3'b000, sw};
assign w_ext  = {3'b000, w};
assign nw_ext = {3'b000, nw};

// Sum all the inputs

assign count = n_ext + ne_ext + e_ext + se_ext + s_ext + sw_ext + w_ext + nw_ext;

endmodule

`default_nettype wire
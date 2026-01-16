/// Count how many of the bits are set
/// This version uses arithmetic operators (i.e. '+') to simplify the file.

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module POPCOUNT_ARITH(
    input        N,
    input        NE,
    input        E,
    input        SE,
    input        S,
    input        SW,
    input        W,
    input        NW,
    output [3:0] COUNT
);


// Extend inputs to all be 4 bits wide.
wire [3:0] N_EXT ;
wire [3:0] NE_EXT;
wire [3:0] E_EXT ;
wire [3:0] SE_EXT;
wire [3:0] S_EXT ;
wire [3:0] SW_EXT;
wire [3:0] W_EXT ;
wire [3:0] NW_EXT;

assign N_EXT  = {3'b000,  N};
assign NE_EXT = {3'b000,  NE};
assign E_EXT  = {3'b000,  E};
assign SE_EXT = {3'b000,  SE};
assign S_EXT  = {3'b000,  S};
assign SW_EXT = {3'b000,  SW};
assign W_EXT  = {3'b000,  W};
assign NW_EXT = {3'b000,  NW};

// Sum all the inputs

assign COUNT = N_EXT + NE_EXT + E_EXT + SE_EXT + S_EXT + SW_EXT + W_EXT + NW_EXT;

endmodule
/// Count how many of the bits are set

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module POPCOUNT(
    input wire        N,
    input wire        NE,
    input wire        E,
    input wire        SE,
    input wire        S,
    input wire        SW,
    input wire        W,
    input wire        NW,
    output wire [3:0] COUNT
);

// Intermediate signals for the 2 bit values

wire [1:0] SUM_1_TO_2_1;
wire [1:0] SUM_1_TO_2_2;
wire [1:0] SUM_1_TO_2_3;
wire [1:0] SUM_1_TO_2_4;

// Intermediate signals for the 3 bit values
wire [2:0] SUM_2_TO_3_1;
wire [2:0] SUM_2_TO_3_2;

    // First stage adders
    FULL_ADDER_1_BIT_TO_2_BIT adder_1_to_2_1(N, NE, SUM_1_TO_2_1);
    FULL_ADDER_1_BIT_TO_2_BIT adder_1_to_2_2(E, SE, SUM_1_TO_2_2);
    FULL_ADDER_1_BIT_TO_2_BIT adder_1_to_2_3(S, SW, SUM_1_TO_2_3);
    FULL_ADDER_1_BIT_TO_2_BIT adder_1_to_2_4(W, NW, SUM_1_TO_2_4);

    // Second stage adders
    FULL_ADDER_2_BIT_TO_3_BIT adder_2_to_3_1(SUM_1_TO_2_1, SUM_1_TO_2_2, SUM_2_TO_3_1);
    FULL_ADDER_2_BIT_TO_3_BIT adder_2_to_3_2(SUM_1_TO_2_3, SUM_1_TO_2_4, SUM_2_TO_3_2);

    // Third stage adder
    FULL_ADDER_3_BIT_TO_4_BIT adder_3_to_4(SUM_2_TO_3_1, SUM_2_TO_3_2, COUNT);


endmodule
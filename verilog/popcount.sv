/// Count how many of the bits are set

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off style_keyword_datatype */
/* svlint off keyword_forbidden_wire_reg */
module popcount(
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
/* svlint on style_keyword_datatype */

// Intermediate signals for the 2 bit values

logic [1:0] sum_1_to_2_1;
logic [1:0] sum_1_to_2_2;
logic [1:0] sum_1_to_2_3;
logic [1:0] sum_1_to_2_4;

// Intermediate signals for the 3 bit values
logic [2:0] sum_2_to_3_1;
logic [2:0] sum_2_to_3_2;

    // First stage adders
    full_adder_1_bit_to_2_bit adder_1_to_2_1(
        .a(n),
        .b(ne),
        .sum(sum_1_to_2_1)
    );
    full_adder_1_bit_to_2_bit adder_1_to_2_2(
        .a(e),
        .b(se),
        .sum(sum_1_to_2_2)
    );
    full_adder_1_bit_to_2_bit adder_1_to_2_3(
        .a(s),
        .b(sw),
        .sum(sum_1_to_2_3)
    );
    full_adder_1_bit_to_2_bit adder_1_to_2_4(
        .a(w),
        .b(nw),
        .sum(sum_1_to_2_4)
    );

    // Second stage adders
    full_adder_2_bit_to_3_bit adder_2_to_3_1(
        .a(sum_1_to_2_1),
        .b(sum_1_to_2_2),
        .sum(sum_2_to_3_1)
    );
    full_adder_2_bit_to_3_bit adder_2_to_3_2(
        .a(sum_1_to_2_3),
        .b(sum_1_to_2_4),
        .sum(sum_2_to_3_2)
    );

    // Third stage adder
    full_adder_3_bit_to_4_bit adder_3_to_4(
        .a(sum_2_to_3_1),
        .b(sum_2_to_3_2),
        .sum(count)
    );


endmodule

`default_nettype wire

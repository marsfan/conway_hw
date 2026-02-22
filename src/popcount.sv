/// Count how many of the bits are set

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


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


    // Intermediate signals for the 2 bit values

    logic [1:0] sum_1_to_2_1;
    logic [1:0] sum_1_to_2_2;
    logic [1:0] sum_1_to_2_3;

    // Intermediate signals for the 3 bit values
    logic [2:0] sum_2_to_3_1;

    // Note: Carry in can be used as a way to add a single 1 bit value
    // to an arbitrary N bit value. We can use this to reduce the
    // number of 1-bit adders in the first stage.



    // First stage adders
    full_adder_extending #(1) adder_1 (
        .a(n),
        .b(ne),
        .c_in(e),
        .sum(sum_1_to_2_1)
    );

    full_adder_extending #(1) adder_2 (
        .a(se),
        .b(s),
        .c_in(sw),
        .sum(sum_1_to_2_2)
    );

    // Second stage adders
    full_adder_extending #(2) adder_2_to_3(
        .a(sum_1_to_2_1),
        .b(sum_1_to_2_2),
        .c_in(nw),
        .sum(sum_2_to_3_1)
    );

    // Third stage adder
    full_adder_extending #(3) adder_3_to_4(
        .a(sum_2_to_3_1),
        .b(3'b0),
        .c_in(w),
        .sum(count)
    );



endmodule

`default_nettype wire

/// A single bit full adder, where the output is a 2 bit vector instead of
/// separate sum and carry outputs

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module full_adder_bit_extend (
    input  wire       a,
    input  wire       b,
    input  wire       c,
    output wire [1:0] sum
);
  /* svlint on keyword_forbidden_wire_reg */

    full_adder adder(
        .a(a),
        .b(b),
        .c_in(c),
        .sum(sum[0]),
        .carry(sum[1])
    );


endmodule

`default_nettype wire

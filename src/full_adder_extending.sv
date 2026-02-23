/// Full adder that takes in 2 N bit wide values and returns a value of N+1 bits wide

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none

/* svlint off keyword_forbidden_wire_reg */
module full_adder_extending #(
    parameter int unsigned INPUT_SIZE = 1
)(
    input  wire [INPUT_SIZE - 1:0] a,
    input  wire [INPUT_SIZE - 1:0] b,
    input  wire                    c_in,
    output wire [INPUT_SIZE:0]     sum
);
/* svlint on keyword_forbidden_wire_reg */

    logic [INPUT_SIZE - 1:0] intermediate;

    // For a full adder, sum is a ^ b ^ c_in
    // and carry out is (a & b) | (a & c_in) | (b & c_in);
    // So we just need to do that for each stage, passing carry in from
    // one to the next

    // First bit full adder
    assign sum[0] = a[0] ^ b[0] ^ c_in;
    assign intermediate[0] = (a[0] & b[0]) | (a[0] & c_in) | (b[0] & c_in);

    for (genvar i = 1; i < INPUT_SIZE; i++) begin: upper_bits

        assign sum[i] = a[i] ^ b[i] ^ intermediate[i - 1];
        assign intermediate[i] = (a[i] & b[i]) | (a[i] & intermediate[i - 1]) | (b[i] & intermediate[i - 1]);
    end

  assign sum[INPUT_SIZE] = intermediate[INPUT_SIZE - 1];

endmodule

`default_nettype wire

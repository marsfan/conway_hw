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


full_adder adder (
    .a(a[0]),
    .b(b[0]),
    .c_in(c_in),
    .sum(sum[0]),
    .carry(intermediate[0])
);

for (genvar i = 1; i < INPUT_SIZE; i++) begin
    full_adder adder(
        .a(a[i]),
        .b(b[i]),
        .c_in(intermediate[i - 1]),
        .sum(sum[i]),
        .carry(intermediate[i])
    );
end

  assign sum[INPUT_SIZE] = intermediate[INPUT_SIZE - 1];

endmodule

`default_nettype wire

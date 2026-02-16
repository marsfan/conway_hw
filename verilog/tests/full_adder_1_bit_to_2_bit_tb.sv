/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none
`include "tests/test_utils.svh"


module full_adder_1_bit_to_2_bit_tb();

    logic a;
    logic b;
    logic [1:0] sum;

    full_adder_1_bit_to_2_bit dut(
        .a(a),
        .b(b),
        .sum(sum)
    );

    initial begin


        // Configure to dump variables to VCD file
        $dumpfile("waveforms/full_adder_1_bit_to_2_bit_tb.vcd");
        $dumpvars(0, full_adder_1_bit_to_2_bit_tb);

        a = 0;
        b = 0;
        #1 `CHECK_EQ(sum, 0, "sum 00");

        a = 1;
        b = 0;
        #1 `CHECK_EQ(sum, 1, "sum 01");

        a = 0;
        b = 1;
        #1 `CHECK_EQ(sum, 1, "sum 01 v2");

        a = 1;
        b = 1;
        #1 `CHECK_EQ(sum, 2, "sum 10");

    end

endmodule

`default_nettype wire

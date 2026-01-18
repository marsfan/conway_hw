/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none
`include "tests/test_utils.sv"


module full_adder_1_bit_to_2_bit_tb();

    logic A;
    logic B;
    logic [1:0] SUM;

    FULL_ADDER_1_BIT_TO_2_BIT dut(
        .A(A),
        .B(B),
        .SUM(SUM)
    );

    initial begin
        int errcount;
        errcount = 0;


        // Configure to dump variables to VCD file
        $dumpfile("waveforms/full_adder_1_bit_to_2_bit_tb.vcd");
        $dumpvars(0, full_adder_1_bit_to_2_bit_tb);

        A <= 0;
        B <= 0;
        #1 `CHECK_EQ(SUM, 0, errcount, "SUM 00");

        A <= 1;
        B <= 0;
        #1 `CHECK_EQ(SUM, 1, errcount, "SUM 01");

        A <= 0;
        B <= 1;
        #1 `CHECK_EQ(SUM, 1, errcount, "SUM 01 v2");

        A <= 1;
        B <= 1;
        #1 `CHECK_EQ(SUM, 2, errcount, "SUM 10");

        `STOP_IF_ERR(errcount);
    end

endmodule

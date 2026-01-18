/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`include "tests/test_utils.sv"
module decoder_tb();

    reg [1:0] VAL_IN;
    reg       VAL_00;
    reg       VAL_01;
    reg       VAL_10;
    reg       VAL_11;

    DECODER dut(
        .VAL_IN(VAL_IN),
        .VAL_00(VAL_00),
        .VAL_01(VAL_01),
        .VAL_10(VAL_10),
        .VAL_11(VAL_11)
    );

    initial begin
        int errcount;
        errcount = 0;
        // Configure to dump variables to VCD file
        $dumpfile("waveforms/decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        VAL_IN <= 2'b00;
        #1
        `CHECK_EQ(VAL_00, 1, errcount, "VAL_00 Wrong for VAL_IN = 2'b00");
        `CHECK_EQ(VAL_01, 0, errcount, "VAL_01 Wrong for VAL_IN = 2'b00");
        `CHECK_EQ(VAL_10, 0, errcount, "VAL_10 Wrong for VAL_IN = 2'b00");
        `CHECK_EQ(VAL_11, 0, errcount, "VAL_11 Wrong for VAL_IN = 2'b00");

        VAL_IN <= 2'b01;
        #1
        `CHECK_EQ(VAL_00, 0, errcount, "VAL_00 Wrong for VAL_IN = 2'b01");
        `CHECK_EQ(VAL_01, 1, errcount, "VAL_01 Wrong for VAL_IN = 2'b01");
        `CHECK_EQ(VAL_10, 0, errcount, "VAL_10 Wrong for VAL_IN = 2'b01");
        `CHECK_EQ(VAL_11, 0, errcount, "VAL_11 Wrong for VAL_IN = 2'b01");

        VAL_IN <= 2'b10;
        #1
        `CHECK_EQ(VAL_00, 0, errcount, "VAL_00 Wrong for VAL_IN = 2'b10");
        `CHECK_EQ(VAL_01, 0, errcount, "VAL_01 Wrong for VAL_IN = 2'b10");
        `CHECK_EQ(VAL_10, 1, errcount, "VAL_10 Wrong for VAL_IN = 2'b10");
        `CHECK_EQ(VAL_11, 0, errcount, "VAL_11 Wrong for VAL_IN = 2'b10");

        VAL_IN <= 2'b11;
        #1
        `CHECK_EQ(VAL_00, 0, errcount, "VAL_00 Wrong for VAL_IN = 2'b11");
        `CHECK_EQ(VAL_01, 0, errcount, "VAL_01 Wrong for VAL_IN = 2'b11");
        `CHECK_EQ(VAL_10, 0, errcount, "VAL_10 Wrong for VAL_IN = 2'b11");
        `CHECK_EQ(VAL_11, 1, errcount, "VAL_11 Wrong for VAL_IN = 2'b11");

        // Final fatal to ensure tb exits with a nonzero return code
        `STOP_IF_ERR(errcount);

    end


endmodule
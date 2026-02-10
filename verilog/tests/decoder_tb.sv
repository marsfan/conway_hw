/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none
`include "tests/test_utils.svh"

module decoder_tb();

    reg [1:0] val_in;
    reg       val_00;
    reg       val_01;
    reg       val_10;
    reg       val_11;

    decoder dut(
        .val_in(val_in),
        .val_00(val_00),
        .val_01(val_01),
        .val_10(val_10),
        .val_11(val_11)
    );

    initial begin
        int errcount;
        errcount = 0;
        // Configure to dump variables to VCD file
        $dumpfile("waveforms/decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        val_in <= 2'b00;
        #1
        `CHECK_EQ(val_00, 1, errcount, "val_00 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_01, 0, errcount, "val_01 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_10, 0, errcount, "val_10 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_11, 0, errcount, "val_11 Wrong for val_in = 2'b00");

        val_in <= 2'b01;
        #1
        `CHECK_EQ(val_00, 0, errcount, "val_00 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_01, 1, errcount, "val_01 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_10, 0, errcount, "val_10 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_11, 0, errcount, "val_11 Wrong for val_in = 2'b01");

        val_in <= 2'b10;
        #1
        `CHECK_EQ(val_00, 0, errcount, "val_00 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_01, 0, errcount, "val_01 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_10, 1, errcount, "val_10 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_11, 0, errcount, "val_11 Wrong for val_in = 2'b10");

        val_in <= 2'b11;
        #1
        `CHECK_EQ(val_00, 0, errcount, "val_00 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_01, 0, errcount, "val_01 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_10, 0, errcount, "val_10 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_11, 1, errcount, "val_11 Wrong for val_in = 2'b11");

        // Final fatal to ensure tb exits with a nonzero return code
        `STOP_IF_ERR(errcount);

    end


endmodule
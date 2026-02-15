/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/
`default_nettype none
`include "tests/test_utils.svh"

module decoder_tb();

    logic [1:0] val_in;
    logic       val_00;
    logic       val_01;
    logic       val_10;
    logic       val_11;

    decoder dut(
        .val_in(val_in),
        .val_00(val_00),
        .val_01(val_01),
        .val_10(val_10),
        .val_11(val_11)
    );

    initial begin
        // Configure to dump variables to VCD file
        $dumpfile("waveforms/decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        val_in <= 2'b00;
        #1
        `CHECK_EQ(val_00, 1, "val_00 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_01, 0, "val_01 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_10, 0, "val_10 Wrong for val_in = 2'b00");
        `CHECK_EQ(val_11, 0, "val_11 Wrong for val_in = 2'b00");

        val_in <= 2'b01;
        #1
        `CHECK_EQ(val_00, 0, "val_00 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_01, 1, "val_01 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_10, 0, "val_10 Wrong for val_in = 2'b01");
        `CHECK_EQ(val_11, 0, "val_11 Wrong for val_in = 2'b01");

        val_in <= 2'b10;
        #1
        `CHECK_EQ(val_00, 0, "val_00 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_01, 0, "val_01 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_10, 1, "val_10 Wrong for val_in = 2'b10");
        `CHECK_EQ(val_11, 0, "val_11 Wrong for val_in = 2'b10");

        val_in <= 2'b11;
        #1
        `CHECK_EQ(val_00, 0, "val_00 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_01, 0, "val_01 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_10, 0, "val_10 Wrong for val_in = 2'b11");
        `CHECK_EQ(val_11, 1, "val_11 Wrong for val_in = 2'b11");

        // Final fatal to ensure tb exits with a nonzero return code

    end


endmodule

`default_nettype wire
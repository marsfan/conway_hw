/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

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
        // Configure to dump variables to VCD file
        $dumpfile("waveforms/decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        VAL_IN <= 2'b00;
        #1
        assert(VAL_00 == 1) else $error("VAL_00 Wrong for VAL_IN = 2'b00");
        assert(VAL_01 == 0) else $error("VAL_01 Wrong for VAL_IN = 2'b00");
        assert(VAL_10 == 0) else $error("VAL_10 Wrong for VAL_IN = 2'b00");
        assert(VAL_11 == 0) else $error("VAL_11 Wrong for VAL_IN = 2'b00");

        VAL_IN <= 2'b01;
        #1
        assert(VAL_00 == 0) else $error("VAL_00 Wrong for VAL_IN = 2'b01");
        assert(VAL_01 == 1) else $error("VAL_01 Wrong for VAL_IN = 2'b01");
        assert(VAL_10 == 0) else $error("VAL_10 Wrong for VAL_IN = 2'b01");
        assert(VAL_11 == 0) else $error("VAL_11 Wrong for VAL_IN = 2'b01");

        VAL_IN <= 2'b10;
        #1
        assert(VAL_00 == 0) else $error("VAL_00 Wrong for VAL_IN = 2'b10");
        assert(VAL_01 == 0) else $error("VAL_01 Wrong for VAL_IN = 2'b10");
        assert(VAL_10 == 1) else $error("VAL_10 Wrong for VAL_IN = 2'b10");
        assert(VAL_11 == 0) else $error("VAL_11 Wrong for VAL_IN = 2'b10");

        VAL_IN <= 2'b11;
        #1
        assert(VAL_00 == 0) else $error("VAL_00 Wrong for VAL_IN = 2'b11");
        assert(VAL_01 == 0) else $error("VAL_01 Wrong for VAL_IN = 2'b11");
        assert(VAL_10 == 0) else $error("VAL_10 Wrong for VAL_IN = 2'b11");
        assert(VAL_11 == 1) else $error("VAL_11 Wrong for VAL_IN = 2'b11");

    end


endmodule
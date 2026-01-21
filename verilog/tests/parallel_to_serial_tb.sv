/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module parallel_to_serial_tb();
    localparam int DEPTH = 3;

    logic [DEPTH-1:0] DATA_IN;
    logic LOAD_EN;
    logic SHIFT_EN;
    logic CLK;
    logic RST;
    logic DATA;

    PARALLEL_TO_SERIAL #(DEPTH) dut(
        .DATA_IN(DATA_IN),
        .LOAD_EN(LOAD_EN),
        .SHIFT_EN(SHIFT_EN),
        .CLK(CLK),
        .RST(RST),
        .DATA(DATA)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/parallel_to_serial_tb.vcd");
        $dumpvars(0, parallel_to_serial_tb);

        DATA_IN <= 3'd0;
        LOAD_EN <= 0;
        SHIFT_EN <= 0;
        RST <= 0;

        // RReset system
        RST <= 1;
        #1
        RST <= 0;
        `RUN_CLOCK(CLK, 10);

        // Load bytes
        LOAD_EN <= 1;
        DATA_IN <= 3'b011;
        `RUN_CLOCK(CLK, 10);
        `CHECK_EQ(DATA, 0, errcount, "Loaded bytes");

        // Test we just get zeros if SHIFT_EN is not set
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "SHIFT_EN unset 1");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "SHIFT_EN unset 2");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "SHIFT_EN unset 3");

        // Test we read bytes out as expected
        // Setting LOAD_EN to 0 means that even though we
        // changed DATA_IN, we persist what's in the shift reg
        LOAD_EN  <= 0;
        DATA_IN  <= 3'b000;
        SHIFT_EN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 1, errcount, "First byte out correct");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 1, errcount, "Second byte out correct");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Third byte out correct");

        // Test that we just get zeros if we keep trying
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero 1");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero 2");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero 3");

        // Test that if we load then reset, there's nothing in the shift reg
        SHIFT_EN <= 0;
        LOAD_EN  <= 1;
        DATA_IN  <= 3'b111;
        `RUN_CLOCK(CLK, 20);

        LOAD_EN <= 0;
        DATA_IN <= 3'b000;
        RST     <= 1;
        #1
        RST     <= 0;

        SHIFT_EN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after reset 1");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after reset 2");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after reset 3");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after reset 4");

        // Test that if LOAD_EN is zero, data is not loaded
        LOAD_EN  <= 0;
        SHIFT_EN <= 0;
        DATA_IN  <= 3'b111;
        `RUN_CLOCK(CLK, 20);

        DATA_IN  <= 3'b000;
        SHIFT_EN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after LOAD_EN = 0 1");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after LOAD_EN = 0 2");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after LOAD_EN = 0 3");
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 0, errcount, "Got zero after LOAD_EN = 0 4");

        `STOP_IF_ERR(errcount);
    end

endmodule
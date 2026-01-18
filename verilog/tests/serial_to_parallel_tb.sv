/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.sv"

module serial_to_parallel_tb();

    localparam DEPTH = 3;

    logic DATA_IN;
    logic EN;
    logic CLK;
    logic RST;
    logic [DEPTH-1:0] DATA;

    SERIAL_TO_PARALLEL #(DEPTH) dut (
        .DATA_IN(DATA_IN),
        .EN(EN),
        .CLK(CLK),
        .RST(RST),
        .DATA(DATA)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/serial_to_parallel_tb.vcd");
        $dumpvars(0, serial_to_parallel_tb);

        EN      <= 0;
        DATA_IN <= 0;

        // Reset system
        RST <= 1;
        #1
        `CHECK_EQ(DATA, 3'b000, errcount, "Reset failed");

        // Clear reset flag
        RST <= 0;

        // Check we don't load when EN is 0
        DATA_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 3'b000, errcount, "No loaded when EN = 0");

        // Set enable and shift in
        EN      <= 1;
        DATA_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 3'b001, errcount, "Loaded a byte");

        DATA_IN <= 0;
        // Check it gets shifted up a byte
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 3'b010, errcount, "Byte was shifted");

        // Load another byte
        DATA_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 3'b101, errcount, "Second byte loaded");

        // Ensure after clearing EN we get no new bytes for a few cycles
        EN      <= 0;
        DATA_IN <= 0;
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA, 3'b101, errcount, "No change after clearing EN");

        // Reset everything
        RST <= 1;
        #1
        `CHECK_EQ(DATA, 3'b000, errcount, "Reset at end failed");


        `STOP_IF_ERR(errcount);
    end

endmodule
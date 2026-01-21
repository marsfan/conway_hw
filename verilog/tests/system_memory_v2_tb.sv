/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_v2_tb();

    localparam DATA_SIZE = 5;
    logic [DATA_SIZE-1:0] GRID_IN;
    logic SERIAL_IN;
    logic LOAD_MODE;
    logic RUN_MODE;
    logic CLK;
    logic RESET;
    logic [DATA_SIZE-1:0] DATA_OUT;

    SYSTEM_MEMORY_V2 #(DATA_SIZE) dut (
        .GRID_IN(GRID_IN),
        .SERIAL_IN(SERIAL_IN),
        .LOAD_MODE(LOAD_MODE),
        .RUN_MODE(RUN_MODE),
        .CLK(CLK),
        .RESET(RESET),
        .DATA_OUT(DATA_OUT)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_v2_tb.vcd");
        $dumpvars(0, system_memory_v2_tb);

        GRID_IN   <= 5'b00000;
        SERIAL_IN <= 0;
        LOAD_MODE <= 0;
        RUN_MODE  <= 0;
        RESET     <= 0;

        // Reset system
        RESET <= 1;
        #1
        RESET <= 0;

        `RUN_CLOCK(CLK, 20);
        // Test that nothing is loaded when neither MODE bit is set
        GRID_IN   <= 5'b11001;
        SERIAL_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA_OUT, 5'b00000, errcount, "No output when mode bits not set");

        // Set LOAD_MODE and confirm memory is now set from SERIAL_IN
        GRID_IN   <= 5'b00110;
        LOAD_MODE <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA_OUT, 5'b00001, errcount, "Loaded one byte");

        // Try loading a couple more bytes to confirm shifting works as expected
        SERIAL_IN <= 0;
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        SERIAL_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA_OUT, 5'b01001, errcount, "Loaded more bytes serially");

        // Set RUN_MODE and confirm that
        // A) It takes precedence over LOAD_MODE
        // B) It loads as expected
        RUN_MODE <= 1;
        GRID_IN  <= 5'b00110;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA_OUT, 5'b00110, errcount, "Loaded from GRID_IN");

        // Turn off both LOAD_MODE and RUN_MODE and confirm data is persisted after
        // a couple of clocks
        RUN_MODE  <= 0;
        LOAD_MODE <= 0;
        SERIAL_IN <= 0;
        GRID_IN   <= 5'b00000;
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(DATA_OUT, 5'b00110, errcount, "Data persisted after load.");

        // Reset and confirm value is reset
        RESET <= 1;
        #1
        RESET <= 0;
        `CHECK_EQ(DATA_OUT, 5'b00000, errcount, "Data reset");


        `STOP_IF_ERR(errcount);
    end

endmodule
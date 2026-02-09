/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_v4_tb();

    localparam DATA_SIZE = 5;
    logic [DATA_SIZE-1:0] GRID_IN;
    logic SERIAL_IN;
    logic LOAD_MODE;
    logic RUN_MODE;
    logic OUTPUT_MODE;
    logic CLK;
    logic RESET;
    logic [DATA_SIZE-1:0] SYSTEM_MEM_OUT;
    logic SERIAL_OUT;

    system_memory_v4 #(DATA_SIZE) dut(
        .GRID_IN(GRID_IN),
        .SERIAL_IN(SERIAL_IN),
        .LOAD_MODE(LOAD_MODE),
        .RUN_MODE(RUN_MODE),
        .OUTPUT_MODE(OUTPUT_MODE),
        .CLK(CLK),
        .RESET(RESET),
        .SYSTEM_MEM_OUT(SYSTEM_MEM_OUT),
        .SERIAL_OUT(SERIAL_OUT)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_v4_tb.vcd");
        $dumpvars(0, system_memory_v4_tb);



        GRID_IN     <= 5'b00000;
        SERIAL_IN   <= 0;
        LOAD_MODE   <= 0;
        RUN_MODE    <= 0;
        RESET       <= 0;
        OUTPUT_MODE <= 0;

        // Reset system
        RESET <= 1;
        #1
        RESET <= 0;
        `RUN_CLOCK(CLK, 20);

        // Test that nothing is loaded when neither MODE bit is set
        GRID_IN   <= 5'b11001;
        SERIAL_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00000, errcount, "No output when mode bits not set");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 1");

        // Set LOAD_MODE and confirm memory is now set from SERIAL_IN
        GRID_IN   <= 5'b00110;
        LOAD_MODE <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00001, errcount, "Loaded one byte");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 2");

        // Try loading a couple more bytes to confirm shifting works as expected
        SERIAL_IN <= 0;
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        SERIAL_IN <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b01001, errcount, "Loaded more bytes serially");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 3");

        // Set RUN_MODE and confirm that
        // A) It takes precedence over LOAD_MODE
        // B) It loads as expected
        RUN_MODE <= 1;
        GRID_IN  <= 5'b00110;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00110, errcount, "Loaded from GRID_IN");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 4");

        // Turn off both LOAD_MODE and RUN_MODE and confirm data is persisted after
        // a couple of clocks
        RUN_MODE  <= 0;
        LOAD_MODE <= 0;
        SERIAL_IN <= 0;
        GRID_IN   <= 5'b00000;
        `RUN_CLOCK(CLK, 20);
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00110, errcount, "Data persisted after load.");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 5");

        // Reset and confirm value is reset
        RESET <= 1;
        #1
        RESET <= 0;
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00000, errcount, "Data reset");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "No output when OUTPUT mode not set 6");

        // Load data in to test output shift register
        RUN_MODE <= 1;
        GRID_IN  <= 5'b01101;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b01101, errcount, "Loaded data for testing output shift reg");

        // Test reading out the loaded bytes.
        RUN_MODE    <= 0;
        OUTPUT_MODE <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b11010, errcount, "System memory rotates during output 1");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "First byte shifted out");

        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b10101, errcount, "System memory rotates during output 2");
        `CHECK_EQ(SERIAL_OUT, 1, errcount, "Second byte shifted out");

        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b01011, errcount, "System memory rotates during output 3");
        `CHECK_EQ(SERIAL_OUT, 1, errcount, "Third byte shifted out");

        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b10110, errcount, "System memory rotates during output 4");
        `CHECK_EQ(SERIAL_OUT, 0, errcount, "Fourth byte shifted out");

        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b01101, errcount, "System memory rotates during output 5");
        `CHECK_EQ(SERIAL_OUT, 1, errcount, "Fifth byte shifted out");

        RESET <= 1;
        #1
        RESET <= 0;

        LOAD_MODE   <= 0;
        RUN_MODE    <= 0;
        OUTPUT_MODE <= 0;

        // Test that LOAD_MODE has precedence over OUTPUT_MODE
        OUTPUT_MODE <= 1;
        LOAD_MODE   <= 1;
        SERIAL_IN   <= 1;
        GRID_IN     <= 5'b11011;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00001, errcount, "LOAD has precedence over OUTPUT");

        // Test that RUN_MODE has precedence over LOAD_MODE
        RUN_MODE    <= 1;
        OUTPUT_MODE <= 0;
        LOAD_MODE   <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b11011, errcount, "RUN has precedence over LOAD");

        // Test that RUN_MODE has precedence over OUTPUT_MODE
        RUN_MODE    <= 1;
        OUTPUT_MODE <= 1;
        LOAD_MODE   <= 0;
        GRID_IN     <= 5'b00110;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(SYSTEM_MEM_OUT, 5'b00110, errcount, "RUN has precedence over OUTPUT");


        `STOP_IF_ERR(errcount);
    end

endmodule
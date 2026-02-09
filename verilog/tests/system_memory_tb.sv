/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_tb();
    localparam DATA_SIZE = 5;

    logic [DATA_SIZE - 1:0] INITIAL_IN;
    logic [DATA_SIZE - 1:0] GRID_IN;
    logic WRITE_ENABLE;
    logic LOAD_RUN;
    logic CLK;
    logic RESET;
    logic [DATA_SIZE - 1:0] MEM_OUT;


    system_memory #(DATA_SIZE) dut (
        .INITIAL_IN(INITIAL_IN),
        .GRID_IN(GRID_IN),
        .WRITE_ENABLE(WRITE_ENABLE),
        .LOAD_RUN(LOAD_RUN),
        .CLK(CLK),
        .RESET(RESET),
        .MEM_OUT(MEM_OUT)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_tb.vcd");
        $dumpvars(0, system_memory_tb);

        INITIAL_IN   <= 5'b00000;
        GRID_IN      <= 5'b00000;
        WRITE_ENABLE <= 0;
        LOAD_RUN     <= 0;
        CLK          <= 0;
        RESET        <= 0;

        // Reset system
        RESET <= 1;
        #1
        RESET <= 0;

        `RUN_CLOCK(CLK, 20);

        // Test that nothing is loaded when WRITE_ENABLE = 0;
        INITIAL_IN <= 5'b11001;
        GRID_IN    <= 5'b00110;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(MEM_OUT, 5'b00000, errcount, "No output when WE = 0");

        // Set WE and confirm memory is now set from INITIAL_IN
        WRITE_ENABLE <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(MEM_OUT, 5'b11001, errcount, "Memory Updated from INITIAL_IN");

        // Clear WE and confirm value stays the same
        WRITE_ENABLE <= 0;
        INITIAL_IN   <= 5'b00000;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(MEM_OUT, 5'b11001, errcount, "Value stayed at old INITIAL_IN");

        // Set WE, switch to run mode, and confirm we are getting grid value
        WRITE_ENABLE <= 1;
        LOAD_RUN     <= 1;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(MEM_OUT, 5'b00110, errcount, "Memory Updated from GRID_IN");

        // Clear WE and confirm value stays the same
        WRITE_ENABLE <= 0;
        GRID_IN      <= 5'b00000;
        `RUN_CLOCK(CLK, 20);
        `CHECK_EQ(MEM_OUT, 5'b00110, errcount, "Value stayed at old GRID_IN");

        // Reset and confirm value is reset
        RESET <= 1;
        #1
        RESET <= 0;
        `CHECK_EQ(MEM_OUT, 5'b00000, errcount, "Value was reset");


        `STOP_IF_ERR(errcount);
    end

endmodule
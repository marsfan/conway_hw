/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_counter_tb();

    logic enable;
    logic reset;
    logic clk;
    logic [2:0] count;

    system_counter #(4) dut(
        .enable(enable),
        .reset(reset),
        .clk(clk),
        .count(count)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/system_counter_tb.vcd");
        $dumpvars(0, system_counter_tb);

        // Initialize inputs
        enable = 0;
        reset = 1;
        clk = 0;


        // Reset system
        reset = 0;
        #1
        reset = 1;

        `RUN_CLOCK(clk, 20);
        // Counter should be at zero
        `CHECK_EQ(count, 3'b0, "Count = 0");

        `RUN_CLOCK(clk, 20);
        // Unchanged since enable was not set
        `CHECK_EQ(count, 3'b0, "Count = 0");


        // Set enable and clock, now things should be changing
        enable = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd1, "Count = 1");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd2, "Count = 2");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd3, "Count = 3");

        // Rolls over back to start
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd0, "Rollover back to 0");

        // Rolls over back to start
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd1, "Count = 1");

        // Check that we have async active low reset

        reset = 0;
        #1
        reset = 1;

        // Counter = 0 after reset
        `CHECK_EQ(count, 1'd0, "Async reset");


        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(count, 3'd1, "Count = 1");

        // Check that clearing enable but not clocking does not reset
        enable = 0;
        #1
        enable = 1;
        `CHECK_EQ(count, 3'd1, "Count still one after toggling enable without clocking");

        // Check that clearing enable and clocking resets (synchronous reset)
        enable = 0;
        `RUN_CLOCK(clk, 20);
        enable = 1;
        `CHECK_EQ(count, 3'd0, "Synchronous Reset");



    end

endmodule

`default_nettype wire

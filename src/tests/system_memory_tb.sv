/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_tb();
    localparam int unsigned DATA_SIZE = 5;

    logic [DATA_SIZE - 1:0] initial_in;
    logic [DATA_SIZE - 1:0] grid_in;
    logic write_enable;
    logic load_run;
    logic clk;
    logic reset;
    logic [DATA_SIZE - 1:0] mem_out;


    system_memory #(DATA_SIZE) dut (
        .initial_in(initial_in),
        .grid_in(grid_in),
        .write_enable(write_enable),
        .load_run(load_run),
        .clk(clk),
        .reset(reset),
        .mem_out(mem_out)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_tb.vcd");
        $dumpvars(0, system_memory_tb);

        initial_in   = 5'b00000;
        grid_in      = 5'b00000;
        write_enable = 0;
        load_run     = 0;
        clk          = 0;
        reset        = 0;

        // Reset system
        reset = 1;
        #1
        reset = 0;

        `RUN_CLOCK(clk, 20);

        // Test that nothing is loaded when write_enable = 0;
        initial_in = 5'b11001;
        grid_in    = 5'b00110;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(mem_out, 5'b00000, "No output when WE = 0");

        // Set WE and confirm memory is now set from initial_in
        write_enable = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(mem_out, 5'b11001, "Memory Updated from initial_in");

        // Clear WE and confirm value stays the same
        write_enable = 0;
        initial_in   = 5'b00000;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(mem_out, 5'b11001, "Value stayed at old initial_in");

        // Set WE, switch to run mode, and confirm we are getting grid value
        write_enable = 1;
        load_run     = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(mem_out, 5'b00110, "Memory Updated from grid_in");

        // Clear WE and confirm value stays the same
        write_enable = 0;
        grid_in      = 5'b00000;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(mem_out, 5'b00110, "Value stayed at old grid_in");

        // Reset and confirm value is reset
        reset = 1;
        #1
        reset = 0;
        `CHECK_EQ(mem_out, 5'b00000, "Value was reset");


    end

endmodule

`default_nettype wire

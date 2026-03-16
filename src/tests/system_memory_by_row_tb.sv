/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_by_row_tb();
    localparam ROW_SIZE = 4;
    localparam DATA_SIZE = 16;

    logic                   load_mode;
    logic                   run_mode;
    logic                   output_mode;
    logic                   serial_in;
    logic [ROW_SIZE - 1:0]  top_row_in;
    logic                   reset;
    logic                   clk;
    logic [ROW_SIZE - 1:0]  prev_row;
    logic [DATA_SIZE - 1:0] parallel_out;
    logic                   serial_out;

    system_memory_by_row #(
        .DATA_SIZE(DATA_SIZE),
        .ROW_SIZE(ROW_SIZE)
    ) dut (
        .load_mode(load_mode),
        .run_mode(run_mode),
        .output_mode(output_mode),
        .serial_in(serial_in),
        .top_row_in(top_row_in),
        .reset(reset),
        .clk(clk),
        .prev_row(prev_row),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );


    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_by_row_tb.vcd");
        $dumpvars(0, system_memory_by_row_tb);

        serial_in = 0;
        load_mode = 0;
        run_mode = 0;
        output_mode = 0;
        top_row_in = 0;
        reset = 1;
        clk = 0;

        // Reset system
        reset = 0;
        #1
        reset = 1;
        `RUN_CLOCK(clk, 20);

        // Test that nothing is loaded when neither MODE bit is set
        serial_in = 1;
        top_row_in = 4'b1101;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 0, "No change in PREV_ROW");
        `CHECK_EQ(parallel_out, 0, "No change in parallel out");
        `CHECK_EQ(serial_out, 0, "No change in serial out");

        // Set to load mode and confirm memory is now set from serial in
        load_mode = 1;
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 0, "No change in PREV_ROW");
        `CHECK_EQ(parallel_out, 16'b1, "First bit loaded");
        `CHECK_EQ(serial_out, 0, "serial_out still 0 as it reads highest bit");

        // Try loading a couple more bits to confirm shifting works as expected
        serial_in = 0;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 0, "No change in PREV_ROW");
        `CHECK_EQ(parallel_out, 4'b1001, "Loaded more bits serially");
        `CHECK_EQ(serial_out, 0, "High bit still zero");

        // Set run_mode and confirm that
        // 1) shifts bits  down by ROW_SIZE
        // 2) It loads in the top ROW_SIZE bits
        // 3) It shifts the bottom 8 bits into prev_row
        load_mode = 0;
        run_mode = 1;
        serial_in = 0;
        top_row_in = 4'b0110;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b1001, "Prev Row updated");
        `CHECK_EQ(parallel_out, 16'b0110_0000_0000_0000, "Loaded bits into top");
        `CHECK_EQ(serial_out, 0, "High bit still zero");

        // Turn off run_mode an confirm that clocking results in no changes.
        run_mode = 0;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b1001, "Prev Row unchanged");
        `CHECK_EQ(parallel_out, 16'b0110_0000_0000_0000, "parallel_out unchanged");
        `CHECK_EQ(serial_out, 0, "High bit still zero");

        // Turn on run_mode and load_mode and confirm:
        // 1) load_mode takes precedence over run_mode
        // 2) load_mode causes prev_row to be cleared
        load_mode = 1;
        run_mode = 1;
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 0, "Prev Row Cleared");
        `CHECK_EQ(parallel_out, 16'b1100_0000_0000_0001, "Loaded bit into bottom.");
        `CHECK_EQ(serial_out, 1, "High bit now 1");

        // Push in enough values to load all the way to "prev_row"
        load_mode = 0;
        serial_in = 0;
        run_mode = 1;
        top_row_in = 4'b0001;
        `RUN_CLOCK(clk, 20);
        top_row_in = 4'b0010;
        `RUN_CLOCK(clk, 20);
        top_row_in = 4'b0011;
        `RUN_CLOCK(clk, 20);
        top_row_in = 4'b0100;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b1100, "Prev Row");
        `CHECK_EQ(parallel_out, 16'b0100_0011_0010_0001, "Parallel Out");
        `CHECK_EQ(serial_out, 0, "High bit now 0");

        // Check that pushing another value does not perform any circular ops
        top_row_in = 4'b1111;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b0001, "Prev Row");
        `CHECK_EQ(parallel_out, 16'b1111_0100_0011_0010, "Parallel out");
        `CHECK_EQ(serial_out, 1, "High bit now 1");

        // Check that setting "output_mode" performs an upwards circular
        // shift on main memory, and does not modify prev_row
        run_mode = 0;
        top_row_in = 0;
        output_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b0001, "Prev Row");
        `CHECK_EQ(parallel_out, 16'b1110_1000_0110_0101, "Parallel out");
        `CHECK_EQ(serial_out, 1, "High bit now 1");

        // Check that load_mode has precedence over output_mode
        run_mode = 0;
        load_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b0000, "Prev Row");
        `CHECK_EQ(parallel_out, 16'b1101_0000_1100_1010, "Parallel out");
        `CHECK_EQ(serial_out, 1, "High bit still 1");

        // Check that run_mode has precedence over output_mode
        load_mode = 0;
        run_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(prev_row, 4'b1010, "Prev Row");
        `CHECK_EQ(parallel_out, 16'b0000_1101_0000_1100, "Parallel out");
        `CHECK_EQ(serial_out, 0, "High bit now 0");


        // Check an async reset wipes everything
        reset = 0;
        #1
        reset = 1;
        `CHECK_EQ(prev_row, 0, "Prev Row Cleared");
        `CHECK_EQ(parallel_out, 0, "Parallel out Cleared");
        `CHECK_EQ(serial_out, 0, "High bit cleared");



    end

endmodule

`default_nettype wire

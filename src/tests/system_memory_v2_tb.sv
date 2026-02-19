/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_v2_tb();

    localparam int unsigned DATA_SIZE = 5;

    logic [DATA_SIZE - 1:0] grid_in;
    logic serial_in;
    logic load_mode;
    logic run_mode;
    logic clk;
    logic reset;
    logic [DATA_SIZE - 1:0] data_out;

    system_memory_v2 #(DATA_SIZE) dut (
        .grid_in(grid_in),
        .serial_in(serial_in),
        .load_mode(load_mode),
        .run_mode(run_mode),
        .clk(clk),
        .reset(reset),
        .data_out(data_out)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_v2_tb.vcd");
        $dumpvars(0, system_memory_v2_tb);

        grid_in   = 5'b00000;
        serial_in = 0;
        load_mode = 0;
        run_mode  = 0;
        reset     = 0;

        // Reset system
        reset = 1;
        #1
        reset = 0;

        `RUN_CLOCK(clk, 20);
        // Test that nothing is loaded when neither MODE bit is set
        grid_in   = 5'b11001;
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data_out, 5'b00000, "No output when mode bits not set");

        // Set load_mode and confirm memory is now set from serial_in
        grid_in   = 5'b00110;
        load_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data_out, 5'b00001, "Loaded one byte");

        // Try loading a couple more bytes to confirm shifting works as expected
        serial_in = 0;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data_out, 5'b01001, "Loaded more bytes serially");

        // Set run_mode and confirm that
        // A) It takes precedence over load_mode
        // B) It loads as expected
        run_mode = 1;
        grid_in  = 5'b00110;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data_out, 5'b00110, "Loaded from grid_in");

        // Turn off both load_mode and run_mode and confirm data is persisted after
        // a couple of clocks
        run_mode  = 0;
        load_mode = 0;
        serial_in = 0;
        grid_in   = 5'b00000;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data_out, 5'b00110, "Data persisted after load.");

        // Reset and confirm value is reset
        reset = 1;
        #1
        reset = 0;
        `CHECK_EQ(data_out, 5'b00000, "Data reset");


    end

endmodule

`default_nettype wire

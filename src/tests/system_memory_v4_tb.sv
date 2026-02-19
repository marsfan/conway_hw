/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module system_memory_v4_tb();

    localparam int unsigned DATA_SIZE = 5;

    logic [DATA_SIZE - 1:0] grid_in;
    logic serial_in;
    logic load_mode;
    logic run_mode;
    logic output_mode;
    logic clk;
    logic reset;
    logic [DATA_SIZE - 1:0] system_mem_out;
    logic serial_out;

    system_memory_v4 #(DATA_SIZE) dut(
        .grid_in(grid_in),
        .serial_in(serial_in),
        .load_mode(load_mode),
        .run_mode(run_mode),
        .output_mode(output_mode),
        .clk(clk),
        .reset(reset),
        .system_mem_out(system_mem_out),
        .serial_out(serial_out)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/system_memory_v4_tb.vcd");
        $dumpvars(0, system_memory_v4_tb);



        grid_in     = 5'b00000;
        serial_in   = 0;
        load_mode   = 0;
        run_mode    = 0;
        reset       = 0;
        output_mode = 0;

        // Reset system
        reset = 1;
        #1
        reset = 0;
        `RUN_CLOCK(clk, 20);

        // Test that nothing is loaded when neither MODE bit is set
        grid_in   = 5'b11001;
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00000, "No output when mode bits not set");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 1");

        // Set load_mode and confirm memory is now set from serial_in
        grid_in   = 5'b00110;
        load_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00001, "Loaded one byte");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 2");

        // Try loading a couple more bytes to confirm shifting works as expected
        serial_in = 0;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        serial_in = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b01001, "Loaded more bytes serially");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 3");

        // Set run_mode and confirm that
        // A) It takes precedence over load_mode
        // B) It loads as expected
        run_mode = 1;
        grid_in  = 5'b00110;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00110, "Loaded from grid_in");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 4");

        // Turn off both load_mode and run_mode and confirm data is persisted after
        // a couple of clocks
        run_mode  = 0;
        load_mode = 0;
        serial_in = 0;
        grid_in   = 5'b00000;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00110, "Data persisted after load.");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 5");

        // Reset and confirm value is reset
        reset = 1;
        #1
        reset = 0;
        `CHECK_EQ(system_mem_out, 5'b00000, "Data reset");
        `CHECK_EQ(serial_out, 0, "No output when OUTPUT mode not set 6");

        // Load data in to test output shift register
        run_mode = 1;
        grid_in  = 5'b01101;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b01101, "Loaded data for testing output shift reg");

        // Test reading out the loaded bytes.
        run_mode    = 0;
        output_mode = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b11010, "System memory rotates during output 1");
        `CHECK_EQ(serial_out, 0, "First byte shifted out");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b10101, "System memory rotates during output 2");
        `CHECK_EQ(serial_out, 1, "Second byte shifted out");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b01011, "System memory rotates during output 3");
        `CHECK_EQ(serial_out, 1, "Third byte shifted out");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b10110, "System memory rotates during output 4");
        `CHECK_EQ(serial_out, 0, "Fourth byte shifted out");

        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b01101, "System memory rotates during output 5");
        `CHECK_EQ(serial_out, 1, "Fifth byte shifted out");

        reset = 1;
        #1
        reset = 0;

        load_mode   = 0;
        run_mode    = 0;
        output_mode = 0;

        // Test that load_mode has precedence over output_mode
        output_mode = 1;
        load_mode   = 1;
        serial_in   = 1;
        grid_in     = 5'b11011;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00001, "LOAD has precedence over OUTPUT");

        // Test that run_mode has precedence over load_mode
        run_mode    = 1;
        output_mode = 0;
        load_mode   = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b11011, "RUN has precedence over LOAD");

        // Test that run_mode has precedence over output_mode
        run_mode    = 1;
        output_mode = 1;
        load_mode   = 0;
        grid_in     = 5'b00110;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(system_mem_out, 5'b00110, "RUN has precedence over OUTPUT");


    end

endmodule

`default_nettype wire

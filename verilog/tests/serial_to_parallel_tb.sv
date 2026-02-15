/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module serial_to_parallel_tb();

    localparam int unsigned DEPTH = 3;

    logic data_in;
    logic en;
    logic clk;
    logic rst;
    logic [DEPTH - 1:0] data;

    serial_to_parallel #(DEPTH) dut (
        .data_in(data_in),
        .en(en),
        .clk(clk),
        .rst(rst),
        .data(data)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/serial_to_parallel_tb.vcd");
        $dumpvars(0, serial_to_parallel_tb);

        en      <= 0;
        data_in <= 0;

        // Reset system
        rst <= 1;
        #1
        `CHECK_EQ(data, 3'b000, "Reset failed");

        // Clear reset flag
        rst <= 0;

        // Check we don't load when en is 0
        data_in <= 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 3'b000, "No loaded when en = 0");

        // Set enable and shift in
        en      <= 1;
        data_in <= 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 3'b001, "Loaded a byte");

        data_in <= 0;
        // Check it gets shifted up a byte
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 3'b010, "Byte was shifted");

        // Load another byte
        data_in <= 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 3'b101, "Second byte loaded");

        // Ensure after clearing en we get no new bytes for a few cycles
        en      <= 0;
        data_in <= 0;
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 3'b101, "No change after clearing en");

        // Reset everything
        rst <= 1;
        #1
        `CHECK_EQ(data, 3'b000, "Reset at end failed");


    end

endmodule

`default_nettype wire
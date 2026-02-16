/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module parallel_to_serial_tb();
    localparam int DEPTH = 3;

    logic [DEPTH - 1:0] data_in;
    logic load_en;
    logic shift_en;
    logic clk;
    logic rst;
    logic data;

    parallel_to_serial #(DEPTH) dut(
        .data_in(data_in),
        .load_en(load_en),
        .shift_en(shift_en),
        .clk(clk),
        .rst(rst),
        .data(data)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/parallel_to_serial_tb.vcd");
        $dumpvars(0, parallel_to_serial_tb);

        data_in = 3'd0;
        load_en = 0;
        shift_en = 0;
        rst = 0;

        // RReset system
        rst = 1;
        #1
        rst = 0;
        `RUN_CLOCK(clk, 10);

        // Load bytes
        load_en = 1;
        data_in = 3'b011;
        `RUN_CLOCK(clk, 10);
        `CHECK_EQ(data, 0, "Loaded bytes");

        // Test we just get zeros if shift_en is not set
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "shift_en unset 1");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "shift_en unset 2");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "shift_en unset 3");

        // Test we read bytes out as expected
        // Setting load_en to 0 means that even though we
        // changed data_in, we persist what's in the shift reg
        load_en  = 0;
        data_in  = 3'b000;
        shift_en = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 1, "First byte out correct");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 1, "Second byte out correct");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Third byte out correct");

        // Test that we just get zeros if we keep trying
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero 1");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero 2");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero 3");

        // Test that if we load then reset, there's nothing in the shift reg
        shift_en = 0;
        load_en  = 1;
        data_in  = 3'b111;
        `RUN_CLOCK(clk, 20);

        load_en = 0;
        data_in = 3'b000;
        rst     = 1;
        #1
        rst     = 0;

        shift_en = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after reset 1");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after reset 2");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after reset 3");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after reset 4");

        // Test that if load_en is zero, data is not loaded
        load_en  = 0;
        shift_en = 0;
        data_in  = 3'b111;
        `RUN_CLOCK(clk, 20);

        data_in  = 3'b000;
        shift_en = 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after load_en = 0 1");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after load_en = 0 2");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after load_en = 0 3");
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(data, 0, "Got zero after load_en = 0 4");

    end

endmodule

`default_nettype wire

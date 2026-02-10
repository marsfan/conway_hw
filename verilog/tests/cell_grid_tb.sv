/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none
`include "tests/test_utils.svh"

module cell_grid_tb();

    logic [63:0] input_state;
    logic [63:0] next_state;

    cell_grid #(8, 8) dut (
        .input_state(input_state),
        .next_state(next_state)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Configure to dump variables to VCD file
        $dumpfile("waveforms/cell_grid_tb.vcd");
        $dumpvars(0, cell_grid_tb);

        // Testing a few of the different patterns from the
        // Wikipedia page on conway's game of life.

        input_state <= 64'h0000001818000000;
        #1
        `CHECK_EQ(next_state, 64'h0000001818000000, errcount, "Block");

        input_state <= 64'h0000102828100000;
        #1
        `CHECK_EQ(next_state, 64'h0000102828100000, errcount, "Behive");

        input_state <= 64'h0000001010100000;
        #1
        `CHECK_EQ(next_state, 64'h0000000038000000, errcount, "Blinker");

        input_state <= 64'h0060601818000000;
        #1
        `CHECK_EQ(next_state, 64'h0060400818000000, errcount, "Beacon");

        input_state <= 64'hC080000000000000;
        #1
        `CHECK_EQ(next_state, 64'hC0C0000000000000, errcount, "Corner1");

        input_state <= 64'h8080800000000000;
        #1
        `CHECK_EQ(next_state, 64'h00C0000000000000, errcount, "Corner2");

        `STOP_IF_ERR(errcount);


    end

endmodule
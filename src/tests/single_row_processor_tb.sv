/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module single_row_processor_tb();

    logic [7:0] prev_row;
    logic [7:0] this_row;
    logic [7:0] next_row;
    logic [7:0] is_alive;

    single_row_processor #(8) dut (
        .prev_row(prev_row),
        .this_row(this_row),
        .next_row(next_row),
        .is_alive(is_alive)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/single_row_processor_tb.vcd");
        $dumpvars(0, single_row_processor_tb);


        // Testing a few patterns to confirm things are wired up properly
        prev_row = 8'b00000000;
        this_row = 8'b01110000;
        next_row = 8'b00000000;

        #1
        `CHECK_EQ(is_alive, 8'b00100000, "Blinker 1");


        prev_row = 8'b00111000;
        this_row = 8'b00000000;
        next_row = 8'b00000000;

        #1
        `CHECK_EQ(is_alive, 8'b00010000, "Blinker 2");


        prev_row = 8'b11000000;
        this_row = 8'b11000000;
        next_row = 8'b00000000;

        #1
        `CHECK_EQ(is_alive, 8'b11000000, "Block Top Left");

        prev_row = 8'b00000000;
        this_row = 8'b11000000;
        next_row = 8'b11000000;

        #1
        `CHECK_EQ(is_alive, 8'b11000000, "Block Bottom Left");

        prev_row = 8'b00000000;
        this_row = 8'b00000011;
        next_row = 8'b00000011;

        #1
        `CHECK_EQ(is_alive, 8'b00000011, "Block Bottom Right");

        prev_row = 8'b00000011;
        this_row = 8'b00000011;
        next_row = 8'b00000000;

        #1
        `CHECK_EQ(is_alive, 8'b00000011, "Block Top Right");


    end

endmodule

`default_nettype wire

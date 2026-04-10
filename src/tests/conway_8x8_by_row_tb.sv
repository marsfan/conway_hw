/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module conway_8x8_by_row_tb();

logic       data_in;
logic [1:0] mode;
logic       reset;
logic       clk;
logic       data_out;
logic       din_led;
logic       clk_led;
logic       dout_led;
logic [1:0] mode_leds;

    conway_8x8_by_row dut(
        .data_in(data_in),   // Serial data in
        .mode(mode),      // System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
        .reset(reset),     // Async active low system reset
        .clk(clk),       // System clock // TODO: Separate clocks for shift regs so they can run faster?
        .data_out(data_out),  // Serial data out
        .din_led(din_led),   // Data input LED for debugging
        .clk_led(clk_led),   // Data output LED for debugging
        .dout_led(dout_led),  // Data output LED for debugging
        .mode_leds(mode_leds)  // Mode LEDs for debugging
    );

        logic [63:0] test_out = 0;


    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/conway_8x8_by_row_tb.vcd");
        $dumpvars(0, conway_8x8_by_row_tb);

        reset = 0;
        #1
        reset = 1;

        // Load in three bits as 1, then 18 bits as zero
        mode = 2'b00;
        for (int i = 0; i < 3; i++) begin
            data_in = 1;
            `RUN_CLOCK(clk, 20);
        end
        for (int i = 0; i < 18; i++) begin
            data_in = 0;
            `RUN_CLOCK(clk, 20);
        end

        // Unload all 64 bits into output logic;
        mode = 2'b10;
        for (int i = 0; i < 64; i++) begin
            test_out = test_out << 1;
            test_out = test_out | data_out;
            `RUN_CLOCK(clk, 20);
        end

        $display(test_out);


    end

endmodule

`default_nettype wire

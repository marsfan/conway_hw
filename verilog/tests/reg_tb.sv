/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`include "tests/test_utils.sv"

module reg_tb();

    reg [10:0] d;
    reg we, clk, reset;
    wire [10:0] q;


    DFF #(11) dut (d, we, clk, reset, q);



    initial begin
        int errcount;
        errcount = 0;

        // Configure to dump all variables to VCD file
        $dumpfile("waveforms/reg_tb.vcd");
        $dumpvars(0, reg_tb);

        // Initial values
        we <= 0;
        clk <= 0;
        d <= 0;

        // Reset register, wait 1 time unit, then cler reset
        reset <= 1;
        #1

        `CHECK_EQ(q, 0, errcount, "REG_TB: Reset Failed");
        reset <= 0;

        // Set value but don't enable WE
        d <= 11'b00000001100;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(q, 0, errcount, "REG_TB: Q Stayed the same failed");


        we <= 1;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(q, 11'b00000001100, errcount, "REG_TB: Q set failed");

        we <= 0;
        d <= 11'd0;
        `RUN_CLOCK(clk, 20);
        `CHECK_EQ(q, 11'b00000001100, errcount, "REG_TB: Q stays the same (again) failed");

        // Final fatal to ensure tb exits with a nonzero return code
        `STOP_IF_ERR(errcount);

    end

endmodule
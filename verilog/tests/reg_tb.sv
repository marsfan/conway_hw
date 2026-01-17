/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module reg_tb();

    reg [10:0] d;
    reg we, clk, reset;
    wire [10:0] q;


    DFF #(11) dut (d, we, clk, reset, q);



    initial begin
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

        assert( q == 0) else $error( "REG_TB: Reset failed");
        reset <= 0;

        // Set value but don't enable WE
        d <= 11'b00000001100;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 0) else $error( "REG_TB: Q Stayed the same failed");


        we <= 1;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 11'b00000001100) else $error("REG_TB: Q set failed");

        we <= 0;
        d <= 11'd0;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 11'b00000001100) else $error("REG_TB: Q stays the same (again) failed");

    end

endmodule
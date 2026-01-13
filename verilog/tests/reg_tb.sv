

module reg_tb();

    reg [10:0] d;
    reg we, clk, reset;
    wire [10:0] q;


    dff #(11) dut (d, we, clk, reset, q);



    initial begin
        // Configure to dump all variables to test.vcd
        $dumpfile("waveforms/reg_tb.vcd");
        $dumpvars(0,d, we, clk, reset, q);

        // Initial values
        we <= 0;
        clk <= 0;
        d <= 0;

        // Reset register, wait 1 time unit, then cler reset
        reset <= 1;
        #1

        assert( q == 0) else $display( "REG_TB: Reset failed");
        reset <= 0;

        // Set value but don't enable WE
        d <= 11'b00000001100;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 0) else $display( "REG_TB: Q Stayed the same failed");


        we <= 1;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 11'b00000001100) else $display("REG_TB: Q set failed");

        we <= 0;
        d <= 11'd0;
        #20 clk = 1;
        #20 clk = 0;
        assert( q == 11'b00000001100) else $display("REG_TB: Q stays the same (again) failed");


    end

endmodule
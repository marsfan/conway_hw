/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module full_adder_tb();

    typedef struct packed {
        logic a1;
        logic a2;
        logic cin;
        logic cout;
        logic sum;
    } test_case_t;

    test_case_t [7:0] test_cases;

    assign test_cases[0] = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0};
    assign test_cases[1] = {1'd0, 1'd0, 1'd1, 1'd0, 1'd1};
    assign test_cases[2] = {1'd0, 1'd1, 1'd0, 1'd0, 1'd1};
    assign test_cases[3] = {1'd0, 1'd1, 1'd1, 1'd1, 1'd0};
    assign test_cases[4] = {1'd1, 1'd0, 1'd0, 1'd0, 1'd1};
    assign test_cases[5] = {1'd1, 1'd0, 1'd1, 1'd1, 1'd0};
    assign test_cases[6] = {1'd1, 1'd1, 1'd0, 1'd1, 1'd0};
    assign test_cases[7] = {1'd1, 1'd1, 1'd1, 1'd1, 1'd1};

    logic IN1, IN2, cin, sum, cout;

    full_adder dut(
        .a(IN1),
        .b(IN2),
        .c_in(cin),
        .sum(sum),
        .carry(cout)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);

        for (int i = 0; i < $size(test_cases); i++) begin
            IN1 <= test_cases[i].a1;
            IN2 <= test_cases[i].a2;
            cin <= test_cases[i].cin;
            #1
            `CHECK_EQ(sum, test_cases[i].sum, errcount, "sum");
            `CHECK_EQ(cout, test_cases[i].cout, errcount, "cout");
        end


        `STOP_IF_ERR(errcount);
    end

endmodule
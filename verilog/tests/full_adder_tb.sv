/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module full_adder_tb();

    typedef struct packed {
        logic A1;
        logic A2;
        logic CIN;
        logic COUT;
        logic SUM;
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

    logic IN1, IN2, CIN, SUM, COUT;

    full_adder dut(
        .A(IN1),
        .B(IN2),
        .C_IN(CIN),
        .SUM(SUM),
        .CARRY(COUT)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);

        for (int i = 0; i < $size(test_cases); i++) begin
            IN1 <= test_cases[i].A1;
            IN2 <= test_cases[i].A2;
            CIN <= test_cases[i].CIN;
            #1
            `CHECK_EQ(SUM, test_cases[i].SUM, errcount, "SUM");
            `CHECK_EQ(COUT, test_cases[i].COUT, errcount, "COUT");
        end


        `STOP_IF_ERR(errcount);
    end

endmodule
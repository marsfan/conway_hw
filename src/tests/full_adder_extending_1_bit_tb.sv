/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module full_adder_extending_1_bit_tb ();

    typedef struct packed {
        logic a;
        logic b;
        logic c;
        logic [1:0] sum;
    } test_case_t;

    test_case_t [7:0] test_cases;

    assign test_cases[0] = {1'd0, 1'd0, 1'd0, 2'b00};
    assign test_cases[1] = {1'd0, 1'd0, 1'd1, 2'b01};
    assign test_cases[2] = {1'd0, 1'd1, 1'd0, 2'b01};
    assign test_cases[3] = {1'd0, 1'd1, 1'd1, 2'b10};
    assign test_cases[4] = {1'd1, 1'd0, 1'd0, 2'b01};
    assign test_cases[5] = {1'd1, 1'd0, 1'd1, 2'b10};
    assign test_cases[6] = {1'd1, 1'd1, 1'd0, 2'b10};
    assign test_cases[7] = {1'd1, 1'd1, 1'd1, 2'b11};

    logic a, b, c;
    logic [1:0] sum;

    full_adder_extending #(1) dut(
        .a(a),
        .b(b),
        .c_in(c),
        .sum(sum)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_extending_1_bit_tb.vcd");
        $dumpvars(0, full_adder_extending_1_bit_tb);

        for (int i = 0; i < $size(test_cases); i++) begin
            a = test_cases[i].a;
            b = test_cases[i].b;
            c = test_cases[i].c;
            #1;
            `CHECK_EQ(sum, test_cases[i].sum, i);
        end


    end

endmodule

`default_nettype wire

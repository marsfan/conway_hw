/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https://mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.svh"

module full_adder_2_bit_to_3_bit_tb();

    typedef struct packed {
        logic [1:0] a;
        logic [1:0] b;
        logic [2:0] sum;
    } test_case_t;

    test_case_t [15:0]  test_cases;

    assign test_cases[0] = {2'b00, 2'b00, 3'b000};
    assign test_cases[1] = {2'b01, 2'b00, 3'b001};
    assign test_cases[2] = {2'b10, 2'b00, 3'b010};
    assign test_cases[3] = {2'b11, 2'b00, 3'b011};

    assign test_cases[4] = {2'b00, 2'b01, 3'b001};
    assign test_cases[5] = {2'b01, 2'b01, 3'b010};
    assign test_cases[6] = {2'b10, 2'b01, 3'b011};
    assign test_cases[7] = {2'b11, 2'b01, 3'b100};

    assign test_cases[8] = {2'b00, 2'b10, 3'b010};
    assign test_cases[9] = {2'b01, 2'b10, 3'b011};
    assign test_cases[10] = {2'b10, 2'b10, 3'b100};
    assign test_cases[11] = {2'b11, 2'b10, 3'b101};

    assign test_cases[12] = {2'b00, 2'b11, 3'b011};
    assign test_cases[13] = {2'b01, 2'b11, 3'b100};
    assign test_cases[14] = {2'b10, 2'b11, 3'b101};
    assign test_cases[15] = {2'b11, 2'b11, 3'b110};


    logic [1:0] a;
    logic [1:0] b;
    logic [2:0] sum;

    full_adder_2_bit_to_3_bit dut(
        .a(a),
        .b(b),
        .sum(sum)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_2_bit_to_3_bit_tb.vcd");
        $dumpvars(0, full_adder_2_bit_to_3_bit_tb);

        for (int i =0; i < $size(test_cases); i++) begin
            a <= test_cases[i].a;
            b <= test_cases[i].b;
            #1 `CHECK_EQ(sum, test_cases[i].sum, i);

        end

    end

endmodule

`default_nettype wire
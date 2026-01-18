/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.sv"

module full_adder_2_bit_to_3_bit_tb();

    typedef struct packed  {
        logic [1:0] A;
        logic [1:0] B;
        logic [2:0] SUM;
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


    logic [1:0] A;
    logic [1:0] B;
    logic [2:0] SUM;

    FULL_ADDER_2_BIT_TO_3_BIT dut(
        .A(A),
        .B(B),
        .SUM(SUM)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_2_bit_to_3_bit_tb.vcd");
        $dumpvars(0, full_adder_2_bit_to_3_bit_tb);

        for (int i =0; i < $size(test_cases); i++) begin
            A <= test_cases[i].A;
            B <= test_cases[i].B;
            #1 `CHECK_EQ(SUM, test_cases[i].SUM, errcount, i);

        end

        `STOP_IF_ERR(errcount);
    end

endmodule
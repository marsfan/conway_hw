/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.sv"

module full_adder_3_bit_to_4_bit_tb();

    typedef struct packed  {
        logic [2:0] A;
        logic [2:0] B;
        logic [3:0] SUM;
    } test_case_t;

    test_case_t [63:0]  test_cases;

        assign test_cases[0] = {3'b000, 3'b000, 4'b0000};
        assign test_cases[1] = {3'b001, 3'b000, 4'b0001};
        assign test_cases[2] = {3'b010, 3'b000, 4'b0010};
        assign test_cases[3] = {3'b011, 3'b000, 4'b0011};
        assign test_cases[4] = {3'b100, 3'b000, 4'b0100};
        assign test_cases[5] = {3'b101, 3'b000, 4'b0101};
        assign test_cases[6] = {3'b110, 3'b000, 4'b0110};
        assign test_cases[7] = {3'b111, 3'b000, 4'b0111};

        assign test_cases[8] = {3'b000, 3'b001, 4'b0001};
        assign test_cases[9] = {3'b001, 3'b001, 4'b0010};
        assign test_cases[10] = {3'b010, 3'b001, 4'b0011};
        assign test_cases[11] = {3'b011, 3'b001, 4'b0100};
        assign test_cases[12] = {3'b100, 3'b001, 4'b0101};
        assign test_cases[13] = {3'b101, 3'b001, 4'b0110};
        assign test_cases[14] = {3'b110, 3'b001, 4'b0111};
        assign test_cases[15] = {3'b111, 3'b001, 4'b1000};

        assign test_cases[16] = {3'b000, 3'b010, 4'b0010};
        assign test_cases[17] = {3'b001, 3'b010, 4'b0011};
        assign test_cases[18] = {3'b010, 3'b010, 4'b0100};
        assign test_cases[19] = {3'b011, 3'b010, 4'b0101};
        assign test_cases[20] = {3'b100, 3'b010, 4'b0110};
        assign test_cases[21] = {3'b101, 3'b010, 4'b0111};
        assign test_cases[22] = {3'b110, 3'b010, 4'b1000};
        assign test_cases[23] = {3'b111, 3'b010, 4'b1001};

        assign test_cases[24] = {3'b000, 3'b011, 4'b0011};
        assign test_cases[25] = {3'b001, 3'b011, 4'b0100};
        assign test_cases[26] = {3'b010, 3'b011, 4'b0101};
        assign test_cases[27] = {3'b011, 3'b011, 4'b0110};
        assign test_cases[28] = {3'b100, 3'b011, 4'b0111};
        assign test_cases[29] = {3'b101, 3'b011, 4'b1000};
        assign test_cases[30] = {3'b110, 3'b011, 4'b1001};
        assign test_cases[31] = {3'b111, 3'b011, 4'b1010};

        assign test_cases[32] = {3'b000, 3'b100, 4'b0100};
        assign test_cases[33] = {3'b001, 3'b100, 4'b0101};
        assign test_cases[34] = {3'b010, 3'b100, 4'b0110};
        assign test_cases[35] = {3'b011, 3'b100, 4'b0111};
        assign test_cases[36] = {3'b100, 3'b100, 4'b1000};
        assign test_cases[37] = {3'b101, 3'b100, 4'b1001};
        assign test_cases[38] = {3'b110, 3'b100, 4'b1010};
        assign test_cases[39] = {3'b111, 3'b100, 4'b1011};

        assign test_cases[40] = {3'b000, 3'b101, 4'b0101};
        assign test_cases[41] = {3'b001, 3'b101, 4'b0110};
        assign test_cases[42] = {3'b010, 3'b101, 4'b0111};
        assign test_cases[43] = {3'b011, 3'b101, 4'b1000};
        assign test_cases[44] = {3'b100, 3'b101, 4'b1001};
        assign test_cases[45] = {3'b101, 3'b101, 4'b1010};
        assign test_cases[46] = {3'b110, 3'b101, 4'b1011};
        assign test_cases[47] = {3'b111, 3'b101, 4'b1100};

        assign test_cases[48] = {3'b000, 3'b110, 4'b0110};
        assign test_cases[49] = {3'b001, 3'b110, 4'b0111};
        assign test_cases[50] = {3'b010, 3'b110, 4'b1000};
        assign test_cases[51] = {3'b011, 3'b110, 4'b1001};
        assign test_cases[52] = {3'b100, 3'b110, 4'b1010};
        assign test_cases[53] = {3'b101, 3'b110, 4'b1011};
        assign test_cases[54] = {3'b110, 3'b110, 4'b1100};
        assign test_cases[55] = {3'b111, 3'b110, 4'b1101};


        assign test_cases[56] = {3'b000, 3'b111, 4'b0111};
        assign test_cases[57] = {3'b001, 3'b111, 4'b1000};
        assign test_cases[58] = {3'b010, 3'b111, 4'b1001};
        assign test_cases[59] = {3'b011, 3'b111, 4'b1010};
        assign test_cases[60] = {3'b100, 3'b111, 4'b1011};
        assign test_cases[61] = {3'b101, 3'b111, 4'b1100};
        assign test_cases[62] = {3'b110, 3'b111, 4'b1101};
        assign test_cases[63] = {3'b111, 3'b111, 4'b1110};



    logic [2:0] A;
    logic [2:0] B;
    logic [3:0] SUM;

    FULL_ADDER_3_BIT_TO_4_BIT dut(
        .A(A),
        .B(B),
        .SUM(SUM)
    );

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/full_adder_3_bit_to_4_bit_tb.vcd");
        $dumpvars(0, full_adder_3_bit_to_4_bit_tb);

        for (int i =0; i < $size(test_cases); i++) begin
            A <= test_cases[i].A;
            B <= test_cases[i].B;
            #1 `CHECK_EQ(SUM, test_cases[i].SUM, errcount, i);

        end

        `STOP_IF_ERR(errcount);
    end

endmodule
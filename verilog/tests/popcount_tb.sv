/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none
`include "tests/test_utils.sv"

module popcount_tb();

    logic N;
    logic NE;
    logic E;
    logic SE;
    logic S;
    logic SW;
    logic W;
    logic NW;
    logic [3:0] COUNT;

    POPCOUNT dut(
        .N(N),
        .NE(NE),
        .E(E),
        .SE(SE),
        .S(S),
        .SW(SW),
        .W(W),
        .NW(NW),
        .COUNT(COUNT)
    );

    typedef struct packed {
        logic N;
        logic NE;
        logic E;
        logic SE;
        logic S;
        logic SW;
        logic W;
        logic NW;
        logic [3:0] COUNT;
    } test_case_t;

    test_case_t [255:0] test_cases;
    assign test_cases[0] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000};
    assign test_cases[1] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0001};
    assign test_cases[2] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0001};
    assign test_cases[3] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0010};
    assign test_cases[4] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0001};
    assign test_cases[5] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0010};
    assign test_cases[6] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0010};
    assign test_cases[7] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0011};
    assign test_cases[8] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0001};
    assign test_cases[9] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0010};
    assign test_cases[10] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0010};
    assign test_cases[11] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0011};
    assign test_cases[12] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0010};
    assign test_cases[13] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0011};
    assign test_cases[14] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0011};
    assign test_cases[15] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0100};
    assign test_cases[16] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0001};
    assign test_cases[17] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0010};
    assign test_cases[18] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0010};
    assign test_cases[19] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0011};
    assign test_cases[20] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
    assign test_cases[21] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0011};
    assign test_cases[22] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0011};
    assign test_cases[23] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0100};
    assign test_cases[24] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[25] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[26] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[27] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[28] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[29] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[30] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[31] = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[32] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0001};
    assign test_cases[33] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0010};
    assign test_cases[34] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0010};
    assign test_cases[35] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0011};
    assign test_cases[36] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
    assign test_cases[37] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0011};
    assign test_cases[38] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0011};
    assign test_cases[39] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0100};
    assign test_cases[40] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[41] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[42] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[43] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[44] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[45] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[46] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[47] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[48] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[49] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[50] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[51] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[52] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[53] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[54] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[55] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[56] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[57] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[58] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[59] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[60] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[61] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[62] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[63] = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[64] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0001};
    assign test_cases[65] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0010};
    assign test_cases[66] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0010};
    assign test_cases[67] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0011};
    assign test_cases[68] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
    assign test_cases[69] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0011};
    assign test_cases[70] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0011};
    assign test_cases[71] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0100};
    assign test_cases[72] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[73] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[74] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[75] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[76] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[77] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[78] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[79] = {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[80] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[81] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[82] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[83] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[84] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[85] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[86] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[87] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[88] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[89] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[90] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[91] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[92] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[93] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[94] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[95] = {1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[96] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[97] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[98] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[99] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[100] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[101] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[102] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[103] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[104] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[105] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[106] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[107] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[108] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[109] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[110] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[111] = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[112] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[113] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[114] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[115] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[116] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[117] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[118] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[119] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[120] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0100};
    assign test_cases[121] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0101};
    assign test_cases[122] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0101};
    assign test_cases[123] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0110};
    assign test_cases[124] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0101};
    assign test_cases[125] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0110};
    assign test_cases[126] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0110};
    assign test_cases[127] = {1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0111};
    assign test_cases[128] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0001};
    assign test_cases[129] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0010};
    assign test_cases[130] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0010};
    assign test_cases[131] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0011};
    assign test_cases[132] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
    assign test_cases[133] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0011};
    assign test_cases[134] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0011};
    assign test_cases[135] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0100};
    assign test_cases[136] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[137] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[138] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[139] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[140] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[141] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[142] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[143] = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[144] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[145] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[146] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[147] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[148] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[149] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[150] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[151] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[152] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[153] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[154] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[155] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[156] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[157] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[158] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[159] = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[160] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[161] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[162] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[163] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[164] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[165] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[166] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[167] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[168] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[169] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[170] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[171] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[172] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[173] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[174] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[175] = {1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[176] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[177] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[178] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[179] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[180] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[181] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[182] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[183] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[184] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0100};
    assign test_cases[185] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0101};
    assign test_cases[186] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0101};
    assign test_cases[187] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0110};
    assign test_cases[188] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0101};
    assign test_cases[189] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0110};
    assign test_cases[190] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0110};
    assign test_cases[191] = {1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0111};
    assign test_cases[192] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0010};
    assign test_cases[193] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0011};
    assign test_cases[194] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0011};
    assign test_cases[195] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0100};
    assign test_cases[196] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0011};
    assign test_cases[197] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0100};
    assign test_cases[198] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0100};
    assign test_cases[199] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0101};
    assign test_cases[200] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[201] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[202] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[203] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[204] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[205] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[206] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[207] = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[208] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[209] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[210] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[211] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[212] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[213] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[214] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[215] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[216] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0100};
    assign test_cases[217] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0101};
    assign test_cases[218] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0101};
    assign test_cases[219] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0110};
    assign test_cases[220] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0101};
    assign test_cases[221] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0110};
    assign test_cases[222] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0110};
    assign test_cases[223] = {1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0111};
    assign test_cases[224] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0011};
    assign test_cases[225] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0100};
    assign test_cases[226] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100};
    assign test_cases[227] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0101};
    assign test_cases[228] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0100};
    assign test_cases[229] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0101};
    assign test_cases[230] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0101};
    assign test_cases[231] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0110};
    assign test_cases[232] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0100};
    assign test_cases[233] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0101};
    assign test_cases[234] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0101};
    assign test_cases[235] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0110};
    assign test_cases[236] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0101};
    assign test_cases[237] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0110};
    assign test_cases[238] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0110};
    assign test_cases[239] = {1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 4'b0111};
    assign test_cases[240] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0100};
    assign test_cases[241] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0101};
    assign test_cases[242] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0101};
    assign test_cases[243] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0110};
    assign test_cases[244] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0101};
    assign test_cases[245] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 4'b0110};
    assign test_cases[246] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0110};
    assign test_cases[247] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 4'b0111};
    assign test_cases[248] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0101};
    assign test_cases[249] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 4'b0110};
    assign test_cases[250] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0110};
    assign test_cases[251] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 4'b0111};
    assign test_cases[252] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 4'b0110};
    assign test_cases[253] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0111};
    assign test_cases[254] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b0111};
    assign test_cases[255] = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 4'b1000};

    initial begin
        int errcount;
        errcount = 0;

        // Dump to VCD File
        $dumpfile("waveforms/popcount_tb.vcd");
        $dumpvars(0, popcount_tb);

        for (int i = 0; i < 256; i++) begin
            N  <= test_cases[i].N;
            NE <= test_cases[i].NE;
            E  <= test_cases[i].E;
            SE <= test_cases[i].SE;
            S  <= test_cases[i].S;
            SW <= test_cases[i].SW;
            W  <= test_cases[i].W;
            NW <= test_cases[i].NW;

            #1;

            `CHECK_EQ(COUNT, test_cases[i].COUNT, errcount, i);
        end


        `STOP_IF_ERR(errcount);
    end

endmodule
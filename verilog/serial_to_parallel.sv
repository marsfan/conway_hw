/// Shift register that shifts data in serially and outputs parallel

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

module SERIAL_TO_PARALLEL #(parameter data_size = 64)
(
    input DATA_IN,
    input EN,
    input CLK,
    input RST,
    output reg [data_size-1:0] DATA = 0
);


always @(posedge CLK, posedge RST) begin : shift_register_process
    if (RST) begin
        DATA <= 0;
    end else if ((CLK) && (EN)) begin
        // Take a slice of the bottom 63 elements, and concatenate it with the new value
        // This means we have shifted everying up one bit, and shifted in the new value at the bottom
        DATA <= {DATA[$high(DATA) - 1:$low(DATA)], DATA_IN};
    end
end


endmodule
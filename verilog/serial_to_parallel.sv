/// Shift register that shifts data in serially and outputs parallel

/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/
`default_nettype none

module serial_to_parallel #(
    parameter int unsigned DATA_SIZE = 64
) (
    input  wire                  data_in,
    input  wire                  en,
    input  wire                  clk,
    input  wire                  rst,
    output reg [DATA_SIZE - 1:0] data = 0
);


always @(posedge clk, posedge rst) begin: shift_register_process
    if (rst) begin
        data <= 0;
    end else if ((clk) && (en)) begin
        // Take a slice of the bottom 63 elements, and concatenate it with the new value
        // This means we have shifted everying up one bit, and shifted in the new value at the bottom
        data <= {data[$high(data) - 1:$low(data)], data_in};
    end
end


endmodule

`default_nettype wire

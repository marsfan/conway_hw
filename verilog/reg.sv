module dff #(parameter SIZE = 1)(
    input [SIZE-1:0] d,
    input we,
    input clk,
    input reset,
    output reg [SIZE-1:0]  q
);

    // parameter SIZE = 1;

    // input we, clk, reset;
    // input [SIZE-1:0] d;
    // output reg [SIZE-1:0] q;

    always @(posedge clk, reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            if (we) begin
                q <= d;
            end
        end
    end

endmodule
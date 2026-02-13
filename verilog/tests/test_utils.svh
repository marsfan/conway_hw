`ifndef MY_DEFINES_SV
`define MY_DEFINES_SV


/// Check that a condition is true
`define CHECK(V, MSG) assert (V) else $fatal(2, MSG)

/// Check if two values are equal
`define CHECK_EQ(A, B, MSG) assert (A == B) else $fatal(2, MSG)

/// Drive clock high for T time units, then drive low for T Time units
`define RUN_CLOCK(CLK, T) begin #T CLK <= 1; #T CLK <= 0; end


`endif
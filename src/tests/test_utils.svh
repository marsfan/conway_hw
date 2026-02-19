`ifndef TEST_UTILS_SVH
`define TEST_UTILS_SVH


/// Check that a condition is true
`define CHECK(V, MSG) assert (V) else $fatal(2, MSG)

/// Check if two values are equal
`define CHECK_EQ(A, B, MSG) assert (A == B) else $fatal(2, MSG)

/// Drive clock high for T time units, then drive low for T Time units
`define RUN_CLOCK(CLK, T) begin /*Run Clock Once*/ #T CLK = 1; #T CLK = 0; end


`endif  // TEST_UTILS_SVH

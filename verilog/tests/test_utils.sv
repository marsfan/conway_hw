`ifndef MY_DEFINES_SV
`define MY_DEFINES_SV

/// Check that a condition is true, if not increment ERRCOUNT and display error message
`define CHECK(V, ERRCOUNT, MSG) assert(V) else begin ERRCOUNT++; $error(MSG); end

/// Check if two values are equal. If not, increment ERRCOUNT and display error message
`define CHECK_EQ(A, B, ERRCOUNT, MSG) assert(A==B) else begin ERRCOUNT++; $error(MSG); end

/// Drive clock high for T time units, then drive low for T Time units
`define RUN_CLOCK(CLK, T)  begin #T CLK <= 1; #T CLK <= 0; end

/// Halt with an errorr code if ERRCOUNT is nonzerro
`define STOP_IF_ERR(ERRCOUNT) assert(ERRCOUNT == 0) else $fatal(2)

`endif
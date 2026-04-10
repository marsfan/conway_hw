/*
  * Copyright (c) 2024 Gabriel Roper
  * SPDX-License-Identifier: Apache-2.0
  */

`default_nettype none

/* svlint off keyword_forbidden_wire_reg */
module tt_um_conway (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  /* svlint on keyword_forbidden_wire_reg */


  logic [1:0] red;
  logic [1:0] green;
  logic [1:0] blue;
  logic hsync;
  logic vsync;

  conway_vga conway(
    .rst_n(rst_n),
    .int_clk(clk),
    .ext_clk(ui_in[3]),
    .data_in(ui_in[0]),
    .mode(ui_in[2:1]),
    .data_out(uio_out[0]), // FIXME: Use a UI_OUT?
    .red(red),
    .green(green),
    .blue(blue),
    .hsync(hsync),
    .vsync(vsync)
  );
  assign uo_out = {hsync, blue[0], green[0], red[0], vsync, blue[1], green[1], red[1]};



  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[7:1] = 0;
  assign uio_oe  = 8'b00000001;

  // assign uo_out[7:6] = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:4], uio_in};




endmodule

`default_nettype wire

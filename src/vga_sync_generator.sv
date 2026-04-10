/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

// I wrote this partially based on the simple "stripes" example from
// Tiny Tapeout's VGA playground (https://vga-playground.com/?preset=stripes),
// and partially from the BASYS 2 reference manual (https://digilent.com/reference/_media/basys2/basys2_rm.pdf)

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module vga_sync_generator(
    input wire clk,
    input wire rst_n,
    output wire hsync,
    output reg vsync,
    output wire [9:0] hpos,
    output wire [9:0] vpos,
    output wire display_active
);
/* svlint on keyword_forbidden_wire_reg */
// FIXME: Convert these to parameters
localparam int unsigned DISPLAY_WIDTH = 640;
localparam int unsigned H_FRONT_PORCH = 16;
localparam int unsigned H_BACK_PORCH  = 48;
localparam int unsigned H_PULSE_WIDTH = 96;
localparam int unsigned H_PULSE_START = DISPLAY_WIDTH + H_FRONT_PORCH;
// By adding 1 here, we can then use `<` instead of `<=`, simplifying logic
localparam int unsigned H_PULSE_END = H_PULSE_START + H_PULSE_WIDTH + 1;
localparam int unsigned H_SYNC_TIME = DISPLAY_WIDTH + H_FRONT_PORCH + H_BACK_PORCH + H_PULSE_WIDTH;


localparam int unsigned DISPLAY_HEIGHT = 480;
localparam int unsigned V_FRONT_PORCH = 10;
localparam int unsigned V_BACK_PORCH = 33; // Digilent says 29
localparam int unsigned V_PULSE_WIDTH = 2;
localparam int unsigned V_PULSE_START = DISPLAY_HEIGHT + V_FRONT_PORCH;
localparam int unsigned V_PULSE_END = V_PULSE_START + V_PULSE_WIDTH;
localparam int unsigned V_SYNC_TIME = DISPLAY_HEIGHT + V_FRONT_PORCH + V_BACK_PORCH + V_PULSE_WIDTH;

logic [9:0] hcount;
logic [9:0] vcount;
logic hcount_0;

always_ff @(posedge clk or negedge rst_n) begin: hsync_counter
    if (!rst_n) begin
        hcount <= 0;
    end else if (clk) begin
        if (hcount < 10'(H_SYNC_TIME - 1)) begin
            hcount <= hcount + 1;
        end else begin
            hcount <= 0;
        end
    end
end


assign hsync = ~((hcount > 10'(H_PULSE_START)) && (hcount < 10'(H_PULSE_END)));


assign hcount_0 = hcount == 0;
always_ff @(posedge hcount_0 or negedge rst_n) begin: vsync_counter
    if (!rst_n) begin
        vcount <= 0;
    end else if (hcount_0) begin
        if (vcount < 10'(V_SYNC_TIME - 1)) begin
            vcount <= vcount + 1;
        end else begin
            vcount <= 0;
        end
    end
end

// Putting this in always_ff adds a single clock cycle delay, which is what we need to make it match the tinytapeout design
always_ff @(posedge clk) begin
    if (!rst_n) begin
        vsync <= 0;
    end else if ((vcount >= 10'(V_PULSE_START)) && vcount < 10'(V_PULSE_END)) begin
        vsync <= 0;
    end else begin
        vsync <= 1;
    end
end


// FIXME: Can we just output hcount and vcount directly?
assign hpos = hcount;
assign vpos = vcount;


assign display_active = (hcount < 10'(DISPLAY_WIDTH)) && (vcount < 10'(DISPLAY_HEIGHT));


endmodule


`default_nettype wire

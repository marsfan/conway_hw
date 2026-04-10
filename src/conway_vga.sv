/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module conway_vga(
    input  wire       rst_n,    ///< System reset
    input  wire       int_clk,  ///< Internal 25MHZ system clock
    input  wire       ext_clk,  ///< Separate external clock for memory when loading
    input  wire       data_in,  ///< Serial data in
    input  wire [1:0] mode,     ///< current system mode
    output wire       data_out, ///< Serial data out
    output wire [1:0] red,      ///< VGA red channel
    output wire [1:0] green,    ///< VGA Green Channel
    output wire [1:0] blue,     ///< VGA Blue channel
    output wire       hsync,    ///< hsync signal
    output wire       vsync     ///< vsync signal
);
/* svlint on keyword_forbidden_wire_reg */

localparam int unsigned DISPLAY_WIDTH = 640;
localparam int unsigned DISPLAY_HEIGHT = 480;
localparam int unsigned NUM_ROWS = 8;
localparam int unsigned NUM_COLS = 8;
localparam int unsigned DATA_SIZE = NUM_ROWS * NUM_COLS;

// Width needed to store (NUM_ROWS-1) in counter
// $clog2(N) is ceil(log2(N))
// See https://www.edaboard.com/threads/what-is-the-clog2-built-in-function-do-in-systemverilog.167892/
localparam int COUNTER_WIDTH = $clog2(NUM_ROWS);

// FIXME: Some sort of assert that W*H=DATA_SIZE

logic [9:0]                 pix_x;                  ///< VGA current pixel x coordinate
logic [9:0]                 pix_y;                  ///< VGA current pixel y coordinate
logic                       calculator_clk;         ///< Gated clock for the bit of logic that handles actually calculating rows
logic                       row_calc_active;        ///< Indicates if we are currently supposed to be calculating rows or not
logic                       video_active;           ///< Whether or not we are currently drawing video.
logic [COUNTER_WIDTH - 1:0] row_count;              ///< Counter for tracking the row we are currently processing
logic [NUM_COLS - 1:0]      row_new_state;          ///< New states for the currently active row
logic [NUM_COLS - 1:0]      prev_row;               ///< Previous states for the row below the active row
logic [NUM_COLS - 1:0]      next_row;               ///< Previous states for the row above the active row
logic [DATA_SIZE - 1:0]     system_mem_parallel;    ///< Full set of states stored in system memory
logic                       muxed_clock;  ///< Clock for system memory that selects specific signals

logic load_mode;
logic run_mode;
logic output_mode;
logic fourth_mode;

decoder mode_decode(
    .val_in(mode),
    .val_00(load_mode),
    .val_01(run_mode),
    .val_10(output_mode),
    .val_11(fourth_mode)
);

logic [3:0] vsync_count;
// 4 bit counter for vsync.
// We use this so we don't update the display on every vsync, but
// every 15th vsync, so we can actually see thing changing
always_ff @(negedge vsync) begin
    if (!rst_n) begin
        vsync_count <= 0;
    end else begin
        vsync_count <= vsync_count + 1;
    end
end


always_ff @(posedge int_clk) begin
    if (!rst_n || vsync) begin
        row_count <= 0;
    end else if (!vsync_count) begin
        if (row_count < (NUM_ROWS - 1))  begin
            row_count <= row_count + 1;
        end
    end
end

logic memclk_en;
always_ff @(posedge int_clk) begin
    if (!rst_n || vsync) begin
        memclk_en <= 0;
    end else if (!vsync_count & (row_count < NUM_ROWS)) begin
        memclk_en <= 1;
    end else begin
        memclk_en <= 0;
    end
end

logic mem_clk;
// FIXME: Proper clock enable, not just a logic AND
assign mem_clk = run_mode ? (int_clk & memclk_en) : ext_clk;

system_memory_by_row #(
    .DATA_SIZE(DATA_SIZE),
    .ROW_SIZE(NUM_COLS)
) memory (
    .load_mode(load_mode),
    .run_mode(run_mode),
    .output_mode(output_mode),
    .serial_in(data_in),
    .top_row_in(row_new_state),
    .reset(rst_n),
    .clk(mem_clk),
    .prev_row(prev_row),
    .parallel_out(system_mem_parallel),
    .serial_out(data_out)
);

assign next_row = (row_count == COUNTER_WIDTH'(NUM_ROWS - 1)) ? 0 : system_mem_parallel[(2 * NUM_COLS) - 1:NUM_COLS];

single_row_processor #(NUM_COLS) row_calculator (
    .prev_row(prev_row),
    .this_row(system_mem_parallel[NUM_COLS - 1:0]),
    .next_row(next_row),
    .is_alive(row_new_state)
);

vga_sync_generator vga_generator(
    .clk(int_clk),
    .rst_n(rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_active(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
);

logic [9:0] cell_index;
screen_pos_to_index #(
    .SCREEN_WIDTH(DISPLAY_WIDTH),
    .SCREEN_HEIGHT(DISPLAY_HEIGHT),
    .NUM_ROWS(NUM_ROWS),
    .NUM_COLS(NUM_COLS)
) display_indexer(
    .pix_x(pix_x),
    .pix_y(pix_y),
    .index(cell_index)
);


logic [1:0] display_val = system_mem_parallel[cell_index] ? 2'b11 : 0;
assign red = video_active ? display_val : 0;
assign green = video_active ? display_val : 0;
assign blue = video_active ? display_val : 0;




endmodule



`default_nettype wire

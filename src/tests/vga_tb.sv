/*
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.org/MPL/2.0/.
*/

`default_nettype none

`timescale 1ns/1ps

module vga_tb();

    logic clk;
    logic reset;
    logic hsync_roper;
    logic vsync_roper;
    logic [9:0] hpos_roper;
    logic [9:0] vpos_roper;
    logic display_active_roper;


    logic hsync_tt;
    logic vsync_tt;
    logic [9:0] hpos_tt;
    logic [9:0] vpos_tt;
    logic display_active_tt;

    localparam CLOCK_TIME = 40ns;


    vga_sync_generator dut_roper (
        .clk(clk),
        .rst_n(reset),
        .hsync(hsync_roper),
        .vsync(vsync_roper),
        .hpos(hpos_roper),
        .vpos(vpos_roper),
        .display_active(display_active_roper)
     );

    hvsync_generator dut_tt (
        .clk(clk),
        .reset(~reset),
        .hsync(hsync_tt),
        .vsync(vsync_tt),
        .hpos(hpos_tt),
        .vpos(vpos_tt),
        .display_on(display_active_tt)
    );

    initial begin

        // Dump to VCD File
        $dumpfile("waveforms/vga_tb.vcd");
        $dumpvars(0, vga_tb);

        // Doing an sync reset for the TT VGA
        reset = 0;
        clk = 0;
        #(CLOCK_TIME /2);
        clk = 1;
        #(CLOCK_TIME /2);
        reset = 1;


        // DUT driver and logic comparer
        forever begin
            clk = 0;
            if ($realtime > 61ns) begin
               assert (hpos_roper == hpos_tt) else $fatal(2, "HPOS MISMATCH");
               assert (hsync_roper == hsync_tt) else $fatal(2, "HSYNC MISMATCH");
               assert (vpos_roper == vpos_tt) else $fatal(2, "VPOS MISMATCH");
                assert (vsync_roper == vsync_tt) else $fatal(2, "VSYNC MISMATCH");
                assert (display_active_roper == display_active_tt) else $fatal(2, "DISPLAY_ACTIVE MISMATCH");
            end
            #20;
            clk = 1;
            if ($realtime > 61ns) begin
               assert (hpos_roper == hpos_tt) else $fatal(2, "HPOS MISMATCH");
               assert (hsync_roper == hsync_tt) else $fatal(2, "HSYNC MISMATCH");
               assert (vpos_roper == vpos_tt) else $fatal(2, "VPOS MISMATCH");
                assert (vsync_roper == vsync_tt) else $fatal(2, "VSYNC MISMATCH");
                assert (display_active_roper == display_active_tt) else $fatal(2, "DISPLAY_ACTIVE MISMATCH");
            end
            #20;
            if ($realtime > 61ns) begin
               assert (hpos_roper == hpos_tt) else $fatal(2, "HPOS MISMATCH");
               assert (hsync_roper == hsync_tt) else $fatal(2, "HSYNC MISMATCH");
               assert (vpos_roper == vpos_tt) else $fatal(2, "VPOS MISMATCH");
                assert (vsync_roper == vsync_tt) else $fatal(2, "VSYNC MISMATCH");
                assert (display_active_roper == display_active_tt) else $fatal(2, "DISPLAY_ACTIVE MISMATCH");
            end
            // // if ($realtime > (100ms)) begin
            // if ($realtime > 80ns) begin
            //     $finish(2);
            // end
         end

    end


    // hsync Pulse width checker (T_pw)
    initial begin
        real start;
        real measured_width;
        forever begin
            @(negedge hsync_roper);
            start = $realtime;

            @(posedge hsync_roper);
            measured_width = $realtime - start;
            assert (measured_width == 3.84us) else $fatal(2, "Hsync Pulse Wrong Width", measured_width);
        end
    end

        // h sync time checker (T_s)
    initial begin
        real start;
        real measured_width;
        #40 // Wait a little bit for reset

        forever begin
            @(negedge hsync_roper);
            start = $realtime;

            @(negedge hsync_roper);
            measured_width = $realtime - start;
            assert (measured_width == 32us) else $fatal(2, "H sync time", measured_width);
        end
    end

    // vsync Pulse width checker
    initial begin
        real start;
        real measured_width;
        #40 // Wait a little bit for reset
        forever begin
            @(negedge vsync_roper);
            start = $realtime;

            @(posedge vsync_roper);
            measured_width = $realtime - start;
            assert (measured_width == 64us) else $fatal(2, "Vsync Pulse Wrong Width", measured_width);
        end
    end




    // Controls ending program
    initial begin
        #20ms $finish(2);
    end



endmodule

`default_nettype wire

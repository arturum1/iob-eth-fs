// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_fifo_async_conf.vh"

module iob_fifo_async #(
    parameter W_DATA_W = `IOB_FIFO_ASYNC_W_DATA_W,
    parameter R_DATA_W = `IOB_FIFO_ASYNC_R_DATA_W,
    parameter ADDR_W = `IOB_FIFO_ASYNC_ADDR_W,
    parameter BIG_ENDIAN = `IOB_FIFO_ASYNC_BIG_ENDIAN,
    parameter MAXDATA_W = `IOB_FIFO_ASYNC_MAXDATA_W,  // Don't change this parameter value!
    parameter MINDATA_W = `IOB_FIFO_ASYNC_MINDATA_W,  // Don't change this parameter value!
    parameter R = `IOB_FIFO_ASYNC_R,  // Don't change this parameter value!
    parameter MINADDR_W = `IOB_FIFO_ASYNC_MINADDR_W,  // Don't change this parameter value!
    parameter W_ADDR_W = `IOB_FIFO_ASYNC_W_ADDR_W,  // Don't change this parameter value!
    parameter R_ADDR_W = `IOB_FIFO_ASYNC_R_ADDR_W  // Don't change this parameter value!
) (
    // w_clk_en_rst_s: Write clock, clock enable and async reset
    input w_clk_i,
    input w_cke_i,
    input w_arst_i,
    input w_rst_i,
    input w_en_i,
    // w_data_i: Write data
    input [W_DATA_W-1:0] w_data_i,
    // w_full_o: Write full signal
    output w_full_o,
    // w_empty_o: Write empty signal
    output w_empty_o,
    // w_level_o: Write FIFO level
    output [ADDR_W+1-1:0] w_level_o,
    // r_clk_en_rst_s: Read clock, clock enable and async reset
    input r_clk_i,
    input r_cke_i,
    input r_arst_i,
    input r_rst_i,
    input r_en_i,
    // r_data_o: Read data
    output [R_DATA_W-1:0] r_data_o,
    // r_full_o: Read full signal
    output r_full_o,
    // r_empty_o: Read empty signal
    output r_empty_o,
    // r_level_o: Read fifo level
    output [ADDR_W+1-1:0] r_level_o,
    // extmem_io: External memory interface
    output ext_mem_w_clk_o,
    output [R-1:0] ext_mem_w_en_o,
    output [MINADDR_W-1:0] ext_mem_w_addr_o,
    output [MAXDATA_W-1:0] ext_mem_w_data_o,
    output ext_mem_r_clk_o,
    output [R-1:0] ext_mem_r_en_o,
    output [MINADDR_W-1:0] ext_mem_r_addr_o,
    input [MAXDATA_W-1:0] ext_mem_r_data_i
);

// Read address in binary format
    wire [R_ADDR_W+1-1:0] r_raddr_bin;
// Write address in binary format
    wire [R_ADDR_W+1-1:0] w_raddr_bin;
// Read address in binary format
    wire [W_ADDR_W+1-1:0] r_waddr_bin;
// Write address in binary format
    wire [W_ADDR_W+1-1:0] w_waddr_bin;
// Read address in binary format wire (negative edge)
    wire [ADDR_W+1-1:0] r_raddr_bin_n;
// Write address in binary format wire (negative edge)
    wire [ADDR_W+1-1:0] r_waddr_bin_n;
// Write address in binary format wire (negative edge)
    wire [ADDR_W+1-1:0] w_raddr_bin_n;
// Write address in binary format wire (negative edge)
    wire [ADDR_W+1-1:0] w_waddr_bin_n;
// Write address in gray format
    wire [W_ADDR_W+1-1:0] w_waddr_gray;
// Read address in gray format
    wire [W_ADDR_W+1-1:0] r_waddr_gray;
// Read address in gray format
    wire [R_ADDR_W+1-1:0] r_raddr_gray;
// Write address in gray format
    wire [R_ADDR_W+1-1:0] w_raddr_gray;
// Internal read level
    wire [(ADDR_W+1)-1:0] r_level_int;
// Internal write level
    wire [(ADDR_W+1)-1:0] w_level_int;
// Internal read enable
    wire r_en_int;
// Internal write enable
    wire w_en_int;
// Write address wire
    wire [W_ADDR_W-1:0] w_addr;
// Read address wire
    wire [R_ADDR_W-1:0] r_addr;


// SPDX-FileCopyrightText: 2025 IObundle
//
// SPDX-License-Identifier: MIT

function [31:0] iob_max;
   input [31:0] a;
   input [31:0] b;
   begin
      if (a > b) iob_max = a;
      else iob_max = b;
   end
endfunction

function [31:0] iob_min;
   input [31:0] a;
   input [31:0] b;
   begin
      if (a < b) iob_min = a;
      else iob_min = b;
   end
endfunction

function [31:0] iob_cshift_left;
   input [31:0] DATA;
   input integer DATA_WIDTH;
   input integer SHIFT;
   begin
      iob_cshift_left = (DATA << SHIFT) | (DATA >> (DATA_WIDTH - SHIFT));
   end
endfunction

function [31:0] iob_cshift_right;
   input [31:0] DATA;
   input integer DATA_WIDTH;
   input integer SHIFT;
   begin
      iob_cshift_right = (DATA >> SHIFT) | (DATA << (DATA_WIDTH - SHIFT));
   end
endfunction

function integer iob_abs;
   input integer a;
   begin
      iob_abs = (a >= 0) ? a : -a;
   end
endfunction

function integer iob_sign;
   input integer a;
   begin
      if (a < 0)
        iob_sign = -1;
      else
        iob_sign = 1;
   end
endfunction
                 localparam ADDR_W_DIFF = $clog2(R);  //difference between read and write address widths
                 localparam [ADDR_W:0] FIFO_SIZE = {1'b1, {ADDR_W{1'b0}}};  //in bytes
                 localparam [ADDR_W-1:0] W_INCR = (W_DATA_W > R_DATA_W) ? 1'b1 << ADDR_W_DIFF : 1'b1;
                 localparam [ADDR_W-1:0] R_INCR = (R_DATA_W > W_DATA_W) ? 1'b1 << ADDR_W_DIFF : 1'b1;
                 generate
                    if (W_DATA_W > R_DATA_W) begin : g_write_wider_bin
                        assign w_waddr_bin_n = w_waddr_bin << ADDR_W_DIFF;
                        assign w_raddr_bin_n = w_raddr_bin;
                        assign r_raddr_bin_n = r_raddr_bin;
                        assign r_waddr_bin_n = r_waddr_bin << ADDR_W_DIFF;
                    end else if (R_DATA_W > W_DATA_W) begin : g_read_wider_bin
                        assign w_waddr_bin_n = w_waddr_bin;
                        assign w_raddr_bin_n = w_raddr_bin << ADDR_W_DIFF;
                        assign r_raddr_bin_n = r_raddr_bin << ADDR_W_DIFF;
                        assign r_waddr_bin_n = r_waddr_bin;
                    end else begin : g_write_equals_read_bin
                        assign w_raddr_bin_n = w_raddr_bin;
                        assign w_waddr_bin_n = w_waddr_bin;
                        assign r_waddr_bin_n = r_waddr_bin;
                        assign r_raddr_bin_n = r_raddr_bin;
                    end
                endgenerate
                assign r_level_int = r_waddr_bin_n - r_raddr_bin_n;
                assign r_level_o   = r_level_int[0+:(ADDR_W+1)];
                //READ DOMAIN EMPTY AND FULL FLAGS
                assign r_empty_o   = (r_level_int < {2'd0, R_INCR});
                assign r_full_o    = (r_level_int > (FIFO_SIZE - {2'd0, R_INCR}));
                assign w_level_int = w_waddr_bin_n - w_raddr_bin_n;
                assign w_level_o   = w_level_int[0+:(ADDR_W+1)];
                assign w_empty_o   = (w_level_int < {2'd0, W_INCR});
                assign w_full_o    = (w_level_int > (FIFO_SIZE - {2'd0, W_INCR}));
                assign r_en_int = (r_en_i & (~r_empty_o));
                assign w_en_int = (w_en_i & (~w_full_o));
                assign w_addr = w_waddr_bin[W_ADDR_W-1:0];
                assign r_addr          = r_raddr_bin[R_ADDR_W-1:0];
                assign ext_mem_w_clk_o = w_clk_i;
                assign ext_mem_r_clk_o = r_clk_i;
                

        // Default description
        iob_gray_counter #(
        .W((R_ADDR_W + 1))
    ) r_raddr_gray_counter (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(r_clk_i),
        .cke_i(r_cke_i),
        .arst_i(r_arst_i),
        .rst_i(r_rst_i),
        .en_i(r_en_int),
        // data_o port: Data output
        .data_o(r_raddr_gray)
        );

            // Default description
        iob_gray_counter #(
        .W((W_ADDR_W + 1))
    ) w_waddr_gray_counter (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(w_clk_i),
        .cke_i(w_cke_i),
        .arst_i(w_arst_i),
        .rst_i(w_rst_i),
        .en_i(w_en_int),
        // data_o port: Data output
        .data_o(w_waddr_gray)
        );

            // Default description
        iob_gray2bin #(
        .DATA_W((R_ADDR_W + 1))
    ) gray2bin_r_raddr (
            // gr_i port: Gray input
        .gr_i(r_raddr_gray),
        // bin_o port: Binary output
        .bin_o(r_raddr_bin)
        );

            // Default description
        iob_gray2bin #(
        .DATA_W((W_ADDR_W + 1))
    ) gray2bin_r_raddr_sync (
            // gr_i port: Gray input
        .gr_i(r_waddr_gray),
        // bin_o port: Binary output
        .bin_o(r_waddr_bin)
        );

            // Default description
        iob_gray2bin #(
        .DATA_W((W_ADDR_W + 1))
    ) gray2bin_w_waddr (
            // gr_i port: Gray input
        .gr_i(w_waddr_gray),
        // bin_o port: Binary output
        .bin_o(w_waddr_bin)
        );

            // Default description
        iob_gray2bin #(
        .DATA_W((R_ADDR_W + 1))
    ) gray2bin_w_raddr_sync (
            // gr_i port: Gray input
        .gr_i(w_raddr_gray),
        // bin_o port: Binary output
        .bin_o(w_raddr_bin)
        );

            // Default description
        iob_sync #(
        .DATA_W((W_ADDR_W + 1)),
        .RST_VAL({(W_ADDR_W + 1) {1'd0}})
    ) w_waddr_gray_sync0 (
            // clk_rst_s port: Clock and reset
        .clk_i(r_clk_i),
        .arst_i(r_arst_i),
        // signal_i port: Input port
        .signal_i(w_waddr_gray),
        // signal_o port: Output port
        .signal_o(r_waddr_gray)
        );

            // Default description
        iob_sync #(
        .DATA_W((R_ADDR_W + 1)),
        .RST_VAL({(R_ADDR_W + 1) {1'd0}})
    ) r_raddr_gray_sync0 (
            // clk_rst_s port: Clock and reset
        .clk_i(w_clk_i),
        .arst_i(w_arst_i),
        // signal_i port: Input port
        .signal_i(r_raddr_gray),
        // signal_o port: Output port
        .signal_o(w_raddr_gray)
        );

            // Default description
        iob_asym_converter #(
        .W_DATA_W(W_DATA_W),
        .R_DATA_W(R_DATA_W),
        .ADDR_W(ADDR_W),
        .BIG_ENDIAN(BIG_ENDIAN)
    ) asym_converter (
            // extmem_io port: External memory interface
        .ext_mem_w_en_o(ext_mem_w_en_o),
        .ext_mem_w_addr_o(ext_mem_w_addr_o),
        .ext_mem_w_data_o(ext_mem_w_data_o),
        .ext_mem_r_en_o(ext_mem_r_en_o),
        .ext_mem_r_addr_o(ext_mem_r_addr_o),
        .ext_mem_r_data_i(ext_mem_r_data_i),
        // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(r_clk_i),
        .cke_i(r_cke_i),
        .arst_i(r_arst_i),
        .rst_i(r_rst_i),
        // write_i port: Write interface
        .w_en_i(w_en_int),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i),
        // read_io port: Read interface
        .r_en_i(r_en_int),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o)
        );

    
endmodule

// SPDX-FileCopyrightText: 2025 IObundle
//
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

`include "iob_axis_s_axi_m_write_conf.vh"

module iob_axis_s_axi_m_write #(
    parameter AXI_ADDR_W = `IOB_AXIS_S_AXI_M_WRITE_AXI_ADDR_W,
    parameter AXI_LEN_W = `IOB_AXIS_S_AXI_M_WRITE_AXI_LEN_W,
    parameter AXI_DATA_W = `IOB_AXIS_S_AXI_M_WRITE_AXI_DATA_W,
    parameter AXI_ID_W = `IOB_AXIS_S_AXI_M_WRITE_AXI_ID_W,
    parameter WLEN_W = `IOB_AXIS_S_AXI_M_WRITE_WLEN_W
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // rst_i: Synchronous reset interface
    input rst_i,
    // config_write_io: 
    input [AXI_ADDR_W-1:0] w_addr_i,
    input [WLEN_W-1:0] w_length_i,
    input w_start_transfer_i,
    input [(AXI_LEN_W+1)-1:0] w_max_len_i,
    output [WLEN_W-1:0] w_remaining_data_o,
    output w_busy_o,
    // axis_in_io: 
    input [AXI_DATA_W-1:0] axis_in_tdata_i,
    input axis_in_tvalid_i,
    output axis_in_tready_o,
    // axi_write_m: AXI interface
    output [AXI_ADDR_W-1:0] axi_awaddr_o,
    output axi_awvalid_o,
    input axi_awready_i,
    output [AXI_DATA_W-1:0] axi_wdata_o,
    output [AXI_DATA_W/8-1:0] axi_wstrb_o,
    output axi_wvalid_o,
    input axi_wready_i,
    input [2-1:0] axi_bresp_i,
    input axi_bvalid_i,
    output axi_bready_o,
    output [AXI_ID_W-1:0] axi_awid_o,
    output [AXI_LEN_W-1:0] axi_awlen_o,
    output [3-1:0] axi_awsize_o,
    output [2-1:0] axi_awburst_o,
    output [2-1:0] axi_awlock_o,
    output [4-1:0] axi_awcache_o,
    output [4-1:0] axi_awqos_o,
    output axi_wlast_o,
    input [AXI_ID_W-1:0] axi_bid_i,
    // ext_mem_m: External memory interface
    output ext_mem_write_clk_o,
    output ext_mem_write_r_en_o,
    output [AXI_LEN_W-1:0] ext_mem_write_r_addr_o,
    input [AXI_DATA_W-1:0] ext_mem_write_r_data_i,
    output ext_mem_write_w_en_o,
    output [AXI_LEN_W-1:0] ext_mem_write_w_addr_o,
    output [AXI_DATA_W-1:0] ext_mem_write_w_data_o
);

   localparam WAIT_START = 1'd0, WAIT_DATA_IN_FIFO = 1'd1;
   localparam LEN_DIFF = WLEN_W - (AXI_LEN_W+1);

   wire [(AXI_LEN_W+1)-1:0] fifo_level;
   wire                     fifo_full;
   assign axis_in_tready_o = ~fifo_full;
   wire                  fifo_ren;
   wire [AXI_DATA_W-1:0] fifo_rdata;
   wire                  fifo_empty;

   // FIFO
   iob_fifo_sync #(
      .W_DATA_W(AXI_DATA_W),
      .R_DATA_W(AXI_DATA_W),
      .ADDR_W  (AXI_LEN_W)
   ) buffer_inst (
      // Global signals
      .clk_i           (clk_i),
      .cke_i           (cke_i),
      .arst_i          (arst_i),
      .rst_i           (rst_i),
      // Write port
      .w_en_i          (axis_in_tvalid_i),
      .w_data_i        (axis_in_tdata_i),
      .w_full_o        (fifo_full),
      // Read port
      .r_en_i          (fifo_ren),
      .r_data_o        (fifo_rdata),
      .r_empty_o       (fifo_empty),
      // External memory interface
      .ext_mem_clk_o   (ext_mem_write_clk_o),
      .ext_mem_w_en_o  (ext_mem_write_w_en_o),
      .ext_mem_w_addr_o(ext_mem_write_w_addr_o),
      .ext_mem_w_data_o(ext_mem_write_w_data_o),
      .ext_mem_r_en_o  (ext_mem_write_r_en_o),
      .ext_mem_r_addr_o(ext_mem_write_r_addr_o),
      .ext_mem_r_data_i(ext_mem_write_r_data_i),
      // FIFO level
      .level_o         (fifo_level)
   );

   wire [         2-1:0] fifo2axis_lvl;
   wire                  axis_tvalid_int;
   wire [AXI_DATA_W-1:0] axis_tdata_int;
   wire                  axis_tready_int;
   iob_fifo2axis #(
      .DATA_W    (AXI_DATA_W),
      .AXIS_LEN_W(1)
   ) fifo2axis_inst (
      // Global signals
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i        (rst_i),
      .en_i         (1'b1),
      .len_i        (1'b1),
      .level_o      (fifo2axis_lvl),
      // FIFO I/F
      .fifo_empty_i (fifo_empty),
      .fifo_read_o  (fifo_ren),
      .fifo_rdata_i (fifo_rdata),
      // AXIS I/F
      .axis_tvalid_o(axis_tvalid_int),
      .axis_tdata_o (axis_tdata_int),
      .axis_tready_i(axis_tready_int),
      .axis_tlast_o ()
   );

   wire [(AXI_LEN_W+2)-1:0] level_int = {1'd0,fifo_level} + {1'd0,fifo2axis_lvl};

   reg                      w_state_nxt;
   wire                     w_state;
   reg  [   WLEN_W-1:0]     w_remaining_data_nxt;
   reg  [(AXI_LEN_W+1)-1:0] burst_length;
   reg  [   AXI_ADDR_W-1:0] w_addr_int_nxt;
   wire [   AXI_ADDR_W-1:0] burst_addr;
   reg                      start_burst;
   wire                     busy;
   reg                      w_busy_int;

   assign w_busy_o = w_busy_int;

   always @* begin
      // FSM
      // Default assignments
      w_busy_int             = 1'b1;
      w_state_nxt          = w_state;
      w_remaining_data_nxt = w_remaining_data_o;
      w_addr_int_nxt       = burst_addr;
      start_burst          = 1'b0;
      burst_length         = 0;

      case (w_state)
         WAIT_START: begin
            w_busy_int = 1'b0;
            if (w_start_transfer_i) begin
               w_remaining_data_nxt = w_length_i;
               w_addr_int_nxt       = w_addr_i;
               w_state_nxt          = WAIT_DATA_IN_FIFO;
            end
         end
         default: begin  // WAIT_DATA_IN_FIFO
            if (!busy) begin
               if (w_remaining_data_o > 0) begin
                  if (({{(LEN_DIFF-1){1'b0}}, level_int} >= w_remaining_data_o) &&
                        (w_remaining_data_o <= {{LEN_DIFF{1'b0}}, w_max_len_i})) begin
                     // RX FIFO has enough data to transfer the remaining data
                     burst_length = w_remaining_data_o[0+:(AXI_LEN_W+1)];
                  end else if (level_int >= {1'd0,w_max_len_i}) begin
                     // RX FIFO has enough data for a burst transfer
                     burst_length = w_max_len_i;
                  end

                  if (burst_length > 0) begin
                     // Start the transfer
                     start_burst          = 1'd1;
                     // Set values for the next transfer
                     w_remaining_data_nxt = w_remaining_data_o - burst_length;
                     w_addr_int_nxt       = burst_addr + (burst_length << 2);
                  end
               end else begin
                  w_state_nxt = WAIT_START;
               end
            end
         end
      endcase
   end

   // State register
   iob_reg_car #(
      .DATA_W (1),
      .RST_VAL(1'd0)
   ) w_state_reg (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      .data_i(w_state_nxt),
      .data_o(w_state)
   );

   // Length registers
   iob_reg_car #(
      .DATA_W (WLEN_W),
      .RST_VAL({WLEN_W{1'b0}})
   ) w_length_reg (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      .data_i(w_remaining_data_nxt),
      .data_o(w_remaining_data_o)
   );

   // Address registers
   iob_reg_car #(
      .DATA_W (AXI_ADDR_W),
      .RST_VAL({AXI_ADDR_W{1'b0}})
   ) w_addr_reg (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      .data_i(w_addr_int_nxt),
      .data_o(burst_addr)
   );

   iob_axis_s_axi_m_write_int #(
      .AXI_ADDR_W(AXI_ADDR_W),
      .AXI_DATA_W(AXI_DATA_W),
      .AXI_LEN_W (AXI_LEN_W),
      .AXI_ID_W  (AXI_ID_W)
   ) axis2axi_inst (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i(rst_i),

.axi_awaddr_o(axi_awaddr_o),
.axi_awvalid_o(axi_awvalid_o),
.axi_awready_i(axi_awready_i),
.axi_wdata_o(axi_wdata_o),
.axi_wstrb_o(axi_wstrb_o),
.axi_wvalid_o(axi_wvalid_o),
.axi_wready_i(axi_wready_i),
.axi_bresp_i(axi_bresp_i),
.axi_bvalid_i(axi_bvalid_i),
.axi_bready_o(axi_bready_o),
.axi_awid_o(axi_awid_o),
.axi_awlen_o(axi_awlen_o),
.axi_awsize_o(axi_awsize_o),
.axi_awburst_o(axi_awburst_o),
.axi_awlock_o(axi_awlock_o),
.axi_awcache_o(axi_awcache_o),
.axi_awqos_o(axi_awqos_o),
.axi_wlast_o(axi_wlast_o),
.axi_bid_i(axi_bid_i),

      .w_addr_i          (burst_addr),
      .w_length_i        (burst_length),
      .w_strb_i          (4'b1111),
      .w_start_transfer_i(start_burst),
      .w_busy_o          (busy),

      .axis_in_data_i (axis_tdata_int),
      .axis_in_valid_i(axis_tvalid_int),
      .axis_in_ready_o(axis_tready_int)
   );

endmodule

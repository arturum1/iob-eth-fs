// SPDX-FileCopyrightText: 2025 IObundle
//
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

/*
   This unit breaks down an AXIS into multiple bursts of AXI.
   Address (and length) are set by using the write_ or read_ interfaces.
   The busy signals can be used to probe the state of the transfer. When asserted,
   they indicate that the unit is doing a data transfer.
   Both AXIS In and AXIS Out operate individually and can work simultaneously (these units can also
   be instantiated individually)
   4k boundaries are handled automatically.

AXIS Out:
   After configuring read_addr and read_length, the axis_out transfer can start by setting the
   read_start_transfer signal. There is no limit to the amount of data that can be sent.

AXIS In:
   After configuring write_addr and write_length, the axis_in transfer can start by setting the
   write_start_transfer signal.
   Length is given as the amount of dwords. A length of 1 means that one transfer is performed.
   If the axis_in interface is stalled permanently before completing the full transfer, the unit
   might block the entire system, as it will continue to keep the AXI connection alive.
   If for some reason the user realises that it requested a length bigger then need, the user still
   needs to keep outputing data out of the axis_in interface. Only when write_busy is de-asserted
   has the transfer fully completed.

Note: if the transfer goes over the maximum size, given by AXI_ADDR_W,
   the transfer will wrap around and will start reading/writing to the lower addresses.
*/

`include "iob_axis_s_axi_m_conf.vh"

module iob_axis_s_axi_m #(
    parameter AXI_ADDR_W = `IOB_AXIS_S_AXI_M_AXI_ADDR_W,
    parameter AXI_LEN_W = `IOB_AXIS_S_AXI_M_AXI_LEN_W,
    parameter AXI_DATA_W = `IOB_AXIS_S_AXI_M_AXI_DATA_W,
    parameter AXI_ID_W = `IOB_AXIS_S_AXI_M_AXI_ID_W,
    parameter WLEN_W = `IOB_AXIS_S_AXI_M_WLEN_W,
    parameter RLEN_W = `IOB_AXIS_S_AXI_M_RLEN_W,
    parameter WRITE_HEXFILE = `IOB_AXIS_S_AXI_M_WRITE_HEXFILE,  // Don't change this parameter value!
    parameter READ_HEXFILE = `IOB_AXIS_S_AXI_M_READ_HEXFILE  // Don't change this parameter value!
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
    // config_read_io: 
    input [AXI_ADDR_W-1:0] r_addr_i,
    input [RLEN_W-1:0] r_length_i,
    input r_start_transfer_i,
    input [(AXI_LEN_W+1)-1:0] r_max_len_i,
    output [RLEN_W-1:0] r_remaining_data_o,
    output r_busy_o,
    // axis_in_io: 
    input [AXI_DATA_W-1:0] axis_in_tdata_i,
    input axis_in_tvalid_i,
    output axis_in_tready_o,
    // axis_out_io: 
    output [AXI_DATA_W-1:0] axis_out_tdata_o,
    output axis_out_tvalid_o,
    input axis_out_tready_i,
    // write_ext_mem_m: External memory interface
    output ext_mem_write_clk_o,
    output ext_mem_write_r_en_o,
    output [AXI_LEN_W-1:0] ext_mem_write_r_addr_o,
    input [AXI_DATA_W-1:0] ext_mem_write_r_data_i,
    output ext_mem_write_w_en_o,
    output [AXI_LEN_W-1:0] ext_mem_write_w_addr_o,
    output [AXI_DATA_W-1:0] ext_mem_write_w_data_o,
    // read_ext_mem_m: External memory interface
    output ext_mem_read_clk_o,
    output ext_mem_read_r_en_o,
    output [AXI_LEN_W-1:0] ext_mem_read_r_addr_o,
    input [AXI_DATA_W-1:0] ext_mem_read_r_data_i,
    output ext_mem_read_w_en_o,
    output [AXI_LEN_W-1:0] ext_mem_read_w_addr_o,
    output [AXI_DATA_W-1:0] ext_mem_read_w_data_o,
    // axi_m: AXI interface
    output [AXI_ADDR_W-1:0] axi_araddr_o,
    output axi_arvalid_o,
    input axi_arready_i,
    input [AXI_DATA_W-1:0] axi_rdata_i,
    input [2-1:0] axi_rresp_i,
    input axi_rvalid_i,
    output axi_rready_o,
    output [AXI_ID_W-1:0] axi_arid_o,
    output [AXI_LEN_W-1:0] axi_arlen_o,
    output [3-1:0] axi_arsize_o,
    output [2-1:0] axi_arburst_o,
    output [2-1:0] axi_arlock_o,
    output [4-1:0] axi_arcache_o,
    output [4-1:0] axi_arqos_o,
    input [AXI_ID_W-1:0] axi_rid_i,
    input axi_rlast_i,
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
    input [AXI_ID_W-1:0] axi_bid_i
);

   iob_axis_s_axi_m_read #(
      .AXI_ADDR_W(AXI_ADDR_W),
      .AXI_LEN_W (AXI_LEN_W),
      .AXI_DATA_W(AXI_DATA_W),
      .AXI_ID_W  (AXI_ID_W),
      .RLEN_W(RLEN_W)
   ) axis_s_axi_m_read0 (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i(rst_i),

      .r_addr_i          (r_addr_i),
      .r_length_i        (r_length_i),
      .r_start_transfer_i(r_start_transfer_i),
      .r_max_len_i       (r_max_len_i),
      .r_remaining_data_o(r_remaining_data_o),
      .r_busy_o          (r_busy_o),

      .axis_out_tdata_o (axis_out_tdata_o),
      .axis_out_tvalid_o(axis_out_tvalid_o),
      .axis_out_tready_i(axis_out_tready_i),

.axi_araddr_o(axi_araddr_o),
.axi_arvalid_o(axi_arvalid_o),
.axi_arready_i(axi_arready_i),
.axi_rdata_i(axi_rdata_i),
.axi_rresp_i(axi_rresp_i),
.axi_rvalid_i(axi_rvalid_i),
.axi_rready_o(axi_rready_o),
.axi_arid_o(axi_arid_o),
.axi_arlen_o(axi_arlen_o),
.axi_arsize_o(axi_arsize_o),
.axi_arburst_o(axi_arburst_o),
.axi_arlock_o(axi_arlock_o),
.axi_arcache_o(axi_arcache_o),
.axi_arqos_o(axi_arqos_o),
.axi_rid_i(axi_rid_i),
.axi_rlast_i(axi_rlast_i),

      .ext_mem_read_clk_o(ext_mem_read_clk_o),
      .ext_mem_read_r_data_i(ext_mem_read_r_data_i),
      .ext_mem_read_r_en_o(ext_mem_read_r_en_o),
      .ext_mem_read_r_addr_o(ext_mem_read_r_addr_o),
      .ext_mem_read_w_data_o(ext_mem_read_w_data_o),
      .ext_mem_read_w_addr_o(ext_mem_read_w_addr_o),
      .ext_mem_read_w_en_o(ext_mem_read_w_en_o)
   );

   iob_axis_s_axi_m_write #(
      .AXI_ADDR_W(AXI_ADDR_W),
      .AXI_LEN_W (AXI_LEN_W),
      .AXI_DATA_W(AXI_DATA_W),
      .AXI_ID_W  (AXI_ID_W),
      .WLEN_W(WLEN_W)
   ) axis_s_axi_m_write0 (
      .clk_i(clk_i),
      .cke_i(cke_i),
      .arst_i(arst_i),
      .rst_i(rst_i),

      .w_addr_i          (w_addr_i),
      .w_length_i        (w_length_i),
      .w_start_transfer_i(w_start_transfer_i),
      .w_max_len_i       (w_max_len_i),
      .w_remaining_data_o(w_remaining_data_o),
      .w_busy_o          (w_busy_o),

      .axis_in_tdata_i (axis_in_tdata_i),
      .axis_in_tvalid_i(axis_in_tvalid_i),
      .axis_in_tready_o(axis_in_tready_o),

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

      .ext_mem_write_clk_o(ext_mem_write_clk_o),
      .ext_mem_write_r_data_i(ext_mem_write_r_data_i),
      .ext_mem_write_r_en_o(ext_mem_write_r_en_o),
      .ext_mem_write_r_addr_o(ext_mem_write_r_addr_o),
      .ext_mem_write_w_data_o(ext_mem_write_w_data_o),
      .ext_mem_write_w_addr_o(ext_mem_write_w_addr_o),
      .ext_mem_write_w_en_o(ext_mem_write_w_en_o)
   );

endmodule

// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_eth_csrs_conf.vh"

module iob_eth_csrs #(
   parameter ADDR_W      = `IOB_ETH_CSRS_ADDR_W,       // Don't change this parameter value!
   parameter DATA_W      = `IOB_ETH_CSRS_DATA_W,
   parameter AXI_ID_W    = `IOB_ETH_CSRS_AXI_ID_W,
   parameter AXI_ADDR_W  = `IOB_ETH_CSRS_AXI_ADDR_W,
   parameter AXI_DATA_W  = `IOB_ETH_CSRS_AXI_DATA_W,
   parameter AXI_LEN_W   = `IOB_ETH_CSRS_AXI_LEN_W,
   parameter PHY_RST_CNT = `IOB_ETH_CSRS_PHY_RST_CNT,
   parameter BD_NUM_LOG2 = `IOB_ETH_CSRS_BD_NUM_LOG2,
   parameter BUFFER_W    = `IOB_ETH_CSRS_BUFFER_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                                              clk_i,
   input                                              cke_i,
   input                                              arst_i,
   // control_if_s: CSR control interface. Interface type defined by `csr_if` parameter.
   input                                              iob_valid_i,
   input  [                                   12-1:0] iob_addr_i,
   input  [                               DATA_W-1:0] iob_wdata_i,
   input  [                             DATA_W/8-1:0] iob_wstrb_i,
   output                                             iob_rvalid_o,
   output [                               DATA_W-1:0] iob_rdata_o,
   output                                             iob_ready_o,
   // moder_io: moder register interface
   output [                                   32-1:0] moder_rdata_o,
   input  [                                   32-1:0] moder_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] moder_wstrb_i,
   // int_source_io: int_source register interface
   output [                                   32-1:0] int_source_rdata_o,
   input  [                                   32-1:0] int_source_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] int_source_wstrb_i,
   // int_mask_io: int_mask register interface
   output [                                   32-1:0] int_mask_rdata_o,
   input  [                                   32-1:0] int_mask_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] int_mask_wstrb_i,
   // ipgt_io: ipgt register interface
   output [                                   32-1:0] ipgt_rdata_o,
   input  [                                   32-1:0] ipgt_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] ipgt_wstrb_i,
   // ipgr1_io: ipgr1 register interface
   output [                                   32-1:0] ipgr1_rdata_o,
   input  [                                   32-1:0] ipgr1_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] ipgr1_wstrb_i,
   // ipgr2_io: ipgr2 register interface
   output [                                   32-1:0] ipgr2_rdata_o,
   input  [                                   32-1:0] ipgr2_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] ipgr2_wstrb_i,
   // packetlen_io: packetlen register interface
   output [                                   32-1:0] packetlen_rdata_o,
   input  [                                   32-1:0] packetlen_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] packetlen_wstrb_i,
   // collconf_io: collconf register interface
   output [                                   32-1:0] collconf_rdata_o,
   input  [                                   32-1:0] collconf_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] collconf_wstrb_i,
   // tx_bd_num_io: tx_bd_num register interface
   output [                                   32-1:0] tx_bd_num_rdata_o,
   input  [                                   32-1:0] tx_bd_num_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] tx_bd_num_wstrb_i,
   // ctrlmoder_io: ctrlmoder register interface
   output [                                   32-1:0] ctrlmoder_rdata_o,
   input  [                                   32-1:0] ctrlmoder_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] ctrlmoder_wstrb_i,
   // miimoder_io: miimoder register interface
   output [                                   32-1:0] miimoder_rdata_o,
   input  [                                   32-1:0] miimoder_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miimoder_wstrb_i,
   // miicommand_io: miicommand register interface
   output [                                   32-1:0] miicommand_rdata_o,
   input  [                                   32-1:0] miicommand_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miicommand_wstrb_i,
   // miiaddress_io: miiaddress register interface
   output [                                   32-1:0] miiaddress_rdata_o,
   input  [                                   32-1:0] miiaddress_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miiaddress_wstrb_i,
   // miitx_data_io: miitx_data register interface
   output [                                   32-1:0] miitx_data_rdata_o,
   input  [                                   32-1:0] miitx_data_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miitx_data_wstrb_i,
   // miirx_data_io: miirx_data register interface
   output [                                   32-1:0] miirx_data_rdata_o,
   input  [                                   32-1:0] miirx_data_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miirx_data_wstrb_i,
   // miistatus_io: miistatus register interface
   output [                                   32-1:0] miistatus_rdata_o,
   input  [                                   32-1:0] miistatus_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] miistatus_wstrb_i,
   // mac_addr0_io: mac_addr0 register interface
   output [                                   32-1:0] mac_addr0_rdata_o,
   input  [                                   32-1:0] mac_addr0_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] mac_addr0_wstrb_i,
   // mac_addr1_io: mac_addr1 register interface
   output [                                   32-1:0] mac_addr1_rdata_o,
   input  [                                   32-1:0] mac_addr1_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] mac_addr1_wstrb_i,
   // eth_hash0_adr_io: eth_hash0_adr register interface
   output [                                   32-1:0] eth_hash0_adr_rdata_o,
   input  [                                   32-1:0] eth_hash0_adr_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] eth_hash0_adr_wstrb_i,
   // eth_hash1_adr_io: eth_hash1_adr register interface
   output [                                   32-1:0] eth_hash1_adr_rdata_o,
   input  [                                   32-1:0] eth_hash1_adr_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] eth_hash1_adr_wstrb_i,
   // eth_txctrl_io: eth_txctrl register interface
   output [                                   32-1:0] eth_txctrl_rdata_o,
   input  [                                   32-1:0] eth_txctrl_wdata_i,
   input  [              ((32/8 > 1) ? 32/8 : 1)-1:0] eth_txctrl_wstrb_i,
   // tx_bd_cnt_io: tx_bd_cnt register interface
   output                                             tx_bd_cnt_valid_o,
   input  [((BD_NUM_LOG2 > 1) ? BD_NUM_LOG2 : 1)-1:0] tx_bd_cnt_rdata_i,
   input                                              tx_bd_cnt_ready_i,
   input                                              tx_bd_cnt_rvalid_i,
   // rx_bd_cnt_io: rx_bd_cnt register interface
   output                                             rx_bd_cnt_valid_o,
   input  [((BD_NUM_LOG2 > 1) ? BD_NUM_LOG2 : 1)-1:0] rx_bd_cnt_rdata_i,
   input                                              rx_bd_cnt_ready_i,
   input                                              rx_bd_cnt_rvalid_i,
   // tx_word_cnt_io: tx_word_cnt register interface
   output                                             tx_word_cnt_valid_o,
   input  [      ((BUFFER_W > 1) ? BUFFER_W : 1)-1:0] tx_word_cnt_rdata_i,
   input                                              tx_word_cnt_ready_i,
   input                                              tx_word_cnt_rvalid_i,
   // rx_word_cnt_io: rx_word_cnt register interface
   output                                             rx_word_cnt_valid_o,
   input  [      ((BUFFER_W > 1) ? BUFFER_W : 1)-1:0] rx_word_cnt_rdata_i,
   input                                              rx_word_cnt_ready_i,
   input                                              rx_word_cnt_rvalid_i,
   // rx_nbytes_io: rx_nbytes register interface
   output                                             rx_nbytes_valid_o,
   input  [      ((BUFFER_W > 1) ? BUFFER_W : 1)-1:0] rx_nbytes_rdata_i,
   input                                              rx_nbytes_ready_i,
   input                                              rx_nbytes_rvalid_i,
   // frame_word_io: frame_word register interface
   output                                             frame_word_valid_o,
   output [                                    8-1:0] frame_word_wdata_o,
   output [                ((8/8 > 1) ? 8/8 : 1)-1:0] frame_word_wstrb_o,
   input                                              frame_word_ready_i,
   input  [                                    8-1:0] frame_word_rdata_i,
   input                                              frame_word_rvalid_i,
   // phy_rst_val_i: phy_rst_val register interface
   input                                              phy_rst_val_wdata_i,
   // bd_io: bd register interface
   output                                             bd_valid_o,
   output [                      BD_NUM_LOG2+1+2-1:0] bd_addr_o,
   output [                                   32-1:0] bd_wdata_o,
   output [              ((32/8 > 1) ? 32/8 : 1)-1:0] bd_wstrb_o,
   input                                              bd_ready_i,
   input  [                                   32-1:0] bd_rdata_i,
   input                                              bd_rvalid_i
);

   // Internal iob interface
   wire                               internal_iob_valid;
   wire [                 ADDR_W-1:0] internal_iob_addr;
   wire [                 DATA_W-1:0] internal_iob_wdata;
   wire [               DATA_W/8-1:0] internal_iob_wstrb;
   wire                               internal_iob_rvalid;
   wire [                 DATA_W-1:0] internal_iob_rdata;
   wire                               internal_iob_ready;
   wire                               state;
   reg                                state_nxt;
   wire                               write_en;
   wire [                 ADDR_W-1:0] internal_iob_addr_stable;
   wire [                 ADDR_W-1:0] internal_iob_addr_reg;
   wire                               internal_iob_addr_reg_en;
   wire [                     32-1:0] moder_wdata;
   wire                               moder_w_valid;
   wire                               moder_reg_en;
   wire [                     32-1:0] moder_reg_data;
   wire [                     32-1:0] int_source_wdata;
   wire                               int_source_w_valid;
   wire                               int_source_reg_en;
   wire [                     32-1:0] int_source_reg_data;
   wire [                     32-1:0] int_mask_wdata;
   wire                               int_mask_w_valid;
   wire                               int_mask_reg_en;
   wire [                     32-1:0] int_mask_reg_data;
   wire [                     32-1:0] ipgt_wdata;
   wire                               ipgt_w_valid;
   wire                               ipgt_reg_en;
   wire [                     32-1:0] ipgt_reg_data;
   wire [                     32-1:0] ipgr1_wdata;
   wire                               ipgr1_w_valid;
   wire                               ipgr1_reg_en;
   wire [                     32-1:0] ipgr1_reg_data;
   wire [                     32-1:0] ipgr2_wdata;
   wire                               ipgr2_w_valid;
   wire                               ipgr2_reg_en;
   wire [                     32-1:0] ipgr2_reg_data;
   wire [                     32-1:0] packetlen_wdata;
   wire                               packetlen_w_valid;
   wire                               packetlen_reg_en;
   wire [                     32-1:0] packetlen_reg_data;
   wire [                     32-1:0] collconf_wdata;
   wire                               collconf_w_valid;
   wire                               collconf_reg_en;
   wire [                     32-1:0] collconf_reg_data;
   wire [                     32-1:0] tx_bd_num_wdata;
   wire                               tx_bd_num_w_valid;
   wire                               tx_bd_num_reg_en;
   wire [                     32-1:0] tx_bd_num_reg_data;
   wire [                     32-1:0] ctrlmoder_wdata;
   wire                               ctrlmoder_w_valid;
   wire                               ctrlmoder_reg_en;
   wire [                     32-1:0] ctrlmoder_reg_data;
   wire [                     32-1:0] miimoder_wdata;
   wire                               miimoder_w_valid;
   wire                               miimoder_reg_en;
   wire [                     32-1:0] miimoder_reg_data;
   wire [                     32-1:0] miicommand_wdata;
   wire                               miicommand_w_valid;
   wire                               miicommand_reg_en;
   wire [                     32-1:0] miicommand_reg_data;
   wire [                     32-1:0] miiaddress_wdata;
   wire                               miiaddress_w_valid;
   wire                               miiaddress_reg_en;
   wire [                     32-1:0] miiaddress_reg_data;
   wire [                     32-1:0] miitx_data_wdata;
   wire                               miitx_data_w_valid;
   wire                               miitx_data_reg_en;
   wire [                     32-1:0] miitx_data_reg_data;
   wire [                     32-1:0] miirx_data_wdata;
   wire                               miirx_data_w_valid;
   wire                               miirx_data_reg_en;
   wire [                     32-1:0] miirx_data_reg_data;
   wire [                     32-1:0] miistatus_wdata;
   wire                               miistatus_w_valid;
   wire                               miistatus_reg_en;
   wire [                     32-1:0] miistatus_reg_data;
   wire [                     32-1:0] mac_addr0_wdata;
   wire                               mac_addr0_w_valid;
   wire                               mac_addr0_reg_en;
   wire [                     32-1:0] mac_addr0_reg_data;
   wire [                     32-1:0] mac_addr1_wdata;
   wire                               mac_addr1_w_valid;
   wire                               mac_addr1_reg_en;
   wire [                     32-1:0] mac_addr1_reg_data;
   wire [                     32-1:0] eth_hash0_adr_wdata;
   wire                               eth_hash0_adr_w_valid;
   wire                               eth_hash0_adr_reg_en;
   wire [                     32-1:0] eth_hash0_adr_reg_data;
   wire [                     32-1:0] eth_hash1_adr_wdata;
   wire                               eth_hash1_adr_w_valid;
   wire                               eth_hash1_adr_reg_en;
   wire [                     32-1:0] eth_hash1_adr_reg_data;
   wire [                     32-1:0] eth_txctrl_wdata;
   wire                               eth_txctrl_w_valid;
   wire                               eth_txctrl_reg_en;
   wire [                     32-1:0] eth_txctrl_reg_data;
   wire [                      8-1:0] frame_word_wdata;
   wire [  ((8/8 > 1) ? 8/8 : 1)-1:0] frame_word_wstrb;
   wire [                     32-1:0] bd_wdata;
   wire [((32/8 > 1) ? 32/8 : 1)-1:0] bd_wstrb;
   wire [                     32-1:0] moder_rdata;
   wire [                     32-1:0] int_source_rdata;
   wire [                     32-1:0] int_mask_rdata;
   wire [                     32-1:0] ipgt_rdata;
   wire [                     32-1:0] ipgr1_rdata;
   wire [                     32-1:0] ipgr2_rdata;
   wire [                     32-1:0] packetlen_rdata;
   wire [                     32-1:0] collconf_rdata;
   wire [                     32-1:0] tx_bd_num_rdata;
   wire [                     32-1:0] ctrlmoder_rdata;
   wire [                     32-1:0] miimoder_rdata;
   wire [                     32-1:0] miicommand_rdata;
   wire [                     32-1:0] miiaddress_rdata;
   wire [                     32-1:0] miitx_data_rdata;
   wire [                     32-1:0] miirx_data_rdata;
   wire [                     32-1:0] miistatus_rdata;
   wire [                     32-1:0] mac_addr0_rdata;
   wire [                     32-1:0] mac_addr1_rdata;
   wire [                     32-1:0] eth_hash0_adr_rdata;
   wire [                     32-1:0] eth_hash1_adr_rdata;
   wire [                     32-1:0] eth_txctrl_rdata;
   wire                               phy_rst_val_rdata;
   wire                               iob_rvalid_out;
   reg                                iob_rvalid_nxt;
   wire [                     32-1:0] iob_rdata_out;
   reg  [                     32-1:0] iob_rdata_nxt;
   wire                               iob_ready_out;
   reg                                iob_ready_nxt;
   // Rvalid signal of currently addressed CSR
   reg                                rvalid_int;
   // Ready signal of currently addressed CSR
   reg                                ready_int;


   // Include iob_functions for use in parameters
   localparam IOB_MAX_W = ADDR_W;
   function [IOB_MAX_W-1:0] iob_max;
      input [IOB_MAX_W-1:0] a;
      input [IOB_MAX_W-1:0] b;
      begin
         if (a > b) iob_max = a;
         else iob_max = b;
      end
   endfunction

   function integer iob_abs;
      input integer a;
      begin
         iob_abs = (a >= 0) ? a : -a;
      end
   endfunction

   `define IOB_NBYTES (DATA_W/8)
   `define IOB_NBYTES_W $clog2(`IOB_NBYTES)
   `define IOB_WORD_ADDR(ADDR) ((ADDR>>`IOB_NBYTES_W)<<`IOB_NBYTES_W)

   localparam WSTRB_W = DATA_W / 8;

   //FSM states
   localparam WAIT_REQ = 1'd0;
   localparam WAIT_RVALID = 1'd1;


   assign internal_iob_addr_reg_en = internal_iob_valid;
   assign internal_iob_addr_stable = internal_iob_valid ? internal_iob_addr : internal_iob_addr_reg;

   assign write_en = |internal_iob_wstrb;

   //write address
   wire [($clog2(WSTRB_W)+1)-1:0] byte_offset;
   iob_ctls #(
      .W     (WSTRB_W),
      .MODE  (0),
      .SYMBOL(0)
   ) bo_inst (
      .data_i (internal_iob_wstrb),
      .count_o(byte_offset)
   );

   wire [ADDR_W-1:0] wstrb_addr;
   assign wstrb_addr = `IOB_WORD_ADDR(internal_iob_addr_stable) + byte_offset;

   // Create a special readstrobe for "REG" (auto) CSRs.
   // LSBs 0 = read full word; LSBs 1 = read byte; LSBs 2 = read half word; LSBs 3 = read byte.
   reg [1:0] shift_amount;
   always @(*) begin
      case (internal_iob_addr_stable[1:0])
         // Access entire word
         2'b00:   shift_amount = 2;
         // Access single byte
         2'b01:   shift_amount = 0;
         // Access half word
         2'b10:   shift_amount = 1;
         // Access single byte
         2'b11:   shift_amount = 0;
         default: shift_amount = 0;
      endcase
   end


   //NAME: moder;
   //MODE: RW; WIDTH: 32; RST_VAL: 40960; ADDR: 0; SPACE (bytes): 4 (max); TYPE: REG. 

   assign moder_wdata = internal_iob_wdata[0+:32];
   wire moder_addressed_w;
   assign moder_addressed_w = (wstrb_addr < 4);
   assign moder_w_valid     = internal_iob_valid & (write_en & moder_addressed_w);
   assign moder_rdata       = moder_rdata_o;
   assign moder_reg_en      = moder_w_valid | (|moder_wstrb_i);
   assign moder_reg_data    = moder_w_valid ? moder_wdata : moder_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd40960)
   ) moder_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (moder_reg_en),
      .data_i(moder_reg_data),
      .data_o(moder_rdata_o)
   );



   //NAME: int_source;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: REG. 

   assign int_source_wdata = internal_iob_wdata[0+:32];
   wire int_source_addressed_w;
   assign int_source_addressed_w = (wstrb_addr >= (4)) && (wstrb_addr < 8);
   assign int_source_w_valid     = internal_iob_valid & (write_en & int_source_addressed_w);
   assign int_source_rdata       = int_source_rdata_o;
   assign int_source_reg_en      = int_source_w_valid | (|int_source_wstrb_i);
   assign int_source_reg_data    = int_source_w_valid ? int_source_wdata : int_source_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) int_source_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (int_source_reg_en),
      .data_i(int_source_reg_data),
      .data_o(int_source_rdata_o)
   );



   //NAME: int_mask;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 8; SPACE (bytes): 4 (max); TYPE: REG. 

   assign int_mask_wdata = internal_iob_wdata[0+:32];
   wire int_mask_addressed_w;
   assign int_mask_addressed_w = (wstrb_addr >= (8)) && (wstrb_addr < 12);
   assign int_mask_w_valid     = internal_iob_valid & (write_en & int_mask_addressed_w);
   assign int_mask_rdata       = int_mask_rdata_o;
   assign int_mask_reg_en      = int_mask_w_valid | (|int_mask_wstrb_i);
   assign int_mask_reg_data    = int_mask_w_valid ? int_mask_wdata : int_mask_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) int_mask_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (int_mask_reg_en),
      .data_i(int_mask_reg_data),
      .data_o(int_mask_rdata_o)
   );



   //NAME: ipgt;
   //MODE: RW; WIDTH: 32; RST_VAL: 18; ADDR: 12; SPACE (bytes): 4 (max); TYPE: REG. 

   assign ipgt_wdata = internal_iob_wdata[0+:32];
   wire ipgt_addressed_w;
   assign ipgt_addressed_w = (wstrb_addr >= (12)) && (wstrb_addr < 16);
   assign ipgt_w_valid     = internal_iob_valid & (write_en & ipgt_addressed_w);
   assign ipgt_rdata       = ipgt_rdata_o;
   assign ipgt_reg_en      = ipgt_w_valid | (|ipgt_wstrb_i);
   assign ipgt_reg_data    = ipgt_w_valid ? ipgt_wdata : ipgt_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd18)
   ) ipgt_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (ipgt_reg_en),
      .data_i(ipgt_reg_data),
      .data_o(ipgt_rdata_o)
   );



   //NAME: ipgr1;
   //MODE: RW; WIDTH: 32; RST_VAL: 12; ADDR: 16; SPACE (bytes): 4 (max); TYPE: REG. 

   assign ipgr1_wdata = internal_iob_wdata[0+:32];
   wire ipgr1_addressed_w;
   assign ipgr1_addressed_w = (wstrb_addr >= (16)) && (wstrb_addr < 20);
   assign ipgr1_w_valid     = internal_iob_valid & (write_en & ipgr1_addressed_w);
   assign ipgr1_rdata       = ipgr1_rdata_o;
   assign ipgr1_reg_en      = ipgr1_w_valid | (|ipgr1_wstrb_i);
   assign ipgr1_reg_data    = ipgr1_w_valid ? ipgr1_wdata : ipgr1_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd12)
   ) ipgr1_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (ipgr1_reg_en),
      .data_i(ipgr1_reg_data),
      .data_o(ipgr1_rdata_o)
   );



   //NAME: ipgr2;
   //MODE: RW; WIDTH: 32; RST_VAL: 18; ADDR: 20; SPACE (bytes): 4 (max); TYPE: REG. 

   assign ipgr2_wdata = internal_iob_wdata[0+:32];
   wire ipgr2_addressed_w;
   assign ipgr2_addressed_w = (wstrb_addr >= (20)) && (wstrb_addr < 24);
   assign ipgr2_w_valid     = internal_iob_valid & (write_en & ipgr2_addressed_w);
   assign ipgr2_rdata       = ipgr2_rdata_o;
   assign ipgr2_reg_en      = ipgr2_w_valid | (|ipgr2_wstrb_i);
   assign ipgr2_reg_data    = ipgr2_w_valid ? ipgr2_wdata : ipgr2_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd18)
   ) ipgr2_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (ipgr2_reg_en),
      .data_i(ipgr2_reg_data),
      .data_o(ipgr2_rdata_o)
   );



   //NAME: packetlen;
   //MODE: RW; WIDTH: 32; RST_VAL: 4195840; ADDR: 24; SPACE (bytes): 4 (max); TYPE: REG. 

   assign packetlen_wdata = internal_iob_wdata[0+:32];
   wire packetlen_addressed_w;
   assign packetlen_addressed_w = (wstrb_addr >= (24)) && (wstrb_addr < 28);
   assign packetlen_w_valid     = internal_iob_valid & (write_en & packetlen_addressed_w);
   assign packetlen_rdata       = packetlen_rdata_o;
   assign packetlen_reg_en      = packetlen_w_valid | (|packetlen_wstrb_i);
   assign packetlen_reg_data    = packetlen_w_valid ? packetlen_wdata : packetlen_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd4195840)
   ) packetlen_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (packetlen_reg_en),
      .data_i(packetlen_reg_data),
      .data_o(packetlen_rdata_o)
   );



   //NAME: collconf;
   //MODE: RW; WIDTH: 32; RST_VAL: 61443; ADDR: 28; SPACE (bytes): 4 (max); TYPE: REG. 

   assign collconf_wdata = internal_iob_wdata[0+:32];
   wire collconf_addressed_w;
   assign collconf_addressed_w = (wstrb_addr >= (28)) && (wstrb_addr < 32);
   assign collconf_w_valid     = internal_iob_valid & (write_en & collconf_addressed_w);
   assign collconf_rdata       = collconf_rdata_o;
   assign collconf_reg_en      = collconf_w_valid | (|collconf_wstrb_i);
   assign collconf_reg_data    = collconf_w_valid ? collconf_wdata : collconf_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd61443)
   ) collconf_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (collconf_reg_en),
      .data_i(collconf_reg_data),
      .data_o(collconf_rdata_o)
   );



   //NAME: tx_bd_num;
   //MODE: RW; WIDTH: 32; RST_VAL: 64; ADDR: 32; SPACE (bytes): 4 (max); TYPE: REG. 

   assign tx_bd_num_wdata = internal_iob_wdata[0+:32];
   wire tx_bd_num_addressed_w;
   assign tx_bd_num_addressed_w = (wstrb_addr >= (32)) && (wstrb_addr < 36);
   assign tx_bd_num_w_valid     = internal_iob_valid & (write_en & tx_bd_num_addressed_w);
   assign tx_bd_num_rdata       = tx_bd_num_rdata_o;
   assign tx_bd_num_reg_en      = tx_bd_num_w_valid | (|tx_bd_num_wstrb_i);
   assign tx_bd_num_reg_data    = tx_bd_num_w_valid ? tx_bd_num_wdata : tx_bd_num_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd64)
   ) tx_bd_num_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (tx_bd_num_reg_en),
      .data_i(tx_bd_num_reg_data),
      .data_o(tx_bd_num_rdata_o)
   );



   //NAME: ctrlmoder;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 36; SPACE (bytes): 4 (max); TYPE: REG. 

   assign ctrlmoder_wdata = internal_iob_wdata[0+:32];
   wire ctrlmoder_addressed_w;
   assign ctrlmoder_addressed_w = (wstrb_addr >= (36)) && (wstrb_addr < 40);
   assign ctrlmoder_w_valid     = internal_iob_valid & (write_en & ctrlmoder_addressed_w);
   assign ctrlmoder_rdata       = ctrlmoder_rdata_o;
   assign ctrlmoder_reg_en      = ctrlmoder_w_valid | (|ctrlmoder_wstrb_i);
   assign ctrlmoder_reg_data    = ctrlmoder_w_valid ? ctrlmoder_wdata : ctrlmoder_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) ctrlmoder_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (ctrlmoder_reg_en),
      .data_i(ctrlmoder_reg_data),
      .data_o(ctrlmoder_rdata_o)
   );



   //NAME: miimoder;
   //MODE: RW; WIDTH: 32; RST_VAL: 100; ADDR: 40; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miimoder_wdata = internal_iob_wdata[0+:32];
   wire miimoder_addressed_w;
   assign miimoder_addressed_w = (wstrb_addr >= (40)) && (wstrb_addr < 44);
   assign miimoder_w_valid     = internal_iob_valid & (write_en & miimoder_addressed_w);
   assign miimoder_rdata       = miimoder_rdata_o;
   assign miimoder_reg_en      = miimoder_w_valid | (|miimoder_wstrb_i);
   assign miimoder_reg_data    = miimoder_w_valid ? miimoder_wdata : miimoder_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd100)
   ) miimoder_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miimoder_reg_en),
      .data_i(miimoder_reg_data),
      .data_o(miimoder_rdata_o)
   );



   //NAME: miicommand;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 44; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miicommand_wdata = internal_iob_wdata[0+:32];
   wire miicommand_addressed_w;
   assign miicommand_addressed_w = (wstrb_addr >= (44)) && (wstrb_addr < 48);
   assign miicommand_w_valid     = internal_iob_valid & (write_en & miicommand_addressed_w);
   assign miicommand_rdata       = miicommand_rdata_o;
   assign miicommand_reg_en      = miicommand_w_valid | (|miicommand_wstrb_i);
   assign miicommand_reg_data    = miicommand_w_valid ? miicommand_wdata : miicommand_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) miicommand_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miicommand_reg_en),
      .data_i(miicommand_reg_data),
      .data_o(miicommand_rdata_o)
   );



   //NAME: miiaddress;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 48; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miiaddress_wdata = internal_iob_wdata[0+:32];
   wire miiaddress_addressed_w;
   assign miiaddress_addressed_w = (wstrb_addr >= (48)) && (wstrb_addr < 52);
   assign miiaddress_w_valid     = internal_iob_valid & (write_en & miiaddress_addressed_w);
   assign miiaddress_rdata       = miiaddress_rdata_o;
   assign miiaddress_reg_en      = miiaddress_w_valid | (|miiaddress_wstrb_i);
   assign miiaddress_reg_data    = miiaddress_w_valid ? miiaddress_wdata : miiaddress_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) miiaddress_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miiaddress_reg_en),
      .data_i(miiaddress_reg_data),
      .data_o(miiaddress_rdata_o)
   );



   //NAME: miitx_data;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 52; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miitx_data_wdata = internal_iob_wdata[0+:32];
   wire miitx_data_addressed_w;
   assign miitx_data_addressed_w = (wstrb_addr >= (52)) && (wstrb_addr < 56);
   assign miitx_data_w_valid     = internal_iob_valid & (write_en & miitx_data_addressed_w);
   assign miitx_data_rdata       = miitx_data_rdata_o;
   assign miitx_data_reg_en      = miitx_data_w_valid | (|miitx_data_wstrb_i);
   assign miitx_data_reg_data    = miitx_data_w_valid ? miitx_data_wdata : miitx_data_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) miitx_data_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miitx_data_reg_en),
      .data_i(miitx_data_reg_data),
      .data_o(miitx_data_rdata_o)
   );



   //NAME: miirx_data;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 56; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miirx_data_wdata = internal_iob_wdata[0+:32];
   wire miirx_data_addressed_w;
   assign miirx_data_addressed_w = (wstrb_addr >= (56)) && (wstrb_addr < 60);
   assign miirx_data_w_valid     = internal_iob_valid & (write_en & miirx_data_addressed_w);
   assign miirx_data_rdata       = miirx_data_rdata_o;
   assign miirx_data_reg_en      = miirx_data_w_valid | (|miirx_data_wstrb_i);
   assign miirx_data_reg_data    = miirx_data_w_valid ? miirx_data_wdata : miirx_data_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) miirx_data_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miirx_data_reg_en),
      .data_i(miirx_data_reg_data),
      .data_o(miirx_data_rdata_o)
   );



   //NAME: miistatus;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 60; SPACE (bytes): 4 (max); TYPE: REG. 

   assign miistatus_wdata = internal_iob_wdata[0+:32];
   wire miistatus_addressed_w;
   assign miistatus_addressed_w = (wstrb_addr >= (60)) && (wstrb_addr < 64);
   assign miistatus_w_valid     = internal_iob_valid & (write_en & miistatus_addressed_w);
   assign miistatus_rdata       = miistatus_rdata_o;
   assign miistatus_reg_en      = miistatus_w_valid | (|miistatus_wstrb_i);
   assign miistatus_reg_data    = miistatus_w_valid ? miistatus_wdata : miistatus_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) miistatus_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (miistatus_reg_en),
      .data_i(miistatus_reg_data),
      .data_o(miistatus_rdata_o)
   );



   //NAME: mac_addr0;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 64; SPACE (bytes): 4 (max); TYPE: REG. 

   assign mac_addr0_wdata = internal_iob_wdata[0+:32];
   wire mac_addr0_addressed_w;
   assign mac_addr0_addressed_w = (wstrb_addr >= (64)) && (wstrb_addr < 68);
   assign mac_addr0_w_valid     = internal_iob_valid & (write_en & mac_addr0_addressed_w);
   assign mac_addr0_rdata       = mac_addr0_rdata_o;
   assign mac_addr0_reg_en      = mac_addr0_w_valid | (|mac_addr0_wstrb_i);
   assign mac_addr0_reg_data    = mac_addr0_w_valid ? mac_addr0_wdata : mac_addr0_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) mac_addr0_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (mac_addr0_reg_en),
      .data_i(mac_addr0_reg_data),
      .data_o(mac_addr0_rdata_o)
   );



   //NAME: mac_addr1;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 68; SPACE (bytes): 4 (max); TYPE: REG. 

   assign mac_addr1_wdata = internal_iob_wdata[0+:32];
   wire mac_addr1_addressed_w;
   assign mac_addr1_addressed_w = (wstrb_addr >= (68)) && (wstrb_addr < 72);
   assign mac_addr1_w_valid     = internal_iob_valid & (write_en & mac_addr1_addressed_w);
   assign mac_addr1_rdata       = mac_addr1_rdata_o;
   assign mac_addr1_reg_en      = mac_addr1_w_valid | (|mac_addr1_wstrb_i);
   assign mac_addr1_reg_data    = mac_addr1_w_valid ? mac_addr1_wdata : mac_addr1_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) mac_addr1_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (mac_addr1_reg_en),
      .data_i(mac_addr1_reg_data),
      .data_o(mac_addr1_rdata_o)
   );



   //NAME: eth_hash0_adr;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 72; SPACE (bytes): 4 (max); TYPE: REG. 

   assign eth_hash0_adr_wdata = internal_iob_wdata[0+:32];
   wire eth_hash0_adr_addressed_w;
   assign eth_hash0_adr_addressed_w = (wstrb_addr >= (72)) && (wstrb_addr < 76);
   assign eth_hash0_adr_w_valid = internal_iob_valid & (write_en & eth_hash0_adr_addressed_w);
   assign eth_hash0_adr_rdata = eth_hash0_adr_rdata_o;
   assign eth_hash0_adr_reg_en = eth_hash0_adr_w_valid | (|eth_hash0_adr_wstrb_i);
   assign eth_hash0_adr_reg_data = eth_hash0_adr_w_valid ? eth_hash0_adr_wdata : eth_hash0_adr_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) eth_hash0_adr_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (eth_hash0_adr_reg_en),
      .data_i(eth_hash0_adr_reg_data),
      .data_o(eth_hash0_adr_rdata_o)
   );



   //NAME: eth_hash1_adr;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 76; SPACE (bytes): 4 (max); TYPE: REG. 

   assign eth_hash1_adr_wdata = internal_iob_wdata[0+:32];
   wire eth_hash1_adr_addressed_w;
   assign eth_hash1_adr_addressed_w = (wstrb_addr >= (76)) && (wstrb_addr < 80);
   assign eth_hash1_adr_w_valid = internal_iob_valid & (write_en & eth_hash1_adr_addressed_w);
   assign eth_hash1_adr_rdata = eth_hash1_adr_rdata_o;
   assign eth_hash1_adr_reg_en = eth_hash1_adr_w_valid | (|eth_hash1_adr_wstrb_i);
   assign eth_hash1_adr_reg_data = eth_hash1_adr_w_valid ? eth_hash1_adr_wdata : eth_hash1_adr_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) eth_hash1_adr_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (eth_hash1_adr_reg_en),
      .data_i(eth_hash1_adr_reg_data),
      .data_o(eth_hash1_adr_rdata_o)
   );



   //NAME: eth_txctrl;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 80; SPACE (bytes): 4 (max); TYPE: REG. 

   assign eth_txctrl_wdata = internal_iob_wdata[0+:32];
   wire eth_txctrl_addressed_w;
   assign eth_txctrl_addressed_w = (wstrb_addr >= (80)) && (wstrb_addr < 84);
   assign eth_txctrl_w_valid     = internal_iob_valid & (write_en & eth_txctrl_addressed_w);
   assign eth_txctrl_rdata       = eth_txctrl_rdata_o;
   assign eth_txctrl_reg_en      = eth_txctrl_w_valid | (|eth_txctrl_wstrb_i);
   assign eth_txctrl_reg_data    = eth_txctrl_w_valid ? eth_txctrl_wdata : eth_txctrl_wdata_i;
   iob_reg_cae #(
      .DATA_W (32),
      .RST_VAL(32'd0)
   ) eth_txctrl_datareg_wr (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (eth_txctrl_reg_en),
      .data_i(eth_txctrl_reg_data),
      .data_o(eth_txctrl_rdata_o)
   );



   //NAME: frame_word;
   //MODE: RW; WIDTH: 8; RST_VAL: 0; ADDR: 104; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   assign frame_word_wdata = internal_iob_wdata[0+:8];
   wire frame_word_addressed;
   assign frame_word_addressed = (internal_iob_addr_stable >= (104)) &&  (internal_iob_addr_stable < 105);
   assign frame_word_valid_o = internal_iob_valid & frame_word_addressed;
   assign frame_word_wstrb = internal_iob_wstrb[0/8+:((8/8>1)?8/8 : 1)];
   assign frame_word_wstrb_o = frame_word_wstrb;
   assign frame_word_wdata_o = frame_word_wdata;


   //NAME: bd;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 1024; SPACE (bytes): 1024 (max); TYPE: NOAUTO. 

   assign bd_wdata = internal_iob_wdata[0+:32];
   wire bd_addressed;
   assign bd_addressed = (internal_iob_addr_stable >= (1024)) &&  (internal_iob_addr_stable < (1024+(2**(BD_NUM_LOG2+1+2))));
   assign bd_valid_o = internal_iob_valid & bd_addressed;
   assign bd_addr_o = internal_iob_addr_stable - 1024;
   assign bd_wstrb = internal_iob_wstrb[0/8+:((32/8>1)?32/8 : 1)];
   assign bd_wstrb_o = bd_wstrb;
   assign bd_wdata_o = bd_wdata;


   //NAME: moder;
   //MODE: RW; WIDTH: 32; RST_VAL: 40960; ADDR: 0; SPACE (bytes): 4 (max); TYPE: REG. 

   wire moder_addressed_r;
   assign moder_addressed_r = (internal_iob_addr_stable >> shift_amount <= iob_max(
       1, 3 >> shift_amount
   ));


   //NAME: int_source;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: REG. 

   wire int_source_addressed_r;
   assign int_source_addressed_r = (internal_iob_addr_stable>>shift_amount >= (4>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 7 >> shift_amount
   ));


   //NAME: int_mask;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 8; SPACE (bytes): 4 (max); TYPE: REG. 

   wire int_mask_addressed_r;
   assign int_mask_addressed_r = (internal_iob_addr_stable>>shift_amount >= (8>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 11 >> shift_amount
   ));


   //NAME: ipgt;
   //MODE: RW; WIDTH: 32; RST_VAL: 18; ADDR: 12; SPACE (bytes): 4 (max); TYPE: REG. 

   wire ipgt_addressed_r;
   assign ipgt_addressed_r = (internal_iob_addr_stable>>shift_amount >= (12>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 15 >> shift_amount
   ));


   //NAME: ipgr1;
   //MODE: RW; WIDTH: 32; RST_VAL: 12; ADDR: 16; SPACE (bytes): 4 (max); TYPE: REG. 

   wire ipgr1_addressed_r;
   assign ipgr1_addressed_r = (internal_iob_addr_stable>>shift_amount >= (16>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 19 >> shift_amount
   ));


   //NAME: ipgr2;
   //MODE: RW; WIDTH: 32; RST_VAL: 18; ADDR: 20; SPACE (bytes): 4 (max); TYPE: REG. 

   wire ipgr2_addressed_r;
   assign ipgr2_addressed_r = (internal_iob_addr_stable>>shift_amount >= (20>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 23 >> shift_amount
   ));


   //NAME: packetlen;
   //MODE: RW; WIDTH: 32; RST_VAL: 4195840; ADDR: 24; SPACE (bytes): 4 (max); TYPE: REG. 

   wire packetlen_addressed_r;
   assign packetlen_addressed_r = (internal_iob_addr_stable>>shift_amount >= (24>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 27 >> shift_amount
   ));


   //NAME: collconf;
   //MODE: RW; WIDTH: 32; RST_VAL: 61443; ADDR: 28; SPACE (bytes): 4 (max); TYPE: REG. 

   wire collconf_addressed_r;
   assign collconf_addressed_r = (internal_iob_addr_stable>>shift_amount >= (28>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 31 >> shift_amount
   ));


   //NAME: tx_bd_num;
   //MODE: RW; WIDTH: 32; RST_VAL: 64; ADDR: 32; SPACE (bytes): 4 (max); TYPE: REG. 

   wire tx_bd_num_addressed_r;
   assign tx_bd_num_addressed_r = (internal_iob_addr_stable>>shift_amount >= (32>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 35 >> shift_amount
   ));


   //NAME: ctrlmoder;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 36; SPACE (bytes): 4 (max); TYPE: REG. 

   wire ctrlmoder_addressed_r;
   assign ctrlmoder_addressed_r = (internal_iob_addr_stable>>shift_amount >= (36>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 39 >> shift_amount
   ));


   //NAME: miimoder;
   //MODE: RW; WIDTH: 32; RST_VAL: 100; ADDR: 40; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miimoder_addressed_r;
   assign miimoder_addressed_r = (internal_iob_addr_stable>>shift_amount >= (40>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 43 >> shift_amount
   ));


   //NAME: miicommand;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 44; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miicommand_addressed_r;
   assign miicommand_addressed_r = (internal_iob_addr_stable>>shift_amount >= (44>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 47 >> shift_amount
   ));


   //NAME: miiaddress;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 48; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miiaddress_addressed_r;
   assign miiaddress_addressed_r = (internal_iob_addr_stable>>shift_amount >= (48>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 51 >> shift_amount
   ));


   //NAME: miitx_data;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 52; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miitx_data_addressed_r;
   assign miitx_data_addressed_r = (internal_iob_addr_stable>>shift_amount >= (52>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 55 >> shift_amount
   ));


   //NAME: miirx_data;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 56; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miirx_data_addressed_r;
   assign miirx_data_addressed_r = (internal_iob_addr_stable>>shift_amount >= (56>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 59 >> shift_amount
   ));


   //NAME: miistatus;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 60; SPACE (bytes): 4 (max); TYPE: REG. 

   wire miistatus_addressed_r;
   assign miistatus_addressed_r = (internal_iob_addr_stable>>shift_amount >= (60>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 63 >> shift_amount
   ));


   //NAME: mac_addr0;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 64; SPACE (bytes): 4 (max); TYPE: REG. 

   wire mac_addr0_addressed_r;
   assign mac_addr0_addressed_r = (internal_iob_addr_stable>>shift_amount >= (64>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 67 >> shift_amount
   ));


   //NAME: mac_addr1;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 68; SPACE (bytes): 4 (max); TYPE: REG. 

   wire mac_addr1_addressed_r;
   assign mac_addr1_addressed_r = (internal_iob_addr_stable>>shift_amount >= (68>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 71 >> shift_amount
   ));


   //NAME: eth_hash0_adr;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 72; SPACE (bytes): 4 (max); TYPE: REG. 

   wire eth_hash0_adr_addressed_r;
   assign eth_hash0_adr_addressed_r = (internal_iob_addr_stable>>shift_amount >= (72>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 75 >> shift_amount
   ));


   //NAME: eth_hash1_adr;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 76; SPACE (bytes): 4 (max); TYPE: REG. 

   wire eth_hash1_adr_addressed_r;
   assign eth_hash1_adr_addressed_r = (internal_iob_addr_stable>>shift_amount >= (76>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 79 >> shift_amount
   ));


   //NAME: eth_txctrl;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 80; SPACE (bytes): 4 (max); TYPE: REG. 

   wire eth_txctrl_addressed_r;
   assign eth_txctrl_addressed_r = (internal_iob_addr_stable>>shift_amount >= (80>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 83 >> shift_amount
   ));


   //NAME: tx_bd_cnt;
   //MODE: R; WIDTH: BD_NUM_LOG2; RST_VAL: 0; ADDR: 84; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   wire tx_bd_cnt_addressed;
   assign tx_bd_cnt_addressed = (internal_iob_addr_stable >= (84)) && (internal_iob_addr_stable < 85);
   assign tx_bd_cnt_valid_o = internal_iob_valid & tx_bd_cnt_addressed & ~write_en;


   //NAME: rx_bd_cnt;
   //MODE: R; WIDTH: BD_NUM_LOG2; RST_VAL: 0; ADDR: 88; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   wire rx_bd_cnt_addressed;
   assign rx_bd_cnt_addressed = (internal_iob_addr_stable >= (88)) && (internal_iob_addr_stable < 89);
   assign rx_bd_cnt_valid_o = internal_iob_valid & rx_bd_cnt_addressed & ~write_en;


   //NAME: tx_word_cnt;
   //MODE: R; WIDTH: BUFFER_W; RST_VAL: 0; ADDR: 92; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire tx_word_cnt_addressed;
   assign tx_word_cnt_addressed = (internal_iob_addr_stable >= (92)) && (internal_iob_addr_stable < 96);
   assign tx_word_cnt_valid_o = internal_iob_valid & tx_word_cnt_addressed & ~write_en;


   //NAME: rx_word_cnt;
   //MODE: R; WIDTH: BUFFER_W; RST_VAL: 0; ADDR: 96; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire rx_word_cnt_addressed;
   assign rx_word_cnt_addressed = (internal_iob_addr_stable >= (96)) && (internal_iob_addr_stable < 100);
   assign rx_word_cnt_valid_o = internal_iob_valid & rx_word_cnt_addressed & ~write_en;


   //NAME: rx_nbytes;
   //MODE: R; WIDTH: BUFFER_W; RST_VAL: 0; ADDR: 100; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire rx_nbytes_addressed;
   assign rx_nbytes_addressed = (internal_iob_addr_stable >= (100)) && (internal_iob_addr_stable < 104);
   assign rx_nbytes_valid_o = internal_iob_valid & rx_nbytes_addressed & ~write_en;


   //NAME: frame_word;
   //MODE: RW; WIDTH: 8; RST_VAL: 0; ADDR: 104; SPACE (bytes): 1 (max); TYPE: NOAUTO. 



   //NAME: phy_rst_val;
   //MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 108; SPACE (bytes): 1 (max); TYPE: REG. 

   wire phy_rst_val_addressed_r;
   assign phy_rst_val_addressed_r = (internal_iob_addr_stable>>shift_amount >= (108>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 108 >> shift_amount
   ));
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'd0)
   ) phy_rst_val_datareg_rd (
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .data_i(phy_rst_val_wdata_i),
      .data_o(phy_rst_val_rdata)
   );



   //NAME: bd;
   //MODE: RW; WIDTH: 32; RST_VAL: 0; ADDR: 1024; SPACE (bytes): 1024 (max); TYPE: NOAUTO. 



   //NAME: version;
   //MODE: R; WIDTH: 16; RST_VAL: 0001; ADDR: 2048; SPACE (bytes): 2 (max); TYPE: REG. 

   wire version_addressed_r;
   assign version_addressed_r = (internal_iob_addr_stable>>shift_amount >= (2048>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 2049 >> shift_amount
   ));


   wire auto_addressed;
   wire auto_addressed_r;
   reg  auto_addressed_nxt;

   //RESPONSE SWITCH

   // Don't register response signals if accessing non-auto CSR
   assign internal_iob_rvalid = auto_addressed ? iob_rvalid_out : rvalid_int;
   assign internal_iob_rdata  = auto_addressed ? iob_rdata_out : iob_rdata_nxt;
   assign internal_iob_ready  = auto_addressed ? iob_ready_out : ready_int;

   // auto_addressed register
   assign auto_addressed      = (state == WAIT_REQ) ? auto_addressed_nxt : auto_addressed_r;
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) auto_addressed_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(auto_addressed_nxt),
      // data_o port: Data output
      .data_o(auto_addressed_r)
   );

   always @* begin
      iob_rdata_nxt      = 32'd0;

      rvalid_int         = 1'b1;
      ready_int          = 1'b1;
      auto_addressed_nxt = auto_addressed_r;
      if (internal_iob_valid) begin
         auto_addressed_nxt = 1'b1;
      end
      if (moder_addressed_r) begin
         iob_rdata_nxt[0+:32] = moder_rdata | 32'd0;
      end

      if (int_source_addressed_r) begin
         iob_rdata_nxt[0+:32] = int_source_rdata | 32'd0;
      end

      if (int_mask_addressed_r) begin
         iob_rdata_nxt[0+:32] = int_mask_rdata | 32'd0;
      end

      if (ipgt_addressed_r) begin
         iob_rdata_nxt[0+:32] = ipgt_rdata | 32'd0;
      end

      if (ipgr1_addressed_r) begin
         iob_rdata_nxt[0+:32] = ipgr1_rdata | 32'd0;
      end

      if (ipgr2_addressed_r) begin
         iob_rdata_nxt[0+:32] = ipgr2_rdata | 32'd0;
      end

      if (packetlen_addressed_r) begin
         iob_rdata_nxt[0+:32] = packetlen_rdata | 32'd0;
      end

      if (collconf_addressed_r) begin
         iob_rdata_nxt[0+:32] = collconf_rdata | 32'd0;
      end

      if (tx_bd_num_addressed_r) begin
         iob_rdata_nxt[0+:32] = tx_bd_num_rdata | 32'd0;
      end

      if (ctrlmoder_addressed_r) begin
         iob_rdata_nxt[0+:32] = ctrlmoder_rdata | 32'd0;
      end

      if (miimoder_addressed_r) begin
         iob_rdata_nxt[0+:32] = miimoder_rdata | 32'd0;
      end

      if (miicommand_addressed_r) begin
         iob_rdata_nxt[0+:32] = miicommand_rdata | 32'd0;
      end

      if (miiaddress_addressed_r) begin
         iob_rdata_nxt[0+:32] = miiaddress_rdata | 32'd0;
      end

      if (miitx_data_addressed_r) begin
         iob_rdata_nxt[0+:32] = miitx_data_rdata | 32'd0;
      end

      if (miirx_data_addressed_r) begin
         iob_rdata_nxt[0+:32] = miirx_data_rdata | 32'd0;
      end

      if (miistatus_addressed_r) begin
         iob_rdata_nxt[0+:32] = miistatus_rdata | 32'd0;
      end

      if (mac_addr0_addressed_r) begin
         iob_rdata_nxt[0+:32] = mac_addr0_rdata | 32'd0;
      end

      if (mac_addr1_addressed_r) begin
         iob_rdata_nxt[0+:32] = mac_addr1_rdata | 32'd0;
      end

      if (eth_hash0_adr_addressed_r) begin
         iob_rdata_nxt[0+:32] = eth_hash0_adr_rdata | 32'd0;
      end

      if (eth_hash1_adr_addressed_r) begin
         iob_rdata_nxt[0+:32] = eth_hash1_adr_rdata | 32'd0;
      end

      if (eth_txctrl_addressed_r) begin
         iob_rdata_nxt[0+:32] = eth_txctrl_rdata | 32'd0;
      end

      if (tx_bd_cnt_addressed) begin

         iob_rdata_nxt[0+:8] = {{1{1'b0}}, tx_bd_cnt_rdata_i} | 8'd0;
         rvalid_int          = tx_bd_cnt_rvalid_i;
         ready_int           = tx_bd_cnt_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (rx_bd_cnt_addressed) begin

         iob_rdata_nxt[0+:8] = {{1{1'b0}}, rx_bd_cnt_rdata_i} | 8'd0;
         rvalid_int          = rx_bd_cnt_rvalid_i;
         ready_int           = rx_bd_cnt_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (tx_word_cnt_addressed) begin

         iob_rdata_nxt[0+:32] = tx_word_cnt_rdata_i | 32'd0;
         rvalid_int           = tx_word_cnt_rvalid_i;
         ready_int            = tx_word_cnt_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (rx_word_cnt_addressed) begin

         iob_rdata_nxt[0+:32] = rx_word_cnt_rdata_i | 32'd0;
         rvalid_int           = rx_word_cnt_rvalid_i;
         ready_int            = rx_word_cnt_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (rx_nbytes_addressed) begin

         iob_rdata_nxt[0+:32] = rx_nbytes_rdata_i | 32'd0;
         rvalid_int           = rx_nbytes_rvalid_i;
         ready_int            = rx_nbytes_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (frame_word_addressed) begin

         iob_rdata_nxt[0+:8] = frame_word_rdata_i | 8'd0;
         rvalid_int          = frame_word_rvalid_i;
         ready_int           = frame_word_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (phy_rst_val_addressed_r) begin
         iob_rdata_nxt[0+:8] = {{7{1'b0}}, phy_rst_val_rdata} | 8'd0;
      end

      if (bd_addressed) begin

         iob_rdata_nxt[0+:32] = bd_rdata_i | 32'd0;
         rvalid_int           = bd_rvalid_i;
         ready_int            = bd_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (version_addressed_r) begin
         iob_rdata_nxt[0+:16] = 16'h0001 | 16'd0;
      end

      if (write_en && (wstrb_addr >= (104)) && (wstrb_addr < 105)) begin
         ready_int = frame_word_ready_i;
         if (internal_iob_valid & (|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (write_en && (wstrb_addr >= (1024)) && (wstrb_addr < 2048)) begin
         ready_int = bd_ready_i;
         if (internal_iob_valid & (|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end



      // ######  FSM  #############

      //FSM default values
      iob_ready_nxt  = 1'b0;
      iob_rvalid_nxt = 1'b0;
      state_nxt      = state;

      //FSM state machine
      case (state)
         WAIT_REQ: begin
            if (internal_iob_valid) begin  // Wait for a valid request

               iob_ready_nxt = ready_int;

               // If is read and ready, go to WAIT_RVALID
               if (iob_ready_nxt && (!write_en)) begin
                  state_nxt = WAIT_RVALID;
               end
            end
         end

         default: begin  // WAIT_RVALID

            if (auto_addressed & iob_rvalid_out) begin  // Transfer done
               state_nxt = WAIT_REQ;
            end else if ((!auto_addressed) & rvalid_int) begin  // Transfer done
               state_nxt = WAIT_REQ;
            end else begin
               iob_rvalid_nxt = rvalid_int;

            end
         end
      endcase

   end  //always @*



        // store iob addr
   iob_reg_cae #(
      .DATA_W (ADDR_W),
      .RST_VAL({ADDR_W{1'b0}})
   ) internal_addr_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (internal_iob_addr_reg_en),
      // data_i port: Data input
      .data_i(internal_iob_addr),
      // data_o port: Data output
      .data_o(internal_iob_addr_reg)
   );

   // state register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) state_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(state_nxt),
      // data_o port: Data output
      .data_o(state)
   );

   // Convert CSR interface into internal IOb port
   iob_universal_converter_iob_iob #(
      .ADDR_W(ADDR_W),
      .DATA_W(DATA_W)
   ) iob_universal_converter (
      // s_s port: Subordinate port
      .iob_valid_i (iob_valid_i),
      .iob_addr_i  (iob_addr_i),
      .iob_wdata_i (iob_wdata_i),
      .iob_wstrb_i (iob_wstrb_i),
      .iob_rvalid_o(iob_rvalid_o),
      .iob_rdata_o (iob_rdata_o),
      .iob_ready_o (iob_ready_o),
      // m_m port: Manager port
      .iob_valid_o (internal_iob_valid),
      .iob_addr_o  (internal_iob_addr),
      .iob_wdata_o (internal_iob_wdata),
      .iob_wstrb_o (internal_iob_wstrb),
      .iob_rvalid_i(internal_iob_rvalid),
      .iob_rdata_i (internal_iob_rdata),
      .iob_ready_i (internal_iob_ready)
   );

   // rvalid register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) rvalid_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_rvalid_nxt),
      // data_o port: Data output
      .data_o(iob_rvalid_out)
   );

   // rdata register
   iob_reg_ca #(
      .DATA_W (32),
      .RST_VAL(32'b0)
   ) rdata_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_rdata_nxt),
      // data_o port: Data output
      .data_o(iob_rdata_out)
   );

   // ready register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) ready_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_ready_nxt),
      // data_o port: Data output
      .data_o(iob_ready_out)
   );


endmodule

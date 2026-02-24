// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_eth_logic_conf.vh"

module iob_eth_logic #(
   parameter BUFFER_W = `IOB_ETH_LOGIC_BUFFER_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                              clk_i,
   input                              cke_i,
   input                              arst_i,
   // eth_logic_io: Default description
   input                              tx_bd_cnt_valid_rd_i,
   output reg                         tx_bd_cnt_ready_rd_o,
   output                             tx_bd_cnt_rvalid_rd_o,
   input                              rx_bd_cnt_valid_rd_i,
   output reg                         rx_bd_cnt_ready_rd_o,
   output                             rx_bd_cnt_rvalid_rd_o,
   input                              tx_word_cnt_valid_rd_i,
   output reg                         tx_word_cnt_ready_rd_o,
   output                             tx_word_cnt_rvalid_rd_o,
   input                              rx_word_cnt_valid_rd_i,
   output reg                         rx_word_cnt_ready_rd_o,
   output                             rx_word_cnt_rvalid_rd_o,
   input                              rx_nbytes_valid_rd_i,
   output reg                         rx_nbytes_ready_rd_o,
   output                             rx_nbytes_rvalid_rd_o,
   output     [         BUFFER_W-1:0] rx_nbytes_rdata_rd_o,
   output reg                         frame_word_ready_wrrd_o,
   input                              frame_word_wstrb_wrrd_i,
   input                              frame_word_valid_wrrd_i,
   output reg                         internal_frame_word_wen_o,
   output reg                         internal_frame_word_ren_o,
   input                              internal_frame_word_ready_wr_i,
   input                              internal_frame_word_ready_rd_i,
   output reg                         internal_bd_wen_o,
   input                              bd_valid_wrrd_i,
   input      [                4-1:0] bd_wstrb_wrrd_i,
   output reg                         bd_ready_wrrd_o,
   output                             bd_rvalid_wrrd_o,
   input                              rcv_ack_i,
   input                              rx_data_rcvd_i,
   input      [`IOB_ETH_BUFFER_W-1:0] rx_nbytes_i
);

   reg                tx_bd_cnt_rvalid_rd_o_nxt;
   reg                rx_bd_cnt_rvalid_rd_o_nxt;
   reg                tx_word_cnt_rvalid_rd_o_nxt;
   reg                rx_word_cnt_rvalid_rd_o_nxt;
   reg                rx_nbytes_rvalid_rd_o_nxt;
   reg                rx_nbytes_rvalid_rd_o_en;
   reg                rx_nbytes_rvalid_rd_o_rst;
   reg [BUFFER_W-1:0] rx_nbytes_rdata_rd_o_nxt;
   reg                rx_nbytes_rdata_rd_o_en;
   reg                bd_rvalid_wrrd_o_nxt;

   always @(*) begin

      // Delay rvalid and rdata signals of NOAUTO CSRs by one clock cycle, since they must come after valid & ready handshake

      // tx bd cnt logic
      tx_bd_cnt_ready_rd_o = 1'b1;
      tx_bd_cnt_rvalid_rd_o_nxt = tx_bd_cnt_valid_rd_i & tx_bd_cnt_ready_rd_o;

      // rx bd cnt logic
      rx_bd_cnt_ready_rd_o = 1'b1;
      rx_bd_cnt_rvalid_rd_o_nxt = rx_bd_cnt_valid_rd_i & rx_bd_cnt_ready_rd_o;

      // tx word cnt logic
      tx_word_cnt_ready_rd_o = 1'b1;
      tx_word_cnt_rvalid_rd_o_nxt = tx_word_cnt_valid_rd_i & tx_word_cnt_ready_rd_o;

      // rx word cnt logic
      rx_word_cnt_ready_rd_o = 1'b1;
      rx_word_cnt_rvalid_rd_o_nxt = rx_word_cnt_valid_rd_i & rx_word_cnt_ready_rd_o;

      // rx nbytes logic
      rx_nbytes_ready_rd_o = ~rcv_ack_i;  // Wait for ack complete
      rx_nbytes_rvalid_rd_o_en = rx_nbytes_valid_rd_i & rx_nbytes_ready_rd_o;
      rx_nbytes_rvalid_rd_o_rst = rx_nbytes_rvalid_rd_o;  // Enable for one clock cycle
      rx_nbytes_rvalid_rd_o_nxt = 1'b1;
      // same logic for rdata
      rx_nbytes_rdata_rd_o_en = rx_nbytes_rvalid_rd_o_en;
      rx_nbytes_rdata_rd_o_nxt = rx_data_rcvd_i ? rx_nbytes_i : 0;

      // frame word logic
      frame_word_ready_wrrd_o = internal_frame_word_wen_o ? internal_frame_word_ready_wr_i : internal_frame_word_ready_rd_i;
      internal_frame_word_wen_o = frame_word_valid_wrrd_i & (|frame_word_wstrb_wrrd_i);
      internal_frame_word_ren_o = frame_word_valid_wrrd_i & (~(|frame_word_wstrb_wrrd_i));

      // BD logic
      internal_bd_wen_o = bd_valid_wrrd_i & (|bd_wstrb_wrrd_i);
      bd_ready_wrrd_o = 1'b1;
      bd_rvalid_wrrd_o_nxt = bd_valid_wrrd_i && (~(|bd_wstrb_wrrd_i));
      // bd_rdata_wrrd already delayed due to RAM

   end




   // tx_bd_cnt_rvalid_rd_o register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(0)
   ) tx_bd_cnt_rvalid_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(tx_bd_cnt_rvalid_rd_o_nxt),
      // data_o port: Data output
      .data_o(tx_bd_cnt_rvalid_rd_o)
   );

   // rx_bd_cnt_rvalid_rd_o register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(0)
   ) rx_bd_cnt_rvalid_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(rx_bd_cnt_rvalid_rd_o_nxt),
      // data_o port: Data output
      .data_o(rx_bd_cnt_rvalid_rd_o)
   );

   // tx_word_cnt_rvalid_rd_o register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(0)
   ) tx_word_cnt_rvalid_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(tx_word_cnt_rvalid_rd_o_nxt),
      // data_o port: Data output
      .data_o(tx_word_cnt_rvalid_rd_o)
   );

   // rx_word_cnt_rvalid_rd_o register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(0)
   ) rx_word_cnt_rvalid_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(rx_word_cnt_rvalid_rd_o_nxt),
      // data_o port: Data output
      .data_o(rx_word_cnt_rvalid_rd_o)
   );

   // rx_nbytes_rvalid_rd_o register
   iob_reg_care #(
      .DATA_W (1),
      .RST_VAL(0)
   ) rx_nbytes_rvalid_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (rx_nbytes_rvalid_rd_o_rst),
      .en_i  (rx_nbytes_rvalid_rd_o_en),
      // data_i port: Data input
      .data_i(rx_nbytes_rvalid_rd_o_nxt),
      // data_o port: Data output
      .data_o(rx_nbytes_rvalid_rd_o)
   );

   // rx_nbytes_rdata_rd_o register
   iob_reg_cae #(
      .DATA_W (BUFFER_W),
      .RST_VAL(0)
   ) rx_nbytes_rdata_rd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (rx_nbytes_rdata_rd_o_en),
      // data_i port: Data input
      .data_i(rx_nbytes_rdata_rd_o_nxt),
      // data_o port: Data output
      .data_o(rx_nbytes_rdata_rd_o)
   );

   // bd_rvalid_wrrd_o register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(0)
   ) bd_rvalid_wrrd_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(bd_rvalid_wrrd_o_nxt),
      // data_o port: Data output
      .data_o(bd_rvalid_wrrd_o)
   );


endmodule

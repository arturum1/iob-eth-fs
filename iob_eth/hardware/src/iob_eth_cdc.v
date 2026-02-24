// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_eth_cdc_conf.vh"

module iob_eth_cdc #(
   parameter BUFFER_W = `IOB_ETH_CDC_BUFFER_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                 clk_i,
   input                 cke_i,
   input                 arst_i,
   // tx_rx_clk_i: Default description
   input                 mii_rx_clk_i,
   input                 mii_tx_clk_i,
   // phy_rst_io: Default description
   input                 phy_rst_i,
   output                rx_phy_rst_o,
   output                tx_phy_rst_o,
   // system_io: Default description
   input                 rcv_ack_i,
   input                 send_i,
   input                 crc_en_i,
   input  [      11-1:0] tx_nbytes_i,
   output                crc_err_o,
   output [BUFFER_W-1:0] rx_nbytes_o,
   output                rx_data_rcvd_o,
   output                tx_ready_o,
   // eth_io: Default description
   output                eth_rcv_ack_o,
   output                eth_send_o,
   output                eth_crc_en_o,
   output [      11-1:0] eth_tx_nbytes_o,
   input                 eth_crc_err_i,
   input  [BUFFER_W-1:0] eth_rx_nbytes_i,
   input                 eth_rx_data_rcvd_i,
   input                 eth_tx_ready_i
);

   wire rx_clk_arst;
   wire tx_clk_arst;

   // Async reset synchronizer for RX
   iob_reset_sync rx_reset_sync (
      // clk_rst_s port: clock and reset
      .clk_i (mii_rx_clk_i),
      .arst_i(arst_i),
      // arst_o port: Output port
      .arst_o(rx_clk_arst)
   );

   // Async reset synchronizer for TX
   iob_reset_sync tx_reset_sync (
      // clk_rst_s port: clock and reset
      .clk_i (mii_tx_clk_i),
      .arst_i(arst_i),
      // arst_o port: Output port
      .arst_o(tx_clk_arst)
   );

   // Synchronizer for rx_phy_rst_o
   iob_sync #(
      .DATA_W(1)
   ) rx_arst_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_rx_clk_i),
      .arst_i  (rx_clk_arst),
      // signal_i port: Input port
      .signal_i(phy_rst_i),
      // signal_o port: Output port
      .signal_o(rx_phy_rst_o)
   );

   // Synchronizer for tx_phy_rst_o
   iob_sync #(
      .DATA_W(1)
   ) tx_arst_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_tx_clk_i),
      .arst_i  (tx_clk_arst),
      // signal_i port: Input port
      .signal_i(phy_rst_i),
      // signal_o port: Output port
      .signal_o(tx_phy_rst_o)
   );

   // Synchronizer for eth_rcv_ack_o
   iob_sync #(
      .DATA_W(1)
   ) rcv_f2s_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_rx_clk_i),
      .arst_i  (rx_phy_rst_o),
      // signal_i port: Input port
      .signal_i(rcv_ack_i),
      // signal_o port: Output port
      .signal_o(eth_rcv_ack_o)
   );

   // Synchronizer for eth_send_o
   iob_sync #(
      .DATA_W(1)
   ) send_f2s_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_tx_clk_i),
      .arst_i  (tx_phy_rst_o),
      // signal_i port: Input port
      .signal_i(send_i),
      // signal_o port: Output port
      .signal_o(eth_send_o)
   );

   // Synchronizer for eth_crc_en_o
   iob_sync #(
      .DATA_W(1)
   ) crc_en_f2s_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_tx_clk_i),
      .arst_i  (tx_phy_rst_o),
      // signal_i port: Input port
      .signal_i(crc_en_i),
      // signal_o port: Output port
      .signal_o(eth_crc_en_o)
   );

   // Synchronizer for eth_tx_nbytes_o
   iob_sync #(
      .DATA_W(11)
   ) tx_nbytes_f2s_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (mii_tx_clk_i),
      .arst_i  (tx_phy_rst_o),
      // signal_i port: Input port
      .signal_i(tx_nbytes_i),
      // signal_o port: Output port
      .signal_o(eth_tx_nbytes_o)
   );

   // Synchronizer for crc_err_o
   iob_sync #(
      .DATA_W(1)
   ) crc_err_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (clk_i),
      .arst_i  (arst_i),
      // signal_i port: Input port
      .signal_i(eth_crc_err_i),
      // signal_o port: Output port
      .signal_o(crc_err_o)
   );

   // Synchronizer for rx_nbytes_o
   iob_sync #(
      .DATA_W(BUFFER_W)
   ) rx_nbytes_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (clk_i),
      .arst_i  (arst_i),
      // signal_i port: Input port
      .signal_i(eth_rx_nbytes_i),
      // signal_o port: Output port
      .signal_o(rx_nbytes_o)
   );

   // Synchronizer for rx_data_rcvd_o
   iob_sync #(
      .DATA_W(1)
   ) rx_data_rcvd_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (clk_i),
      .arst_i  (arst_i),
      // signal_i port: Input port
      .signal_i(eth_rx_data_rcvd_i),
      // signal_o port: Output port
      .signal_o(rx_data_rcvd_o)
   );

   // Synchronizer for tx_ready_o
   iob_sync #(
      .DATA_W(1)
   ) tx_ready_sync_sync (
      // clk_rst_s port: Clock and reset
      .clk_i   (clk_i),
      .arst_i  (arst_i),
      // signal_i port: Input port
      .signal_i(eth_tx_ready_i),
      // signal_o port: Output port
      .signal_o(tx_ready_o)
   );


endmodule

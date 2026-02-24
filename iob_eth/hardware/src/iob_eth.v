// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_eth_conf.vh"

module iob_eth #(
   parameter DATA_W      = `IOB_ETH_DATA_W,
   parameter AXI_ID_W    = `IOB_ETH_AXI_ID_W,
   parameter AXI_ADDR_W  = `IOB_ETH_AXI_ADDR_W,
   parameter AXI_DATA_W  = `IOB_ETH_AXI_DATA_W,
   parameter AXI_LEN_W   = `IOB_ETH_AXI_LEN_W,
   parameter PHY_RST_CNT = `IOB_ETH_PHY_RST_CNT,
   parameter BD_NUM_LOG2 = `IOB_ETH_BD_NUM_LOG2,
   parameter BUFFER_W    = `IOB_ETH_BUFFER_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                     clk_i,
   input                     cke_i,
   input                     arst_i,
   // axi_m: AXI manager interface for external memory
   output [  AXI_ADDR_W-1:0] axi_araddr_o,
   output                    axi_arvalid_o,
   input                     axi_arready_i,
   input  [  AXI_DATA_W-1:0] axi_rdata_i,
   input  [           2-1:0] axi_rresp_i,
   input                     axi_rvalid_i,
   output                    axi_rready_o,
   output [    AXI_ID_W-1:0] axi_arid_o,
   output [   AXI_LEN_W-1:0] axi_arlen_o,
   output [           3-1:0] axi_arsize_o,
   output [           2-1:0] axi_arburst_o,
   output [           2-1:0] axi_arlock_o,
   output [           4-1:0] axi_arcache_o,
   output [           4-1:0] axi_arqos_o,
   input  [    AXI_ID_W-1:0] axi_rid_i,
   input                     axi_rlast_i,
   output [  AXI_ADDR_W-1:0] axi_awaddr_o,
   output                    axi_awvalid_o,
   input                     axi_awready_i,
   output [  AXI_DATA_W-1:0] axi_wdata_o,
   output [AXI_DATA_W/8-1:0] axi_wstrb_o,
   output                    axi_wvalid_o,
   input                     axi_wready_i,
   input  [           2-1:0] axi_bresp_i,
   input                     axi_bvalid_i,
   output                    axi_bready_o,
   output [    AXI_ID_W-1:0] axi_awid_o,
   output [   AXI_LEN_W-1:0] axi_awlen_o,
   output [           3-1:0] axi_awsize_o,
   output [           2-1:0] axi_awburst_o,
   output [           2-1:0] axi_awlock_o,
   output [           4-1:0] axi_awcache_o,
   output [           4-1:0] axi_awqos_o,
   output                    axi_wlast_o,
   input  [    AXI_ID_W-1:0] axi_bid_i,
   // inta_o: Interrupt Output
   output                    inta_o,
   // phy_rstn_o: PHY reset output (active low)
   output                    phy_rstn_o,
   // mii_io: MII interface
   input                     mii_tx_clk_i,
   output [           4-1:0] mii_txd_o,
   output                    mii_tx_en_o,
   output                    mii_tx_er_o,
   input                     mii_rx_clk_i,
   input  [           4-1:0] mii_rxd_i,
   input                     mii_rx_dv_i,
   input                     mii_rx_er_i,
   input                     mii_crs_i,
   input                     mii_col_i,
   inout                     mii_mdio_io,
   output                    mii_mdc_o,
   // csrs_cbus_s: Control and Status Registers interface (auto-generated)
   input                     csrs_iob_valid_i,
   input  [          12-1:0] csrs_iob_addr_i,
   input  [      DATA_W-1:0] csrs_iob_wdata_i,
   input  [    DATA_W/8-1:0] csrs_iob_wstrb_i,
   output                    csrs_iob_rvalid_o,
   output [      DATA_W-1:0] csrs_iob_rdata_o,
   output                    csrs_iob_ready_o
);

   wire [               32-1:0] moder_wr;
   wire [               32-1:0] moder_rd;
   wire [                4-1:0] moder_wstrb;
   wire [               32-1:0] int_source_wr;
   wire [               32-1:0] int_source_rd;
   wire [                4-1:0] int_source_wstrb;
   wire [               32-1:0] int_mask_wr;
   wire [               32-1:0] int_mask_rd;
   wire [                4-1:0] int_mask_wstrb;
   wire [               32-1:0] ipgt_wr;
   wire [               32-1:0] ipgt_rd;
   wire [                4-1:0] ipgt_wstrb;
   wire [               32-1:0] ipgr1_wr;
   wire [               32-1:0] ipgr1_rd;
   wire [                4-1:0] ipgr1_wstrb;
   wire [               32-1:0] ipgr2_wr;
   wire [               32-1:0] ipgr2_rd;
   wire [                4-1:0] ipgr2_wstrb;
   wire [               32-1:0] packetlen_wr;
   wire [               32-1:0] packetlen_rd;
   wire [                4-1:0] packetlen_wstrb;
   wire [               32-1:0] collconf_wr;
   wire [               32-1:0] collconf_rd;
   wire [                4-1:0] collconf_wstrb;
   wire [               32-1:0] tx_bd_num_wr;
   wire [               32-1:0] tx_bd_num_rd;
   wire [                4-1:0] tx_bd_num_wstrb;
   wire [               32-1:0] ctrlmoder_wr;
   wire [               32-1:0] ctrlmoder_rd;
   wire [                4-1:0] ctrlmoder_wstrb;
   wire [               32-1:0] miimoder_wr;
   wire [               32-1:0] miimoder_rd;
   wire [                4-1:0] miimoder_wstrb;
   wire [               32-1:0] miicommand_wr;
   wire [               32-1:0] miicommand_rd;
   wire [                4-1:0] miicommand_wstrb;
   wire [               32-1:0] miiaddress_wr;
   wire [               32-1:0] miiaddress_rd;
   wire [                4-1:0] miiaddress_wstrb;
   wire [               32-1:0] miitx_data_wr;
   wire [               32-1:0] miitx_data_rd;
   wire [                4-1:0] miitx_data_wstrb;
   wire [               32-1:0] miirx_data_wr;
   wire [               32-1:0] miirx_data_rd;
   wire [                4-1:0] miirx_data_wstrb;
   wire [               32-1:0] miistatus_wr;
   wire [               32-1:0] miistatus_rd;
   wire [                4-1:0] miistatus_wstrb;
   wire [               32-1:0] mac_addr0_wr;
   wire [               32-1:0] mac_addr0_rd;
   wire [                4-1:0] mac_addr0_wstrb;
   wire [               32-1:0] mac_addr1_wr;
   wire [               32-1:0] mac_addr1_rd;
   wire [                4-1:0] mac_addr1_wstrb;
   wire [               32-1:0] eth_hash0_adr_wr;
   wire [               32-1:0] eth_hash0_adr_rd;
   wire [                4-1:0] eth_hash0_adr_wstrb;
   wire [               32-1:0] eth_hash1_adr_wr;
   wire [               32-1:0] eth_hash1_adr_rd;
   wire [                4-1:0] eth_hash1_adr_wstrb;
   wire [               32-1:0] eth_txctrl_wr;
   wire [               32-1:0] eth_txctrl_rd;
   wire [                4-1:0] eth_txctrl_wstrb;
   wire                         tx_bd_cnt_valid_rd;
   wire [      BD_NUM_LOG2-1:0] tx_bd_cnt_rdata_rd;
   wire                         tx_bd_cnt_ready_rd;
   wire                         tx_bd_cnt_rvalid_rd;
   wire                         rx_bd_cnt_valid_rd;
   wire [      BD_NUM_LOG2-1:0] rx_bd_cnt_rdata_rd;
   wire                         rx_bd_cnt_ready_rd;
   wire                         rx_bd_cnt_rvalid_rd;
   wire                         tx_word_cnt_valid_rd;
   wire [         BUFFER_W-1:0] tx_word_cnt_rdata_rd;
   wire                         tx_word_cnt_ready_rd;
   wire                         tx_word_cnt_rvalid_rd;
   wire                         rx_word_cnt_valid_rd;
   wire [         BUFFER_W-1:0] rx_word_cnt_rdata_rd;
   wire                         rx_word_cnt_ready_rd;
   wire                         rx_word_cnt_rvalid_rd;
   wire                         rx_nbytes_valid_rd;
   wire [         BUFFER_W-1:0] rx_nbytes_rdata_rd;
   wire                         rx_nbytes_ready_rd;
   wire                         rx_nbytes_rvalid_rd;
   wire                         frame_word_valid_wrrd;
   wire [                8-1:0] frame_word_wdata_wrrd;
   wire                         frame_word_wstrb_wrrd;
   wire                         frame_word_ready_wrrd;
   wire [                8-1:0] frame_word_rdata_wrrd;
   wire                         frame_word_rvalid_wrrd;
   wire                         phy_rst_val_rd;
   wire                         bd_valid_wrrd;
   wire [  BD_NUM_LOG2+1+2-1:0] bd_addr_wrrd;
   wire [               32-1:0] bd_wdata_wrrd;
   wire [                4-1:0] bd_wstrb_wrrd;
   wire                         bd_ready_wrrd;
   wire [               32-1:0] bd_rdata_wrrd;
   wire                         bd_rvalid_wrrd;
   wire                         internal_bd_wen;
   wire                         internal_frame_word_wen;
   wire                         internal_frame_word_ready_wr;
   wire                         internal_frame_word_ren;
   wire                         internal_frame_word_ready_rd;
   wire                         iob_eth_tx_buffer_enA;
   wire [`IOB_ETH_BUFFER_W-1:0] iob_eth_tx_buffer_addrA;
   wire [                8-1:0] iob_eth_tx_buffer_dinA;
   wire [`IOB_ETH_BUFFER_W-1:0] iob_eth_tx_buffer_addrB;
   wire [                8-1:0] iob_eth_tx_buffer_doutB;
   wire                         iob_eth_rx_buffer_enA;
   wire [`IOB_ETH_BUFFER_W-1:0] iob_eth_rx_buffer_addrA;
   wire [                8-1:0] iob_eth_rx_buffer_dinA;
   wire                         iob_eth_rx_buffer_enB;
   wire [`IOB_ETH_BUFFER_W-1:0] iob_eth_rx_buffer_addrB;
   wire [                8-1:0] iob_eth_rx_buffer_doutB;
   wire [               21-1:0] phy_rst_cnt_o;
   wire                         phy_rst;
   wire                         rx_phy_rst;
   wire                         tx_phy_rst;
   wire                         rcv_ack;
   wire                         send;
   wire                         crc_en;
   wire [               11-1:0] tx_nbytes;
   wire                         crc_err;
   wire [`IOB_ETH_BUFFER_W-1:0] rx_nbytes;
   wire                         rx_data_rcvd;
   wire                         tx_ready;
   wire                         eth_rcv_ack;
   wire                         eth_send;
   wire                         eth_crc_en;
   wire [               11-1:0] eth_tx_nbytes;
   wire                         eth_crc_err;
   wire                         eth_rx_data_rcvd;
   wire                         eth_tx_ready;
   wire                         dt_bd_en;
   wire [                8-1:0] dt_bd_addr;
   wire                         dt_bd_wen;
   wire [               32-1:0] dt_bd_i;
   wire [               32-1:0] dt_bd_o;
   wire                         rx_irq;
   wire                         tx_irq;
   wire                         iob_acc_rst;
   wire [               21-1:0] iob_acc_incr;
   wire                         tx_ram_at2p_en;
   // Port A
   wire [    BD_NUM_LOG2+1-1:0] bd_ram_port_a_addr;
   wire                         dt_csrs_control_rx_en;
   wire                         dt_csrs_control_tx_en;
   wire [      BD_NUM_LOG2-1:0] dt_csrs_control_tx_bd_num;


   // Connect write outputs to read
   assign moder_rd                  = moder_wr;
   assign int_source_rd             = int_source_wr;
   assign int_mask_rd               = int_mask_wr;
   assign ipgt_rd                   = ipgt_wr;
   assign ipgr1_rd                  = ipgr1_wr;
   assign ipgr2_rd                  = ipgr2_wr;
   assign packetlen_rd              = packetlen_wr;
   assign collconf_rd               = collconf_wr;
   assign tx_bd_num_rd              = tx_bd_num_wr;
   assign ctrlmoder_rd              = ctrlmoder_wr;
   assign miimoder_rd               = miimoder_wr;
   assign miicommand_rd             = miicommand_wr;
   assign miiaddress_rd             = miiaddress_wr;
   assign miitx_data_rd             = miitx_data_wr;
   assign miirx_data_rd             = miirx_data_wr;
   assign miistatus_rd              = miistatus_wr;
   assign mac_addr0_rd              = mac_addr0_wr;
   assign mac_addr1_rd              = mac_addr1_wr;
   assign eth_hash0_adr_rd          = eth_hash0_adr_wr;
   assign eth_hash1_adr_rd          = eth_hash1_adr_wr;
   assign eth_txctrl_rd             = eth_txctrl_wr;

   // signals are never written from core
   assign moder_wstrb               = 4'h0;
   assign int_source_wstrb          = 4'h0;
   assign int_mask_wstrb            = 4'h0;
   assign ipgt_wstrb                = 4'h0;
   assign ipgr1_wstrb               = 4'h0;
   assign ipgr2_wstrb               = 4'h0;
   assign packetlen_wstrb           = 4'h0;
   assign collconf_wstrb            = 4'h0;
   assign tx_bd_num_wstrb           = 4'h0;
   assign ctrlmoder_wstrb           = 4'h0;
   assign miimoder_wstrb            = 4'h0;
   assign miicommand_wstrb          = 4'h0;
   assign miiaddress_wstrb          = 4'h0;
   assign miitx_data_wstrb          = 4'h0;
   assign miirx_data_wstrb          = 4'h0;
   assign miistatus_wstrb           = 4'h0;
   assign mac_addr0_wstrb           = 4'h0;
   assign mac_addr1_wstrb           = 4'h0;
   assign eth_hash0_adr_wstrb       = 4'h0;
   assign eth_hash1_adr_wstrb       = 4'h0;
   assign eth_txctrl_wstrb          = 4'h0;

   assign mii_tx_er_o               = 1'b0;  //TODO
   //assign ... = mii_rx_er_i;  //TODO

   //assign ... = mii_col_i;  //TODO
   //assign ... = mii_crs_i;  //TODO



   // iob_acc i/o
   assign iob_acc_rst               = 1'b0;
   assign iob_acc_incr              = -21'd1;

   assign phy_rst                   = phy_rst_cnt_o[20];
   assign phy_rstn_o                = ~phy_rst;
   assign phy_rst_val_rd            = phy_rst;

   // DMA
   assign inta_o                    = rx_irq | tx_irq;

   assign tx_ram_at2p_en            = 1'b1;
   assign bd_ram_port_a_addr        = bd_addr_wrrd[2+:(BD_NUM_LOG2+1)];
   assign dt_csrs_control_rx_en     = moder_wr[0];
   assign dt_csrs_control_tx_en     = moder_wr[1];
   assign dt_csrs_control_tx_bd_num = tx_bd_num_wr[BD_NUM_LOG2-1:0];



   // The Control and Status Register block contains registers accessible by the software for controlling the IP core attached as a peripheral.
   iob_eth_csrs csrs (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i                (clk_i),
      .cke_i                (cke_i),
      .arst_i               (arst_i),
      // moder_io port: moder register interface
      .moder_rdata_o        (moder_wr),
      .moder_wdata_i        (moder_rd),
      .moder_wstrb_i        (moder_wstrb),
      // int_source_io port: int_source register interface
      .int_source_rdata_o   (int_source_wr),
      .int_source_wdata_i   (int_source_rd),
      .int_source_wstrb_i   (int_source_wstrb),
      // int_mask_io port: int_mask register interface
      .int_mask_rdata_o     (int_mask_wr),
      .int_mask_wdata_i     (int_mask_rd),
      .int_mask_wstrb_i     (int_mask_wstrb),
      // ipgt_io port: ipgt register interface
      .ipgt_rdata_o         (ipgt_wr),
      .ipgt_wdata_i         (ipgt_rd),
      .ipgt_wstrb_i         (ipgt_wstrb),
      // ipgr1_io port: ipgr1 register interface
      .ipgr1_rdata_o        (ipgr1_wr),
      .ipgr1_wdata_i        (ipgr1_rd),
      .ipgr1_wstrb_i        (ipgr1_wstrb),
      // ipgr2_io port: ipgr2 register interface
      .ipgr2_rdata_o        (ipgr2_wr),
      .ipgr2_wdata_i        (ipgr2_rd),
      .ipgr2_wstrb_i        (ipgr2_wstrb),
      // packetlen_io port: packetlen register interface
      .packetlen_rdata_o    (packetlen_wr),
      .packetlen_wdata_i    (packetlen_rd),
      .packetlen_wstrb_i    (packetlen_wstrb),
      // collconf_io port: collconf register interface
      .collconf_rdata_o     (collconf_wr),
      .collconf_wdata_i     (collconf_rd),
      .collconf_wstrb_i     (collconf_wstrb),
      // tx_bd_num_io port: tx_bd_num register interface
      .tx_bd_num_rdata_o    (tx_bd_num_wr),
      .tx_bd_num_wdata_i    (tx_bd_num_rd),
      .tx_bd_num_wstrb_i    (tx_bd_num_wstrb),
      // ctrlmoder_io port: ctrlmoder register interface
      .ctrlmoder_rdata_o    (ctrlmoder_wr),
      .ctrlmoder_wdata_i    (ctrlmoder_rd),
      .ctrlmoder_wstrb_i    (ctrlmoder_wstrb),
      // miimoder_io port: miimoder register interface
      .miimoder_rdata_o     (miimoder_wr),
      .miimoder_wdata_i     (miimoder_rd),
      .miimoder_wstrb_i     (miimoder_wstrb),
      // miicommand_io port: miicommand register interface
      .miicommand_rdata_o   (miicommand_wr),
      .miicommand_wdata_i   (miicommand_rd),
      .miicommand_wstrb_i   (miicommand_wstrb),
      // miiaddress_io port: miiaddress register interface
      .miiaddress_rdata_o   (miiaddress_wr),
      .miiaddress_wdata_i   (miiaddress_rd),
      .miiaddress_wstrb_i   (miiaddress_wstrb),
      // miitx_data_io port: miitx_data register interface
      .miitx_data_rdata_o   (miitx_data_wr),
      .miitx_data_wdata_i   (miitx_data_rd),
      .miitx_data_wstrb_i   (miitx_data_wstrb),
      // miirx_data_io port: miirx_data register interface
      .miirx_data_rdata_o   (miirx_data_wr),
      .miirx_data_wdata_i   (miirx_data_rd),
      .miirx_data_wstrb_i   (miirx_data_wstrb),
      // miistatus_io port: miistatus register interface
      .miistatus_rdata_o    (miistatus_wr),
      .miistatus_wdata_i    (miistatus_rd),
      .miistatus_wstrb_i    (miistatus_wstrb),
      // mac_addr0_io port: mac_addr0 register interface
      .mac_addr0_rdata_o    (mac_addr0_wr),
      .mac_addr0_wdata_i    (mac_addr0_rd),
      .mac_addr0_wstrb_i    (mac_addr0_wstrb),
      // mac_addr1_io port: mac_addr1 register interface
      .mac_addr1_rdata_o    (mac_addr1_wr),
      .mac_addr1_wdata_i    (mac_addr1_rd),
      .mac_addr1_wstrb_i    (mac_addr1_wstrb),
      // eth_hash0_adr_io port: eth_hash0_adr register interface
      .eth_hash0_adr_rdata_o(eth_hash0_adr_wr),
      .eth_hash0_adr_wdata_i(eth_hash0_adr_rd),
      .eth_hash0_adr_wstrb_i(eth_hash0_adr_wstrb),
      // eth_hash1_adr_io port: eth_hash1_adr register interface
      .eth_hash1_adr_rdata_o(eth_hash1_adr_wr),
      .eth_hash1_adr_wdata_i(eth_hash1_adr_rd),
      .eth_hash1_adr_wstrb_i(eth_hash1_adr_wstrb),
      // eth_txctrl_io port: eth_txctrl register interface
      .eth_txctrl_rdata_o   (eth_txctrl_wr),
      .eth_txctrl_wdata_i   (eth_txctrl_rd),
      .eth_txctrl_wstrb_i   (eth_txctrl_wstrb),
      // tx_bd_cnt_io port: tx_bd_cnt register interface
      .tx_bd_cnt_valid_o    (tx_bd_cnt_valid_rd),
      .tx_bd_cnt_rdata_i    (tx_bd_cnt_rdata_rd),
      .tx_bd_cnt_ready_i    (tx_bd_cnt_ready_rd),
      .tx_bd_cnt_rvalid_i   (tx_bd_cnt_rvalid_rd),
      // rx_bd_cnt_io port: rx_bd_cnt register interface
      .rx_bd_cnt_valid_o    (rx_bd_cnt_valid_rd),
      .rx_bd_cnt_rdata_i    (rx_bd_cnt_rdata_rd),
      .rx_bd_cnt_ready_i    (rx_bd_cnt_ready_rd),
      .rx_bd_cnt_rvalid_i   (rx_bd_cnt_rvalid_rd),
      // tx_word_cnt_io port: tx_word_cnt register interface
      .tx_word_cnt_valid_o  (tx_word_cnt_valid_rd),
      .tx_word_cnt_rdata_i  (tx_word_cnt_rdata_rd),
      .tx_word_cnt_ready_i  (tx_word_cnt_ready_rd),
      .tx_word_cnt_rvalid_i (tx_word_cnt_rvalid_rd),
      // rx_word_cnt_io port: rx_word_cnt register interface
      .rx_word_cnt_valid_o  (rx_word_cnt_valid_rd),
      .rx_word_cnt_rdata_i  (rx_word_cnt_rdata_rd),
      .rx_word_cnt_ready_i  (rx_word_cnt_ready_rd),
      .rx_word_cnt_rvalid_i (rx_word_cnt_rvalid_rd),
      // rx_nbytes_io port: rx_nbytes register interface
      .rx_nbytes_valid_o    (rx_nbytes_valid_rd),
      .rx_nbytes_rdata_i    (rx_nbytes_rdata_rd),
      .rx_nbytes_ready_i    (rx_nbytes_ready_rd),
      .rx_nbytes_rvalid_i   (rx_nbytes_rvalid_rd),
      // frame_word_io port: frame_word register interface
      .frame_word_valid_o   (frame_word_valid_wrrd),
      .frame_word_wdata_o   (frame_word_wdata_wrrd),
      .frame_word_wstrb_o   (frame_word_wstrb_wrrd),
      .frame_word_ready_i   (frame_word_ready_wrrd),
      .frame_word_rdata_i   (frame_word_rdata_wrrd),
      .frame_word_rvalid_i  (frame_word_rvalid_wrrd),
      // phy_rst_val_i port: phy_rst_val register interface
      .phy_rst_val_wdata_i  (phy_rst_val_rd),
      // bd_io port: bd register interface
      .bd_valid_o           (bd_valid_wrrd),
      .bd_addr_o            (bd_addr_wrrd),
      .bd_wdata_o           (bd_wdata_wrrd),
      .bd_wstrb_o           (bd_wstrb_wrrd),
      .bd_ready_i           (bd_ready_wrrd),
      .bd_rdata_i           (bd_rdata_wrrd),
      .bd_rvalid_i          (bd_rvalid_wrrd),
      // control_if_s port: CSR control interface. Interface type defined by `csr_if` parameter.
      .iob_valid_i          (csrs_iob_valid_i),
      .iob_addr_i           (csrs_iob_addr_i),
      .iob_wdata_i          (csrs_iob_wdata_i),
      .iob_wstrb_i          (csrs_iob_wstrb_i),
      .iob_rvalid_o         (csrs_iob_rvalid_o),
      .iob_rdata_o          (csrs_iob_rdata_o),
      .iob_ready_o          (csrs_iob_ready_o)
   );

   // Counter to generate initial PHY reset signal. Configurable duration based on counter reset value.
   iob_acc #(
      .DATA_W (21),
      .RST_VAL(21'h100000 | (PHY_RST_CNT - 1))
   ) phy_reset_counter (
      // clk_en_rst_s port: clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // en_rst_i port: Enable and Synchronous reset interface
      .en_i  (phy_rst),
      .rst_i (iob_acc_rst),
      // incr_i port: Input port
      .incr_i(iob_acc_incr),
      // data_o port: Output port
      .data_o(phy_rst_cnt_o)
   );

   // Clock domain crossing block, using internal synchronizers.
   iob_eth_cdc #(
      .BUFFER_W(BUFFER_W)
   ) cdc (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i             (clk_i),
      .cke_i             (cke_i),
      .arst_i            (arst_i),
      // tx_rx_clk_i port: Default description
      .mii_rx_clk_i      (mii_rx_clk_i),
      .mii_tx_clk_i      (mii_tx_clk_i),
      // phy_rst_io port: Default description
      .phy_rst_i         (phy_rst),
      .rx_phy_rst_o      (rx_phy_rst),
      .tx_phy_rst_o      (tx_phy_rst),
      // system_io port: Default description
      .rcv_ack_i         (rcv_ack),
      .send_i            (send),
      .crc_en_i          (crc_en),
      .tx_nbytes_i       (tx_nbytes),
      .crc_err_o         (crc_err),
      .rx_nbytes_o       (rx_nbytes),
      .rx_data_rcvd_o    (rx_data_rcvd),
      .tx_ready_o        (tx_ready),
      // eth_io port: Default description
      .eth_rcv_ack_o     (eth_rcv_ack),
      .eth_send_o        (eth_send),
      .eth_crc_en_o      (eth_crc_en),
      .eth_tx_nbytes_o   (eth_tx_nbytes),
      .eth_crc_err_i     (eth_crc_err),
      .eth_rx_nbytes_i   (iob_eth_rx_buffer_addrA),
      .eth_rx_data_rcvd_i(eth_rx_data_rcvd),
      .eth_tx_ready_i    (eth_tx_ready)
   );

   // Ethernet transmitter that reads payload bytes from a host interface, emits preamble/SFD and payload, computes and appends the CRC, and provides flow-control so the surrounding logic knows when the transmitter is ready for the next frame.
   iob_eth_tx transmitter (
      // arst_i port: Default description
      .arst_i   (tx_phy_rst),
      // buffer_io port: Default description
      .addr_o   (iob_eth_tx_buffer_addrB),
      .data_i   (iob_eth_tx_buffer_doutB),
      // dt_io port: Default description
      .send_i   (eth_send),
      .ready_o  (eth_tx_ready),
      .nbytes_i (eth_tx_nbytes),
      .crc_en_i (eth_crc_en),
      // mii_io port: Default description
      .tx_clk_i (mii_tx_clk_i),
      .tx_en_o  (mii_tx_en_o),
      .tx_data_o(mii_txd_o)
   );

   // Ethernet receiver that detects frame start, captures the destination MAC and payload, writes received bytes to a host interface, and validates the frame with a CRC check; it produces a ready/received indication for higher-level logic.
   iob_eth_rx receiver (
      // arst_i port: Default description
      .arst_i     (rx_phy_rst),
      // buffer_o port: Default description
      .wr_o       (iob_eth_rx_buffer_enA),
      .addr_o     (iob_eth_rx_buffer_addrA),
      .data_o     (iob_eth_rx_buffer_dinA),
      // dt_io port: Default description
      .rcv_ack_i  (eth_rcv_ack),
      .data_rcvd_o(eth_rx_data_rcvd),
      .crc_err_o  (eth_crc_err),
      // mii_i port: Default description
      .rx_clk_i   (mii_rx_clk_i),
      .rx_dv_i    (mii_rx_dv_i),
      .rx_data_i  (mii_rxd_i)
   );

   // Buffer memory for data to be transmitted.
   iob_ram_at2p #(
      .ADDR_W(`IOB_ETH_BUFFER_W),
      .DATA_W(8)
   ) tx_buffer (
      // ram_at2p_s port: RAM interface
      .r_clk_i (mii_tx_clk_i),
      .r_en_i  (tx_ram_at2p_en),
      .r_addr_i(iob_eth_tx_buffer_addrB),
      .r_data_o(iob_eth_tx_buffer_doutB),
      .w_clk_i (clk_i),
      .w_en_i  (iob_eth_tx_buffer_enA),
      .w_addr_i(iob_eth_tx_buffer_addrA),
      .w_data_i(iob_eth_tx_buffer_dinA)
   );

   // Buffer memory for data received.
   iob_ram_at2p #(
      .ADDR_W(`IOB_ETH_BUFFER_W),
      .DATA_W(8)
   ) rx_buffer (
      // ram_at2p_s port: RAM interface
      .r_clk_i (clk_i),
      .r_en_i  (iob_eth_rx_buffer_enB),
      .r_addr_i(iob_eth_rx_buffer_addrB),
      .r_data_o(iob_eth_rx_buffer_doutB),
      .w_clk_i (mii_rx_clk_i),
      .w_en_i  (iob_eth_rx_buffer_enA),
      .w_addr_i(iob_eth_rx_buffer_addrA),
      .w_data_i(iob_eth_rx_buffer_dinA)
   );

   // Buffer descriptors memory.
   iob_ram_tdp #(
      .ADDR_W              (BD_NUM_LOG2 + 1),
      .DATA_W              (32),
      .MEM_NO_READ_ON_WRITE(1)
   ) buffer_descriptors (
      // clk_i port: clock
      .clk_i  (clk_i),
      // port_a_io port: Port A
      .enA_i  (bd_valid_wrrd),
      .weA_i  (internal_bd_wen),
      .addrA_i(bd_ram_port_a_addr),
      .dA_i   (bd_wdata_wrrd),
      .dA_o   (bd_rdata_wrrd),
      // port_b_io port: Port B
      .enB_i  (dt_bd_en),
      .weB_i  (dt_bd_wen),
      .addrB_i(dt_bd_addr),
      .dB_i   (dt_bd_o),
      .dB_o   (dt_bd_i)
   );

   // Manages data transfers between ethernet modules and interfaces.
   iob_eth_dt #(
      .AXI_ADDR_W(AXI_ADDR_W),
      .AXI_DATA_W(AXI_DATA_W),
      .AXI_LEN_W (AXI_LEN_W),
      .AXI_ID_W  (AXI_ID_W),
      .BUFFER_W  (`IOB_ETH_BUFFER_W),
      .BD_ADDR_W (BD_NUM_LOG2 + 1)
   ) data_transfer (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i                 (clk_i),
      .cke_i                 (cke_i),
      .arst_i                (arst_i),
      // csrs_control_i port: Default description
      .rx_en_i               (dt_csrs_control_rx_en),
      .tx_en_i               (dt_csrs_control_tx_en),
      .tx_bd_num_i           (dt_csrs_control_tx_bd_num),
      // buffer_descriptors_io port: Default description
      .bd_en_o               (dt_bd_en),
      .bd_addr_o             (dt_bd_addr),
      .bd_wen_o              (dt_bd_wen),
      .bd_i                  (dt_bd_i),
      .bd_o                  (dt_bd_o),
      // tx_front_end_io port: Default description
      .eth_data_wr_wen_o     (iob_eth_tx_buffer_enA),
      .eth_data_wr_addr_o    (iob_eth_tx_buffer_addrA),
      .eth_data_wr_wdata_o   (iob_eth_tx_buffer_dinA),
      .tx_ready_i            (tx_ready),
      .crc_en_o              (crc_en),
      .tx_nbytes_o           (tx_nbytes),
      .send_o                (send),
      // rx_back_end_io port: Default description
      .eth_data_rd_ren_o     (iob_eth_rx_buffer_enB),
      .eth_data_rd_addr_o    (iob_eth_rx_buffer_addrB),
      .eth_data_rd_rdata_i   (iob_eth_rx_buffer_doutB),
      .rx_data_rcvd_i        (rx_data_rcvd),
      .crc_err_i             (crc_err),
      .rx_nbytes_i           (rx_nbytes),
      .rcv_ack_o             (rcv_ack),
      // axi_m port: AXI manager interface for external memory (DMA)
      .axi_araddr_o          (axi_araddr_o),
      .axi_arvalid_o         (axi_arvalid_o),
      .axi_arready_i         (axi_arready_i),
      .axi_rdata_i           (axi_rdata_i),
      .axi_rresp_i           (axi_rresp_i),
      .axi_rvalid_i          (axi_rvalid_i),
      .axi_rready_o          (axi_rready_o),
      .axi_arid_o            (axi_arid_o),
      .axi_arlen_o           (axi_arlen_o),
      .axi_arsize_o          (axi_arsize_o),
      .axi_arburst_o         (axi_arburst_o),
      .axi_arlock_o          (axi_arlock_o),
      .axi_arcache_o         (axi_arcache_o),
      .axi_arqos_o           (axi_arqos_o),
      .axi_rid_i             (axi_rid_i),
      .axi_rlast_i           (axi_rlast_i),
      .axi_awaddr_o          (axi_awaddr_o),
      .axi_awvalid_o         (axi_awvalid_o),
      .axi_awready_i         (axi_awready_i),
      .axi_wdata_o           (axi_wdata_o),
      .axi_wstrb_o           (axi_wstrb_o),
      .axi_wvalid_o          (axi_wvalid_o),
      .axi_wready_i          (axi_wready_i),
      .axi_bresp_i           (axi_bresp_i),
      .axi_bvalid_i          (axi_bvalid_i),
      .axi_bready_o          (axi_bready_o),
      .axi_awid_o            (axi_awid_o),
      .axi_awlen_o           (axi_awlen_o),
      .axi_awsize_o          (axi_awsize_o),
      .axi_awburst_o         (axi_awburst_o),
      .axi_awlock_o          (axi_awlock_o),
      .axi_awcache_o         (axi_awcache_o),
      .axi_awqos_o           (axi_awqos_o),
      .axi_wlast_o           (axi_wlast_o),
      .axi_bid_i             (axi_bid_i),
      // no_dma_io port: Default description
      .tx_bd_cnt_o           (tx_bd_cnt_rdata_rd),
      .tx_word_cnt_o         (tx_word_cnt_rdata_rd),
      .tx_frame_word_wen_i   (internal_frame_word_wen),
      .tx_frame_word_wdata_i (frame_word_wdata_wrrd),
      .tx_frame_word_ready_o (internal_frame_word_ready_wr),
      .rx_bd_cnt_o           (rx_bd_cnt_rdata_rd),
      .rx_word_cnt_o         (rx_word_cnt_rdata_rd),
      .rx_frame_word_ren_i   (internal_frame_word_ren),
      .rx_frame_word_rdata_o (frame_word_rdata_wrrd),
      .rx_frame_word_rvalid_o(frame_word_rvalid_wrrd),
      .rx_frame_word_ready_o (internal_frame_word_ready_rd),
      // interrupts_o port: Default description
      .tx_irq_o              (tx_irq),
      .rx_irq_o              (rx_irq)
   );

   // Controls MII management signals.
   iob_eth_mii_management mii_management (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i      (clk_i),
      .cke_i      (cke_i),
      .arst_i     (arst_i),
      // management_io port: MII management interface
      .mii_mdc_o  (mii_mdc_o),
      .mii_mdio_io(mii_mdio_io)
   );

   // Extra ethernet logic for interface between CSRs and Data Transfer block.
   iob_eth_logic #(
      .BUFFER_W(BUFFER_W)
   ) eth_logic (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i                         (clk_i),
      .cke_i                         (cke_i),
      .arst_i                        (arst_i),
      // eth_logic_io port: Default description
      .tx_bd_cnt_valid_rd_i          (tx_bd_cnt_valid_rd),
      .tx_bd_cnt_ready_rd_o          (tx_bd_cnt_ready_rd),
      .tx_bd_cnt_rvalid_rd_o         (tx_bd_cnt_rvalid_rd),
      .rx_bd_cnt_valid_rd_i          (rx_bd_cnt_valid_rd),
      .rx_bd_cnt_ready_rd_o          (rx_bd_cnt_ready_rd),
      .rx_bd_cnt_rvalid_rd_o         (rx_bd_cnt_rvalid_rd),
      .tx_word_cnt_valid_rd_i        (tx_word_cnt_valid_rd),
      .tx_word_cnt_ready_rd_o        (tx_word_cnt_ready_rd),
      .tx_word_cnt_rvalid_rd_o       (tx_word_cnt_rvalid_rd),
      .rx_word_cnt_valid_rd_i        (rx_word_cnt_valid_rd),
      .rx_word_cnt_ready_rd_o        (rx_word_cnt_ready_rd),
      .rx_word_cnt_rvalid_rd_o       (rx_word_cnt_rvalid_rd),
      .rx_nbytes_valid_rd_i          (rx_nbytes_valid_rd),
      .rx_nbytes_ready_rd_o          (rx_nbytes_ready_rd),
      .rx_nbytes_rvalid_rd_o         (rx_nbytes_rvalid_rd),
      .rx_nbytes_rdata_rd_o          (rx_nbytes_rdata_rd),
      .frame_word_ready_wrrd_o       (frame_word_ready_wrrd),
      .frame_word_wstrb_wrrd_i       (frame_word_wstrb_wrrd),
      .frame_word_valid_wrrd_i       (frame_word_valid_wrrd),
      .internal_frame_word_wen_o     (internal_frame_word_wen),
      .internal_frame_word_ren_o     (internal_frame_word_ren),
      .internal_frame_word_ready_wr_i(internal_frame_word_ready_wr),
      .internal_frame_word_ready_rd_i(internal_frame_word_ready_rd),
      .internal_bd_wen_o             (internal_bd_wen),
      .bd_valid_wrrd_i               (bd_valid_wrrd),
      .bd_wstrb_wrrd_i               (bd_wstrb_wrrd),
      .bd_ready_wrrd_o               (bd_ready_wrrd),
      .bd_rvalid_wrrd_o              (bd_rvalid_wrrd),
      .rcv_ack_i                     (rcv_ack),
      .rx_data_rcvd_i                (rx_data_rcvd),
      .rx_nbytes_i                   (rx_nbytes)
   );


endmodule

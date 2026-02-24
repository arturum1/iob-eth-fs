// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_uut_conf.vh"

module iob_uut #(
    parameter DATA_W = `IOB_UUT_DATA_W,
    parameter ADDR_W = `IOB_UUT_ADDR_W,
    parameter AXI_ID_W = `IOB_UUT_AXI_ID_W,
    parameter AXI_ADDR_W = `IOB_UUT_AXI_ADDR_W,
    parameter AXI_DATA_W = `IOB_UUT_AXI_DATA_W,
    parameter AXI_LEN_W = `IOB_UUT_AXI_LEN_W,
    parameter PHY_RST_CNT = `IOB_UUT_PHY_RST_CNT,
    parameter BD_NUM_LOG2 = `IOB_UUT_BD_NUM_LOG2,
    parameter BUFFER_W = `IOB_UUT_BUFFER_W
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // pbus_s: Testbench eth sim wrapper csrs interface
    input iob_valid_i,
    input [(12+2)-1:0] iob_addr_i,
    input [32-1:0] iob_wdata_i,
    input [32/8-1:0] iob_wstrb_i,
    output iob_rvalid_o,
    output [32-1:0] iob_rdata_o,
    output iob_ready_o
);

// Interrupt signal
    wire axistream_in_interrupt;
// AXI Stream interface signals
    wire axis_clk;
    wire axis_cke;
    wire axis_arst;
    wire [DATA_W-1:0] axis_tdata;
    wire axis_tvalid;
    wire axis_tready;
    wire axis_tlast;
// axistream_in CSRs interface
    wire axistream_in_csrs_iob_valid;
    wire [12-1:0] axistream_in_csrs_iob_addr;
    wire [32-1:0] axistream_in_csrs_iob_wdata;
    wire [32/8-1:0] axistream_in_csrs_iob_wstrb;
    wire axistream_in_csrs_iob_rvalid;
    wire [32-1:0] axistream_in_csrs_iob_rdata;
    wire axistream_in_csrs_iob_ready;
// Interrupt signal
    wire axistream_out_interrupt;
// axistream_out CSRs interface
    wire axistream_out_csrs_iob_valid;
    wire [12-1:0] axistream_out_csrs_iob_addr;
    wire [32-1:0] axistream_out_csrs_iob_wdata;
    wire [32/8-1:0] axistream_out_csrs_iob_wstrb;
    wire axistream_out_csrs_iob_rvalid;
    wire [32-1:0] axistream_out_csrs_iob_rdata;
    wire axistream_out_csrs_iob_ready;
// ethernet interrupt wire
    wire inta;
// Ethernet phy reset wire
    wire phy_rstn;
// ethernet PHY interface wires
    wire mtx_clk;
    wire [4-1:0] mtx_d;
    wire mtx_en;
    wire mtx_err;
    wire mrx_clk;
    wire [4-1:0] mrx_d;
    wire mrx_dv;
    wire mrx_err;
    wire mcrs;
    wire mcoll;
    wire mdio;
    wire mdc;
// eth CSRs interface
    wire eth_csrs_iob_valid;
    wire [12-1:0] eth_csrs_iob_addr;
    wire [32-1:0] eth_csrs_iob_wdata;
    wire [32/8-1:0] eth_csrs_iob_wstrb;
    wire eth_csrs_iob_rvalid;
    wire [32-1:0] eth_csrs_iob_rdata;
    wire eth_csrs_iob_ready;
// Testbench ethernet csrs bus
    wire converted_eth_csrs_iob_valid;
    wire [12-1:0] converted_eth_csrs_iob_addr;
    wire [32-1:0] converted_eth_csrs_iob_wdata;
    wire [32/8-1:0] converted_eth_csrs_iob_wstrb;
    wire converted_eth_csrs_iob_rvalid;
    wire [32-1:0] converted_eth_csrs_iob_rdata;
    wire converted_eth_csrs_iob_ready;
// dma CSRs interface
    wire dma_csrs_iob_valid;
    wire [12-1:0] dma_csrs_iob_addr;
    wire [32-1:0] dma_csrs_iob_wdata;
    wire [32/8-1:0] dma_csrs_iob_wstrb;
    wire dma_csrs_iob_rvalid;
    wire [32-1:0] dma_csrs_iob_rdata;
    wire dma_csrs_iob_ready;
// mii counter enable
    wire mii_cnt_en;
// mii counter reset
    wire mii_cnt_rst;
// mii counter output
    wire [2-1:0] mii_cnt;
// DMA AXI connection wires
    wire [AXI_ADDR_W-1:0] dma_axi_araddr;
    wire dma_axi_arvalid;
    wire dma_axi_arready;
    wire [32-1:0] dma_axi_rdata;
    wire [2-1:0] dma_axi_rresp;
    wire dma_axi_rvalid;
    wire dma_axi_rready;
    wire dma_axi_arid;
    wire [8-1:0] dma_axi_arlen;
    wire [3-1:0] dma_axi_arsize;
    wire [2-1:0] dma_axi_arburst;
    wire [2-1:0] dma_axi_arlock;
    wire [4-1:0] dma_axi_arcache;
    wire [4-1:0] dma_axi_arqos;
    wire dma_axi_rid;
    wire dma_axi_rlast;
    wire [AXI_ADDR_W-1:0] dma_axi_awaddr;
    wire dma_axi_awvalid;
    wire dma_axi_awready;
    wire [32-1:0] dma_axi_wdata;
    wire [32/8-1:0] dma_axi_wstrb;
    wire dma_axi_wvalid;
    wire dma_axi_wready;
    wire [2-1:0] dma_axi_bresp;
    wire dma_axi_bvalid;
    wire dma_axi_bready;
    wire dma_axi_awid;
    wire [8-1:0] dma_axi_awlen;
    wire [3-1:0] dma_axi_awsize;
    wire [2-1:0] dma_axi_awburst;
    wire [2-1:0] dma_axi_awlock;
    wire [4-1:0] dma_axi_awcache;
    wire [4-1:0] dma_axi_awqos;
    wire dma_axi_wlast;
    wire dma_axi_bid;
// ETH AXI connection wires
    wire [AXI_ADDR_W-1:0] eth_axi_araddr;
    wire eth_axi_arvalid;
    wire eth_axi_arready;
    wire [32-1:0] eth_axi_rdata;
    wire [2-1:0] eth_axi_rresp;
    wire eth_axi_rvalid;
    wire eth_axi_rready;
    wire eth_axi_arid;
    wire [AXI_LEN_W-1:0] eth_axi_arlen;
    wire [3-1:0] eth_axi_arsize;
    wire [2-1:0] eth_axi_arburst;
    wire [2-1:0] eth_axi_arlock;
    wire [4-1:0] eth_axi_arcache;
    wire [4-1:0] eth_axi_arqos;
    wire eth_axi_rid;
    wire eth_axi_rlast;
    wire [AXI_ADDR_W-1:0] eth_axi_awaddr;
    wire eth_axi_awvalid;
    wire eth_axi_awready;
    wire [32-1:0] eth_axi_wdata;
    wire [32/8-1:0] eth_axi_wstrb;
    wire eth_axi_wvalid;
    wire eth_axi_wready;
    wire [2-1:0] eth_axi_bresp;
    wire eth_axi_bvalid;
    wire eth_axi_bready;
    wire eth_axi_awid;
    wire [AXI_LEN_W-1:0] eth_axi_awlen;
    wire [3-1:0] eth_axi_awsize;
    wire [2-1:0] eth_axi_awburst;
    wire [2-1:0] eth_axi_awlock;
    wire [4-1:0] eth_axi_awcache;
    wire [4-1:0] eth_axi_awqos;
    wire eth_axi_wlast;
    wire eth_axi_bid;
// AXIS OUT <-> DMA connection wires
    wire [AXI_DATA_W-1:0] axis_out_tdata;
    wire axis_out_tvalid;
    wire axis_out_tready;
// AXIS IN <-> DMA connection wires
    wire [AXI_DATA_W-1:0] axis_in_tdata;
    wire axis_in_tvalid;
    wire axis_in_tready;
// AXI subordinate bus for interconnect
    wire [(2*AXI_ADDR_W)-1:0] intercon_s_axi_araddr;
    wire [(2*1)-1:0] intercon_s_axi_arvalid;
    wire [(2*1)-1:0] intercon_s_axi_arready;
    wire [(2*AXI_DATA_W)-1:0] intercon_s_axi_rdata;
    wire [(2*2)-1:0] intercon_s_axi_rresp;
    wire [(2*1)-1:0] intercon_s_axi_rvalid;
    wire [(2*1)-1:0] intercon_s_axi_rready;
    wire [(2*AXI_ID_W)-1:0] intercon_s_axi_arid;
    wire [(2*8)-1:0] intercon_s_axi_arlen;
    wire [(2*3)-1:0] intercon_s_axi_arsize;
    wire [(2*2)-1:0] intercon_s_axi_arburst;
    wire [(2*2)-1:0] intercon_s_axi_arlock;
    wire [(2*4)-1:0] intercon_s_axi_arcache;
    wire [(2*4)-1:0] intercon_s_axi_arqos;
    wire [(2*AXI_ID_W)-1:0] intercon_s_axi_rid;
    wire [(2*1)-1:0] intercon_s_axi_rlast;
    wire [(2*AXI_ADDR_W)-1:0] intercon_s_axi_awaddr;
    wire [(2*1)-1:0] intercon_s_axi_awvalid;
    wire [(2*1)-1:0] intercon_s_axi_awready;
    wire [(2*AXI_DATA_W)-1:0] intercon_s_axi_wdata;
    wire [(2*AXI_DATA_W/8)-1:0] intercon_s_axi_wstrb;
    wire [(2*1)-1:0] intercon_s_axi_wvalid;
    wire [(2*1)-1:0] intercon_s_axi_wready;
    wire [(2*2)-1:0] intercon_s_axi_bresp;
    wire [(2*1)-1:0] intercon_s_axi_bvalid;
    wire [(2*1)-1:0] intercon_s_axi_bready;
    wire [(2*AXI_ID_W)-1:0] intercon_s_axi_awid;
    wire [(2*8)-1:0] intercon_s_axi_awlen;
    wire [(2*3)-1:0] intercon_s_axi_awsize;
    wire [(2*2)-1:0] intercon_s_axi_awburst;
    wire [(2*2)-1:0] intercon_s_axi_awlock;
    wire [(2*4)-1:0] intercon_s_axi_awcache;
    wire [(2*4)-1:0] intercon_s_axi_awqos;
    wire [(2*1)-1:0] intercon_s_axi_wlast;
    wire [(2*AXI_ID_W)-1:0] intercon_s_axi_bid;
// AXI manager bus for interconnect
    wire [AXI_ADDR_W-1:0] intercon_m_axi_araddr;
    wire intercon_m_axi_arvalid;
    wire intercon_m_axi_arready;
    wire [AXI_DATA_W-1:0] intercon_m_axi_rdata;
    wire [2-1:0] intercon_m_axi_rresp;
    wire intercon_m_axi_rvalid;
    wire intercon_m_axi_rready;
    wire [AXI_ID_W-1:0] intercon_m_axi_arid;
    wire [8-1:0] intercon_m_axi_arlen;
    wire [3-1:0] intercon_m_axi_arsize;
    wire [2-1:0] intercon_m_axi_arburst;
    wire [2-1:0] intercon_m_axi_arlock;
    wire [4-1:0] intercon_m_axi_arcache;
    wire [4-1:0] intercon_m_axi_arqos;
    wire [AXI_ID_W-1:0] intercon_m_axi_rid;
    wire intercon_m_axi_rlast;
    wire [AXI_ADDR_W-1:0] intercon_m_axi_awaddr;
    wire intercon_m_axi_awvalid;
    wire intercon_m_axi_awready;
    wire [AXI_DATA_W-1:0] intercon_m_axi_wdata;
    wire [AXI_DATA_W/8-1:0] intercon_m_axi_wstrb;
    wire intercon_m_axi_wvalid;
    wire intercon_m_axi_wready;
    wire [2-1:0] intercon_m_axi_bresp;
    wire intercon_m_axi_bvalid;
    wire intercon_m_axi_bready;
    wire [AXI_ID_W-1:0] intercon_m_axi_awid;
    wire [8-1:0] intercon_m_axi_awlen;
    wire [3-1:0] intercon_m_axi_awsize;
    wire [2-1:0] intercon_m_axi_awburst;
    wire [2-1:0] intercon_m_axi_awlock;
    wire [4-1:0] intercon_m_axi_awcache;
    wire [4-1:0] intercon_m_axi_awqos;
    wire intercon_m_axi_wlast;
    wire [AXI_ID_W-1:0] intercon_m_axi_bid;
// Connect axi_ram to 'iob_ram_t2p_be' memory
    wire ext_mem_clk;
    wire ext_mem_r_en;
    wire [AXI_ADDR_W - 2-1:0] ext_mem_r_addr;
    wire [32-1:0] ext_mem_r_data;
    wire [32/8-1:0] ext_mem_w_strb;
    wire [AXI_ADDR_W - 2-1:0] ext_mem_w_addr;
    wire [32-1:0] ext_mem_w_data;

 
    assign axis_clk = clk_i;
    assign axis_cke = cke_i;
    assign axis_arst = arst_i;

    // MII Counter
    assign mii_cnt_en = 1'b1;
    assign mii_cnt_rst = 1'b0;

    // Ethernet PHY Interface loopback
    assign mtx_clk = mii_cnt[1];
    assign mrx_clk = mii_cnt[1];
    assign mrx_dv = mtx_en;
    assign mrx_d = mtx_d;
    assign mrx_err = 1'b0;
    assign mcoll = 1'b0;
    assign mcrs = 1'b0;
    // Connect all manager AXI interfaces to interconnect
    assign intercon_s_axi_araddr = {dma_axi_araddr, eth_axi_araddr};
    assign intercon_s_axi_arvalid = {dma_axi_arvalid, eth_axi_arvalid};
    assign intercon_s_axi_rready = {dma_axi_rready, eth_axi_rready};
    assign intercon_s_axi_arid = {dma_axi_arid, eth_axi_arid};
    assign intercon_s_axi_arlen = {dma_axi_arlen, eth_axi_arlen};
    assign intercon_s_axi_arsize = {dma_axi_arsize, eth_axi_arsize};
    assign intercon_s_axi_arburst = {dma_axi_arburst, eth_axi_arburst};
    assign intercon_s_axi_arlock = {dma_axi_arlock, eth_axi_arlock};
    assign intercon_s_axi_arcache = {dma_axi_arcache, eth_axi_arcache};
    assign intercon_s_axi_arqos = {dma_axi_arqos, eth_axi_arqos};
    assign intercon_s_axi_awaddr = {dma_axi_awaddr, eth_axi_awaddr};
    assign intercon_s_axi_awvalid = {dma_axi_awvalid, eth_axi_awvalid};
    assign intercon_s_axi_wdata = {dma_axi_wdata, eth_axi_wdata};
    assign intercon_s_axi_wstrb = {dma_axi_wstrb, eth_axi_wstrb};
    assign intercon_s_axi_wvalid = {dma_axi_wvalid, eth_axi_wvalid};
    assign intercon_s_axi_bready = {dma_axi_bready, eth_axi_bready};
    assign intercon_s_axi_awid = {dma_axi_awid, eth_axi_awid};
    assign intercon_s_axi_awlen = {dma_axi_awlen, eth_axi_awlen};
    assign intercon_s_axi_awsize = {dma_axi_awsize, eth_axi_awsize};
    assign intercon_s_axi_awburst = {dma_axi_awburst, eth_axi_awburst};
    assign intercon_s_axi_awlock = {dma_axi_awlock, eth_axi_awlock};
    assign intercon_s_axi_awcache = {dma_axi_awcache, eth_axi_awcache};
    assign intercon_s_axi_awqos = {dma_axi_awqos, eth_axi_awqos};
    assign intercon_s_axi_wlast = {dma_axi_wlast, eth_axi_wlast};
    assign eth_axi_arready = intercon_s_axi_arready[0]; 
    assign dma_axi_arready = intercon_s_axi_arready[1]; 
    assign eth_axi_rdata = intercon_s_axi_rdata[0*AXI_DATA_W+:AXI_DATA_W]; 
    assign dma_axi_rdata = intercon_s_axi_rdata[1*AXI_DATA_W+:AXI_DATA_W]; 
    assign eth_axi_rresp = intercon_s_axi_rresp[0*2+:2]; 
    assign dma_axi_rresp = intercon_s_axi_rresp[1*2+:2]; 
    assign eth_axi_rvalid = intercon_s_axi_rvalid[0]; 
    assign dma_axi_rvalid = intercon_s_axi_rvalid[1]; 
    assign eth_axi_rid = intercon_s_axi_rid[0*AXI_ID_W+:AXI_ID_W]; 
    assign dma_axi_rid = intercon_s_axi_rid[1*AXI_ID_W+:AXI_ID_W]; 
    assign eth_axi_rlast = intercon_s_axi_rlast[0]; 
    assign dma_axi_rlast = intercon_s_axi_rlast[1]; 
    assign eth_axi_awready = intercon_s_axi_awready[0]; 
    assign dma_axi_awready = intercon_s_axi_awready[1]; 
    assign eth_axi_wready = intercon_s_axi_wready[0]; 
    assign dma_axi_wready = intercon_s_axi_wready[1]; 
    assign eth_axi_bresp = intercon_s_axi_bresp[0*2+:2]; 
    assign dma_axi_bresp = intercon_s_axi_bresp[1*2+:2]; 
    assign eth_axi_bvalid = intercon_s_axi_bvalid[0]; 
    assign dma_axi_bvalid = intercon_s_axi_bvalid[1]; 
    assign eth_axi_bid = intercon_s_axi_bid[0*AXI_ID_W+:AXI_ID_W]; 
    assign dma_axi_bid = intercon_s_axi_bid[1*AXI_ID_W+:AXI_ID_W]; 


        // Convert IOb port from testbench into correct interface for Eth CSRs bus
        iob_universal_converter_iob_iob #(
        .ADDR_W(12),
        .DATA_W(DATA_W)
    ) iob_universal_converter (
            // s_s port: Subordinate port
        .iob_valid_i(eth_csrs_iob_valid),
        .iob_addr_i(eth_csrs_iob_addr),
        .iob_wdata_i(eth_csrs_iob_wdata),
        .iob_wstrb_i(eth_csrs_iob_wstrb),
        .iob_rvalid_o(eth_csrs_iob_rvalid),
        .iob_rdata_o(eth_csrs_iob_rdata),
        .iob_ready_o(eth_csrs_iob_ready),
        // m_m port: Manager port
        .iob_valid_o(converted_eth_csrs_iob_valid),
        .iob_addr_o(converted_eth_csrs_iob_addr),
        .iob_wdata_o(converted_eth_csrs_iob_wdata),
        .iob_wstrb_o(converted_eth_csrs_iob_wstrb),
        .iob_rvalid_i(converted_eth_csrs_iob_rvalid),
        .iob_rdata_i(converted_eth_csrs_iob_rdata),
        .iob_ready_i(converted_eth_csrs_iob_ready)
        );

            // ETH clk counter: 4x slower than system clk
        iob_counter #(
        .DATA_W(2),
        .RST_VAL({2{1'b0}})
    ) mii_counter_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // counter_en_i port: Counter enable input
        .counter_en_i(mii_cnt_en),
        // counter_rst_i port: Counter reset input
        .counter_rst_i(mii_cnt_rst),
        // data_o port: Output port
        .data_o(mii_cnt)
        );

            // AXIS IN test instrument
        iob_axistream_in #(
        .ADDR_W((ADDR_W-2)),
        .DATA_W(DATA_W),
        .TDATA_W(DATA_W),
        .FIFO_ADDR_W(AXI_ADDR_W)
    ) axistream_in0 (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // interrupt_o port: Interrupt signal
        .interrupt_o(axistream_in_interrupt),
        // axistream_io port: AXI Stream interface signals
        .axis_clk_i(axis_clk),
        .axis_cke_i(axis_cke),
        .axis_arst_i(axis_arst),
        .axis_tdata_i(axis_tdata),
        .axis_tvalid_i(axis_tvalid),
        .axis_tready_o(axis_tready),
        .axis_tlast_i(axis_tlast),
        // sys_axis_io port: System AXI Stream interface.
        .sys_tdata_o(axis_in_tdata),
        .sys_tvalid_o(axis_in_tvalid),
        .sys_tready_i(axis_in_tready),
        // csrs_cbus_s port: Control and Status Registers interface (auto-generated)
        .csrs_iob_valid_i(axistream_in_csrs_iob_valid),
        .csrs_iob_addr_i(axistream_in_csrs_iob_addr[4:0]),
        .csrs_iob_wdata_i(axistream_in_csrs_iob_wdata),
        .csrs_iob_wstrb_i(axistream_in_csrs_iob_wstrb),
        .csrs_iob_rvalid_o(axistream_in_csrs_iob_rvalid),
        .csrs_iob_rdata_o(axistream_in_csrs_iob_rdata),
        .csrs_iob_ready_o(axistream_in_csrs_iob_ready)
        );

            // AXIS OUT test instrument
        iob_axistream_out #(
        .ADDR_W((ADDR_W-2)),
        .DATA_W(DATA_W),
        .TDATA_W(DATA_W),
        .FIFO_ADDR_W(AXI_ADDR_W)
    ) axistream_out0 (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // interrupt_o port: Interrupt signal
        .interrupt_o(axistream_out_interrupt),
        // axistream_io port: AXI Stream interface signals
        .axis_clk_i(axis_clk),
        .axis_cke_i(axis_cke),
        .axis_arst_i(axis_arst),
        .axis_tdata_o(axis_tdata),
        .axis_tvalid_o(axis_tvalid),
        .axis_tready_i(axis_tready),
        .axis_tlast_o(axis_tlast),
        // sys_axis_io port: System AXI Stream interface.
        .sys_tdata_i(axis_out_tdata),
        .sys_tvalid_i(axis_out_tvalid),
        .sys_tready_o(axis_out_tready),
        // csrs_cbus_s port: Control and Status Registers interface (auto-generated)
        .csrs_iob_valid_i(axistream_out_csrs_iob_valid),
        .csrs_iob_addr_i(axistream_out_csrs_iob_addr[4:0]),
        .csrs_iob_wdata_i(axistream_out_csrs_iob_wdata),
        .csrs_iob_wstrb_i(axistream_out_csrs_iob_wstrb),
        .csrs_iob_rvalid_o(axistream_out_csrs_iob_rvalid),
        .csrs_iob_rdata_o(axistream_out_csrs_iob_rdata),
        .csrs_iob_ready_o(axistream_out_csrs_iob_ready)
        );

            // Split between testbench peripherals
        tb_pbus_split iob_pbus_split (
            // clk_en_rst_s port: Clock, clock enable and async reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // reset_i port: Reset signal
        .rst_i(arst_i),
        // s_s port: Split subordinate interface
        .s_iob_valid_i(iob_valid_i),
        .s_iob_addr_i(iob_addr_i),
        .s_iob_wdata_i(iob_wdata_i),
        .s_iob_wstrb_i(iob_wstrb_i),
        .s_iob_rvalid_o(iob_rvalid_o),
        .s_iob_rdata_o(iob_rdata_o),
        .s_iob_ready_o(iob_ready_o),
        // m_0_m port: Split manager interface
        .m0_iob_valid_o(axistream_in_csrs_iob_valid),
        .m0_iob_addr_o(axistream_in_csrs_iob_addr),
        .m0_iob_wdata_o(axistream_in_csrs_iob_wdata),
        .m0_iob_wstrb_o(axistream_in_csrs_iob_wstrb),
        .m0_iob_rvalid_i(axistream_in_csrs_iob_rvalid),
        .m0_iob_rdata_i(axistream_in_csrs_iob_rdata),
        .m0_iob_ready_i(axistream_in_csrs_iob_ready),
        // m_1_m port: Split manager interface
        .m1_iob_valid_o(axistream_out_csrs_iob_valid),
        .m1_iob_addr_o(axistream_out_csrs_iob_addr),
        .m1_iob_wdata_o(axistream_out_csrs_iob_wdata),
        .m1_iob_wstrb_o(axistream_out_csrs_iob_wstrb),
        .m1_iob_rvalid_i(axistream_out_csrs_iob_rvalid),
        .m1_iob_rdata_i(axistream_out_csrs_iob_rdata),
        .m1_iob_ready_i(axistream_out_csrs_iob_ready),
        // m_2_m port: Split manager interface
        .m2_iob_valid_o(dma_csrs_iob_valid),
        .m2_iob_addr_o(dma_csrs_iob_addr),
        .m2_iob_wdata_o(dma_csrs_iob_wdata),
        .m2_iob_wstrb_o(dma_csrs_iob_wstrb),
        .m2_iob_rvalid_i(dma_csrs_iob_rvalid),
        .m2_iob_rdata_i(dma_csrs_iob_rdata),
        .m2_iob_ready_i(dma_csrs_iob_ready),
        // m_3_m port: Split manager interface
        .m3_iob_valid_o(eth_csrs_iob_valid),
        .m3_iob_addr_o(eth_csrs_iob_addr),
        .m3_iob_wdata_o(eth_csrs_iob_wdata),
        .m3_iob_wstrb_o(eth_csrs_iob_wstrb),
        .m3_iob_rvalid_i(eth_csrs_iob_rvalid),
        .m3_iob_rdata_i(eth_csrs_iob_rdata),
        .m3_iob_ready_i(eth_csrs_iob_ready)
        );

            // Unit Under Test (UUT) DMA instance.
        iob_eth #(
        .DATA_W(DATA_W),
        .AXI_ADDR_W(AXI_ADDR_W),
        .AXI_DATA_W(AXI_DATA_W),
        .AXI_ID_W(AXI_ID_W),
        .AXI_LEN_W(AXI_LEN_W),
        .PHY_RST_CNT(PHY_RST_CNT)
    ) eth_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // csrs_cbus_s port: Control and Status Registers interface (auto-generated)
        .csrs_iob_valid_i(converted_eth_csrs_iob_valid),
        .csrs_iob_addr_i(converted_eth_csrs_iob_addr),
        .csrs_iob_wdata_i(converted_eth_csrs_iob_wdata),
        .csrs_iob_wstrb_i(converted_eth_csrs_iob_wstrb),
        .csrs_iob_rvalid_o(converted_eth_csrs_iob_rvalid),
        .csrs_iob_rdata_o(converted_eth_csrs_iob_rdata),
        .csrs_iob_ready_o(converted_eth_csrs_iob_ready),
        // axi_m port: AXI manager interface for external memory
        .axi_araddr_o(eth_axi_araddr),
        .axi_arvalid_o(eth_axi_arvalid),
        .axi_arready_i(eth_axi_arready),
        .axi_rdata_i(eth_axi_rdata),
        .axi_rresp_i(eth_axi_rresp),
        .axi_rvalid_i(eth_axi_rvalid),
        .axi_rready_o(eth_axi_rready),
        .axi_arid_o(eth_axi_arid),
        .axi_arlen_o(eth_axi_arlen),
        .axi_arsize_o(eth_axi_arsize),
        .axi_arburst_o(eth_axi_arburst),
        .axi_arlock_o(eth_axi_arlock),
        .axi_arcache_o(eth_axi_arcache),
        .axi_arqos_o(eth_axi_arqos),
        .axi_rid_i(eth_axi_rid),
        .axi_rlast_i(eth_axi_rlast),
        .axi_awaddr_o(eth_axi_awaddr),
        .axi_awvalid_o(eth_axi_awvalid),
        .axi_awready_i(eth_axi_awready),
        .axi_wdata_o(eth_axi_wdata),
        .axi_wstrb_o(eth_axi_wstrb),
        .axi_wvalid_o(eth_axi_wvalid),
        .axi_wready_i(eth_axi_wready),
        .axi_bresp_i(eth_axi_bresp),
        .axi_bvalid_i(eth_axi_bvalid),
        .axi_bready_o(eth_axi_bready),
        .axi_awid_o(eth_axi_awid),
        .axi_awlen_o(eth_axi_awlen),
        .axi_awsize_o(eth_axi_awsize),
        .axi_awburst_o(eth_axi_awburst),
        .axi_awlock_o(eth_axi_awlock),
        .axi_awcache_o(eth_axi_awcache),
        .axi_awqos_o(eth_axi_awqos),
        .axi_wlast_o(eth_axi_wlast),
        .axi_bid_i(eth_axi_bid),
        // inta_o port: Interrupt Output
        .inta_o(inta),
        // phy_rstn_o port: PHY reset output (active low)
        .phy_rstn_o(phy_rstn),
        // mii_io port: MII interface
        .mii_tx_clk_i(mtx_clk),
        .mii_txd_o(mtx_d),
        .mii_tx_en_o(mtx_en),
        .mii_tx_er_o(mtx_err),
        .mii_rx_clk_i(mrx_clk),
        .mii_rxd_i(mrx_d),
        .mii_rx_dv_i(mrx_dv),
        .mii_rx_er_i(mrx_err),
        .mii_crs_i(mcrs),
        .mii_col_i(mcoll),
        .mii_mdio_io(mdio),
        .mii_mdc_o(mdc)
        );

            // DMA test instrument.
        iob_dma #(
        .DATA_W(DATA_W),
        .ADDR_W((ADDR_W-2)),
        .AXI_ADDR_W(AXI_ADDR_W),
        .AXI_DATA_W(AXI_DATA_W)
    ) dma_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // rst_i port: Synchronous reset interface
        .rst_i(arst_i),
        // csrs_cbus_s port: Control and Status Registers interface (auto-generated)
        .csrs_iob_valid_i(dma_csrs_iob_valid),
        .csrs_iob_addr_i(dma_csrs_iob_addr[4:0]),
        .csrs_iob_wdata_i(dma_csrs_iob_wdata),
        .csrs_iob_wstrb_i(dma_csrs_iob_wstrb),
        .csrs_iob_rvalid_o(dma_csrs_iob_rvalid),
        .csrs_iob_rdata_o(dma_csrs_iob_rdata),
        .csrs_iob_ready_o(dma_csrs_iob_ready),
        .axis_in_tdata_i(axis_in_tdata),
        .axis_in_tvalid_i(axis_in_tvalid),
        .axis_in_tready_o(axis_in_tready),
        .axis_out_tdata_o(axis_out_tdata),
        .axis_out_tvalid_o(axis_out_tvalid),
        .axis_out_tready_i(axis_out_tready),
        // axi_m port: AXI interface
        .axi_araddr_o(dma_axi_araddr),
        .axi_arvalid_o(dma_axi_arvalid),
        .axi_arready_i(dma_axi_arready),
        .axi_rdata_i(dma_axi_rdata),
        .axi_rresp_i(dma_axi_rresp),
        .axi_rvalid_i(dma_axi_rvalid),
        .axi_rready_o(dma_axi_rready),
        .axi_arid_o(dma_axi_arid),
        .axi_arlen_o(dma_axi_arlen),
        .axi_arsize_o(dma_axi_arsize),
        .axi_arburst_o(dma_axi_arburst),
        .axi_arlock_o(dma_axi_arlock),
        .axi_arcache_o(dma_axi_arcache),
        .axi_arqos_o(dma_axi_arqos),
        .axi_rid_i(dma_axi_rid),
        .axi_rlast_i(dma_axi_rlast),
        .axi_awaddr_o(dma_axi_awaddr),
        .axi_awvalid_o(dma_axi_awvalid),
        .axi_awready_i(dma_axi_awready),
        .axi_wdata_o(dma_axi_wdata),
        .axi_wstrb_o(dma_axi_wstrb),
        .axi_wvalid_o(dma_axi_wvalid),
        .axi_wready_i(dma_axi_wready),
        .axi_bresp_i(dma_axi_bresp),
        .axi_bvalid_i(dma_axi_bvalid),
        .axi_bready_o(dma_axi_bready),
        .axi_awid_o(dma_axi_awid),
        .axi_awlen_o(dma_axi_awlen),
        .axi_awsize_o(dma_axi_awsize),
        .axi_awburst_o(dma_axi_awburst),
        .axi_awlock_o(dma_axi_awlock),
        .axi_awcache_o(dma_axi_awcache),
        .axi_awqos_o(dma_axi_awqos),
        .axi_wlast_o(dma_axi_wlast),
        .axi_bid_i(dma_axi_bid)
        );

            // Interconnect core: DMA + ETH managers, AXI RAM subordinate
        iob_axi_interconnect #(
        .ID_WIDTH(AXI_ID_W),
        .DATA_WIDTH(AXI_DATA_W),
        .ADDR_WIDTH(AXI_ADDR_W),
        .S_COUNT(2),
        .M_COUNT(1),
        .M_ADDR_WIDTH(AXI_ADDR_W)
    ) iob_axi_interconnect_ram (
            // clk_i port: Clock
        .clk_i(clk_i),
        // rst_i port: Synchronous reset
        .rst_i(arst_i),
        // s_axi_s port: AXI subordinate interface
        .s_axi_araddr_i(intercon_s_axi_araddr),
        .s_axi_arvalid_i(intercon_s_axi_arvalid),
        .s_axi_arready_o(intercon_s_axi_arready),
        .s_axi_rdata_o(intercon_s_axi_rdata),
        .s_axi_rresp_o(intercon_s_axi_rresp),
        .s_axi_rvalid_o(intercon_s_axi_rvalid),
        .s_axi_rready_i(intercon_s_axi_rready),
        .s_axi_arid_i(intercon_s_axi_arid),
        .s_axi_arlen_i(intercon_s_axi_arlen),
        .s_axi_arsize_i(intercon_s_axi_arsize),
        .s_axi_arburst_i(intercon_s_axi_arburst),
        .s_axi_arlock_i(intercon_s_axi_arlock[1:0]),
        .s_axi_arcache_i(intercon_s_axi_arcache),
        .s_axi_arqos_i(intercon_s_axi_arqos),
        .s_axi_rid_o(intercon_s_axi_rid),
        .s_axi_rlast_o(intercon_s_axi_rlast),
        .s_axi_awaddr_i(intercon_s_axi_awaddr),
        .s_axi_awvalid_i(intercon_s_axi_awvalid),
        .s_axi_awready_o(intercon_s_axi_awready),
        .s_axi_wdata_i(intercon_s_axi_wdata),
        .s_axi_wstrb_i(intercon_s_axi_wstrb),
        .s_axi_wvalid_i(intercon_s_axi_wvalid),
        .s_axi_wready_o(intercon_s_axi_wready),
        .s_axi_bresp_o(intercon_s_axi_bresp),
        .s_axi_bvalid_o(intercon_s_axi_bvalid),
        .s_axi_bready_i(intercon_s_axi_bready),
        .s_axi_awid_i(intercon_s_axi_awid),
        .s_axi_awlen_i(intercon_s_axi_awlen),
        .s_axi_awsize_i(intercon_s_axi_awsize),
        .s_axi_awburst_i(intercon_s_axi_awburst),
        .s_axi_awlock_i(intercon_s_axi_awlock[1:0]),
        .s_axi_awcache_i(intercon_s_axi_awcache),
        .s_axi_awqos_i(intercon_s_axi_awqos),
        .s_axi_wlast_i(intercon_s_axi_wlast),
        .s_axi_bid_o(intercon_s_axi_bid),
        // m_axi_m port: AXI manager interface
        .m_axi_araddr_o(intercon_m_axi_araddr),
        .m_axi_arvalid_o(intercon_m_axi_arvalid),
        .m_axi_arready_i(intercon_m_axi_arready),
        .m_axi_rdata_i(intercon_m_axi_rdata),
        .m_axi_rresp_i(intercon_m_axi_rresp),
        .m_axi_rvalid_i(intercon_m_axi_rvalid),
        .m_axi_rready_o(intercon_m_axi_rready),
        .m_axi_arid_o(intercon_m_axi_arid),
        .m_axi_arlen_o(intercon_m_axi_arlen),
        .m_axi_arsize_o(intercon_m_axi_arsize),
        .m_axi_arburst_o(intercon_m_axi_arburst),
        .m_axi_arlock_o(intercon_m_axi_arlock[0]),
        .m_axi_arcache_o(intercon_m_axi_arcache),
        .m_axi_arqos_o(intercon_m_axi_arqos),
        .m_axi_rid_i(intercon_m_axi_rid),
        .m_axi_rlast_i(intercon_m_axi_rlast),
        .m_axi_awaddr_o(intercon_m_axi_awaddr),
        .m_axi_awvalid_o(intercon_m_axi_awvalid),
        .m_axi_awready_i(intercon_m_axi_awready),
        .m_axi_wdata_o(intercon_m_axi_wdata),
        .m_axi_wstrb_o(intercon_m_axi_wstrb),
        .m_axi_wvalid_o(intercon_m_axi_wvalid),
        .m_axi_wready_i(intercon_m_axi_wready),
        .m_axi_bresp_i(intercon_m_axi_bresp),
        .m_axi_bvalid_i(intercon_m_axi_bvalid),
        .m_axi_bready_o(intercon_m_axi_bready),
        .m_axi_awid_o(intercon_m_axi_awid),
        .m_axi_awlen_o(intercon_m_axi_awlen),
        .m_axi_awsize_o(intercon_m_axi_awsize),
        .m_axi_awburst_o(intercon_m_axi_awburst),
        .m_axi_awlock_o(intercon_m_axi_awlock[0]),
        .m_axi_awcache_o(intercon_m_axi_awcache),
        .m_axi_awqos_o(intercon_m_axi_awqos),
        .m_axi_wlast_o(intercon_m_axi_wlast),
        .m_axi_bid_i(intercon_m_axi_bid)
        );

            // AXI RAM test instrument to connect to DMA
        iob_axi_ram #(
        .ID_WIDTH(AXI_ID_W),
        .ADDR_WIDTH(AXI_ADDR_W),
        .DATA_WIDTH(AXI_DATA_W)
    ) axi_ram_inst (
            // clk_i port: Clock
        .clk_i(clk_i),
        // rst_i port: Synchronous reset
        .rst_i(arst_i),
        // axi_s port: AXI interface
        .axi_araddr_i(intercon_m_axi_araddr),
        .axi_arvalid_i(intercon_m_axi_arvalid),
        .axi_arready_o(intercon_m_axi_arready),
        .axi_rdata_o(intercon_m_axi_rdata),
        .axi_rresp_o(intercon_m_axi_rresp),
        .axi_rvalid_o(intercon_m_axi_rvalid),
        .axi_rready_i(intercon_m_axi_rready),
        .axi_arid_i(intercon_m_axi_arid),
        .axi_arlen_i(intercon_m_axi_arlen),
        .axi_arsize_i(intercon_m_axi_arsize),
        .axi_arburst_i(intercon_m_axi_arburst),
        .axi_arlock_i(intercon_m_axi_arlock),
        .axi_arcache_i(intercon_m_axi_arcache),
        .axi_arqos_i(intercon_m_axi_arqos),
        .axi_rid_o(intercon_m_axi_rid),
        .axi_rlast_o(intercon_m_axi_rlast),
        .axi_awaddr_i(intercon_m_axi_awaddr),
        .axi_awvalid_i(intercon_m_axi_awvalid),
        .axi_awready_o(intercon_m_axi_awready),
        .axi_wdata_i(intercon_m_axi_wdata),
        .axi_wstrb_i(intercon_m_axi_wstrb),
        .axi_wvalid_i(intercon_m_axi_wvalid),
        .axi_wready_o(intercon_m_axi_wready),
        .axi_bresp_o(intercon_m_axi_bresp),
        .axi_bvalid_o(intercon_m_axi_bvalid),
        .axi_bready_i(intercon_m_axi_bready),
        .axi_awid_i(intercon_m_axi_awid),
        .axi_awlen_i(intercon_m_axi_awlen),
        .axi_awsize_i(intercon_m_axi_awsize),
        .axi_awburst_i(intercon_m_axi_awburst),
        .axi_awlock_i(intercon_m_axi_awlock),
        .axi_awcache_i(intercon_m_axi_awcache),
        .axi_awqos_i(intercon_m_axi_awqos),
        .axi_wlast_i(intercon_m_axi_wlast),
        .axi_bid_o(intercon_m_axi_bid),
        // external_mem_bus_m port: Port for connection to external 'iob_ram_t2p_be' memory
        .ext_mem_clk_o(ext_mem_clk),
        .ext_mem_r_en_o(ext_mem_r_en),
        .ext_mem_r_addr_o(ext_mem_r_addr),
        .ext_mem_r_data_i(ext_mem_r_data),
        .ext_mem_w_strb_o(ext_mem_w_strb),
        .ext_mem_w_addr_o(ext_mem_w_addr),
        .ext_mem_w_data_o(ext_mem_w_data)
        );

            // AXI RAM external memory
        iob_ram_t2p_be #(
        .ADDR_W(AXI_ADDR_W - 2),
        .DATA_W(AXI_DATA_W)
    ) iob_ram_t2p_be_inst (
            // ram_t2p_be_s port: RAM interface
        .clk_i(ext_mem_clk),
        .r_en_i(ext_mem_r_en),
        .r_addr_i(ext_mem_r_addr),
        .r_data_o(ext_mem_r_data),
        .w_strb_i(ext_mem_w_strb),
        .w_addr_i(ext_mem_w_addr),
        .w_data_i(ext_mem_w_data)
        );

    
endmodule

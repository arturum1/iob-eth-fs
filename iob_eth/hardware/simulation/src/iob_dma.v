// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_dma_conf.vh"

module iob_dma #(
    parameter DATA_W = `IOB_DMA_DATA_W,
    parameter ADDR_W = `IOB_DMA_ADDR_W,
    parameter AXI_ADDR_W = `IOB_DMA_AXI_ADDR_W,
    parameter AXI_LEN_W = `IOB_DMA_AXI_LEN_W,
    parameter AXI_DATA_W = `IOB_DMA_AXI_DATA_W,
    parameter AXI_ID_W = `IOB_DMA_AXI_ID_W,
    parameter WLEN_W = `IOB_DMA_WLEN_W,
    parameter RLEN_W = `IOB_DMA_RLEN_W
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // rst_i: Synchronous reset interface
    input rst_i,
    // dma_input_io: 
    input [AXI_DATA_W-1:0] axis_in_tdata_i,
    input axis_in_tvalid_i,
    output axis_in_tready_o,
    // dma_output_io: 
    output [AXI_DATA_W-1:0] axis_out_tdata_o,
    output axis_out_tvalid_o,
    input axis_out_tready_i,
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
    input [AXI_ID_W-1:0] axi_bid_i,
    // csrs_cbus_s: Control and Status Registers interface (auto-generated)
    input csrs_iob_valid_i,
    input [5-1:0] csrs_iob_addr_i,
    input [DATA_W-1:0] csrs_iob_wdata_i,
    input [DATA_W/8-1:0] csrs_iob_wstrb_i,
    output csrs_iob_rvalid_o,
    output [DATA_W-1:0] csrs_iob_rdata_o,
    output csrs_iob_ready_o
);

    wire receive_enabled;
    wire receive_valid;
    wire receive_ready;
    wire w_length_wen_wr;
    wire [WLEN_W-1:0] w_length_wdata_wr;
    wire [WLEN_W-1:0] w_length_wdata_reg;
// Counter enable signal
    wire counter_en;
    wire [WLEN_W-1:0] axis_in_cnt;
// Configure write (AXIS in)
    wire [AXI_ADDR_W-1:0] w_addr_wr;
    wire w_start_wen_wr;
    wire [(AXI_LEN_W+1)-1:0] w_burstlen_wr;
    wire [WLEN_W-1:0] w_buf_level_rd;
    wire w_busy_rd;
// Configure read (AXIS out)
    wire [AXI_ADDR_W-1:0] r_addr_wr;
    wire [WLEN_W-1:0] r_length_wr;
    wire r_start_wen_wr;
    wire [(AXI_LEN_W+1)-1:0] r_burstlen_wr;
    wire [WLEN_W-1:0] r_buf_level_rd;
    wire r_busy_rd;
// External memory write wires
    wire ext_mem_write_clk;
    wire ext_mem_write_r_en;
    wire [AXI_LEN_W-1:0] ext_mem_write_r_addr;
    wire [AXI_DATA_W-1:0] ext_mem_write_r_data;
    wire ext_mem_write_w_en;
    wire [AXI_LEN_W-1:0] ext_mem_write_w_addr;
    wire [AXI_DATA_W-1:0] ext_mem_write_w_data;
// External memory read wires
    wire ext_mem_read_clk;
    wire ext_mem_read_r_en;
    wire [AXI_LEN_W-1:0] ext_mem_read_r_addr;
    wire [AXI_DATA_W-1:0] ext_mem_read_r_data;
    wire ext_mem_read_w_en;
    wire [AXI_LEN_W-1:0] ext_mem_read_w_addr;
    wire [AXI_DATA_W-1:0] ext_mem_read_w_data;
    wire w_length_valid_wr;
    wire [WLEN_W/8-1:0] w_length_wstrb_wr;
    wire w_length_ready_wr;
    wire w_start_valid_wr;
    wire w_start_wdata_wr;
    wire w_start_wstrb_wr;
    wire w_start_ready_wr;
    wire r_start_valid_wr;
    wire r_start_wdata_wr;
    wire r_start_wstrb_wr;
    wire r_start_ready_wr;
// Counter reset input
    wire counter_rst;


    assign counter_en = axis_in_tvalid_i & axis_in_tready_o & receive_enabled;
    assign receive_enabled = axis_in_cnt != w_length_wdata_reg;
    assign receive_valid = axis_in_tvalid_i & receive_enabled;
    assign axis_in_tready_o = receive_ready & receive_enabled;

    assign w_length_ready_wr = 1'b1;
    assign w_start_ready_wr = 1'b1;
    assign r_start_ready_wr = 1'b1;

    assign w_length_wen_wr = w_length_valid_wr & w_length_ready_wr;
    assign w_start_wen_wr = w_start_valid_wr & w_start_ready_wr;
    assign r_start_wen_wr = r_start_valid_wr & r_start_ready_wr;


        // Control/Status Registers
        iob_dma_csrs #(
        .AXI_ADDR_W(AXI_ADDR_W),
        .AXI_LEN_W(AXI_LEN_W),
        .WLEN_W(WLEN_W),
        .RLEN_W(RLEN_W)
    ) csrs (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // w_addr_o port: w_addr register interface
        .w_addr_rdata_o(w_addr_wr),
        // w_length_io port: w_length register interface
        .w_length_valid_o(w_length_valid_wr),
        .w_length_wdata_o(w_length_wdata_wr),
        .w_length_wstrb_o(w_length_wstrb_wr),
        .w_length_ready_i(w_length_ready_wr),
        // w_busy_i port: w_busy register interface
        .w_busy_wdata_i(w_busy_rd),
        // w_start_io port: w_start register interface
        .w_start_valid_o(w_start_valid_wr),
        .w_start_wdata_o(w_start_wdata_wr),
        .w_start_wstrb_o(w_start_wstrb_wr),
        .w_start_ready_i(w_start_ready_wr),
        // w_burstlen_o port: w_burstlen register interface
        .w_burstlen_rdata_o(w_burstlen_wr),
        // w_buf_level_i port: w_buf_level register interface
        .w_buf_level_wdata_i(w_buf_level_rd),
        // r_addr_o port: r_addr register interface
        .r_addr_rdata_o(r_addr_wr),
        // r_length_o port: r_length register interface
        .r_length_rdata_o(r_length_wr),
        // r_busy_i port: r_busy register interface
        .r_busy_wdata_i(r_busy_rd),
        // r_start_io port: r_start register interface
        .r_start_valid_o(r_start_valid_wr),
        .r_start_wdata_o(r_start_wdata_wr),
        .r_start_wstrb_o(r_start_wstrb_wr),
        .r_start_ready_i(r_start_ready_wr),
        // r_burstlen_o port: r_burstlen register interface
        .r_burstlen_rdata_o(r_burstlen_wr),
        // r_buf_level_i port: r_buf_level register interface
        .r_buf_level_wdata_i(r_buf_level_rd),
        // control_if_s port: CSR control interface. Interface type defined by `csr_if` parameter.
        .iob_valid_i(csrs_iob_valid_i),
        .iob_addr_i(csrs_iob_addr_i),
        .iob_wdata_i(csrs_iob_wdata_i),
        .iob_wstrb_i(csrs_iob_wstrb_i),
        .iob_rvalid_o(csrs_iob_rvalid_o),
        .iob_rdata_o(csrs_iob_rdata_o),
        .iob_ready_o(csrs_iob_ready_o)
        );

            // Write length register
        iob_reg_cae #(
        .DATA_W(WLEN_W),
        .RST_VAL({WLEN_W{1'd0}})
    ) w_length (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .en_i(w_length_wen_wr),
        // data_i port: Data input
        .data_i(w_length_wdata_wr),
        // data_o port: Data output
        .data_o(w_length_wdata_reg)
        );

            // Count number of words read via AXI Stream in
        iob_counter #(
        .DATA_W(WLEN_W)
    ) counter_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // counter_rst_i port: Counter reset input
        .counter_rst_i(counter_rst),
        // counter_en_i port: Counter enable input
        .counter_en_i(counter_en),
        // data_o port: Output port
        .data_o(axis_in_cnt)
        );

            // AXIS to AXI
        iob_axis_s_axi_m #(
        .AXI_ADDR_W(AXI_ADDR_W),
        .AXI_LEN_W(AXI_LEN_W),
        .AXI_DATA_W(AXI_DATA_W),
        .AXI_ID_W(AXI_ID_W),
        .WLEN_W(WLEN_W),
        .RLEN_W(RLEN_W)
    ) axis_s_axi_m_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // rst_i port: Synchronous reset interface
        .rst_i(rst_i),
        .w_addr_i(w_addr_wr),
        .w_length_i(w_length_wdata_reg),
        .w_start_transfer_i(w_start_wen_wr),
        .w_max_len_i(w_burstlen_wr),
        .w_remaining_data_o(w_buf_level_rd),
        .w_busy_o(w_busy_rd),
        .r_addr_i(r_addr_wr),
        .r_length_i(r_length_wr),
        .r_start_transfer_i(r_start_wen_wr),
        .r_max_len_i(r_burstlen_wr),
        .r_remaining_data_o(r_buf_level_rd),
        .r_busy_o(r_busy_rd),
        .axis_in_tdata_i(axis_in_tdata_i),
        .axis_in_tvalid_i(receive_valid),
        .axis_in_tready_o(receive_ready),
        .axis_out_tdata_o(axis_out_tdata_o),
        .axis_out_tvalid_o(axis_out_tvalid_o),
        .axis_out_tready_i(axis_out_tready_i),
        // write_ext_mem_m port: External memory interface
        .ext_mem_write_clk_o(ext_mem_write_clk),
        .ext_mem_write_r_en_o(ext_mem_write_r_en),
        .ext_mem_write_r_addr_o(ext_mem_write_r_addr),
        .ext_mem_write_r_data_i(ext_mem_write_r_data),
        .ext_mem_write_w_en_o(ext_mem_write_w_en),
        .ext_mem_write_w_addr_o(ext_mem_write_w_addr),
        .ext_mem_write_w_data_o(ext_mem_write_w_data),
        // read_ext_mem_m port: External memory interface
        .ext_mem_read_clk_o(ext_mem_read_clk),
        .ext_mem_read_r_en_o(ext_mem_read_r_en),
        .ext_mem_read_r_addr_o(ext_mem_read_r_addr),
        .ext_mem_read_r_data_i(ext_mem_read_r_data),
        .ext_mem_read_w_en_o(ext_mem_read_w_en),
        .ext_mem_read_w_addr_o(ext_mem_read_w_addr),
        .ext_mem_read_w_data_o(ext_mem_read_w_data),
        // axi_m port: AXI interface
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
        .axi_bid_i(axi_bid_i)
        );

            // Write FIFO RAM
        iob_ram_t2p #(
        .ADDR_W(AXI_LEN_W),
        .DATA_W(DATA_W)
    ) write_fifo_memory (
            // ram_t2p_s port: RAM interface
        .clk_i(ext_mem_write_clk),
        .r_en_i(ext_mem_write_r_en),
        .r_addr_i(ext_mem_write_r_addr),
        .r_data_o(ext_mem_write_r_data),
        .w_en_i(ext_mem_write_w_en),
        .w_addr_i(ext_mem_write_w_addr),
        .w_data_i(ext_mem_write_w_data)
        );

            // Read FIFO RAM
        iob_ram_t2p #(
        .ADDR_W(AXI_LEN_W),
        .DATA_W(DATA_W)
    ) read_fifo_memory (
            // ram_t2p_s port: RAM interface
        .clk_i(ext_mem_read_clk),
        .r_en_i(ext_mem_read_r_en),
        .r_addr_i(ext_mem_read_r_addr),
        .r_data_o(ext_mem_read_r_data),
        .w_en_i(ext_mem_read_w_en),
        .w_addr_i(ext_mem_read_w_addr),
        .w_data_i(ext_mem_read_w_data)
        );

    
endmodule

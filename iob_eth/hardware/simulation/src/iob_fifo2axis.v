// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_fifo2axis_conf.vh"

module iob_fifo2axis #(
    parameter DATA_W = `IOB_FIFO2AXIS_DATA_W,
    parameter AXIS_LEN_W = `IOB_FIFO2AXIS_AXIS_LEN_W
) (
    // clk_en_rst_s: Clock, clock enable, async and sync reset
    input clk_i,
    input cke_i,
    input arst_i,
    input rst_i,
    // en_i: Enable signal
    input en_i,
    // len_i: Length signal
    input [AXIS_LEN_W-1:0] len_i,
    // level_o: Level signal
    output reg [2-1:0] level_o,
    // fifo_read_o: FIFO read signal
    output reg fifo_read_o,
    // fifo_rdata_i: FIFO read data signal
    input [DATA_W-1:0] fifo_rdata_i,
    // fifo_empty_i: FIFO empty signal
    input fifo_empty_i,
    // axis_m: AXIS manager interface
    output [DATA_W-1:0] axis_tdata_o,
    output axis_tvalid_o,
    input axis_tready_i,
    output axis_tlast_o
);

// Data valid register
    wire data_valid;
// Saved register
    wire saved;
// Saved tdata register
    wire [DATA_W-1:0] saved_tdata;
// Outputs enable signal
    reg outputs_enable;
// Read condition signal
    reg read_condition;
// AXIS word count signal
    wire [AXIS_LEN_W-1:0] axis_word_count;
// Length internal signal
    reg [AXIS_LEN_W-1:0] len_int;
// Saved tlast register
    wire saved_tlast;
    reg data_valid_nxt;
    reg saved_nxt;
    reg saved_rst;
    reg [DATA_W-1:0] saved_tdata_nxt;
    reg saved_tdata_en;
    reg saved_tlast_nxt;
    reg saved_tlast_en;
    reg [DATA_W-1:0] axis_tdata_o_nxt;
    reg axis_tdata_o_en;
    reg axis_tvalid_o_nxt;
    reg axis_tvalid_o_en;
    reg axis_tlast_o_nxt;
    reg axis_tlast_o_en;

	always @ (*)
		begin
			

    // Skid buffer
    // Signals if there is valid data in skid buffer
    outputs_enable = (~axis_tvalid_o) | axis_tready_i;
    saved_rst = rst_i | outputs_enable;
    saved_nxt = (data_valid & (~outputs_enable)) | saved;
    saved_tdata_en = data_valid;
    saved_tdata_nxt = fifo_rdata_i;

    // AXIS regs
    // tvalid
    axis_tvalid_o_en  = outputs_enable;
    axis_tvalid_o_nxt = saved | data_valid;
    // tdata
    axis_tdata_o_en  = outputs_enable;
    axis_tdata_o_nxt = (saved) ? saved_tdata : fifo_rdata_i;

    //FIFO read
    // read new data:
    // 1. if tready is high
    // 2. if no data is saved
    // 3. if no data is being read from fifo
    read_condition = axis_tready_i | (~axis_tvalid_o_nxt);
    
        if (saved && axis_tvalid_o) begin
            level_o = 2'd2;
        end else if (saved || axis_tvalid_o) begin
            level_o = 2'd1;
        end else begin
            level_o = 2'd0;
        end
        
        fifo_read_o    = (en_i & (~fifo_empty_i)) & read_condition;
        
    // Data valid register
    data_valid_nxt = fifo_read_o;
    
        // tlast
        len_int = len_i - 1;
        saved_tlast_en = data_valid;
        saved_tlast_nxt = axis_word_count == len_int;
        axis_tlast_o_en  = outputs_enable;
        axis_tlast_o_nxt = (saved) ? saved_tlast : saved_tlast_nxt;
        
		end

        // data_valid register
        iob_reg_car #(
        .DATA_W(1),
        .RST_VAL(0)
    ) data_valid_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        // data_i port: Data input
        .data_i(data_valid_nxt),
        // data_o port: Data output
        .data_o(data_valid)
        );

            // saved register
        iob_reg_car #(
        .DATA_W(1),
        .RST_VAL(0)
    ) saved_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(saved_rst),
        // data_i port: Data input
        .data_i(saved_nxt),
        // data_o port: Data output
        .data_o(saved)
        );

            // saved_tdata register
        iob_reg_care #(
        .DATA_W(DATA_W),
        .RST_VAL(0)
    ) saved_tdata_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(saved_tdata_en),
        // data_i port: Data input
        .data_i(saved_tdata_nxt),
        // data_o port: Data output
        .data_o(saved_tdata)
        );

            // saved_tlast register
        iob_reg_care #(
        .DATA_W(1),
        .RST_VAL(0)
    ) saved_tlast_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(saved_tlast_en),
        // data_i port: Data input
        .data_i(saved_tlast_nxt),
        // data_o port: Data output
        .data_o(saved_tlast)
        );

            // axis_tdata_o register
        iob_reg_care #(
        .DATA_W(DATA_W),
        .RST_VAL(0)
    ) axis_tdata_o_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(axis_tdata_o_en),
        // data_i port: Data input
        .data_i(axis_tdata_o_nxt),
        // data_o port: Data output
        .data_o(axis_tdata_o)
        );

            // axis_tvalid_o register
        iob_reg_care #(
        .DATA_W(1),
        .RST_VAL(0)
    ) axis_tvalid_o_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(axis_tvalid_o_en),
        // data_i port: Data input
        .data_i(axis_tvalid_o_nxt),
        // data_o port: Data output
        .data_o(axis_tvalid_o)
        );

            // axis_tlast_o register
        iob_reg_care #(
        .DATA_W(1),
        .RST_VAL(0)
    ) axis_tlast_o_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(axis_tlast_o_en),
        // data_i port: Data input
        .data_i(axis_tlast_o_nxt),
        // data_o port: Data output
        .data_o(axis_tlast_o)
        );

            // tdata word count
        iob_modcnt #(
        .DATA_W(AXIS_LEN_W),
        .RST_VAL({AXIS_LEN_W{1'b1}})
    ) word_count_inst (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // en_rst_i port: Enable and Synchronous reset interface
        .rst_i(rst_i),
        .en_i(fifo_read_o),
        // mod_i port: Input port
        .mod_i(len_int),
        // data_o port: Output port
        .data_o(axis_word_count)
        );

    
endmodule

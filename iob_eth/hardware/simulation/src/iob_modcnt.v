// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_modcnt_conf.vh"

module iob_modcnt #(
    parameter DATA_W = `IOB_MODCNT_DATA_W,
    parameter RST_VAL = `IOB_MODCNT_RST_VAL
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // en_rst_i: Enable and Synchronous reset interface
    input rst_i,
    input en_i,
    // mod_i: Input port
    input [DATA_W-1:0] mod_i,
    // data_o: Output port
    output [DATA_W-1:0] data_o
);

// ld_count wire
    wire ld_count;
// data wire
    wire [DATA_W-1:0] data;


        assign ld_count = (data_o >= mod_i);
        assign data = ld_count ? {DATA_W{1'b0}} : data_o + 1'b1;
            

        // Default description
        iob_reg_care #(
        .DATA_W(DATA_W),
        .RST_VAL(RST_VAL)
    ) reg0 (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(en_i),
        // data_i port: Data input
        .data_i(data),
        // data_o port: Data output
        .data_o(data_o)
        );

    
endmodule

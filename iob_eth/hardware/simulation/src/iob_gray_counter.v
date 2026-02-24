// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_gray_counter_conf.vh"

module iob_gray_counter #(
    parameter W = `IOB_GRAY_COUNTER_W
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    input rst_i,
    input en_i,
    // data_o: Data output
    output [W-1:0] data_o
);

// Binary counter
    wire [W-1:0] bin_counter;
// Binary counter next
    wire [W-1:0] bin_counter_nxt;
// Gray counter
    wire [W-1:0] gray_counter;
// Gray counter next
    wire [W-1:0] gray_counter_nxt;


                assign bin_counter_nxt = bin_counter + 1'b1;
                generate
                    if (W > 1) begin : g_width_gt1
                        assign gray_counter_nxt = {bin_counter[W-1], bin_counter[W-2:0] ^ bin_counter[W-1:1]};
                     end else begin : g_width_eq1
                        assign gray_counter_nxt = bin_counter;
                    end
                endgenerate
                assign data_o = gray_counter;


                

        // Default description
        iob_reg_care #(
        .DATA_W(W),
        .RST_VAL({{(W - 1) {1'd0}}, 1'd1})
    ) bin_counter_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(en_i),
        // data_i port: Data input
        .data_i(bin_counter_nxt),
        // data_o port: Data output
        .data_o(bin_counter)
        );

            // Default description
        iob_reg_care #(
        .DATA_W(W),
        .RST_VAL({W{1'd0}})
    ) gray_counter_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .rst_i(rst_i),
        .en_i(en_i),
        // data_i port: Data input
        .data_i(gray_counter_nxt),
        // data_o port: Data output
        .data_o(gray_counter)
        );

    
endmodule

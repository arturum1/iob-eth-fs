// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_gray2bin_conf.vh"

module iob_gray2bin #(
    parameter DATA_W = `IOB_GRAY2BIN_DATA_W
) (
    // gr_i: Gray input
    input [DATA_W-1:0] gr_i,
    // bin_o: Binary output
    output [DATA_W-1:0] bin_o
);


                genvar pos;

                generate
                   for (pos = 0; pos < DATA_W; pos = pos + 1) begin : gen_bin
                      assign bin_o[pos] = ^gr_i[DATA_W-1:pos];
                   end
                endgenerate
                


endmodule

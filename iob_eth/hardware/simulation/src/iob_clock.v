// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_clock_conf.vh"

module iob_clock #(
    parameter CLK_PERIOD = `IOB_CLOCK_CLK_PERIOD
) (
    // clk_o: Output clock
    output clk_o
);


   reg clk;
   assign clk_o = clk;
   initial clk = 0; always #(CLK_PERIOD/2) clk = ~clk;
        


endmodule

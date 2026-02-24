// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_eth_mii_management_conf.vh"

module iob_eth_mii_management (
   // clk_en_rst_s: Clock, clock enable and reset
   input  clk_i,
   input  cke_i,
   input  arst_i,
   // management_io: MII management interface
   output mii_mdc_o,
   inout  mii_mdio_io
);


   assign mii_mdc_o = 1'b0;  //TODO
   //assign mii_mdio_io   = 1'b0;  //TODO




endmodule

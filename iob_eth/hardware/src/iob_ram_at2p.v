// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_ram_at2p_conf.vh"

module iob_ram_at2p #(
   parameter DATA_W = `IOB_RAM_AT2P_DATA_W,
   parameter ADDR_W = `IOB_RAM_AT2P_ADDR_W
) (
   // ram_at2p_s: RAM interface
   input               r_clk_i,
   input               r_en_i,
   input  [ADDR_W-1:0] r_addr_i,
   output [DATA_W-1:0] r_data_o,
   input               w_clk_i,
   input               w_en_i,
   input  [ADDR_W-1:0] w_addr_i,
   input  [DATA_W-1:0] w_data_i
);


   // Declare the RAM
   reg [DATA_W-1:0] ram        [(2**ADDR_W)-1:0];
   reg [DATA_W-1:0] r_data_int;
   assign r_data_o = r_data_int;

   //write
   always @(posedge w_clk_i) begin
      if (w_en_i) begin
         ram[w_addr_i] <= w_data_i;
      end
   end

   //read
   always @(posedge r_clk_i) begin
      if (r_en_i) begin
         r_data_int <= ram[r_addr_i];
      end
   end



endmodule

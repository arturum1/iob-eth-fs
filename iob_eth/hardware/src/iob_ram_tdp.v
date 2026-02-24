// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_ram_tdp_conf.vh"

module iob_ram_tdp #(
   parameter HEXFILE = `IOB_RAM_TDP_HEXFILE,
   parameter ADDR_W = `IOB_RAM_TDP_ADDR_W,
   parameter DATA_W = `IOB_RAM_TDP_DATA_W,
   parameter MEM_NO_READ_ON_WRITE = `IOB_RAM_TDP_MEM_NO_READ_ON_WRITE,
   parameter MEM_INIT_FILE_INT =
   `IOB_RAM_TDP_MEM_INIT_FILE_INT  // Don't change this parameter value!
) (
   // clk_i: clock
   input               clk_i,
   // port_a_io: Port A
   input               enA_i,
   input               weA_i,
   input  [ADDR_W-1:0] addrA_i,
   input  [DATA_W-1:0] dA_i,
   output [DATA_W-1:0] dA_o,
   // port_b_io: Port B
   input               enB_i,
   input               weB_i,
   input  [ADDR_W-1:0] addrB_i,
   input  [DATA_W-1:0] dB_i,
   output [DATA_W-1:0] dB_o
);


   localparam INIT_RAM = (MEM_INIT_FILE_INT != "none") ? 1 : 0;
   reg [DATA_W-1:0] dA_o_reg;
   reg [DATA_W-1:0] dB_o_reg;
   assign dA_o = dA_o_reg;
   assign dB_o = dB_o_reg;
   // Declare the RAM
   reg [DATA_W-1:0] ram[2**ADDR_W-1:0];

   // Initialize the RAM
   generate
      if (INIT_RAM) begin : mem_init
         initial $readmemh(MEM_INIT_FILE_INT, ram, 0, 2 ** ADDR_W - 1);
      end
   endgenerate

   generate
      if (MEM_NO_READ_ON_WRITE) begin : with_MEM_NO_READ_ON_WRITE
         always @(posedge clk_i) begin  // Port A
            if (enA_i)
               if (weA_i) ram[addrA_i] <= dA_i;
               else dA_o_reg <= ram[addrA_i];
         end
         always @(posedge clk_i) begin  // Port B
            if (enB_i)
               if (weB_i) ram[addrB_i] <= dB_i;
               else dB_o_reg <= ram[addrB_i];
         end
      end else begin : not_MEM_NO_READ_ON_WRITE
         always @(posedge clk_i) begin  // Port A
            if (enA_i) if (weA_i) ram[addrA_i] <= dA_i;
            dA_o_reg <= ram[addrA_i];
         end
         always @(posedge clk_i) begin  // Port B
            if (enB_i) if (weB_i) ram[addrB_i] <= dB_i;
            dB_o_reg <= ram[addrB_i];
         end
      end
   endgenerate



endmodule

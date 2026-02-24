// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_edge_detect_conf.vh"

module iob_edge_detect #(
    parameter EDGE_TYPE = `IOB_EDGE_DETECT_EDGE_TYPE,
    parameter OUT_TYPE = `IOB_EDGE_DETECT_OUT_TYPE
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    input rst_i,
    // bit_i: 
    input bit_i,
    // detected_o: 
    output detected_o
);

// Internal bit wire
    wire bit_int;
// Internal bit wire with delay
    wire bit_int_q;


                generate
    if (EDGE_TYPE == "falling") begin : gen_falling
      assign bit_int = ~bit_i;
      iob_reg_car #(
          .DATA_W (1),
          .RST_VAL(1'b0)
      ) bit_reg (
.clk_i(clk_i),
.cke_i(cke_i),
.arst_i(arst_i),
.rst_i(rst_i),
          .data_i(bit_int),
          .data_o(bit_int_q)
      );

    end else begin : gen_default_rising
      assign bit_int = bit_i;

      iob_reg_car #(
          .DATA_W (1),
          .RST_VAL(1'b1)
      ) bit_reg (
.clk_i(clk_i),
.cke_i(cke_i),
.arst_i(arst_i),
.rst_i(rst_i),
          .data_i(bit_int),
          .data_o(bit_int_q)
      );
    end
  endgenerate

  generate
    if (OUT_TYPE == "pulse") begin : gen_pulse
      assign detected_o = bit_int & ~bit_int_q;
    end else begin : gen_step
      wire detected_prev;
      iob_reg_car #(
          .DATA_W(1)
      ) detected_reg (
.clk_i(clk_i),
.cke_i(cke_i),
.arst_i(arst_i),
.rst_i(rst_i),
          .data_i(detected_o),
          .data_o(detected_prev)
      );
      assign detected_o = detected_prev | (bit_int & ~bit_int_q);
    end
  endgenerate
                


endmodule

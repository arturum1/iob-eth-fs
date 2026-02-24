// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_axistream_in_csrs_conf.vh"

module iob_axistream_in_csrs #(
    parameter ADDR_W = `IOB_AXISTREAM_IN_CSRS_ADDR_W,  // Don't change this parameter value!
    parameter DATA_W = `IOB_AXISTREAM_IN_CSRS_DATA_W,
    parameter TDATA_W = `IOB_AXISTREAM_IN_CSRS_TDATA_W,
    parameter FIFO_ADDR_W = `IOB_AXISTREAM_IN_CSRS_FIFO_ADDR_W
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // control_if_s: CSR control interface. Interface type defined by `csr_if` parameter.
    input iob_valid_i,
    input [5-1:0] iob_addr_i,
    input [DATA_W-1:0] iob_wdata_i,
    input [DATA_W/8-1:0] iob_wstrb_i,
    output iob_rvalid_o,
    output [DATA_W-1:0] iob_rdata_o,
    output iob_ready_o,
    // soft_reset_o: soft_reset register interface
    output soft_reset_rdata_o,
    // enable_o: enable register interface
    output enable_rdata_o,
    // data_io: data register interface
    output data_valid_o,
    input [32-1:0] data_rdata_i,
    input data_ready_i,
    input data_rvalid_i,
    // mode_o: mode register interface
    output mode_rdata_o,
    // nwords_i: nwords register interface
    input [((DATA_W > 1) ? DATA_W : 1)-1:0] nwords_wdata_i,
    // tlast_detected_i: tlast_detected register interface
    input tlast_detected_wdata_i,
    // fifo_full_i: fifo_full register interface
    input fifo_full_wdata_i,
    // fifo_empty_i: fifo_empty register interface
    input fifo_empty_wdata_i,
    // fifo_threshold_o: fifo_threshold register interface
    output [((FIFO_ADDR_W+1 > 1) ? FIFO_ADDR_W+1 : 1)-1:0] fifo_threshold_rdata_o,
    // fifo_level_i: fifo_level register interface
    input [((FIFO_ADDR_W+1 > 1) ? FIFO_ADDR_W+1 : 1)-1:0] fifo_level_wdata_i
);

// Internal iob interface
    wire internal_iob_valid;
    wire [ADDR_W-1:0] internal_iob_addr;
    wire [DATA_W-1:0] internal_iob_wdata;
    wire [DATA_W/8-1:0] internal_iob_wstrb;
    wire internal_iob_rvalid;
    wire [DATA_W-1:0] internal_iob_rdata;
    wire internal_iob_ready;
    wire state;
    reg state_nxt;
    wire write_en;
    wire [ADDR_W-1:0] internal_iob_addr_stable;
    wire [ADDR_W-1:0] internal_iob_addr_reg;
    wire internal_iob_addr_reg_en;
    wire soft_reset_wdata;
    wire soft_reset_w_valid;
    wire enable_wdata;
    wire enable_w_valid;
    wire mode_wdata;
    wire mode_w_valid;
    wire [((FIFO_ADDR_W+1 > 1) ? FIFO_ADDR_W+1 : 1)-1:0] fifo_threshold_wdata;
    wire fifo_threshold_w_valid;
    wire [((DATA_W > 1) ? DATA_W : 1)-1:0] nwords_rdata;
    wire tlast_detected_rdata;
    wire fifo_full_rdata;
    wire fifo_empty_rdata;
    wire [((FIFO_ADDR_W+1 > 1) ? FIFO_ADDR_W+1 : 1)-1:0] fifo_level_rdata;
    wire iob_rvalid_out;
    reg iob_rvalid_nxt;
    wire [32-1:0] iob_rdata_out;
    reg [32-1:0] iob_rdata_nxt;
    wire iob_ready_out;
    reg iob_ready_nxt;
// Rvalid signal of currently addressed CSR
    reg rvalid_int;
// Ready signal of currently addressed CSR
    reg ready_int;


    // Include iob_functions for use in parameters
    localparam IOB_MAX_W = ADDR_W;
    function [IOB_MAX_W-1:0] iob_max;
       input [IOB_MAX_W-1:0] a;
       input [IOB_MAX_W-1:0] b;
       begin
          if (a > b) iob_max = a;
          else iob_max = b;
       end
    endfunction

    function integer iob_abs;
       input integer a;
       begin
          iob_abs = (a >= 0) ? a : -a;
       end
    endfunction

    `define IOB_NBYTES (DATA_W/8)
    `define IOB_NBYTES_W $clog2(`IOB_NBYTES)
    `define IOB_WORD_ADDR(ADDR) ((ADDR>>`IOB_NBYTES_W)<<`IOB_NBYTES_W)

    localparam WSTRB_W = DATA_W/8;

    //FSM states
    localparam WAIT_REQ = 1'd0;
    localparam WAIT_RVALID = 1'd1;


    assign internal_iob_addr_reg_en = internal_iob_valid;
    assign internal_iob_addr_stable = internal_iob_valid ? internal_iob_addr : internal_iob_addr_reg;

    assign write_en = |internal_iob_wstrb;

    //write address
    wire [($clog2(WSTRB_W)+1)-1:0] byte_offset;
    iob_ctls #(.W(WSTRB_W), .MODE(0), .SYMBOL(0)) bo_inst (.data_i(internal_iob_wstrb), .count_o(byte_offset));

    wire [ADDR_W-1:0] wstrb_addr;
    assign wstrb_addr = `IOB_WORD_ADDR(internal_iob_addr_stable) + byte_offset;

// Create a special readstrobe for "REG" (auto) CSRs.
// LSBs 0 = read full word; LSBs 1 = read byte; LSBs 2 = read half word; LSBs 3 = read byte.
   reg [1:0] shift_amount;
   always @(*) begin
      case (internal_iob_addr_stable[1:0])
         // Access entire word
         2'b00: shift_amount = 2;
         // Access single byte
         2'b01: shift_amount = 0;
         // Access half word
         2'b10: shift_amount = 1;
         // Access single byte
         2'b11: shift_amount = 0;
         default: shift_amount = 0;
      endcase
    end


//NAME: soft_reset;
//MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 0; SPACE (bytes): 1 (max); TYPE: REG. 

    assign soft_reset_wdata = internal_iob_wdata[0+:1];
    wire soft_reset_addressed_w;
    assign soft_reset_addressed_w =  (wstrb_addr < 1);
    assign soft_reset_w_valid = internal_iob_valid & (write_en & soft_reset_addressed_w);
    iob_reg_cae #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) soft_reset_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (soft_reset_w_valid),
      .data_i (soft_reset_wdata),
      .data_o (soft_reset_rdata_o)
    );



//NAME: enable;
//MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 1; SPACE (bytes): 1 (max); TYPE: REG. 

    assign enable_wdata = internal_iob_wdata[8+:1];
    wire enable_addressed_w;
    assign enable_addressed_w = (wstrb_addr >= (1)) &&  (wstrb_addr < 2);
    assign enable_w_valid = internal_iob_valid & (write_en & enable_addressed_w);
    iob_reg_cae #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) enable_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (enable_w_valid),
      .data_i (enable_wdata),
      .data_o (enable_rdata_o)
    );



//NAME: mode;
//MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 8; SPACE (bytes): 1 (max); TYPE: REG. 

    assign mode_wdata = internal_iob_wdata[0+:1];
    wire mode_addressed_w;
    assign mode_addressed_w = (wstrb_addr >= (8)) &&  (wstrb_addr < 9);
    assign mode_w_valid = internal_iob_valid & (write_en & mode_addressed_w);
    iob_reg_cae #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) mode_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (mode_w_valid),
      .data_i (mode_wdata),
      .data_o (mode_rdata_o)
    );



//NAME: fifo_threshold;
//MODE: W; WIDTH: FIFO_ADDR_W+1; RST_VAL: 8; ADDR: 20; SPACE (bytes): 4 (max); TYPE: REG. 

    assign fifo_threshold_wdata = internal_iob_wdata[0+:((FIFO_ADDR_W+1 > 1) ? FIFO_ADDR_W+1 : 1)];
    wire fifo_threshold_addressed_w;
    assign fifo_threshold_addressed_w = (wstrb_addr >= (20)) &&  (wstrb_addr < 24);
    assign fifo_threshold_w_valid = internal_iob_valid & (write_en & fifo_threshold_addressed_w);
    iob_reg_cae #(
      .DATA_W(FIFO_ADDR_W+1),
      .RST_VAL({{(FIFO_ADDR_W+1-4){1'd0}},4'd8})
    ) fifo_threshold_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (fifo_threshold_w_valid),
      .data_i (fifo_threshold_wdata),
      .data_o (fifo_threshold_rdata_o)
    );



//NAME: data;
//MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

    wire data_addressed;
    assign data_addressed = (internal_iob_addr_stable >= (4)) && (internal_iob_addr_stable < 8);
   assign data_valid_o = internal_iob_valid & data_addressed & ~write_en;


//NAME: nwords;
//MODE: R; WIDTH: DATA_W; RST_VAL: 0; ADDR: 12; SPACE (bytes): 4 (max); TYPE: REG. 

    wire nwords_addressed_r;
    assign nwords_addressed_r = (internal_iob_addr_stable>>shift_amount >= (12>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,15>>shift_amount));
    iob_reg_ca #(
      .DATA_W(DATA_W),
      .RST_VAL({DATA_W{1'd0}})
    ) nwords_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (nwords_wdata_i),
      .data_o (nwords_rdata)
    );



//NAME: tlast_detected;
//MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 16; SPACE (bytes): 1 (max); TYPE: REG. 

    wire tlast_detected_addressed_r;
    assign tlast_detected_addressed_r = (internal_iob_addr_stable>>shift_amount >= (16>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,16>>shift_amount));
    iob_reg_ca #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) tlast_detected_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (tlast_detected_wdata_i),
      .data_o (tlast_detected_rdata)
    );



//NAME: fifo_full;
//MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 17; SPACE (bytes): 1 (max); TYPE: REG. 

    wire fifo_full_addressed_r;
    assign fifo_full_addressed_r = (internal_iob_addr_stable>>shift_amount >= (17>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,17>>shift_amount));
    iob_reg_ca #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) fifo_full_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (fifo_full_wdata_i),
      .data_o (fifo_full_rdata)
    );



//NAME: fifo_empty;
//MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 18; SPACE (bytes): 1 (max); TYPE: REG. 

    wire fifo_empty_addressed_r;
    assign fifo_empty_addressed_r = (internal_iob_addr_stable>>shift_amount >= (18>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,18>>shift_amount));
    iob_reg_ca #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) fifo_empty_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (fifo_empty_wdata_i),
      .data_o (fifo_empty_rdata)
    );



//NAME: fifo_level;
//MODE: R; WIDTH: FIFO_ADDR_W+1; RST_VAL: 0; ADDR: 24; SPACE (bytes): 4 (max); TYPE: REG. 

    wire fifo_level_addressed_r;
    assign fifo_level_addressed_r = (internal_iob_addr_stable>>shift_amount >= (24>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,27>>shift_amount));
    iob_reg_ca #(
      .DATA_W(FIFO_ADDR_W+1),
      .RST_VAL({FIFO_ADDR_W+1{1'd0}})
    ) fifo_level_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (fifo_level_wdata_i),
      .data_o (fifo_level_rdata)
    );



//NAME: version;
//MODE: R; WIDTH: 16; RST_VAL: 0081; ADDR: 28; SPACE (bytes): 2 (max); TYPE: REG. 

    wire version_addressed_r;
    assign version_addressed_r = (internal_iob_addr_stable>>shift_amount >= (28>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,29>>shift_amount));


    wire auto_addressed;
    wire auto_addressed_r;
    reg auto_addressed_nxt;

    //RESPONSE SWITCH

    // Don't register response signals if accessing non-auto CSR
    assign internal_iob_rvalid = auto_addressed ? iob_rvalid_out : rvalid_int;
    assign internal_iob_rdata = auto_addressed ? iob_rdata_out : iob_rdata_nxt;
    assign internal_iob_ready = auto_addressed ? iob_ready_out : ready_int;

   // auto_addressed register
   assign auto_addressed = (state == WAIT_REQ) ? auto_addressed_nxt : auto_addressed_r;
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) auto_addressed_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(auto_addressed_nxt),
      // data_o port: Data output
      .data_o(auto_addressed_r)
   );

    always @* begin
        iob_rdata_nxt = 32'd0;

        rvalid_int = 1'b1;
        ready_int = 1'b1;
        auto_addressed_nxt = auto_addressed_r;
        if (internal_iob_valid) begin
            auto_addressed_nxt = 1'b1;
        end
        if(data_addressed) begin

            iob_rdata_nxt[0+:32] = data_rdata_i|32'd0;
            rvalid_int = data_rvalid_i;
            ready_int = data_ready_i;
            if (internal_iob_valid & (~|internal_iob_wstrb)) begin
                auto_addressed_nxt = 1'b0;
            end
        end

        if(nwords_addressed_r) begin
            iob_rdata_nxt[0+:32] = nwords_rdata|32'd0;
        end

        if(tlast_detected_addressed_r) begin
            iob_rdata_nxt[0+:8] = {{7{1'b0}}, tlast_detected_rdata}|8'd0;
        end

        if(fifo_full_addressed_r) begin
            iob_rdata_nxt[8+:8] = {{7{1'b0}}, fifo_full_rdata}|8'd0;
        end

        if(fifo_empty_addressed_r) begin
            iob_rdata_nxt[16+:8] = {{7{1'b0}}, fifo_empty_rdata}|8'd0;
        end

        if(fifo_level_addressed_r) begin
            iob_rdata_nxt[0+:32] = {{7{1'b0}}, fifo_level_rdata}|32'd0;
        end

        if(version_addressed_r) begin
            iob_rdata_nxt[0+:16] = 16'h0081|16'd0;
        end



        // ######  FSM  #############

        //FSM default values
        iob_ready_nxt = 1'b0;
        iob_rvalid_nxt = 1'b0;
        state_nxt = state;

        //FSM state machine
        case(state)
            WAIT_REQ: begin
                if(internal_iob_valid) begin // Wait for a valid request

                    iob_ready_nxt = ready_int;

                    // If is read and ready, go to WAIT_RVALID
                    if (iob_ready_nxt && (!write_en)) begin
                        state_nxt = WAIT_RVALID;
                    end
                end
            end

            default: begin  // WAIT_RVALID

                if (auto_addressed & iob_rvalid_out) begin // Transfer done
                    state_nxt = WAIT_REQ;
                end else if ((!auto_addressed) & rvalid_int) begin // Transfer done
                    state_nxt = WAIT_REQ;
                end else begin
                    iob_rvalid_nxt = rvalid_int;

                end
            end
        endcase

    end //always @*



        // store iob addr
        iob_reg_cae #(
        .DATA_W(ADDR_W),
        .RST_VAL({ADDR_W{1'b0}})
    ) internal_addr_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        .en_i(internal_iob_addr_reg_en),
        // data_i port: Data input
        .data_i(internal_iob_addr),
        // data_o port: Data output
        .data_o(internal_iob_addr_reg)
        );

            // state register
        iob_reg_ca #(
        .DATA_W(1),
        .RST_VAL(1'b0)
    ) state_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // data_i port: Data input
        .data_i(state_nxt),
        // data_o port: Data output
        .data_o(state)
        );

            // Convert CSR interface into internal IOb port
        iob_universal_converter_iob_iob #(
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) iob_universal_converter (
            // s_s port: Subordinate port
        .iob_valid_i(iob_valid_i),
        .iob_addr_i(iob_addr_i),
        .iob_wdata_i(iob_wdata_i),
        .iob_wstrb_i(iob_wstrb_i),
        .iob_rvalid_o(iob_rvalid_o),
        .iob_rdata_o(iob_rdata_o),
        .iob_ready_o(iob_ready_o),
        // m_m port: Manager port
        .iob_valid_o(internal_iob_valid),
        .iob_addr_o(internal_iob_addr),
        .iob_wdata_o(internal_iob_wdata),
        .iob_wstrb_o(internal_iob_wstrb),
        .iob_rvalid_i(internal_iob_rvalid),
        .iob_rdata_i(internal_iob_rdata),
        .iob_ready_i(internal_iob_ready)
        );

            // rvalid register
        iob_reg_ca #(
        .DATA_W(1),
        .RST_VAL(1'b0)
    ) rvalid_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // data_i port: Data input
        .data_i(iob_rvalid_nxt),
        // data_o port: Data output
        .data_o(iob_rvalid_out)
        );

            // rdata register
        iob_reg_ca #(
        .DATA_W(32),
        .RST_VAL(32'b0)
    ) rdata_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // data_i port: Data input
        .data_i(iob_rdata_nxt),
        // data_o port: Data output
        .data_o(iob_rdata_out)
        );

            // ready register
        iob_reg_ca #(
        .DATA_W(1),
        .RST_VAL(1'b0)
    ) ready_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // data_i port: Data input
        .data_i(iob_ready_nxt),
        // data_o port: Data output
        .data_o(iob_ready_out)
        );

    
endmodule

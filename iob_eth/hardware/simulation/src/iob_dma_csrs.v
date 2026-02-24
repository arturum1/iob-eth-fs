// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_dma_csrs_conf.vh"

module iob_dma_csrs #(
    parameter ADDR_W = `IOB_DMA_CSRS_ADDR_W,  // Don't change this parameter value!
    parameter DATA_W = `IOB_DMA_CSRS_DATA_W,
    parameter AXI_ADDR_W = `IOB_DMA_CSRS_AXI_ADDR_W,
    parameter AXI_LEN_W = `IOB_DMA_CSRS_AXI_LEN_W,
    parameter AXI_DATA_W = `IOB_DMA_CSRS_AXI_DATA_W,
    parameter AXI_ID_W = `IOB_DMA_CSRS_AXI_ID_W,
    parameter WLEN_W = `IOB_DMA_CSRS_WLEN_W,
    parameter RLEN_W = `IOB_DMA_CSRS_RLEN_W
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
    // w_addr_o: w_addr register interface
    output [((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)-1:0] w_addr_rdata_o,
    // w_length_io: w_length register interface
    output w_length_valid_o,
    output [((WLEN_W > 1) ? WLEN_W : 1)-1:0] w_length_wdata_o,
    output [((WLEN_W/8 > 1) ? WLEN_W/8 : 1)-1:0] w_length_wstrb_o,
    input w_length_ready_i,
    // w_busy_i: w_busy register interface
    input w_busy_wdata_i,
    // w_start_io: w_start register interface
    output w_start_valid_o,
    output w_start_wdata_o,
    output [((1/8 > 1) ? 1/8 : 1)-1:0] w_start_wstrb_o,
    input w_start_ready_i,
    // w_burstlen_o: w_burstlen register interface
    output [(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)-1:0] w_burstlen_rdata_o,
    // w_buf_level_i: w_buf_level register interface
    input [((WLEN_W > 1) ? WLEN_W : 1)-1:0] w_buf_level_wdata_i,
    // r_addr_o: r_addr register interface
    output [((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)-1:0] r_addr_rdata_o,
    // r_length_o: r_length register interface
    output [((RLEN_W > 1) ? RLEN_W : 1)-1:0] r_length_rdata_o,
    // r_start_io: r_start register interface
    output r_start_valid_o,
    output r_start_wdata_o,
    output [((1/8 > 1) ? 1/8 : 1)-1:0] r_start_wstrb_o,
    input r_start_ready_i,
    // r_busy_i: r_busy register interface
    input r_busy_wdata_i,
    // r_burstlen_o: r_burstlen register interface
    output [(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)-1:0] r_burstlen_rdata_o,
    // r_buf_level_i: r_buf_level register interface
    input [((RLEN_W > 1) ? RLEN_W : 1)-1:0] r_buf_level_wdata_i
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
    wire [((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)-1:0] w_addr_wdata;
    wire w_addr_w_valid;
    wire [((WLEN_W > 1) ? WLEN_W : 1)-1:0] w_length_wdata;
    wire [((WLEN_W/8 > 1) ? WLEN_W/8 : 1)-1:0] w_length_wstrb;
    wire w_start_wdata;
    wire [((1/8 > 1) ? 1/8 : 1)-1:0] w_start_wstrb;
    wire [(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)-1:0] w_burstlen_wdata;
    wire w_burstlen_w_valid;
    wire [((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)-1:0] r_addr_wdata;
    wire r_addr_w_valid;
    wire [((RLEN_W > 1) ? RLEN_W : 1)-1:0] r_length_wdata;
    wire r_length_w_valid;
    wire r_start_wdata;
    wire [((1/8 > 1) ? 1/8 : 1)-1:0] r_start_wstrb;
    wire [(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)-1:0] r_burstlen_wdata;
    wire r_burstlen_w_valid;
    wire w_busy_rdata;
    wire [((WLEN_W > 1) ? WLEN_W : 1)-1:0] w_buf_level_rdata;
    wire r_busy_rdata;
    wire [((RLEN_W > 1) ? RLEN_W : 1)-1:0] r_buf_level_rdata;
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


//NAME: w_addr;
//MODE: W; WIDTH: AXI_ADDR_W; RST_VAL: 0; ADDR: 0; SPACE (bytes): 4 (max); TYPE: REG. 

    assign w_addr_wdata = internal_iob_wdata[0+:((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)];
    wire w_addr_addressed_w;
    assign w_addr_addressed_w =  (wstrb_addr < 4);
    assign w_addr_w_valid = internal_iob_valid & (write_en & w_addr_addressed_w);
    iob_reg_cae #(
      .DATA_W(AXI_ADDR_W),
      .RST_VAL({AXI_ADDR_W{1'd0}})
    ) w_addr_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (w_addr_w_valid),
      .data_i (w_addr_wdata),
      .data_o (w_addr_rdata_o)
    );



//NAME: w_length;
//MODE: W; WIDTH: WLEN_W; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

    assign w_length_wdata = internal_iob_wdata[0+:((WLEN_W > 1) ? WLEN_W : 1)];
    wire w_length_addressed;
    assign w_length_addressed = (internal_iob_addr_stable >= (4)) &&  (internal_iob_addr_stable < 8);
   assign w_length_valid_o = internal_iob_valid & w_length_addressed;
    assign w_length_wstrb = internal_iob_wstrb[0/8+:((WLEN_W/8 > 1) ? WLEN_W/8 : 1)];
   assign w_length_wstrb_o = w_length_wstrb;
    assign w_length_wdata_o = w_length_wdata;


//NAME: w_start;
//MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 8; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

    assign w_start_wdata = internal_iob_wdata[0+:1];
    wire w_start_addressed;
    assign w_start_addressed = (internal_iob_addr_stable >= (8)) &&  (internal_iob_addr_stable < 9);
   assign w_start_valid_o = internal_iob_valid & w_start_addressed;
    assign w_start_wstrb = internal_iob_wstrb[0/8+:((1/8 > 1) ? 1/8 : 1)];
   assign w_start_wstrb_o = w_start_wstrb;
    assign w_start_wdata_o = w_start_wdata;


//NAME: w_burstlen;
//MODE: W; WIDTH: (AXI_LEN_W+1); RST_VAL: 16; ADDR: 10; SPACE (bytes): 2 (max); TYPE: REG. 

    assign w_burstlen_wdata = internal_iob_wdata[16+:(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)];
    wire w_burstlen_addressed_w;
    assign w_burstlen_addressed_w = (wstrb_addr >= (10)) &&  (wstrb_addr < 12);
    assign w_burstlen_w_valid = internal_iob_valid & (write_en & w_burstlen_addressed_w);
    iob_reg_cae #(
      .DATA_W((AXI_LEN_W+1)),
      .RST_VAL({{((AXI_LEN_W+1)-5){1'd0}},5'd16})
    ) w_burstlen_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (w_burstlen_w_valid),
      .data_i (w_burstlen_wdata),
      .data_o (w_burstlen_rdata_o)
    );



//NAME: r_addr;
//MODE: W; WIDTH: AXI_ADDR_W; RST_VAL: 0; ADDR: 12; SPACE (bytes): 4 (max); TYPE: REG. 

    assign r_addr_wdata = internal_iob_wdata[0+:((AXI_ADDR_W > 1) ? AXI_ADDR_W : 1)];
    wire r_addr_addressed_w;
    assign r_addr_addressed_w = (wstrb_addr >= (12)) &&  (wstrb_addr < 16);
    assign r_addr_w_valid = internal_iob_valid & (write_en & r_addr_addressed_w);
    iob_reg_cae #(
      .DATA_W(AXI_ADDR_W),
      .RST_VAL({AXI_ADDR_W{1'd0}})
    ) r_addr_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (r_addr_w_valid),
      .data_i (r_addr_wdata),
      .data_o (r_addr_rdata_o)
    );



//NAME: r_length;
//MODE: W; WIDTH: RLEN_W; RST_VAL: 0; ADDR: 16; SPACE (bytes): 4 (max); TYPE: REG. 

    assign r_length_wdata = internal_iob_wdata[0+:((RLEN_W > 1) ? RLEN_W : 1)];
    wire r_length_addressed_w;
    assign r_length_addressed_w = (wstrb_addr >= (16)) &&  (wstrb_addr < 20);
    assign r_length_w_valid = internal_iob_valid & (write_en & r_length_addressed_w);
    iob_reg_cae #(
      .DATA_W(RLEN_W),
      .RST_VAL({RLEN_W{1'd0}})
    ) r_length_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (r_length_w_valid),
      .data_i (r_length_wdata),
      .data_o (r_length_rdata_o)
    );



//NAME: r_start;
//MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 20; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

    assign r_start_wdata = internal_iob_wdata[0+:1];
    wire r_start_addressed;
    assign r_start_addressed = (internal_iob_addr_stable >= (20)) &&  (internal_iob_addr_stable < 21);
   assign r_start_valid_o = internal_iob_valid & r_start_addressed;
    assign r_start_wstrb = internal_iob_wstrb[0/8+:((1/8 > 1) ? 1/8 : 1)];
   assign r_start_wstrb_o = r_start_wstrb;
    assign r_start_wdata_o = r_start_wdata;


//NAME: r_burstlen;
//MODE: W; WIDTH: (AXI_LEN_W+1); RST_VAL: 16; ADDR: 22; SPACE (bytes): 2 (max); TYPE: REG. 

    assign r_burstlen_wdata = internal_iob_wdata[16+:(((AXI_LEN_W+1) > 1) ? (AXI_LEN_W+1) : 1)];
    wire r_burstlen_addressed_w;
    assign r_burstlen_addressed_w = (wstrb_addr >= (22)) &&  (wstrb_addr < 24);
    assign r_burstlen_w_valid = internal_iob_valid & (write_en & r_burstlen_addressed_w);
    iob_reg_cae #(
      .DATA_W((AXI_LEN_W+1)),
      .RST_VAL({{((AXI_LEN_W+1)-5){1'd0}},5'd16})
    ) r_burstlen_datareg_wr (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .en_i   (r_burstlen_w_valid),
      .data_i (r_burstlen_wdata),
      .data_o (r_burstlen_rdata_o)
    );



//NAME: w_busy;
//MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 0; SPACE (bytes): 1 (max); TYPE: REG. 

    wire w_busy_addressed_r;
    assign w_busy_addressed_r = (internal_iob_addr_stable>>shift_amount <= iob_max(1,0>>shift_amount));
    iob_reg_ca #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) w_busy_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (w_busy_wdata_i),
      .data_o (w_busy_rdata)
    );



//NAME: w_buf_level;
//MODE: R; WIDTH: WLEN_W; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: REG. 

    wire w_buf_level_addressed_r;
    assign w_buf_level_addressed_r = (internal_iob_addr_stable>>shift_amount >= (4>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,7>>shift_amount));
    iob_reg_ca #(
      .DATA_W(WLEN_W),
      .RST_VAL({WLEN_W{1'd0}})
    ) w_buf_level_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (w_buf_level_wdata_i),
      .data_o (w_buf_level_rdata)
    );



//NAME: r_busy;
//MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 8; SPACE (bytes): 1 (max); TYPE: REG. 

    wire r_busy_addressed_r;
    assign r_busy_addressed_r = (internal_iob_addr_stable>>shift_amount >= (8>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,8>>shift_amount));
    iob_reg_ca #(
      .DATA_W(1),
      .RST_VAL(1'd0)
    ) r_busy_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (r_busy_wdata_i),
      .data_o (r_busy_rdata)
    );



//NAME: r_buf_level;
//MODE: R; WIDTH: RLEN_W; RST_VAL: 0; ADDR: 12; SPACE (bytes): 4 (max); TYPE: REG. 

    wire r_buf_level_addressed_r;
    assign r_buf_level_addressed_r = (internal_iob_addr_stable>>shift_amount >= (12>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,15>>shift_amount));
    iob_reg_ca #(
      .DATA_W(RLEN_W),
      .RST_VAL({RLEN_W{1'd0}})
    ) r_buf_level_datareg_rd (
      .clk_i  (clk_i),
      .cke_i  (cke_i),
      .arst_i (arst_i),
      .data_i (r_buf_level_wdata_i),
      .data_o (r_buf_level_rdata)
    );



//NAME: version;
//MODE: R; WIDTH: 16; RST_VAL: 0081; ADDR: 16; SPACE (bytes): 2 (max); TYPE: REG. 

    wire version_addressed_r;
    assign version_addressed_r = (internal_iob_addr_stable>>shift_amount >= (16>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(1,17>>shift_amount));


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
        if(w_busy_addressed_r) begin
            iob_rdata_nxt[0+:8] = {{7{1'b0}}, w_busy_rdata}|8'd0;
        end

        if(w_buf_level_addressed_r) begin
            iob_rdata_nxt[0+:32] = w_buf_level_rdata|32'd0;
        end

        if(r_busy_addressed_r) begin
            iob_rdata_nxt[0+:8] = {{7{1'b0}}, r_busy_rdata}|8'd0;
        end

        if(r_buf_level_addressed_r) begin
            iob_rdata_nxt[0+:32] = r_buf_level_rdata|32'd0;
        end

        if(version_addressed_r) begin
            iob_rdata_nxt[0+:16] = 16'h0081|16'd0;
        end

        if(write_en && (wstrb_addr >= (4)) &&  (wstrb_addr < 8)) begin
            ready_int = w_length_ready_i;
            if (internal_iob_valid & (|internal_iob_wstrb)) begin
                auto_addressed_nxt = 1'b0;
            end
        end

        if(write_en && (wstrb_addr >= (8)) &&  (wstrb_addr < 9)) begin
            ready_int = w_start_ready_i;
            if (internal_iob_valid & (|internal_iob_wstrb)) begin
                auto_addressed_nxt = 1'b0;
            end
        end

        if(write_en && (wstrb_addr >= (20)) &&  (wstrb_addr < 21)) begin
            ready_int = r_start_ready_i;
            if (internal_iob_valid & (|internal_iob_wstrb)) begin
                auto_addressed_nxt = 1'b0;
            end
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

                if (iob_rvalid_out) begin // Transfer done
                    state_nxt = WAIT_REQ;
                end else begin
                    iob_rvalid_nxt = 1'b1;

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

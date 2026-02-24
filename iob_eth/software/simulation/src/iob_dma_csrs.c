/*
 * SPDX-FileCopyrightText: 2026 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#include "iob_dma_csrs.h"

// Base Address
static uint32_t base;
void iob_dma_csrs_init_baseaddr(uint32_t addr) { base = addr; }

// Core Setters and Getters
void iob_dma_csrs_set_w_addr(uint32_t value) {
  iob_write(base + IOB_DMA_CSRS_W_ADDR_ADDR, IOB_DMA_CSRS_W_ADDR_W, value);
}

void iob_dma_csrs_set_w_length(uint32_t value) {
  iob_write(base + IOB_DMA_CSRS_W_LENGTH_ADDR, IOB_DMA_CSRS_W_LENGTH_W, value);
}

uint8_t iob_dma_csrs_get_w_busy() {
  return iob_read(base + IOB_DMA_CSRS_W_BUSY_ADDR, IOB_DMA_CSRS_W_BUSY_W);
}

void iob_dma_csrs_set_w_start(uint8_t value) {
  iob_write(base + IOB_DMA_CSRS_W_START_ADDR, IOB_DMA_CSRS_W_START_W, value);
}

void iob_dma_csrs_set_w_burstlen(uint16_t value) {
  iob_write(base + IOB_DMA_CSRS_W_BURSTLEN_ADDR, IOB_DMA_CSRS_W_BURSTLEN_W,
            value);
}

uint32_t iob_dma_csrs_get_w_buf_level() {
  return iob_read(base + IOB_DMA_CSRS_W_BUF_LEVEL_ADDR,
                  IOB_DMA_CSRS_W_BUF_LEVEL_W);
}

void iob_dma_csrs_set_r_addr(uint32_t value) {
  iob_write(base + IOB_DMA_CSRS_R_ADDR_ADDR, IOB_DMA_CSRS_R_ADDR_W, value);
}

void iob_dma_csrs_set_r_length(uint32_t value) {
  iob_write(base + IOB_DMA_CSRS_R_LENGTH_ADDR, IOB_DMA_CSRS_R_LENGTH_W, value);
}

void iob_dma_csrs_set_r_start(uint8_t value) {
  iob_write(base + IOB_DMA_CSRS_R_START_ADDR, IOB_DMA_CSRS_R_START_W, value);
}

uint8_t iob_dma_csrs_get_r_busy() {
  return iob_read(base + IOB_DMA_CSRS_R_BUSY_ADDR, IOB_DMA_CSRS_R_BUSY_W);
}

void iob_dma_csrs_set_r_burstlen(uint16_t value) {
  iob_write(base + IOB_DMA_CSRS_R_BURSTLEN_ADDR, IOB_DMA_CSRS_R_BURSTLEN_W,
            value);
}

uint32_t iob_dma_csrs_get_r_buf_level() {
  return iob_read(base + IOB_DMA_CSRS_R_BUF_LEVEL_ADDR,
                  IOB_DMA_CSRS_R_BUF_LEVEL_W);
}

uint16_t iob_dma_csrs_get_version() {
  return iob_read(base + IOB_DMA_CSRS_VERSION_ADDR, IOB_DMA_CSRS_VERSION_W);
}

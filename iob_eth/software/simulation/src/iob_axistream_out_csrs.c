/*
 * SPDX-FileCopyrightText: 2026 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#include "iob_axistream_out_csrs.h"

// Base Address
static uint32_t base;
void iob_axistream_out_csrs_init_baseaddr(uint32_t addr) { base = addr; }

// Core Setters and Getters
void iob_axistream_out_csrs_set_soft_reset(uint8_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_SOFT_RESET_ADDR,
            IOB_AXISTREAM_OUT_CSRS_SOFT_RESET_W, value);
}

void iob_axistream_out_csrs_set_enable(uint8_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_ENABLE_ADDR,
            IOB_AXISTREAM_OUT_CSRS_ENABLE_W, value);
}

void iob_axistream_out_csrs_set_data(uint32_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_DATA_ADDR,
            IOB_AXISTREAM_OUT_CSRS_DATA_W, value);
}

void iob_axistream_out_csrs_set_mode(uint8_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_MODE_ADDR,
            IOB_AXISTREAM_OUT_CSRS_MODE_W, value);
}

void iob_axistream_out_csrs_set_nwords(uint32_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_NWORDS_ADDR,
            IOB_AXISTREAM_OUT_CSRS_NWORDS_W, value);
}

uint8_t iob_axistream_out_csrs_get_fifo_full() {
  return iob_read(base + IOB_AXISTREAM_OUT_CSRS_FIFO_FULL_ADDR,
                  IOB_AXISTREAM_OUT_CSRS_FIFO_FULL_W);
}

uint8_t iob_axistream_out_csrs_get_fifo_empty() {
  return iob_read(base + IOB_AXISTREAM_OUT_CSRS_FIFO_EMPTY_ADDR,
                  IOB_AXISTREAM_OUT_CSRS_FIFO_EMPTY_W);
}

void iob_axistream_out_csrs_set_fifo_threshold(uint32_t value) {
  iob_write(base + IOB_AXISTREAM_OUT_CSRS_FIFO_THRESHOLD_ADDR,
            IOB_AXISTREAM_OUT_CSRS_FIFO_THRESHOLD_W, value);
}

uint32_t iob_axistream_out_csrs_get_fifo_level() {
  return iob_read(base + IOB_AXISTREAM_OUT_CSRS_FIFO_LEVEL_ADDR,
                  IOB_AXISTREAM_OUT_CSRS_FIFO_LEVEL_W);
}

uint16_t iob_axistream_out_csrs_get_version() {
  return iob_read(base + IOB_AXISTREAM_OUT_CSRS_VERSION_ADDR,
                  IOB_AXISTREAM_OUT_CSRS_VERSION_W);
}

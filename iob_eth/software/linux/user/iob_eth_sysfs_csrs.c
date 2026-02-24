/*
 * SPDX-FileCopyrightText: 2025 IObundle
 *
 * SPDX-License-Identifier: MIT
 */

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "iob_eth_driver_files.h"

#include "iob_eth_csrs.h"

int sysfs_read_file(const char *filename, uint32_t *read_value) {
  // Open file for read
  FILE *file = fopen(filename, "r");
  if (file == NULL) {
    perror("[User] Failed to open the file");
    return -1;
  }

  // Read uint32_t value from file in ASCII
  ssize_t ret = fscanf(file, "%u", read_value);
  if (ret == -1) {
    perror("[User] Failed to read from file");
    fclose(file);
    return -1;
  }

  fclose(file);

  return ret;
}

int sysfs_write_file(const char *filename, uint32_t write_value) {
  // Open file for write
  FILE *file = fopen(filename, "w");
  if (file == NULL) {
    perror("[User] Failed to open the file");
    return -1;
  }

  // Write uint32_t value to file in ASCII
  ssize_t ret = fprintf(file, "%u", write_value);
  if (ret == -1) {
    perror("[User] Failed to write to file");
    fclose(file);
    return -1;
  }

  fclose(file);

  return ret;
}

// Empty init function - base address is obtained from device tree
void iob_eth_csrs_init_baseaddr(uint32_t addr) {}

// Core Setters and Getters
void iob_eth_csrs_set_moder(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MODER, value);
}
uint32_t iob_eth_csrs_get_moder() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MODER, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_source(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_INT_SOURCE, value);
}
uint32_t iob_eth_csrs_get_int_source() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_INT_SOURCE, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_mask(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_INT_MASK, value);
}
uint32_t iob_eth_csrs_get_int_mask() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_INT_MASK, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgt(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_IPGT, value);
}
uint32_t iob_eth_csrs_get_ipgt() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_IPGT, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr1(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_IPGR1, value);
}
uint32_t iob_eth_csrs_get_ipgr1() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_IPGR1, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr2(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_IPGR2, value);
}
uint32_t iob_eth_csrs_get_ipgr2() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_IPGR2, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_packetlen(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_PACKETLEN, value);
}
uint32_t iob_eth_csrs_get_packetlen() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_PACKETLEN, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_collconf(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_COLLCONF, value);
}
uint32_t iob_eth_csrs_get_collconf() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_COLLCONF, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_tx_bd_num(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_TX_BD_NUM, value);
}
uint32_t iob_eth_csrs_get_tx_bd_num() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_TX_BD_NUM, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ctrlmoder(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_CTRLMODER, value);
}
uint32_t iob_eth_csrs_get_ctrlmoder() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_CTRLMODER, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miimoder(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIIMODER, value);
}
uint32_t iob_eth_csrs_get_miimoder() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIIMODER, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miicommand(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIICOMMAND, value);
}
uint32_t iob_eth_csrs_get_miicommand() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIICOMMAND, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miiaddress(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIIADDRESS, value);
}
uint32_t iob_eth_csrs_get_miiaddress() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIIADDRESS, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miitx_data(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIITX_DATA, value);
}
uint32_t iob_eth_csrs_get_miitx_data() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIITX_DATA, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miirx_data(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIIRX_DATA, value);
}
uint32_t iob_eth_csrs_get_miirx_data() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIIRX_DATA, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miistatus(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MIISTATUS, value);
}
uint32_t iob_eth_csrs_get_miistatus() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MIISTATUS, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr0(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MAC_ADDR0, value);
}
uint32_t iob_eth_csrs_get_mac_addr0() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MAC_ADDR0, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr1(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_MAC_ADDR1, value);
}
uint32_t iob_eth_csrs_get_mac_addr1() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_MAC_ADDR1, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash0_adr(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_ETH_HASH0_ADR, value);
}
uint32_t iob_eth_csrs_get_eth_hash0_adr() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_ETH_HASH0_ADR, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash1_adr(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_ETH_HASH1_ADR, value);
}
uint32_t iob_eth_csrs_get_eth_hash1_adr() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_ETH_HASH1_ADR, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_txctrl(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_ETH_TXCTRL, value);
}
uint32_t iob_eth_csrs_get_eth_txctrl() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_ETH_TXCTRL, &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_bd_cnt() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_TX_BD_CNT, &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_bd_cnt() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_RX_BD_CNT, &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_word_cnt() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_TX_WORD_CNT, &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_word_cnt() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_RX_WORD_CNT, &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_nbytes() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_RX_NBYTES, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_frame_word(uint8_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_FRAME_WORD, value);
}
uint8_t iob_eth_csrs_get_frame_word() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_FRAME_WORD, &return_value);
  return (uint8_t)return_value;
}
uint8_t iob_eth_csrs_get_phy_rst_val() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_PHY_RST_VAL, &return_value);
  return (uint8_t)return_value;
}
void iob_eth_csrs_set_bd(uint32_t value) {
  sysfs_write_file(IOB_ETH_SYSFILE_BD, value);
}
uint32_t iob_eth_csrs_get_bd() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_BD, &return_value);
  return (uint32_t)return_value;
}
uint16_t iob_eth_csrs_get_version() {
  uint32_t return_value = 0;
  sysfs_read_file(IOB_ETH_SYSFILE_VERSION, &return_value);
  return (uint16_t)return_value;
}

/*
 * SPDX-FileCopyrightText: 2026 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */


#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "iob_eth_driver_files.h"

#include "iob_eth_csrs.h"

uint32_t read_reg(int fd, uint32_t addr, uint32_t nbits, uint32_t *value) {
  ssize_t ret = -1;

  if (fd == 0) {
    perror("[User] Invalid file descriptor");
    return -1;
  }

  // Point to register address
  if (lseek(fd, addr, SEEK_SET) == -1) {
    perror("[User] Failed to seek to register");
    return -1;
  }

  // Read value from device
  switch (nbits) {
  case 8:
    uint8_t value8 = 0;
    ret = read(fd, &value8, sizeof(value8));
    if (ret == -1) {
      perror("[User] Failed to read from device");
    }
    *value = (uint32_t)value8;
    break;
  case 16:
    uint16_t value16 = 0;
    ret = read(fd, &value16, sizeof(value16));
    if (ret == -1) {
      perror("[User] Failed to read from device");
    }
    *value = (uint32_t)value16;
    break;
  case 32:
    uint32_t value32 = 0;
    ret = read(fd, &value32, sizeof(value32));
    if (ret == -1) {
      perror("[User] Failed to read from device");
    }
    *value = (uint32_t)value32;
    break;
  default:
    // unsupported nbits
    ret = -1;
    *value = 0;
    perror("[User] Unsupported nbits");
    break;
  }

  return ret;
}

uint32_t write_reg(int fd, uint32_t addr, uint32_t nbits, uint32_t value) {
  ssize_t ret = -1;

  if (fd == 0) {
    perror("[User] Invalid file descriptor");
    return -1;
  }

  // Point to register address
  if (lseek(fd, addr, SEEK_SET) == -1) {
    perror("[User] Failed to seek to register");
    return -1;
  }

  // Write value to device
  switch (nbits) {
  case 8:
    uint8_t value8 = (uint8_t)value;
    ret = write(fd, &value8, sizeof(value8));
    if (ret == -1) {
      perror("[User] Failed to write to device");
    }
    break;
  case 16:
    uint16_t value16 = (uint16_t)value;
    ret = write(fd, &value16, sizeof(value16));
    if (ret == -1) {
      perror("[User] Failed to write to device");
    }
    break;
  case 32:
    ret = write(fd, &value, sizeof(value));
    if (ret == -1) {
      perror("[User] Failed to write to device");
    }
    break;
  default:
    break;
  }

  return ret;
}

int fd = 0;

void iob_eth_csrs_init_baseaddr(uint32_t addr) {
  fd = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd == -1) {
    perror("[User] Failed to open the device file");
  }
}

// Core Setters and Getters
void iob_eth_csrs_set_moder(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MODER_ADDR, IOB_ETH_CSRS_MODER_W, value);
}
uint32_t iob_eth_csrs_get_moder() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MODER_ADDR, IOB_ETH_CSRS_MODER_W, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_source(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_INT_SOURCE_ADDR, IOB_ETH_CSRS_INT_SOURCE_W, value);
}
uint32_t iob_eth_csrs_get_int_source() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_INT_SOURCE_ADDR, IOB_ETH_CSRS_INT_SOURCE_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_mask(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_INT_MASK_ADDR, IOB_ETH_CSRS_INT_MASK_W, value);
}
uint32_t iob_eth_csrs_get_int_mask() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_INT_MASK_ADDR, IOB_ETH_CSRS_INT_MASK_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgt(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_IPGT_ADDR, IOB_ETH_CSRS_IPGT_W, value);
}
uint32_t iob_eth_csrs_get_ipgt() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_IPGT_ADDR, IOB_ETH_CSRS_IPGT_W, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr1(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_IPGR1_ADDR, IOB_ETH_CSRS_IPGR1_W, value);
}
uint32_t iob_eth_csrs_get_ipgr1() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_IPGR1_ADDR, IOB_ETH_CSRS_IPGR1_W, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr2(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_IPGR2_ADDR, IOB_ETH_CSRS_IPGR2_W, value);
}
uint32_t iob_eth_csrs_get_ipgr2() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_IPGR2_ADDR, IOB_ETH_CSRS_IPGR2_W, &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_packetlen(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_PACKETLEN_ADDR, IOB_ETH_CSRS_PACKETLEN_W, value);
}
uint32_t iob_eth_csrs_get_packetlen() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_PACKETLEN_ADDR, IOB_ETH_CSRS_PACKETLEN_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_collconf(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_COLLCONF_ADDR, IOB_ETH_CSRS_COLLCONF_W, value);
}
uint32_t iob_eth_csrs_get_collconf() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_COLLCONF_ADDR, IOB_ETH_CSRS_COLLCONF_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_tx_bd_num(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_TX_BD_NUM_ADDR, IOB_ETH_CSRS_TX_BD_NUM_W, value);
}
uint32_t iob_eth_csrs_get_tx_bd_num() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_TX_BD_NUM_ADDR, IOB_ETH_CSRS_TX_BD_NUM_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ctrlmoder(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_CTRLMODER_ADDR, IOB_ETH_CSRS_CTRLMODER_W, value);
}
uint32_t iob_eth_csrs_get_ctrlmoder() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_CTRLMODER_ADDR, IOB_ETH_CSRS_CTRLMODER_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miimoder(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIIMODER_ADDR, IOB_ETH_CSRS_MIIMODER_W, value);
}
uint32_t iob_eth_csrs_get_miimoder() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIIMODER_ADDR, IOB_ETH_CSRS_MIIMODER_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miicommand(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIICOMMAND_ADDR, IOB_ETH_CSRS_MIICOMMAND_W, value);
}
uint32_t iob_eth_csrs_get_miicommand() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIICOMMAND_ADDR, IOB_ETH_CSRS_MIICOMMAND_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miiaddress(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIIADDRESS_ADDR, IOB_ETH_CSRS_MIIADDRESS_W, value);
}
uint32_t iob_eth_csrs_get_miiaddress() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIIADDRESS_ADDR, IOB_ETH_CSRS_MIIADDRESS_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miitx_data(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIITX_DATA_ADDR, IOB_ETH_CSRS_MIITX_DATA_W, value);
}
uint32_t iob_eth_csrs_get_miitx_data() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIITX_DATA_ADDR, IOB_ETH_CSRS_MIITX_DATA_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miirx_data(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIIRX_DATA_ADDR, IOB_ETH_CSRS_MIIRX_DATA_W, value);
}
uint32_t iob_eth_csrs_get_miirx_data() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIIRX_DATA_ADDR, IOB_ETH_CSRS_MIIRX_DATA_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miistatus(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MIISTATUS_ADDR, IOB_ETH_CSRS_MIISTATUS_W, value);
}
uint32_t iob_eth_csrs_get_miistatus() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MIISTATUS_ADDR, IOB_ETH_CSRS_MIISTATUS_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr0(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MAC_ADDR0_ADDR, IOB_ETH_CSRS_MAC_ADDR0_W, value);
}
uint32_t iob_eth_csrs_get_mac_addr0() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MAC_ADDR0_ADDR, IOB_ETH_CSRS_MAC_ADDR0_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr1(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_MAC_ADDR1_ADDR, IOB_ETH_CSRS_MAC_ADDR1_W, value);
}
uint32_t iob_eth_csrs_get_mac_addr1() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_MAC_ADDR1_ADDR, IOB_ETH_CSRS_MAC_ADDR1_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash0_adr(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR, IOB_ETH_CSRS_ETH_HASH0_ADR_W,
            value);
}
uint32_t iob_eth_csrs_get_eth_hash0_adr() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR, IOB_ETH_CSRS_ETH_HASH0_ADR_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash1_adr(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR, IOB_ETH_CSRS_ETH_HASH1_ADR_W,
            value);
}
uint32_t iob_eth_csrs_get_eth_hash1_adr() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR, IOB_ETH_CSRS_ETH_HASH1_ADR_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_txctrl(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_ETH_TXCTRL_ADDR, IOB_ETH_CSRS_ETH_TXCTRL_W, value);
}
uint32_t iob_eth_csrs_get_eth_txctrl() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_ETH_TXCTRL_ADDR, IOB_ETH_CSRS_ETH_TXCTRL_W,
           &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_bd_cnt() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_TX_BD_CNT_ADDR, IOB_ETH_CSRS_TX_BD_CNT_W,
           &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_bd_cnt() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_RX_BD_CNT_ADDR, IOB_ETH_CSRS_RX_BD_CNT_W,
           &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_word_cnt() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_TX_WORD_CNT_ADDR, IOB_ETH_CSRS_TX_WORD_CNT_W,
           &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_word_cnt() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_RX_WORD_CNT_ADDR, IOB_ETH_CSRS_RX_WORD_CNT_W,
           &return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_nbytes() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_RX_NBYTES_ADDR, IOB_ETH_CSRS_RX_NBYTES_W,
           &return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_frame_word(uint8_t value) {
  write_reg(fd, IOB_ETH_CSRS_FRAME_WORD_ADDR, IOB_ETH_CSRS_FRAME_WORD_W, value);
}
uint8_t iob_eth_csrs_get_frame_word() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_FRAME_WORD_ADDR, IOB_ETH_CSRS_FRAME_WORD_W,
           &return_value);
  return (uint8_t)return_value;
}
uint8_t iob_eth_csrs_get_phy_rst_val() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_PHY_RST_VAL_ADDR, IOB_ETH_CSRS_PHY_RST_VAL_W,
           &return_value);
  return (uint8_t)return_value;
}
void iob_eth_csrs_set_bd(uint32_t value) {
  write_reg(fd, IOB_ETH_CSRS_BD_ADDR, IOB_ETH_CSRS_BD_W, value);
}
uint32_t iob_eth_csrs_get_bd() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_BD_ADDR, IOB_ETH_CSRS_BD_W, &return_value);
  return (uint32_t)return_value;
}
uint16_t iob_eth_csrs_get_version() {
  uint32_t return_value = 0;
  read_reg(fd, IOB_ETH_CSRS_VERSION_ADDR, IOB_ETH_CSRS_VERSION_W,
           &return_value);
  return (uint16_t)return_value;
}

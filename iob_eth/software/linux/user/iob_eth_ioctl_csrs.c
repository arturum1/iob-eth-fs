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
#include <sys/ioctl.h>
#include <unistd.h>

#include "iob_eth_driver_files.h"

#include "iob_eth_csrs.h"

#define WR_MODER _IOW('$', 0, int32_t *)
#define RD_MODER _IOR('$', 1, int32_t *)
#define WR_INT_SOURCE _IOW('$', 2, int32_t *)
#define RD_INT_SOURCE _IOR('$', 3, int32_t *)
#define WR_INT_MASK _IOW('$', 4, int32_t *)
#define RD_INT_MASK _IOR('$', 5, int32_t *)
#define WR_IPGT _IOW('$', 6, int32_t *)
#define RD_IPGT _IOR('$', 7, int32_t *)
#define WR_IPGR1 _IOW('$', 8, int32_t *)
#define RD_IPGR1 _IOR('$', 9, int32_t *)
#define WR_IPGR2 _IOW('$', 10, int32_t *)
#define RD_IPGR2 _IOR('$', 11, int32_t *)
#define WR_PACKETLEN _IOW('$', 12, int32_t *)
#define RD_PACKETLEN _IOR('$', 13, int32_t *)
#define WR_COLLCONF _IOW('$', 14, int32_t *)
#define RD_COLLCONF _IOR('$', 15, int32_t *)
#define WR_TX_BD_NUM _IOW('$', 16, int32_t *)
#define RD_TX_BD_NUM _IOR('$', 17, int32_t *)
#define WR_CTRLMODER _IOW('$', 18, int32_t *)
#define RD_CTRLMODER _IOR('$', 19, int32_t *)
#define WR_MIIMODER _IOW('$', 20, int32_t *)
#define RD_MIIMODER _IOR('$', 21, int32_t *)
#define WR_MIICOMMAND _IOW('$', 22, int32_t *)
#define RD_MIICOMMAND _IOR('$', 23, int32_t *)
#define WR_MIIADDRESS _IOW('$', 24, int32_t *)
#define RD_MIIADDRESS _IOR('$', 25, int32_t *)
#define WR_MIITX_DATA _IOW('$', 26, int32_t *)
#define RD_MIITX_DATA _IOR('$', 27, int32_t *)
#define WR_MIIRX_DATA _IOW('$', 28, int32_t *)
#define RD_MIIRX_DATA _IOR('$', 29, int32_t *)
#define WR_MIISTATUS _IOW('$', 30, int32_t *)
#define RD_MIISTATUS _IOR('$', 31, int32_t *)
#define WR_MAC_ADDR0 _IOW('$', 32, int32_t *)
#define RD_MAC_ADDR0 _IOR('$', 33, int32_t *)
#define WR_MAC_ADDR1 _IOW('$', 34, int32_t *)
#define RD_MAC_ADDR1 _IOR('$', 35, int32_t *)
#define WR_ETH_HASH0_ADR _IOW('$', 36, int32_t *)
#define RD_ETH_HASH0_ADR _IOR('$', 37, int32_t *)
#define WR_ETH_HASH1_ADR _IOW('$', 38, int32_t *)
#define RD_ETH_HASH1_ADR _IOR('$', 39, int32_t *)
#define WR_ETH_TXCTRL _IOW('$', 40, int32_t *)
#define RD_ETH_TXCTRL _IOR('$', 41, int32_t *)
#define RD_TX_BD_CNT _IOR('$', 42, int32_t *)
#define RD_RX_BD_CNT _IOR('$', 43, int32_t *)
#define RD_TX_WORD_CNT _IOR('$', 44, int32_t *)
#define RD_RX_WORD_CNT _IOR('$', 45, int32_t *)
#define RD_RX_NBYTES _IOR('$', 46, int32_t *)
#define WR_FRAME_WORD _IOW('$', 47, int32_t *)
#define RD_FRAME_WORD _IOR('$', 48, int32_t *)
#define RD_PHY_RST_VAL _IOR('$', 49, int32_t *)
#define WR_BD _IOW('$', 50, int32_t *)
#define RD_BD _IOR('$', 51, int32_t *)
#define RD_VERSION _IOR('$', 52, int32_t *)
int fd = 0;

void iob_eth_csrs_init_baseaddr(uint32_t addr) {
  fd = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd == -1) {
    perror("[User] Failed to open the device file");
  }
}

// Core Setters and Getters
void iob_eth_csrs_set_moder(uint32_t value) {
  ioctl(fd, WR_MODER, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_moder() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MODER, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_source(uint32_t value) {
  ioctl(fd, WR_INT_SOURCE, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_int_source() {
  uint32_t return_value = 0;
  ioctl(fd, RD_INT_SOURCE, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_int_mask(uint32_t value) {
  ioctl(fd, WR_INT_MASK, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_int_mask() {
  uint32_t return_value = 0;
  ioctl(fd, RD_INT_MASK, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgt(uint32_t value) {
  ioctl(fd, WR_IPGT, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_ipgt() {
  uint32_t return_value = 0;
  ioctl(fd, RD_IPGT, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr1(uint32_t value) {
  ioctl(fd, WR_IPGR1, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_ipgr1() {
  uint32_t return_value = 0;
  ioctl(fd, RD_IPGR1, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ipgr2(uint32_t value) {
  ioctl(fd, WR_IPGR2, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_ipgr2() {
  uint32_t return_value = 0;
  ioctl(fd, RD_IPGR2, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_packetlen(uint32_t value) {
  ioctl(fd, WR_PACKETLEN, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_packetlen() {
  uint32_t return_value = 0;
  ioctl(fd, RD_PACKETLEN, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_collconf(uint32_t value) {
  ioctl(fd, WR_COLLCONF, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_collconf() {
  uint32_t return_value = 0;
  ioctl(fd, RD_COLLCONF, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_tx_bd_num(uint32_t value) {
  ioctl(fd, WR_TX_BD_NUM, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_tx_bd_num() {
  uint32_t return_value = 0;
  ioctl(fd, RD_TX_BD_NUM, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_ctrlmoder(uint32_t value) {
  ioctl(fd, WR_CTRLMODER, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_ctrlmoder() {
  uint32_t return_value = 0;
  ioctl(fd, RD_CTRLMODER, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miimoder(uint32_t value) {
  ioctl(fd, WR_MIIMODER, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miimoder() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIIMODER, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miicommand(uint32_t value) {
  ioctl(fd, WR_MIICOMMAND, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miicommand() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIICOMMAND, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miiaddress(uint32_t value) {
  ioctl(fd, WR_MIIADDRESS, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miiaddress() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIIADDRESS, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miitx_data(uint32_t value) {
  ioctl(fd, WR_MIITX_DATA, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miitx_data() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIITX_DATA, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miirx_data(uint32_t value) {
  ioctl(fd, WR_MIIRX_DATA, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miirx_data() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIIRX_DATA, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_miistatus(uint32_t value) {
  ioctl(fd, WR_MIISTATUS, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_miistatus() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MIISTATUS, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr0(uint32_t value) {
  ioctl(fd, WR_MAC_ADDR0, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_mac_addr0() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MAC_ADDR0, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_mac_addr1(uint32_t value) {
  ioctl(fd, WR_MAC_ADDR1, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_mac_addr1() {
  uint32_t return_value = 0;
  ioctl(fd, RD_MAC_ADDR1, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash0_adr(uint32_t value) {
  ioctl(fd, WR_ETH_HASH0_ADR, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_eth_hash0_adr() {
  uint32_t return_value = 0;
  ioctl(fd, RD_ETH_HASH0_ADR, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_hash1_adr(uint32_t value) {
  ioctl(fd, WR_ETH_HASH1_ADR, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_eth_hash1_adr() {
  uint32_t return_value = 0;
  ioctl(fd, RD_ETH_HASH1_ADR, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_eth_txctrl(uint32_t value) {
  ioctl(fd, WR_ETH_TXCTRL, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_eth_txctrl() {
  uint32_t return_value = 0;
  ioctl(fd, RD_ETH_TXCTRL, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_bd_cnt() {
  uint32_t return_value = 0;
  ioctl(fd, RD_TX_BD_CNT, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_bd_cnt() {
  uint32_t return_value = 0;
  ioctl(fd, RD_RX_BD_CNT, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_tx_word_cnt() {
  uint32_t return_value = 0;
  ioctl(fd, RD_TX_WORD_CNT, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_word_cnt() {
  uint32_t return_value = 0;
  ioctl(fd, RD_RX_WORD_CNT, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint32_t iob_eth_csrs_get_rx_nbytes() {
  uint32_t return_value = 0;
  ioctl(fd, RD_RX_NBYTES, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
void iob_eth_csrs_set_frame_word(uint8_t value) {
  ioctl(fd, WR_FRAME_WORD, (int32_t *)&value);
}
uint8_t iob_eth_csrs_get_frame_word() {
  uint32_t return_value = 0;
  ioctl(fd, RD_FRAME_WORD, (int32_t *)&return_value);
  return (uint8_t)return_value;
}
uint8_t iob_eth_csrs_get_phy_rst_val() {
  uint32_t return_value = 0;
  ioctl(fd, RD_PHY_RST_VAL, (int32_t *)&return_value);
  return (uint8_t)return_value;
}
void iob_eth_csrs_set_bd(uint32_t value) {
  ioctl(fd, WR_BD, (int32_t *)&value);
}
uint32_t iob_eth_csrs_get_bd() {
  uint32_t return_value = 0;
  ioctl(fd, RD_BD, (int32_t *)&return_value);
  return (uint32_t)return_value;
}
uint16_t iob_eth_csrs_get_version() {
  uint32_t return_value = 0;
  ioctl(fd, RD_VERSION, (int32_t *)&return_value);
  return (uint16_t)return_value;
}

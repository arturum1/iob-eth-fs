/*
 * SPDX-FileCopyrightText: 2025 IObundle
 *
 * SPDX-License-Identifier: MIT
 */

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include "iob_eth.h"
#include "iob_eth_csrs.h"
#include "iob_eth_driver_files.h"

//
// Test macros
//
#define TEST_PASSED 0
#define TEST_FAILED 1

#define TEST_WRITE_VALUE 0x12345678

#define RUN_TEST(test_name)                                                    \
  printf("Running test: %s...\n", #test_name);                                 \
  if (test_name() != TEST_PASSED) {                                            \
    printf("Test failed: %s\n", #test_name);                                   \
    return TEST_FAILED;                                                        \
  }                                                                            \
  printf("Test passed: %s\n", #test_name);

//
// Functionality tests
//

int test_functionality_moder_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_moder(value);

  uint32_t read_value = iob_eth_csrs_get_moder();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_moder_read() {
  iob_eth_csrs_get_moder();
  return TEST_PASSED;
}

int test_functionality_int_source_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_int_source(value);

  uint32_t read_value = iob_eth_csrs_get_int_source();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_int_source_read() {
  iob_eth_csrs_get_int_source();
  return TEST_PASSED;
}

int test_functionality_int_mask_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_int_mask(value);

  uint32_t read_value = iob_eth_csrs_get_int_mask();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_int_mask_read() {
  iob_eth_csrs_get_int_mask();
  return TEST_PASSED;
}

int test_functionality_ipgt_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_ipgt(value);

  uint32_t read_value = iob_eth_csrs_get_ipgt();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_ipgt_read() {
  iob_eth_csrs_get_ipgt();
  return TEST_PASSED;
}

int test_functionality_ipgr1_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_ipgr1(value);

  uint32_t read_value = iob_eth_csrs_get_ipgr1();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_ipgr1_read() {
  iob_eth_csrs_get_ipgr1();
  return TEST_PASSED;
}

int test_functionality_ipgr2_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_ipgr2(value);

  uint32_t read_value = iob_eth_csrs_get_ipgr2();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_ipgr2_read() {
  iob_eth_csrs_get_ipgr2();
  return TEST_PASSED;
}

int test_functionality_packetlen_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_packetlen(value);

  uint32_t read_value = iob_eth_csrs_get_packetlen();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_packetlen_read() {
  iob_eth_csrs_get_packetlen();
  return TEST_PASSED;
}

int test_functionality_collconf_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_collconf(value);

  uint32_t read_value = iob_eth_csrs_get_collconf();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_collconf_read() {
  iob_eth_csrs_get_collconf();
  return TEST_PASSED;
}

int test_functionality_tx_bd_num_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_tx_bd_num(value);

  uint32_t read_value = iob_eth_csrs_get_tx_bd_num();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_tx_bd_num_read() {
  iob_eth_csrs_get_tx_bd_num();
  return TEST_PASSED;
}

int test_functionality_ctrlmoder_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_ctrlmoder(value);

  uint32_t read_value = iob_eth_csrs_get_ctrlmoder();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_ctrlmoder_read() {
  iob_eth_csrs_get_ctrlmoder();
  return TEST_PASSED;
}

int test_functionality_miimoder_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miimoder(value);

  uint32_t read_value = iob_eth_csrs_get_miimoder();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miimoder_read() {
  iob_eth_csrs_get_miimoder();
  return TEST_PASSED;
}

int test_functionality_miicommand_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miicommand(value);

  uint32_t read_value = iob_eth_csrs_get_miicommand();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miicommand_read() {
  iob_eth_csrs_get_miicommand();
  return TEST_PASSED;
}

int test_functionality_miiaddress_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miiaddress(value);

  uint32_t read_value = iob_eth_csrs_get_miiaddress();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miiaddress_read() {
  iob_eth_csrs_get_miiaddress();
  return TEST_PASSED;
}

int test_functionality_miitx_data_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miitx_data(value);

  uint32_t read_value = iob_eth_csrs_get_miitx_data();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miitx_data_read() {
  iob_eth_csrs_get_miitx_data();
  return TEST_PASSED;
}

int test_functionality_miirx_data_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miirx_data(value);

  uint32_t read_value = iob_eth_csrs_get_miirx_data();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miirx_data_read() {
  iob_eth_csrs_get_miirx_data();
  return TEST_PASSED;
}

int test_functionality_miistatus_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_miistatus(value);

  uint32_t read_value = iob_eth_csrs_get_miistatus();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_miistatus_read() {
  iob_eth_csrs_get_miistatus();
  return TEST_PASSED;
}

int test_functionality_mac_addr0_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_mac_addr0(value);

  uint32_t read_value = iob_eth_csrs_get_mac_addr0();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_mac_addr0_read() {
  iob_eth_csrs_get_mac_addr0();
  return TEST_PASSED;
}

int test_functionality_mac_addr1_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_mac_addr1(value);

  uint32_t read_value = iob_eth_csrs_get_mac_addr1();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_mac_addr1_read() {
  iob_eth_csrs_get_mac_addr1();
  return TEST_PASSED;
}

int test_functionality_eth_hash0_adr_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_eth_hash0_adr(value);

  uint32_t read_value = iob_eth_csrs_get_eth_hash0_adr();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_eth_hash0_adr_read() {
  iob_eth_csrs_get_eth_hash0_adr();
  return TEST_PASSED;
}

int test_functionality_eth_hash1_adr_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_eth_hash1_adr(value);

  uint32_t read_value = iob_eth_csrs_get_eth_hash1_adr();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_eth_hash1_adr_read() {
  iob_eth_csrs_get_eth_hash1_adr();
  return TEST_PASSED;
}

int test_functionality_eth_txctrl_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_eth_txctrl(value);

  uint32_t read_value = iob_eth_csrs_get_eth_txctrl();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_eth_txctrl_read() {
  iob_eth_csrs_get_eth_txctrl();
  return TEST_PASSED;
}

int test_functionality_tx_bd_cnt_read() {
  iob_eth_csrs_get_tx_bd_cnt();
  return TEST_PASSED;
}

int test_functionality_rx_bd_cnt_read() {
  iob_eth_csrs_get_rx_bd_cnt();
  return TEST_PASSED;
}

int test_functionality_tx_word_cnt_read() {
  iob_eth_csrs_get_tx_word_cnt();
  return TEST_PASSED;
}

int test_functionality_rx_word_cnt_read() {
  iob_eth_csrs_get_rx_word_cnt();
  return TEST_PASSED;
}

int test_functionality_rx_nbytes_read() {
  iob_eth_csrs_get_rx_nbytes();
  return TEST_PASSED;
}

int test_functionality_frame_word_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint8_t value = (uint8_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_frame_word(value);

  uint8_t read_value = iob_eth_csrs_get_frame_word();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_frame_word_read() {
  iob_eth_csrs_get_frame_word();
  return TEST_PASSED;
}

int test_functionality_phy_rst_val_read() {
  iob_eth_csrs_get_phy_rst_val();
  return TEST_PASSED;
}

int test_functionality_bd_write() {
  // Cast the test value to the correct data type, adjusting to the CSR width
  // (ignoring most significant bits if needed)
  uint32_t value = (uint32_t)TEST_WRITE_VALUE;
  iob_eth_csrs_set_bd(value);

  uint32_t read_value = iob_eth_csrs_get_bd();
  if (read_value != value) {
    printf("Error: Read value (0x%x) does not match written value (0x%x)\n",
           read_value, value);
    return TEST_FAILED;
  }

  return TEST_PASSED;
}

int test_functionality_bd_read() {
  iob_eth_csrs_get_bd();
  return TEST_PASSED;
}

int test_functionality_version_read() {
  iob_eth_csrs_get_version();
  return TEST_PASSED;
}

//
// Error handling tests
//

#if defined(DEV_IF)
int test_error_concurrent_open() {
  /*
   * Test concurrent open calls to the device file.
   * This test is for the dev interface.
   */
  int fd1 = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd1 == -1) {
    perror("open");
    return TEST_FAILED;
  }

  int fd2 = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd2 != -1 || errno != EBUSY) {
    printf("Error: Second open should fail with EBUSY\n");
    if (fd2 != -1) {
      close(fd2);
    }
    close(fd1);
    return TEST_FAILED;
  }

  close(fd1);
  return TEST_PASSED;
}

int test_error_invalid_write() {
  /*
   * Test invalid write calls to the device file.
   * This test is for the dev interface.
   */
  int fd = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd == -1) {
    perror("open");
    return TEST_FAILED;
  }

  char buf = 0;
  lseek(fd, IOB_ETH_CSRS_VERSION_ADDR, SEEK_SET); // Seek to a read-only CSR
  if (write(fd, &buf, 1) != -1 || errno != EACCES) {
    printf("Error: Invalid write should fail with EACCES\n");
    close(fd);
    return TEST_FAILED;
  }

  close(fd);
  return TEST_PASSED;
}

int test_error_invalid_llseek() {
  /*
   * Test invalid llseek calls to the device file.
   * This test is for the dev interface.
   */
  int fd = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd == -1) {
    perror("open");
    return TEST_FAILED;
  }

  if (lseek(fd, 0, -1) != -1 || errno != EINVAL) {
    printf("Error: Invalid llseek should fail with EINVAL\n");
    close(fd);
    return TEST_FAILED;
  }

  close(fd);
  return TEST_PASSED;
}

#elif defined(IOCTL_IF)
int test_error_invalid_ioctl() {
  /*
   * Test invalid ioctl calls to the device file.
   * This test is for the ioctl interface.
   */
  int fd = open(IOB_ETH_DEVICE_FILE, O_RDWR);
  if (fd == -1) {
    perror("open");
    return TEST_FAILED;
  }

  if (ioctl(fd, -1, NULL) == 0 || errno != ENOTTY) {
    printf("Error: Invalid ioctl should fail with ENOTTY. Errno: %d\n", errno);
    close(fd);
    return TEST_FAILED;
  }

  close(fd);
  return TEST_PASSED;
}

#elif defined(SYSFS_IF)
int test_error_sysfs_write_to_readonly() {
  /*
   * Test writing to a read-only sysfs file.
   * This test is for the sysfs interface.
   */
  char file_path[128];
  sprintf(file_path, "/sys/class/iob_eth/iob_eth/version");
  int fd = open(file_path, O_WRONLY);
  if (fd != -1 || errno != EACCES) {
    printf("Error: Opening a read-only sysfs file for writing should fail with "
           "EACCES.\n");
    if (fd != -1) {
      close(fd);
    }
    return TEST_FAILED;
  }
  return TEST_PASSED;
}

int test_error_sysfs_read_from_nonexistent() {
  /*
   * Test reading from a non-existent sysfs file.
   * This test is for the sysfs interface.
   */
  char file_path[128];
  sprintf(file_path, "/sys/class/iob_eth/iob_eth/nonexistent");
  int fd = open(file_path, O_RDONLY);
  if (fd != -1 || errno != ENOENT) {
    printf("Error: Opening a non-existent sysfs file for reading should fail "
           "with ENOENT.\n");
    if (fd != -1) {
      close(fd);
    }
    return TEST_FAILED;
  }
  return TEST_PASSED;
}

int test_error_sysfs_write_invalid_value() {
  /*
   * Test writing an invalid value to a sysfs file.
   * This test is for the sysfs interface.
   */
  char file_path[128];
  sprintf(file_path, "/sys/class/iob_eth/iob_eth/moder");
  int fd = open(file_path, O_WRONLY);
  if (fd == -1) {
    perror("open");
    return TEST_FAILED;
  }
  if (write(fd, "invalid", 7) != -1 || errno != EINVAL) {
    printf("Error: Writing an invalid value to a sysfs file should fail with "
           "EINVAL.\n");
    close(fd);
    return TEST_FAILED;
  }
  close(fd);
  return TEST_PASSED;
}
#endif // SYSFS_IF

//
// Performance tests
//

int test_performance_moder_read() {
  const int num_iterations = 100;
  struct timespec start, end;
  double total_time = 0;

  clock_gettime(CLOCK_MONOTONIC, &start);
  for (int i = 0; i < num_iterations; i++) {
    iob_eth_csrs_get_moder();
  }
  clock_gettime(CLOCK_MONOTONIC, &end);

  total_time =
      (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
  printf("Read performance for moder: %f seconds for %d iterations\n",
         total_time, num_iterations);

  return TEST_PASSED;
}

int test_performance_moder_write() {
  const int num_iterations = 100;
  struct timespec start, end;
  double total_time = 0;

  clock_gettime(CLOCK_MONOTONIC, &start);
  for (int i = 0; i < num_iterations; i++) {
    iob_eth_csrs_set_moder(i);
  }
  clock_gettime(CLOCK_MONOTONIC, &end);

  total_time =
      (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
  printf("Write performance for moder: %f seconds for %d iterations\n",
         total_time, num_iterations);

  return TEST_PASSED;
}

int main() {
  // Run error handling tests that manage their own file descriptors first
#if defined(DEV_IF)
  RUN_TEST(test_error_concurrent_open);

  RUN_TEST(test_error_invalid_write);
  RUN_TEST(test_error_invalid_llseek);
#elif defined(IOCTL_IF)
  RUN_TEST(test_error_invalid_ioctl);
#endif

  // Initialize global file descriptor for remaining tests
  iob_eth_csrs_init_baseaddr(0);

  printf("\n[User] Version: 0x%x\n", iob_eth_csrs_get_version());

  // Run functionality tests

  RUN_TEST(test_functionality_moder_write);
  RUN_TEST(test_functionality_moder_read);
  RUN_TEST(test_functionality_int_source_write);
  RUN_TEST(test_functionality_int_source_read);
  RUN_TEST(test_functionality_int_mask_write);
  RUN_TEST(test_functionality_int_mask_read);
  RUN_TEST(test_functionality_ipgt_write);
  RUN_TEST(test_functionality_ipgt_read);
  RUN_TEST(test_functionality_ipgr1_write);
  RUN_TEST(test_functionality_ipgr1_read);
  RUN_TEST(test_functionality_ipgr2_write);
  RUN_TEST(test_functionality_ipgr2_read);
  RUN_TEST(test_functionality_packetlen_write);
  RUN_TEST(test_functionality_packetlen_read);
  RUN_TEST(test_functionality_collconf_write);
  RUN_TEST(test_functionality_collconf_read);
  RUN_TEST(test_functionality_tx_bd_num_write);
  RUN_TEST(test_functionality_tx_bd_num_read);
  RUN_TEST(test_functionality_ctrlmoder_write);
  RUN_TEST(test_functionality_ctrlmoder_read);
  RUN_TEST(test_functionality_miimoder_write);
  RUN_TEST(test_functionality_miimoder_read);
  RUN_TEST(test_functionality_miicommand_write);
  RUN_TEST(test_functionality_miicommand_read);
  RUN_TEST(test_functionality_miiaddress_write);
  RUN_TEST(test_functionality_miiaddress_read);
  RUN_TEST(test_functionality_miitx_data_write);
  RUN_TEST(test_functionality_miitx_data_read);
  RUN_TEST(test_functionality_miirx_data_write);
  RUN_TEST(test_functionality_miirx_data_read);
  RUN_TEST(test_functionality_miistatus_write);
  RUN_TEST(test_functionality_miistatus_read);
  RUN_TEST(test_functionality_mac_addr0_write);
  RUN_TEST(test_functionality_mac_addr0_read);
  RUN_TEST(test_functionality_mac_addr1_write);
  RUN_TEST(test_functionality_mac_addr1_read);
  RUN_TEST(test_functionality_eth_hash0_adr_write);
  RUN_TEST(test_functionality_eth_hash0_adr_read);
  RUN_TEST(test_functionality_eth_hash1_adr_write);
  RUN_TEST(test_functionality_eth_hash1_adr_read);
  RUN_TEST(test_functionality_eth_txctrl_write);
  RUN_TEST(test_functionality_eth_txctrl_read);
  RUN_TEST(test_functionality_tx_bd_cnt_read);
  RUN_TEST(test_functionality_rx_bd_cnt_read);
  RUN_TEST(test_functionality_tx_word_cnt_read);
  RUN_TEST(test_functionality_rx_word_cnt_read);
  RUN_TEST(test_functionality_rx_nbytes_read);
  RUN_TEST(test_functionality_frame_word_write);
  RUN_TEST(test_functionality_frame_word_read);
  RUN_TEST(test_functionality_phy_rst_val_read);
  RUN_TEST(test_functionality_bd_write);
  RUN_TEST(test_functionality_bd_read);
  RUN_TEST(test_functionality_version_read);
  // Run SYSFS error tests
#if defined(SYSFS_IF)
  RUN_TEST(test_error_sysfs_write_to_readonly);
  RUN_TEST(test_error_sysfs_read_from_nonexistent);

  RUN_TEST(test_error_sysfs_write_invalid_value);

#endif

  // Run performance tests

  RUN_TEST(test_performance_moder_write);
  RUN_TEST(test_performance_moder_read);
  printf("All tests passed!\n");
}

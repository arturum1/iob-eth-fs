/*
 * SPDX-FileCopyrightText: 2025 IObundle
 *
 * SPDX-License-Identifier: MIT
 */

/* iob_eth_main.c: driver for iob_eth
 * using device platform. No hardcoded hardware address:
 * 1. load driver: insmod iob_eth.ko
 * 2. run user app: ./user/user
 */

#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/io.h>
#include <linux/ioport.h>
#include <linux/kernel.h>
#include <linux/mod_devicetable.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/uaccess.h>

#include <linux/ioctl.h>

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

#include "iob_class/iob_class_utils.h"
#include "iob_eth_driver_files.h"

static int iob_eth_probe(struct platform_device *);
static int iob_eth_remove(struct platform_device *);

static ssize_t iob_eth_read(struct file *, char __user *, size_t, loff_t *);
static ssize_t iob_eth_write(struct file *, const char __user *, size_t,
                             loff_t *);
static loff_t iob_eth_llseek(struct file *, loff_t, int);
static int iob_eth_open(struct inode *, struct file *);
static int iob_eth_release(struct inode *, struct file *);

static long iob_eth_ioctl(struct file *, unsigned int, unsigned long);

static struct iob_data iob_eth_data = {0};
DEFINE_MUTEX(iob_eth_mutex);

#include "iob_eth_sysfs.h"

static const struct file_operations iob_eth_fops = {
    .owner = THIS_MODULE,
    .write = iob_eth_write,
    .read = iob_eth_read,
    .llseek = iob_eth_llseek,
    .unlocked_ioctl = iob_eth_ioctl,
    .open = iob_eth_open,
    .release = iob_eth_release,
};

static const struct of_device_id of_iob_eth_match[] = {
    {.compatible = "iobundle,eth0"},
    {},
};

static struct platform_driver iob_eth_driver = {
    .driver =
        {
            .name = "iob_eth",
            .owner = THIS_MODULE,
            .of_match_table = of_iob_eth_match,
        },
    .probe = iob_eth_probe,
    .remove = iob_eth_remove,
};

//
// Module init and exit functions
//
static int iob_eth_probe(struct platform_device *pdev) {
  struct resource *res;
  int result = 0;

  if (iob_eth_data.device != NULL) {
    pr_err("[Driver] %s: No more devices allowed!\n", IOB_ETH_DRIVER_NAME);

    return -ENODEV;
  }

  pr_info("[iob_eth] %s: probing.\n", IOB_ETH_DRIVER_NAME);

  // Get the I/O region base address
  res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (!res) {
    pr_err("[Driver]: Failed to get I/O resource!\n");
    result = -ENODEV;
    goto r_get_resource;
  }

  // Request and map the I/O region
  iob_eth_data.regbase = devm_ioremap_resource(&pdev->dev, res);
  if (IS_ERR(iob_eth_data.regbase)) {
    result = PTR_ERR(iob_eth_data.regbase);
    goto r_ioremmap;
  }
  iob_eth_data.regsize = resource_size(res);

  // Allocate char device
  result = alloc_chrdev_region(&iob_eth_data.devnum, 0, 1, IOB_ETH_DRIVER_NAME);
  if (result) {
    pr_err("%s: Failed to allocate device number!\n", IOB_ETH_DRIVER_NAME);
    goto r_alloc_region;
  }

  cdev_init(&iob_eth_data.cdev, &iob_eth_fops);

  result = cdev_add(&iob_eth_data.cdev, iob_eth_data.devnum, 1);
  if (result) {
    pr_err("%s: Char device registration failed!\n", IOB_ETH_DRIVER_NAME);
    goto r_cdev_add;
  }

  // Create device class // todo: make a dummy driver just to create and own the
  // class: https://stackoverflow.com/a/16365027/8228163
  if ((iob_eth_data.class = class_create(THIS_MODULE, IOB_ETH_DRIVER_CLASS)) ==
      NULL) {
    printk("Device class can not be created!\n");
    goto r_class;
  }

  // Create device file
  iob_eth_data.device = device_create(
      iob_eth_data.class, NULL, iob_eth_data.devnum, NULL, IOB_ETH_DRIVER_NAME);
  if (iob_eth_data.device == NULL) {
    printk("Can not create device file!\n");
    goto r_device;
  }

  result = iob_eth_create_device_attr_files(iob_eth_data.device);
  if (result) {
    pr_err("Cannot create device attribute file......\n");
    goto r_dev_file;
  }

  dev_info(&pdev->dev, "initialized.\n");
  goto r_ok;

r_dev_file:
  iob_eth_remove_device_attr_files(&iob_eth_data);
r_device:
  class_destroy(iob_eth_data.class);
r_class:
  cdev_del(&iob_eth_data.cdev);
r_cdev_add:
  unregister_chrdev_region(iob_eth_data.devnum, 1);
r_alloc_region:
  // iounmap is managed by devm
r_ioremmap:
r_get_resource:
r_ok:

  return result;
}

static int iob_eth_remove(struct platform_device *pdev) {
  iob_eth_remove_device_attr_files(&iob_eth_data);
  class_destroy(iob_eth_data.class);
  cdev_del(&iob_eth_data.cdev);
  unregister_chrdev_region(iob_eth_data.devnum, 1);
  // Note: no need for iounmap, since we are using devm_ioremap_resource()

  dev_info(&pdev->dev, "exiting.\n");

  return 0;
}

static int __init iob_eth_init(void) {
  pr_info("[iob_eth] %s: initializing.\n", IOB_ETH_DRIVER_NAME);

  return platform_driver_register(&iob_eth_driver);
}

static void __exit iob_eth_exit(void) {
  pr_info("[iob_eth] %s: exiting.\n", IOB_ETH_DRIVER_NAME);
  platform_driver_unregister(&iob_eth_driver);
}

//
// File operations
//

static int iob_eth_open(struct inode *inode, struct file *file) {
  pr_info("[iob_eth] Device opened\n");

  if (!mutex_trylock(&iob_eth_mutex)) {
    pr_info("[iob_eth] Another process is accessing the device\n");

    return -EBUSY;
  }

  return 0;
}

static int iob_eth_release(struct inode *inode, struct file *file) {
  pr_info("[iob_eth] Device closed\n");

  mutex_unlock(&iob_eth_mutex);

  return 0;
}

static ssize_t iob_eth_read(struct file *file, char __user *buf, size_t count,
                            loff_t *ppos) {
  int size = 0;
  u32 value = 0;

  /* read value from register */
  switch (*ppos) {
  case IOB_ETH_CSRS_MODER_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MODER_ADDR,
                              IOB_ETH_CSRS_MODER_W);
    size = (IOB_ETH_CSRS_MODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read moder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_INT_SOURCE_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_INT_SOURCE_ADDR,
                          IOB_ETH_CSRS_INT_SOURCE_W);
    size = (IOB_ETH_CSRS_INT_SOURCE_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read int_source: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_INT_MASK_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_INT_MASK_ADDR,
                              IOB_ETH_CSRS_INT_MASK_W);
    size = (IOB_ETH_CSRS_INT_MASK_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read int_mask: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGT_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGT_ADDR,
                              IOB_ETH_CSRS_IPGT_W);
    size = (IOB_ETH_CSRS_IPGT_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read ipgt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGR1_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGR1_ADDR,
                              IOB_ETH_CSRS_IPGR1_W);
    size = (IOB_ETH_CSRS_IPGR1_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read ipgr1: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGR2_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGR2_ADDR,
                              IOB_ETH_CSRS_IPGR2_W);
    size = (IOB_ETH_CSRS_IPGR2_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read ipgr2: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_PACKETLEN_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_PACKETLEN_ADDR,
                              IOB_ETH_CSRS_PACKETLEN_W);
    size = (IOB_ETH_CSRS_PACKETLEN_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read packetlen: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_COLLCONF_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_COLLCONF_ADDR,
                              IOB_ETH_CSRS_COLLCONF_W);
    size = (IOB_ETH_CSRS_COLLCONF_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read collconf: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_TX_BD_NUM_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_BD_NUM_ADDR,
                              IOB_ETH_CSRS_TX_BD_NUM_W);
    size = (IOB_ETH_CSRS_TX_BD_NUM_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read tx_bd_num: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_CTRLMODER_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_CTRLMODER_ADDR,
                              IOB_ETH_CSRS_CTRLMODER_W);
    size = (IOB_ETH_CSRS_CTRLMODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read ctrlmoder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIMODER_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIMODER_ADDR,
                              IOB_ETH_CSRS_MIIMODER_W);
    size = (IOB_ETH_CSRS_MIIMODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miimoder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIICOMMAND_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIICOMMAND_ADDR,
                          IOB_ETH_CSRS_MIICOMMAND_W);
    size = (IOB_ETH_CSRS_MIICOMMAND_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miicommand: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIADDRESS_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIADDRESS_ADDR,
                          IOB_ETH_CSRS_MIIADDRESS_W);
    size = (IOB_ETH_CSRS_MIIADDRESS_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miiaddress: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIITX_DATA_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIITX_DATA_ADDR,
                          IOB_ETH_CSRS_MIITX_DATA_W);
    size = (IOB_ETH_CSRS_MIITX_DATA_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miitx_data: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIRX_DATA_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIRX_DATA_ADDR,
                          IOB_ETH_CSRS_MIIRX_DATA_W);
    size = (IOB_ETH_CSRS_MIIRX_DATA_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miirx_data: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIISTATUS_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIISTATUS_ADDR,
                              IOB_ETH_CSRS_MIISTATUS_W);
    size = (IOB_ETH_CSRS_MIISTATUS_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read miistatus: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MAC_ADDR0_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MAC_ADDR0_ADDR,
                              IOB_ETH_CSRS_MAC_ADDR0_W);
    size = (IOB_ETH_CSRS_MAC_ADDR0_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read mac_addr0: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MAC_ADDR1_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MAC_ADDR1_ADDR,
                              IOB_ETH_CSRS_MAC_ADDR1_W);
    size = (IOB_ETH_CSRS_MAC_ADDR1_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read mac_addr1: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR,
                          IOB_ETH_CSRS_ETH_HASH0_ADR_W);
    size = (IOB_ETH_CSRS_ETH_HASH0_ADR_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read eth_hash0_adr: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR,
                          IOB_ETH_CSRS_ETH_HASH1_ADR_W);
    size = (IOB_ETH_CSRS_ETH_HASH1_ADR_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read eth_hash1_adr: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_TXCTRL_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_TXCTRL_ADDR,
                          IOB_ETH_CSRS_ETH_TXCTRL_W);
    size = (IOB_ETH_CSRS_ETH_TXCTRL_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read eth_txctrl: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_TX_BD_CNT_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_BD_CNT_ADDR,
                              IOB_ETH_CSRS_TX_BD_CNT_W);
    size = (IOB_ETH_CSRS_TX_BD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read tx_bd_cnt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_RX_BD_CNT_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_BD_CNT_ADDR,
                              IOB_ETH_CSRS_RX_BD_CNT_W);
    size = (IOB_ETH_CSRS_RX_BD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read rx_bd_cnt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_TX_WORD_CNT_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_WORD_CNT_ADDR,
                          IOB_ETH_CSRS_TX_WORD_CNT_W);
    size = (IOB_ETH_CSRS_TX_WORD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read tx_word_cnt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_RX_WORD_CNT_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_WORD_CNT_ADDR,
                          IOB_ETH_CSRS_RX_WORD_CNT_W);
    size = (IOB_ETH_CSRS_RX_WORD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read rx_word_cnt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_RX_NBYTES_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_NBYTES_ADDR,
                              IOB_ETH_CSRS_RX_NBYTES_W);
    size = (IOB_ETH_CSRS_RX_NBYTES_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read rx_nbytes: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_FRAME_WORD_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_FRAME_WORD_ADDR,
                          IOB_ETH_CSRS_FRAME_WORD_W);
    size = (IOB_ETH_CSRS_FRAME_WORD_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read frame_word: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_PHY_RST_VAL_ADDR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_PHY_RST_VAL_ADDR,
                          IOB_ETH_CSRS_PHY_RST_VAL_W);
    size = (IOB_ETH_CSRS_PHY_RST_VAL_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read phy_rst_val: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_BD_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_BD_ADDR,
                              IOB_ETH_CSRS_BD_W);
    size = (IOB_ETH_CSRS_BD_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read bd: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_VERSION_ADDR:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_VERSION_ADDR,
                              IOB_ETH_CSRS_VERSION_W);
    size = (IOB_ETH_CSRS_VERSION_W >> 3); // bit to bytes
    pr_info("[iob_eth] Dev - Read version: 0x%x\n", value);
    break;
  default:
    // invalid address - no bytes read
    return -EACCES;
  }

  // Read min between count and REG_SIZE
  if (size > count)
    size = count;

  if (copy_to_user(buf, &value, size))
    return -EFAULT;

  return count;
}

static ssize_t iob_eth_write(struct file *file, const char __user *buf,
                             size_t count, loff_t *ppos) {
  int size = 0;
  u32 value = 0;

  switch (*ppos) {
  case IOB_ETH_CSRS_MODER_ADDR:
    size = (IOB_ETH_CSRS_MODER_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for moder CSR is not equal to register "
              "size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MODER_ADDR,
                       IOB_ETH_CSRS_MODER_W);
    pr_info("[iob_eth] Dev - Write moder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_INT_SOURCE_ADDR:
    size = (IOB_ETH_CSRS_INT_SOURCE_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for int_source CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_INT_SOURCE_ADDR, IOB_ETH_CSRS_INT_SOURCE_W);
    pr_info("[iob_eth] Dev - Write int_source: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_INT_MASK_ADDR:
    size = (IOB_ETH_CSRS_INT_MASK_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for int_mask CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_INT_MASK_ADDR,
                       IOB_ETH_CSRS_INT_MASK_W);
    pr_info("[iob_eth] Dev - Write int_mask: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGT_ADDR:
    size = (IOB_ETH_CSRS_IPGT_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for ipgt CSR is not equal to register "
              "size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGT_ADDR,
                       IOB_ETH_CSRS_IPGT_W);
    pr_info("[iob_eth] Dev - Write ipgt: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGR1_ADDR:
    size = (IOB_ETH_CSRS_IPGR1_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for ipgr1 CSR is not equal to register "
              "size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGR1_ADDR,
                       IOB_ETH_CSRS_IPGR1_W);
    pr_info("[iob_eth] Dev - Write ipgr1: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_IPGR2_ADDR:
    size = (IOB_ETH_CSRS_IPGR2_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for ipgr2 CSR is not equal to register "
              "size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGR2_ADDR,
                       IOB_ETH_CSRS_IPGR2_W);
    pr_info("[iob_eth] Dev - Write ipgr2: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_PACKETLEN_ADDR:
    size = (IOB_ETH_CSRS_PACKETLEN_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for packetlen CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_PACKETLEN_ADDR,
                       IOB_ETH_CSRS_PACKETLEN_W);
    pr_info("[iob_eth] Dev - Write packetlen: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_COLLCONF_ADDR:
    size = (IOB_ETH_CSRS_COLLCONF_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for collconf CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_COLLCONF_ADDR,
                       IOB_ETH_CSRS_COLLCONF_W);
    pr_info("[iob_eth] Dev - Write collconf: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_TX_BD_NUM_ADDR:
    size = (IOB_ETH_CSRS_TX_BD_NUM_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for tx_bd_num CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_TX_BD_NUM_ADDR,
                       IOB_ETH_CSRS_TX_BD_NUM_W);
    pr_info("[iob_eth] Dev - Write tx_bd_num: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_CTRLMODER_ADDR:
    size = (IOB_ETH_CSRS_CTRLMODER_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for ctrlmoder CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_CTRLMODER_ADDR,
                       IOB_ETH_CSRS_CTRLMODER_W);
    pr_info("[iob_eth] Dev - Write ctrlmoder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIMODER_ADDR:
    size = (IOB_ETH_CSRS_MIIMODER_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miimoder CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MIIMODER_ADDR,
                       IOB_ETH_CSRS_MIIMODER_W);
    pr_info("[iob_eth] Dev - Write miimoder: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIICOMMAND_ADDR:
    size = (IOB_ETH_CSRS_MIICOMMAND_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miicommand CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIICOMMAND_ADDR, IOB_ETH_CSRS_MIICOMMAND_W);
    pr_info("[iob_eth] Dev - Write miicommand: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIADDRESS_ADDR:
    size = (IOB_ETH_CSRS_MIIADDRESS_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miiaddress CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIIADDRESS_ADDR, IOB_ETH_CSRS_MIIADDRESS_W);
    pr_info("[iob_eth] Dev - Write miiaddress: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIITX_DATA_ADDR:
    size = (IOB_ETH_CSRS_MIITX_DATA_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miitx_data CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIITX_DATA_ADDR, IOB_ETH_CSRS_MIITX_DATA_W);
    pr_info("[iob_eth] Dev - Write miitx_data: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIIRX_DATA_ADDR:
    size = (IOB_ETH_CSRS_MIIRX_DATA_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miirx_data CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIIRX_DATA_ADDR, IOB_ETH_CSRS_MIIRX_DATA_W);
    pr_info("[iob_eth] Dev - Write miirx_data: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MIISTATUS_ADDR:
    size = (IOB_ETH_CSRS_MIISTATUS_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for miistatus CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MIISTATUS_ADDR,
                       IOB_ETH_CSRS_MIISTATUS_W);
    pr_info("[iob_eth] Dev - Write miistatus: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MAC_ADDR0_ADDR:
    size = (IOB_ETH_CSRS_MAC_ADDR0_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for mac_addr0 CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MAC_ADDR0_ADDR,
                       IOB_ETH_CSRS_MAC_ADDR0_W);
    pr_info("[iob_eth] Dev - Write mac_addr0: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_MAC_ADDR1_ADDR:
    size = (IOB_ETH_CSRS_MAC_ADDR1_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for mac_addr1 CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MAC_ADDR1_ADDR,
                       IOB_ETH_CSRS_MAC_ADDR1_W);
    pr_info("[iob_eth] Dev - Write mac_addr1: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR:
    size = (IOB_ETH_CSRS_ETH_HASH0_ADR_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for eth_hash0_adr CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR,
                       IOB_ETH_CSRS_ETH_HASH0_ADR_W);
    pr_info("[iob_eth] Dev - Write eth_hash0_adr: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR:
    size = (IOB_ETH_CSRS_ETH_HASH1_ADR_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for eth_hash1_adr CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR,
                       IOB_ETH_CSRS_ETH_HASH1_ADR_W);
    pr_info("[iob_eth] Dev - Write eth_hash1_adr: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_ETH_TXCTRL_ADDR:
    size = (IOB_ETH_CSRS_ETH_TXCTRL_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for eth_txctrl CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_TXCTRL_ADDR, IOB_ETH_CSRS_ETH_TXCTRL_W);
    pr_info("[iob_eth] Dev - Write eth_txctrl: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_FRAME_WORD_ADDR:
    size = (IOB_ETH_CSRS_FRAME_WORD_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for frame_word CSR is not equal to "
              "register size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_FRAME_WORD_ADDR, IOB_ETH_CSRS_FRAME_WORD_W);
    pr_info("[iob_eth] Dev - Write frame_word: 0x%x\n", value);
    break;
  case IOB_ETH_CSRS_BD_ADDR:
    size = (IOB_ETH_CSRS_BD_W >> 3); // bit to bytes
    if (count != size) {
      pr_info("[iob_eth] write size %d for bd CSR is not equal to register "
              "size %d\n",
              (int)count, size);
      return -EACCES;
    }
    if (read_user_data(buf, size, &value))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_BD_ADDR,
                       IOB_ETH_CSRS_BD_W);
    pr_info("[iob_eth] Dev - Write bd: 0x%x\n", value);
    break;
  default:
    pr_info("[iob_eth] Invalid write address 0x%x\n", (unsigned int)*ppos);
    // invalid address - no bytes written
    return -EACCES;
  }

  return count;
}

/* Custom lseek function
 * check: lseek(2) man page for whence modes
 */
static loff_t iob_eth_llseek(struct file *filp, loff_t offset, int whence) {
  loff_t new_pos = -1;

  switch (whence) {
  case SEEK_SET:
    new_pos = offset;
    break;
  case SEEK_CUR:
    new_pos = filp->f_pos + offset;
    break;
  case SEEK_END:
    new_pos = (1 << IOB_ETH_CSRS_ADDR_W) + offset;
    break;
  default:
    return -EINVAL;
  }

  // Check for valid bounds
  if (new_pos < 0 || new_pos > iob_eth_data.regsize) {
    return -EINVAL;
  }

  // Update file position
  filp->f_pos = new_pos;

  return new_pos;
}

/* IOCTL function
 * This function will be called when we write IOCTL on the Device file
 */
static long iob_eth_ioctl(struct file *file, unsigned int cmd,
                          unsigned long arg) {
  int size = 0;
  u32 value = 0;

  switch (cmd) {
  case WR_MODER:
    size = (IOB_ETH_CSRS_MODER_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MODER_ADDR,
                       IOB_ETH_CSRS_MODER_W);
    pr_info("[iob_eth] IOCTL - Write moder: 0x%x\n", value);

    break;
  case RD_MODER:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MODER_ADDR,
                              IOB_ETH_CSRS_MODER_W);
    size = (IOB_ETH_CSRS_MODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read moder: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_INT_SOURCE:
    size = (IOB_ETH_CSRS_INT_SOURCE_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_INT_SOURCE_ADDR, IOB_ETH_CSRS_INT_SOURCE_W);
    pr_info("[iob_eth] IOCTL - Write int_source: 0x%x\n", value);

    break;
  case RD_INT_SOURCE:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_INT_SOURCE_ADDR,
                          IOB_ETH_CSRS_INT_SOURCE_W);
    size = (IOB_ETH_CSRS_INT_SOURCE_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read int_source: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_INT_MASK:
    size = (IOB_ETH_CSRS_INT_MASK_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_INT_MASK_ADDR,
                       IOB_ETH_CSRS_INT_MASK_W);
    pr_info("[iob_eth] IOCTL - Write int_mask: 0x%x\n", value);

    break;
  case RD_INT_MASK:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_INT_MASK_ADDR,
                              IOB_ETH_CSRS_INT_MASK_W);
    size = (IOB_ETH_CSRS_INT_MASK_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read int_mask: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_IPGT:
    size = (IOB_ETH_CSRS_IPGT_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGT_ADDR,
                       IOB_ETH_CSRS_IPGT_W);
    pr_info("[iob_eth] IOCTL - Write ipgt: 0x%x\n", value);

    break;
  case RD_IPGT:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGT_ADDR,
                              IOB_ETH_CSRS_IPGT_W);
    size = (IOB_ETH_CSRS_IPGT_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read ipgt: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_IPGR1:
    size = (IOB_ETH_CSRS_IPGR1_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGR1_ADDR,
                       IOB_ETH_CSRS_IPGR1_W);
    pr_info("[iob_eth] IOCTL - Write ipgr1: 0x%x\n", value);

    break;
  case RD_IPGR1:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGR1_ADDR,
                              IOB_ETH_CSRS_IPGR1_W);
    size = (IOB_ETH_CSRS_IPGR1_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read ipgr1: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_IPGR2:
    size = (IOB_ETH_CSRS_IPGR2_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_IPGR2_ADDR,
                       IOB_ETH_CSRS_IPGR2_W);
    pr_info("[iob_eth] IOCTL - Write ipgr2: 0x%x\n", value);

    break;
  case RD_IPGR2:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_IPGR2_ADDR,
                              IOB_ETH_CSRS_IPGR2_W);
    size = (IOB_ETH_CSRS_IPGR2_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read ipgr2: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_PACKETLEN:
    size = (IOB_ETH_CSRS_PACKETLEN_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_PACKETLEN_ADDR,
                       IOB_ETH_CSRS_PACKETLEN_W);
    pr_info("[iob_eth] IOCTL - Write packetlen: 0x%x\n", value);

    break;
  case RD_PACKETLEN:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_PACKETLEN_ADDR,
                              IOB_ETH_CSRS_PACKETLEN_W);
    size = (IOB_ETH_CSRS_PACKETLEN_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read packetlen: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_COLLCONF:
    size = (IOB_ETH_CSRS_COLLCONF_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_COLLCONF_ADDR,
                       IOB_ETH_CSRS_COLLCONF_W);
    pr_info("[iob_eth] IOCTL - Write collconf: 0x%x\n", value);

    break;
  case RD_COLLCONF:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_COLLCONF_ADDR,
                              IOB_ETH_CSRS_COLLCONF_W);
    size = (IOB_ETH_CSRS_COLLCONF_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read collconf: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_TX_BD_NUM:
    size = (IOB_ETH_CSRS_TX_BD_NUM_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_TX_BD_NUM_ADDR,
                       IOB_ETH_CSRS_TX_BD_NUM_W);
    pr_info("[iob_eth] IOCTL - Write tx_bd_num: 0x%x\n", value);

    break;
  case RD_TX_BD_NUM:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_BD_NUM_ADDR,
                              IOB_ETH_CSRS_TX_BD_NUM_W);
    size = (IOB_ETH_CSRS_TX_BD_NUM_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read tx_bd_num: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_CTRLMODER:
    size = (IOB_ETH_CSRS_CTRLMODER_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_CTRLMODER_ADDR,
                       IOB_ETH_CSRS_CTRLMODER_W);
    pr_info("[iob_eth] IOCTL - Write ctrlmoder: 0x%x\n", value);

    break;
  case RD_CTRLMODER:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_CTRLMODER_ADDR,
                              IOB_ETH_CSRS_CTRLMODER_W);
    size = (IOB_ETH_CSRS_CTRLMODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read ctrlmoder: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIIMODER:
    size = (IOB_ETH_CSRS_MIIMODER_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MIIMODER_ADDR,
                       IOB_ETH_CSRS_MIIMODER_W);
    pr_info("[iob_eth] IOCTL - Write miimoder: 0x%x\n", value);

    break;
  case RD_MIIMODER:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIMODER_ADDR,
                              IOB_ETH_CSRS_MIIMODER_W);
    size = (IOB_ETH_CSRS_MIIMODER_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miimoder: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIICOMMAND:
    size = (IOB_ETH_CSRS_MIICOMMAND_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIICOMMAND_ADDR, IOB_ETH_CSRS_MIICOMMAND_W);
    pr_info("[iob_eth] IOCTL - Write miicommand: 0x%x\n", value);

    break;
  case RD_MIICOMMAND:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIICOMMAND_ADDR,
                          IOB_ETH_CSRS_MIICOMMAND_W);
    size = (IOB_ETH_CSRS_MIICOMMAND_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miicommand: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIIADDRESS:
    size = (IOB_ETH_CSRS_MIIADDRESS_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIIADDRESS_ADDR, IOB_ETH_CSRS_MIIADDRESS_W);
    pr_info("[iob_eth] IOCTL - Write miiaddress: 0x%x\n", value);

    break;
  case RD_MIIADDRESS:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIADDRESS_ADDR,
                          IOB_ETH_CSRS_MIIADDRESS_W);
    size = (IOB_ETH_CSRS_MIIADDRESS_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miiaddress: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIITX_DATA:
    size = (IOB_ETH_CSRS_MIITX_DATA_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIITX_DATA_ADDR, IOB_ETH_CSRS_MIITX_DATA_W);
    pr_info("[iob_eth] IOCTL - Write miitx_data: 0x%x\n", value);

    break;
  case RD_MIITX_DATA:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIITX_DATA_ADDR,
                          IOB_ETH_CSRS_MIITX_DATA_W);
    size = (IOB_ETH_CSRS_MIITX_DATA_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miitx_data: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIIRX_DATA:
    size = (IOB_ETH_CSRS_MIIRX_DATA_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_MIIRX_DATA_ADDR, IOB_ETH_CSRS_MIIRX_DATA_W);
    pr_info("[iob_eth] IOCTL - Write miirx_data: 0x%x\n", value);

    break;
  case RD_MIIRX_DATA:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIIRX_DATA_ADDR,
                          IOB_ETH_CSRS_MIIRX_DATA_W);
    size = (IOB_ETH_CSRS_MIIRX_DATA_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miirx_data: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MIISTATUS:
    size = (IOB_ETH_CSRS_MIISTATUS_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MIISTATUS_ADDR,
                       IOB_ETH_CSRS_MIISTATUS_W);
    pr_info("[iob_eth] IOCTL - Write miistatus: 0x%x\n", value);

    break;
  case RD_MIISTATUS:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MIISTATUS_ADDR,
                              IOB_ETH_CSRS_MIISTATUS_W);
    size = (IOB_ETH_CSRS_MIISTATUS_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read miistatus: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MAC_ADDR0:
    size = (IOB_ETH_CSRS_MAC_ADDR0_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MAC_ADDR0_ADDR,
                       IOB_ETH_CSRS_MAC_ADDR0_W);
    pr_info("[iob_eth] IOCTL - Write mac_addr0: 0x%x\n", value);

    break;
  case RD_MAC_ADDR0:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MAC_ADDR0_ADDR,
                              IOB_ETH_CSRS_MAC_ADDR0_W);
    size = (IOB_ETH_CSRS_MAC_ADDR0_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read mac_addr0: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_MAC_ADDR1:
    size = (IOB_ETH_CSRS_MAC_ADDR1_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_MAC_ADDR1_ADDR,
                       IOB_ETH_CSRS_MAC_ADDR1_W);
    pr_info("[iob_eth] IOCTL - Write mac_addr1: 0x%x\n", value);

    break;
  case RD_MAC_ADDR1:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_MAC_ADDR1_ADDR,
                              IOB_ETH_CSRS_MAC_ADDR1_W);
    size = (IOB_ETH_CSRS_MAC_ADDR1_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read mac_addr1: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_ETH_HASH0_ADR:
    size = (IOB_ETH_CSRS_ETH_HASH0_ADR_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR,
                       IOB_ETH_CSRS_ETH_HASH0_ADR_W);
    pr_info("[iob_eth] IOCTL - Write eth_hash0_adr: 0x%x\n", value);

    break;
  case RD_ETH_HASH0_ADR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_HASH0_ADR_ADDR,
                          IOB_ETH_CSRS_ETH_HASH0_ADR_W);
    size = (IOB_ETH_CSRS_ETH_HASH0_ADR_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read eth_hash0_adr: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_ETH_HASH1_ADR:
    size = (IOB_ETH_CSRS_ETH_HASH1_ADR_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR,
                       IOB_ETH_CSRS_ETH_HASH1_ADR_W);
    pr_info("[iob_eth] IOCTL - Write eth_hash1_adr: 0x%x\n", value);

    break;
  case RD_ETH_HASH1_ADR:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_HASH1_ADR_ADDR,
                          IOB_ETH_CSRS_ETH_HASH1_ADR_W);
    size = (IOB_ETH_CSRS_ETH_HASH1_ADR_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read eth_hash1_adr: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_ETH_TXCTRL:
    size = (IOB_ETH_CSRS_ETH_TXCTRL_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_ETH_TXCTRL_ADDR, IOB_ETH_CSRS_ETH_TXCTRL_W);
    pr_info("[iob_eth] IOCTL - Write eth_txctrl: 0x%x\n", value);

    break;
  case RD_ETH_TXCTRL:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_ETH_TXCTRL_ADDR,
                          IOB_ETH_CSRS_ETH_TXCTRL_W);
    size = (IOB_ETH_CSRS_ETH_TXCTRL_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read eth_txctrl: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_TX_BD_CNT:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_BD_CNT_ADDR,
                              IOB_ETH_CSRS_TX_BD_CNT_W);
    size = (IOB_ETH_CSRS_TX_BD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read tx_bd_cnt: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_RX_BD_CNT:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_BD_CNT_ADDR,
                              IOB_ETH_CSRS_RX_BD_CNT_W);
    size = (IOB_ETH_CSRS_RX_BD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read rx_bd_cnt: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_TX_WORD_CNT:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_TX_WORD_CNT_ADDR,
                          IOB_ETH_CSRS_TX_WORD_CNT_W);
    size = (IOB_ETH_CSRS_TX_WORD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read tx_word_cnt: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_RX_WORD_CNT:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_WORD_CNT_ADDR,
                          IOB_ETH_CSRS_RX_WORD_CNT_W);
    size = (IOB_ETH_CSRS_RX_WORD_CNT_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read rx_word_cnt: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_RX_NBYTES:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_RX_NBYTES_ADDR,
                              IOB_ETH_CSRS_RX_NBYTES_W);
    size = (IOB_ETH_CSRS_RX_NBYTES_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read rx_nbytes: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_FRAME_WORD:
    size = (IOB_ETH_CSRS_FRAME_WORD_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value,
                       IOB_ETH_CSRS_FRAME_WORD_ADDR, IOB_ETH_CSRS_FRAME_WORD_W);
    pr_info("[iob_eth] IOCTL - Write frame_word: 0x%x\n", value);

    break;
  case RD_FRAME_WORD:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_FRAME_WORD_ADDR,
                          IOB_ETH_CSRS_FRAME_WORD_W);
    size = (IOB_ETH_CSRS_FRAME_WORD_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read frame_word: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_PHY_RST_VAL:
    value =
        iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_PHY_RST_VAL_ADDR,
                          IOB_ETH_CSRS_PHY_RST_VAL_W);
    size = (IOB_ETH_CSRS_PHY_RST_VAL_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read phy_rst_val: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case WR_BD:
    size = (IOB_ETH_CSRS_BD_W >> 3); // bit to bytes
    if (copy_from_user(&value, (int32_t *)arg, size))
      return -EFAULT;
    iob_data_write_reg(iob_eth_data.regbase, value, IOB_ETH_CSRS_BD_ADDR,
                       IOB_ETH_CSRS_BD_W);
    pr_info("[iob_eth] IOCTL - Write bd: 0x%x\n", value);

    break;
  case RD_BD:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_BD_ADDR,
                              IOB_ETH_CSRS_BD_W);
    size = (IOB_ETH_CSRS_BD_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read bd: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  case RD_VERSION:
    value = iob_data_read_reg(iob_eth_data.regbase, IOB_ETH_CSRS_VERSION_ADDR,
                              IOB_ETH_CSRS_VERSION_W);
    size = (IOB_ETH_CSRS_VERSION_W >> 3); // bit to bytes
    pr_info("[iob_eth] IOCTL - Read version: 0x%x\n", value);

    if (copy_to_user((int32_t *)arg, &value, size))
      return -EFAULT;

    break;
  default:
    pr_info("[iob_eth] Invalid IOCTL command 0x%x\n", cmd);
    return -ENOTTY;
  }
  return 0;
}

module_init(iob_eth_init);
module_exit(iob_eth_exit);

MODULE_LICENSE("Dual MIT/GPL");
MODULE_AUTHOR("IObundle");
MODULE_DESCRIPTION("iob_eth Drivers");
MODULE_VERSION("0.1");

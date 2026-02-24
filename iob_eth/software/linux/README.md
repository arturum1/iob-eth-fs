<!--
SPDX-FileCopyrightText: 2025 IObundle

SPDX-License-Identifier: MIT
-->

# IOB_ETH Linux Kernel Drivers
- Structure:
    - `drivers/`: directory with linux kernel module drivers for iob_eth
        - `iob_eth_main.c`: driver source
        - `iob_eth_driver_files.h` and `iob_eth_sysfs.h`: header files
        - `driver.mk`: makefile segment with `iob_eth-obj:` target for driver
          compilation
    - `user/`: directory with user application example that uses iob_eth
      drivers
        - `iob_eth_user.c`: user space application that uses iob_eth
          drivers. Example provided for some cores.
        - `Makefile`: user application compilation targets
    - `iob_eth.dts`: device tree template with iob_eth node
        - manually add the `iob_eth` node to the system device tree so the
          iob_eth is recognized by the linux kernel

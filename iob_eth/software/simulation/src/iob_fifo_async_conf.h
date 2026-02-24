/*
 * SPDX-FileCopyrightText: 2026 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#ifndef H_IOB_FIFO_ASYNC_CONF_H
#define H_IOB_FIFO_ASYNC_CONF_H

#define IOB_FIFO_ASYNC_W_DATA_W 21
#define IOB_FIFO_ASYNC_R_DATA_W 21
#define IOB_FIFO_ASYNC_ADDR_W 3
#define IOB_FIFO_ASYNC_BIG_ENDIAN 0
#define IOB_FIFO_ASYNC_MAXDATA_W iob_max(W_DATA_W, R_DATA_W)
#define IOB_FIFO_ASYNC_MINDATA_W iob_min(W_DATA_W, R_DATA_W)
#define IOB_FIFO_ASYNC_R MAXDATA_W / MINDATA_W
#define IOB_FIFO_ASYNC_MINADDR_W ADDR_W - $clog2(R)
#define IOB_FIFO_ASYNC_W_ADDR_W (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
#define IOB_FIFO_ASYNC_R_ADDR_W (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
#define IOB_FIFO_ASYNC_VERSION 0x0081

#endif // H_IOB_FIFO_ASYNC_CONF_H

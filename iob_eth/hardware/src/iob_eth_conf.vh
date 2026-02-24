// general_operation: General operation group
// Core Configuration Parameters Default Values
`define IOB_ETH_DATA_W 32
`define IOB_ETH_AXI_ID_W 1
`define IOB_ETH_AXI_ADDR_W 24
`define IOB_ETH_AXI_DATA_W 32
`define IOB_ETH_AXI_LEN_W 4
`define IOB_ETH_PHY_RST_CNT 20'hFFFFF
`define IOB_ETH_BD_NUM_LOG2 7
`define IOB_ETH_BUFFER_W 11
// Core Configuration Macros.
`define IOB_ETH_PREAMBLE 8'h55
`define IOB_ETH_PREAMBLE_LEN 7
`define IOB_ETH_SFD 8'hD5
`define IOB_ETH_MAC_ADDR_LEN 6
`define IOB_ETH_VERSION 16'h0001

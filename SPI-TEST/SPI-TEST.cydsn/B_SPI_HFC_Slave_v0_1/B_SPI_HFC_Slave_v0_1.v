/*******************************************************************************
* File Name:  B_SPI_HFC_Slave_v0_1.v
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  This file provides a base level model of the SPI Slave component
*
* Note:
*  None
********************************************************************************
*                 Control and Status Register definitions
********************************************************************************
*
*  Tx interrupt Status Register Definition
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  |  Bit  |   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  | Desc |interrupt|bt_cplt |unused  |unused  |unused  |tx_empty |tx_n_f |spi_done|
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+

*  Rx interrupt Status Register Definition
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  |  Bit  |   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  | Desc |interrupt|rx_full |rx_f_ovr|rx_f_e  |rx_n_e  | unused |unused  | unused |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*    spi_done  =>  0 = spi transmission not done
*                  1 = spi transmission done
*
*    tx_n_f    =>  0 = TX FIFO full
*                  1 = TX not full
*
*    tx_empty  =>  0 = TX_FIFO not empty
*                  1 = TX FIFO empty
*
*    rx_n_e    =>  0 =  RX FIFO empty
*                  1 =  RX FIFO not empty
*
*    rx_f_e    =>  0 = RX FIFO not empty
*                  1 = RX FIFO empty
*
*    rx_f_ovr  =>  0 = RX FIFO not overrun
*                  1 = RX FIFO overrun
*
*    rx_full   =>  0 = RX FIFO not full
*                  1 = RX FIFO full
*
*    bt_cplt   =>  0 = byte/word transfer is not complete
*                  1 = byte/word transfer complete
*
********************************************************************************
*                 Data Path register definitions
********************************************************************************
*  INSTANCE NAME:  DatapathName
*  DESCRIPTION:
*  REGISTER USAGE:
*    F0 => TX FIFO buffer
*    F1 => RX FIFO buffer
*    D0 => na
*    D1 => na
*    A0 => Current SPI Value(MISO data is shifted out, MOSI data is shifted in)
*    A1 => na
*
********************************************************************************
*               I*O Signals:
********************************************************************************
*  IO SIGNALS:
*
*    reset        input     component reset input
*    clock        input     component clock input
*    mosi         input     SPI MOSI input
*    sclk         input     SPI SCLK input
*    ss           input     SPI SS input
*    tx_enable    output    tx enable output(is used for Bidirectional Mode only)
*    miso         output    SPI MISO output
*    interrupt    output    interrupt output
*
********************************************************************************
* Copyright 2008-2015, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions,
* disclaimers, and limitations in the end user license agreement accompanying
* the software package with which this file was provided.
********************************************************************************/

`include "cypress.v"
`ifdef B_SPI_HFC_Slave_v0_1_V_ALREADY_INCLUDED
`else
`define B_SPI_HFC_Slave_v0_1_V_ALREADY_INCLUDED

module B_SPI_HFC_Slave_v0_1(
    input  wire  reset,         /* System Reset             */
    input  wire  clock,         /* System Clk - 2x Bit rate */
    input  wire  mosi,          /* SPI MOSI input           */
	input  wire  rde,           /* rx data effective        */
    input  wire  sclk,          /* SPI SCLK input           */
    input  wire  ss,            /* SPI SS input             */

    output  wire miso,          /* SPI MISO output                  */
    output  reg  tde,           /* tx data effective                */
    output  wire tx_interpt,    /* Status Register Interrupt output */
    output  wire rx_interpt,    /* Status Register Interrupt output */
    output  wire tx_drq,        /* tx DMA request                   */
    output  wire rx_drq         /* rx DMA request                   */
);
    /* bit order: default is MSb first (i.e Shift Left and ShiftLeft in static configuration is = 0) */
    /* DO NOT CHANGE these two parameters.  They define constants */
    localparam SPIS_MSB_FIRST = 1'b0;
    localparam SPIS_LSB_FIRST = 1'b1;

    /* Status register bits */
    localparam SPIS_STS_SPI_DONE_BIT            = 3'd0;
    localparam SPIS_STS_TX_BUFFER_NOT_FULL_BIT  = 3'd1;
    localparam SPIS_STS_TX_BUFFER_EMPTY_BIT     = 3'd2;
    localparam SPIS_STS_BYTE_COMPLETE_BIT       = 3'd6;
    localparam SPIS_STS_RX_BUFFER_NOT_EMPTY_BIT = 3'd3;
    localparam SPIS_STS_RX_BUFFER_EMPTY_BIT     = 3'd4;
    localparam SPIS_STS_RX_FIFO_OVERRUN_BIT     = 3'd5;
    localparam SPIS_STS_RX_FIFO_FULL_BIT        = 3'd6;

    /* Index for Bidirectional Mode Control Register bit */
    localparam CTRL_TX_PERMISSION = 1'b0;

    /* Counter initialization bit */
    localparam CTRL_CNT_INIT      = 1'b1;

    parameter [0:0] ShiftDir =  SPIS_MSB_FIRST;

    /* set to 2-8 bits only. Default is 8 bits */
    parameter [6:0] NumberOfDataBits = 7'd8;

    /* Default is rising edge mode */
    parameter [0:0] ModeCPHA         = 1'b0;
    parameter [0:0] ModePOL          = 1'b0;

    localparam [2:0] dp8MsbVal = (NumberOfDataBits % 8) - 3'd1;

    localparam [7:0] dpMask    = (NumberOfDataBits == 8) ? 8'd255 :
                                 (NumberOfDataBits == 7) ? 8'd127 :
                                 (NumberOfDataBits == 6) ? 8'd63  :
                                 (NumberOfDataBits == 5) ? 8'd31  :
                                 (NumberOfDataBits == 4) ? 8'd15  :
                                 (NumberOfDataBits == 3) ? 8'd7   :
                                 (NumberOfDataBits == 2) ? 8'd3   : 8'd0;

    /* This value get's truncated to 3 bits */
    localparam [2:0] dp16MsbVal = (NumberOfDataBits % 8) - 4'd9;

    localparam [7:0] dp16MOSIMask = (NumberOfDataBits == 16) ? 8'd255 :
                                    (NumberOfDataBits == 15) ? 8'd127 :
                                    (NumberOfDataBits == 14) ? 8'd63  :
                                    (NumberOfDataBits == 13) ? 8'd31  :
                                    (NumberOfDataBits == 12) ? 8'd15  :
                                    (NumberOfDataBits == 11) ? 8'd7  :
                                    (NumberOfDataBits == 10) ? 8'd3  :
                                    /*(NumberOfDataBits == 9)  ? */ 8'd1 ;

    localparam [1:0] dynShiftDir     = (ShiftDir == SPIS_MSB_FIRST) ? 2'd1 : 2'd2;
    localparam [1:0] dp16MSBSIChoice = (ShiftDir == SPIS_MSB_FIRST) ? `SC_SI_A_CHAIN : `SC_SI_A_ROUTE;
    localparam [1:0] dp16LSBSIChoice = (ShiftDir == SPIS_MSB_FIRST) ? `SC_SI_A_ROUTE : `SC_SI_A_CHAIN;

    /* RX FIFO is loaded on the negedge of SCLK */
    localparam f1_edge = `SC_FIFO_CLK1_NEG;

    /* Datapath selection local parameters */
    localparam SR8  = 8'd8;
    localparam SR16 = 8'd16;

    /* datapath configurations  */
    localparam dp8_config = {
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM0:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM1:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM2:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM3:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM4:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM5:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM6:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM7:      */
            dpMask, 8'hFF, /*CFG9:      */
            8'hFF, 8'hFF, /*CFG11-10:      */
            `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
            `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
            `SC_A_MASK_ENBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
            `SC_SI_A_ROUTE, /*CFG13-12:      */
            `SC_A0_SRC_ACC, ShiftDir, 1'h0,
            1'h0, `SC_FIFO1_ALU, `SC_FIFO0_BUS,
            `SC_MSB_ENBL, dp8MsbVal, `SC_MSB_NOCHN,
            `SC_FB_NOCHN, `SC_CMP1_NOCHN,
            `SC_CMP0_NOCHN, /*CFG15-14:      */
            3'h00, `SC_FIFO_SYNC__ADD, 4'h00, f1_edge, `SC_FIFO_CLK0_POS,
            `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,`SC_FIFO__EDGE,
            `SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,`SC_WRK16CAT_DSBL  /*CFG17-16:      */
        };

    localparam dp16_config_msb = {
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM0:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM1:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM2:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM3:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM4:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM5:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM6:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM7:      */
            dp16MOSIMask, 8'h00, /*CFG9:      */
            8'hFF, 8'hFF, /*CFG11-10:      */
            `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
            `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
            `SC_A_MASK_ENBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
            dp16MSBSIChoice, /*CFG13-12:      */
            `SC_A0_SRC_ACC, ShiftDir, 1'h0,
            1'h0, `SC_FIFO1_ALU, `SC_FIFO0_BUS,
            `SC_MSB_ENBL, dp16MsbVal, `SC_MSB_NOCHN,
            `SC_FB_NOCHN, `SC_CMP1_NOCHN,
            `SC_CMP0_NOCHN, /*CFG15-14:      */
            3'h00, `SC_FIFO_SYNC__ADD, 4'h00, f1_edge, `SC_FIFO_CLK0_POS,
            `SC_FIFO_CLK__DP, `SC_FIFO_CAP_AX,
            `SC_FIFO__EDGE, `SC_FIFO_ASYNC, `SC_EXTCRC_DSBL,
            `SC_WRK16CAT_DSBL  /*CFG17-16:      */
        };

    localparam dp16_config_lsb = {
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM0:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM1:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM2:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM3:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM4:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM5:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM6:      */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM7:      */
            8'hFF, 8'h00, /*CFG9:      */
            8'hFF, 8'hFF, /*CFG11-10:      */
            `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
            `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
            `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
            dp16LSBSIChoice, /*CFG13-12:      */
            `SC_A0_SRC_ACC, ShiftDir, 1'h0,
            1'h0, `SC_FIFO1_ALU, `SC_FIFO0_BUS,
            `SC_MSB_DSBL, `SC_MSB_BIT7, `SC_MSB_NOCHN,
            `SC_FB_NOCHN, `SC_CMP1_NOCHN,
            `SC_CMP0_NOCHN, /*CFG15-14:      */
            3'h00, `SC_FIFO_SYNC__ADD, 4'h00, f1_edge, `SC_FIFO_CLK0_POS,
            `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
            `SC_FIFO__EDGE, `SC_FIFO_ASYNC, `SC_EXTCRC_DSBL,
            `SC_WRK16CAT_DSBL  /*CFG17-16:      */
            };

    /* Status Register inputs from the PLD/DP's */
    wire [6:0] tx_status;
    wire [6:0] rx_status;

    /* Master Out Slave In from the Datapath.
    Selects between mosi_dp8 and mosi_dp16 based on NUM_BITS */
    wire miso_from_dp;
    /* One compare output of the counter which signals
    when to load received data into the FIFO */
    wire dpcounter_zero;
    /* "Counter is equal to '1' condition" output
    is used as "byte complete" condition*/
    wire dpcounter_one;
    /* counter output */
    wire [6:0] count;

    /* datapath si input*/
    wire mosi_to_dp;
    /* non-connected wires, used for connection convenience */
    wire nc1, nc2, nc3, nc4;
    /* TX and RX FIFO status outputs */
    wire dpMISO_fifo_not_empty;
    wire dpMISO_fifo_not_full;
    wire dpMISO_fifo_empty;
    wire dpMOSI_fifo_not_empty;
    wire dpMOSI_fifo_full;
    wire dpMOSI_fifo_empty;

    /* "clear on read" status input sources */
    wire mosi_buf_overrun;
    /* load RX FIFO (from counter) */
    wire load;

    /* Datapath and Counter7 clock */
    wire dp_clock;
    /* conditional 'shift out' wires for 16-bit datapath */
    wire mosi_from_dpL;
    wire mosi_from_dpR;
    wire cnt_reset = reset | ss;
    wire inv_ss    = ~ss;
    /*registered MOSI value*/
    reg mosi_tmp;
    reg dpcounter_one_reg;
    reg mosi_buf_overrun_fin;
    wire clock_fin;
    wire dpcounter_one_fin;
    wire miso_tx_empty_reg_fin;
    wire mosi_buf_overrun_reg;
    wire dpMOSI_fifo_full_reg;

    wire tx_load        = (ModeCPHA == 1'b0) ? load : dpcounter_zero;
    wire byte_complete  = dpcounter_one_fin & (~dpcounter_one_reg);
    wire rx_buf_overrun = mosi_buf_overrun_reg & (~mosi_buf_overrun_fin);
    wire prc_clk_src    = (((ModeCPHA == 0) && (ModePOL == 0)) || ((ModeCPHA == 1) && (ModePOL == 1))) ? sclk : ~sclk;
    wire dp_clk_src     = (((ModeCPHA == 0) && (ModePOL == 1)) || ((ModeCPHA == 1) && (ModePOL == 0))) ? sclk : ~sclk;
	wire prc_clk;

    cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE))
    ClkEn (
        .clock_in(clock),
        .enable(1'b1),
        .clock_out(clock_fin)
    );

    cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`FALSE))
    PrcClkEn (
        .clock_in(prc_clk_src),
        .enable(1'b1),
        .clock_out(prc_clk)
    );

    cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`FALSE))
    DpClkEn (
        .clock_in(dp_clk_src),
        .enable(1'b1),
        .clock_out(dp_clock)
    );

    cy_psoc3_sync sync_1(
        .sc_out(dpcounter_one_fin),
        .sc_in(dpcounter_one),
        .clock(clock_fin)
    );

    cy_psoc3_sync sync_2(
        .sc_out(miso_tx_empty_reg_fin),
        .sc_in(dpMISO_fifo_empty),
        .clock(clock_fin)
    );

    cy_psoc3_sync sync_3(
        .sc_out(mosi_buf_overrun_reg),
        .sc_in(mosi_buf_overrun),
        .clock(clock_fin)
    );

    cy_psoc3_sync sync_4(
        .sc_out(dpMOSI_fifo_full_reg),
        .sc_in(dpMOSI_fifo_full),
        .clock(clock_fin)
    );

    assign miso                  = (ss == 1'b0) ? miso_from_dp : 1'b0;
    assign dpMISO_fifo_not_empty = ~dpMISO_fifo_empty;
    assign mosi_buf_overrun      = load & dpMOSI_fifo_full;

    /* status register connections */
    assign tx_status[SPIS_STS_SPI_DONE_BIT]            = (byte_complete & miso_tx_empty_reg_fin);
    assign tx_status[SPIS_STS_TX_BUFFER_EMPTY_BIT]     = miso_tx_empty_reg_fin;
    assign tx_status[SPIS_STS_TX_BUFFER_NOT_FULL_BIT]  = dpMISO_fifo_not_full;
    assign tx_status[SPIS_STS_BYTE_COMPLETE_BIT]       = byte_complete;

    assign rx_status[SPIS_STS_RX_BUFFER_EMPTY_BIT]     = ~dpMOSI_fifo_not_empty;
    assign rx_status[SPIS_STS_RX_BUFFER_NOT_EMPTY_BIT] = dpMOSI_fifo_not_empty;
    assign rx_status[SPIS_STS_RX_FIFO_OVERRUN_BIT]     = rx_buf_overrun;
    assign rx_status[SPIS_STS_RX_FIFO_FULL_BIT]        = dpMOSI_fifo_full_reg;

    assign tx_status[5:3] = 3'h0;
    assign rx_status[2:0] = 3'h0;
	
	assign tx_drq = dpMISO_fifo_not_full;
	assign rx_drq = dpMOSI_fifo_not_empty;

    /* Determination of 'sclk_fin' polarity
    according to the ModePOL parameter value.
    If 'SS' is 'high' SCLK should be blocked */

    cy_psoc3_count7 #(.cy_period(NumberOfDataBits - 7'h1), .cy_route_ld(0), .cy_route_en(1))
    BitCounter(
        /* input          */ .clock(dp_clock),
        /* input          */ .reset(cnt_reset),
        /* input          */ .load(1'b0),
        /* input          */ .enable(inv_ss),
        /* output [06:00] */ .count(count),
        /* output         */ .tc()
        );

    assign dpcounter_zero = (count[3:0] == 4'h0);
    assign dpcounter_one  = (count[3:0] == 4'h1);
    assign load = (ModeCPHA == 1'b0) ? dpcounter_one : dpcounter_zero;

    cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h41), .cy_int_mask(7'h7F))
    TxStsReg(
        /* input         */  .clock(clock_fin),
        /* input [06:00] */  .status(tx_status),
        /* output        */  .interrupt(tx_interpt)
    );

    cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h20), .cy_int_mask(7'h7F))
    RxStsReg(
        /* input         */  .clock(clock_fin),
        /* input [06:00] */  .status(rx_status),
        /* output        */  .interrupt(rx_interpt)
    );


    always @(posedge clock_fin) begin
        dpcounter_one_reg    <= dpcounter_one_fin;
        mosi_buf_overrun_fin <= mosi_buf_overrun_reg;
    end

    always @(posedge prc_clk) begin
        mosi_tmp <= mosi;
    end
	
	always @(posedge dp_clock) begin
		if (inv_ss == 1'b1 && tx_load == 1'b1) begin
			tde <= dpMISO_fifo_empty;
		end
		else begin
			tde <= dpMISO_fifo_empty ? tde : 1'b0;
		end
	end

    /* Bypass input flip-flop on last received bit */
    assign mosi_to_dp = (load == 1'b1) ? mosi : mosi_tmp;
	
	wire load_rx;
	assign load_rx = (rde == 1'b0) ? load : 1'b0;

    generate
    if (NumberOfDataBits <= SR8) begin: sR8
        cy_psoc3_dp8 #(.cy_dpconfig_a(dp8_config))
        Dp(
            /*  input           */ .clk(dp_clock),
            /*  input           */ .reset(reset),
            /*  input   [02:00] */ .cs_addr({inv_ss, 1'b0, tx_load}),
            /*  input           */ .route_si(mosi_to_dp),
            /*  input           */ .route_ci(1'b0),
            /*  input           */ .f0_load(1'b0),
            /*  input           */ .f1_load(load_rx),
            /*  input           */ .d0_load(1'b0),
            /*  input           */ .d1_load(1'b0),
            /*  output          */ .ce0(),
            /*  output          */ .cl0(),
            /*  output          */ .z0(),
            /*  output          */ .ff0(),
            /*  output          */ .ce1(),
            /*  output          */ .cl1(),
            /*  output          */ .z1(),
            /*  output          */ .ff1(),
            /*  output          */ .ov_msb(),
            /*  output          */ .co_msb(),
            /*  output          */ .cmsb(),
            /*  output          */ .so(miso_from_dp),
            /*  output          */ .f0_bus_stat(dpMISO_fifo_not_full),
            /*  output          */ .f0_blk_stat(dpMISO_fifo_empty),
            /*  output          */ .f1_bus_stat(dpMOSI_fifo_not_empty),
            /*  output          */ .f1_blk_stat(dpMOSI_fifo_full)
        );
    end /* NumberOfDataBits <= 8 */
    else if (NumberOfDataBits <= SR16) begin : sR16 /* NumberOfDataBits > 8 */
        cy_psoc3_dp16 #(.cy_dpconfig_a(dp16_config_lsb), .cy_dpconfig_b(dp16_config_msb))
        Dp(
            /*  input         */  .clk(dp_clock),
            /*  input         */  .reset(reset),
            /*  input [02:00] */  .cs_addr({inv_ss, 1'b0, tx_load}),
            /*  input         */  .route_si(mosi_to_dp),
            /*  input         */  .route_ci(1'b0),
            /*  input         */  .f0_load(1'b0),
            /*  input         */  .f1_load(load_rx),
            /*  input         */  .d0_load(1'b0),
            /*  input         */  .d1_load(1'b0),
            /*  output        */  .ce0(),
            /*  output        */  .cl0(),
            /*  output        */  .z0(),
            /*  output        */  .ff0(),
            /*  output        */  .ce1(),
            /*  output        */  .cl1(),
            /*  output        */  .z1(),
            /*  output        */  .ff1(),
            /*  output        */  .ov_msb(),
            /*  output        */  .co_msb(),
            /*  output        */  .cmsb(),
            /*  output        */  .so({mosi_from_dpL, mosi_from_dpR}),
            /*  output        */  .f0_bus_stat({dpMISO_fifo_not_full, nc1}),
            /*  output        */  .f0_blk_stat({dpMISO_fifo_empty, nc2}),
            /*  output        */  .f1_bus_stat({dpMOSI_fifo_not_empty, nc3}),
            /*  output        */  .f1_blk_stat({dpMOSI_fifo_full, nc4})
        );

        assign miso_from_dp = (ShiftDir == SPIS_MSB_FIRST) ? mosi_from_dpL : mosi_from_dpR;

    end /* sR16 */
    endgenerate

endmodule
`endif /* B_SPI_HFC_Slave_v0_1_V_ALREADY_INCLUDED */


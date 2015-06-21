/*******************************************************************************
*
* FILENAME:  B_DMA_UART_v0_1.v
* COMPONENT NAME:   B_DMA_UART_v0_1
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  This file provides a top level model of the Base UART user module
*  defining the controller and datapath instances and all of the necessary
*  interconnect, for the RX and TX components individually.  This allows
*  for a lot of flexibility in how big the design can be and puts all of
*  the code in a single file for easy maintenance.
*
********************************************************************************
* Control and Status Register definitions
********************************************************************************
* Control Register Definition
*  +======+------+------+------+-------+-------+------+----------+--------+
*  |  Bit |  7   |  6   |  5   |   4   |   3   |   2  |   1      |   0    |
*  +======+------+------+------+-------+-------+------+----------+--------+
*  | Desc |ADDRM2|ADDRM1|ADDRM0|PARITY1|PARITY0| MARK |SEND_BREAK| HD_SEND|
*  +======+------+------+------+-------+-------+------+----------+--------+
*
*  HD_SEND      => Used for dynamically reconfiguration RX or TX operation in
*                  Half Duplex mode.
*                  0 = RX operation HD mode
*                  1 = TX operation HD mode
*  SEND_BREAK   => 1 = Sends Break signal in HD mode and release Parity bit
*                    for Break signal in TX mode.
*  MARK         => 0 = sets space(0) in Parity bit location.
*                  1 = sets mark(1) in Parity bit location.
*  PARITY0/1    => 0 = NONE
*                  1 = EVEN
*                  2 = ODD
*                  3 = MRKSPC
*  ADDRM0/1/2   => The RX address mode control is a 3-bit field used to define
*                  the expected hardware addressing operation.
*                  0 = NONE
*                  1 = SW_BYTE_BYTE
*                  2 = SW_DET_BUFFER
*                  3 = HW_BYTE_BYTE
*                  4 = HW_DET_BUFFER
*
********************************************************************************
*             TX Data Path register definitions
********************************************************************************
*
*  INSTANCE NAME:  dpTXShifter
*
*  DESCRIPTION:
*   Data Shifter for the TX portion of the UART.
*
*  REGISTER USAGE:
*   F0 => Data to be sent
*   F1 => Unused
*   D0 => Unused
*   D1 => Unused
*   A0 => Data as it is shifted out
*   A1 => Unused
*
* Data Path States
* (0bit generated on Count7/DP clock divider, 1,2Bit from Sate Machine)
*  0 0 0   0   Idle
*  0 0 1   1   Idle
*  0 1 0   2   Idle
*  0 1 1   3   Send Start Bit (F0 -> A0)
*  1 0 0   4   Idle
*  1 0 1   5   Send Data Bits (A0>>)
*  1 1 0   6   Idle
*  1 1 1   7   Idle (Send Parity/Stop Bits)
*
********************************************************************************
*
*  INSTANCE NAME:  dpTXBitClkGen
*
*  DESCRIPTION:
*   Bit Enable Generator for the TX implemented on Data Path.
*
*  REGISTER USAGE:
*   F0 => Unused
*   F1 => Unused
*   D0 => Bit length
*   D1 => Period
*   A0 => Counter
*   A1 => Unused
*
* Data Path States
*  0 0 0   0   Counter load (A0 = 0)
*  0 0 1   1   Count (A0++)
*
********************************************************************************
*             TX   7-Bit Counter Implementation Description
********************************************************************************
*
*  INSTANCE NAME:  TXBitCounter
*
*  DESCRIPTION:
*   Bit Enable Generator and Bit Counter rolled into a 7-Bit Counter.  Requires
*   a period of the number of bits (+1 for the start bit) times the oversample
*   rate of 8 or 16-bits.  It is required to use 8 or 16-bit oversampling
*   because the lower 3 or 4 bits of the counter are masked and compared to zero
*   to generate the bit enable.  Terminal count of the counter defines the end
*   of a packet before Parity and Stop Bits are sent.
*
*  REGISTER USAGE:
*   PERIOD => ((NumBits + 1) * (OverSample Rate)) - 1
*
********************************************************************************
*              RX  Data Path register definitions
********************************************************************************
*
*  INSTANCE NAME:  dpRXShifter
*
*  DESCRIPTION:
*    Data Shifter for the RX portion of the UART. Half Duplex mode is
*    implemented on this Data Path.
*
*  REGISTER USAGE:
*   F0 => Data just received
*   F1 => Data to be sent(Half duplex send)
*   D0 => Address 1
*   D1 => Address 2
*   A0 => Data as it is shifted in
*   A1 => Data as it is shifted out (Half duplex send)
*
* Data Path States
* (0bit generated on RXBitCounter clock divider, 1,2Bit from Sate Machine)
*  ADD  2 1  0 Bits cs_addr
*  0 0  0 0  X     Idle
*  RX Stages:
*  0 1  0 0  X     Check Start
*  0 0  0 1  0     Idle
*  0 0  0 1  1     Get Data Bits (A0>>)
*  1 0  0 0  X     Get Parity Bit
*  1 1  0 0  X     Check Stop Bit (A0 -> F0)
*  0 1  1 1  X     Check Break Signal (A1>> - does not take effect in RX mode)
*  TX Stage for Half Duplex mode(HD_SEND = 1):
*  0 0  1 0  0     Idle
*  0 0  1 0  1     Send Start Bit (F1 -> A1)
*  0 0  1 1  0     Idle
*  0 0  1 1  1     Send Data Bits (A1>>)
*  1 0  0 0  X     Send Parity Bit
*  0 1  1 1  X     Send Stop 1 Bit
*  0 1  0 0  X     Send Stop 2 Bit
*
********************************************************************************
*             RX   7-Bit Counter Implementation Description
********************************************************************************
*
*  INSTANCE NAME:  RXBitCounter
*
*  DESCRIPTION:
*   Bit Enable Generator and Bit Counter rolled into a 7-Bit Counter.
*
*  REGISTER USAGE:
*
********************************************************************************
* Copyright 2008-2015, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions,
* disclaimers, and limitations in the end user license agreement accompanying
* the software package with which this file was provided.
*******************************************************************************/


`include "cypress.v"
`ifdef B_DMA_UART_v0_1_V_ALREADY_INCLUDED
`else
`define B_DMA_UART_v0_1_V_ALREADY_INCLUDED
module B_DMA_UART_v0_1
(
    input   wire clock,         /* User Supplied Clock = 8x or 16x the bit-rate depends on OverSampleCount parameter */
    input   wire reset,         /* System Global Reset                      */
    input   wire rx,            /* Receive: Serial Data Input               */
    output  wire tx,            /* Transmit: Serial Data Output             */
    output  wire rx_interrupt,  /* Interrupt output from the RX section     */
    output  wire tx_interrupt,  /* Interrupt output from the TX section     */
	output  wire rx_drq,  		/* DMA request output from the RX section   */
    output  wire tx_drq,  		/* DMA request output from the TX section   */
    output  wire rts_n,         /* Request to send output for Flow control  */
    input   wire cts_n,         /* Clear to send input for Flow control     */
    output  reg tx_en,          /* Transmit Enable: Hardware control line output  */
    output  reg tx_data,        /* Transmit Data: shift out the TX data to a CRC component or other logic */
    output  reg tx_clk,         /* Transmit Clock: Provides clock edge used to shift out the TX data */
    output  reg rx_data,        /* Receive Data: shift out the RX data to a CRC component or other logic */
    output  reg rx_clk          /* Receive Clock: Provides clock edge used to shift out the RX data */
);


/*************************************************************************
*                   Parameters                                           *
*************************************************************************/

/* Constants for NumStopBits parameter */
localparam UART_NUM_STOP_BITS_1 = 2'd1;
localparam UART_NUM_STOP_BITS_2 = 2'd2;

/* Constants for OverSampleCount parameter */
localparam UART_OVER_SAMPLE_8   = 7'd8;
localparam UART_OVER_SAMPLE_16  = 7'd16;

/* Constants for ParityType parameter */
localparam UART_PARITY_TYPE_NONE   = 2'd0;
localparam UART_PARITY_TYPE_EVEN   = 2'd1;
localparam UART_PARITY_TYPE_ODD    = 2'd2;
localparam UART_PARITY_TYPE_MRKSPC = 2'd3;

/* Constants for RXAddressMode parameter */
localparam UART_RX_ADDR_MODE_NONE           = 3'd0;
localparam UART_RX_ADDR_MODE_SW_BYTE_BYTE   = 3'd1;
localparam UART_RX_ADDR_MODE_SW_DET_BUFFER  = 3'd2;
localparam UART_RX_ADDR_MODE_HW_BYTE_BYTE   = 3'd3;
localparam UART_RX_ADDR_MODE_HW_DET_BUFFER  = 3'd4;

localparam NUM_START_BITS                   = 4'd1;    /* UART alwas uses one start bit */
localparam NUM_C7_MAX_BITS_O16              = 4'd8;    /* max count for count7 at 16x oversample */
/* These parameters will set by the software */
parameter ParityType            = UART_PARITY_TYPE_NONE;    /* Set the Parity Type as Odd, Even or Mark/Space */
parameter ParityTypeSw          = 1'b0;         /* Makes Parity Type changeable by Control Register */
parameter FlowControl           = 1'b0;         /* Enable Flow Control Signals */
parameter HwTXEnSignal          = 1'b0;         /* Enable the external TX Enable Signal output */
parameter RXEnable              = 1'b1;         /* Enable RX portion of the UART */
parameter TXEnable              = 1'b1;         /* Enable TX portion of the UART */
parameter HalfDuplexEn          = 1'b0;         /* Enable Half Duplex mode: RX+TX portions on the RX only hardware */
parameter CRCoutputsEn          = 1'b0;         /* Enable CRC outputs */
parameter RXStatusIntEnable     = 1'b0;         /* Enable Interrupts from status register: not used */
parameter RXAddressMode         = UART_RX_ADDR_MODE_NONE;   /* Configure RX Hardware Address Detection Scheme */
parameter Address1              = 8'd0;         /* RX Hardware Address #1 */
parameter Address2              = 8'd0;         /* RX Hardware Address #2 */
parameter NumDataBits           = 4'd8;         /* Define the Number of Data Bits 5-9 */
parameter NumStopBits           = UART_NUM_STOP_BITS_1; /* Define the Number of Stop Bits 1-2*/
parameter OverSampleCount       = UART_OVER_SAMPLE_8;   /* Allows Oversampling of 8 or 16 */
parameter Use23Polling          = 1'b1;         /* Use 2 of 3 polling on the RX UART sampler */
parameter TXBitClkGenDP         = 1'b1;         /* Use datapath for clock generation if enabled, otherwise Count7 */
parameter BreakDetect           = 1'b0;         /* Enable Break Signal generation and detection */
parameter BreakBitsTX           = 7'd13;        /* Set Break signal length in bits for TX */
parameter BreakBitsRX           = 7'd13;        /* Set Break signal length in bits for RX */


/* Polling require to start sampling on 1 bits before */
localparam [3:0] HalfBitCounts = ((OverSampleCount / 4'd2) + (Use23Polling * 4'd1) - 4'd2);
/* Truncating NumDataBits. UART shifts max 8 bits, Mark/Space functionality working if 9 bits selected */
localparam [3:0] FinalNumDataBits = (NumDataBits > 8) ? 4'd8 : NumDataBits;
/* TX Count7 period: calculated always for oversample 8, enable input used for oversample 16 */
localparam [6:0] txperiod_init = ((FinalNumDataBits + NUM_START_BITS) * UART_OVER_SAMPLE_8) - 7'd1;
/* Init RX counter for break detect time, rewritten @ HD mode by LoadRx(Tx) Cofig API */
/* This parameter is increased on the 2 in 2 out of 3 mode to sample voting in the middle */
localparam [6:0] rxperiod_init = (OverSampleCount == UART_OVER_SAMPLE_8) ?
                ((BreakBitsRX + NUM_START_BITS) * OverSampleCount) + (HalfBitCounts - 1) :
                /* 7bit counter need one more bit for OverSampleCount=16 */
                ((NUM_C7_MAX_BITS_O16 - 1) * OverSampleCount) + (HalfBitCounts - 1);

/* need to use additional bit for count7 at 16x oversample*/
localparam rxperiod_cmp_need_one_bit = ((OverSampleCount == UART_OVER_SAMPLE_16) && (FinalNumDataBits > 6)) ?
                                        1'd1 : 1'd0;
/* This parameter used in RX State machine to define that all predefined data bits received */
localparam [6:0] rxperiod_cmp = (OverSampleCount == UART_OVER_SAMPLE_8) ?
                                                             BreakBitsRX + NUM_START_BITS - FinalNumDataBits :
                                /* for 16 OverSample*/
                                rxperiod_cmp_need_one_bit ? (NUM_C7_MAX_BITS_O16 - 1) * 2 - FinalNumDataBits
                                                          : (NUM_C7_MAX_BITS_O16 - 1) - FinalNumDataBits;

/* This parameter used in RX State machine to define that all predefined break bits detected */
localparam [6:0] rxbreak_cmp = (OverSampleCount == UART_OVER_SAMPLE_8) ? NUM_START_BITS :
                                /* Break at 16 OverSample always needs one more bit*/
                                (NUM_C7_MAX_BITS_O16 - 1) * 2 - BreakBitsRX + NUM_START_BITS;

/* This parameter used in TX State machine in HD mode to define that all predefined data bits received */
localparam [6:0] hd_txperiod_cmp = (OverSampleCount == UART_OVER_SAMPLE_8) ? BreakBitsTX - FinalNumDataBits :
                                /* for 16 OverSample*/
                                rxperiod_cmp_need_one_bit ? NUM_C7_MAX_BITS_O16 * 2 - FinalNumDataBits - NUM_START_BITS
                                                          : NUM_C7_MAX_BITS_O16 - FinalNumDataBits - NUM_START_BITS;

/* This parameter used in TX State machine in HD mode to define that all predefined break bits detected */
localparam [6:0] hd_tx_break_cmp = (OverSampleCount == UART_OVER_SAMPLE_8) ? NUM_START_BITS :
                                /* Break at 16 OverSample always needs one more bit*/
                                NUM_C7_MAX_BITS_O16 * 2 - BreakBitsTX;

/* Counter low position for compare */
localparam cl = (OverSampleCount == UART_OVER_SAMPLE_8) ? 3'd3 : 3'd4;

/* Control Register bit locations */
localparam UART_CTRL_HD_SEND                    = 3'd0;
localparam UART_CTRL_HD_SEND_BREAK              = 3'd1; /* HD_SEND_BREAK - sends break bits in HD mode*/
                  /* HD_SEND_BREAK - skip to send parity bit @ Break signal in Full Duplex mode*/
localparam UART_CTRL_MARK                       = 3'd2; /* 1 sets mark, 0 sets space */
localparam UART_CTRL_PARITYTYPE0                = 3'd3; /* Defines the type of parity implemented */
localparam UART_CTRL_PARITYTYPE1                = 3'd4; /* Defines the type of parity implemented */
localparam UART_CTRL_RXADDR_MODE0               = 3'd5;
localparam UART_CTRL_RXADDR_MODE1               = 3'd6;
localparam UART_CTRL_RXADDR_MODE2               = 3'd7;

localparam UART_RX_CTRL_ADDR_MODE_NONE          = 3'd0;
localparam UART_RX_CTRL_ADDR_MODE_SW_BYTE_BYTE  = 3'd1;
localparam UART_RX_CTRL_ADDR_MODE_SW_DET_BUFFER = 3'd2;
localparam UART_RX_CTRL_ADDR_MODE_HW_BYTE_BYTE  = 3'd3;
localparam UART_RX_CTRL_ADDR_MODE_HW_DET_BUFFER = 3'd4;


/***************************************************************************
*           Instantiation of udb_clock_enable primitive
****************************************************************************
* The udb_clock_enable primitive component allows to support clock enable
* mechanism and specify the intended synchronization behaviour for the clock
* result (operational clock).
* There is no need to reset or enable this component. In this case the
* udb_clock_enable is used only for synchronization. The resulted clock is
* always enabled.
*/
wire clock_op;         /* internal clock to drive the component         */
cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE)) ClkSync
(
    /* input  */    .clock_in(clock),
    /* input  */    .enable(1'b1),
    /* output */    .clock_out(clock_op)
);


/**************************************************************************
*               Control Register Implementation
**************************************************************************/
wire [7:0]  control;             /* UART Control Register */
generate
if(  ((ParityType == UART_PARITY_TYPE_MRKSPC) && TXEnable) ||
     ((ParityType != UART_PARITY_TYPE_NONE) && TXEnable && BreakDetect) || ParityTypeSw ||
     ((RXAddressMode != UART_RX_ADDR_MODE_NONE) && RXEnable) || HalfDuplexEn )
begin : sCR_SyncCtl
        cy_psoc3_control #(.cy_force_order(1), .cy_ctrl_mode_1(8'h0), .cy_ctrl_mode_0(8'hFF)) CtrlReg
        (
            /* input          */  .clock(clock_op),
            /* output [07:00] */  .control(control)
        );
end /* sCR_SyncCtl */
endgenerate


/**************************************************************************/
/* Reset signal synchronization for Count7 usage                          */
/**************************************************************************/
reg reset_reg;
always @(posedge clock_op)
begin
    reset_reg <= reset;
end

wire tx_hd_send_break =
        ((((ParityType != UART_PARITY_TYPE_NONE) || ParityTypeSw) && TXEnable && BreakDetect) || HalfDuplexEn) ?
        control[UART_CTRL_HD_SEND_BREAK] : 1'b0;

wire HalfDuplexSend = HalfDuplexEn ? control[UART_CTRL_HD_SEND] : 1'b0;
wire [1:0] FinalParityType = ParityTypeSw ?
                             {control[UART_CTRL_PARITYTYPE1], control[UART_CTRL_PARITYTYPE0]} : ParityType;

wire [2:0] FinalAddrMode = (RXAddressMode != UART_RX_ADDR_MODE_NONE) ?
            {control[UART_CTRL_RXADDR_MODE2], control[UART_CTRL_RXADDR_MODE1], control[UART_CTRL_RXADDR_MODE0]} :
            RXAddressMode;

reg tx_mark;
reg tx_ctrl_mark_last;
wire tx_ctrl_mark = ((ParityType == UART_PARITY_TYPE_MRKSPC) || ParityTypeSw) ? control[UART_CTRL_MARK] : 1'b0;


/**************************************************************************/
/* Reset signal for DP and Status Register is available from ES3 silicon  */
/* It is required to clear SR when direction changed in HD mode           */
/**************************************************************************/
reg HalfDuplexSend_last;
wire reset_sr = (HalfDuplexSend ^ HalfDuplexSend_last) | reset_reg;

if(HalfDuplexEn)
begin
    always @(posedge clock_op)
    begin
        HalfDuplexSend_last <= HalfDuplexSend;
    end
end


/**************************************************************************
* txn is the inverted version of tx. The default output for a UART should
* be one. In order to get a one value out at time zero when all flip-flops
* are initialized to zero, txn is registered and then inverted when driven
* to the pin.
**************************************************************************/
reg txn;
assign tx = ~txn;

/* interrupts implementation */

wire        tx_interrupt_out;
wire        rx_interrupt_out;
assign      tx_interrupt = TXEnable ? tx_interrupt_out : 1'b0;
assign      rx_interrupt = (RXEnable || HalfDuplexEn) ? rx_interrupt_out : 1'b0;

/* DMA implementation */

wire        tx_drq_out;
wire        rx_drq_out;
assign      tx_drq = TXEnable ? tx_drq_out : 1'b0;
assign      rx_drq = (RXEnable || HalfDuplexEn) ? rx_drq_out : 1'b0;

/**************************************************************************
*           UART TX Implementation                                        *
**************************************************************************/
generate
if (TXEnable == 1) begin : sTX

    wire [6:0]  tx_status;              /* Transmit portion of the UART Status Register */
    wire        tx_fifo_empty;          /* Transmitter FIFO Empty status line from FIFO -
                                           used for flow control of data ready to send */
    wire        tx_fifo_notfull;        /* Transmitter FIFO not full status line from FIFO -
                                           Firmware should check the status bit FIFO_FULL before writing more data */
    reg         tx_parity_bit;          /* Transmitter Parity Bit container (sent on TX during parity bit state) */
    reg         tx_bitclk;              /* 1/8 or 1/16 of system clock */
    wire        tx_bitclk_dp;
    wire        tx_counter_tc;          /* End of data shifting */
    wire        tx_counter_dp;
    wire        tx_bitclk_enable_pre;   /* Transmitter Enable (1/8 or 1/16 system clock) used for cs_addr[0]*/

    reg [2:0]   tx_state;               /* Transmit State Machine State Container */

    /* TX State Machine States: */
    localparam UART_TX_STATE_IDLE               = 3'd0;
    localparam UART_TX_STATE_SEND_START         = 3'd1;
    localparam UART_TX_STATE_SEND_DATA          = 3'd2;
    localparam UART_TX_STATE_SEND_PARITY        = 3'd3;
    localparam UART_TX_STATE_SEND_STOP1         = 3'd4;
    localparam UART_TX_STATE_SEND_STOP2         = 3'd7;
    localparam UART_TX_STATE_SEND_STOP          = (NumStopBits == UART_NUM_STOP_BITS_1) ?
                                                  UART_TX_STATE_SEND_STOP1 : UART_TX_STATE_SEND_STOP2;
    /* TX Shifter Datapath Configuration */
    localparam UART_TX_SHIFTER_DP_CONFIG =
    {
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM0: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM1: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM2: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM3: SEND START */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM4: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP___SR, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM5: SEND DATA (SR) */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM6: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM7: SEND LAST BIT(PARITY/STOP1/2) */
        8'hFF, 8'h00,    /*CFG9:  */
        8'hFF, 8'hFF,    /*CFG11-10:  */
        `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
        `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
        `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
        `SC_SI_A_DEFSI, /*CFG13-12:  */
        `SC_A0_SRC_ACC, `SC_SHIFT_SR, 1'h0,
        1'h0, `SC_FIFO1__A0, `SC_FIFO0_BUS,
        `SC_MSB_ENBL, `SC_MSB_BIT7, `SC_MSB_NOCHN,
        `SC_FB_NOCHN, `SC_CMP1_NOCHN,
        `SC_CMP0_NOCHN, /*CFG15-14:  */
        3'h00, `SC_FIFO_SYNC_NONE, 6'h00,
        `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
        `SC_FIFO__EDGE,`SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,
        `SC_WRK16CAT_DSBL /*CFG17-16:  */
    };

    /* TX Shifter Datapath */
    cy_psoc3_dp8 #(.cy_dpconfig_a(UART_TX_SHIFTER_DP_CONFIG)) TxShifter
    (
        /*  input                   */  .clk(clock_op),
        /*  input                   */  .reset(reset_reg),
        /*  input   [02:00]         */  .cs_addr({tx_state[1],tx_state[0],tx_bitclk_enable_pre}),
        /*  input                   */  .route_si(1'b0),
        /*  input                   */  .route_ci(1'b0),
        /*  input                   */  .f0_load(1'b0),
        /*  input                   */  .f1_load(1'b0),
        /*  input                   */  .d0_load(1'b0),
        /*  input                   */  .d1_load(1'b0),
        /*  output                  */  .ce0(),
        /*  output                  */  .cl0(),
        /*  output                  */  .z0(),
        /*  output                  */  .ff0(),
        /*  output                  */  .ce1(),
        /*  output                  */  .cl1(),
        /*  output                  */  .z1(),
        /*  output                  */  .ff1(),
        /*  output                  */  .ov_msb(),
        /*  output                  */  .co_msb(),
        /*  output                  */  .cmsb(),
        /*  output                  */  .so(tx_shift_out),
        /*  output                  */  .f0_bus_stat(tx_fifo_notfull),  /*FIFO is not full when bus_stat = 1;*/
        /*  output                  */  .f0_blk_stat(tx_fifo_empty),    /*FIFO is empty when blk_stat = 1;*/
        /*  output                  */  .f1_bus_stat(),
        /*  output                  */  .f1_blk_stat()
    );

    wire [6:0] txbitcount;
    wire tx_bitclk_half;
    wire tx_count7_enable;
    reg  clock2;                    /* 1/2 system clock for oversample*16 */

    /* 8x or 16x clock divider implemented on Count7 */
    if(TXBitClkGenDP == 0)
    begin : sCLOCK
        wire counter_load = (tx_state == UART_TX_STATE_IDLE) || (tx_bitclk && (tx_state == UART_TX_STATE_SEND_STOP));
        if( (OverSampleCount == UART_OVER_SAMPLE_16) )
        begin
            /* Count7 enable implementation to work on 1/2 system clock */
            always @(posedge clock_op)
            begin
                if(counter_load)
                begin
                    clock2 <= 1'b0;
                end
                else
                begin
                    clock2 <= !clock2;
                end
            end
            assign tx_count7_enable = clock2 | counter_load; /* EN must be high for LD effect */
            /* Generate tx_bitclk one clock cycle sooner in STOP bit state.
            *  This one clock cycle required to change state to START without time overhead
            */
            assign tx_bitclk_enable_pre =  (txbitcount[2:0] == 3'd0) && ((tx_state == UART_TX_STATE_SEND_STOP) ?
                                           (!tx_count7_enable) : (tx_count7_enable));
        end
        else
        begin
            assign tx_count7_enable =  1'b1;
            assign tx_bitclk_enable_pre = ((tx_state == UART_TX_STATE_SEND_STOP) ?
                                         (txbitcount[2:0] == 3'd1) : (txbitcount[2:0] == 3'd0));
        end

        cy_psoc3_count7 #(.cy_period(txperiod_init),.cy_route_ld(1),.cy_route_en(1)) TxBitCounter
        (
            /*  input             */  .clock(clock_op),
            /*  input             */  .reset(reset_reg),
            /*  input             */  .load(counter_load),
            /*  input             */  .enable(tx_count7_enable),
            /*  output  [06:00]   */  .count(txbitcount),
            /*  output            */  .tc(tx_counter_tc)
        );

        if(CRCoutputsEn)
        begin
            assign tx_bitclk_half = !txbitcount[2];   /* txbitcount[2:0] == 3'd2;*/
        end
    end
    /* 8x or 16x clock divider implemented on Datapath */
    else
    begin : sCLOCK
        wire [7:0] sc_out;
        wire counter_load_not = !((tx_state == UART_TX_STATE_IDLE) || (tx_bitclk_enable_pre &&
                                  (tx_state == UART_TX_STATE_SEND_STOP)));

        localparam [7:0] dpTXBitClkGenCmask0 = OverSampleCount - 1;

        /* TX Bit Clk Datapath Configuration */
        localparam UART_TX_BIT_CLK_DP_CONFIG =
        {
            `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM0: Counter load (A0 = 0)*/
            `CS_ALU_OP__INC, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM1:  Count (A0++)*/
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM2:  */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM3:  */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM4:  */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM5:  */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM6:  */
            `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
            `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
            `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
            `CS_CMP_SEL_CFGA, /*CFGRAM7:  */
              8'hFF, 8'h00,    /*CFG9:  */
              8'hFF, dpTXBitClkGenCmask0,    /*CFG11-10: dpTXBitClkGenCmask0 = OverSampleCount-1 */
            `SC_CMPB_A1_D1, `SC_CMPA_A0_D1, `SC_CI_B_ARITH,
            `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_ENBL,
            `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
            `SC_SI_A_DEFSI, /*CFG13-12:  */
            `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'h0,
            1'h0, `SC_FIFO1__A0, `SC_FIFO0__A0,
            `SC_MSB_ENBL, `SC_MSB_BIT7, `SC_MSB_NOCHN,
            `SC_FB_NOCHN, `SC_CMP1_NOCHN,
            `SC_CMP0_NOCHN, /*CFG15-14:  */
             10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
            `SC_FIFO__EDGE,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
            `SC_WRK16CAT_DSBL /*CFG17-16:  */
        };

        /* TX Bit Clk Datapath */
        cy_psoc3_dp #(.cy_dpconfig(UART_TX_BIT_CLK_DP_CONFIG)) TxBitClkGen
        (
            /*  input                   */  .clk(clock_op),
            /*  input                   */  .reset(reset_reg),
            /*  input   [02:00]         */  .cs_addr({2'b0,counter_load_not}),
            /*  input                   */  .route_si(1'b0),
            /*  input                   */  .route_ci(1'b0),
            /*  input                   */  .f0_load(1'b0),
            /*  input                   */  .f1_load(1'b0),
            /*  input                   */  .d0_load(1'b0),
            /*  input                   */  .d1_load(1'b0),
            /*  output                  */  .ce0_reg(tx_bitclk_dp),
            /*  output                  */  .cl0(),
            /*  output                  */  .z0(),
            /*  output                  */  .ff0(),
            /*  output                  */  .ce1_reg(tx_counter_dp),
            /*  output                  */  .cl1(),
            /*  output                  */  .z1(),
            /*  output                  */  .ff1(),
            /*  output                  */  .ov_msb(),
            /*  output                  */  .co_msb(),
            /*  output                  */  .cmsb(),
            /*  output                  */  .so(),
            /*  output                  */  .f0_bus_stat(),
            /*  output                  */  .f0_blk_stat(),
            /*  output                  */  .f1_bus_stat(),
            /*  output                  */  .f1_blk_stat(),

            /* input                    */  .ci(1'b0),     /* Carry in from previous stage */
            /* output                   */  .co(),         /* Carry out to next stage      */
            /* input                    */  .sir(1'b0),    /* Shift in from right side     */
            /* output                   */  .sor(),        /* Shift out to right side      */
            /* input                    */  .sil(1'b0),    /* Shift in from left side      */
            /* output                   */  .sol(),        /* Shift out to left side       */
            /* input                    */  .msbi(1'b0),   /* MSB chain in                 */
            /* output                   */  .msbo(),       /* MSB chain out                */
            /* input [01:00]            */  .cei(2'b0),    /* Compare equal in from prev stage     */
            /* output [01:00]           */  .ceo(),        /* Compare equal out to next stage      */
            /* input [01:00]            */  .cli(2'b0),    /* Compare less than in from prv stage  */
            /* output [01:00]           */  .clo(),        /* Compare less than out to next stage  */
            /* input [01:00]            */  .zi(2'b0),     /* Zero detect in from previous stage   */
            /* output [01:00]           */  .zo(),         /* Zero detect out to next stage        */
            /* input [01:00]            */  .fi(2'b0),     /* 0xFF detect in from previous stage   */
            /* output [01:00]           */  .fo(),         /* 0xFF detect out to next stage        */
            /* input [01:00]            */  .capi(2'b0),   /* Software capture from previous stage */
            /* output [01:00]           */  .capo(),       /* Software capture to next stage       */
            /* input                    */  .cfbi(1'b0),   /* CRC Feedback in from previous stage  */
            /* output                   */  .cfbo(),       /* CRC Feedback out to next stage       */
            /* input [07:00]            */  .pi(8'b0),     /* Parallel data port           */
            /* output [07:00]           */  .po(sc_out[7:0]) /* Parallel data port         */
        );
        assign tx_counter_tc = tx_counter_dp;
        assign tx_bitclk_enable_pre = tx_bitclk_dp;

        if(CRCoutputsEn)
        begin
            assign tx_bitclk_half  = sc_out[cl-1];
        end
    end

    /* TX Status Register bit locations */
    localparam UART_TX_STS_TX_COMPLETE          = 3'h0;
    localparam UART_TX_STS_TX_BUFF_EMPTY        = 3'h1;
    localparam UART_TX_STS_TX_FIFO_FULL         = 3'h2;
    localparam UART_TX_STS_TX_FIFO_NOT_FULL     = 3'h3;

    assign tx_status[6:4] = 3'b0;
    if(TXBitClkGenDP == 0)
    begin
      assign tx_status[UART_TX_STS_TX_COMPLETE] = tx_fifo_empty & tx_bitclk & (tx_state == UART_TX_STATE_SEND_STOP);
    end
    else
    begin
      assign tx_status[UART_TX_STS_TX_COMPLETE] = tx_fifo_empty & tx_bitclk_enable_pre &
                                                                  (tx_state == UART_TX_STATE_SEND_STOP);
    end
    assign tx_status[UART_TX_STS_TX_BUFF_EMPTY] = tx_fifo_empty;
    assign tx_status[UART_TX_STS_TX_FIFO_FULL] = !tx_fifo_notfull;
    assign tx_status[UART_TX_STS_TX_FIFO_NOT_FULL] = tx_fifo_notfull;


    /* Instantiate the status register and interrupt hook*/
    cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h01), .cy_int_mask(7'h7F)) TxSts
    (
        /* input          */  .clock(clock_op),
        /* input          */  .reset(reset_reg),
        /* input  [06:00] */  .status(tx_status),
        /* output         */  .interrupt(tx_interrupt_out)
    );
	
	assign tx_drq_out = tx_status[UART_TX_STS_TX_FIFO_NOT_FULL];

    /**************************************************************************/
    /* Registering tx_en for removing possible glitches                       */
    /**************************************************************************/
    always @(posedge clock_op)
    begin
        if(reset_reg)
        begin
            tx_en <= 1'b0;
        end
        else
        begin
            tx_en <= (HwTXEnSignal & (tx_state != UART_TX_STATE_IDLE)) ? 1'b1 : 1'b0;
        end
    end

    /* CRC outputs implementation
    * tx_clk and tx_data are synchronized to clock
    */
    if(CRCoutputsEn)
    begin
        always @(posedge clock_op)
        begin
            if((tx_state == UART_TX_STATE_SEND_DATA) & !reset_reg)
            begin
                tx_clk <= tx_bitclk_half;
                tx_data <= ~txn;
            end
            else
            begin
                tx_clk <= 1'b0;
                tx_data <= 1'b0;
            end
        end
    end

    always @(posedge clock_op)
    begin
        if(TXBitClkGenDP == 0)
        begin
            tx_bitclk <= tx_bitclk_enable_pre;
        end
        else
        /* Do not generate tx_bitclk in last STOP state. Use tx_bitclk_pre instead
        *  to change state to START without time overhead
        */
        begin
            tx_bitclk <= tx_bitclk_enable_pre && (tx_state != UART_TX_STATE_SEND_STOP);
        end

    end

    /* TX State machine*/
    always @(posedge clock_op)
    begin
        if(FinalParityType == UART_PARITY_TYPE_MRKSPC)
        begin
            tx_ctrl_mark_last <= tx_ctrl_mark;
            if(tx_ctrl_mark && !tx_ctrl_mark_last) /* Edge detector */
            begin
                tx_mark <= 1'b1;
            end
        end
        if(reset_reg)
        begin
            tx_state <= UART_TX_STATE_IDLE;
            txn <= 1'b0;
            tx_mark <= 1'b0;
        end
        else
        begin
            case(tx_state)
                UART_TX_STATE_IDLE:
                begin
                    txn <= 1'b0;
                    if(!(cts_n && FlowControl) && !tx_fifo_empty)
                    begin
                        tx_state <= UART_TX_STATE_SEND_START;
                    end
                end
                UART_TX_STATE_SEND_START:
                begin
                    txn <= 1'b1;
                    if(tx_bitclk)
                    begin
                        txn <= ~tx_shift_out;
                        if( (FinalParityType == UART_PARITY_TYPE_EVEN) || (FinalParityType == UART_PARITY_TYPE_ODD) )
                        begin
                            tx_parity_bit <= (FinalParityType == UART_PARITY_TYPE_ODD) ? 1 : 0;
                        end
                        tx_state <= UART_TX_STATE_SEND_DATA;
                    end
                end
                UART_TX_STATE_SEND_DATA:
                begin
                    if(tx_bitclk)
                    begin
                        if( (FinalParityType == UART_PARITY_TYPE_EVEN) || (FinalParityType == UART_PARITY_TYPE_ODD) )
                        begin
                            tx_parity_bit <= (tx_parity_bit ^ ~txn);
                        end
                        if(tx_counter_tc)
                        begin
                            if( ((FinalParityType == UART_PARITY_TYPE_EVEN) ||
                                 (FinalParityType == UART_PARITY_TYPE_ODD)) && !tx_hd_send_break )
                            begin
                                tx_state <= UART_TX_STATE_SEND_PARITY;
                                txn <= ~(tx_parity_bit ^ ~txn);    /* +last bit */
                            end
                            else if( (FinalParityType == UART_PARITY_TYPE_MRKSPC) && !tx_hd_send_break )
                            begin
                                tx_state <= UART_TX_STATE_SEND_PARITY;
                                txn <= ~tx_mark;
                                if(tx_mark)
                                begin
                                    tx_mark <= 1'b0;
                                end
                            end
                            else
                            begin
                                tx_state <= UART_TX_STATE_SEND_STOP1;
                                txn <= 1'b0;
                            end
                        end
                        else
                        begin
                            txn <= ~tx_shift_out;
                        end
                    end
                end
                UART_TX_STATE_SEND_PARITY:
                begin
                    if(tx_bitclk)
                    begin
                        tx_state <= UART_TX_STATE_SEND_STOP1;
                        txn <= 1'b0;
                    end
                end
                UART_TX_STATE_SEND_STOP1:
                begin
                /* Check tx_bitclk one clock cycle sooner in STOP bit state.
                *  This one clock cycle required to change state to START without time overhead
                */
                    if((TXBitClkGenDP == 0) ? tx_bitclk : tx_bitclk_enable_pre)
                    begin
                        if(NumStopBits == UART_NUM_STOP_BITS_1)
                        begin
                            if(!(cts_n && FlowControl) && !tx_fifo_empty)
                            begin
                                tx_state <= UART_TX_STATE_SEND_START;
                            end
                            else
                            begin
                                tx_state <= UART_TX_STATE_IDLE;
                            end
                        end
                        else
                        begin
                            tx_state <= UART_TX_STATE_SEND_STOP2;
                        end
                    end
                end
                UART_TX_STATE_SEND_STOP2:
                begin
                    if((TXBitClkGenDP == 0) ? tx_bitclk : tx_bitclk_enable_pre)
                    begin
                        if(!(cts_n && FlowControl) && !tx_fifo_empty)
                        begin
                            tx_state <= UART_TX_STATE_SEND_START;
                        end
                        else
                        begin
                            tx_state <= UART_TX_STATE_IDLE;
                        end
                    end
                end
            endcase
        end /* end of else statement */
    end /* End of always block */
end /* End of TXEnable Generate Statement */
endgenerate /* sTX */


/**************************************************************
*               UART RX Implementation                        *
*       HALF DUPLEX mode implemented within RX                *
**************************************************************/

/* RX Controller Logic */
generate
if (RXEnable || HalfDuplexEn)
begin:sRX
    wire [6:0]  rx_status;                  /* Receive portion of the UART Status Register */
    reg  [3:0]  rx_state;                   /* Receive State Machine State Container */
    reg         rx_parity_bit;
    reg         rx_markspace_pre;
    reg         rx_markspace_status;
    reg         rx_address_detected;        /* used in ADDR_MODE_HW_ mode for skip not addressed data */
    reg         rx_parity_error_pre;        /* need for delay parity error to byte received interrupt */
    reg         rx_parity_error_status;
    reg         rx_break_status;
    reg         rx_addr_match_status;
    reg         rx_stop_bit_error;
    reg         rx_break_detect;
    reg         rx_last;                    /* used for start bit falling edge detection */
    wire        rx_postpoll;
    reg         rx_load_fifo;
    wire        rx_fifofull;
    wire        rx_fifonotempty;
    wire        rx_addressmatch1;
    wire        rx_addressmatch2;
    wire [6:0]  rx_count;
    wire        rx_counter_load;
    wire        rx_bitclk_pre;
    reg         rx_bitclk;
    reg         rx_state_stop1_reg;
    /* Additional bit for count7 at 16xOverSample */
    wire        rx_count7_tc;
    reg         rx_count7_bit8;
    wire        rx_count7_bit8_wire;
    wire        rx_bitclk_pre16x;
    wire        rx_bitclk_enable;

    wire        rx_poll_bit1;
    wire        rx_poll_bit2;

    /* One address supported in Half duplex mode */
    wire        rx_addressmatch =  HalfDuplexEn ? rx_addressmatch1 : (rx_addressmatch1 | rx_addressmatch2);


    /* RX State Machine States: */
    /* Two low bits go to DP cs_addr[2,1] */
    localparam UART_RX_STATE_IDLE           = 4'h00;
    localparam UART_RX_STATE_CHECK_START    = 4'h04;
    localparam UART_RX_STATE_GET_DATA       = 4'h01;
    localparam UART_RX_STATE_GET_PARITY     = 4'h08;
    localparam UART_RX_STATE_CHECK_STOP1    = 4'h0C;
    localparam UART_RX_STATE_CHECK_BREAK    = 4'h07;
    localparam UART_HD_STATE_SEND_START     = 4'h02;
    localparam UART_HD_STATE_SEND_DATA      = 4'h03;
    localparam UART_HD_STATE_SEND_PARITY    = UART_RX_STATE_GET_PARITY;
    localparam UART_HD_STATE_SEND_STOP1     = UART_RX_STATE_CHECK_BREAK;
    localparam UART_HD_STATE_SEND_STOP2     = UART_RX_STATE_CHECK_START;
    localparam UART_HD_STATE_SEND_STOP      = (NumStopBits == UART_NUM_STOP_BITS_1) ?
                                                  UART_HD_STATE_SEND_STOP1 : UART_HD_STATE_SEND_STOP2;

    localparam [2:0] rxmsbsel = (FinalNumDataBits == 8) ? 3'd7 :
                                (FinalNumDataBits == 7) ? 3'd6 :
                                (FinalNumDataBits == 6) ? 3'd5 :
                              /*(FinalNumDataBits == 5)*/ 3'd4;
    localparam [7:0] addressMask = (FinalNumDataBits == 8) ? 8'hFF :
                                (FinalNumDataBits == 7) ? 8'h7F :
                                (FinalNumDataBits == 6) ? 8'h3F :
                              /*(FinalNumDataBits == 5)*/ 8'h1F;
    localparam [7:0] dataMask = (FinalNumDataBits == 8) ? 8'hFF :
                                (FinalNumDataBits == 7) ? 8'h7F :
                                (FinalNumDataBits == 6) ? 8'h3F :
                              /*(FinalNumDataBits == 5)*/ 8'h1F;

    /* RX Shifter Datapath Configuration */
    localparam UART_RX_SHIFTER_DP_CONFIG =
    {
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM0: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM1: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM2: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP___SR, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM3: GET DATA (SR) */
        `CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM4: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC___F1,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM5: SEND START */
        `CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM6: IDLE */
        `CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
        `CS_SHFT_OP___SR, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CFGRAM7: SEND DATA (SR) */
        dataMask, 8'h00,    /*CFG9:  */
        8'hFF, addressMask,    /*CFG11-10:  */
        `SC_CMPB_A0_D1, `SC_CMPA_A0_D1, `SC_CI_B_ARITH,
        `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_ENBL,
        `SC_A_MASK_ENBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
        `SC_SI_A_ROUTE, /*CFG13-12: CMP A0 -D1 */
        `SC_A0_SRC_ACC, `SC_SHIFT_SR, 1'h0,
        1'h0, `SC_FIFO1_BUS, `SC_FIFO0__A0,
        `SC_MSB_ENBL, rxmsbsel, `SC_MSB_NOCHN,
        `SC_FB_NOCHN, `SC_CMP1_NOCHN,
        `SC_CMP0_NOCHN, /*CFG15-14:  */
        3'h00, `SC_FIFO_SYNC_NONE, 6'h00,
        `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
        `SC_FIFO__EDGE,`SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,
        `SC_WRK16CAT_DSBL /*CFG17-16:  */
    };

    cy_psoc3_dp8 #(.cy_dpconfig_a(UART_RX_SHIFTER_DP_CONFIG)) RxShifter
    (
        /*  input           */  .clk(clock_op),
        /*  input           */  .reset(reset_reg),
        /*  input   [02:00] */  .cs_addr({rx_state[1],rx_state[0],rx_bitclk_enable}),
        /*  input           */  .route_si(rx_postpoll),
        /*  input           */  .route_ci(1'b0),
        /*  input           */  .f0_load(rx_load_fifo),
        /*  input           */  .f1_load(1'b0),
        /*  input           */  .d0_load(1'b0),
        /*  input           */  .d1_load(1'b0),
        /*  output          */  .ce0(rx_addressmatch1),
        /*  output          */  .cl0(),
        /*  output          */  .z0(),
        /*  output          */  .ff0(),
        /*  output          */  .ce1(rx_addressmatch2),
        /*  output          */  .cl1(),
        /*  output          */  .z1(),
        /*  output          */  .ff1(),
        /*  output          */  .ov_msb(),
        /*  output          */  .co_msb(),
        /*  output          */  .cmsb(),
        /*  output          */  .so(hd_shift_out),
        /*  output          */  .f0_bus_stat(rx_fifonotempty),    /* FIFO is not EMPTY */
        /*  output          */  .f0_blk_stat(rx_fifofull),        /* FIFO is FULL */
        /*  output          */  .f1_bus_stat(hd_tx_fifo_notfull), /* FIFO is not full when bus_stat = 1; */
        /*  output          */  .f1_blk_stat(hd_tx_fifo_empty)    /* FIFO is empty when blk_stat = 1; */
    );

    if(HalfDuplexEn)
    begin
        assign rx_counter_load = (rx_state == UART_RX_STATE_IDLE) || 
                                 (HalfDuplexSend & rx_bitclk & (rx_state == UART_HD_STATE_SEND_STOP));
        /* Generate rx_bitclk one clock cycle sooner in HD STOP bit state.
        *  This one clock cycle required to change state to START without time overhead
        */
        assign rx_bitclk_pre = ((rx_state == UART_HD_STATE_SEND_STOP) & HalfDuplexSend) ? (rx_count[cl-1:0] == 4'd1) : 
                                                                                          (rx_count[cl-1:0] == 4'd0);
    end
    else
    begin
        assign rx_counter_load = (rx_state == UART_RX_STATE_IDLE);
        assign rx_bitclk_pre = (rx_count[cl-1:0] == 4'd0);
    end                         

    assign rx_bitclk_pre16x = (rx_count[cl-1:0] == (HalfBitCounts)) ? 1'b1 : 1'b0;

    cy_psoc3_count7 #(.cy_period(rxperiod_init),.cy_route_ld(1),.cy_route_en(1)) RxBitCounter
    (
        /*  input             */  .clock(clock_op),
        /*  input             */  .reset(reset_reg),
        /*  input             */  .load(rx_counter_load),
        /*  input             */  .enable(1),
        /*  output    [06:00] */  .count(rx_count),
        /*  output            */  .tc(rx_count7_tc)
    );

    assign rx_count7_bit8_wire = (OverSampleCount == UART_OVER_SAMPLE_16) ? rx_count7_bit8 : 1'd0;
    assign rx_bitclk_enable = !HalfDuplexSend ? rx_bitclk : rx_bitclk_pre;

    always @(posedge clock_op)
    begin
        if( (OverSampleCount == UART_OVER_SAMPLE_16) && rx_count7_bit8 && !HalfDuplexSend)
        begin
            rx_bitclk <= rx_bitclk_pre16x; /* Count7 reloaded to start value and we don't need to skip half bit*/
        end
        else
        begin
            rx_bitclk <= rx_bitclk_pre;
        end
        rx_state_stop1_reg <= (rx_state != UART_RX_STATE_CHECK_STOP1);
    end

    /* This state machine counts only first two voting, the third goes directly from rx line */
    if(Use23Polling)
    begin : s23Poll
        reg [1:0] pollcount;
        wire      pollingrange;

        assign rx_poll_bit1 = rx_count7_bit8_wire ?
                    ((rx_count[cl-1:0] == (HalfBitCounts + 4'd1)) ? 1'b1 : 1'b0) :
                    ((rx_count[cl-1:0] == 4'd1) ? 1'b1 : 1'b0);
        assign rx_poll_bit2 = rx_count7_bit8_wire ? rx_bitclk_pre16x : rx_bitclk_pre;
        assign pollingrange = rx_poll_bit1 | rx_poll_bit2;

        always @(posedge clock_op)
        begin
            if(reset_reg)
            begin
                pollcount <= 2'd0;
            end
            else
            begin
                if(pollingrange)
                begin
                    if(rx)
                    begin
                        pollcount <= pollcount + 2'd1;
                    end
                end
                else
                begin
                    pollcount <= 2'd0;
                end
            end
        end
        assign rx_postpoll = (pollcount < 2'd1) ? 1'b0 : ((pollcount < 2'd2) ? rx : 1'b1);
    end
    else
    begin
        assign rx_postpoll = rx;
    end /* Use23Polling */


    /* RX Status Register bit locations */
    localparam UART_RX_STS_MRKSPC           = 3'd0;
    localparam UART_RX_STS_BREAK            = 3'd1;
    localparam UART_RX_STS_PAR_ERROR        = 3'd2;
    localparam UART_RX_STS_STOP_ERROR       = 3'd3;
    localparam UART_RX_STS_OVERRUN          = 3'd4;
    localparam UART_RX_STS_FIFO_NOTEMPTY    = 3'd5;
    localparam UART_RX_STS_ADDR_MATCH       = 3'd6;

    /* Address Modes define when this bit is set */
    /* Address Mode 00 = Software Byte by Byte - Generate Interrupt when address byte detected */
    /* Address Mode 01 = Software Address To Buffer - Generate Interrupt when Address byte detected */
    /* Address mode 10 = Hardware Byte by Byte - Generate Interrupt when address byte is detected and matches
                            one of the addresses */
    /* Address mode 10 = Hardware Address To Buffer - Generate Interrupt when address byte is detected and matches
                            one of the addresses */
    /* BE NOTE: Adress2 not used in Half duplex mode as 6 only outputs per DP available */
    if(HalfDuplexEn)
    begin
        /*UART_RX_STS_MRKSPC for RX or
        UART_TX_STS_TX_COMPLETE for TX - generated at the end of Stop Bit */
        assign rx_status[UART_RX_STS_MRKSPC] = HalfDuplexSend ? hd_tx_fifo_empty & rx_bitclk &
                                ((NumStopBits == UART_NUM_STOP_BITS_1) ? (rx_state == UART_HD_STATE_SEND_STOP1) :
                                                                        (rx_state == UART_HD_STATE_SEND_STOP2)) :
                        (FinalAddrMode == UART_RX_ADDR_MODE_NONE) ? (1'b0) : rx_markspace_status;
        /*UART_RX_STS_BREAK for RX or           Break detect
        UART_TX_STS_TX_BUFF_EMPTY for TX*/
        assign rx_status[UART_RX_STS_BREAK] = HalfDuplexSend ? hd_tx_fifo_empty : BreakDetect ? rx_break_status : 1'b0 ;
        /*UART_RX_STS_PAR_ERROR for RX          Parity Error */
        assign rx_status[UART_RX_STS_PAR_ERROR] = rx_parity_error_status;
        /*UART_RX_STS_STOP_ERROR for RX or      Framing error
        UART_TX_STS_TX_FIFO_NOT_FULL for TX*/
        assign rx_status[UART_RX_STS_STOP_ERROR] = rx_stop_bit_error;
        assign rx_status[UART_RX_STS_OVERRUN] = rx_fifofull & rx_load_fifo;
        /* FIFO_NOTEMPTY delayed to synchronize with errors for RX
        UART_TX_STS_TX_FIFO_FULL for TX*/
        assign rx_status[UART_RX_STS_FIFO_NOTEMPTY] = HalfDuplexSend ? !hd_tx_fifo_notfull :
                                                      rx_fifonotempty & rx_state_stop1_reg;
        assign rx_status[UART_RX_STS_ADDR_MATCH] =
                                        (FinalAddrMode  == UART_RX_ADDR_MODE_NONE) ? 1'b0 : rx_addr_match_status;

        /**************************************************************************/
        /* Registering tx_en for removing possible glitches                       */
        /**************************************************************************/
        always @(posedge clock_op)
        begin
            if(reset_reg)
            begin
                tx_en <= 1'b0;
            end
            else
            begin
                tx_en <= ( HwTXEnSignal && HalfDuplexSend && (rx_state != UART_RX_STATE_IDLE)) ? 1'b1 : 1'b0;
            end
        end

        /* TX CRC outputs implementation
        *  tx_clk and tx_data are synchronized to clock
        */
        if(CRCoutputsEn)
        begin
            always @(posedge clock_op)
            begin
                if((rx_state == UART_HD_STATE_SEND_DATA) & !reset_reg)
                begin
                    tx_clk <= (rx_count[cl-1:0] == ((OverSampleCount / 4'd2) - 4'd2));
                    tx_data <= ~txn;
                end
                else
                begin
                    tx_clk <= 1'b0;
                    tx_data <= 1'b0;
                end
            end
        end
    end
    else
    begin
        assign rx_status[UART_RX_STS_MRKSPC] =  (FinalAddrMode == UART_RX_ADDR_MODE_NONE) ? (1'b0) :
                                                rx_markspace_status;
        assign rx_status[UART_RX_STS_BREAK] = BreakDetect ? rx_break_status : 1'b0 ;/* Break detect  */
        assign rx_status[UART_RX_STS_PAR_ERROR] = rx_parity_error_status;           /* Parity Error  */
        assign rx_status[UART_RX_STS_STOP_ERROR] = rx_stop_bit_error;               /* Framing Error */
        assign rx_status[UART_RX_STS_OVERRUN] = rx_fifofull & rx_load_fifo;
        /* FIFO_NOTEMPTY delayed to synchronize with errors*/
        assign rx_status[UART_RX_STS_FIFO_NOTEMPTY] = rx_fifonotempty & rx_state_stop1_reg;
        assign rx_status[UART_RX_STS_ADDR_MATCH] =
                                        (FinalAddrMode  == UART_RX_ADDR_MODE_NONE) ? 1'b0 : rx_addr_match_status;
    end

    assign rts_n = rx_fifofull;

    /* RX CRC outputs implementation
    *  rx_clk and rx_data are synchronized to clock
    */
    if(CRCoutputsEn)
    begin
        always @(posedge clock_op)
        begin
            if((rx_state == UART_RX_STATE_GET_DATA) & !reset_reg)
            begin

                rx_clk <= Use23Polling ? rx_poll_bit2 : rx_bitclk;
                rx_data <= rx;
            end
            else
            begin
                rx_clk <= 1'b0;
                rx_data <= 1'b0;
            end
        end
    end

    /* Instantiate the status register and interrupt hook */
    cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h5F), .cy_int_mask(7'h7F)) RxSts
    (
        /* input          */  .clock(clock_op),
        /* input          */  .reset(HalfDuplexEn ? reset_sr : reset_reg),
        /* input  [06:00] */  .status(rx_status),
        /* output         */  .interrupt(rx_interrupt_out)
    );
	
	assign rx_drq_out = rx_status[UART_RX_STS_FIFO_NOTEMPTY];

    /* RX State Machine */
    always @(posedge clock_op)
    begin
        if(HalfDuplexEn && (FinalParityType == UART_PARITY_TYPE_MRKSPC))
        begin
            tx_ctrl_mark_last <= tx_ctrl_mark;
            if(tx_ctrl_mark && !tx_ctrl_mark_last) /* Edge detector */
            begin
                tx_mark <= 1'b1;
            end
        end

        rx_addr_match_status <= 1'b0;
        rx_stop_bit_error <= 1'b0;
        rx_markspace_status <= 1'b0;
        rx_parity_error_status <= 1'b0;
        rx_break_status <= 1'b0;
        rx_load_fifo <= 1'b0;

        if(reset_reg)
        begin
            rx_state <= UART_RX_STATE_IDLE;
            rx_last <= 1'b0;
            rx_address_detected <= 1'b0;
            if(HalfDuplexEn)
            begin
                tx_mark <= 1'b0;
                txn <= 1'b0;
            end
            if(OverSampleCount==UART_OVER_SAMPLE_16)
            begin
                rx_count7_bit8 <= 1'b0;
            end
        end
        else
        begin
            rx_last <= rx;
            if( (OverSampleCount == UART_OVER_SAMPLE_16) && !rx_count7_bit8 )
            begin
                if(rx_count7_tc)
                begin
                    rx_count7_bit8 <= 1;
                end
            end

            case(rx_state)
                UART_RX_STATE_IDLE:
                begin
                    if(OverSampleCount == UART_OVER_SAMPLE_16)
                    begin
                        rx_count7_bit8 <= 0;
                    end
                    if(HalfDuplexEn)
                    begin
                        txn <= 1'b0;
                    end
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        if(!(cts_n && FlowControl) && !hd_tx_fifo_empty)
                        begin
                            rx_state <= UART_HD_STATE_SEND_START;
                        end
                    end
                    else if(~rx & rx_last) /* RX falling edge detection */
                    begin
                        rx_state <= UART_RX_STATE_CHECK_START;
                    end
                end
                UART_RX_STATE_CHECK_START: /* Check the start bit after 4 cycles */
                begin
                    /*UART_HD_STATE_SEND_STOP2 in Half duplex mode*/
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        if(rx_bitclk)
                        begin
                            if(!(cts_n && FlowControl) && !hd_tx_fifo_empty)
                            begin
                                if(OverSampleCount == UART_OVER_SAMPLE_16)
                                begin
                                    rx_count7_bit8 <= 0;
                                end
                                rx_state <= UART_HD_STATE_SEND_START;
                            end
                            else
                            begin
                                rx_state <= UART_RX_STATE_IDLE;
                            end
                        end
                    end
                    else if(rx_bitclk)
                    begin
                        if(rx_postpoll)
                        begin
                            rx_state <= UART_RX_STATE_IDLE;
                        end
                        else
                        begin
                            rx_state <= UART_RX_STATE_GET_DATA;
                            /* init status*/
                            if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                                (FinalParityType == UART_PARITY_TYPE_ODD) )
                            begin
                                rx_parity_bit <= (FinalParityType == UART_PARITY_TYPE_ODD) ? 1 : 0;
                                rx_parity_error_pre <= 1'b0;
                            end
                            if(BreakDetect)
                            begin
                                rx_break_detect <= 1'b0;
                                rx_break_status <= 1'b0;
                            end
                            if( (FinalParityType == UART_PARITY_TYPE_MRKSPC) ||
                                (FinalAddrMode != UART_RX_ADDR_MODE_NONE) )
                            begin
                                rx_markspace_pre <= 1'b0;
                            end
                            rx_stop_bit_error <= 1'b0;
                        end
                    end
                end
                UART_RX_STATE_GET_DATA:  /* Get the data bits */
                begin
                    if(rx_bitclk)
                    begin
                        if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                            (FinalParityType == UART_PARITY_TYPE_ODD) )
                        begin
                            rx_parity_bit <= rx_parity_bit ^ rx_postpoll;
                        end
                        if(BreakDetect)
                        begin
                            rx_break_detect <= rx_break_detect | rx_postpoll;
                        end
                    end
                    if( rxperiod_cmp_need_one_bit && !rx_count7_bit8_wire )
                    begin
                        rx_state <= UART_RX_STATE_GET_DATA; /* wait on next count7 turn */
                    end
                    else if(rx_count[6:cl] < rxperiod_cmp)
                    begin
                        if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                            (FinalParityType == UART_PARITY_TYPE_ODD)  ||
                            (FinalParityType == UART_PARITY_TYPE_MRKSPC) )
                        begin
                            rx_state <= UART_RX_STATE_GET_PARITY;
                        end
                        else
                        begin
                            rx_state <= UART_RX_STATE_CHECK_STOP1;
                            rx_load_fifo <= 1'b1;
                        end
                    end
                end
                UART_RX_STATE_GET_PARITY:
                begin
                    /*UART_HD_STATE_SEND_PARITY in Half duplex mode*/
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        if(rx_bitclk)
                        begin
                            txn <= 1'b0;
                            rx_state <= UART_HD_STATE_SEND_STOP1;
                        end
                    end
                    else if(rx_bitclk)
                    begin
                        if(BreakDetect)
                        begin
                            rx_break_detect <= rx_break_detect | rx_postpoll;
                        end
                        if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                            (FinalParityType == UART_PARITY_TYPE_ODD) )
                        begin
                            if(rx_postpoll != rx_parity_bit)
                            begin
                                rx_parity_error_pre <= 1'b1;
                            end
                        end

                        if( (FinalParityType == UART_PARITY_TYPE_MRKSPC) ||
                            (FinalAddrMode != UART_RX_ADDR_MODE_NONE) )
                        begin
                            rx_markspace_pre <= rx_postpoll;
                            if( (FinalAddrMode == UART_RX_ADDR_MODE_HW_DET_BUFFER) ||
                                (FinalAddrMode == UART_RX_ADDR_MODE_HW_BYTE_BYTE) )
                            begin
                                if(rx_postpoll) /* Address byte received */
                                begin
                                    rx_address_detected <= rx_addressmatch;
                                    if( (FinalAddrMode == UART_RX_ADDR_MODE_HW_BYTE_BYTE) & rx_addressmatch)
                                    begin           /* Address is correct - store it for Byte_Byte mode*/
                                        rx_state <= UART_RX_STATE_CHECK_STOP1;
                                        rx_load_fifo <= 1'b1;
                                    end
                                    else    /* Skip not correct address byte or in DET_BUFFER mode*/
                                    begin
                                        rx_state <= UART_RX_STATE_IDLE;
                                    end
                                end
                                else    /* Data byte received*/
                                begin
                                    if(rx_address_detected) /* Store data only when correct Addres received */
                                    begin
                                        rx_state <= UART_RX_STATE_CHECK_STOP1;
                                        rx_load_fifo <= 1'b1;
                                    end
                                    else                /* Skip not addresed data */
                                    begin
                                        rx_state <= UART_RX_STATE_IDLE;
                                    end
                                end
                            end
                            else
                            begin
                                rx_state <= UART_RX_STATE_CHECK_STOP1;
                                rx_load_fifo <= 1'b1;
                            end
                        end
                        else
                        begin
                            rx_state <= UART_RX_STATE_CHECK_STOP1;
                            rx_load_fifo <= 1'b1;
                        end
                    end
                end    /* UART_RX_STATE_GET_PARITY*/
                UART_RX_STATE_CHECK_STOP1:
                begin
                    /* prepare clear on read errors one clock ahead */
                    if(rx_bitclk)
                    begin
                        if(FinalAddrMode != UART_RX_ADDR_MODE_NONE)
                        begin
                            rx_addr_match_status <= rx_addressmatch;
                        end
                        if((FinalParityType == UART_PARITY_TYPE_EVEN) || (FinalParityType == UART_PARITY_TYPE_ODD))
                        begin
                            rx_parity_error_status <= rx_parity_error_pre;
                        end
                        if( (FinalParityType == UART_PARITY_TYPE_MRKSPC) ||
                            (FinalAddrMode != UART_RX_ADDR_MODE_NONE) )
                        begin
                            rx_markspace_status <= rx_markspace_pre;
                        end
                        if(~rx_postpoll)
                        begin            /* Stop bit = 0 */
                            rx_stop_bit_error <= 1'b1;   /* Set Error Flag */
                            if( BreakDetect && !rx_break_detect)  /* Break detection*/
                            begin
                                rx_state <= UART_RX_STATE_CHECK_BREAK;
                            end
                            else
                            begin
                                rx_state <= UART_RX_STATE_IDLE;
                            end
                        end
                        else
                        begin
                            rx_state <= UART_RX_STATE_IDLE;
                        end
                    end
                end /*UART_RX_STATE_CHECK_STOP1 */
                UART_RX_STATE_CHECK_BREAK:
                begin
                    /*UART_HD_STATE_SEND_STOP1 in Half duplex mode*/
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        if(rx_bitclk)
                        begin
                            if(NumStopBits == UART_NUM_STOP_BITS_1)
                            begin
                                if(!(cts_n && FlowControl) && !hd_tx_fifo_empty)
                                begin
                                    if(OverSampleCount == UART_OVER_SAMPLE_16)
                                    begin
                                        rx_count7_bit8 <= 0;
                                    end
                                    rx_state <= UART_HD_STATE_SEND_START;
                                end
                                else
                                begin
                                    rx_state <= UART_RX_STATE_IDLE;
                                end
                            end
                            else
                            begin
                                rx_state <= UART_HD_STATE_SEND_STOP2;
                            end
                        end
                    end
                    else if(BreakDetect)
                    begin
                        if(rx_bitclk)
                        begin
                            rx_break_detect <= rx_break_detect | rx_postpoll;
                            /* always need one more bit at 16x oversample */
                            if( ( ((OverSampleCount==UART_OVER_SAMPLE_16) && rx_count7_bit8_wire) ||
                                (OverSampleCount==UART_OVER_SAMPLE_8) ) && (rx_count[6:cl] < rxbreak_cmp) )
                            begin
                                if(~rx_break_detect) /* Break detected*/
                                begin
                                    rx_break_status <= 1'b1;    /* Set set BREAK Flag */
                                end
                                rx_break_detect <= 1;        /* protect from double detect */
                            end
                            if(~rx_break_detect && ~rx_postpoll)
                            begin   /* wait till BREAK release, it can be longer */
                                rx_state <= UART_RX_STATE_CHECK_BREAK;
                            end
                            else
                            begin
                                rx_state <= UART_RX_STATE_IDLE;
                            end
                        end
                    end    /*BreakDetect*/
                end /*UART_RX_STATE_CHECK_BREAK */
                UART_HD_STATE_SEND_START:
                begin
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        txn <= 1'b1;
                        if(rx_bitclk)
                        begin
                            txn <= ~hd_shift_out;
                            if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                                (FinalParityType == UART_PARITY_TYPE_ODD) )
                            begin
                                rx_parity_bit <= (FinalParityType == UART_PARITY_TYPE_ODD) ? 1 : 0;
                            end
                            rx_state <= UART_HD_STATE_SEND_DATA;
                        end
                        else
                        begin
                            rx_state <= UART_HD_STATE_SEND_START;
                        end
                    end
                end
                UART_HD_STATE_SEND_DATA:
                begin
                    if(HalfDuplexSend && HalfDuplexEn)
                    begin
                        if(rx_bitclk)
                        begin
                            if( (FinalParityType == UART_PARITY_TYPE_EVEN) ||
                                (FinalParityType == UART_PARITY_TYPE_ODD) )
                            begin
                                rx_parity_bit <= (rx_parity_bit ^ ~txn);
                            end
                            /* SendBreak always need one more bit */
                            if((rx_count7_bit8_wire ||          /* counter second turn */
                                rx_count7_tc ||                 /* last bit, but rx_count already reloaded*/
                                (!rxperiod_cmp_need_one_bit &&  /*data <= 6 bits*/
                                !(tx_hd_send_break && (OverSampleCount == UART_OVER_SAMPLE_16)))) && /*Break@16x*/
                               (((rx_count[6:cl] < hd_txperiod_cmp) && !tx_hd_send_break) ||
                                ((rx_count[6:cl] < hd_tx_break_cmp) && tx_hd_send_break)))
                            begin
                                if((FinalParityType == UART_PARITY_TYPE_EVEN) ||
                                   (FinalParityType == UART_PARITY_TYPE_ODD))
                                begin
                                    rx_state <= UART_HD_STATE_SEND_PARITY;
                                    txn <= ~(rx_parity_bit ^ ~txn);    /*+last bit*/
                                end
                                else if (FinalParityType == UART_PARITY_TYPE_MRKSPC)
                                begin
                                    rx_state <= UART_HD_STATE_SEND_PARITY;

                                    txn <= ~tx_mark;
                                    if(tx_mark)
                                    begin
                                        tx_mark <= 1'b0;
                                    end
                                end
                                else
                                begin
                                    rx_state <= UART_HD_STATE_SEND_STOP1;
                                    txn <= 1'b0;
                                end
                            end
                            else
                            begin
                                if(tx_hd_send_break)
                                begin
                                    txn <= 1'b1;
                                end
                                else
                                begin
                                    txn <= ~hd_shift_out;
                                end
                            end
                        end
                    end
                end
            endcase
        end /* End of Else Statement */
    end /* End of Always Block */
end    /* End of RXEnable Generate Statement begin*/
endgenerate /* sRX */

endmodule /* B_DMA_UART_v0_1 */

`endif /* B_DMA_UART_v0_1_V_ALREADY_INCLUDED */



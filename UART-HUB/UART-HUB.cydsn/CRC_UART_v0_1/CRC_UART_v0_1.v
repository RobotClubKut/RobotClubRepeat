/*******************************************************************************
* File Name:  CRC_UART_v0_1.v 
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description: 
*  This file provides a top level model of the CRC componnent
*  defining and all of the necessary interconnect.
* 
* Note: 
*  None
********************************************************************************
*                 Control and Status Register definitions
******************************************************************************** 
*
* Control Register Definition
*
*  ctrl_enable => 0 = disable CRC
*                 1 = enable CRC
*
*  ctrl_reset  => Software reset for dtrig. Firstly must be set "1", 
*                 after that - "0". This is emulate rising edge for reset 
*                 triggers.
*
******************************************************************************** 
*                 Data Path register definitions
******************************************************************************** 
*  INSTANCE NAME:  DatapathName 
*  DESCRIPTION:
*  REGISTER USAGE:
*    F0 => Copy of lower half of seed valu
*    F1 => Copy of upper half of seed value
*    D0 => Lower half of polynomial value
*    D1 => Upper half of polynomial value
*    A0 => Lower half of seed value 
*    A1 => Upper half of seed value  
*
******************************************************************************** 
*               I*O Signals:   
******************************************************************************** 
*  IO SIGNALS: 
*   di            input        Input Data
*    reset          input           Reset
*   clock         input        Data clock
*   enable          input           Enable
*
********************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

`include "cypress.v"
`ifdef CRC_UART_v0_1_V_ALREADY_INCLUDED
`else
`define CRC_UART_v0_1_V_ALREADY_INCLUDED

module CRC_UART_v0_1
(
    input wire clock,
    input wire reset,
    input wire enable,
    input wire di
);

    /**************************************************************************/
    /* Parameters                                                             */
    /**************************************************************************/
    localparam CRC_8_BIT  = 7'd8;
    localparam CRC_16_BIT = 7'd16;
    localparam CRC_24_BIT = 7'd24;
    localparam CRC_32_BIT = 7'd32;
    localparam CRC_40_BIT = 7'd40;
    localparam CRC_48_BIT = 7'd48;
    localparam CRC_56_BIT = 7'd56;
    localparam CRC_64_BIT = 7'd64;
    parameter [6:0] Resolution = CRC_8_BIT;    
   
    localparam CRC_CFG_TDM_DISABLE = 1'd0;
    localparam CRC_CFG_TDM_ENABLE  = 1'd1;
    parameter TimeMultiplexing = CRC_CFG_TDM_DISABLE;
    
    /* UDB Revision definitions */
    localparam CY_UDB_V0 = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_5A);
    localparam CY_UDB_V1 = (!CY_UDB_V0);
    
    /* Silicon definition */
    localparam PSOC4A = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_4A);

    /* Control Register Bits (Bits 7-1 are unused )*/
    localparam CRC_CTRL_ENABLE      = 3'h0;   /* Enable CRC */             
    localparam CRC_CTRL_RESET       = 3'h1;   /* Reset CRC */             
    
    /* State Machine States */
    localparam CRC_STATE_CALC_LOWER = 2'd0;  /* Calculate Lower Half */
    localparam CRC_STATE_CALC_UPPER = 2'd1;  /* Calculate Upper Half */
    localparam CRC_STATE_SAVE_LOWER = 2'd2;  /* Save Lower Half */
    localparam CRC_STATE_SAVE_UPPER = 2'd3;  /* Save Upper Half */   
   
    localparam [2:0] dpPOVal = (Resolution <= CRC_8_BIT)  ? (Resolution - 1): 
                               (Resolution <= CRC_16_BIT) ? (Resolution - 9):
                               (Resolution <= CRC_24_BIT) ? (Resolution - 17):
                               (Resolution <= CRC_32_BIT) ? (Resolution - 25):
                               (Resolution <= CRC_40_BIT) ? (Resolution - 33):
                               (Resolution <= CRC_48_BIT) ? (Resolution - 41):
                               (Resolution <= CRC_56_BIT) ? (Resolution - 49):
                               (Resolution <= CRC_64_BIT) ? (Resolution - 57): 0;

    localparam [2:0] dpMsbVal = (Resolution < CRC_8_BIT) ? (Resolution - 1) : 7;
    
    localparam dpconfig0 =    
    {
        `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG0 Comment:Calculate Lower Half */
        `CS_ALU_OP__XOR, `CS_SRCA_A1, `CS_SRCB_D1,
        `CS_SHFT_OP___SL, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
        `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG1 Comment:Calculate Upper Half*/
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG2 Comment:Save Lower Half*/
        `CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D1,
        `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG3 Comment:Save Upper Half*/
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG5 Comment:*/
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
        `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
        `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
        `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
        `CS_CMP_SEL_CFGA, /*CS_REG7 Comment:*/
          8'hFF, 8'h00,    /*SC_REG4    Comment: */
          8'hFF, 8'hFF,    /*SC_REG5    Comment: */
        `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_CHAIN,
        `SC_CI_A_ROUTE, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
        `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
        `SC_SI_A_ROUTE, /*SC_REG6 Comment: */
        `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
        1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
        `SC_MSB_ENBL, dpMsbVal, `SC_MSB_NOCHN,
        `SC_FB_NOCHN, `SC_CMP1_NOCHN,
        `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
         10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
        `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_ENBL,
        `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
    };
    
    
    /* Internal signals */
    wire clk;
    wire so;
    wire ci;
    wire si;
    wire cmsb;
    wire si_final;
    wire so_chain;
    wire si_d;
    wire si_c;
    wire si_b;
    wire si_a;
    wire so_d;
    wire so_c;
    wire so_b;
    wire so_a;
    wire [7:0] sc_out_a;
    wire [7:0] sc_out_b;
    wire [7:0] sc_out_c;
    wire [7:0] sc_out_d;
    wire [7:0] sc_out;
    wire [2:0] cs_addr;   
    wire enable_final;
    wire reset_final;
    wire ctrl_enable;
    wire ctrl_reset;
    
    wire save_so;
    wire save; 
    wire dcfg;
    wire clk_ctrl;
    wire so_reg1;
    
    wire [7:0] control; /* Control Register Output */    
    
    reg so_reg;
    reg ci_temp;
    reg sc_temp;
    reg [1:0] state;
    wire ci_mult;
    
    
    /**************************************************************************/
    /* Hierarchy - instantiating another module                               */
    /**************************************************************************/

    generate
        if ((TimeMultiplexing == CRC_CFG_TDM_DISABLE) || PSOC4A) 
        begin
            cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE))
            Sync1(
                /* input  */.clock_in(clock),
                /* input  */.enable(enable),
                /* output */.clock_out(clk)
            );
        end
        else 
        begin
            cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE))
            Sync1(
                /* input  */.clock_in(clock),
                /* input  */.enable(enable_final),
                /* output */.clock_out(clk)
            );
        end
    endgenerate
    
    generate
        if (CY_UDB_V0)
        begin: AsyncCtrl
            cy_psoc3_control #(.cy_force_order(`TRUE)) 
            CtrlReg (
                /* output 07:00] */.control(control)
            );
        end
        else
        begin: SyncCtrl
            cy_psoc3_control #(.cy_force_order(`TRUE), .cy_ctrl_mode_1(8'h0), .cy_ctrl_mode_0(8'h0)) 
            CtrlReg (
                /* output [07:00] */ .control(control)
            );
        end
    endgenerate

    generate
        if ((Resolution > CRC_48_BIT) && (TimeMultiplexing == CRC_CFG_TDM_ENABLE))
        begin : b3 
            cy_psoc3_dp #(.cy_dpconfig(dpconfig0)) 
            CRCdp_d(
                /*  input                   */  .clk(clk),    
                /*  input   [02:00]         */  .cs_addr(cs_addr),
                /*  input                   */  .route_si(si_d),      
                /*  input                   */  .route_ci(ci_mult),    
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
                /*  output                  */  .so(so_d),  
                /*  output                  */  .f0_bus_stat(),     
                /*  output                  */  .f0_blk_stat(),     
                /*  output                  */  .f1_bus_stat(),     
                /*  output                  */  .f1_blk_stat(),
        
                /* input                    */  .ci(1'b0),     
                /* output                   */  .co(),         
                /* input                    */  .sir(1'b0),    
                /* output                   */  .sor(),        
                /* input                    */  .sil(1'b0),    
                /* output                   */  .sol(),        
                /* input                    */  .msbi(1'b0),   
                /* output                   */  .msbo(),       
                /* input [01:00]            */  .cei(2'b0),    
                /* output [01:00]           */  .ceo(),        
                /* input [01:00]            */  .cli(2'b0),    
                /* output [01:00]           */  .clo(),        
                /* input [01:00]            */  .zi(2'b0),     
                /* output [01:00]           */  .zo(),         
                /* input [01:00]            */  .fi(2'b0),     
                /* output [01:00]           */  .fo(),         
                /* input [01:00]            */  .capi(2'b0),   
                /* output [01:00]           */  .capo(),       
                /* input                    */  .cfbi(1'b0),   
                /* output                   */  .cfbo(),       
                /* input [07:00]            */  .pi(8'b0),     
                /* output [07:00]           */  .po(sc_out_d[7:0])         
            );
        end 
        if ((Resolution > CRC_32_BIT) && (TimeMultiplexing == CRC_CFG_TDM_ENABLE))
        begin : b2
            cy_psoc3_dp #(.cy_dpconfig(dpconfig0)) 
            CRCdp_c(
                /*  input                   */  .clk(clk),     
                /* input   [02:00]         */  .cs_addr(cs_addr),
                /* input                   */  .route_si(si_c),      
                /* input                   */  .route_ci(ci_mult),    
                /* input                   */  .f0_load(1'b0),     
                /* input                   */  .f1_load(1'b0),     
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
                /*  output                  */  .so(so_c),  
                /*  output                  */  .f0_bus_stat(),     
                /*  output                  */  .f0_blk_stat(),     
                /*  output                  */  .f1_bus_stat(),     
                /*  output                  */  .f1_blk_stat(),
        
                /* input                    */  .ci(1'b0),     
                /* output                   */  .co(),         
                /* input                    */  .sir(1'b0),    
                /* output                   */  .sor(),        
                /* input                    */  .sil(1'b0),    
                /* output                   */  .sol(),        
                /* input                    */  .msbi(1'b0),   
                /* output                   */  .msbo(),       
                /* input [01:00]            */  .cei(2'b0),    
                /* output [01:00]           */  .ceo(),        
                /* input [01:00]            */  .cli(2'b0),    
                /* output [01:00]           */  .clo(),        
                /* input [01:00]            */  .zi(2'b0),     
                /* output [01:00]           */  .zo(),         
                /* input [01:00]            */  .fi(2'b0),     
                /* output [01:00]           */  .fo(),         
                /* input [01:00]            */  .capi(2'b0),   
                /* output [01:00]           */  .capo(),       
                /* input                    */  .cfbi(1'b0),   
                /* output                   */  .cfbo(),       
                /* input [07:00]            */  .pi(8'b0),     
                /* output [07:00]           */  .po(sc_out_c[7:0])          
            );            
        end 
        if ((Resolution > CRC_16_BIT) && (TimeMultiplexing == CRC_CFG_TDM_ENABLE))
        begin : b1
            cy_psoc3_dp #(.cy_dpconfig(dpconfig0)) 
            CRCdp_b(
                /* input                   */  .clk(clk),  
                /* input   [02:00]         */  .cs_addr(cs_addr),
                /* input                   */  .route_si(si_b),      
                /* input                   */  .route_ci(ci_mult),    
                /* input                   */  .f0_load(1'b0),     
                /* input                   */  .f1_load(1'b0),     
                /* input                   */  .d0_load(1'b0),     
                /* input                   */  .d1_load(1'b0),     
                /* output                  */  .ce0(),             
                /* output                  */  .cl0(),             
                /* output                  */  .z0(),              
                /* output                  */  .ff0(),             
                /* output                  */  .ce1(),
                /* output                  */  .cl1(),
                /* output                  */  .z1(),
                /* output                  */  .ff1(),
                /* output                  */  .ov_msb(),
                /* output                  */  .co_msb(), 
                /* output                  */  .cmsb(), 
                /* output                  */  .so(so_b),  
                /* output                  */  .f0_bus_stat(),     
                /* output                  */  .f0_blk_stat(),     
                /* output                  */  .f1_bus_stat(),     
                /* output                  */  .f1_blk_stat(),
        
                /* input                    */  .ci(1'b0),     
                /* output                   */  .co(),         
                /* input                    */  .sir(1'b0),    
                /* output                   */  .sor(),        
                /* input                    */  .sil(1'b0),    
                /* output                   */  .sol(),        
                /* input                    */  .msbi(1'b0),   
                /* output                   */  .msbo(),       
                /* input [01:00]            */  .cei(2'b0),    
                /* output [01:00]           */  .ceo(),       
                /* input [01:00]            */  .cli(2'b0),    
                /* output [01:00]           */  .clo(),        
                /* input [01:00]            */  .zi(2'b0),     
                /* output [01:00]           */  .zo(),         
                /* input [01:00]            */  .fi(2'b0),     
                /* output [01:00]           */  .fo(),         
                /* input [01:00]            */  .capi(2'b0),   
                /* output [01:00]           */  .capo(),       
                /* input                    */  .cfbi(1'b0),   
                /* output                   */  .cfbo(),       
                /* input [07:00]            */  .pi(8'b0),     
                /* output [07:00]           */  .po(sc_out_b[7:0])          
            );
        end 
        if ((Resolution > CRC_8_BIT) && (TimeMultiplexing == CRC_CFG_TDM_ENABLE))
        begin : b0
            cy_psoc3_dp #(.cy_dpconfig(dpconfig0)) 
            CRCdp_a(
             /*  input                   */  .clk(clk),   
             /*  input   [02:00]         */  .cs_addr(cs_addr),
             /*  input                   */  .route_si(si),
             /*  input                   */  .route_ci(ci_mult),
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
             /*  output                  */  .cmsb(cmsb), 
             /*  output                  */  .so(so_a),  
             /*  output                  */  .f0_bus_stat(),     
             /*  output                  */  .f0_blk_stat(),     
             /*  output                  */  .f1_bus_stat(),     
             /*  output                  */  .f1_blk_stat(),
        
             /* input                    */  .ci(1'b0),     
             /* output                   */  .co(),         
             /* input                    */  .sir(1'b0),    
             /* output                   */  .sor(),        
             /* input                    */  .sil(1'b0),    
             /* output                   */  .sol(),        
             /* input                    */  .msbi(1'b0),   
             /* output                   */  .msbo(),       
             /* input [01:00]            */  .cei(2'b0),    
             /* output [01:00]           */  .ceo(),        
             /* input [01:00]            */  .cli(2'b0),    
             /* output [01:00]           */  .clo(),        
             /* input [01:00]            */  .zi(2'b0),     
             /* output [01:00]           */  .zo(),         
             /* input [01:00]            */  .fi(2'b0),     
             /* output [01:00]           */  .fo(),         
             /* input [01:00]            */  .capi(2'b0),   
             /* output [01:00]           */  .capo(),       
             /* input                    */  .cfbi(1'b0),   
             /* output                   */  .cfbo(),       
             /* input [07:00]            */  .pi(8'b0),     
             /* output [07:00]           */  .po(sc_out_a[7:0])          
            );
        end
    endgenerate
   
   
    generate
        if ((Resolution <= CRC_8_BIT) && (TimeMultiplexing == CRC_CFG_TDM_DISABLE))
        begin : sC8
            cy_psoc3_dp8 #(.cy_dpconfig_a(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_ROUTE, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_ENBL, dpMsbVal, `SC_MSB_NOCHN,
                `SC_FB_NOCHN, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_ENBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            })) CRCdp(
                /*  input                   */  .clk(clk),    
                /*  input   [02:00]         */  .cs_addr(cs_addr),
                /*  input                   */  .route_si(si),      
                /*  input                   */  .route_ci(ci),    
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
                /*  output                  */  .cmsb(cmsb),
                /*  output                  */  .so(),
                /*  output                  */  .f0_bus_stat(),     
                /*  output                  */  .f0_blk_stat(),     
                /*  output                  */  .f1_bus_stat(),     
                /*  output                  */  .f1_blk_stat()      
            );
        end 
        else if ((Resolution <= CRC_16_BIT) && (TimeMultiplexing == CRC_CFG_TDM_DISABLE)) 
        begin : sC16
            cy_psoc3_dp16 #(.cy_dpconfig_a(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_CHAIN,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_ROUTE, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_ENBL, `SC_MSB_BIT7, `SC_MSB_CHNED,
                `SC_FB_NOCHN, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment:MSB Chain */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_ENBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_b(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_CHAIN,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_ENBL, dpPOVal, `SC_MSB_NOCHN,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment:FB Chain and MSB enable */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            })) CRCdp(
                /* input            */ .clk(clk),   
                /* input  [02:00]   */ .cs_addr(cs_addr),              
                /* input            */ .route_si(si), 
                /* input            */ .route_ci(ci),  
                /* input            */ .f0_load(1'b0),     
                /* input            */ .f1_load(1'b0),     
                /* input            */ .d0_load(1'b0),    
                /* input            */ .d1_load(1'b0),     
                /* output [01:00]   */ .ce0(), 
                /* output [01:00]   */ .cl0(),  
                /* output [01:00]   */ .z0(),  
                /* output [01:00]   */ .ff0(),  
                /* output [01:00]   */ .ce1(),  
                /* output [01:00]   */ .cl1(),   
                /* output [01:00]   */ .z1(),    
                /* output [01:00]   */ .ff1(),  
                /* output [01:00]   */ .ov_msb(),      
                /* output [01:00]   */ .co_msb(),    
                /* output [01:00]   */ .cmsb({cmsb, nc1}),    
                /* output [01:00]   */ .so(),        
                /* output [01:00]   */ .f0_bus_stat(),     
                /* output [01:00]   */ .f0_blk_stat(),     
                /* output [01:00]   */ .f1_bus_stat(),    
                /* output [01:00]   */ .f1_blk_stat()    
            );
        end 
        else if ((Resolution <= CRC_24_BIT) && (TimeMultiplexing == CRC_CFG_TDM_DISABLE))
        begin : sC24
            cy_psoc3_dp24 #(.cy_dpconfig_a(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_ROUTE, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_DSBL, `SC_MSB_BIT7, `SC_MSB_CHNED,
                `SC_FB_NOCHN, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_ENBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_b(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_DSBL, `SC_MSB_BIT7, `SC_MSB_CHNED,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_c(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_ENBL, dpPOVal, `SC_MSB_NOCHN,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            })) CRCdp(
                /* input            */ .clk(clk),        
                /* input  [02:00]   */ .cs_addr(cs_addr),  
                /* input            */ .route_si(si),    
                /* input            */ .route_ci(ci),  
                /* input            */ .f0_load(1'b0), 
                /* input            */ .f1_load(1'b0),  
                /* input            */ .d0_load(1'b0),   
                /* input            */ .d1_load(1'b0),  
                /* output [02:00]   */ .ce0(),         
                /* output [02:00]   */ .cl0(),        
                /* output [02:00]   */ .z0(),       
                /* output [02:00]   */ .ff0(),    
                /* output [02:00]   */ .ce1(), 
                /* output [02:00]   */ .cl1(),  
                /* output [02:00]   */ .z1(),   
                /* output [02:00]   */ .ff1(), 
                /* output [02:00]   */ .ov_msb(),  
                /* output [02:00]   */ .co_msb(),  
                /* output [02:00]   */ .cmsb({cmsb, nc1, nc2}),   
                /* output [02:00]   */ .so(),     
                /* output [02:00]   */ .f0_bus_stat(), 
                /* output [02:00]   */ .f0_blk_stat(),  
                /* output [02:00]   */ .f1_bus_stat(),  
                /* output [02:00]   */ .f1_blk_stat()   
            );
        end 
        else if ((Resolution <= CRC_32_BIT) && (TimeMultiplexing == CRC_CFG_TDM_DISABLE)) 
        begin : sC32
            cy_psoc3_dp32 #(.cy_dpconfig_a(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_ROUTE, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_DSBL, `SC_MSB_BIT0, `SC_MSB_CHNED,
                `SC_FB_NOCHN, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_ENBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_b(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_DSBL, `SC_MSB_BIT0, `SC_MSB_CHNED,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_c(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_DSBL, `SC_MSB_BIT7, `SC_MSB_CHNED,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            }), .cy_dpconfig_d(
            {
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG0 Comment: */
                `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_ENBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG1 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG2 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG3 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG4 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG5 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG6 Comment: */
                `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
                `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC___F1,
                `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
                `CS_CMP_SEL_CFGA, /*CS_REG7 Comment: */
                8'hFF, 8'h00,    /*SC_REG4    Comment: */
                8'hFF, 8'hFF,    /*SC_REG5    Comment: */
                `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
                `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
                `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
                `SC_SI_A_CHAIN, /*SC_REG6 Comment: */
                `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'b0,
                1'b0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
                `SC_MSB_ENBL, dpPOVal, `SC_MSB_NOCHN,
                `SC_FB_CHNED, `SC_CMP1_NOCHN,
                `SC_CMP0_NOCHN, /*SC_REG7 Comment: */
                10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
                `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
                `SC_WRK16CAT_DSBL /*SC_REG8 Comment: */
            })) CRCdp(
                /* input            */ .clk(clk),          
                /* input  [02:00]   */ .cs_addr(cs_addr),   
                /* input            */ .route_si(si),     
                /* input            */ .route_ci(ci),    
                /* input            */ .f0_load(1'b0),     
                /* input            */ .f1_load(1'b0),     
                /* input            */ .d0_load(1'b0),    
                /* input            */ .d1_load(1'b0),   
                /* output [03:00]   */ .ce0(),         
                /* output [03:00]   */ .cl0(),        
                /* output [03:00]   */ .z0(),        
                /* output [03:00]   */ .ff0(),       
                /* output [03:00]   */ .ce1(),        
                /* output [03:00]   */ .cl1(),       
                /* output [03:00]   */ .z1(),       
                /* output [03:00]   */ .ff1(),          
                /* output [03:00]   */ .ov_msb(),       
                /* output [03:00]   */ .co_msb(),      
                /* output [03:00]   */ .cmsb({cmsb, nc1, nc2, nc3}),        
                /* output [03:00]   */ .so(),           
                /* output [03:00]   */ .f0_bus_stat(),  
                /* output [03:00]   */ .f0_blk_stat(),  
                /* output [03:00]   */ .f1_bus_stat(),  
                /* output [03:00]   */ .f1_blk_stat()   
            );
        end 
    endgenerate
   
   
    /**************************************************************************/
    /* Synchronous procedures                                                 */
    /**************************************************************************/
    generate
         /* Time Multiplexing Logic */
        if (TimeMultiplexing == CRC_CFG_TDM_ENABLE)
        begin
            always @(posedge clk or posedge reset_final)
            begin
                if (reset_final)
                    state <= 2'b11;
                else
                case (state)
                    CRC_STATE_CALC_LOWER:   state <= CRC_STATE_SAVE_LOWER;
                    CRC_STATE_SAVE_LOWER:   state <= CRC_STATE_CALC_UPPER;
                    CRC_STATE_CALC_UPPER:   state <= CRC_STATE_SAVE_UPPER;
                    CRC_STATE_SAVE_UPPER:   state <= CRC_STATE_CALC_LOWER;
                    default:                state <= CRC_STATE_CALC_LOWER;
                endcase
            end
    
            /* sync so */     
            always @(posedge clk)
            begin
                if (reset_final)
                begin
                    so_reg <= 1'b1;
                end
                else if (save_so)
                begin
                    so_reg<= so;
                end
                else so_reg<=so_reg;
            end 
            
            /* ci */     
            always @(posedge clk)
            begin
                if (reset_final)
                    ci_temp <= 1'b1;
                else if (save)
                begin
                    ci_temp <= ci;
                end    
                else ci_temp<=ci_temp;
            end 
            
            /* si */     
            always @(posedge clk)
            begin
                if (reset_final)
                    sc_temp <= 1'b1;
                else if (save)
                begin
                    sc_temp <= sc_out[dpPOVal];
                end
                else sc_temp<=sc_temp;
            end 
        end
    endgenerate
    
   
    /**************************************************************************/
    /* Combinatorial  procedures                                                */
    /**************************************************************************/
    
    /* Chain Datapathes */
    generate
        if (TimeMultiplexing == CRC_CFG_TDM_ENABLE) 
        begin
            if (Resolution <= CRC_16_BIT)
            begin
                assign so = so_a;  
                assign sc_out = sc_out_a;
            end
            else if (Resolution <= CRC_24_BIT)
            begin
                assign si_b = dcfg ? si : so_a;
                assign so = so_b;
                assign sc_out = sc_out_b;
            end
            else if (Resolution <= CRC_32_BIT)
            begin
                assign si_b = so_a;
                assign so = so_b;
                assign sc_out = sc_out_b;
            end    
            else if (Resolution <= CRC_40_BIT)
            begin  
                assign si_c = so_b;
                assign si_b = dcfg ? si : so_a;
                assign so = so_c;
                assign sc_out = sc_out_c;
            end
            else if (Resolution <= CRC_48_BIT) 
            begin
                assign si_c = so_b;
                assign si_b = so_a;
                assign so = so_c;
                assign sc_out = sc_out_c;
            end
            else if (Resolution <= CRC_56_BIT)
            begin
                assign si_d = so_c;
                assign si_c = so_b;
                assign si_b = dcfg ? si : so_a;
                assign so = so_d;
                assign sc_out = sc_out_d;
            end
            else if (Resolution <= CRC_64_BIT)
            begin
                assign si_d = so_c;
                assign si_c = so_b;
                assign si_b = so_a;
                assign so = so_d;
                assign sc_out = sc_out_d;
            end
        end
    endgenerate
  
 
    generate
        if (TimeMultiplexing == CRC_CFG_TDM_DISABLE) 
        begin
            assign cs_addr = {reset, 1'b0, enable_final};
            assign ci = cmsb ^ di;
            assign si = cmsb ^ di;
        end
        else
        begin
            assign cs_addr = {reset, state[1:0]};
            assign ci = dcfg ? sc_out[dpPOVal] : ci_temp;
            assign si = dcfg ? so_reg : sc_temp ^ di;
            assign ci_mult = ci ^ di;
        end
    endgenerate
        
    /* Control Signals */
    assign ctrl_enable       = control[CRC_CTRL_ENABLE];
    assign ctrl_reset         = control[CRC_CTRL_RESET];
    
      assign save = state[1];
    assign save_so = ~save;
    assign dcfg = state[0];
        
    assign reset_final  = ctrl_reset | reset; 
    assign enable_final = ctrl_enable & enable;
     
  
endmodule   /* CRC_UART_v0_1 */
`endif      /* CRC_UART_v0_1_V_ALREADY_INCLUDED */



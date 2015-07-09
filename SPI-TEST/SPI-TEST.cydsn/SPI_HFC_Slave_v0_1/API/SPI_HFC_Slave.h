/*******************************************************************************
* File Name: `$INSTANCE_NAME`.h
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  Contains the function prototypes, constants and register definition
*  of the SPI Slave Component.
*
* Note:
*  None
*
********************************************************************************
* Copyright 2008-2015, Cypress Semiconductor Corporation. All rights reserved.
* You may use this file only in accordance with the license, terms, conditions,
* disclaimers, and limitations in the end user license agreement accompanying
* the software package with which this file was provided.
*******************************************************************************/

#if !defined(CY_SPIS_`$INSTANCE_NAME`_H)
#define CY_SPIS_`$INSTANCE_NAME`_H

#include "cytypes.h"
#include "CyLib.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component `$CY_COMPONENT_NAME` requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */


/***************************************
*   Conditional Compilation Parameters
***************************************/

#define `$INSTANCE_NAME`_DATA_WIDTH                  (`$NumberOfDataBits`u)
#define `$INSTANCE_NAME`_INTERNAL_TX_INT_ENABLED     (`$InternalTxInterruptEnabled`u)
#define `$INSTANCE_NAME`_INTERNAL_RX_INT_ENABLED     (`$InternalRxInterruptEnabled`u)
#define `$INSTANCE_NAME`_MODE_USE_ZERO               (`$ModeUseZero`u)
//#define `$INSTANCE_NAME`_BIDIRECTIONAL_MODE          (`$BidirectMode`u)
#define `$INSTANCE_NAME`_MODE                        (`$Mode`u)

#define `$INSTANCE_NAME`_FIFO_SIZE                  (4u)
/* Internal interrupt handling */
#define `$INSTANCE_NAME`_TX_BUFFER_SIZE             (`$TxBufferSize`u)
#define `$INSTANCE_NAME`_RX_BUFFER_SIZE             (`$RxBufferSize`u)
#define `$INSTANCE_NAME`_INTERNAL_TX_INT_ENABLED    (`$InternalTxInterruptEnabled`u)
#define `$INSTANCE_NAME`_INTERNAL_RX_INT_ENABLED    (`$InternalRxInterruptEnabled`u)

#define `$INSTANCE_NAME`_TX_SOFTWARE_BUF_ENABLED    ((0u != `$INSTANCE_NAME`_INTERNAL_TX_INT_ENABLED) && \
                                                     (`$INSTANCE_NAME`_TX_BUFFER_SIZE > `$INSTANCE_NAME`_FIFO_SIZE))

#define `$INSTANCE_NAME`_RX_SOFTWARE_BUF_ENABLED    ((0u != `$INSTANCE_NAME`_INTERNAL_RX_INT_ENABLED) && \
                                                     (`$INSTANCE_NAME`_RX_BUFFER_SIZE > `$INSTANCE_NAME`_FIFO_SIZE))


/***************************************
*        Data Struct Definition
***************************************/

/* Sleep Mode API Support */
typedef struct
{
    uint8 enableState;
    uint8 cntrPeriod;
} `$INSTANCE_NAME`_BACKUP_STRUCT;


/***************************************
*        Function Prototypes
***************************************/

void  `$INSTANCE_NAME`_Init(void) `=ReentrantKeil($INSTANCE_NAME . "_Init")`;
void  `$INSTANCE_NAME`_Enable(void) `=ReentrantKeil($INSTANCE_NAME . "_Enable")`;
void  `$INSTANCE_NAME`_Start(void) `=ReentrantKeil($INSTANCE_NAME . "_Start")`;
void  `$INSTANCE_NAME`_Stop(void) `=ReentrantKeil($INSTANCE_NAME . "_Stop")`;
void  `$INSTANCE_NAME`_EnableTxInt(void) `=ReentrantKeil($INSTANCE_NAME . "_EnableTxInt")`;
void  `$INSTANCE_NAME`_EnableRxInt(void) `=ReentrantKeil($INSTANCE_NAME . "_EnableRxInt")`;
void  `$INSTANCE_NAME`_DisableTxInt(void) `=ReentrantKeil($INSTANCE_NAME . "_DisableTxInt")`;
void  `$INSTANCE_NAME`_DisableRxInt(void) `=ReentrantKeil($INSTANCE_NAME . "_DisableRxInt")`;
void  `$INSTANCE_NAME`_SetTxInterruptMode(uint8 intSrc) `=ReentrantKeil($INSTANCE_NAME . "_SetTxInterruptMode")`;
void  `$INSTANCE_NAME`_SetRxInterruptMode(uint8 intSrc) `=ReentrantKeil($INSTANCE_NAME . "_SetRxInterruptMode")`;
uint8 `$INSTANCE_NAME`_ReadTxStatus(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadTxStatus")`;
uint8 `$INSTANCE_NAME`_ReadRxStatus(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadRxStatus")`;
void  `$INSTANCE_NAME`_WriteTxData(`$RegSizeReplacementString` txData)`=ReentrantKeil($INSTANCE_NAME . "_WriteTxData")`;

#if(`$INSTANCE_NAME`_MODE_USE_ZERO != 0u)
    void  `$INSTANCE_NAME`_WriteTxDataZero(`$RegSizeReplacementString` txDataByte) \
                                              `=ReentrantKeil($INSTANCE_NAME . "_WriteTxDataZero")`;
#endif /* (`$INSTANCE_NAME`_MODE_USE_ZERO != 0u) */

`$RegSizeReplacementString` `$INSTANCE_NAME`_ReadRxData(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadRxData")`;
uint8 `$INSTANCE_NAME`_GetRxBufferSize(void) `=ReentrantKeil($INSTANCE_NAME . "_GetRxBufferSize")`;
uint8 `$INSTANCE_NAME`_GetTxBufferSize(void) `=ReentrantKeil($INSTANCE_NAME . "_GetTxBufferSize")`;
void  `$INSTANCE_NAME`_ClearRxBuffer(void) `=ReentrantKeil($INSTANCE_NAME . "_ClearRxBuffer")`;
void  `$INSTANCE_NAME`_ClearTxBuffer(void) `=ReentrantKeil($INSTANCE_NAME . "_ClearTxBuffer")`;

#if 0 // ignore bidirect
#if (`$INSTANCE_NAME`_BIDIRECTIONAL_MODE != 0u)
    void  `$INSTANCE_NAME`_TxEnable(void) `=ReentrantKeil($INSTANCE_NAME . "_TxEnable")`;
    void  `$INSTANCE_NAME`_TxDisable(void) `=ReentrantKeil($INSTANCE_NAME . "_TxDisable")`;
#endif /* `$INSTANCE_NAME`_BIDIRECTIONAL_MODE != 0u */
#endif // ingore bidirect

void  `$INSTANCE_NAME`_PutArray(const `$RegSizeReplacementString` buffer[], uint8 byteCount) `=ReentrantKeil($INSTANCE_NAME . "_PutArray")`;
void  `$INSTANCE_NAME`_ClearFIFO(void) `=ReentrantKeil($INSTANCE_NAME . "_ClearFIFO")`;
void  `$INSTANCE_NAME`_Sleep(void) `=ReentrantKeil($INSTANCE_NAME . "_Sleep")`;
void  `$INSTANCE_NAME`_Wakeup(void) `=ReentrantKeil($INSTANCE_NAME . "_Wakeup")`;
void  `$INSTANCE_NAME`_SaveConfig(void) `=ReentrantKeil($INSTANCE_NAME . "_SaveConfig")`;
void  `$INSTANCE_NAME`_RestoreConfig(void) `=ReentrantKeil($INSTANCE_NAME . "_RestoreConfig")`;

/* Communication bootloader APIs */
#if defined(CYDEV_BOOTLOADER_IO_COMP) && ((CYDEV_BOOTLOADER_IO_COMP == CyBtldr_`$INSTANCE_NAME`) || \
                                          (CYDEV_BOOTLOADER_IO_COMP == CyBtldr_Custom_Interface))
    /* Physical layer functions */
    void    `$INSTANCE_NAME`_CyBtldrCommStart(void) CYSMALL `=ReentrantKeil($INSTANCE_NAME . "_CyBtldrCommStart")`;
    void    `$INSTANCE_NAME`_CyBtldrCommStop(void) CYSMALL `=ReentrantKeil($INSTANCE_NAME . "_CyBtldrCommStop")`;
    void    `$INSTANCE_NAME`_CyBtldrCommReset(void) CYSMALL `=ReentrantKeil($INSTANCE_NAME . "_CyBtldrCommReset")`;
    cystatus `$INSTANCE_NAME`_CyBtldrCommWrite(const uint8 pData[], uint16 size, uint16 * count, uint8 timeOut) CYSMALL
             `=ReentrantKeil($INSTANCE_NAME . "_CyBtldrCommWrite")`;
    cystatus `$INSTANCE_NAME`_CyBtldrCommRead(uint8 pData[], uint16 size, uint16 * count, uint8 timeOut) CYSMALL
             `=ReentrantKeil($INSTANCE_NAME . "_CyBtldrCommRead")`;

    #if (CYDEV_BOOTLOADER_IO_COMP == CyBtldr_`$INSTANCE_NAME`)
        #define CyBtldrCommStart    `$INSTANCE_NAME`_CyBtldrCommStart
        #define CyBtldrCommStop     `$INSTANCE_NAME`_CyBtldrCommStop
        #define CyBtldrCommReset    `$INSTANCE_NAME`_CyBtldrCommReset
        #define CyBtldrCommWrite    `$INSTANCE_NAME`_CyBtldrCommWrite
        #define CyBtldrCommRead     `$INSTANCE_NAME`_CyBtldrCommRead
    #endif  /* (CYDEV_BOOTLOADER_IO_COMP == CyBtldr_`$INSTANCE_NAME`) */

    /* Byte to Byte time out for detecting end of block data from host */
    #define `$INSTANCE_NAME`_BYTE2BYTE_TIME_OUT (1u)

#endif /* (CYDEV_BOOTLOADER_IO_COMP) && ((CYDEV_BOOTLOADER_IO_COMP == CyBtldr_`$INSTANCE_NAME`) || \
                                             (CYDEV_BOOTLOADER_IO_COMP == CyBtldr_Custom_Interface)) */


CY_ISR_PROTO(`$INSTANCE_NAME`_TX_ISR);
CY_ISR_PROTO(`$INSTANCE_NAME`_RX_ISR);

/* Macros for getting software status of SPIS Statusi Register */
#define `$INSTANCE_NAME`_GET_STATUS_TX(swTxSts) ( (uint8)(`$INSTANCE_NAME`_TX_STATUS_REG | \
                                                       ((swTxSts) & `$INSTANCE_NAME`_STS_CLR_ON_RD_BYTES_MASK)) )
#define `$INSTANCE_NAME`_GET_STATUS_RX(swRxSts) ( (uint8)(`$INSTANCE_NAME`_RX_STATUS_REG | \
                                                       ((swRxSts) & `$INSTANCE_NAME`_STS_CLR_ON_RD_BYTES_MASK)) )


/***************************************
*   Variable with external linkage
***************************************/

extern uint8 `$INSTANCE_NAME`_initVar;


/***************************************
*           API Constants
***************************************/

#define `$INSTANCE_NAME`_TX_ISR_NUMBER     ((uint8)`$INSTANCE_NAME`_TxInternalInterrupt__INTC_NUMBER)
#define `$INSTANCE_NAME`_RX_ISR_NUMBER     ((uint8)`$INSTANCE_NAME`_RxInternalInterrupt__INTC_NUMBER)
#define `$INSTANCE_NAME`_TX_ISR_PRIORITY   ((uint8)`$INSTANCE_NAME`_TxInternalInterrupt__INTC_PRIOR_NUM)
#define `$INSTANCE_NAME`_RX_ISR_PRIORITY   ((uint8)`$INSTANCE_NAME`_RxInternalInterrupt__INTC_PRIOR_NUM)


/***************************************
*    Initial Parameter Constants
***************************************/

#define `$INSTANCE_NAME`_INT_ON_SPI_DONE    (uint8)(`$IntOnSPIDone`u << `$INSTANCE_NAME`_STS_SPI_DONE_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_TX_EMPTY    (uint8)(`$InterruptOnTXEmpty`u << `$INSTANCE_NAME`_STS_TX_FIFO_EMPTY_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_TX_NOT_FULL (uint8)(`$IntOnTXNotFull`u << `$INSTANCE_NAME`_STS_TX_FIFO_NOT_FULL_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_BYTE_COMP   (uint8)(`$IntOnByteComp`u << `$INSTANCE_NAME`_STS_BYTE_COMPLETE_SHIFT)

#define `$INSTANCE_NAME`_TX_INIT_INTERRUPTS_MASK  (`$INSTANCE_NAME`_INT_ON_SPI_DONE | \
                                            `$INSTANCE_NAME`_INT_ON_TX_EMPTY | `$INSTANCE_NAME`_INT_ON_TX_NOT_FULL | \
                                            `$INSTANCE_NAME`_INT_ON_BYTE_COMP)

#define `$INSTANCE_NAME`_INT_ON_RX_EMPTY     (uint8)(`$InterruptOnRXEmpty`u << `$INSTANCE_NAME`_STS_RX_FIFO_EMPTY_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_RX_NOT_EMPTY (uint8)(`$IntOnRXNotEmpty`u << `$INSTANCE_NAME`_STS_RX_FIFO_NOT_EMPTY_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_RX_OVER      (uint8)(`$IntOnRXOver`u << `$INSTANCE_NAME`_STS_RX_FIFO_OVERRUN_SHIFT)
#define `$INSTANCE_NAME`_INT_ON_RX_FULL      (uint8)(`$IntOnRXFull`u << `$INSTANCE_NAME`_STS_RX_FIFO_FULL_SHIFT)

#define `$INSTANCE_NAME`_RX_INIT_INTERRUPTS_MASK (`$INSTANCE_NAME`_INT_ON_RX_EMPTY | \
                                            `$INSTANCE_NAME`_INT_ON_RX_NOT_EMPTY | `$INSTANCE_NAME`_INT_ON_RX_OVER | \
                                            `$INSTANCE_NAME`_INT_ON_RX_FULL)

#define `$INSTANCE_NAME`_BITCTR_INIT           (`$INSTANCE_NAME`_DATA_WIDTH - 1u)

`#DECLARE_ENUM SPI_Modes`

#define `$INSTANCE_NAME`_TX_BUFFER_SIZE         (`$TxBufferSize`u)
#define `$INSTANCE_NAME`_RX_BUFFER_SIZE         (`$RxBufferSize`u)

/* Following definitions are for version Compatibility, they are obsolete.
*  Please do not use it in new projects
*/
#define `$INSTANCE_NAME`_INIT_INTERRUPTS_MASK  (`$INSTANCE_NAME`_INT_ON_SPI_DONE | `$INSTANCE_NAME`_INT_ON_TX_EMPTY | \
                                            `$INSTANCE_NAME`_INT_ON_TX_NOT_FULL | `$INSTANCE_NAME`_INT_ON_RX_EMPTY | \
                                            `$INSTANCE_NAME`_INT_ON_RX_NOT_EMPTY | `$INSTANCE_NAME`_INT_ON_RX_OVER | \
                                            `$INSTANCE_NAME`_INT_ON_BYTE_COMP)


/***************************************
*             Registers
***************************************/
#if(CY_PSOC3 || CY_PSOC5)
    #define `$INSTANCE_NAME`_TXDATA_ZERO_REG          (* (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

    #define `$INSTANCE_NAME`_TXDATA_ZERO_PTR           (  (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

    #define `$INSTANCE_NAME`_RXDATA_ZERO_REG           (* (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

    #define `$INSTANCE_NAME`_RXDATA_ZERO_PTR           (  (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

    #define `$INSTANCE_NAME`_TXDATA_REG                (* (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F0_REG)

    #define `$INSTANCE_NAME`_TXDATA_PTR                (  (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F0_REG)

    #define `$INSTANCE_NAME`_RXDATA_REG                (* (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F1_REG)

    #define `$INSTANCE_NAME`_RXDATA_PTR                (  (`$RegDefReplacementString`  *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F1_REG)
#else
    #if(`$INSTANCE_NAME`_DATA_WIDTH <= 8u) /* 8bit - SPIS */
        #define `$INSTANCE_NAME`_TXDATA_ZERO_REG           (* (reg8 *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

        #define `$INSTANCE_NAME`_TXDATA_ZERO_PTR           (  (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

        #define `$INSTANCE_NAME`_RXDATA_ZERO_REG           (* (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

        #define `$INSTANCE_NAME`_RXDATA_ZERO_PTR           (  (reg8 *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__A0_REG)

        #define `$INSTANCE_NAME`_TXDATA_REG                (* (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F0_REG)

        #define `$INSTANCE_NAME`_TXDATA_PTR                (  (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F0_REG)

        #define `$INSTANCE_NAME`_RXDATA_REG                (* (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F1_REG)

        #define `$INSTANCE_NAME`_RXDATA_PTR                (  (reg8  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__F1_REG)
    #else /* 16bit - SPIS */
        #define `$INSTANCE_NAME`_TXDATA_ZERO_REG           (* (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_A0_REG)

        #define `$INSTANCE_NAME`_TXDATA_ZERO_PTR           (  (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_A0_REG)

        #define `$INSTANCE_NAME`_RXDATA_ZERO_REG           (* (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_A0_REG)

        #define `$INSTANCE_NAME`_RXDATA_ZERO_PTR           (  (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_A0_REG)

        #define `$INSTANCE_NAME`_TXDATA_REG                (* (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_F0_REG)

        #define `$INSTANCE_NAME`_TXDATA_PTR                (  (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_F0_REG)

        #define `$INSTANCE_NAME`_RXDATA_REG                (* (reg16  *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_F1_REG)

        #define `$INSTANCE_NAME`_RXDATA_PTR                (  (reg16 *) \
                `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__16BIT_F1_REG)
    #endif /* (`$INSTANCE_NAME`_DATA_WIDTH <= 8u) */
#endif     /* (CY_PSOC3 || CY_PSOC5) */

#define `$INSTANCE_NAME`_TX_AUX_CONTROL_DP0_REG       (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__DP_AUX_CTL_REG)
#define `$INSTANCE_NAME`_TX_AUX_CONTROL_DP0_PTR       (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__DP_AUX_CTL_REG)

#define `$INSTANCE_NAME`_RX_AUX_CONTROL_DP0_REG       (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__DP_AUX_CTL_REG)
#define `$INSTANCE_NAME`_RX_AUX_CONTROL_DP0_PTR       (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u0__DP_AUX_CTL_REG)

#if(`$INSTANCE_NAME`_DATA_WIDTH > 8u)

    #define `$INSTANCE_NAME`_TX_AUX_CONTROL_DP1_REG   (* (reg8 *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u1__DP_AUX_CTL_REG)
    #define `$INSTANCE_NAME`_TX_AUX_CONTROL_DP1_PTR   (  (reg8 *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u1__DP_AUX_CTL_REG)

    #define `$INSTANCE_NAME`_RX_AUX_CONTROL_DP1_REG   (* (reg8 *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u1__DP_AUX_CTL_REG)
    #define `$INSTANCE_NAME`_RX_AUX_CONTROL_DP1_PTR   (  (reg8 *) \
            `$INSTANCE_NAME`_BSPIS_`$VerilogSectionReplacementString`_Dp_u1__DP_AUX_CTL_REG)

#endif /* `$INSTANCE_NAME`_DATA_WIDTH > 8u */


#define `$INSTANCE_NAME`_COUNTER_PERIOD_REG    (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_BitCounter__PERIOD_REG)
#define `$INSTANCE_NAME`_COUNTER_PERIOD_PTR    (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_BitCounter__PERIOD_REG)

#define `$INSTANCE_NAME`_TX_STATUS_MASK_REG    (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_TxStsReg__MASK_REG)
#define `$INSTANCE_NAME`_TX_STATUS_MASK_PTR    (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_TxStsReg__MASK_REG)

#define `$INSTANCE_NAME`_RX_STATUS_MASK_REG    (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_RxStsReg__MASK_REG)
#define `$INSTANCE_NAME`_RX_STATUS_MASK_PTR    (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_RxStsReg__MASK_REG)

#define `$INSTANCE_NAME`_ONE_REG               (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_SPISlave_dpCounter_u0__D1_REG)
#define `$INSTANCE_NAME`_ONE_PTR               (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_dpCounter_u0__D1_REG)

#define `$INSTANCE_NAME`_TX_STATUS_REG         (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_TxStsReg__STATUS_REG)
#define `$INSTANCE_NAME`_TX_STATUS_PTR         (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS__TxStsReg__STATUS_REG)

#define `$INSTANCE_NAME`_RX_STATUS_REG         (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_RxStsReg__STATUS_REG)
#define `$INSTANCE_NAME`_RX_STATUS_PTR         (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_RxStsReg__STATUS_REG)

#define `$INSTANCE_NAME`_COUNTER_CONTROL_REG   (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_BitCounter__CONTROL_AUX_CTL_REG)
#define `$INSTANCE_NAME`_COUNTER_CONTROL_PTR   (  (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_BitCounter__CONTROL_AUX_CTL_REG)

#define `$INSTANCE_NAME`_TX_STATUS_ACTL_REG    (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_TxStsReg__STATUS_AUX_CTL_REG)
#define `$INSTANCE_NAME`_TX_STATUS_ACTL_PTR    (  (reg8 *) \
        `$INSTANCE_NAME`_TX_BSPIS_TxStsReg__STATUS_AUX_CTL_REG)

#define `$INSTANCE_NAME`_RX_STATUS_ACTL_REG    (* (reg8 *) \
        `$INSTANCE_NAME`_BSPIS_RxStsReg__STATUS_AUX_CTL_REG)
#define `$INSTANCE_NAME`_RX_STATUS_ACTL_PTR    (  (reg8 *) \
        `$INSTANCE_NAME`_RX_BSPIS_RxStsReg__STATUS_AUX_CTL_REG)

#if 0 // ignore bidirect
#if(`$INSTANCE_NAME`_BIDIRECTIONAL_MODE)

    #define `$INSTANCE_NAME`_CONTROL_REG       (* (reg8 *) \
   `$INSTANCE_NAME`_BSPIS_`$CtlModeReplacementString`_CtrlReg__CONTROL_REG)
    #define `$INSTANCE_NAME`_CONTROL_PTR       (  (reg8 *) \
   `$INSTANCE_NAME`_BSPIS_`$CtlModeReplacementString`_CtrlReg__CONTROL_REG)

#endif /* `$INSTANCE_NAME`_BIDIRECTIONAL_MODE */
#endif // ignore bidirect

/***************************************
*       Register Constants
***************************************/

/* Status Register Definitions */
#define `$INSTANCE_NAME`_STS_SPI_DONE_SHIFT             (0x00u)
#define `$INSTANCE_NAME`_STS_TX_FIFO_NOT_FULL_SHIFT     (0x01u)
#define `$INSTANCE_NAME`_STS_TX_FIFO_EMPTY_SHIFT        (0x02u)
#define `$INSTANCE_NAME`_STS_RX_FIFO_NOT_EMPTY_SHIFT    (0x03u)
#define `$INSTANCE_NAME`_STS_RX_FIFO_EMPTY_SHIFT        (0x04u)
#define `$INSTANCE_NAME`_STS_RX_FIFO_OVERRUN_SHIFT      (0x05u)
#define `$INSTANCE_NAME`_STS_RX_FIFO_FULL_SHIFT         (0x06u)
#define `$INSTANCE_NAME`_STS_BYTE_COMPLETE_SHIFT        (0x06u)

#define `$INSTANCE_NAME`_STS_SPI_DONE                   ((uint8)(0x01u << `$INSTANCE_NAME`_STS_SPI_DONE_SHIFT))
#define `$INSTANCE_NAME`_STS_TX_FIFO_EMPTY              ((uint8)(0x01u << `$INSTANCE_NAME`_STS_TX_FIFO_EMPTY_SHIFT))
#define `$INSTANCE_NAME`_STS_TX_FIFO_NOT_FULL           ((uint8)(0x01u << `$INSTANCE_NAME`_STS_TX_FIFO_NOT_FULL_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_FIFO_EMPTY              ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_FIFO_EMPTY_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_FIFO_NOT_EMPTY          ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_FIFO_NOT_EMPTY_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_FIFO_OVERRUN            ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_FIFO_OVERRUN_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_FIFO_FULL               ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_FIFO_FULL_SHIFT))
#define `$INSTANCE_NAME`_STS_BYTE_COMPLETE              ((uint8)(0x01u << `$INSTANCE_NAME`_STS_BYTE_COMPLETE_SHIFT))

#define `$INSTANCE_NAME`_STS_CLR_ON_RD_BYTES_MASK       (0x61u)

/* StatusI Register Interrupt Enable Control Bits */
/* As defined by the Register map for the AUX Control Register */
#define `$INSTANCE_NAME`_INT_ENABLE                     (0x10u)
#define `$INSTANCE_NAME`_TX_FIFO_CLR    (0x01u) /* F0 - TX FIFO */
#define `$INSTANCE_NAME`_RX_FIFO_CLR    (0x02u) /* F1 - RX FIFO */
#define `$INSTANCE_NAME`_FIFO_CLR       (`$INSTANCE_NAME`_TX_FIFO_CLR | `$INSTANCE_NAME`_RX_FIFO_CLR)

/* Bit Counter (7-bit) Control Register Bit Definitions */
/* As defined by the Register map for the AUX Control Register */
#define `$INSTANCE_NAME`_CNTR_ENABLE                    (0x20u)

/* Bi-Directional mode control bit */
#define `$INSTANCE_NAME`_CTRL_TX_SIGNAL_EN              (0x01u)

/* Datapath Auxillary Control Register definitions */
#define `$INSTANCE_NAME`_AUX_CTRL_FIFO0_CLR             (0x00u)
#define `$INSTANCE_NAME`_AUX_CTRL_FIFO1_CLR             (0x00u)
#define `$INSTANCE_NAME`_AUX_CTRL_FIFO0_LVL             (0x00u)
#define `$INSTANCE_NAME`_AUX_CTRL_FIFO1_LVL             (0x00u)
#define `$INSTANCE_NAME`_STATUS_ACTL_INT_EN_MASK        (0x10u)

/* Component disabled */
#define `$INSTANCE_NAME`_DISABLED   (0u)

/***************************************
* The following code is DEPRECATED and 
* should not be used in new projects.
***************************************/

#define `$INSTANCE_NAME`_TXDATA_ZERO               (`$INSTANCE_NAME`_TXDATA_ZERO_REG)
#define `$INSTANCE_NAME`_TXDATA                    (`$INSTANCE_NAME`_TXDATA_REG)
#define `$INSTANCE_NAME`_RXDATA                    (`$INSTANCE_NAME`_RXDATA_REG)
#define `$INSTANCE_NAME`_MISO_AUX_CONTROLDP0       (`$INSTANCE_NAME`_MISO_AUX_CTRL_DP0_REG)
#define `$INSTANCE_NAME`_MOSI_AUX_CONTROLDP0       (`$INSTANCE_NAME`_MOSI_AUX_CTRL_DP0_REG)
#define `$INSTANCE_NAME`_TXBUFFERREAD              (`$INSTANCE_NAME`_txBufferRead)
#define `$INSTANCE_NAME`_TXBUFFERWRITE             (`$INSTANCE_NAME`_txBufferWrite)
#define `$INSTANCE_NAME`_RXBUFFERREAD              (`$INSTANCE_NAME`_rxBufferRead)
#define `$INSTANCE_NAME`_RXBUFFERWRITE             (`$INSTANCE_NAME`_rxBufferWrite)

#if(`$INSTANCE_NAME`_DATA_WIDTH > 8u)

    #define `$INSTANCE_NAME`_MISO_AUX_CONTROLDP1   (`$INSTANCE_NAME`_MISO_AUX_CTRL_DP1_REG)
    #define `$INSTANCE_NAME`_MOSI_AUX_CONTROLDP1   (`$INSTANCE_NAME`_MOSI_AUX_CTRL_DP0_REG)

#endif /* `$INSTANCE_NAME`_DATA_WIDTH > 8u */

#define `$INSTANCE_NAME`_COUNTER_PERIOD            (`$INSTANCE_NAME`_COUNTER_PERIOD_REG)
#define `$INSTANCE_NAME`_COUNTER_CONTROL           (`$INSTANCE_NAME`_COUNTER_CONTROL_REG)
#define `$INSTANCE_NAME`_ONE                       (`$INSTANCE_NAME`_ONE_REG)
#define `$INSTANCE_NAME`_STATUS                    (`$INSTANCE_NAME`_TX_STATUS_REG)
#define `$INSTANCE_NAME`_STATUS_MASK               (`$INSTANCE_NAME`_TX_STATUS_MASK_REG)
#define `$INSTANCE_NAME`_STATUS_ACTL               (`$INSTANCE_NAME`_TX_STATUS_ACTL_REG)

#define `$INSTANCE_NAME`_WriteByte      (`$INSTANCE_NAME`_WriteTxData)
#define `$INSTANCE_NAME`_ReadByte       (`$INSTANCE_NAME`_ReadRxData)
#define `$INSTANCE_NAME`_WriteByteZero  (`$INSTANCE_NAME`_WriteTxDataZero)
void  `$INSTANCE_NAME`_SetInterruptMode(uint8 intSrc) `=ReentrantKeil($INSTANCE_NAME . "_SetInterruptMode")`;
uint8 `$INSTANCE_NAME`_ReadStatus(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadStatus")`;
void  `$INSTANCE_NAME`_EnableInt(void) `=ReentrantKeil($INSTANCE_NAME . "_EnableInt")`;
void  `$INSTANCE_NAME`_DisableInt(void) `=ReentrantKeil($INSTANCE_NAME . "_DisableInt")`;

#define `$INSTANCE_NAME`_STS_TX_BUF_NOT_FULL_SHIFT      (0x01u)
#define `$INSTANCE_NAME`_STS_TX_BUF_FULL_SHIFT          (0x02u)
#define `$INSTANCE_NAME`_STS_RX_BUF_NOT_EMPTY_SHIFT     (0x03u)
#define `$INSTANCE_NAME`_STS_RX_BUF_EMPTY_SHIFT         (0x04u)
#define `$INSTANCE_NAME`_STS_RX_BUF_OVERRUN_SHIFT       (0x05u)

#define `$INSTANCE_NAME`_STS_TX_BUF_NOT_FULL            ((uint8)(0x01u << `$INSTANCE_NAME`_STS_TX_BUF_NOT_FULL_SHIFT))
#define `$INSTANCE_NAME`_STS_TX_BUF_FULL                ((uint8)(0x01u << `$INSTANCE_NAME`_STS_TX_BUF_FULL_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_BUF_NOT_EMPTY           ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_BUF_NOT_EMPTY_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_BUF_EMPTY               ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_BUF_EMPTY_SHIFT))
#define `$INSTANCE_NAME`_STS_RX_BUF_OVERRUN             ((uint8)(0x01u << `$INSTANCE_NAME`_STS_RX_BUF_OVERRUN_SHIFT))

#define `$INSTANCE_NAME`_DataWidth                  (`$INSTANCE_NAME`_DATA_WIDTH)
#define `$INSTANCE_NAME`_InternalClockUsed          (`$INSTANCE_NAME`_INTERNAL_CLOCK)
#define `$INSTANCE_NAME`_InternalTxInterruptEnabled (`$INSTANCE_NAME`_INTERNAL_TX_INT_ENABLED)
#define `$INSTANCE_NAME`_InternalRxInterruptEnabled (`$INSTANCE_NAME`_INTERNAL_RX_INT_ENABLED)
#define `$INSTANCE_NAME`_ModeUseZero                (`$INSTANCE_NAME`_MODE_USE_ZERO)
//#define `$INSTANCE_NAME`_BidirectionalMode          (`$INSTANCE_NAME`_BIDIRECTIONAL_MODE)
#define `$INSTANCE_NAME`_Mode                       (`$INSTANCE_NAME`_MODE)
#define `$INSTANCE_NAME`_DATAWIDHT                  (`$INSTANCE_NAME`_DATA_WIDTH)
#define `$INSTANCE_NAME`_InternalInterruptEnabled   (`$InternalInterruptEnabled`u)

#define `$INSTANCE_NAME`_TXBUFFERSIZE   (`$INSTANCE_NAME`_TX_BUFFER_SIZE)
#define `$INSTANCE_NAME`_RXBUFFERSIZE   (`$INSTANCE_NAME`_RX_BUFFER_SIZE)

#define `$INSTANCE_NAME`_TXBUFFER       `$INSTANCE_NAME`_txBuffer
#define `$INSTANCE_NAME`_RXBUFFER       `$INSTANCE_NAME`_rxBuffer

#endif  /* CY_SPIS_`$INSTANCE_NAME`_H */

/* [] END OF FILE */

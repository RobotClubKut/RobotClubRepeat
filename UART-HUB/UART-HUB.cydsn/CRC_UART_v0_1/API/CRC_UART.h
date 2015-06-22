/*******************************************************************************
* File Name: `$INSTANCE_NAME`.h
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  This file provides constants and parameter values for the CRC component.
*
* Note:
*  None
*
********************************************************************************
* Copyright 2008-2013, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions,
* disclaimers, and limitations in the end user license agreement accompanying
* the software package with which this file was provided.
*******************************************************************************/

#if !defined(CRC_UART_`$INSTANCE_NAME`_H)
#define CRC_UART_`$INSTANCE_NAME`_H

#include "cytypes.h"
#include "cyfitter.h"
#include "CyLib.h"


/***************************************
*   Conditional Compilation Parameters
****************************************/

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */

#if !defined (CY_PSOC5A)
    #error Component `$CY_COMPONENT_NAME` requires cy_boot v3.0 or later
#endif /* (CY_ PSOC5A) */

#define `$INSTANCE_NAME`_CRC_SIZE                   (`$Resolution`u)
#define `$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE   (`$TimeMultiplexing`u)


/***************************************
*       Type defines
***************************************/

/* Structure to save registers before go to sleep */
typedef struct
{
    uint8 enableState;

    /* Save D0 and D1 registers are none-retention for Panther ES1 */
    #if (CY_UDB_V0)

        #if (`$INSTANCE_NAME`_CRC_SIZE <= 32u)
            `$RegSizeReplacementString` polynomial;

        #else
            uint32 polynomialUpper;
            uint32 polynomialLower;

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

    #endif  /* End (CY_UDB_V0) */

} `$INSTANCE_NAME`_BACKUP_STRUCT;

extern uint8 `$INSTANCE_NAME`_initVar;

extern `$INSTANCE_NAME`_BACKUP_STRUCT `$INSTANCE_NAME`_backup;


/***************************************
*        Function Prototypes
****************************************/

void `$INSTANCE_NAME`_Init(void) `=ReentrantKeil($INSTANCE_NAME . "_Init")`;
void `$INSTANCE_NAME`_Enable(void) `=ReentrantKeil($INSTANCE_NAME . "_Enable")`;
void `$INSTANCE_NAME`_Start(void) `=ReentrantKeil($INSTANCE_NAME . "_Start")`;
void `$INSTANCE_NAME`_Stop(void) `=ReentrantKeil($INSTANCE_NAME . "_Stop")`;
void `$INSTANCE_NAME`_SaveConfig(void) `=ReentrantKeil($INSTANCE_NAME . "_SaveConfig")`;
void `$INSTANCE_NAME`_Sleep(void) `=ReentrantKeil($INSTANCE_NAME . "_Sleep")`;
void `$INSTANCE_NAME`_RestoreConfig(void) `=ReentrantKeil($INSTANCE_NAME . "_RestoreConfig")`;
void `$INSTANCE_NAME`_Wakeup(void) `=ReentrantKeil($INSTANCE_NAME . "_Wakeup")`;

#if (`$INSTANCE_NAME`_CRC_SIZE <= 32u)    /* 8-32 bits CRC */
    `$RegSizeReplacementString` `$INSTANCE_NAME`_ReadCRC(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRC")`;
    void `$INSTANCE_NAME`_WriteSeed(`$RegSizeReplacementString` seed)  `=ReentrantKeil($INSTANCE_NAME . "_WriteSeed")`;
    `$RegSizeReplacementString` `$INSTANCE_NAME`_ReadPolynomial(void)
                                               `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomial")`;
    void `$INSTANCE_NAME`_WritePolynomial(`$RegSizeReplacementString` polynomial)
                                          `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomial")`;

#else                                    /* 33-64 bits CRC */
    uint32 `$INSTANCE_NAME`_ReadCRCUpper(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRCUpper")`;
    uint32 `$INSTANCE_NAME`_ReadCRCLower(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRCLower")`;
    void `$INSTANCE_NAME`_WriteSeedUpper(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_WriteSeedUpper")`;
    void `$INSTANCE_NAME`_WriteSeedLower(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_WriteSeedLower")`;
    uint32 `$INSTANCE_NAME`_ReadPolynomialUpper(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomialUpper")`;
    uint32 `$INSTANCE_NAME`_ReadPolynomialLower(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomialLower")`;
    void `$INSTANCE_NAME`_WritePolynomialUpper(uint32 polynomial)
                                                `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomialUpper")`;
    void `$INSTANCE_NAME`_WritePolynomialLower(uint32 polynomial)
                                                `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomialLower")`;

#endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

#if (`$INSTANCE_NAME`_CRC_SIZE <= 32u) /* 8-32 bits CRC */
    void `$INSTANCE_NAME`_ResetSeedInit(`$RegSizeReplacementString` seed)
                                        `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInit")`;
#else
    void `$INSTANCE_NAME`_ResetSeedInitUpper(uint32 seed)
                                        `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInitUpper")`;
    void `$INSTANCE_NAME`_ResetSeedInitLower(uint32 seed)
                                        `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInitLower")`;
#endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */


/***************************************
*    Initial Parameter Constants
***************************************/

#if (`$INSTANCE_NAME`_CRC_SIZE <= 32u)
    #define `$INSTANCE_NAME`_DEFAULT_POLYNOM            (`$PolyValueLower`u)
    #define `$INSTANCE_NAME`_DEFAULT_SEED               (`$SeedValueLower`u)

#else
    #define `$INSTANCE_NAME`_DEFAULT_POLYNOM_UPPER      (`$PolyValueUpper`u)
    #define `$INSTANCE_NAME`_DEFAULT_POLYNOM_LOWER      (`$PolyValueLower`u)
    #define `$INSTANCE_NAME`_DEFAULT_SEED_UPPER         (`$SeedValueUpper`u)
    #define `$INSTANCE_NAME`_DEFAULT_SEED_LOWER         (`$SeedValueLower`u)

#endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */


/***************************************
*           API Constants
***************************************/

#define `$INSTANCE_NAME`_MASK                           (`$Mask`u)


/***************************************
*             Registers
***************************************/

#define `$INSTANCE_NAME`_EXECUTE_DFF_RESET    { `$INSTANCE_NAME`_CONTROL_REG |= `$INSTANCE_NAME`_CTRL_RESET; \
    `$INSTANCE_NAME`_CONTROL_REG &= (uint8)~`$INSTANCE_NAME`_CTRL_RESET; }


#if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)
    #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)      /* 16 bits CRC */
        /* Polynomial */
        #define `$INSTANCE_NAME`_POLYNOM_A__D1_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed */
        #define `$INSTANCE_NAME`_SEED_A__A1_REG             (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_A__A1_PTR             ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_REG             (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_PTR             ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* Seed COPY */
        #define `$INSTANCE_NAME`_SEED_COPY_A__A1_REG        (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A1_PTR        ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_REG        (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_PTR        ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)      /* 24 bits CRC */
        /* Polynomial */
        #define `$INSTANCE_NAME`_POLYNOM_B__D1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed */
        #define `$INSTANCE_NAME`_SEED_B__A1_REG             (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_B__A1_PTR             ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_B__A0_REG             (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_B__A0_PTR             ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_REG             (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_PTR             ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* Seed COPY */
        #define `$INSTANCE_NAME`_SEED_COPY_B__A1_REG        (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A1_PTR        ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A0_REG        (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A0_PTR        ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_REG        (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_PTR        ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 32u)      /* 32 bits CRC */
        /* Polynomial */
        #define `$INSTANCE_NAME`_POLYNOM_B__D1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D1_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_B__D0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_A__D0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed */
        #define `$INSTANCE_NAME`_SEED_B__A1_REG             (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_B__A1_PTR             ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_A__A1_REG             (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_A__A1_PTR             ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_B__A0_REG             (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_B__A0_PTR             ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_REG             (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_A__A0_PTR             ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* Seed COPY */
        #define `$INSTANCE_NAME`_SEED_COPY_B__A1_REG        (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A1_PTR        ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A1_REG        (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A1_PTR        ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A0_REG        (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_B__A0_PTR        ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_REG        (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_COPY_A__A0_PTR        ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 40u)      /* 40 bits CRC */
        /* Polynomial Upper */
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        /* Polynomial Lower */
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        /* Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* Seed COPY Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        /* Seed COPY Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)      /* 48 bits CRC */
        /* Polynomial Upper */
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        /* Polynomial Lower */
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        /* Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* Seed COPY Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        /* Seed COPY Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)      /* 56 bits CRC */
        /* Polynom Upper */
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        /* Polynom Lower */
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_D__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        /* Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_D__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_D__A0_PTR                  ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* COPY Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        /* COPY Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_D__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_D__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )

    #else                                        /* 64 bits CRC */
        /* Polynom Upper */
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_A__D1_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        #define `$INSTANCE_NAME`_POLYNOM_UPPER_A__D1_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D1_REG )
        /* Polynom Lower */
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG            (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        #define `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_PTR            ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__D0_REG )
        /* Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_D__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_C__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_B__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_A__A1_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_A__A1_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A1_REG )
        /* Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_D__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_D__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_C__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_B__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG               (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_A__A0_PTR               ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__A0_REG )
        /* COPY Seed Upper */
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_A__A1_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        #define `$INSTANCE_NAME`_SEED_UPPER_COPY_A__A1_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F1_REG )
        /* COPY Seed Lower */
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_D__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_D__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG          (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
        #define `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_PTR          ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__F0_REG )
    #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

#else
    #if (CY_PSOC3 || CY_PSOC5)
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 32u)         /* 8-32 bits CRC */
            /* Polynomial */
            #define `$INSTANCE_NAME`_POLYNOM_PTR      ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__D0_REG )
            /* Seed */
            #define `$INSTANCE_NAME`_SEED_PTR         ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__A0_REG )
            /* Seed COPY */
            #define `$INSTANCE_NAME`_SEED_COPY_PTR    ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__F0_REG )

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */
    #else /* PSoC4 */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 8u)         /* 8 bits CRC */
            /* Polynomial */
            #define `$INSTANCE_NAME`_POLYNOM_PTR      ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__D0_REG )
            /* Seed */
            #define `$INSTANCE_NAME`_SEED_PTR         ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__A0_REG )
            /* Seed COPY */
            #define `$INSTANCE_NAME`_SEED_COPY_PTR    ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__F0_REG )

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 16u)         /* 16 bits CRC */
            /* Polynomial */
            #define `$INSTANCE_NAME`_POLYNOM_PTR      ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__16BIT_D0_REG )
            /* Seed */
            #define `$INSTANCE_NAME`_SEED_PTR         ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__16BIT_A0_REG )
            /* Seed COPY */
            #define `$INSTANCE_NAME`_SEED_COPY_PTR    ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__16BIT_F0_REG )

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)         /* 24 bits CRC */
            /* Polynomial */
            #define `$INSTANCE_NAME`_POLYNOM_PTR      ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__D0_REG )
            /* Seed */
            #define `$INSTANCE_NAME`_SEED_PTR         ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__A0_REG )
            /* Seed COPY */
            #define `$INSTANCE_NAME`_SEED_COPY_PTR    ( (`$RegDefReplacementString` *)\
                                                `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__F0_REG )

         #else                                          /* 32 bits CRC */
            /* Polynomial */
            #define `$INSTANCE_NAME`_POLYNOM_PTR      ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__32BIT_D0_REG )
            /* Seed */
            #define `$INSTANCE_NAME`_SEED_PTR         ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__32BIT_A0_REG )
            /* Seed COPY */
            #define `$INSTANCE_NAME`_SEED_COPY_PTR    ( (`$RegDefReplacementString` *)\
                                            `$INSTANCE_NAME`_`$VerilogSectionReplacementString`_CRCdp_u0__32BIT_F0_REG )

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

    #endif  /* End (CY_PSOC3 || CY_PSOC5) */

#endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */

/* Aux control */
#if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)
    #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)      /* 8-16 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG              (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR              ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 32u)      /* 17-32 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG              (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR              ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG              (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR              ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)      /* 33-48 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG              (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR              ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG              (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR              ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_REG              (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_PTR              ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__DP_AUX_CTL_REG )

    #else                                         /* 48-64 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG              (*(reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR              ( (reg8 *) `$INSTANCE_NAME`_b0_CRCdp_a__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG              (*(reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR              ( (reg8 *) `$INSTANCE_NAME`_b1_CRCdp_b__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_REG              (*(reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_PTR              ( (reg8 *) `$INSTANCE_NAME`_b2_CRCdp_c__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_D_REG              (*(reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_D_PTR              ( (reg8 *) `$INSTANCE_NAME`_b3_CRCdp_d__DP_AUX_CTL_REG )

    #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

#else
    #if (`$INSTANCE_NAME`_CRC_SIZE <= 8u)      /* 8 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG          (*(reg8 *) `$INSTANCE_NAME`_sC8_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC8_CRCdp_u0__DP_AUX_CTL_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 16u)      /* 16 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG          (*(reg8 *) `$INSTANCE_NAME`_sC16_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC16_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG          (*(reg8 *) `$INSTANCE_NAME`_sC16_CRCdp_u1__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC16_CRCdp_u1__DP_AUX_CTL_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)      /* 24-39 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG          (*(reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG          (*(reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u1__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u1__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_REG          (*(reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u2__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC24_CRCdp_u2__DP_AUX_CTL_REG )

    #elif (`$INSTANCE_NAME`_CRC_SIZE <= 32u)      /* 40-55 bits CRC */
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_REG          (*(reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_A_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u0__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_REG          (*(reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u1__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_B_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u1__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_REG          (*(reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u2__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_C_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u2__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_D_REG          (*(reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u3__DP_AUX_CTL_REG )
        #define `$INSTANCE_NAME`_AUX_CONTROL_D_PTR          ( (reg8 *) `$INSTANCE_NAME`_sC32_CRCdp_u3__DP_AUX_CTL_REG )

    #else                                         /* 56-64 bits CRC */
        /* Not supported */
    #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

#endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */

#if (CY_UDB_V0)
    #define `$INSTANCE_NAME`_CONTROL_REG                    (*(reg8 *) `$INSTANCE_NAME`_AsyncCtrl_CtrlReg__CONTROL_REG )
    #define `$INSTANCE_NAME`_CONTROL_PTR                    ( (reg8 *) `$INSTANCE_NAME`_AsyncCtrl_CtrlReg__CONTROL_REG )

#else
    #define `$INSTANCE_NAME`_CONTROL_REG                    (*(reg8 *) `$INSTANCE_NAME`_SyncCtrl_CtrlReg__CONTROL_REG )
    #define `$INSTANCE_NAME`_CONTROL_PTR                    ( (reg8 *) `$INSTANCE_NAME`_SyncCtrl_CtrlReg__CONTROL_REG )

#endif  /* End (CY_UDB_V0) */


/***************************************
*       Register Constants
***************************************/

/* Control register definitions */
#define `$INSTANCE_NAME`_CTRL_ENABLE                    (0x01u)
#define `$INSTANCE_NAME`_CTRL_RESET                     (0x02u)

/* Aux Control register definitions */
#define `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG        (0x03u)

#define `$INSTANCE_NAME`_IS_CRC_ENABLE(reg)             (((reg) & `$INSTANCE_NAME`_CTRL_ENABLE) != 0u)

#endif  /* End CRC_UART_`$INSTANCE_NAME`_H */

/* [] END OF FILE */

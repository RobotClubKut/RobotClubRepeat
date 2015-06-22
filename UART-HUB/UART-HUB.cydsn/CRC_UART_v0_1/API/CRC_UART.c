/*******************************************************************************
* File Name: `$INSTANCE_NAME`.c
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  This file provides the source code to the API for the CRC component
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

#include "`$INSTANCE_NAME`.h"

uint8 `$INSTANCE_NAME`_initVar = 0u;

`$INSTANCE_NAME`_BACKUP_STRUCT `$INSTANCE_NAME`_backup =
{
    0x00u, /* enableState; */

    /* Save D0 and D1 registers are none-retention for Panther ES1 */
    #if (CY_UDB_V0)

        #if(`$INSTANCE_NAME`_CRC_SIZE <= 32u)
            `$INSTANCE_NAME`_DEFAULT_POLYNOM, /* polynomial; */

        #else
            `$INSTANCE_NAME`_DEFAULT_POLYNOM_UPPER, /* polynomialUpper; */
            `$INSTANCE_NAME`_DEFAULT_POLYNOM_LOWER,  /* polynomialLower; */

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

    #endif  /* End (CY_UDB_V0) */
};


/*******************************************************************************
* Function Name: `$INSTANCE_NAME`_Init
********************************************************************************
*
* Summary:
*  Initializes seed and polynomial registers with initial values.
*
* Parameters:
*  void
*
* Return:
*  void
*
*******************************************************************************/
void `$INSTANCE_NAME`_Init(void) `=ReentrantKeil($INSTANCE_NAME . "_Init")`
{
    /* Writes seed value and ponynom value provided for customizer */
    #if (`$INSTANCE_NAME`_CRC_SIZE <= 32u)
        `$INSTANCE_NAME`_WritePolynomial(`$INSTANCE_NAME`_DEFAULT_POLYNOM);
        `$INSTANCE_NAME`_WriteSeed(`$INSTANCE_NAME`_DEFAULT_SEED);
        `$INSTANCE_NAME`_ResetSeedInit(`$INSTANCE_NAME`_DEFAULT_SEED);

    #else
        `$INSTANCE_NAME`_WritePolynomialUpper(`$INSTANCE_NAME`_DEFAULT_POLYNOM_UPPER);
        `$INSTANCE_NAME`_WritePolynomialLower(`$INSTANCE_NAME`_DEFAULT_POLYNOM_LOWER);
        `$INSTANCE_NAME`_WriteSeedUpper(`$INSTANCE_NAME`_DEFAULT_SEED_UPPER);
        `$INSTANCE_NAME`_WriteSeedLower(`$INSTANCE_NAME`_DEFAULT_SEED_LOWER);
        `$INSTANCE_NAME`_ResetSeedInitUpper(`$INSTANCE_NAME`_DEFAULT_SEED_UPPER);
        `$INSTANCE_NAME`_ResetSeedInitLower(`$INSTANCE_NAME`_DEFAULT_SEED_LOWER);

    #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */
}


/*******************************************************************************
* Function Name: `$INSTANCE_NAME`_Enable
********************************************************************************
*
* Summary:
*  Starts CRC computation on rising edge of input clock.
*
* Parameters:
*  void
*
* Return:
*  void
*
*******************************************************************************/
void `$INSTANCE_NAME`_Enable(void) `=ReentrantKeil($INSTANCE_NAME . "_Enable")`
{
    `$INSTANCE_NAME`_CONTROL_REG |= `$INSTANCE_NAME`_CTRL_ENABLE;
}


/*******************************************************************************
* Function Name: `$INSTANCE_NAME`_Start
********************************************************************************
*
* Summary:
*  Initializes seed and polynomial registers with initial values. Computation
*  of CRC starts on rising edge of input clock.
*
* Parameters:
*  void
*
* Return:
*  void
*
* Global variables:
*  `$INSTANCE_NAME`_initVar: global variable is used to indicate initial
*  configuration of this component.  The variable is initialized to zero and set
*  to 1 the first time `$INSTANCE_NAME`_Start() is called. This allows
*  enable/disable component without re-initialization in all subsequent calls
*  to the `$INSTANCE_NAME`_Start() routine.
*
*******************************************************************************/
void `$INSTANCE_NAME`_Start(void) `=ReentrantKeil($INSTANCE_NAME . "_Start")`
{
    /* Writes seed value and ponynom value provided from customizer */
    if (`$INSTANCE_NAME`_initVar == 0u)
    {
        `$INSTANCE_NAME`_Init();
        `$INSTANCE_NAME`_initVar = 1u;
    }

    `$INSTANCE_NAME`_Enable();
}


/*******************************************************************************
* Function Name: `$INSTANCE_NAME`_Stop
********************************************************************************
*
* Summary:
*  Stops CRC computation.
*
* Parameters:
*  void
*
* Return:
*  void
*
* Reentrant:
*  No
*
*******************************************************************************/
void `$INSTANCE_NAME`_Stop(void) `=ReentrantKeil($INSTANCE_NAME . "_Stop")`
{
    `$INSTANCE_NAME`_CONTROL_REG &= ((uint8)~`$INSTANCE_NAME`_CTRL_ENABLE);
}


#if (`$INSTANCE_NAME`_CRC_SIZE <= 32u) /* 8-32 bits CRC */
    /*******************************************************************************
    * FUNCTION NAME: `$INSTANCE_NAME`_ResetSeedInit
    ********************************************************************************
    *
    * Summary:
    *  Increments the CRC by one when API single step mode is used.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  void
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_ResetSeedInit(`$RegSizeReplacementString` seed)
                                        `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInit")`
    {
         uint8 enableInterrupts;

        /* Mask the Seed to cut unused bits */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            seed &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Change AuxControl reg, need to be safety */
        enableInterrupts = CyEnterCriticalSection();

        #if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)
            /* Set FIFOs to single register */
            `$INSTANCE_NAME`_AUX_CONTROL_A_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

            #if(`$INSTANCE_NAME`_CRC_SIZE > 16u)       /* 17-32 bits CRC */
                `$INSTANCE_NAME`_AUX_CONTROL_B_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

            /* AuxControl reg settings are done */
            CyExitCriticalSection(enableInterrupts);

            /* Write Seed COPY */
            #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)          /* 16 bits CRC */
                `$INSTANCE_NAME`_SEED_COPY_A__A1_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_COPY_A__A0_REG = LO8(seed);

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)        /* 24 bits CRC */
                `$INSTANCE_NAME`_SEED_COPY_B__A1_REG = LO8(HI16(seed));
                `$INSTANCE_NAME`_SEED_COPY_B__A0_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_COPY_A__A0_REG = LO8(seed);

            #else                                           /* 32 bits CRC */
                `$INSTANCE_NAME`_SEED_COPY_B__A1_REG = HI8(HI16(seed));
                `$INSTANCE_NAME`_SEED_COPY_A__A1_REG = LO8(HI16(seed));
                `$INSTANCE_NAME`_SEED_COPY_B__A0_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_COPY_A__A0_REG = LO8(seed);
            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        #else
            /* Set FIFOs to single register */
            #if (`$INSTANCE_NAME`_CRC_SIZE <= 8u)         /* 8 bits CRC */
                `$INSTANCE_NAME`_AUX_CONTROL_A_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 16u)      /* 16 bits CRC */
                `$INSTANCE_NAME`_AUX_CONTROL_A_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_B_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)      /* 24 bits CRC */
                `$INSTANCE_NAME`_AUX_CONTROL_A_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_B_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_C_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 32u)      /* 32 bits CRC */
                `$INSTANCE_NAME`_AUX_CONTROL_A_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_B_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_C_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
                `$INSTANCE_NAME`_AUX_CONTROL_D_REG  |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

            /* AuxControl reg setting are done */
            CyExitCriticalSection(enableInterrupts);

            /* Write Seed COPY */
            `$CySetRegReplacementString`(`$INSTANCE_NAME`_SEED_COPY_PTR, seed);
        #endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */
    }

#else

    /*******************************************************************************
    * FUNCTION NAME: `$INSTANCE_NAME`_ResetSeedInitUpper
    ********************************************************************************
    *
    * Summary:
    *  Increments the CRC by one when API single step mode is used.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  void
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_ResetSeedInitUpper(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInitUpper")`
    {
        uint8 enableInterrupts;

        /* Mask the Seed Upper half to cut unused bits in case, when CRC size is not byte-aligned or equal 24 */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            seed &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Change AuxControl reg, need to be safety */
        enableInterrupts = CyEnterCriticalSection();

        /* Set FIFOs to single register */
        `$INSTANCE_NAME`_AUX_CONTROL_A_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
        `$INSTANCE_NAME`_AUX_CONTROL_B_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
        `$INSTANCE_NAME`_AUX_CONTROL_C_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;

        #if (`$INSTANCE_NAME`_CRC_SIZE > 48u)               /* 49-64 bits CRC */
            `$INSTANCE_NAME`_AUX_CONTROL_D_REG |= `$INSTANCE_NAME`_AUXCTRL_FIFO_SINGLE_REG;
        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */

        /* AuxControl reg settings are done */
        CyExitCriticalSection(enableInterrupts);

        /* Write Seed Upper COPY */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)        /* 56 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG = HI8(seed);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_COPY_D__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_COPY_C__A1_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_COPY_B__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_COPY_A__A1_REG = LO8(seed);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */
    }


    /*******************************************************************************
    * FUNCTION NAME: `$INSTANCE_NAME`_ResetSeedInitLower
    ********************************************************************************
    *
    * Summary:
    *  Increments the CRC by one when API single step mode is used.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  void
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_ResetSeedInitLower(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_ResetSeedInitLower")`
    {
        /* Write Seed Lower COPY */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG = LO8(seed);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_COPY_D__A0_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_COPY_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_COPY_A__A0_REG = LO8(seed);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */
    }
#endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */


#if(`$INSTANCE_NAME`_CRC_SIZE <= 32u) /* 8-32 bits CRC */
    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_ReadCRC
    ********************************************************************************
    *
    * Summary:
    *  Reads CRC value.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns CRC value.
    *
    * Side Effects:
    *  The CRC value is cut according to mask = 2^(Resolution) - 1.
    *  For example if CRC Resolution is 14 bits the mask value is:
    *  mask = 2^(14) - 1 = 0x3FFFu.
    *  The seed value = 0xFFFFu is cut:
    *  seed & mask = 0xFFFFu & 0x3FFFu = 0x3FFFu.
    *
    *******************************************************************************/
    `$RegSizeReplacementString` `$INSTANCE_NAME`_ReadCRC(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRC")`
    {
        /* Read CRC */
        #if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)

            `$RegSizeReplacementString` seed;

            #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)          /* 16 bits CRC */
                seed = ((uint16) `$INSTANCE_NAME`_SEED_A__A1_REG) << 8u;
                seed |= `$INSTANCE_NAME`_SEED_A__A0_REG;

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)        /* 24 bits CRC */
                seed = ((uint32) (`$INSTANCE_NAME`_SEED_B__A1_REG)) << 16u;
                seed |= ((uint32) (`$INSTANCE_NAME`_SEED_B__A0_REG)) << 8u;
                seed |= `$INSTANCE_NAME`_SEED_A__A0_REG;

            #else                                           /* 32 bits CRC */
                seed = ((uint32) `$INSTANCE_NAME`_SEED_B__A1_REG) << 24u;
                seed |= ((uint32) `$INSTANCE_NAME`_SEED_A__A1_REG) << 16u;
                seed |= ((uint32) `$INSTANCE_NAME`_SEED_B__A0_REG) << 8u;
                seed |= `$INSTANCE_NAME`_SEED_A__A0_REG;

            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 8u) */
            
            #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
                seed &= `$INSTANCE_NAME`_MASK;
            #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */
            
            return (seed);

        #else
            
            #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
                return (`$CyGetRegReplacementString`(`$INSTANCE_NAME`_SEED_PTR)  & `$INSTANCE_NAME`_MASK);
            #else
                return (`$CyGetRegReplacementString`(`$INSTANCE_NAME`_SEED_PTR));
            #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */
            

        #endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WriteSeed
    ********************************************************************************
    *
    * Summary:
    *  Writes seed value.
    *
    * Parameters:
    *  seed:  Seed value.
    *
    * Return:
    *  void
    *
    * Side Effects:
    *  The seed value is cut according to mask = 2^(Resolution) - 1.
    *  For example if CRC Resolution is 14 bits the mask value is:
    *  mask = 2^(14) - 1 = 0x3FFFu.
    *  The seed value = 0xFFFFu is cut:
    *  seed & mask = 0xFFFFu & 0x3FFFu = 0x3FFFu.
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WriteSeed(`$RegSizeReplacementString` seed) `=ReentrantKeil($INSTANCE_NAME . "_WriteSeed")`
    {
        /* Mask the Seed Upper half to cut unused bits in case, when CRC size is not byte-aligned or equal 24 */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            seed &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Writes Seed */
        #if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)

            #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)          /* 16 bits CRC */
                `$INSTANCE_NAME`_SEED_A__A1_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_A__A0_REG = LO8(seed);

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)        /* 24 bits CRC */
                `$INSTANCE_NAME`_SEED_B__A1_REG = LO8(HI16(seed));
                `$INSTANCE_NAME`_SEED_B__A0_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_A__A0_REG = LO8(seed);

            #else                                           /* 32 bits CRC */
                `$INSTANCE_NAME`_SEED_B__A1_REG = HI8(HI16(seed));
                `$INSTANCE_NAME`_SEED_A__A1_REG = LO8(HI16(seed));
                `$INSTANCE_NAME`_SEED_B__A0_REG = HI8(seed);
                `$INSTANCE_NAME`_SEED_A__A0_REG = LO8(seed);
            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

            /* Resets triggers */
            `$INSTANCE_NAME`_EXECUTE_DFF_RESET;

        #else

            `$CySetRegReplacementString`(`$INSTANCE_NAME`_SEED_PTR, seed);

        #endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_ReadPolynomial
    ********************************************************************************
    *
    * Summary:
    *  Reads CRC polynomial value.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns CRC polynomial value.
    *
    *******************************************************************************/
    `$RegSizeReplacementString` `$INSTANCE_NAME`_ReadPolynomial(void)
                                               `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomial")`
    {
        /* Reads polynomial */
        #if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)

            `$RegSizeReplacementString` polynomial;

            #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)          /* 16 bits CRC */
                polynomial = ((uint16) `$INSTANCE_NAME`_POLYNOM_A__D1_REG) << 8u;
                polynomial |= (`$INSTANCE_NAME`_POLYNOM_A__D0_REG);

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)        /* 24 bits CRC */
                polynomial = ((uint32) `$INSTANCE_NAME`_POLYNOM_B__D1_REG) << 16u;
                polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_B__D0_REG) << 8u;
                polynomial |= `$INSTANCE_NAME`_POLYNOM_A__D0_REG;

            #else                                           /* 32 bits CRC */
                polynomial = ((uint32) `$INSTANCE_NAME`_POLYNOM_B__D1_REG) << 24u;
                polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_A__D1_REG) << 16u;
                polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_B__D0_REG) << 8u;
                polynomial |= `$INSTANCE_NAME`_POLYNOM_A__D0_REG;

            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

            return polynomial;

        #else

            return `$CyGetRegReplacementString`(`$INSTANCE_NAME`_POLYNOM_PTR);

        #endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WritePolynomial
    ********************************************************************************
    *
    * Summary:
    *  Writes CRC polynomial value.
    *
    * Parameters:
    *  polynomial:  CRC polynomial.
    *
    * Return:
    *  void
    *
    * Side Effects:
    *  The polynomial value is cut according to mask = 2^(Resolution) - 1.
    *  For example if CRC Resolution is 14 bits the mask value is:
    *  mask = 2^(14) - 1 = 0x3FFFu.
    *  The polynomial value = 0xFFFFu is cut:
    *  polynomial & mask = 0xFFFFu & 0x3FFFu = 0x3FFFu.
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WritePolynomial(`$RegSizeReplacementString` polynomial)
                                          `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomial")`
    {
        /* Mask polynomial to cut unused bits in case, when CRC size is not byte-aligned or equal 24 */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            polynomial &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Write polynomial */
        #if (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE)

            #if (`$INSTANCE_NAME`_CRC_SIZE <= 16u)          /* 16 bits CRC */

                `$INSTANCE_NAME`_POLYNOM_A__D1_REG = HI8(polynomial);
                `$INSTANCE_NAME`_POLYNOM_A__D0_REG = LO8(polynomial);

            #elif (`$INSTANCE_NAME`_CRC_SIZE <= 24u)        /* 24 bits CRC */
                `$INSTANCE_NAME`_POLYNOM_B__D1_REG = LO8(HI16(polynomial));
                `$INSTANCE_NAME`_POLYNOM_B__D0_REG = HI8(polynomial);
                `$INSTANCE_NAME`_POLYNOM_A__D0_REG = LO8(polynomial);

            #else                                           /* 32 bits CRC */
                `$INSTANCE_NAME`_POLYNOM_B__D1_REG = HI8(HI16(polynomial));
                `$INSTANCE_NAME`_POLYNOM_A__D1_REG = LO8(HI16(polynomial));
                `$INSTANCE_NAME`_POLYNOM_B__D0_REG = HI8(polynomial);
                `$INSTANCE_NAME`_POLYNOM_A__D0_REG = LO8(polynomial);

            #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

            /* Resets triggers */
            `$INSTANCE_NAME`_EXECUTE_DFF_RESET;

        #else

            `$CySetRegReplacementString`(`$INSTANCE_NAME`_POLYNOM_PTR, polynomial);

        #endif  /* End (`$INSTANCE_NAME`_TIME_MULTIPLEXING_ENABLE) */
    }

#else   /* 33-64 bits CRC */

    /*******************************************************************************
    *  Function Name: `$INSTANCE_NAME`_ReadCRCUpper
    ********************************************************************************
    *
    * Summary:
    *  Reads upper half of CRC value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns upper half of CRC value.
    *
    * Side Effects:
    *  The polynomial value is cut according to mask = 2^(Resolution) - 1.
    *  For example if CRC Resolution is 14 bits the mask value is:
    *  mask = 2^(14) - 1 = 0x3FFFu.
    *  The polynomial value = 0xFFFFu is cut:
    *  polynomial & mask = 0xFFFFu & 0x3FFFu = 0x3FFFu.
    *
    *******************************************************************************/
    uint32 `$INSTANCE_NAME`_ReadCRCUpper(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRCUpper")`
    {
        uint32 seed;

        /* Read CRC Upper */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            seed = `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)        /* 56 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG) << 16u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG;

        #else                                           /* 64 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG) << 24u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG) << 16u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_UPPER_A__A1_REG;

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */
        
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            seed &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */
                
        return (seed);
    }


    /*******************************************************************************
    *  Function Name: `$INSTANCE_NAME`_ReadCRCLower
    ********************************************************************************
    *
    * Summary:
    *  Reads lower half of CRC value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns lower half of CRC value.
    *
    *******************************************************************************/
    uint32 `$INSTANCE_NAME`_ReadCRCLower(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadCRCLower")`
    {
        uint32 seed;

        /* Read CRC Lower */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_LOWER_B__A1_REG) << 24u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG) << 16u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_LOWER_A__A1_REG) << 24u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG) << 16u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG;

        #else                                           /* 64 bits CRC */
            seed = ((uint32) `$INSTANCE_NAME`_SEED_LOWER_D__A0_REG) << 24u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG) << 16u;
            seed |= ((uint32) `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG) << 8u;
            seed |= `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG;

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        return seed;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WriteSeedUpper
    ********************************************************************************
    *
    * Summary:
    *  Writes upper half of seed value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  seed:  Upper half of seed value.
    *
    * Return:
    *  void
    *
    * Side Effects:
    *  The upper half of seed value is cut according to
    *  mask = 2^(Resolution - 32) - 1.
    *  For example if CRC Resolution is 35 bits the mask value is:
    *  2^(35 - 32) - 1 = 2^(3) - 1 = 0x0000 0007u.
    *  The upper half of seed value = 0x0000 00FFu is cut:
    *  upper half of seed & mask = 0x0000 00FFu & 0x0000 0007u = 0x0000 0007u.
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WriteSeedUpper(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_WriteSeedUpper")`
    {
        /* Mask the Seed Upper half to cut unused bits in case, when CRC size is not byte-aligned or equal 24 */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            seed &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Write Seed Upper */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)        /* 56 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG = HI8(seed);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_SEED_UPPER_D__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_C__A1_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_UPPER_B__A1_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_UPPER_A__A1_REG = LO8(seed);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        /* Resets triggers */
        `$INSTANCE_NAME`_EXECUTE_DFF_RESET;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WriteSeedLower
    ********************************************************************************
    *
    * Summary:
    *  Writes lower half of seed value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  seed:  Lower half of seed value.
    *
    * Return:
    *  void
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WriteSeedLower(uint32 seed) `=ReentrantKeil($INSTANCE_NAME . "_WriteSeedLower")`
    {
        /* Write Seed Lower */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_B__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG = LO8(seed);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_A__A1_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG = LO8(seed);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_SEED_LOWER_D__A0_REG = HI8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_C__A0_REG = LO8(HI16(seed));
            `$INSTANCE_NAME`_SEED_LOWER_B__A0_REG = HI8(seed);
            `$INSTANCE_NAME`_SEED_LOWER_A__A0_REG = LO8(seed);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        /* Resets triggers */
        `$INSTANCE_NAME`_EXECUTE_DFF_RESET;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_ReadPolynomialUpper
    ********************************************************************************
    *
    * Summary:
    *  Reads upper half of CRC polynomial value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns upper half of CRC polynomial value.
    *
    *******************************************************************************/
    uint32 `$INSTANCE_NAME`_ReadPolynomialUpper(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomialUpper")`
    {
        uint32 polynomial;

        /* Read Polynomial Upper */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            polynomial = `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)        /* 56 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG) << 16u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG;

        #else                                           /* 64 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG) << 24u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG) << 16u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_UPPER_A__D1_REG;

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        return polynomial;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_ReadPolynomialLower
    ********************************************************************************
    *
    * Summary:
    *  Reads lower half of CRC polynomial value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  void
    *
    * Return:
    *  Returns lower half of CRC polynomial value.
    *
    *******************************************************************************/
    uint32 `$INSTANCE_NAME`_ReadPolynomialLower(void) `=ReentrantKeil($INSTANCE_NAME . "_ReadPolynomialLower")`
    {
        uint32 polynomial;

        /* Read Polynomial Lower */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_B__D1_REG) << 24u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG) << 16u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG;

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_A__D1_REG) << 24u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG) << 16u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG;

        #else                                           /* 64 bits CRC */
            polynomial =  ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_REG) << 24u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG) << 16u;
            polynomial |= ((uint32) `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG) << 8u;
            polynomial |= `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG;

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        return polynomial;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WritePolynomialUpper
    ********************************************************************************
    *
    * Summary:
    *  Writes upper half of CRC polynomial value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  polynomial:  Upper half CRC polynomial value.
    *
    * Return:
    *  void
    *
    * Side Effects:
    *  The upper half of polynomial value is cut according to
    *  mask = 2^(Resolution - 32) - 1.
    *  For example if CRC Resolution is 35 bits the mask value is:
    *  2^(35 - 32) - 1 = 2^(3) - 1 = 0x0000 0007u.
    *  The upper half of polynomial value = 0x0000 00FFu is cut:
    *  upper half of polynomial & mask = 0x0000 00FFu & 0x0000 0007u = 0x0000 0007u.
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WritePolynomialUpper(uint32 polynomial)
                                                `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomialUpper")`
    {
        /* Mask the polynomial upper half to cut unused bits in case, when CRC size is not byte-aligned or equal 24 */
        #if((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u))
            polynomial &= `$INSTANCE_NAME`_MASK;
        #endif /* ((0u != (`$INSTANCE_NAME`_CRC_SIZE % 8u)) || (`$INSTANCE_NAME`_CRC_SIZE == 24u)) */

        /* Write Polynomial Upper */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG = LO8(polynomial);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG = LO8(polynomial);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 56u)        /* 56 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG = LO8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG = LO8(polynomial);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_UPPER_D__D1_REG = HI8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_UPPER_C__D1_REG = LO8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_UPPER_B__D1_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_UPPER_A__D1_REG = LO8(polynomial);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        /* Resets triggers */
        `$INSTANCE_NAME`_EXECUTE_DFF_RESET;
    }


    /*******************************************************************************
    * Function Name: `$INSTANCE_NAME`_WritePolynomialLower
    ********************************************************************************
    *
    * Summary:
    *  Writes lower half of CRC polynomial value. Only generated for 33-64-bit CRC.
    *
    * Parameters:
    *  polynomial:  Lower half of CRC polynomial value.
    *
    * Return:
    *  void
    *
    *******************************************************************************/
    void `$INSTANCE_NAME`_WritePolynomialLower(uint32 polynomial)
                                                `=ReentrantKeil($INSTANCE_NAME . "_WritePolynomialLower")`
    {
        /* Write Polynomial Lower */
        #if (`$INSTANCE_NAME`_CRC_SIZE <= 40u)          /* 40 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_LOWER_B__D1_REG = HI8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG = LO8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG = LO8(polynomial);

        #elif (`$INSTANCE_NAME`_CRC_SIZE <= 48u)        /* 48 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_LOWER_A__D1_REG = HI8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG = LO8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG = LO8(polynomial);

        #else                                           /* 64 bits CRC */
            `$INSTANCE_NAME`_POLYNOM_LOWER_D__D0_REG = HI8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_C__D0_REG = LO8(HI16(polynomial));
            `$INSTANCE_NAME`_POLYNOM_LOWER_B__D0_REG = HI8(polynomial);
            `$INSTANCE_NAME`_POLYNOM_LOWER_A__D0_REG = LO8(polynomial);

        #endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */

        /* Resets triggers */
        `$INSTANCE_NAME`_EXECUTE_DFF_RESET;
    }
#endif  /* End (`$INSTANCE_NAME`_CRC_SIZE <= 32u) */


/* [] END OF FILE */

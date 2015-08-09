/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#include <project.h>
#include "SPIS_HUB.h"

#define NO_UART

int main()
{
    uint8 rxdata[64];
    uint8 length;
    
    CyGlobalIntEnable; /* Enable global interrupts. */
	SPIS_HUB_Init();
	#ifndef NO_UART
	UART_1_Start();
	UART_2_Start();
	UART_3_Start();
	UART_4_Start();
	#endif

    for(;;)
    {
		if(SPIS_HUB_GetRxBuffer(rxdata,&length) == CYRET_SUCCESS)
        {
            SPIS_HUB_SetTxBuffer(rxdata,length);
        }
    }
}

/* [] END OF FILE */

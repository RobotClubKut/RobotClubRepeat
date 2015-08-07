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
#include "SPIS_HUB.h"
#include <string.h>

enum spisRxStatus g_spisRxStatus;
enum spisTxStatus g_spisTxStatus;
enum spisIntStage g_spisIntStage;
cystatus g_spisRxReceiveStatus;
cystatus g_spisTxTransStatus;

uint8 g_spisTxBuffer[256];
uint8 g_spisRxBuffer[256];


CY_ISR(spis_rx_interrupt)
{
	uint8 getData = SPIS_ReadByte();
	if(g_spisIntStage == SPIS_HUB_STAGE_SYNC)
	{
		// receive
		if(getData == SOH)
		{
			if(g_spisRxReceiveStatus == CYRET_STARTED)
			{
				
			}
			else
			{
				
			}
		}
		// trans
		else if(getData == ENQ)
		{
			if(g_spisTxTransStatus == CYRET_STARTED)
			{
				
			}
			else
			{
				
			}
		}
	}
	else if(g_spisIntStage == SPIS_HUB_STAGE_READ_DATA)
	{
		
	}
	else if(g_spisIntStage == SPIS_HUB_STAGE_READ_END)
	{
		
	}
}

void SPIS_HUB_Init()
{
	g_spisIntStage = SPIS_HUB_STAGE_NONE;
	//g_spisRxStatus = 
	g_spisTxStatus = SPIS_HUB_STS_FIFO_EMPTY;
	SPIS_Start();
	SPIS_EnableRxInt();
	SPIS_rx_isr_StartEx(spis_rx_interrupt);
}

cystatus SPIS_HUB_SetTxBuffer(uint8* txData,uint16 length)
{
	if((g_spisTxTransStatus != CYRET_FINISHED)
		|| (g_spisRxReceiveStatus != CYRET_FINISHED)){
		return CYRET_STARTED;
	}
	if((txData == NULL) 
		|| (length > 255)){
		return CYRET_BAD_PARAM;
	}
		
	strncpy(g_spisTxBuffer,txData,length);
	g_spisTxTransStatus = CYRET_STARTED;
	g_spisTxStatus = SPIS_HUB_STS_FIFO_FULL;
	g_spisIntStage = SPIS_HUB_STAGE_SYNC;
}

cystatus SPIS_HUB_GetRxBuffer(uint8* txData,uint16 length)
{
	
}

enum spisRxStatus SPIS_HUB_ReadRxStatus()
{
	return g_spisRxStatus;
}

enum spisTxStatus SPIS_HUB_ReadTxStatus()
{
	return g_spisTxStatus;
}

/* [] END OF FILE */

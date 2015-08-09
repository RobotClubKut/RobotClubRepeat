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

const uint8 SYNC_ACK[3] = {SYN,ACK,0};
const uint8 SYNC_NAK[3] = {SYN,NAK,0};
const uint8 END_ETB[3]  = {ETB,ETB,0};

volatile enum spisRxStatus g_spisRxStatus;
volatile enum spisTxStatus g_spisTxStatus;
volatile enum spisIntStage g_spisIntStage;
volatile cystatus g_spisRxReceiveStatus;
volatile cystatus g_spisTxTransStatus;

volatile uint8 g_spisTxBuffer[256];
volatile uint8 g_spisRxBuffer[256];

volatile uint8 g_spisTxLength;
volatile uint8 g_spisTxCount;

volatile uint8 g_spisRxLength;
volatile uint8 g_spisRxCount;

CY_ISR(spis_rx_interrupt)
{
	uint8 getData = SPIS_ReadByte();
    if(g_spisIntStage == SPIS_HUB_STAGE_NONE)
    {
        if((getData == SOH) || (getData == ENQ))
        {
            g_spisIntStage = SPIS_HUB_STAGE_SYNC;
        }
    }
	if(g_spisIntStage == SPIS_HUB_STAGE_SYNC)
	{
		// receive
		if(getData == SOH)
		{
			if(g_spisRxReceiveStatus == CYRET_STARTED)
			{
				SPIS_PutArray(SYNC_ACK,sizeof(SYNC_ACK));
                g_spisIntStage = SPIS_HUB_STAGE_READ_DATA;
                g_spisRxLength = 0;
                g_spisRxCount = 0;
			}
			else
			{
				SPIS_PutArray(SYNC_NAK,sizeof(SYNC_NAK));
                g_spisIntStage = SPIS_HUB_STAGE_NONE;
			}
		}
		// trans
		else if(getData == ENQ)
		{
			if(g_spisTxTransStatus == CYRET_STARTED)
			{
				SPIS_PutArray(SYNC_ACK,sizeof(SYNC_ACK));
                SPIS_WriteTxData(g_spisTxLength);
                SPIS_PutArray(g_spisTxBuffer,g_spisTxLength);
                SPIS_PutArray(END_ETB,sizeof(END_ETB));
                g_spisIntStage = SPIS_HUB_STAGE_WRITE_END;
                g_spisTxCount = 0;
			}
			else
			{
				SPIS_PutArray(SYNC_NAK,sizeof(SYNC_NAK));
                g_spisIntStage = SPIS_HUB_STAGE_NONE;
			}
		}
	}
	else if(g_spisIntStage == SPIS_HUB_STAGE_READ_DATA)
	{
        SPIS_WriteTxData(0);
		if((getData != SOH) && (g_spisRxLength == 0))
        {
            g_spisRxLength = getData;
        }
        else
        {
            g_spisRxBuffer[g_spisRxCount] = getData;
            if(g_spisRxCount < g_spisRxLength)
            {
                g_spisRxCount++;
            }
            else
            {
                g_spisIntStage = SPIS_HUB_STAGE_READ_END;
            }
        }
	}
	else if(g_spisIntStage == SPIS_HUB_STAGE_READ_END)
	{
		if(getData == ETB)
        {
            // sumcheck
            SPIS_WriteTxData(EOT);
        }
        else
        {
            // errar status
        }
        g_spisRxReceiveStatus = CYRET_FINISHED;
        g_spisIntStage = SPIS_HUB_STAGE_NONE;
	}
    else if(g_spisIntStage == SPIS_HUB_STAGE_WRITE_END)
    {
        if(g_spisTxCount < g_spisTxLength+4)
        {
            g_spisTxCount++;
        }
        else
        {
            if(getData == EOT)
            {
                
            }
            else if(getData == CAN)
            {
                //error
            }
            else
            {
                //error
            }
            g_spisIntStage = SPIS_HUB_STAGE_NONE;
            g_spisTxTransStatus = CYRET_FINISHED;
        }
    }
}

void SPIS_HUB_Init()
{
	g_spisIntStage = SPIS_HUB_STAGE_NONE;
	g_spisRxStatus = SPIS_HUB_STS_RX_FIFO_EMPTY;
	g_spisTxStatus = SPIS_HUB_STS_TX_FIFO_EMPTY;
    g_spisRxReceiveStatus = CYRET_STARTED;
    g_spisTxTransStatus = CYRET_FINISHED;
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
	SPIS_ClearTxBuffer();
    SPIS_ClearRxBuffer();
    //SPIS_ClearFIFO();
    
    g_spisTxLength = length;
	strncpy(g_spisTxBuffer,txData,length);
	g_spisTxTransStatus = CYRET_STARTED;
	g_spisTxStatus = SPIS_HUB_STS_TX_FIFO_FULL;
	g_spisIntStage = SPIS_HUB_STAGE_SYNC;
    return CYRET_SUCCESS;
}

cystatus SPIS_HUB_GetRxBuffer(uint8* rxData,uint8* length)
{
	if(g_spisRxReceiveStatus != CYRET_FINISHED){
		return CYRET_STARTED;
	}
	if((rxData == NULL) 
		|| (length == NULL)){
		return CYRET_BAD_PARAM;
	}
    *length = g_spisRxLength;
    strncpy(rxData,g_spisRxBuffer,g_spisRxLength);
    
    g_spisRxReceiveStatus = CYRET_STARTED;
	g_spisRxStatus = SPIS_HUB_STS_RX_FIFO_EMPTY;
    g_spisIntStage = SPIS_HUB_STAGE_NONE;
    return CYRET_SUCCESS;
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

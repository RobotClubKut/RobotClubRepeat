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
#ifndef SPIS_HUB_H
#define SPIS_HUB_H
#include <project.h>

enum spisRxStatus 
{
	SPIS_RX_SEND_DATA	
};
	
enum spisTxStatus 
{
	SPIS_HUB_STS_FIFO_FULL,	
	SPIS_HUB_STS_FIFO_EMPTY
};
enum spisIntStage
{
	SPIS_HUB_STAGE_NONE,
	SPIS_HUB_STAGE_SYNC,
	SPIS_HUB_STAGE_READ_DATA,
	SPIS_HUB_STAGE_WRITE_DATA,
	SPIS_HUB_STAGE_READ_END,
	SPIS_HUB_STAGE_WRITE_END
};
enum ASCII
{
	SOH = 0x01,
	EOT = 0x04,
	ENQ = 0x05,
	ACK = 0x06,
	NAK = 0x15,
	SYN = 0x16,
	ETB = 0x17,
	CAN = 0x18
}
CY_ISR_PROT(spis_rx_interrupt);
void SPIS_HUB_Init(void);
cystatus SPIS_HUB_SetTxBuffer(uint8*,uint16);
cystatus SPIS_HUB_SetTxBuffer(uint8*,uint16);
enum spisRxStatus SPIS_HUB_ReadRxStatus(void);
enum spisTxStatus SPIS_HUB_ReadTxStatus(void);

#endif
/* [] END OF FILE */

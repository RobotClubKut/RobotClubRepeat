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
#include <stdio.h>
#include <string.h>

#define CRC_SIZE (CRC_TX_1_CRC_SIZE >> 3)
#define LEN_SIZE 1
#define DATA_SIZE 256
#define BUF_SIZE (LEN_SIZE + DATA_SIZE + CRC_SIZE)

typedef uint8 uart_buf[BUF_SIZE];

cystatus DMA_TX1_Start();
cystatus DMA_TX1_Send(uart_buf buf);
cystatus DMA_TX1_PutStr(char *str);

CY_ISR_PROTO(isr_tx1);

uint16 old_crc, crc_end;

uint8 flag = 0;

int main()
{
	uint16 i = 0;
	uint8 t = 0;
	char str[256];
	DMA_UART_1_Start();
	CRC_TX_1_Start();
	DMA_TX1_Start();
	isr_tx_1_StartEx(isr_tx1);
    CyGlobalIntEnable;

    for(;;)
    {
		flag = 0;
		sprintf(str, "Hello wold %x\n", i);
		t ^= 1;
		DMA_TX1_PutStr(str);
		while (!flag);
		sprintf(str, "CRC: %4x %4x\n", old_crc, crc_end);
		DMA_TX1_PutStr(str);
		CyDelay(1000);
		if (t == 0)
			++i;
    }
	
	
}


/* Variable declarations for DMA_TX_1 */
/* Move these variable declarations to the top of the function */
uint8 DMA_TX_1_Chan;
uint8 DMA_TX_1_TD[1];

/* DMA Configuration for DMA_TX_1 */
#define DMA_TX_1_BYTES_PER_BURST 1
#define DMA_TX_1_REQUEST_PER_BURST 1
#define DMA_TX_1_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_TX_1_DST_BASE (CYDEV_SRAM_BASE)

cystatus DMA_TX1_Start()
{
	DMA_TX_1_Chan = DMA_TX_1_DmaInitialize(DMA_TX_1_BYTES_PER_BURST, DMA_TX_1_REQUEST_PER_BURST, 
	    HI16(DMA_TX_1_SRC_BASE), HI16(DMA_TX_1_DST_BASE));
	if (DMA_TX_1_Chan == DMA_INVALID_CHANNEL)
		return CYRET_LOCKED;
	
	DMA_TX_1_TD[0] = CyDmaTdAllocate();
	if (DMA_TX_1_TD[0] == DMA_INVALID_TD)
		return CYRET_LOCKED;
	
	return CyDmaChSetInitialTd(DMA_TX_1_Chan, DMA_TX_1_TD[0]);
}

uart_buf tx1;

cystatus DMA_TX1_Send(uart_buf buf)
{
	cystatus sts;
	if (buf == NULL)
		return CYRET_BAD_PARAM;
	
	//DMA_UART_1_SendBreak(DMA_UART_1_SEND_BREAK);
	
	sts = CyDmaTdSetConfiguration(DMA_TX_1_TD[0], LEN_SIZE + buf[0] + 1, CY_DMA_DISABLE_TD, DMA_TX_1__TD_TERMOUT_EN | TD_INC_SRC_ADR);
	if (sts == CYRET_SUCCESS)
		sts = CyDmaTdSetAddress(DMA_TX_1_TD[0], LO16((uint32)buf), LO16((uint32)DMA_UART_1_TXDATA_PTR));
	
	//DMA_UART_1_SendBreak(DMA_UART_1_WAIT_FOR_COMPLETE_REINIT);
	CRC_TX_1_Init();
	
	if (sts == CYRET_SUCCESS)
		sts = CyDmaChEnable(DMA_TX_1_Chan, 0);
	
	return sts;
}

cystatus DMA_TX1_PutStr(char *str)
{
	size_t len;
	if (str == NULL)
		return CYRET_BAD_PARAM;
	
	len = strlen(str);
	if (len > DATA_SIZE)
		return CYRET_BAD_PARAM;
	
	
	tx1[0] = len - 1; // index shift
	strcpy((char *)(tx1 + LEN_SIZE), str);
	return DMA_TX1_Send(tx1);
	
}

CY_ISR(isr_tx1)
{
	uint16 crc = CRC_TX_1_ReadCRC();
	Control_Reg_1_Write(((uint8 *)&crc)[0]);
	DMA_UART_1_WriteTxData(((uint8 *)&old_crc)[0] = Status_Reg_1_Read());
	Control_Reg_1_Write(((uint8 *)&crc)[1]);
	DMA_UART_1_ReadTxStatus();
	DMA_UART_1_WriteTxData(((uint8 *)&old_crc)[1] = Status_Reg_1_Read());
	while (!(DMA_UART_1_ReadTxStatus() & DMA_UART_1_TX_STS_COMPLETE));
	crc_end = CRC_TX_1_ReadCRC();
	flag = 1;
}


/* [] END OF FILE */

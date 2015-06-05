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

char tx_buf[11] = "123456789\n";
char rx_buf[11] = "abcdefghi\n";

/* Variable declarations for DMA_1 */
/* Move these variable declarations to the top of the function */
uint8 DMA_1_Chan;
uint8 DMA_1_TD[1];

/* DMA Configuration for DMA_1 */
#define DMA_1_BYTES_PER_BURST 1
#define DMA_1_REQUEST_PER_BURST 1
#define DMA_1_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_1_DST_BASE (CYDEV_SRAM_BASE)

int main()
{

	UART_1_Start();
	
	DMA_1_Chan = DMA_1_DmaInitialize(DMA_1_BYTES_PER_BURST, DMA_1_REQUEST_PER_BURST, 
	    HI16(DMA_1_SRC_BASE), HI16(DMA_1_DST_BASE));
	DMA_1_TD[0] = CyDmaTdAllocate();
	CyDmaTdSetConfiguration(DMA_1_TD[0], 10, CY_DMA_DISABLE_TD, TD_INC_SRC_ADR);
	CyDmaTdSetAddress(DMA_1_TD[0], LO16((uint32)tx_buf), LO16((uint32)&UART_1_TXDATA_REG));
	CyDmaChSetInitialTd(DMA_1_Chan, DMA_1_TD[0]);
	CyDmaChEnable(DMA_1_Chan, 1);
	
	//CyGlobalIntEnable;

	for(;;)
	{
		CyDelay(1000);
		CyDmaTdSetAddress(DMA_1_TD[0], LO16((uint32)rx_buf), LO16((uint32)&UART_1_TXDATA_REG));
		CyDmaChEnable(DMA_1_Chan, 1);
		CyDelay(1000);
		CyDmaTdSetAddress(DMA_1_TD[0], LO16((uint32)tx_buf), LO16((uint32)&UART_1_TXDATA_REG));
		CyDmaChEnable(DMA_1_Chan, 1);
	}
}
/* [] END OF FILE */

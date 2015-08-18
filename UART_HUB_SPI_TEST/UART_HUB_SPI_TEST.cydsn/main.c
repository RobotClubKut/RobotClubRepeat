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

#define DMA_SPIS_RX_BYTES_PER_BURST 1
#define DMA_SPIS_RX_REQUEST_PER_BURST 0
#define DMA_SPIS_RX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_SPIS_RX_DST_BASE (CYDEV_SRAM_BASE)
uint8 DMA_SPIS_RX_Chan;
uint8 DMA_SPIS_RX_TD[3];


uint8 rxCheck;
uint8 rxLength = 1;
uint8 rxBuffer[8];


void DmaRxConfiguration(){
    DMA_SPIS_RX_Chan = DMA_SPIS_RX_DmaInitialize(DMA_SPIS_RX_BYTES_PER_BURST, DMA_SPIS_RX_REQUEST_PER_BURST, 
        HI16(DMA_SPIS_RX_SRC_BASE), HI16(DMA_SPIS_RX_DST_BASE));
    DMA_SPIS_RX_TD[0] = CyDmaTdAllocate();
    DMA_SPIS_RX_TD[1] = CyDmaTdAllocate();
    DMA_SPIS_RX_TD[2] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[0], 1, DMA_SPIS_RX_TD[0], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[1], rxLength, DMA_SPIS_RX_TD[2], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[2], 1, DMA_SPIS_RX_TD[0], TD_TERMIN_EN | TD_INC_DST_ADR);
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[0], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)rxCheck));
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[1], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)(&CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIS_RX_TD[2]].TD0[0u])));
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[2], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)rxBuffer));
    CyDmaChSetInitialTd(DMA_SPIS_RX_Chan, DMA_SPIS_RX_TD[0]);
}
int main()
{
    uint8 spisTxData[256] = "test123";
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    DmaRxConfiguration();
    SPIS_Start();
    CyDmaChEnable(DMA_SPIS_RX_Chan, 1);
    SPIM_Start();
    SPIM_WriteTxData(7);
    SPIM_PutArray(spisTxData,7);
    SPIM_WriteTxData(0);
    for(;;)
    {
        SPIM_WriteTxData(0);
        /* Place your application code here. */
    }
}

/* [] END OF FILE */

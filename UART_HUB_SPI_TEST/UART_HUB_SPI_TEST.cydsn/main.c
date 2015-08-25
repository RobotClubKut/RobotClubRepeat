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
#include<string.h>

#define DMA_SPIS_RX_BYTES_PER_BURST 1
#define DMA_SPIS_RX_REQUEST_PER_BURST 1
#define DMA_SPIS_RX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_SPIS_RX_DST_BASE (CYDEV_SRAM_BASE)
uint8 DMA_SPIS_RX_Chan;
uint8 DMA_SPIS_RX_TD[3];
uint8 spisRxLength = 1;
uint8 spisRxBuffer[16] = {0};

#define DMA_SPIM_RX_BYTES_PER_BURST 1
#define DMA_SPIM_RX_REQUEST_PER_BURST 1
#define DMA_SPIM_RX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_SPIM_RX_DST_BASE (CYDEV_SRAM_BASE)
uint8 DMA_SPIM_RX_Chan;
uint8 DMA_SPIM_RX_TD[3];
uint8 spimRxLength = 1;
uint8 spimRxBuffer[16] = {0};

#define DMA_SPIM_TX_BYTES_PER_BURST 1
#define DMA_SPIM_TX_REQUEST_PER_BURST 1
#define DMA_SPIM_TX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_SPIM_TX_DST_BASE (CYDEV_SRAM_BASE)

uint8 DMA_SPIM_TX_Chan;
uint8 DMA_SPIM_TX_TD[3];
const uint8 spimTxSync = 0;
uint8 spimTxConfig[2];
uint8 spimTxData[255];

#define DMA_SPIS_TX_BYTES_PER_BURST 1
#define DMA_SPIS_TX_REQUEST_PER_BURST 1
#define DMA_SPIS_TX_SRC_BASE (CYDEV_SRAM_BASE)
#define DMA_SPIS_TX_DST_BASE (CYDEV_SRAM_BASE)

uint8 DMA_SPIS_TX_Chan;
uint8 DMA_SPIS_TX_TD[3];
const uint8 spisTxSync = 0;
uint8 spisTxConfig[2];
uint8 spisTxData[255];

void DMASPIMTxConfiguration(){
	DMA_SPIM_TX_Chan = DMA_SPIM_TX_DmaInitialize(DMA_SPIM_TX_BYTES_PER_BURST, DMA_SPIM_TX_REQUEST_PER_BURST, 
	    HI16(DMA_SPIM_TX_SRC_BASE), HI16(DMA_SPIM_TX_DST_BASE));
	DMA_SPIM_TX_TD[0] = CyDmaTdAllocate();
	DMA_SPIM_TX_TD[1] = CyDmaTdAllocate();
	DMA_SPIM_TX_TD[2] = CyDmaTdAllocate();
	CyDmaTdSetConfiguration(DMA_SPIM_TX_TD[0], 0, DMA_SPIM_TX_TD[1], TD_TERMIN_EN);
	CyDmaTdSetConfiguration(DMA_SPIM_TX_TD[1], 2, DMA_SPIM_TX_TD[2], TD_INC_SRC_ADR);
	CyDmaTdSetConfiguration(DMA_SPIM_TX_TD[2], 8, DMA_SPIM_TX_TD[0], TD_INC_SRC_ADR);
	CyDmaTdSetAddress(DMA_SPIM_TX_TD[0], LO16((uint32)&spimTxSync), LO16((uint32)SPIM_TXDATA_PTR));
	CyDmaTdSetAddress(DMA_SPIM_TX_TD[1], LO16((uint32)spimTxConfig), LO16((uint32)SPIM_TXDATA_PTR));
	CyDmaTdSetAddress(DMA_SPIM_TX_TD[2], LO16((uint32)spimTxData), LO16((uint32)SPIM_TXDATA_PTR));
	CyDmaChSetInitialTd(DMA_SPIM_TX_Chan, DMA_SPIM_TX_TD[0]);
}
void DMASPISTxConfiguration(){
	DMA_SPIS_TX_Chan = DMA_SPIS_TX_DmaInitialize(DMA_SPIS_TX_BYTES_PER_BURST, DMA_SPIS_TX_REQUEST_PER_BURST, 
	    HI16(DMA_SPIS_TX_SRC_BASE), HI16(DMA_SPIS_TX_DST_BASE));
	DMA_SPIS_TX_TD[0] = CyDmaTdAllocate();
	DMA_SPIS_TX_TD[1] = CyDmaTdAllocate();
	DMA_SPIS_TX_TD[2] = CyDmaTdAllocate();
	CyDmaTdSetConfiguration(DMA_SPIS_TX_TD[0], 0, DMA_SPIS_TX_TD[1], TD_TERMIN_EN);
	CyDmaTdSetConfiguration(DMA_SPIS_TX_TD[1], 2, DMA_SPIS_TX_TD[2], TD_INC_SRC_ADR);
	CyDmaTdSetConfiguration(DMA_SPIS_TX_TD[2], 8, DMA_SPIS_TX_TD[0], TD_INC_SRC_ADR);
	CyDmaTdSetAddress(DMA_SPIS_TX_TD[0], LO16((uint32)&spisTxSync), LO16((uint32)SPIS_TXDATA_PTR));
	CyDmaTdSetAddress(DMA_SPIS_TX_TD[1], LO16((uint32)spisTxConfig), LO16((uint32)SPIS_TXDATA_PTR));
	CyDmaTdSetAddress(DMA_SPIS_TX_TD[2], LO16((uint32)spisTxData), LO16((uint32)SPIS_TXDATA_PTR));
	CyDmaChSetInitialTd(DMA_SPIS_TX_Chan, DMA_SPIS_TX_TD[0]);
}

void DmaSPISRxConfiguration(){
    DMA_SPIS_RX_Chan = DMA_SPIS_RX_DmaInitialize(DMA_SPIS_RX_BYTES_PER_BURST, DMA_SPIS_RX_REQUEST_PER_BURST, 
        HI16(DMA_SPIS_RX_SRC_BASE), HI16(DMA_SPIS_RX_DST_BASE));
    DMA_SPIS_RX_TD[0] = CyDmaTdAllocate();
    DMA_SPIS_RX_TD[1] = CyDmaTdAllocate();
    DMA_SPIS_RX_TD[2] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[0], 0, DMA_SPIS_RX_TD[1], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[1], spisRxLength, DMA_SPIS_RX_TD[2], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIS_RX_TD[2], 1, DMA_SPIS_RX_TD[0], TD_TERMIN_EN | TD_INC_DST_ADR);
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[0], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)(&CY_DMA_CH_STRUCT_PTR[DMA_SPIS_RX_Chan].action[0u])));
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[1], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)(&CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIS_RX_TD[2]].TD0[0u])));
    CyDmaTdSetAddress(DMA_SPIS_RX_TD[2], LO16((uint32)SPIS_RXDATA_PTR), LO16((uint32)spisRxBuffer));
    CyDmaChSetInitialTd(DMA_SPIS_RX_Chan, DMA_SPIS_RX_TD[0]);
}
void DmaSPIMRxConfiguration(){
    DMA_SPIM_RX_Chan = DMA_SPIM_RX_DmaInitialize(DMA_SPIM_RX_BYTES_PER_BURST, DMA_SPIM_RX_REQUEST_PER_BURST, 
        HI16(DMA_SPIM_RX_SRC_BASE), HI16(DMA_SPIM_RX_DST_BASE));
    DMA_SPIM_RX_TD[0] = CyDmaTdAllocate();
    DMA_SPIM_RX_TD[1] = CyDmaTdAllocate();
    DMA_SPIM_RX_TD[2] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(DMA_SPIM_RX_TD[0], 0, DMA_SPIM_RX_TD[1], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIM_RX_TD[1], spimRxLength, DMA_SPIM_RX_TD[2], TD_TERMIN_EN);
    CyDmaTdSetConfiguration(DMA_SPIM_RX_TD[2], 1, DMA_SPIM_RX_TD[0], TD_TERMIN_EN | TD_INC_DST_ADR);
    CyDmaTdSetAddress(DMA_SPIM_RX_TD[0], LO16((uint32)SPIM_RXDATA_PTR), LO16((uint32)(&CY_DMA_CH_STRUCT_PTR[DMA_SPIM_RX_Chan].action[0u])));
    CyDmaTdSetAddress(DMA_SPIM_RX_TD[1], LO16((uint32)SPIM_RXDATA_PTR), LO16((uint32)(&CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIM_RX_TD[2]].TD0[0u])));
    CyDmaTdSetAddress(DMA_SPIM_RX_TD[2], LO16((uint32)SPIM_RXDATA_PTR), LO16((uint32)spimRxBuffer));
    CyDmaChSetInitialTd(DMA_SPIM_RX_Chan, DMA_SPIM_RX_TD[0]);
}
int main()
{
    uint8 testData[256] = "test123";
    uint8 testData2[256] = "nyampasu!?";
    uint8 testData3[256] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,'\0'};
	uint8 getSpisRxData[16];
	uint8 getSpimRxData[16];
	uint8 getTD[3];
	uint8 nowTd;
	uint8 state;
	uint16 count;
	uint8 i;
    CyGlobalIntEnable; /* Enable global interrupts. */
	
    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    DmaSPISRxConfiguration();
    DmaSPIMRxConfiguration();
	DMASPISTxConfiguration();
	DMASPIMTxConfiguration();
	SPIM_Start();
    SPIS_Start();
    CyDmaChEnable(DMA_SPIS_RX_Chan, 1);
    CyDmaChEnable(DMA_SPIM_RX_Chan, 1);
	CyDmaChEnable(DMA_SPIS_TX_Chan, 1);
	CyDmaChEnable(DMA_SPIM_TX_Chan, 1);
	
	/*
	for(i = 0;i < 10;i++){
		SPIS_WriteTxData(0);
	}
	SPIS_WriteTxData(CPU_TERM_TD);
	SPIS_WriteTxData(strlen((char*)testData2));
	SPIS_PutArray(testData2,strlen((char*)testData2));
	SPIS_WriteTxData(0);
	
	*/
	//CyDelay(100);
	
	CyDmaChStatus(DMA_SPIS_TX_Chan,&nowTd,NULL);
	if(nowTd == DMA_SPIS_TX_TD[0]){
		spisTxConfig[0] = CPU_TERM_TD;
		spisTxConfig[1] = strlen((char*)testData2);
		CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIS_TX_TD[2]].TD0[0u] = spisTxConfig[1];
		strcpy((char*)spisTxData,(char*)testData2);
		CY_DMA_CH_STRUCT_PTR[DMA_SPIS_TX_Chan].action[0u] = 2;
	}
	
	CyDmaChStatus(DMA_SPIM_TX_Chan,&nowTd,NULL);
	if(nowTd == DMA_SPIM_TX_TD[0]){
		spimTxConfig[0] = CPU_TERM_TD;
		spimTxConfig[1] = strlen((char*)testData);
		CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIM_TX_TD[2]].TD0[0u] = spimTxConfig[1];
		strcpy((char*)spimTxData,(char*)testData);
		CY_DMA_CH_STRUCT_PTR[DMA_SPIM_TX_Chan].action[0u] = 2;
	}
	CyDelay(100);
	CyDmaChStatus(DMA_SPIS_TX_Chan,&nowTd,NULL);
	if(nowTd == DMA_SPIS_TX_TD[0]){
		spisTxConfig[0] = CPU_TERM_TD;
		spisTxConfig[1] = strlen((char*)testData3);
		CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIS_TX_TD[2]].TD0[0u] = spisTxConfig[1];
		strcpy((char*)spisTxData,(char*)testData3);
		CY_DMA_CH_STRUCT_PTR[DMA_SPIS_TX_Chan].action[0u] = 2;
	}
	CyDelay(100);
    for(;;)
    {		
		count = CY_DMA_TDMEM_STRUCT_PTR[DMA_SPIS_RX_TD[2]].TD0[0u];
		CyDmaChStatus(DMA_SPIS_RX_Chan,getTD,&state);
		strcpy((char*)getSpimRxData,(char*)spimRxBuffer);
		strcpy((char*)getSpisRxData,(char*)spisRxBuffer);
		
        /* Place your application code here. */
    }
}

/* [] END OF FILE */

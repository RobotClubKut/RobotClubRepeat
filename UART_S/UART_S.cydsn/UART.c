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

#include "UART.h"

DMA_TX_REPEAT(CYDATA uint8, Chan, = 0)
DMA_TX_REPEAT(CYDATA uint8, TD[1], = {0})

#define FUNC(com, f, n) (void) {\
	COM_NAME(com, Chan, n) = COM_NAME(com, DmaInitialize, n)(1, 1, HI16(CYDEV_SRAM_BASE), HI16(CYDEV_SRAM_BASE));\
	COM_NAME(com, TD[0], n) = CyDmaTdAllocate();\
	CyDmaChSetInitialTd(COM_NAME(com, Chan, n), COM_NAME(com, TD[0], n));\
}
DMA_TX_REPEAT_ARG(void, Init, FUNC)
#undef FUNC

#define FUNC(com, f, n) (uint8 *src, uint8 *dest, uint8 len) {\
	CyDmaTdSetConfiguration(COM_NAME(com, TD[0], n), len, CY_DMA_DISABLE_TD, COM_NAME(com, _TD_TERMOUT_EN, n) | TD_INC_SRC_ADR | TD_INC_DST_ADR);\
	CyDmaTdSetAddress(COM_NAME(com, TD[0], n), LO16((uint32)src), LO16((uint32)dest));\
	CyDmaChEnable(COM_NAME(com, Chan, n), 1);\
}
DMA_TX_REPEAT_ARG(void, Start, FUNC)
#undef FUNC


DMA_RX_REPEAT(CYDATA uint8, Chan, = 0)
DMA_RX_REPEAT(CYDATA uint8, TD[2], = {0})

#define FUNC(com, f, n) (void) {\
	COM_NAME(com, Chan, n) = COM_NAME(com, DmaInitialize, n)(1, 1, HI16(CYDEV_SRAM_BASE), HI16(CYDEV_SRAM_BASE));\
	COM_NAME(com, TD[0], n) = CyDmaTdAllocate();\
	COM_NAME(com, TD[1], n) = CyDmaTdAllocate();\
	CyDmaChSetInitialTd(COM_NAME(com, Chan, n), COM_NAME(com, TD[0], n));\
}
DMA_RX_REPEAT_ARG(void, Init, FUNC)
#undef FUNC

#define FUNC(com, f, n) (uint8 *src, uint8 *dest, uint8 len) {\
	CyDmaTdSetConfiguration(COM_NAME(com, TD[0], n), 1, CY_DMA_DISABLE_TD, COM_NAME(com, _TD_TERMOUT_EN, n) | TD_INC_SRC_ADR | TD_INC_DST_ADR);\
	CyDmaTdSetConfiguration(COM_NAME(com, TD[1], n), len, CY_DMA_DISABLE_TD, COM_NAME(com, _TD_TERMOUT_EN, n) | TD_INC_SRC_ADR | TD_INC_DST_ADR);\
	CyDmaTdSetAddress(COM_NAME(com, TD[0], n), LO16((uint32)src), LO16((uint32)dest));\
	CyDmaChEnable(COM_NAME(com, Chan, n), 1);\
}
DMA_RX_REPEAT_ARG(void, Start, FUNC)
#undef FUNC

void DMA_Start(void)
{
	DMA_RX_REPEAT(, Init, ())
	DMA_TX_REPEAT(, Init, ())
}

void ISR_Start(void)
{
	#define ARG(com, f, n) (COM_NAME(com, func, n));
	ISR_BREAK_REPEAT_ARG(, StartEx, ARG)
	ISR_RX_REPEAT_ARG(, StartEx, ARG)
	ISR_TX_REPEAT_ARG(, StartEx, ARG)
	#undef ARG
}

void UART_Start(void)
{
	UART_REPEAT(, Start, ())
	UART_REPEAT(, SetRxInterruptMode, (UART_0_RX_STS_BREAK))
	UART_REPEAT(, SetTxInterruptMode, (UART_0_TX_STS_FIFO_NOT_FULL))
	UART_REPEAT(, ClearTxBuffer, ())
	UART_REPEAT(, ClearRxBuffer, ())
}

ISR_BREAK_REPEAT(CYBIT, flag, = 0)
ISR_RX_REPEAT(CYBIT, flag, = 0)
ISR_TX_REPEAT(CYBIT, flag, = 0)

#define ISR_GEN_FUNC(z, n, d) \
CY_ISR(COM_NAME(COM_GET_COM d, COM_GET_FUNC d, n)) {\
	COM_NAME(COM_GET_COM d, COM_GET_ARG d, n) = 1;\
}

BOOST_PP_REPEAT(NUM_UART, ISR_GEN_FUNC, (isr_break, func, flag))
BOOST_PP_REPEAT(NUM_UART, ISR_GEN_FUNC, (isr_rx, func, flag))
BOOST_PP_REPEAT(NUM_UART, ISR_GEN_FUNC, (isr_tx, func, flag))

/* [] END OF FILE */

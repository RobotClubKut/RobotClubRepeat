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

#ifndef UART_H
#define UART_H

#include <project.h>
#include "generate.h"

#define NUM_UART 3

#define UART_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, UART, func, ret, arg)
#define UART_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, UART, func, ret, arg)

#define ISR_BREAK_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, isr_break, func, ret, arg)
#define ISR_BREAK_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, isr_break, func, ret, arg)

#define ISR_RX_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, isr_rx, func, ret, arg)
#define ISR_RX_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, isr_rx, func, ret, arg)

#define ISR_TX_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, isr_tx, func, ret, arg)
#define ISR_TX_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, isr_tx, func, ret, arg)

#define DMA_RX_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, DMA_RX, func, ret, arg)
#define DMA_RX_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, DMA_RX, func, ret, arg)

#define DMA_TX_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, DMA_TX, func, ret, arg)
#define DMA_TX_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, DMA_TX, func, ret, arg)

#define LED_REPEAT(ret, func, arg) COM_REPEAT(NUM_UART, LED, func, ret, arg)
#define LED_REPEAT_ARG(ret, func, arg) COM_REPEAT_ARG(NUM_UART, LED, func, ret, arg)

ISR_BREAK_REPEAT(void, func, (void))
ISR_RX_REPEAT(void, func, (void))
ISR_TX_REPEAT(void, func, (void))

void ISR_Start(void);

void UART_Start(void);

void DMA_Start(void);

ISR_BREAK_REPEAT(extern CYBIT, flag,)
ISR_RX_REPEAT(extern CYBIT, flag,)
ISR_TX_REPEAT(extern CYBIT, flag,)

#endif // UART_H

/* [] END OF FILE */

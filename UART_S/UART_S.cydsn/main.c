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
#include "generate.h"
#include "UART.h"

int main()
{
    CyGlobalIntEnable;

	DMA_Start();
	ISR_Start();
	UART_Start();
	
	for (;;)
	{
		#define ISR_IF(com, f, n) {\
			COM_NAME(com, f, n) = 0;\
			COM_NAME(UART, ClearRxBuffer, n)();\
			COM_NAME(UART, ReadRxStatus, n)();\
			continue;\
		}
		ISR_BREAK_REPEAT_ARG(if, flag, ISR_IF)
		#undef ISR_IF

		#define ISR_IF(com, f, n) {\
			COM_NAME(com, f, n) = 0;\
			continue;\
		}
		ISR_RX_REPEAT_ARG(if, flag, ISR_IF)
		#undef ISR_IF

		#define ISR_IF(com, f, n) {\
			COM_NAME(com, f, n) = 0;\
			continue;\
		}
		ISR_TX_REPEAT_ARG(if, flag, ISR_IF)
		#undef ISR_IF
    }
}



/* [] END OF FILE */

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

#include "UART_Debug.h"
#include <stdio.h>

char* uart_receive()
{
	static char buf[RX_BUFF_SIZE];
	static uint8 line = 0, pbuf = 0;
	static struct {
		uint8 n : 1;
		uint8 r : 1;
	} flag = {1, 0};
	uint8 ch;
	
	if (flag.n == 1)
	{
		char str[8];
		sprintf(str, "%3d: ", (uint16)line++);
		UART_PutString(str);
		flag.n = 0;
	}
	
	while ((ch = UART_GetChar()) != 0)
	{
		if (flag.r == 1 && ch == '\n')
			continue;
		
		flag.r = 0;
		
		if ((ch >= ' ' && ch <= '~') && pbuf < RX_BUFF_SIZE - 1)
		{
			UART_PutChar(ch);			buf[pbuf++] = ch;
		}
		else if ((ch == '\r' || ch == '\n') && pbuf != 0)
		{
			if (ch == '\r')
				flag.r = 1;
			UART_PutChar('\n');
			pbuf = buf[pbuf] = 0;
			flag.n = 1;
			return buf;
		}
		else if (ch == '\b' && pbuf > 0)
		{
			UART_PutString("\b \b");
			--pbuf;
		}
		else
			UART_PutChar('\a');
	}
	return NULL;
}

/* [] END OF FILE */

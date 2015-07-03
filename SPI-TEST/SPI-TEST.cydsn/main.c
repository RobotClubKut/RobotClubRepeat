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
#include "UART_Debug.h"

#define ESC 0x1b
const char cls[] = {ESC, 'c', 0};

int main()
{
    CyGlobalIntEnable;
	
	UART_Start();
	UART_PutString("\n   Hello, PSoC3 Start\n");
	
	SPIM_Start();
	SPIS_1_Start();
	SPIS_2_Start();
	
    for(;;)
    {
		char *str = uart_receive();
		if (str != NULL)
		{
			UART_PutString("    cmd: ");
			UART_PutString(str);
			UART_PutString("\n");
			if (strcmp(str, "cls") == 0)
			{
				UART_PutString(cls);
				CyDelay(100);
			}
			else if (strncmp(str, "spim", 4) == 0)
			{
				size_t len;
				char *ch, *send;
				if (
					(ch = strtok(str + 4, " ")) != NULL 
					&& (ch[0] == '1' || ch[0] == '2')
					&& (send = strtok(NULL, " ")) != NULL
					&& (len = strlen(send)) > 0
				)
				{
					size_t i, ibuf = 0;
					char buf[256];
					if (ch[0] == '1')
						SS_Write(0);
					else if (ch[0] == '2')
						SS_Write(1);
					
					SPIM_PutArray((uint8 *)send, len);
					
					ibuf += sprintf(buf, "\x1b[31mSPIM %c Send: %s, HEX: ", ch[0], send);
					for (i = 0; i < len; ++i)
						ibuf += sprintf(buf + ibuf, "%02x", (uint16)send[i]);
					sprintf(buf + ibuf, "\n\x1b[0m");
					UART_PutString(buf);
				}
			}
			else if (strncmp(str, "spis", 4) == 0)
			{
				size_t len;
				char *ch, *send;
				if (
					(ch = strtok(str + 4, " ")) != NULL 
					&& (ch[0] == '1' || ch[0] == '2')
					&& (send = strtok(NULL, " ")) != NULL
					&& (len = strlen(send)) > 0
				)
				{
					size_t i, ibuf = 0;
					char buf[256];
					
					if (ch[0] == '1')
						SPIS_1_PutArray((uint8 *)send, len);
					else if (ch[0] == '2')
						SPIS_2_PutArray((uint8 *)send, len);
					
					ibuf += sprintf(buf, "%sSPIS %c Send: %s, HEX: ", ch[0] == '1' ? "\x1b[32m" : "\x1b[33m", ch[0], send);
					for (i = 0; i < len; ++i)
						ibuf += sprintf(buf + ibuf, "%02x", (uint16)send[i]);
					sprintf(buf + ibuf, "\n\x1b[0m");
					UART_PutString(buf);
				}
			}
			else if (strcmp(str, "read") == 0)
			{
				size_t i, len, ibuf = 0;
				char buf[256];
				
				ibuf = sprintf(buf, "\x1b[31mSPIM Read: ");
				len = SPIM_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIM_ReadRxData());
				sprintf(buf + ibuf, "\n");
				UART_PutString(buf);
				
				ibuf = sprintf(buf, "\x1b[32mSPIS 1 Read: ");
				len = SPIS_1_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIS_1_ReadRxData());
				sprintf(buf + ibuf, "\n");
				UART_PutString(buf);
				
				ibuf = sprintf(buf, "\x1b[33mSPIS 2 Read: ");
				len = SPIS_2_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIS_2_ReadRxData());
				sprintf(buf + ibuf, "\n\x1b[0m");
				UART_PutString(buf);
			}
		}
    }
}

/* [] END OF FILE */

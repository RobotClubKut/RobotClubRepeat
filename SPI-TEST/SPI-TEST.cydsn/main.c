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
	
	UART_PutString(cls);
	CyDelay(100);
	UART_PutString("   Hello, PSoC3 Start\n");
	
	SPIM_Start();
	SPIS_1_Start();
	SPIS_2_Start();
	
	Counter_1_Start();
	
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
					
					Counter_1_Init();
					Counter_1_Enable();
					Counter_1_WriteCounter(0);
						
					SPIM_PutArray((uint8 *)send, len);
					
					ibuf += sprintf(buf, "SPIM %c Send: %s, HEX: \x1b[31m", ch[0], send);
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
					
					ibuf += sprintf(buf, "SPIS %c Send: %s, HEX: %s", ch[0], send, ch[0] == '1' ? "\x1b[32m" : "\x1b[33m");
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
				
				ibuf = sprintf(buf, "SPIM Read: \x1b[31m");
				len = SPIM_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIM_ReadRxData());
				sprintf(buf + ibuf, "\n\x1b[0m");
				UART_PutString(buf);
				
				ibuf = sprintf(buf, "SPIS 1 Read: \x1b[32m");
				len = SPIS_1_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIS_1_ReadRxData());
				sprintf(buf + ibuf, "\n\x1b[0m");
				UART_PutString(buf);
				
				ibuf = sprintf(buf, "SPIS 2 Read: \x1b[33m");
				len = SPIS_2_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)SPIS_2_ReadRxData());
				sprintf(buf + ibuf, "\n\x1b[0m");
				UART_PutString(buf);
			}
			else
			{
				UART_PutString("\aError\n");
			}
		}
    }
}

/* [] END OF FILE */

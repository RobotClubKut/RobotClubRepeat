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

#define SPIS_START '1'
#define SPIS_END '3'

uint8 (* const SPIS_GetRxBufferSize[])(void) = {SPIS_1_GetRxBufferSize, SPIS_2_GetRxBufferSize, SPIS_3_GetRxBufferSize};
uint8 (* const SPIS_ReadRxData[])(void) = {SPIS_1_ReadRxData, SPIS_2_ReadRxData, SPIS_3_ReadRxData};
void (* const SPIS_PutArray[])(const uint8*, uint8) = {SPIS_1_PutArray, SPIS_2_PutArray, SPIS_3_PutArray};


int main()
{
	UART_Start();
	
	SPIM_Start();
	SPIS_1_Start();
	SPIS_2_Start();
	SPIS_3_Start();
	CyGlobalIntEnable;
	UART_PutString(cls);
	CyDelay(100);
	UART_PutString("   Hello, PSoC3 Start\n");
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
					&& (ch[0] >= SPIS_START && ch[0] <= SPIS_END)
					&& (send = strtok(NULL, " ")) != NULL
					&& (len = strlen(send)) > 0
				)
				{
					size_t i, ibuf;
					char buf[256];
					
					SS_Write(ch[0] - SPIS_START);
					SPIM_PutArray((uint8 *)send, len);
					
					ibuf = sprintf(buf, "\x1b[31mSPIM \x1b[3%cm%c\x1b[0m Send: \x1b[3%cm%s\x1b[0m, HEX: \x1b[3%cm", ch[0] + 1, ch[0], ch[0] + 1, send, ch[0] + 1);
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
					&& (ch[0] >= SPIS_START && ch[0] <= SPIS_END)
					&& (send = strtok(NULL, " ")) != NULL
					&& (len = strlen(send)) > 0
				)
				{
					size_t i, ibuf;
					char buf[256];
					
					ibuf = sprintf(buf, "\x1b[3%cmSPIS %c\x1b[0m Send: \x1b[31m%s\x1b[0m, HEX: \x1b[31m", ch[0] + 1, ch[0], send);
					SPIS_PutArray[ch[0] - SPIS_START]((uint8 *)send, len);
					
					
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
				uint8 buf2[64];
				char c;
				
				ibuf = sprintf(buf, "\x1b[31mSPIM\x1b[0m Read: \x1b[31m");
				len = SPIM_GetRxBufferSize();
				for (i = 0; i < len; ++i)
					buf2[i] = SPIM_ReadRxData();
				for (i = 0; i < len; ++i)
					if (buf2[i] >= ' ' && buf2[i] <= '~')
						ibuf += sprintf(buf + ibuf, "%c", buf2[i]);
					else
						ibuf += sprintf(buf + ibuf, "\\x%02x", (uint16)buf2[i]);
				ibuf += sprintf(buf + ibuf, "\x1b[0m, HEX: \x1b[31m");
				for (i = 0; i < len; ++i)
					ibuf += sprintf(buf + ibuf, "%02x", (uint16)buf2[i]);
			
				sprintf(buf + ibuf, "\n\x1b[0m");
				UART_PutString(buf);
				
				for (c = SPIS_START; c <= SPIS_END; ++c)
				{
					ibuf = sprintf(buf, "\x1b[3%cmSPIS %c\x1b[0m Read: \x1b[3%cm", c + 1, c, c + 1);
					len = SPIS_GetRxBufferSize[c - SPIS_START]();
					for (i = 0; i < len; ++i)
						buf2[i] = SPIS_ReadRxData[c - SPIS_START]();
					for (i = 0; i < len; ++i)
						if (buf2[i] >= ' ' && buf2[i] <= '~')
							ibuf += sprintf(buf + ibuf, "%c", buf2[i]);
						else
							ibuf += sprintf(buf + ibuf, "\\x%02x", (uint16)buf2[i]);				
					ibuf += sprintf(buf + ibuf, "\x1b[0m, HEX: \x1b[3%cm", c + 1);
					for (i = 0; i < len; ++i)
						ibuf += sprintf(buf + ibuf, "%02x", (uint16)buf2[i]);
						
					sprintf(buf + ibuf, "\n\x1b[0m");
					UART_PutString(buf);
				}
			}
			else
				UART_PutString("\aError\n");
		}
    }
}

/* [] END OF FILE */
